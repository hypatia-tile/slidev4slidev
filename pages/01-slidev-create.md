---
layout: section
---

# 01. Creating a Slidev Project

From an empty directory to a running dev server

---

# `pnpm create slidev`

```sh
pnpm create slidev
```

The generator (`create-slidev`) asks two things:

1. **Project name** — the directory to create (defaults to `slidev`)
2. **Install and start it now using pnpm?** — runs `pnpm install` and `pnpm run dev`

<v-click>

Answer **No** to the second one when you want to put the project under git or Nix first,
then run the printed commands yourself:

```sh
cd slidev
pnpm install
pnpm run dev
```

</v-click>

<!--
The package manager in the prompt is detected from how the generator was launched,
so `pnpm create` gives pnpm commands and a pnpm-specific README.
-->

---

# What the template generates

| File | Purpose |
|---|---|
| `slides.md` | The deck: headmatter + slides separated by `---` |
| `package.json` | `dev` / `build` / `export` scripts, `@slidev/cli`, themes, `vue` |
| `pnpm-workspace.yaml` | pnpm settings: `shamefullyHoist`, build-script allowlist for `playwright-chromium` |
| `pages/imported-slides.md` | Example of splitting slides into files (chapter 03) |
| `components/Counter.vue` | Vue components, auto-registered for use in slides |
| `snippets/external.ts` | Code imported into slides with `<<< @/snippets/...` |
| `vercel.json`, `netlify.toml` | Ready-made hosting config (chapter 05) |
| `_gitignore` → `.gitignore` | Ignores `node_modules`, `dist`, … |

This repository keeps only what it uses: `slides.md`, `pages/`, `package.json`, `vercel.json`.

---

# `pnpm dev`

```sh
pnpm dev          # slidev --open → http://localhost:3030
```

- Edits to `slides.md` and `pages/*.md` hot-reload in the browser
- Useful routes on the dev server:

| URL | View |
|---|---|
| `/` , `/5` | The deck, or slide 5 directly |
| `/presenter` | Presenter mode: notes, next slide, timer |
| `/overview` | All slides as a grid |

- Keys: <kbd>space</kbd> / <kbd>→</kbd> next, <kbd>o</kbd> overview, <kbd>g</kbd> go to slide, <kbd>d</kbd> dark mode

<!--
The same routes exist on the deployed site, which is why vercel.json needs the SPA rewrite.
-->
