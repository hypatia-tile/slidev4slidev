---
layout: section
---

# 03. Structuring a Deck

Splitting slides into files with `src:`

---

# Importing slides with `src:`

A slide whose frontmatter has `src:` is replaced by the slides of that file:

````md
---
src: ./pages/01-slidev-create.md
---
````

- The path is relative to the file doing the import
- The imported file is plain Slidev markdown: its own `---` separators and frontmatter
- Imports can be nested

<v-click>

Import part of a file with a range:

````md
---
src: ./pages/02-slidev-basics.md#2-3
---
````

</v-click>

---

# This deck as the example

```
slides.md                     # headmatter, cover, Contents
pages/
  00-dev-env-nix.md
  01-slidev-create.md
  02-slidev-basics.md
  03-slidev-structure.md
  …
```

- `slides.md` stays short: it only lists chapters
- One chapter per file, numbered, so order is visible in `ls`
- New chapters come from the `add-chapter` Claude Code skill: create the file, append `src:`, update Contents
- `scripts/check.sh` fails the commit if any `src:` points at a missing file

---

# Overriding imported frontmatter

Frontmatter next to `src:` is merged into **every** slide of the imported file:

````md
---
src: ./pages/03-slidev-structure.md
layout: center
---
````

- On a key both sides set, the importing side wins
- Useful when the same chapter file is reused in another deck with a different look
- Checked with `@slidev/parser`: all four slides of this chapter became `layout: center`
