---
version: alpha
name: Thoson Design System
description: HeroUI v3 design system with one brand color (teal by default), Inter typography, large soft radii and borderless surfaces separated by light shadows.
colors:
  primary: "#0F766E"
  primary-foreground: "#FCFCFC"
  primary-hover: "#2F8079"
  primary-soft: "#DBEAE9"
  primary-soft-foreground: "#1E5853"
  focus: "#0F766E"
  background: "#F5F5F5"
  foreground: "#18181B"
  surface: "#FFFFFF"
  surface-foreground: "#18181B"
  surface-secondary: "#EFEFF0"
  surface-secondary-foreground: "#18181B"
  surface-tertiary: "#EAEAEB"
  overlay: "#FFFFFF"
  overlay-foreground: "#18181B"
  segment: "#FFFFFF"
  segment-foreground: "#18181B"
  border: "#DEDEE0"
  backdrop: "#00000080"
  muted: "#63636B"
  default: "#EBEBEC"
  default-hover: "#E1E1E2"
  field-background: "#FFFFFF"
  field-hover: "#F9F9F9"
  field-foreground: "#18181B"
  field-placeholder: "#63636B"
  success: "#17C964"
  success-foreground: "#18181B"
  success-soft: "#DCF7E8"
  success-soft-foreground: "#2B7745"
  warning: "#F5A524"
  warning-foreground: "#18181B"
  warning-soft: "#FEF2DE"
  warning-soft-foreground: "#855F2E"
  danger: "#D0000D"
  danger-foreground: "#FCFCFC"
  danger-hover: "#D8382F"
  danger-soft: "#FFE1E2"
  danger-soft-foreground: "#A43433"
  separator: "#E4E4E7"
typography:
  headline-lg:
    fontFamily: Inter
    fontSize: 30px
    fontWeight: 600
    lineHeight: 1.2
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: 600
    lineHeight: 1.25
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: 400
    lineHeight: 1.5
  label-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: 500
    lineHeight: 1.25
  micro:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: 500
    lineHeight: 1.34
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: 500
    lineHeight: 1.5
  title-sm:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: 500
    lineHeight: 1.71
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.43
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: 400
    lineHeight: 1.5
  label-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: 500
    lineHeight: 1.25
spacing:
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  2xl: 32px
rounded:
  sm: 4px
  md: 6px
  lg: 8px
  xl: 12px
  2xl: 16px
  tab-list: 20px
  menu: 22px
  3xl: 24px
