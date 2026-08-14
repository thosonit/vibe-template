---
version: alpha
name: Verdant Editorial
description: Minimalist editorial design system — restrained near-black/off-white surfaces with one bold, confident signature green accent used sparingly for emphasis and action, in the spirit of Spotify's brand green.
colors:
  primary: "#1DB954"
  primary-hover: "#17A34A"
  primary-active: "#12873C"
  on-primary: "#0B0F0D"
  ink: "#121212"
  ink-secondary: "#4B4F4E"
  ink-tertiary: "#8A8F8D"
  paper: "#FAFAF8"
  surface: "#FFFFFF"
  surface-sunken: "#F1F2F0"
  border: "#E3E4E1"
  border-strong: "#C7C9C5"
  success: "#0F7A3D"
  success-bg: "#E7F7ED"
  warning: "#7A5900"
  warning-bg: "#FBF3DD"
  error: "#A83A30"
  error-bg: "#FBEAE8"
typography:
  display:
    fontFamily: "Fraunces, Georgia, 'Times New Roman', serif"
    fontSize: 4.5rem
    fontWeight: 500
    lineHeight: 1.05
    letterSpacing: "-0.02em"
  h1:
    fontFamily: "{typography.display.fontFamily}"
    fontSize: 2.75rem
    fontWeight: 500
    lineHeight: 1.15
    letterSpacing: "-0.01em"
  h2:
    fontFamily: "{typography.display.fontFamily}"
    fontSize: 1.875rem
    fontWeight: 500
    lineHeight: 1.25
  h3:
    fontFamily: "Inter, -apple-system, 'Segoe UI', sans-serif"
    fontSize: 1.25rem
    fontWeight: 600
    lineHeight: 1.35
  body-lg:
    fontFamily: "Inter, -apple-system, 'Segoe UI', sans-serif"
    fontSize: 1.125rem
    fontWeight: 400
    lineHeight: 1.6
  body-md:
    fontFamily: "Inter, -apple-system, 'Segoe UI', sans-serif"
    fontSize: 1rem
    fontWeight: 400
    lineHeight: 1.55
  caption:
    fontFamily: "Inter, -apple-system, 'Segoe UI', sans-serif"
    fontSize: 0.8125rem
    fontWeight: 500
    lineHeight: 1.4
    letterSpacing: "0.01em"
rounded:
  none: 0px
  sm: 4px
  md: 8px
  lg: 16px
  full: 999px
spacing:
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 40px
  2xl: 64px
  3xl: 96px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    typography: "{typography.h3}"
    rounded: "{rounded.full}"
    padding: 16px
  button-primary-hover:
    backgroundColor: "{colors.primary-hover}"
  button-primary-active:
    backgroundColor: "{colors.primary-active}"
  button-secondary:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.h3}"
    rounded: "{rounded.full}"
    padding: 16px
  button-secondary-hover:
    backgroundColor: "{colors.surface-sunken}"
  card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    rounded: "{rounded.lg}"
    padding: 24px
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.ink}"
    typography: "{typography.body-md}"
    rounded: "{rounded.md}"
    padding: 12px
  badge:
    backgroundColor: "{colors.success-bg}"
    textColor: "{colors.success}"
    typography: "{typography.caption}"
    rounded: "{rounded.sm}"
    padding: 4px
  badge-warning:
    backgroundColor: "{colors.warning-bg}"
    textColor: "{colors.warning}"
    typography: "{typography.caption}"
    rounded: "{rounded.sm}"
    padding: 4px
  badge-error:
    backgroundColor: "{colors.error-bg}"
    textColor: "{colors.error}"
    typography: "{typography.caption}"
    rounded: "{rounded.sm}"
    padding: 4px
  page:
    backgroundColor: "{colors.paper}"
    textColor: "{colors.ink}"
  text-secondary:
    textColor: "{colors.ink-secondary}"
    typography: "{typography.body-md}"
  text-caption:
    textColor: "{colors.ink-tertiary}"
    typography: "{typography.caption}"
---

## Overview

Verdant Editorial pairs the restraint of an editorial layout — generous whitespace, a serif display face, near-black ink on off-white paper — with a single, unapologetically bold accent color. The green (`#1DB954`) is used the way Spotify uses its brand green: sparingly, as a signal of action and identity, never as a background wash. Everywhere else the palette stays quiet so that when green appears, it reads as a deliberate call to act, not decoration.

## Colors

The palette is built on a warm off-white paper (`#FAFAF8`) rather than pure white, giving the interface a printed, editorial feel instead of a clinical one. Ink colors step down in three tiers (`ink`, `ink-secondary`, `ink-tertiary`) so hierarchy comes from contrast, not from introducing new hues. `primary` is reserved for primary actions, active states, and brand moments — it should never cover large surface areas, only buttons, links, and small accents. Semantic colors (`success`, `warning`, `error`) intentionally stay desaturated relative to `primary` so the accent green is never confused with a status color.

## Typography

Fraunces is used only for `display`, `h1`, and `h2` — it carries the editorial character and should be reserved for moments that need presence: page titles, section headers, and pull-quote-style statements. Everything below `h3` switches to Inter, a neutral grippy sans, so body copy stays highly legible at small sizes. This two-family pairing is deliberate: a serif that unmistakably signals "editorial" up top, a sans that disappears into readability below.

## Layout

Spacing follows a doubling-ish scale (`4px` → `96px`) rather than a dense 4px-everywhere grid, because editorial layouts read better with a small number of clearly distinct rhythms rather than many near-identical increments. Use `xl`/`2xl`/`3xl` between major sections to create the generous breathing room the style depends on; reserve `xs`/`sm` for internal component spacing only.

## Shapes

Two personalities coexist by design: buttons and pills are fully rounded (`rounded.full`) to feel like confident, tappable actions — echoing the pill-shaped CTAs common in music/media-brand UI — while containers like cards use a softer, moderate `rounded.lg` so they read as content surfaces, not controls. Avoid mixing these: a container should never use `full`, and a button should never use `none`.

## Components

`button-primary` is the only component that uses the full-strength accent color as a fill; every other component uses `ink`/`paper`/`surface` tokens so the green stays rare and meaningful. `badge` intentionally reuses the `success` tokens rather than `primary`, keeping status indicators visually distinct from the brand accent even though both happen to be green-adjacent.

## Do's and Don'ts

- Do use `primary` for the single most important action on a screen — not for every button.
- Do let `paper`/`ink` carry most of the visual weight; treat color as a spotlight, not a wash.
- Do pair Fraunces headlines with generous surrounding whitespace (`xl` or larger).
- Don't tint large backgrounds or hero sections with `primary` — it should appear as small, high-contrast accents only.
- Don't use `rounded.full` on cards, modals, or other content containers.
- Don't introduce a second accent hue; if more color is needed, lean on the semantic tokens instead.
