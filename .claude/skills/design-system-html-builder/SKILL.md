---
name: design-system-html-builder
description: Build a self-contained design-system.html file (colors, typography, spacing, radius, elevation, every component with its states, light and dark theme, live primary-color picker) from a DESIGN.md design-token file, so other AI coding agents have a rich, visual, copy-pasteable reference for building UI consistent with the brand. Use this skill whenever the user asks to "generate a design system page/site", "visualize my DESIGN.md", "create a design-system.html", "showcase my design tokens", or wants to add/extend components in an existing design-system.html. Also use it if the user has an existing design-system.html they want updated after DESIGN.md changed.
---

# Design System HTML Builder

Generate `docs/design/design-system.html` — a static, self-contained page that shows every token and component of a `DESIGN.md`. DESIGN.md is the machine-readable source of truth; this page is its visual twin, so an agent (and a human) can *see* the system before writing UI, which reduces drift.

The page is **not written from scratch**. `references/design-system-template.html` is the canonical page (built from the matching DESIGN.md template of the `design-md-builder` skill). Every new page is a copy of it with the brand-specific values swapped. Read `references/structure-spec.md` first: it lists what is fixed, the DESIGN.md → page mapping, the class vocabulary and the rules for adding a component.

Two modes: **(A) Create new** and **(B) Update / extend** an existing file. If the user points at an existing `design-system.html`, use B.

## Mode A — Create a new design-system.html

### Step 1 — Find and read DESIGN.md

- Look in `docs/design/DESIGN.md` (project standard, see `CLAUDE.md`), or the path the user gives.
- If it doesn't exist, ask for it, or run the `design-md-builder` skill first. Never invent tokens.
- If DESIGN.md is not lint-clean (`broken-ref` etc.), tell the user before building: broken tokens make the page render wrong.

### Step 2 — Map DESIGN.md onto the template

Read `references/design-system-template.html` in full, then compare it with DESIGN.md:

1. Copy the template to `docs/design/design-system.html`.
2. Swap the values per the mapping table in `structure-spec.md` §2: `:root` and dark tokens, spacing/radius/shadow/height vars, `--font` and the Fonts link, `.t-*` type classes and type-scale rows, brand name, `<title>`, hero copy, color groups/pairs/role table, primary `presets` (DESIGN.md primary first, exact).
3. Reconcile the component set: components the template shows but DESIGN.md doesn't define are removed (HTML, CSS, script wiring); components DESIGN.md defines but the template lacks are added by the rules in `structure-spec.md` §4.
4. Update the section ledes, usage tables and Do's and Don'ts so they say the same thing as DESIGN.md's prose.

Keep the structure, class names, element ids and script behaviour from the template. If DESIGN.md has no dark theme, remove the dark block, the theme switch and its script wiring.

### Step 3 — Design judgment only where the template is silent

The template already carries the layout and look. Call `Skill({skill: "frontend-design:frontend-design"})` only for what DESIGN.md defines and the template doesn't cover (a new component, an illustration, an unusual brand personality), and keep that addition in the same tone: same radii, shadows and motion as its neighbours, no new signature element.

### Step 4 — Verify

Follow `structure-spec.md` §5: render it, check both themes, the primary picker, every contrast pair, interactions, and widths 320 / 768 / 1280. Fix anything that overflows or reads below 4.5:1 by correcting the token or the usage, not by hardcoding a color.

### Step 5 — Present

Report: the path written, which components were added or removed relative to the template, and any value inferred beyond DESIGN.md and why.

## Mode B — Update or extend an existing file

Use when the user says "add component X", "DESIGN.md changed, refresh the page", or similar.

1. Read DESIGN.md and the existing `design-system.html` (its `:root` vars, class vocabulary, `pairs`, `presets`, `sections`).
2. **DESIGN.md changed:** diff the tokens against `:root` and the dark block, update values, then update type rows, spacing/shape/elevation specimens, role table and prose that no longer match.
3. **New component:** follow `structure-spec.md` §4 (CSS in the matching block, specimen in the matching group, behaviour in the existing IIFE, new pairs added to `pairs`). If it needs a token DESIGN.md lacks, ask: use the closest existing token, or update DESIGN.md first (and re-lint through `design-md-builder`).
4. Edit with `Edit`, never rebuild the file. Re-run the checks in `structure-spec.md` §5 for the touched area.
5. Report what changed and where.

## Notes

- The page keeps its one `<script>` for the theme switch, primary picker, live contrast, tabs, dialogs, slider and pagination. That JS exists to demonstrate real states, so keep it; don't add behaviour beyond what a component needs.
- The Lucide icon sprite is part of the template. If DESIGN.md names a different icon set, replace the sprite symbols with that set's equivalents under the same ids.
- `CLAUDE.md` makes this file the reference for UI work: screen prototypes (`docs/screens/*.screen.html`) must match its tokens and component states, so keep it accurate rather than approximate.