components:
  page:
    backgroundColor: "{colors.background}"
    textColor: "{colors.foreground}"
    typography: "{typography.body-md}"
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    typography: "{typography.label-md}"
    rounded: "{rounded.3xl}"
    height: 40px
    padding: "{spacing.lg}"
  button-primary-hover:
    backgroundColor: "{colors.primary-hover}"
    textColor: "{colors.primary-foreground}"
  button-secondary:
    backgroundColor: "{colors.default}"
    textColor: "{colors.primary-soft-foreground}"
    typography: "{typography.label-md}"
    rounded: "{rounded.3xl}"
    height: 40px
    padding: "{spacing.lg}"
  button-secondary-hover:
    backgroundColor: "{colors.default-hover}"
    textColor: "{colors.primary-soft-foreground}"
  button-danger:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.danger-foreground}"
    typography: "{typography.label-md}"
    rounded: "{rounded.3xl}"
    height: 40px
    padding: "{spacing.lg}"
  button-danger-hover:
    backgroundColor: "{colors.danger-hover}"
    textColor: "{colors.danger-foreground}"
  input:
    backgroundColor: "{colors.field-background}"
    textColor: "{colors.field-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.xl}"
    height: 40px
    padding: "{spacing.md}"
  input-hover:
    backgroundColor: "{colors.field-hover}"
    textColor: "{colors.field-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.xl}"
    height: 40px
    padding: "{spacing.md}"
  input-secondary:
    backgroundColor: "{colors.default}"
    textColor: "{colors.field-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.xl}"
    height: 40px
    padding: "{spacing.md}"
  input-placeholder:
    backgroundColor: "{colors.field-background}"
    textColor: "{colors.field-placeholder}"
    typography: "{typography.body-md}"
  card:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.surface-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.3xl}"
    padding: "{spacing.lg}"
  card-title:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.foreground}"
    typography: "{typography.title-sm}"
  card-description:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.muted}"
    typography: "{typography.body-md}"
  chip-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  chip-soft:
    backgroundColor: "{colors.primary-soft}"
    textColor: "{colors.primary-soft-foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  chip-default:
    backgroundColor: "{colors.default}"
    textColor: "{colors.foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  chip-tertiary:
    textColor: "{colors.foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  chip-success:
    backgroundColor: "{colors.success}"
    textColor: "{colors.success-foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  chip-warning:
    backgroundColor: "{colors.warning}"
    textColor: "{colors.warning-foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  chip-danger:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.danger-foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  chip-success-soft:
    backgroundColor: "{colors.success-soft}"
    textColor: "{colors.success-soft-foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  chip-warning-soft:
    backgroundColor: "{colors.warning-soft}"
    textColor: "{colors.warning-soft-foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  chip-danger-soft:
    backgroundColor: "{colors.danger-soft}"
    textColor: "{colors.danger-soft-foreground}"
    typography: "{typography.label-sm}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.sm}"
  separator:
    backgroundColor: "{colors.separator}"
    height: 1px
  spinner:
    textColor: "{colors.primary}"
    size: 24px
  skeleton:
    backgroundColor: "{colors.surface-tertiary}"
    rounded: "{rounded.sm}"
  progress-track:
    backgroundColor: "{colors.default}"
    rounded: "{rounded.sm}"
    height: 8px
  progress-fill:
    backgroundColor: "{colors.primary}"
    rounded: "{rounded.sm}"
    height: 8px
  button-tertiary:
    backgroundColor: "{colors.default}"
    textColor: "{colors.foreground}"
    typography: "{typography.label-md}"
    rounded: "{rounded.3xl}"
    height: 40px
    padding: "{spacing.lg}"
  button-outline:
    textColor: "{colors.foreground}"
    typography: "{typography.label-md}"
    rounded: "{rounded.3xl}"
    height: 40px
    padding: "{spacing.lg}"
  button-ghost-hover:
    backgroundColor: "{colors.default}"
    textColor: "{colors.foreground}"
    typography: "{typography.label-md}"
    rounded: "{rounded.3xl}"
  button-danger-soft:
    backgroundColor: "{colors.danger-soft}"
    textColor: "{colors.danger-soft-foreground}"
    typography: "{typography.label-md}"
    rounded: "{rounded.3xl}"
    height: 40px
    padding: "{spacing.lg}"
  link:
    textColor: "{colors.foreground}"
    typography: "{typography.label-md}"
  close-button:
    backgroundColor: "{colors.default}"
    textColor: "{colors.foreground}"
    rounded: "{rounded.xl}"
    size: 24px
  label:
    textColor: "{colors.foreground}"
    typography: "{typography.label-md}"
  description:
    textColor: "{colors.muted}"
    typography: "{typography.body-sm}"
  field-error:
    textColor: "{colors.danger}"
    typography: "{typography.body-sm}"
  checkbox:
    backgroundColor: "{colors.field-background}"
    rounded: "{rounded.md}"
    size: 16px
  checkbox-checked:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    rounded: "{rounded.md}"
    size: 16px
  radio-checked:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    rounded: "{rounded.lg}"
    size: 16px
  switch-off:
    backgroundColor: "{colors.default}"
    rounded: "{rounded.xl}"
    height: 20px
    width: 40px
  switch-on:
    backgroundColor: "{colors.primary}"
    rounded: "{rounded.xl}"
    height: 20px
    width: 40px
  switch-thumb:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.lg}"
    height: 16px
    width: 22px
  table-root:
    backgroundColor: "{colors.surface-secondary}"
    textColor: "{colors.surface-secondary-foreground}"
    rounded: "{rounded.tab-list}"
    padding: 0 4px 4px 4px
  table-header:
    backgroundColor: "{colors.surface-secondary}"
    textColor: "{colors.muted}"
    typography: "{typography.label-sm}"
    padding: 10px 16px
  table-cell:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.surface-foreground}"
    typography: "{typography.body-md}"
    padding: 12px 16px
  avatar:
    backgroundColor: "{colors.default}"
    textColor: "{colors.foreground}"
    typography: "{typography.label-md}"
    rounded: "{rounded.3xl}"
    size: 40px
  badge:
    backgroundColor: "{colors.danger}"
    textColor: "{colors.danger-foreground}"
    typography: "{typography.micro}"
    rounded: "{rounded.xl}"
    height: 16px
  alert:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.surface-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.3xl}"
    padding: 12px 16px
  alert-title-primary:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary-soft-foreground}"
    typography: "{typography.title-sm}"
  alert-title-success:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.success-soft-foreground}"
    typography: "{typography.title-sm}"
  alert-title-warning:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.warning-soft-foreground}"
    typography: "{typography.title-sm}"
  alert-title-danger:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.danger-soft-foreground}"
    typography: "{typography.title-sm}"
  toast:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.surface-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.3xl}"
    padding: 12px 16px
    width: 460px
  dialog:
    backgroundColor: "{colors.overlay}"
    textColor: "{colors.overlay-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.3xl}"
    padding: "{spacing.xl}"
  dialog-heading:
    backgroundColor: "{colors.overlay}"
    textColor: "{colors.overlay-foreground}"
    typography: "{typography.title-md}"
  dialog-body:
    backgroundColor: "{colors.overlay}"
    textColor: "{colors.muted}"
    typography: "{typography.body-md}"
  backdrop:
    backgroundColor: "{colors.backdrop}"
  popover:
    backgroundColor: "{colors.overlay}"
    textColor: "{colors.overlay-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.3xl}"
    padding: "{spacing.lg}"
  tooltip:
    backgroundColor: "{colors.overlay}"
    textColor: "{colors.overlay-foreground}"
    typography: "{typography.body-sm}"
    rounded: "{rounded.xl}"
    padding: "{spacing.sm}"
  menu:
    backgroundColor: "{colors.overlay}"
    textColor: "{colors.overlay-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.menu}"
    padding: "{spacing.xs}"
  menu-item-hover:
    backgroundColor: "{colors.default}"
    textColor: "{colors.foreground}"
    rounded: "{rounded.2xl}"
  tabs-list:
    backgroundColor: "{colors.default}"
    textColor: "{colors.muted}"
    typography: "{typography.label-md}"
    rounded: "{rounded.tab-list}"
    padding: "{spacing.xs}"
  tab-selected:
    backgroundColor: "{colors.segment}"
    textColor: "{colors.segment-foreground}"
    typography: "{typography.label-md}"
    rounded: "{rounded.3xl}"
    height: 32px
    padding: "{spacing.lg}"
  tabs-indicator-secondary:
    backgroundColor: "{colors.primary}"
    height: 2px
  tabs-secondary-border:
    backgroundColor: "{colors.border}"
    height: 1px
  pagination-link-active:
    backgroundColor: "{colors.default}"
    textColor: "{colors.foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.3xl}"
    size: 36px
  focus-ring:
    backgroundColor: "{colors.focus}"
    size: 2px
  accordion-trigger:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.surface-foreground}"
    typography: "{typography.label-md}"
    padding: "{spacing.lg}"
  accordion-content:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.muted}"
    typography: "{typography.body-md}"
    padding: 0 16px 16px 16px
  breadcrumb-link:
    textColor: "{colors.muted}"
    typography: "{typography.label-md}"
  breadcrumb-current:
    textColor: "{colors.foreground}"
    typography: "{typography.label-md}"
  drawer:
    backgroundColor: "{colors.overlay}"
    textColor: "{colors.overlay-foreground}"
    typography: "{typography.body-md}"
    rounded: "{rounded.2xl}"
    padding: "{spacing.xl}"
  slider-track:
    backgroundColor: "{colors.default}"
    rounded: "{rounded.xl}"
    height: 20px
  slider-fill:
    backgroundColor: "{colors.primary}"
    rounded: "{rounded.xl}"
  slider-thumb:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.primary-foreground}"
    rounded: "{rounded.xl}"
    size: 24px
