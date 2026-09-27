#!/usr/bin/env bash
# PreToolUse hook for Bash: enforce pnpm, and run scripts/check.sh before git commit / push.
# Exit code 2 blocks the command and feeds stderr back to Claude.
set -uo pipefail

cmd="$(jq -r '.tool_input.command // empty')"
root="${CLAUDE_PROJECT_DIR:-$(git rev-parse --show-toplevel)}"

if grep -Eq '(^|[^[:alnum:]_./-])(npm|npx|yarn)([[:space:]]|$)' <<<"$cmd"; then
  echo "This repository uses pnpm. Use pnpm / pnpm dlx instead of npm, npx or yarn." >&2
  exit 2
fi

run_check() {
  if ! out="$("$root/scripts/check.sh" "$1" 2>&1)"; then
    printf 'scripts/check.sh %s failed; fix it before retrying:\n%s\n' "$1" "$out" | tail -n 40 >&2
    exit 2
  fi
}

if grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+push([[:space:]]|$)' <<<"$cmd"; then
  run_check full
elif grep -Eq '(^|[;&|[:space:]])git([[:space:]]+-C[[:space:]]+[^[:space:]]+)?[[:space:]]+commit([[:space:]]|$)' <<<"$cmd"; then
  run_check quick
fi

exit 0
