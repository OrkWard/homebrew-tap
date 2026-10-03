#!/usr/bin/env bash
# Build a bottle for a formula in this tap, publish it to the bottle store and
# commit the updated bottle block.
#
# Usage: scripts/bottle.sh <formula>
set -euo pipefail

formula="${1:?usage: bottle.sh <formula>}"
root="${BOTTLE_ROOT:?BOTTLE_ROOT is not set}"
target="${BOTTLE_TARGET:?BOTTLE_TARGET is not set}"

cd "$(dirname "$0")/.."
tap="orkward/tap/${formula}"

if [ -n "$(git status --porcelain)" ]; then
    echo "tap worktree is dirty; commit the formula change first" >&2
    exit 1
fi

# A bottle can only be poured off a source build.
brew uninstall --ignore-dependencies "${formula}" || true
brew install --build-bottle "${tap}"
brew bottle --json --no-rebuild --root-url="${root}" "${tap}"

shopt -s nullglob
json_files=("${formula}"--*.bottle.json)
if [ ${#json_files[@]} -eq 0 ]; then
    echo "brew bottle produced no JSON" >&2
    exit 1
fi

brew bottle --merge --write --no-commit "${json_files[@]}"

version=""
for built in "${formula}"--*.bottle.tar.gz; do
    # brew names the local file with a double dash; the published object uses
    # a single dash, so rename here rather than inside the bucket.
    published="${built/--/-}"
    mv "${built}" "${published}"
    mc cp "${published}" "${target}/${published}"
    rm -f "${published}"

    if [[ "${built}" =~ ^${formula}--(.+)\.[^.]+\.bottle\.tar\.gz$ ]]; then
        version="${BASH_REMATCH[1]}"
    fi
done

rm -f "${json_files[@]}"

git commit -q -am "${formula}: add ${version} bottle."
git push origin main

# Prove the published bottle is poured cleanly.
brew uninstall --ignore-dependencies "${formula}"
brew install "${tap}"
