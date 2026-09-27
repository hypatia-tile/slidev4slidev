---
name: chapter-pr
description: Ship chapter work as a pull request and report its Vercel preview URL. Use when the owner asks to open a PR for chapters, publish a preview, or says a group of chapters is ready; they may phrase this in Japanese.
---

# Chapter pull request

Chapters land on `main` through pull requests, so every change gets a Vercel
preview deployment before production.

## Steps

1. If on `main`, create a branch `chapter/<short-name>` (e.g.
   `chapter/slidev-basics`). Never commit chapter work directly to `main`.
2. Commit with a Conventional Commit message in English, e.g.
   `feat(slides): add chapters 1-3 on Slidev basics`. The pre-commit hook runs
   `scripts/check.sh quick`.
3. `git push -u origin HEAD`. The pre-push hook runs `scripts/check.sh full`
   (includes `pnpm build`); fix any failure rather than bypassing it.
4. `gh pr create` with an English title and body: which chapters changed, and
   anything the reviewer should look at in the preview.
5. Wait for the Vercel check: `gh pr checks --watch`.
6. Find the preview URL from the deployment status:

   ```sh
   sha=$(git rev-parse HEAD)
   id=$(gh api "repos/{owner}/{repo}/deployments?sha=$sha" --jq '.[0].id')
   gh api "repos/{owner}/{repo}/deployments/$id/statuses" --jq '.[0].environment_url'
   ```

   If that is empty, fall back to the Vercel bot comment on the PR
   (`gh pr view --comments`).
7. Check the preview serves both `/` and a deep link such as `/2` with
   `curl -s -o /dev/null -w '%{http_code}'` (run it via `nix develop --command curl`
   if `curl` is not on PATH; expect 200 for both; the deep
   link depends on the rewrite in `vercel.json`). Previews sit behind Vercel
   Deployment Protection by default: a 302 to `vercel.com/sso-api` (or a 401)
   means that, not a failure — report it and ask the owner to check the preview
   in a logged-in browser.
8. Report the PR URL and the preview URL to the owner. Do not merge; merging
   is the owner's call.
