#!/usr/bin/env bash
# Point a git-sourced formula at a new upstream tag and commit the change.
#
# Usage: scripts/bump.sh <formula> <tag> [revision]
set -euo pipefail

formula="${1:?usage: bump.sh <formula> <tag> [revision]}"
tag="${2:?usage: bump.sh <formula> <tag> [revision]}"
revision="${3:-}"

cd "$(dirname "$0")/.."

if [ -n "$(git status --porcelain)" ]; then
    echo "tap worktree is dirty" >&2
    exit 1
fi

args=(--write-only --no-audit --tag="${tag}")
[ -n "${revision}" ] && args+=(--revision="${revision}")

brew bump-formula-pr "${args[@]}" "orkward/tap/${formula}"
git commit -q -am "${formula} ${tag#v}"