---

## Overview

Thoson follows the HeroUI v3 philosophy: semantic intent over visual style. The interface is calm and rounded, with borderless surfaces separated by light shadows and a single brand primary (teal by default) that marks the main action on a screen. It is accessible by default (WCAG AA), built by composing small parts, and offers `sm`, `md` and `lg` sizes with `md` as the default.

## Colors

The primary color is the brand, and it is the only color that is meant to change between products. It defaults to teal (`#0F766E`, one step darker than teal-600 so white text on it passes WCAG AA). Everything else is a quiet neutral. Color keys follow HeroUI v3 token names with one exception: HeroUI calls this family `accent`, and Thoson calls it `primary` because the Google spec requires that key. Every `primary-*` key here is the HeroUI `accent-*` token of the same role, so copy HeroUI values across under the `primary` name.

| Case | Token | Text on it |
|---|---|---|
| Page canvas | `background` | `foreground` |
| Card, alert, anything that holds content | `surface` | `surface-foreground` |
| Loading placeholder | `surface-tertiary` | none |
| Input fill | `field-background` (hover `field-hover`) | `field-foreground`, placeholder `field-placeholder` |
| Hints, descriptions, captions | none | `muted` |
| Neutral fill: progress track, toggles | `default` (hover `default-hover`) | `foreground` |
| Secondary button | `default` (hover `default-hover`) | `primary-soft-foreground` |
| Main action, selected state, spinner, progress fill | `primary` (hover `primary-hover`) | `primary-foreground` |
| Focus ring | `focus` | none |
| Tinted highlight, such as a soft chip | `primary-soft` | `primary-soft-foreground` |
| Destructive action | `danger` (hover `danger-hover`) | `danger-foreground` |
| Solid status fill: success or warning chip, progress fill | `success`, `warning` | `success-foreground`, `warning-foreground` |
| Status tint (success, warning, danger) | `success-soft`, `warning-soft`, `danger-soft` | the matching `-soft-foreground` |
| Overlay: dialog, popover, menu, tooltip | `overlay` | `overlay-foreground` |
| Table container and header | `surface-secondary` | `surface-secondary-foreground`, header `muted` |
| Selected tab and other segmented indicators | `segment` | `segment-foreground` |
| 1px line that must be visible: outline button, secondary tabs underline | `border` | none |
| Divider between items | `separator` | none |
| Dimmed page behind a dialog | `backdrop` | none |

