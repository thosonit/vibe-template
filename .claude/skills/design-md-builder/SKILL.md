---
name: design-md-builder
description: Build, lint, fix, and export DESIGN.md files — Google's open format for describing a visual identity/design system (colors, typography, spacing, components) to AI coding agents. Use this skill whenever the user wants to create a design system file, a DESIGN.md, a brand style guide for AI agents, wants to define design tokens for their project, mentions "DESIGN.md", "design tokens for agents", or wants to export a design system to Tailwind/DTCG/tokens.json. Also use it if the user has an existing DESIGN.md they want validated, linted, fixed, or updated.
---

# DESIGN.md Builder

Build a `DESIGN.md` file that conforms to Google's open spec (`google-labs-code/design.md`, currently `version: alpha`) — a file describing a design system (design tokens + rationale) for AI coding agents to read and produce UI consistently.

The workflow has 4 fixed steps. Don't skip the lint step — it's what guarantees the file is actually valid per spec, not just "looks right."

## The template

`references/design-md-template.md` is the project's canonical DESIGN.md (a HeroUI v3 based system, "Thoson Design System"). **Every new DESIGN.md starts from a copy of it** — don't write the structure from scratch. Read it in full before Step 2. What it fixes, and what you keep:

- **Token families** (keep names): `primary` (brand) with `-foreground`, `-hover`, `-soft`, `-soft-foreground`; `focus`; neutrals `background`/`surface`/`surface-secondary`/`surface-tertiary`/`overlay`/`segment`/`field-*`/`default`/`muted`/`border`/`separator`/`backdrop`, each surface paired with its `-foreground`; status `success`/`warning`/`danger` with `-soft` and `-soft-foreground` (danger also `-hover`). HeroUI calls the brand family `accent`; here it is `primary` because the spec requires that key.
- **Typography scale** by role (`headline-lg/md`, `title-md/sm`, `body-lg/md/sm`, `label-md/sm`, `micro`), **spacing** `xs`–`2xl` on a 4px base, **rounded** scale `sm`–`3xl` plus `tab-list` and `menu`.
- **Components** in the front matter: one entry per variant/state (`button-primary`, `button-primary-hover`, `chip-soft`, `table-cell`, ...), every value a `{token}` reference, no raw colors.
- **Body sections**, in spec order: Overview, Colors (role table + Dark theme table + "Changing the primary color" table), Typography (role table), Layout, Elevation & Depth (level table), Shapes (radius table), Components (grouped Actions / Forms / Content / Feedback / Overlays / Navigation / States / Motion), Do's and Don'ts. Each section is a role-to-token table or short bullets saying *which token for which case*, plus the rules that stop agents inventing values.

## Step 1 — Ask what the user wants

Only the brand-specific parts of the template change, so ask only for those. If the user already gave them, don't ask again.

Use `AskUserQuestion`, at most 3 questions per call:

- **Name** of the design system (if none, pick a descriptive one).
- **Primary (brand) color**: an existing brand hex, or let Claude propose one. If proposing, choose a shade dark enough that `primary-foreground` on it reaches 4.5:1.
- **Font**: keep Inter (template default, single family), or a specific pairing. If the user wants a pairing, propose one from Google Fonts that fits the vibe and update every `fontFamily` and the font-loading sentence in Typography.
- **Icon set**: default **Lucide** (the template's Do's rule) unless the project already has an icon package installed — detect and reuse it, and rewrite the icon rule accordingly.
- **Deviations from the template** (only if the user hints at them): different component set, different radius character (sharper/rounder), no dark theme, non-HeroUI base. Anything not mentioned stays as the template has it.

If the user doesn't answer, default silently (template values, teal primary, Inter, Lucide) and state those assumptions in the response.

## Step 2 — Build the DESIGN.md file

Read `references/spec.md` (the condensed spec) and `references/design-md-template.md` before writing.

