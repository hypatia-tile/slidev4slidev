---
name: add-chapter
description: Add a new chapter file to the deck and wire it into slides.md. Use when the owner asks to add, start or scaffold a chapter or section of the deck; they may phrase this in Japanese ("次の章を足して").
---

# Add a chapter

The deck is split into chapter files under `pages/`, imported from `slides.md`
with `src:`. `slides.md` itself holds only the cover and the Contents slide.

## Steps

1. Decide the number: one more than the highest `pages/NN-*.md`, starting at
   `00`. Ask the owner for the slug and title if they were not given
   (slug: kebab-case, e.g. `deploy-cli`).
2. Create `pages/NN-<slug>.md` from this template (English prose; the first
   slide is the chapter title slide):

   ```md
   ---
   layout: section
   ---

   # <Title>

   ---

   # <First topic>

   <!--
   Speaker notes go here.
   -->
   ```

3. Append the import to the end of `slides.md`, keeping chapters in number order:

   ```md
   ---
   src: ./pages/NN-<slug>.md
   ---
   ```

4. Add `NN. <Title>` to the list on the Contents slide in `slides.md`.
5. Run `scripts/check.sh quick` to confirm every `src:` resolves.

Do not commit here; committing and opening the PR is `chapter-pr`.
