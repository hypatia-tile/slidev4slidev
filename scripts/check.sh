#!/usr/bin/env bash
# Shared checks for git hooks (lefthook) and Claude Code hooks.
#   scripts/check.sh quick  - fast checks, run before commit
#   scripts/check.sh full   - quick checks + production build, run before push
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

# Re-enter through the devShell so the pinned Node.js and pnpm are used.
if [ -z "${IN_NIX_SHELL:-}" ]; then
  exec nix develop --command "$0" "$@"
fi

mode="${1:-quick}"

check_src_refs() {
  local missing=0 ref
  for file in slides.md pages/*.md; do
    [ -f "$file" ] || continue
    while IFS= read -r ref; do
      if [ ! -f "$(dirname "$file")/$ref" ]; then
        echo "check: $file references missing file: $ref" >&2
        missing=1
      fi
    done < <(sed -n 's/^src:[[:space:]]*//p' "$file")
  done
  return "$missing"
}

check_lockfile() {
  pnpm install --frozen-lockfile --offline --silent
}

case "$mode" in
  quick)
    check_src_refs
    check_lockfile
    ;;
  full)
    check_src_refs
    check_lockfile
    pnpm build
    ;;
  *)
    echo "usage: $0 [quick|full]" >&2
    exit 64
    ;;
esac
