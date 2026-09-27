---
layout: section
---

# 05. Deploying with the Vercel Git Integration

Push to GitHub, Vercel builds and hosts

---

# `vercel.json`

```json
{
  "$schema": "https://openapi.vercel.sh/vercel.json",
  "buildCommand": "pnpm build",
  "outputDirectory": "dist",
  "rewrites": [{ "source": "/(.*)", "destination": "/index.html" }]
}
```

- `buildCommand` / `outputDirectory` — no need to set them in the dashboard
- `rewrites` — every path serves `index.html`, so `/5` works (chapter 04)
- The `create-slidev` template ships a `vercel.json` too, but with `npm run build`

---
class: text-sm
---

# Importing the repository

1. Vercel dashboard → **Add New… → Project** → import the GitHub repository
   <br>(grant the Vercel GitHub App access to it if it is not listed)
2. **Project name** — becomes the domain: `slidev4slidev` → `slidev4slidev.vercel.app`
3. **Framework Preset: Other** — build settings come from `vercel.json`
4. **Root Directory** — the repository root
5. Deploy, then **Settings → Build and Deployment → Node.js Version → 24.x**

<v-click>

Then check both a root and a deep link return 200:

```sh
for path in / /2; do
  curl -s -o /dev/null -w "$path %{http_code}\n" "https://slidev4slidev.vercel.app$path"
done
```

</v-click>

<!--
The vercel-import-guide Claude Code skill holds this checklist and the verification.
-->

---

# Node.js and pnpm on Vercel

Nix does not exist on Vercel. The versions come from the repository and project settings:

| | Source on Vercel |
|---|---|
| Node.js | Project setting **Node.js Version**, checked against `engines.node` |
| pnpm | `packageManager: "pnpm@12.3.4"` in `package.json` |

- Confirm both in the **build log** of the first deployment
- If Vercel picks a different pnpm, set the env var `ENABLE_EXPERIMENTAL_COREPACK=1`

---

# What happens on push

| Event | Vercel does |
|---|---|
| Push to a branch with an open PR | **Preview** deployment; a bot comments the URL on the PR |
| Push more commits | A new preview deployment per commit |
| Merge into `main` | A new **production** build from `main` |

- The PR gets a `Vercel` check: a failed build is visible before merge
- Previews sit behind **Deployment Protection** — logged-out visitors are redirected to Vercel login
- Production is public

---
class: text-sm
---

# Three kinds of URL

| URL | Points at | Changes? |
|---|---|---|
| `slidev4slidev-<hash>-hypatia2.vercel.app` | One deployment | Never — each deployment gets its own |
| `slidev4slidev-git-<branch>-hypatia2.vercel.app` | Latest push of the branch | Moves on every push |
| `slidev4slidev.vercel.app` | Latest production deployment | Moves on every merge to `main` |

<v-clicks>

- Sharing a preview? Use the **branch** URL — a hash URL goes stale after the next push
- Merging does **not** promote the preview: `main` is built again, so production gets a new hash URL
- The production domain is just an alias re-pointed to that new deployment

</v-clicks>

<!--
Learned the hard way on PR #1: the hash URL handed over was from the first push, not the last.
-->
