#!/usr/bin/env bash
# Deploy the image repo to images.warpedvisions.org via rsync.
# Pass --dry-run to list what would change without touching the server.
#
# A real deploy ships only committed, pushed work: it refuses a dirty tree or
# a HEAD that isn't on origin/main, writes version.txt (`<tag> <short hash>`,
# gitignored), and tags the commit deploy-YYYY-MM-DD (-2, -3 for later ones
# that day). `git log deploy-A..deploy-B` is the changelog.
set -euo pipefail

HOST="w28@w42.warpedvisions.org"
REMOTE_PATH="~/images.warpedvisions.org"
RSYNC_FLAGS=(-avz --delete
  --exclude .git/ --exclude .gitignore --exclude .DS_Store
  --exclude .claude/ --exclude CLAUDE.md --exclude deploy.sh
  --exclude .dh-diag)

cd "$(dirname "$0")"

if [[ "${1:-}" == "--dry-run" ]]; then
  echo "Dry run: . -> ${HOST}:${REMOTE_PATH} (nothing will be changed)"
  [[ -n "$(git status --porcelain)" ]] && echo "warning: uncommitted changes (a real deploy would refuse):" && git status --short
  rsync "${RSYNC_FLAGS[@]}" --dry-run ./ "${HOST}:${REMOTE_PATH}/"
  echo "Dry run complete."
  exit 0
fi

if [[ -n "$(git status --porcelain)" ]]; then
  echo "error: uncommitted changes; commit them before deploying." >&2
  git status --short >&2
  exit 1
fi

git fetch -q origin main
if ! git merge-base --is-ancestor HEAD origin/main; then
  echo "error: HEAD isn't on origin/main; push before deploying." >&2
  exit 1
fi

TAG="deploy-$(date +%F)"
n=1
while git rev-parse -q --verify "refs/tags/$TAG" >/dev/null; do
  n=$((n + 1))
  TAG="deploy-$(date +%F)-$n"
done
printf '%s %s\n' "$TAG" "$(git rev-parse --short HEAD)" > version.txt

echo "Deploying . -> ${HOST}:${REMOTE_PATH} as $TAG"
rsync "${RSYNC_FLAGS[@]}" ./ "${HOST}:${REMOTE_PATH}/"
git tag "$TAG"
git push -q origin "$TAG"
echo "Deploy complete; tagged $TAG. Check https://images.warpedvisions.org/version.txt"
