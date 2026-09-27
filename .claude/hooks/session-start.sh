#!/usr/bin/env bash
# SessionStart hook: warn when the session is not inside the Nix devShell.
if [ -z "${IN_NIX_SHELL:-}" ]; then
  cat <<'MSG'
This session is not inside the Nix devShell, so node/pnpm on PATH may not match the pinned versions.
Run toolchain commands through the flake, e.g. `nix develop --command pnpm build`.
MSG
fi
exit 0
