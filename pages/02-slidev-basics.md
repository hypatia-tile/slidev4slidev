---
layout: section
---

# 02. Slidev Basics

Slides, frontmatter, layouts, clicks, code and notes

---

# Slides and frontmatter

````md
---
theme: seriph        # headmatter: the first block configures the whole deck
title: Slidev for Slidev
transition: slide-left
comark: true
---

# First slide

---
layout: center       # frontmatter of the second slide only
---

# Second slide
````

- `---` on its own line starts a new slide
- The first YAML block is the **headmatter** (deck-wide); later blocks are per-slide **frontmatter**

---
layout: two-cols
---

# Layouts

Set with `layout:` in a slide's frontmatter. Built-in ones include:

- `cover`, `section`, `center`, `end`
- `default`
- `two-cols`, `two-cols-header`
- `image-left`, `image-right`
- `quote`, `fact`, `statement`

Themes can add or restyle layouts; `seriph` restyles `cover` and `section`.

::right::

<div class="pl-4">

This slide uses `two-cols`:

```md
---
layout: two-cols
---

# Left column

::right::

Right column
```

</div>

---

# Click animations

```md
<v-click>Appears on the first click</v-click>

<v-clicks>

- one item
- per click

</v-clicks>
```

<v-click>

**Appears on the first click**

</v-click>

<v-clicks>

- Then this item
- Then this one

</v-clicks>

---

# Code blocks

````md
```ts {2|3|all}
const deck = 'slidev4slidev'
const url = `https://${deck}.vercel.app`
console.log(url)
```
````

```ts {2|3|all}
const deck = 'slidev4slidev'
const url = `https://${deck}.vercel.app`
console.log(url)
```

- `{2|3|all}` highlights line 2, then 3, then everything — one step per click
- Syntax highlighting is Shiki; any language it knows works (`nix`, `sh`, `json`, …)

---

# Speaker notes

```md
# A slide

Content the audience sees.

<!--
Everything in the last HTML comment of a slide is a speaker note.
Shown in /presenter, never on the slide itself.
-->
```

Open `/presenter` to see this slide's note.

<!--
This is the note for this slide. Presenter mode also shows the next slide and a timer.
-->
