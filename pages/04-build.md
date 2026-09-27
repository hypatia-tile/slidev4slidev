---
layout: section
---

# 04. Building for Hosting

What `pnpm build` produces, and why hosts need a rewrite

---

# `pnpm build`

```sh
pnpm build        # slidev build → dist/
```

```
dist/
  index.html      # the whole deck is one page
  assets/         # JS, CSS, fonts — hashed file names
  404.html        # copy of index.html, the fallback GitHub Pages uses
  _redirects      # "/*  /index.html  200" — Netlify's rewrite format
```

- The output is static files only: any static host can serve it
- `scripts/check.sh full` runs this same build before every push

---

# The deck is a single-page app

<v-clicks>

- There is one `index.html`; the Vue router decides which slide `/5` shows
- A browser landing on `/5` asks the server for the file `/5` — which does not exist
- So the host must answer every path with `index.html`: a **rewrite**
- Each host has its own way to say that:

</v-clicks>

<v-click>

| Host | Rewrite comes from |
|---|---|
| Netlify | `dist/_redirects` (generated) |
| GitHub Pages | `dist/404.html` (generated, served with status 404) |
| Vercel | `vercel.json` → `rewrites` (you write it; chapter 05) |

</v-click>

---
class: text-sm
---

# Build options worth knowing

| Option | Use |
|---|---|
| `--base /demo/` | Serve from a sub-path instead of the domain root |
| `--router-mode hash` | URLs like `/#/5`: no rewrite needed, e.g. GitHub Pages sub-paths |
| `--out <dir>` | Output directory other than `dist` |
| `--without-notes` | Strip speaker notes — **they are in the bundle by default** |
| `--download` | Add a PDF download button (needs Playwright; not used here) |

<v-click>

Check the result locally before pushing, with the SPA fallback turned on:

```sh
pnpm dlx serve dist --single     # http://localhost:3000/5 should work
```

</v-click>

<!--
Anyone can read speaker notes from the deployed JS. Use --without-notes if notes are private.
-->