- Status colors mark meaning only. Never use them as decoration or as the brand primary, and never show state by color alone. Pair color with text or an icon.
- Primary means brand and action. Green means success, whatever the primary color is.
- Values differ from HeroUI in three places, only to pass WCAG AA with the text on them: `danger` and `primary-hover` are darker so `danger-foreground` and `primary-foreground` reach 4.5:1, and `muted` is darker so hints stay readable on `background`, `default` and `surface-tertiary`.
- A new color follows the same pattern: a base, then `-hover`, `-soft`, `-soft-foreground` and `-foreground` only when a component needs them. Use HeroUI key names.

### Dark theme

Dark uses the same keys; only the values change. `danger`, `danger-hover` and `danger-foreground` keep their light values.

| Keys | Dark values |
|---|---|
| `background`, `surface`, `overlay` | `#060607`, `#18181B`, `#18181B` |
| `surface-secondary`, `surface-tertiary`, `segment` | `#232325`, `#262728`, `#46464C` |
| `border`, `backdrop` | `#28282C`, `rgb(0 0 0 / .6)` |
| `foreground` and every `-foreground` on a neutral (`surface`, `surface-secondary`, `overlay`, `segment`, `field`) | `#FCFCFC` |
| `field-background`, `field-hover` | `#18181B`, `#1C1C1F` |
| `muted`, `field-placeholder` | `#9F9FA9` |
| `default`, `default-hover`, `separator` | `#27272A`, `#2E2E31`, `#212124` |
| `primary`, `primary-hover`, `primary-foreground` | `#2DD4BF`, `#28C2AF`, `#042F2E` |
| `focus` | `#2DD4BF` |
| `primary-soft`, `primary-soft-foreground` | `#1B2F2F`, `#7DE0CF` |
| `success`, `success-foreground` | `#17C964`, `#18181B` |
| `warning`, `warning-foreground` | `#F7B750`, `#18181B` |
| `success-soft`, `success-soft-foreground` | `#182D24`, `#74D88F` |
| `warning-soft`, `warning-soft-foreground` | `#332B21`, `#F9CB86` |
| `danger-soft`, `danger-soft-foreground` | `#351D20`, `#EB7872` |

HeroUI darkens `danger` to `#DB3B3E` on dark, which gives only 4.35:1 against `danger-foreground`. Thoson keeps the light value so the pair stays above 4.5:1. On dark, use `danger-soft-foreground` for danger text; solid `danger` is for fills only.

### Changing the primary color

To rebrand, change only the primary family. Everything else in this file stays the same. In HeroUI this family is the `accent` set of variables, so a rebrand touches these keys and nothing more:

