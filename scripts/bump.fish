#!/usr/bin/env fish
# Update a formula, build and publish its bottle, then commit both changes once.
#
# Usage: scripts/bump.fish <formula> <tag> [revision]
# Set BOTTLE_NO_PUSH to leave publishing the Git commit to the caller.

set -l formula $argv[1]
set -l tag $argv[2]
set -l revision $argv[3]

if test -z "$formula" -o -z "$tag"
    echo "usage: bump.fish <formula> <tag> [revision]" >&2
    exit 1
end

for var in BOTTLE_ROOT BOTTLE_TARGET
    if not set -q $var
        echo "$var is not set; see .env.example" >&2
        exit 1
    end
end

cd (dirname (status filename))/.. || exit 1
set -l tap orkward/tap/$formula

if test -n "$(git status --porcelain --untracked-files=all)"
    echo "tap worktree is dirty" >&2
    exit 1
end

set -l args --write-only --no-audit --tag=$tag
test -n "$revision"; and set -a args --revision=$revision

brew bump-formula-pr $args $tap; or exit $status

# A bottle can only be poured off a source build.
brew uninstall --ignore-dependencies $formula
brew install --build-bottle $tap; or exit $status
brew bottle --json --no-rebuild --root-url=$BOTTLE_ROOT $tap; or exit $status

set -l json_files "$formula"--*.bottle.json

if test (count $json_files) -eq 0
    echo "brew bottle produced no JSON" >&2
    exit 1
end

brew bottle --merge --write --no-commit $json_files; or exit $status

for built in "$formula"--*.bottle.tar.gz
    # brew names the local file with a double dash; the published object uses
    # a single dash, so rename here rather than inside the bucket.
    set -l published (string replace -- -- - $built)
    mv $built $published; or exit $status
    mc cp $published $BOTTLE_TARGET/$published; or exit $status
    rm -f $published
end

rm -f $json_files

git commit -q -am "$formula "(string replace -r '^v' '' -- $tag); or exit $status
if not set -q BOTTLE_NO_PUSH
    git push origin HEAD; or exit $status
end

# Prove the published bottle is poured cleanly.
brew uninstall --ignore-dependencies $formula
brew install $tap
