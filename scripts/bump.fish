#!/usr/bin/env fish
# Point a git-sourced formula at a new upstream tag and commit the change.
#
# Usage: scripts/bump.fish <formula> <tag> [revision]

set -l formula $argv[1]
set -l tag $argv[2]
set -l revision $argv[3]

if test -z "$formula" -o -z "$tag"
    echo "usage: bump.fish <formula> <tag> [revision]" >&2
    exit 1
end

cd (dirname (status filename))/.. || exit 1

if test -n "$(git status --porcelain)"
    echo "tap worktree is dirty" >&2
    exit 1
end

set -l args --write-only --no-audit --tag=$tag
test -n "$revision"; and set -a args --revision=$revision

brew bump-formula-pr $args orkward/tap/$formula; or exit $status
git commit -q -am "$formula "(string replace -r '^v' '' -- $tag)