| Keys | Light | Dark | How to derive |
|---|---|---|---|
| `primary` | `#0F766E` | `#2DD4BF` | The brand color. |
| `focus` | `#0F766E` | `#2DD4BF` | Same value as `primary`. It is a separate key so focus can differ from the brand if you ever need that. |
| `primary-foreground` | `#FCFCFC` | `#042F2E` | Text on `primary`. White on a dark primary, a near-black tint of the primary on a light one. Must reach 4.5:1. |
| `primary-hover` | `#2F8079` | `#28C2AF` | `primary` moved a small step toward `primary-foreground` (HeroUI mixes in 10%). Re-check contrast afterwards. |
| `primary-soft` | `#DBEAE9` | `#1B2F2F` | A light tint of the primary (HeroUI uses 15% on light, 12% on dark). |
| `primary-soft-foreground` | `#1E5853` | `#7DE0CF` | A darker shade of the primary on light, a lighter one on dark. Must reach 4.5:1 on `primary-soft`. |

The secondary button, and the avatar fallback in its primary color variant, use `primary-soft-foreground` as text color, so they follow the primary too. The neutral, status and shape tokens do not change. Check every pair with a contrast tool after the change, then run `npx @google/design.md lint DESIGN.md`.

## Typography

Inter is the only font. Load weights 400, 500 and 600 with `font-display: swap`, and fall back to `system-ui, -apple-system, "Segoe UI", sans-serif`. Pick the style by the role of the text, not by how big it should look.

| Token | Use for |
|---|---|
| `headline-lg` | Page title (the one `h1`) |
| `headline-md` | Section title (`h2`) |
| `title-md` | Dialog headings |
| `title-sm` | Card, alert and toast titles |
| `body-lg` | Input text below 640px, long-form reading |
| `body-md` | Default text: descriptions, table cells, input values from 640px |
| `body-sm` | Hints, error messages, timestamps |
| `label-sm` | Chips, table column headers |
| `micro` | Count badges (10px) |
| `label-md` | Buttons, form labels, tabs, menu items |

- One `h1` per page. Do not skip heading levels.
- Build hierarchy with size first, then weight. Use only the three weights 400, 500 and 600.
- Labels are never uppercase.

## Layout

A 4px base unit drives every gap. Use only the `spacing` scale.

| Token | Use for |
|---|---|
| `xs` (4px) | Tight gaps: a control to its description, inside card content |
| `sm` (8px) | Icon to text in a button, chip padding, menu padding |
| `md` (12px) | Input horizontal padding, gap between card header, content and footer |
| `lg` (16px) | Card and button padding, gap between form fields and between cards, page gutter on mobile |
| `xl` (24px) | Dialog and drawer padding, page gutter from tablet up |
| `2xl` (32px) | Gap between groups of content and between page sections |

- **Padding** is space inside a container. **Gap** is space between siblings; prefer gap over margins.
- Related items sit closer than unrelated ones. An inner container's padding is never larger than its parent's.
- Controls come in three sizes. Heights are taller on touch screens and step down from 768px: `sm` 36px then 32px, `md` 40px then 36px (default), `lg` 44px then 40px. The component tokens use the `md` touch height of 40px. Buttons and inputs placed side by side share one size. Change the size, never the padding, to give a control more room.
- If a value is not on the scale, use the nearest step.
- Page gutter is `lg` on mobile and `xl` from 768px up. App content stops at 1280px and reading text at 720px, both centered.
- Breakpoints: 640, 768, 1024 and 1280px. Below 640px use one column; from 1024px up side navigation can stay open.

## Elevation & Depth

Depth comes from shadow and tone, not borders. Cards and fields have no border, so a light shadow and the step in tone between `background` and `surface` are what separate them from the page. The shadows are the HeroUI v3 values.

| Level | Shadow | Use for |
|---|---|---|
| 0 Flat | None | Page, chips, skeleton |
| 1 Surface | `0 2px 4px rgb(0 0 0 / .04), 0 1px 2px rgb(0 0 0 / .06), 0 0 1px rgb(0 0 0 / .06)` | Cards, alerts, inputs, checkbox and radio controls |
| 2 Overlay | `0 2px 8px rgb(0 0 0 / .06), 0 -6px 12px rgb(0 0 0 / .03), 0 14px 28px rgb(0 0 0 / .08)` | Dialogs, drawers, popovers, menus, tooltips, toasts |

- In the dark theme the level 1 shadow is dropped, and the tone step carries the edge. Level 2 becomes a 1px inner highlight, `inset 0 0 1px rgb(255 255 255 / .3)`.
- Dialogs and drawers sit on a `rgb(0 0 0 / .5)` backdrop.
- Stack order: page 0, sticky header 10, menus and popovers 20, dialogs and drawers 50, toasts 60.
- Focus is a 2px `focus` ring with a 2px offset whose gap shows `background`. Text fields use a flush 2px ring with no offset. Never remove it.
- Disabled controls drop to 50% opacity and ignore pointer events.

