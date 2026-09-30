#!/usr/bin/env bash
# check-conventional-commit.sh — validate one commit message (Conventional Commits).
# Usage: ./scripts/checks/check-conventional-commit.sh "feat(api): add pagination"
#   or:  git log -1 --pretty=%B | ./scripts/checks/check-conventional-commit.sh
set -euo pipefail
MSG="${1:-$(cat)}"
# first line: type(scope)!?: subject
if ! printf '%s' "$MSG" | head -n1 | grep -Eq '^(feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert)(\([a-z0-9][a-z0-9,/ -]*\))?(!)?: [^ ].+'; then
  echo "FAIL: first line must be '<type>(<scope>)?: <subject>' with type in feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert"
  exit 1
fi
SUBJECT="$(printf '%s' "$MSG" | head -n1 | sed -E 's/^[^:]+: //')"
if [ "${#SUBJECT}" -gt 72 ]; then
  echo "FAIL: subject > 72 chars (${#SUBJECT})"
  exit 1
fi
if printf '%s' "$MSG" | grep -Eq '^BREAKING CHANGE: '; then
  echo "note: breaking change footer detected"
fi
echo "conventional commit valid"
