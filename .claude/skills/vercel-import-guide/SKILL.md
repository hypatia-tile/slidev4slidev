---
name: vercel-import-guide
description: Walk the owner through importing this repository into Vercel from the dashboard, then verify the production deployment. Use when setting up or re-creating the Vercel project, or when the production URL needs checking; the owner may phrase this in Japanese.
---

# Vercel import guide

Claude cannot click through the Vercel dashboard, so the owner does the import
and Claude verifies the result. Present the checklist, wait for the owner to
report back, then verify.

## Checklist for the owner

1. Vercel dashboard → **Add New… → Project** → import
   `hypatia-tile/slidev4slidev` from GitHub (grant the Vercel GitHub App access
   to the repository if it is not listed).
2. Project name: `slidev4slidev`.
3. Framework Preset: **Other**. Build and output settings come from
   `vercel.json` (`pnpm build`, `dist`), so leave the overrides off.
4. Root Directory: the repository root (default).
5. After creating: **Settings → Build and Deployment → Node.js Version → 24.x**,
   matching `engines.node` and the flake.
6. Deploy, and report the production URL (expected
   `https://slidev4slidev.vercel.app`).

## Verification

Once the owner reports the URL:

```sh
for path in / /2; do
  printf '%s ' "$path"
  curl -s -o /dev/null -w '%{http_code}\n' "https://slidev4slidev.vercel.app$path"
done
```

If `curl` is not on PATH, run the loop inside `nix develop --command bash -c ...`.
Both must return 200; a 404 on `/2` means the rewrite in `vercel.json` is not
applied. Also check the build log in the dashboard used pnpm 12 (the version
in `packageManager`); if Vercel picked a different pnpm, set the environment
variable `ENABLE_EXPERIMENTAL_COREPACK=1` so it honours `packageManager`.

If the actual URL differs from the expected one, update this skill, the
`release-tag` skill and the README.