1. Copy the template to `docs/design/DESIGN.md` (or another name if the project has several design systems, e.g. `DESIGN-dark.md`).
2. Change `name` and `description`, and replace "Thoson" / "HeroUI" wording in the prose only where the user's base differs.
3. **Rebrand the primary family** following the template's own "Changing the primary color" table: update `primary`, `focus`, `primary-foreground`, `primary-hover`, `primary-soft`, `primary-soft-foreground` in the front matter **and** the Dark theme table and the rebrand table values in the prose. Don't touch neutrals, status colors, shapes or spacing unless the user asked.
4. Apply any font and icon choice (front matter `fontFamily`, Typography prose, Do's and Don'ts).
5. If the user asked for deviations, edit the matching tokens, tables and prose together so front matter and body never contradict each other.
6. New components copy the template's pattern: separate entry per variant/state, `{token}` references only, plus a line in the matching Components group.
7. Keep the `##` section order from the spec and the template's heading names.

Check contrast for every changed foreground/background pair (4.5:1) before moving on — the template's note explains why `danger`, `primary-hover` and `muted` differ from HeroUI.

## Step 3 — Lint and self-fix

This step is mandatory — don't eyeball it and assume "probably fine," always run the real linter:

```bash
npx -y @google/design.md lint docs/design/DESIGN.md 2>&1 | grep -v "npm error config prefix"
```

(The line `npm error config prefix cannot be changed...` is harmless sandbox-environment noise, not a real error — always filter it out when reading the output, don't mistake it for a file error.)

The result is JSON with `findings[]` (each finding has a `severity`: `error`/`warning`/`info`) and a `summary`. Handle by severity:

- **`error`** (e.g. `broken-ref` — a token reference pointing to a token that doesn't exist): MUST be fixed immediately with `Edit` — this makes the file invalid.
- **`warning`**: fix if it makes sense (e.g. `missing-primary`, `missing-typography`, `contrast-ratio` below the WCAG AA 4.5:1 threshold, `section-order` out of sequence, `unknown-key` — possibly a typo like `colours:` instead of `colors:`). For `orphaned-tokens` (a color defined but not used by any component), consider: if it's a reserved semantic color (success/warning/error), it's fine to keep as-is and explain in the response — no need to delete it or force it onto a component.
- **`info`**: reference only (e.g. `token-summary`), no action needed.

After fixing, re-run lint to confirm `errors: 0`. Repeat up to a few times until clean. If any warning is deliberately kept, tell the user why instead of silently ignoring it.

Summarize the lint result briefly for the user (how many errors/warnings were fixed, what was kept and why) — don't paste the raw JSON into the response.

## Step 4 — Export to other formats (only when requested)

Don't do this automatically unless the user asks, or already told you their stack in Step 1 (e.g. "I use Tailwind"). If that signal is there, you can proactively ask a short question like "Want me to export this to a Tailwind config too?" instead of exporting extra files unprompted.

Export commands:

```bash
# Tailwind v4 (CSS @theme block) — most common for new projects
npx -y @google/design.md export --format css-tailwind docs/design/DESIGN.md > docs/design/theme.css

# Tailwind v3 (theme.extend JSON, used in tailwind.config.js)
npx -y @google/design.md export --format json-tailwind docs/design/DESIGN.md > docs/design/tailwind.theme.json

# W3C DTCG tokens.json — for Figma Variables / Storybook compatibility
npx -y @google/design.md export --format dtcg docs/design/DESIGN.md > docs/design/tokens.json
```

After exporting, tell the user which file(s) were written — always mention both the original `DESIGN.md` and the export file, not just the export in isolation.

If the user wants to compare against an older version (a previously edited design system), use the `diff` command:

```bash
npx -y @google/design.md diff DESIGN-v1.md DESIGN-v2.md 2>&1 | grep -v "npm error config prefix"
```

## Important notes

- The format is currently `version: alpha` and may change. If the CLI returns an unexpected error that doesn't match `references/spec.md`, the package has likely been updated; consider running `npx -y @google/design.md spec --rules` to get the latest spec directly from the CLI instead of trusting the static doc alone.
- No need to install the package beforehand — always use `npx -y @google/design.md ...`, it will fetch from the npm registry automatically.
- If the user only wants to see/understand the spec and doesn't want a file created yet, you can answer directly from `references/spec.md` without running the CLI or creating a file.