## Shapes

All radii come from one scale. Pick the radius by the kind of element.

| Token | Use for |
|---|---|
| `sm` (4px) | Progress track and fill, skeleton |
| `md` (6px) | Checkbox control |
| `lg` (8px) | Radio control, switch thumb, other small inner parts such as swatches and keys |
| `xl` (12px) | Inputs, tooltips, close buttons, `sm` badges |
| `2xl` (16px) | Chips, menu items, `sm` avatars, `lg` badges |
| `tab-list` (20px) | Tab list container, table container |
| `menu` (22px) | Dropdown menu |
| `3xl` (24px) | Buttons, cards, alerts, dialogs, popovers, toasts, tabs, `md` and `lg` avatars, `md` badges, pagination links |

- A nested element's radius is never larger than its container's.
- Do not mix rounded and sharp corners in the same view.

## Components

Borders and shadows are described in the sections above, not in the front matter, because the spec has no property for them.

A new component must copy its HeroUI v3 counterpart (structure, variants, sizes, radius, motion and states, checked in the HeroUI docs and `@heroui/styles`), use only the tokens in this file with the key names used here and no raw colors so a new primary reaches it, and be added here with a lint pass; note any value that differs from HeroUI and why.

### Actions

| Button variant | Look | Use for |
|---|---|---|
| `primary` | `primary` fill, `primary-foreground` text | The one main action of a view |
| `secondary` | `default` fill, `primary-soft-foreground` text | A neutral action beside the primary one, such as Cancel |
| `tertiary` | `default` fill, `foreground` text | A low-emphasis action that still needs a fill |
| `outline` | Transparent, 1px `border` | A neutral action that needs a visible edge, such as Export |
| `ghost` | Transparent, `default` on hover | Toolbars, icon-only buttons |
| `danger` | `danger` fill, `danger-foreground` text | Destructive or irreversible actions |
| `danger-soft` | `danger-soft` fill, `danger-soft-foreground` text | A destructive action that should not dominate, such as Remove in a list row |

Buttons use `label-md`, radius `3xl`, an 8px gap between icon and text, and horizontal padding `lg`. The icon inside a button is 20px below 640px and 16px from 640px (always 16px at `sm`), with a -2px horizontal margin so it sits closer to the edge. Icon-only buttons are square at the control height and always carry an accessible label.

- **Link:** `foreground`, `label-md`, no underline at rest, underline on hover. Do not color links with the primary. A link goes to another page; a button changes data or triggers an action.
- **Close button:** a 24px ghost button with radius `xl` and a 16px X icon, in the top-right corner of dialogs, toasts and removable chips.

### Forms

Every field is built top to bottom: **label** (`label-md`, always visible; a placeholder is never the label), optional **description** (`body-sm`, `muted`), **control**, then **field error** (`body-sm`, `danger`). Fields in a form are `lg` apart; a fieldset groups related fields under a legend and fieldsets are `2xl` apart. A required field shows a `danger` asterisk after its label.

- **Input, textarea, select:** `field-background` fill, no border, level 1 shadow, radius `xl`, `md` horizontal padding, `body-lg` text below 640px and `body-md` from 640px, `field-placeholder` placeholder. On hover the fill moves to `field-hover`. Invalid fields get a 1px `danger` outline and the label turns `danger`; while focused, a 2px `danger` ring replaces the outline. A select opens its list in a popover with the `menu` radius. The `secondary` variant uses a `default` fill (hover `default-hover`) and no shadow; use it for a field that sits on a `surface`, because on dark `field-background` is the same value as `surface`, as in HeroUI.
- **Checkbox:** a 16px control, radius `md`, `field-background` fill; checked becomes `primary` with an `primary-foreground` check.
- **Radio:** a 16px control with 8px radius (a circle); the selected state is `primary` with an `primary-foreground` dot.
- **Switch:** a 40 × 20px track (`sm` 32 × 16, `lg` 48 × 24), `default` when off and `primary` when on, with a white thumb that slides in 300ms.
- Validate on blur the first time, then on every change once an error has shown.

| Need | Use |
|---|---|
| Pick one of 2 to 5 visible options | Radio group |
| Pick one of more than 5 options | Select |
| Independent options, or consent | Checkbox |
| A setting that applies immediately | Switch |

### Content

