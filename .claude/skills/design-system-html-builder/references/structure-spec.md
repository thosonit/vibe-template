# Structure & conventions for `design-system.html`

`references/design-system-template.html` is the canonical page (the Thoson Design System, built from `design-md-builder`'s `references/design-md-template.md`). Every new `design-system.html` is a **copy of it with the brand-specific values swapped**, never a page written from scratch. This document says what is fixed, what changes per brand, and how to extend it.

## 1. Fixed (keep as is)

**Page frame**
- `<html data-theme="light">`, one `<style>`, one `<script>` (an IIFE at the end of `<body>`), no external framework. Only the Google Fonts `<link>` is external, and only for fonts DESIGN.md names.
- Sticky `.topbar` (brand + dark-theme switch `#theme-switch` + menu button `.menu-btn` on small screens), then `.wrap.page` = sticky sidebar `.side` (≥1024px) + `<main>`. The sidebar and the `#nav-drawer` are filled by JS from the `sections` array.
- A hidden SVG sprite of Lucide icons (`#i-check`, `#i-x`, `#i-down`, `#i-right`, `#i-left`, `#i-menu`, `#i-info`, `#i-ok`, `#i-warn`, `#i-err`), used as `<svg class="i"><use href="#i-..."/></svg>`.
- Section order matches DESIGN.md's `##` order: `#overview`, `#colors`, `#typography`, `#layout`, `#elevation`, `#shapes`, `#components`, `#rules`. **No numbered section labels.** A section is `<section id aria-labelledby>` with an `h2.t-headline-md`, a `p.lede` of one or two sentences that states the rule (the same rule as the DESIGN.md prose), then specimens in `.card`s.
- `#components` holds the groups `#actions`, `#forms`, `#content`, `#feedback`, `#overlays`, `#navigation`, `#states`, each `.group` = `h3.t-title-md` + specimens + a closing `p.lede` of usage rules.

**Behaviour in the script (keep the element ids it reads)**
- `#theme-switch`, `#primary-picker`, `#color-groups`, `#pairs`, `#side-nav`, `#drawer-nav`, `#nav-drawer`, `#dlg`, `#alert-dlg`, `#vol`/`#vol-out`, `#pagination`, `[data-tabs]`, `[data-open]`, `[data-close]`.
- The dark theme is `:root[data-theme="dark"]`, which only redefines token values; components never branch on theme except the few documented spots (danger text, switch thumb, topbar shadow).
- Live contrast: every pair in `pairs` shows its ratio for the current theme and primary and must read 4.5:1 or better.

## 2. DESIGN.md → page mapping (what you change)

| In the page | Comes from DESIGN.md |
|---|---|
| `:root` color vars (`--primary`, `--surface`, ...) | `colors` front matter, same key names (`--<key>`) |
| `:root[data-theme="dark"]` | the "Dark theme" table in the Colors prose |
| `--space-*` | `spacing`; `--r-*` | `rounded`; `--h-sm/md/lg`, `--gutter` | Layout prose |
| `--shadow-1`, `--shadow-2` (light and dark) | Elevation & Depth table and bullets |
| `--font` and the Fonts `<link>` | `typography.*.fontFamily` and the Typography prose |
| `.t-*` classes and the type-scale rows | `typography` tokens (size, weight, line height) and the "Use for" table |
| `.btn`, `.input`, `.chip`, `.card`, `.table-root`, ... | `components` entries and the Components prose. Values come from the same tokens, no raw hex |
| `presets` in the script | the DESIGN.md primary as the first, exact entry (light and dark values from the "Changing the primary color" table), plus 3–4 derived alternatives |
| Color `groups`, `pairs`, "Which token for which case" table | the Colors role table |
| Brand name, `<title>`, hero copy, sample content | the DESIGN.md `name` and `description` |

If DESIGN.md lacks a value the page needs, do not invent one: ask, or derive it from an existing token and say so in the closing message.

## 3. Class vocabulary (reuse, don't add parallels)

- **Layout:** `.wrap`, `.page`, `.group`, `.grid` (`.cols4`, `.wide`), `.row`, `.stack` (`.tight`), `.lede`, `.card` (`.secondary`, `.tertiary`, `.transparent`, `.form`), `.scroll-x`, `.table-simple`.
- **Type:** `.t-headline-lg|md`, `.t-title-md|sm`, `.t-body-lg|md|sm`, `.t-label-md|sm`, `.t-micro`.
- **Controls:** `.btn` + `primary|secondary|tertiary|outline|ghost|danger|danger-soft`, sizes `sm|lg`, `.icon`, `.close`, `.link`; `.field`, `.input` (`.secondary`), `.check`, `.switch`, `.slider`, `.option-list`.
- **Content and feedback:** `.chip` (+ status and `.soft`), `.avatar`, `.badge`, `.accordion`, `.table-root`, `.alert` (+ status), `.toast`, `.spinner`, `.skeleton`, `.progress`.
- **Overlays and navigation:** `.popover`, `.menu`, `.tooltip`, `.dialog`, `.drawer`, `.tabs` (`.primary|.secondary`), `.crumbs`, `.pagination`, `.pg`.
- **State demos:** `.force-hover`, `.force-press`, `.force-focus` render a state statically.

## 4. Adding or removing a component

1. Read DESIGN.md for the component's tokens. A missing token is a question to the user, not an invention.
2. Add CSS at the end of the existing `<style>` in the matching block comment (`/* Content */`, `/* Feedback */`, ...), using only `var(--token)` values.
3. Add the specimen to the matching `.group` in `#components` (or a new `.group` with its own id before `#states`), with the real states, a short `p.lede` rule, and an `aria-label` or visible label for every control.
4. Wire any behaviour into the existing IIFE; never add a second `<script>` or `<style>`.
5. If the component adds a color pair, add it to `pairs` so its contrast is measured.
6. Components DESIGN.md does not define are removed from the page along with their CSS and script wiring, so the page never shows something DESIGN.md can't back.

## 5. Checks before finishing

- Open the file in a browser (or `Read` it) and confirm: both themes render, the primary picker recolors every component, every contrast pair shows "passes AA", the sidebar highlights the section in view, dialogs/drawer/tabs/slider/pagination work, and at 320, 768 and 1280px nothing overflows horizontally.
- No leftover template content: brand name, "Atlas"/"Thoson"/HeroUI wording, sample people and copy are replaced or deliberately kept as neutral sample content.
