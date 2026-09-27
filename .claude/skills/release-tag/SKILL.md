---
name: release-tag
description: Tag a milestone of the deck on main (e.g. v1-git-integration). Use when the owner says a stage of the deck is finished, or asks to tag or cut a release; they may phrase this in Japanese.
---

# Release tag

Milestone tags record what the repository looked like at each stage, so a
past stage (for example "only the Git Integration deploy existed") can be
checked out later.

## Naming

`v<N>-<stage>`: `N` increments per milestone, `stage` names what the milestone
added. Existing and planned tags:

- `v1-git-integration` — deck complete through chapter 6, deployed by the
  Vercel Git Integration.
- Later stages are expected to be `v2-deploy-cli`, `v3-deploy-actions`; confirm
  the name with the owner before tagging.

## Steps

1. `git switch main && git pull --ff-only`. Refuse if the working tree is dirty.
2. Confirm the tag does not exist yet: `git tag -l '<tag>'` and
   `git ls-remote --tags origin '<tag>'`.
3. Run `scripts/check.sh full`.
4. Confirm the production URL is serving the current `main` (see
   `vercel-import-guide` for the URL and the curl check).
5. Create an annotated tag with an English message summarising the stage:
   `git tag -a <tag> -m "<summary>"`.
6. Show the owner the tag and target commit, and push only after they agree:
   `git push origin <tag>`.