- **Card:** parts are Header (`title-sm` title, `muted` `body-md` description), Content and Footer, `lg` padding, `md` gap between parts, level 1 shadow, no border. Variants: `default` (`surface`), `secondary` (`surface-secondary`), `tertiary` (`surface-tertiary`) and `transparent` (no fill, no shadow).
- **Surface:** the base for any container that sets a depth level. It carries no padding of its own.
- **Table:** a `surface-secondary` container with `xs` padding on the sides and bottom only (none on top) that holds the header, and a `surface` body inside it. Column headers are `label-sm` in `muted` with 10px vertical padding, cells are `body-md` with `md` vertical padding, both with `lg` horizontal padding. Rows are separated by a 1px `separator` line at 50% opacity, and the corners of the body inside the container are `2xl`. Pagination sits below the table, outside it.
- **Avatar:** 32, 40 or 48px (radius `2xl` for 32px, `3xl` for the others); the fallback shows initials in `label-md` (12px at 32px) on `default` with `foreground` text. The primary color variant switches the text to `primary-soft-foreground`.
- **Chip:** tag, label or status text, `label-sm`, radius `2xl`, `sm` horizontal padding. Sizes: `sm` has 4px horizontal and no vertical padding, `md` is the default, `lg` has 12px horizontal and 4px vertical padding and 14px text. The default chip is neutral: a `default` fill with `foreground` text. The `tertiary` variant has no fill. Solid chips use a base color (`primary`, `success`, `warning` or `danger`) with its `-foreground`; soft chips use `-soft` with `-soft-foreground`.
- **Badge:** a count or dot on the top-right corner of another element, `danger` fill, 16px tall with `micro` text. Use a chip for text and a badge for a count.
- **Separator:** 1px `separator`. Use it only when spacing alone does not separate the content.
- **Accordion:** a stack of items separated by a 1px `separator` line. The trigger is `label-md` with `lg` padding all round and a 16px `muted` chevron on the right that rotates 180° in 250ms when open; the panel is `muted` `body-md` with `lg` padding on the sides and bottom and none on top. Use it to hide secondary content such as FAQs. The `surface` variant puts the items on a `surface` container with radius `3xl`.
- **Slider:** a `default` track (radius `xl`, 20px tall) with a `primary` fill and a 24px `primary` thumb (radius `xl`) holding an `primary-foreground` dot. The label sits on the left and the value on the right, both `label-md`, the value with tabular numbers. The thumb scales to 0.9 while dragging. Use it for a value in a range, where precision is not important.

### Feedback

- **Alert:** a status icon, a `title-sm` title and a `muted` `body-md` description on a `surface` container with level 1 shadow, `md` vertical and `lg` horizontal padding, and a `lg` gap between the icon and the text. The status color (`primary`, `success`, `warning`, `danger`) applies to the icon and title only, through the `-soft-foreground` token; the default status uses `foreground`. Use it for a message tied to a place on the page.
- **Toast:** the alert surface (`surface`, same padding) with the level 2 shadow, 460px wide, centered at the bottom of the screen 16px from the edge, at most 3 stacked 12px apart, closes after 4 seconds. Use it to confirm a finished action.
- **Spinner:** a 24px ring with a fading tail (`sm` 16px, `lg` 32px, `xl` 40px) that rotates in 0.75s, in `primary` or the surrounding text color. Use it for short waits, such as inside a button after a press.
- **Skeleton:** `surface-tertiary` at 70% with radius `sm`. The default shimmer sweeps a light band across the block in 2 seconds. Use it for page and card content that is loading.
- **Progress bar:** an 8px `default` track with a `primary` fill (or `success`, `warning`, `danger` for a status) that animates its width in 300ms. With no value, the fill is 40% wide and slides across the track. Use it for waits of known length.
- Loading animations stop when the user prefers reduced motion.

### Overlays

Dialogs, popovers, menus and tooltips use `overlay` with `overlay-foreground` text and the level 2 shadow.

