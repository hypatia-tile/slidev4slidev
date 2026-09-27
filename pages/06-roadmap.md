---
layout: section
---

# 06. Other Ways to Deploy

What this repository will try next

---
class: text-sm
---

# Three ways to deploy to Vercel

| | Git Integration | Vercel CLI | GitHub Actions + CLI |
|---|---|---|---|
| Who builds | Vercel | Your machine or Vercel | The Actions runner |
| Trigger | Push / PR | `vercel deploy` by hand | Workflow events |
| Setup | Import in dashboard | `vercel login`, `vercel link` | Token + IDs in GitHub Secrets |
| Status here | **Production** | Planned (`v2-deploy-cli`) | Workflow present, manual only |

Only one of them should deploy production on push — otherwise every push deploys twice.

---

# Vercel CLI, briefly

```sh
pnpm dlx vercel login
pnpm dlx vercel link                 # writes .vercel/ (ignored by git)
pnpm dlx vercel deploy               # preview deployment
pnpm dlx vercel deploy --prod        # production deployment
```

- `vercel build` + `vercel deploy --prebuilt` builds locally and uploads the output only
- Useful to deploy without pushing, or from CI

---

# GitHub Actions: parked, not active

`.github/workflows/vercel-deploy.yml` runs only on **Run workflow** (`workflow_dispatch`):

```yaml
on:
  workflow_dispatch:
    inputs:
      environment: { type: choice, options: [preview, production] }
```

```sh
vercel pull --environment=$ENV    # project settings + env vars
vercel build [--prod]             # build on the runner
vercel deploy --prebuilt [--prod] # upload the result
```

To make it the real pipeline: add `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`
secrets, trigger on push, and turn off the Git Integration with `"git": { "deploymentEnabled": false }`.

---
layout: center
class: text-center
---

# Next

`v1-git-integration` — this deck, deployed by the Git Integration

Next stages: `v2-deploy-cli`, `v3-deploy-actions`

<div class="text-sm opacity-60 mt-8">
  <a href="https://github.com/hypatia-tile/slidev4slidev" target="_blank">github.com/hypatia-tile/slidev4slidev</a>
</div>
