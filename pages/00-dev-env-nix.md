---
layout: section
---

# 00. Development Environment with Nix

Pin the toolchain per repository, load it automatically

---

# Why a Nix flake?

Slidev needs Node.js and a package manager. Instead of whatever is installed globally:

- **Per-repository versions** — this repo gets Node.js 24 and pnpm 12, other repos get their own
- **Reproducible** — `flake.lock` pins the exact nixpkgs revision
- **Tools come along** — git hooks (`lefthook`) and `curl` live in the same shell
- **Nothing to install globally** except Nix and direnv

<!--
The deck targets its author, who already uses Nix and direnv everywhere.
Without Nix, installing Node.js 24 and pnpm 12 by hand is enough to follow the rest.
-->

---

# `flake.nix`: the devShell

```nix {all|4-9|10-12}
devShells = forAllSystems (pkgs: {
  # Keep nodejs and pnpm in sync with `engines.node` and `packageManager` in package.json.
  default = pkgs.mkShell {
    packages = [
      pkgs.nodejs_24
      pkgs.pnpm
      pkgs.lefthook
      pkgs.curl
    ];
    shellHook = ''
      if [ -f lefthook.yml ]; then lefthook install >/dev/null; fi
    '';
  };
});
```

- `nix develop` enters the shell by hand
- `nix flake lock` / `nix flake update` write and refresh `flake.lock`
- `shellHook` wires up git hooks on entry, once `lefthook.yml` exists

---

# direnv: enter the shell on `cd`

```sh
# .envrc
use flake
```

```sh
direnv allow        # trust this .envrc once
node -v             # v24.x
pnpm -v             # 12.x
```

- `use flake` comes from **nix-direnv**, which caches the shell so re-entering is instant
- `.direnv/` holds that cache — keep it in `.gitignore`
- After editing `flake.nix`, direnv reloads on the next prompt

---

# Keeping versions in sync

Nix only exists on your machine. Vercel reads `package.json`.

| Where | Node.js | pnpm |
|---|---|---|
| `flake.nix` (local) | `pkgs.nodejs_24` | `pkgs.pnpm` → 12.3.4 |
| `package.json` | `"engines": { "node": "24.x" }` | `"packageManager": "pnpm@12.3.4"` |
| Vercel project | Settings → Node.js Version → 24.x | detected from `packageManager` |

<v-click>

When `nix flake update` bumps pnpm, bump `packageManager` in the same commit.
Check the Vercel build log for the versions it actually used.

</v-click>

---

# Checks wired into the shell

`scripts/check.sh` is the single place for checks. Everything else calls it.

| Trigger | Command |
|---|---|
| git `pre-commit` (lefthook) | `scripts/check.sh quick` — `src:` references, frozen lockfile |
| git `pre-push` (lefthook) | `scripts/check.sh full` — quick + `pnpm build` |
| Claude Code `PreToolUse` | same checks before `git commit` / `git push`; blocks `npm`, `npx`, `yarn` |

If called outside the devShell, `check.sh` re-runs itself through `nix develop`,
so the pinned toolchain is always used.

<!--
A failed pre-push means Vercel would fail too. Fix it; do not skip the hook.
-->