- **Dialog:** radius `3xl`, `xl` padding. Parts are Header (`title-md` heading), Body (`muted`, `body-md`), Footer (buttons right aligned, `sm` apart) and a close button. Widths are 320, 384, 448 (default) and 512px. It closes on Escape and on an outside click. It sits on the `backdrop` (opaque by default; a `blur` variant adds a 12px backdrop blur, and a `transparent` variant has no fill), and traps focus. An **alert dialog** confirms a destructive action: two buttons, focus starts on the safe one, and neither Escape nor an outside click closes it. It can show a 40px status icon (radius `3xl`, `danger-soft` fill by default) above the heading, `md` apart.
- **Drawer:** an `overlay` panel with `xl` padding that slides in from an edge in 250ms and leaves in 200ms. Left and right drawers are full height, have no radius, and are 320px wide (384px from 640px, at most 85vw). Top and bottom drawers are full width, at most 85vh tall, and round only the inner corners with `2xl`. It uses the same `backdrop`, focus trap and Escape behavior as a dialog, and also closes on an outside click or by dragging it toward its edge. A drawer opens from the bottom unless told otherwise. Use it for navigation or a side form that should not leave the page.
- **Popover:** radius `3xl`, `lg` padding. Use it for small content or actions anchored to a trigger.
- **Menu (dropdown):** radius `menu`, `xs` padding, at least 220px wide. Items are radius `2xl`, `default` on hover; the danger item uses `danger-soft-foreground`.
- **Tooltip:** `body-sm`, radius `xl`, `sm` padding, at most 320px wide, text only. It opens after 1500ms and closes after 500ms.

### Navigation

- **Tabs `primary`:** a `default` list with radius `tab-list` and `xs` padding; a `segment` indicator slides under the selected tab. Use it to switch views of the same data.
- **Tabs `secondary`:** a transparent list over a 1px `border` line with a 2px `primary` indicator. Use it for page-level sections.
- Tabs can run vertically: the list becomes a column, and `secondary` tabs then use a 1px `border` line and a 2px `primary` indicator on the left.
- A tab is 32px tall with `lg` padding and `label-md`; unselected tabs are `muted`, the selected one is `foreground`. The indicator moves in 250ms.
- **Breadcrumbs:** `label-md`, 6px gap between items with a 12px chevron separator in `muted`. Ancestors are `muted` and underline on hover; the current page is `foreground` and not a link. Use them for a path of three levels or more.
- **Pagination:** links are 36px squares (32px from 768px), radius `3xl`, `body-md`. The current page uses a `default` fill with `foreground` text, not `primary`.

### States

| State | Treatment |
|---|---|
| Hover | The fill moves one step: `primary` to `primary-hover`, `default` to `default-hover`, `danger` to `danger-hover`. Applies only on devices that can hover. |
| Pressed | Buttons scale down: 0.98 at `sm`, 0.97 at `md`, 0.96 at `lg`. |
| Focus | 2px `focus` ring with a 2px offset (flush on text fields). |
| Selected | `primary-soft` fill with `primary-soft-foreground` text, or a solid `primary` indicator. |
| Loading | A spinner replaces the icon, the label stays, and the control ignores pointer events without dimming. |
| Error | 1px `danger` outline on the field (a 2px `danger` ring while focused) and a `body-sm` message under it that says how to fix it. The message is `danger` on light and `danger-soft-foreground` on dark. |
| Disabled | 50% opacity, `not-allowed` cursor, no pointer events. |

### Motion

Motion follows HeroUI. Default easing is `ease`; fills and shadows use ease-out (`cubic-bezier(0, 0, 0.2, 1)`), drawers use `cubic-bezier(0.32, 0.72, 0, 1)`. Overlays animate only transform and opacity.

| What | Timing |
|---|---|
| Button, close button, pagination link | Press scale 250ms; fill 100ms |
| Field fill and focus ring | 150ms |
| Tab color | 150ms; the indicator slides in 250ms |
| Accordion | Chevron 250ms; panel height and opacity 200ms |
| Popover, menu, tooltip | Enter with fade and scale from 0.9 in 150ms; exit in 100ms |
| Dialog | Backdrop fades in 150ms and out 100ms; the panel scales from 1.05 to 1 in 250ms and exits in 100ms |
| Toast | Enter 350ms, exit 250ms |

Everything above stops when the user prefers reduced motion.

## Do's and Don'ts

- Do use `primary` for one main action per screen.
- Do pair every background token with a text color that meets 4.5:1.
- Do use semantic variants (`danger`, not "red button").
- Do keep radii and spacing on the defined scales.
- Do copy the HeroUI v3 component (structure, variants, sizes, radius, motion, states) when adding a new one, and record it in this file.
- Do use Lucide for every icon, at 16px by default (20px inside a button below 640px) with the default 2px stroke and `currentColor`, so the icon follows its text token and the primary; never mix in another icon set.
- Don't add borders to cards or fields. Use shadow and tone.
- Don't hardcode colors or invent values. Use the tokens here, so a new primary reaches every component.
- Don't use the primary for status. The primary means brand and action, green means success.
- Don't remove focus rings or animate layout properties such as width, height or margin.
