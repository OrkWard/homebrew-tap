#!/usr/bin/env fish
# Build a bottle for a formula in this tap, publish it to the bottle store and
# commit the updated bottle block.
#
# Usage: scripts/bottle.fish <formula>

set -l formula $argv[1]

if test -z "$formula"
    echo "usage: bottle.fish <formula>" >&2
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

if test -n "$(git status --porcelain)"
    echo "tap worktree is dirty; commit the formula change first" >&2
    exit 1
end

# A bottle can only be poured off a source build.
brew uninstall --ignore-dependencies $formula
brew install --build-bottle $tap; or exit $status
brew bottle --json --no-rebuild --root-url=$BOTTLE_ROOT $tap; or exit $status

set -l pattern (string escape --style=regex -- $formula)--
set -l json_files (fd --max-depth 1 --type f "^$pattern.*\.bottle\.json\$")

if test (count $json_files) -eq 0
    echo "brew bottle produced no JSON" >&2
    exit 1
end

brew bottle --merge --write --no-commit $json_files; or exit $status

set -l version
for built in (fd --max-depth 1 --type f "^$pattern.*\.bottle\.tar\.gz\$")
    # brew names the local file with a double dash; the published object uses
    # a single dash, so rename here rather than inside the bucket.
    set -l published (string replace -- -- - $built)
    mv $built $published; or exit $status
    mc cp $published $BOTTLE_TARGET/$published; or exit $status
    rm -f $published

    set version (string replace -r -- "^$pattern(.+)\.[^.]+\.bottle\.tar\.gz\$" '$1' $built)
end

rm -f $json_files

git commit -q -am "$formula: add $version bottle."; or exit $status
git push origin main; or exit $status

# Prove the published bottle is poured cleanly.
brew uninstall --ignore-dependencies $formula
brew install $tap
