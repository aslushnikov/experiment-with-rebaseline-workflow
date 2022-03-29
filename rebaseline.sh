#!/bin/bash
set -e
set +x

trap "cd $(pwd -P)" EXIT
cd "$(dirname "$0")"
SCRIPT_PATH=$(pwd -P)

COMMIT_PATH=""
COMMIT_MESSAGE=""

while [[ $# -gt 0 ]]; do
  case $1 in
    --path)
      COMMIT_PATH="$2"
      shift # past argument
      shift # past value
      ;;
    --message)
      COMMIT_MESSAGE="$2"
      shift # past argument
      shift # past value
      ;;
  esac
done

if [[ -z "${COMMIT_MESSAGE}" ]]; then
  echo "ERROR: --message must be passed"
  exit 1
fi

if [[ -z "${COMMIT_PATH}" ]]; then
  echo "ERROR: --path must be passed"
  exit 1
fi

if [[ -z "$(git status --porcelain $COMMIT_PATH)" ]]; then
  echo "Nothing to commit"
  exit 0
fi

if [[ -z "${GITHUB_HEAD_REF}" ]]; then
  echo "FYI: this only updates commits in the Pull Request branch"
  exit 0
fi

git config --global user.name 'Playwright Rebaseline Bot'
git config --global user.email 'playwright-rebaseline-bot@users.noreply.github.com'
git fetch
git checkout "${GITHUB_HEAD_REF}"
git add "${COMMIT_PATH}"
git commit -m "${COMMIT_MESSAGE}"

SHA=$(git rev-parse HEAD)
for i in $(seq 10); do
  echo "Push attempt #i"
  if git push; then
    echo "SUCCESS: Updates pushed"
    exit 0
  fi
  git pull --rebase
  if [[ $(git shortlog -s -n $SHA^.. | wc -l | tr -d ' ') != 1 ]]; then
    echo "ABORTING: someone else pushed to a branch"
    exit 1
  fi
  TIMEOUT=$((i + $RANDOM % 5))
  echo "Sleeping $TIMEOUT seconds before next attempt..."
  sleep $TIMEOUT
done

echo "Updated FAILED"
