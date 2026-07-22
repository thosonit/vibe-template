---
version: "1.0"
name: Corporate Design Tokens
description: Shared design tokens and guidelines for a corporate-style interface — light surfaces, navy accent, and a clean professional tone.
colors:
  primary: "#003469"
  primary-hover: "#00284F"
  primary-active: "#001D38"
  on-primary: "#FFFFFF"
  accent: "#F5A623"
  accent-hover: "#DB9110"
  on-accent: "#1A1A1A"
  success: "#1E9E5A"
  success-bg: "#E6F6ED"
  warning: "#F0A500"
  warning-bg: "#FFF6E0"
  error: "#D64545"
  error-bg: "#FCEAEA"
  info: "#2E7FD6"
  info-bg: "#E9F2FC"
  background: "#F7F8FA"
  surface: "#FFFFFF"
  border: "#E1E4E8"
  text-primary: "#111827"
  text-secondary: "#5B6472"
  text-disabled: "#9CA3AF"
typography:
  display:
    fontFamily: system-ui, -apple-system, "Segoe UI", Roboto, sans-serif
    fontSize: 32px
    fontWeight: 700
    lineHeight: 1.2
  h1:
    fontFamily: "{typography.display.fontFamily}"
    fontSize: 24px
    fontWeight: 700
    lineHeight: 1.3
  h2:
    fontFamily: "{typography.display.fontFamily}"
    fontSize: 20px
    fontWeight: 600
    lineHeight: 1.35
  h3:
    fontFamily: "{typography.display.fontFamily}"
    fontSize: 16px
    fontWeight: 600
    lineHeight: 1.4
  body:
    fontFamily: "{typography.display.fontFamily}"
    fontSize: 14px
    fontWeight: 400
    lineHeight: 1.5
  body-sm:
    fontFamily: "{typography.display.fontFamily}"
    fontSize: 13px
    fontWeight: 400
    lineHeight: 1.45
  caption:
    fontFamily: "{typography.display.fontFamily}"
    fontSize: 12px
    fontWeight: 500
    lineHeight: 1.4
    letterSpacing: 0.02em
rounded:
  sm: 4px
  md: 8px
  lg: 12px
  full: 999px
spacing:
  xs: 4px
  sm: 8px
  md: 12px
  lg: 16px
  xl: 24px
  2xl: 32px
  3xl: 48px
  4xl: 64px
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.lg}"
    typography: "{typography.body}"
  button-primary-hover:
    backgroundColor: "{colors.primary-hover}"
  button-secondary:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.primary}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.lg}"
  button-accent:
    backgroundColor: "{colors.accent}"
    textColor: "{colors.on-accent}"
    rounded: "{rounded.md}"
    padding: "{spacing.sm} {spacing.lg}"
  button-icon:
    backgroundColor: transparent
    textColor: "{colors.text-secondary}"
    hoverBackground: "{colors.background}"
    hoverTextColor: "{colors.text-primary}"
    rounded: "{rounded.md}"
    size: 36px
  button-icon-danger:
    hoverBackground: "{colors.error-bg}"
    hoverTextColor: "{colors.error}"
  card:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.lg}"
    padding: "{spacing.lg}"
  input:
    backgroundColor: "{colors.surface}"
    textColor: "{colors.text-primary}"
    rounded: "{rounded.sm}"
    padding: "{spacing.sm} {spacing.md}"
    height: 40px
  badge-success:
    backgroundColor: "{colors.success-bg}"
    textColor: "{colors.success}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs} {spacing.md}"
    typography: "{typography.caption}"
  badge-warning:
    backgroundColor: "{colors.warning-bg}"
    textColor: "{colors.warning}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs} {spacing.md}"
    typography: "{typography.caption}"
  badge-error:
    backgroundColor: "{colors.error-bg}"
    textColor: "{colors.error}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs} {spacing.md}"
    typography: "{typography.caption}"
  badge-info:
    backgroundColor: "{colors.info-bg}"
    textColor: "{colors.info}"
    rounded: "{rounded.full}"
    padding: "{spacing.xs} {spacing.md}"
    typography: "{typography.caption}"
  table-header:
    backgroundColor: "{colors.background}"
    textColor: "{colors.text-secondary}"
    typography: "{typography.caption}"
  modal-backdrop:
    backgroundColor: "rgba(17, 24, 39, 0.45)"
  modal:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.lg}"
    shadow: lg
    padding: "{spacing.xl}"
  toast:
    rounded: "{rounded.md}"
    shadow: md
    padding: "{spacing.md} {spacing.lg}"
    typography: "{typography.body-sm}"
  tooltip:
    backgroundColor: "{colors.text-primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.sm}"
    padding: "{spacing.xs} {spacing.sm}"
    typography: "{typography.caption}"
    shadow: md
  dropdown-select:
    backgroundColor: "{colors.surface}"
    border: "1px solid {colors.border}"
    rounded: "{rounded.sm}"
    padding: "{spacing.sm} {spacing.md}"
    height: 40px
    focusBorder: "{colors.primary}"
  checkbox:
    border: "1px solid {colors.border}"
    rounded: "{rounded.sm}"
    size: 18px
    checkedBackground: "{colors.primary}"
    checkedIcon: "{colors.on-primary}"
  radio:
    border: "1px solid {colors.border}"
    rounded: "{rounded.full}"
    size: 18px
    checkedBorder: "{colors.primary}"
    checkedDot: "{colors.primary}"
  multiselect-chip:
    backgroundColor: "{colors.info-bg}"
    textColor: "{colors.info}"
    rounded: "{rounded.sm}"
    padding: "{spacing.xs} {spacing.sm}"
    typography: "{typography.body-sm}"
  search-input:
    backgroundColor: "{colors.surface}"
    border: "1px solid {colors.border}"
    rounded: "{rounded.sm}"
    padding: "{spacing.sm} {spacing.md}"
    height: 40px
    iconColor: "{colors.text-secondary}"
  sidebar:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    width: 240px
  sidebar-item-active:
    backgroundColor: "{colors.primary-hover}"
    accentBar: "{colors.accent}"
    accentBarWidth: 3px
  tabs:
    textColor: "{colors.text-secondary}"
    activeTextColor: "{colors.text-primary}"
    activeUnderline: "{colors.accent}"
    typography: "{typography.body}"
  segmented-control:
    backgroundColor: "{colors.background}"
    rounded: "{rounded.full}"
    activeBackground: "{colors.surface}"
    activeShadow: sm
  pagination-item-active:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.on-primary}"
    rounded: "{rounded.sm}"
  filter-bar:
    backgroundColor: "{colors.surface}"
    border: "1px solid {colors.border}"
    rounded: "{rounded.md}"
    padding: "{spacing.md} {spacing.lg}"
  stat-tile:
    backgroundColor: "{colors.surface}"
    rounded: "{rounded.lg}"
    padding: "{spacing.lg}"
    shadow: sm
    valueTypography: "{typography.h1}"
    labelTypography: "{typography.body-sm}"
  progress-bar:
    trackColor: "{colors.background}"
    fillColor: "{colors.primary}"
    rounded: "{rounded.full}"
    height: 8px
  avatar:
    backgroundColor: "{colors.info-bg}"
    textColor: "{colors.primary}"
    rounded: "{rounded.full}"
    size: 36px
  empty-state:
    iconColor: "{colors.text-disabled}"
    iconSize: "{icons.size-lg}"
    padding: "{spacing.2xl}"
    headingTypography: "{typography.h3}"
    descriptionTypography: "{typography.body-sm}"
  spinner:
    color: "{colors.primary}"
    trackColor: "{colors.border}"
icons:
  library: lucide-react
  size-sm: 16px
  size-md: 20px
  size-lg: 24px
  strokeWidth: 2
---

## Overview

This design language is Corporate/Professional: light surfaces, generous whitespace, and a navy accent (`#003469`) used sparingly for primary actions and selected states. It uses a system font stack for fast loading, moderate corner radii for a polished but restrained look, and a consistent spacing system for interface rhythm.

## Colors

| Token | Value | Use |
|---|---|---|
| `primary` | `#003469` | Primary actions, interactive focus, selected states |
| `primary-hover` / `primary-active` | derived from `primary` | Hover and active states for primary controls |
| `accent` | `#F5A623` | Secondary highlights and supporting calls to action |
| `success` / `warning` / `error` / `info` (+ `-bg`) | see token | Semantic status and feedback states |
| `background` | `#F7F8FA` | Page and surface background |
| `surface` | `#FFFFFF` | Cards, panels, modals, and controls |
| `border` | `#E1E4E8` | Input, card, and table borders |
| `text-primary` / `text-secondary` / `text-disabled` | see token | Typography hierarchy and text states |

Principle: navy is a reserved accent for key actions and selected states — avoid using it as the dominant page background or surface color to maintain a light, calm interface.

## Typography

Use a system font stack (`system-ui, -apple-system, "Segoe UI", Roboto, sans-serif`) to reduce external dependencies and improve performance.

Scale: `display` (32px) → `h1` (24px) → `h2` (20px) → `h3` (16px) → `body` (14px) → `body-sm` (13px) → `caption` (12px).

## Layout

Use the 4px-based spacing scale consistently: `xs` (4px), `sm` (8px), `md` (12px), `lg` (16px), `xl` (24px), `2xl` (32px), `3xl` (48px), `4xl` (64px). Apply it uniformly to padding, margin, and gaps rather than using ad hoc values.

- Maintain clear surface hierarchy with `background` for page-level areas and `surface` for cards, sheets, and panels.
- Prefer whitespace and subtle surface shifts over heavy border decoration.
- Keep content layouts flexible to support both dashboard-style and content-first interfaces.

## Elevation & Depth

Use three shadow levels with light, unobtrusive box shadows. Avoid heavy borders combined with strong shadows.

- `sm`: cards, small panels, segmented control active states
- `md`: dropdowns, popovers, tooltips, toast notifications
- `lg`: modals and important overlays

Modals and dialogs use a dark backdrop with `rgba(17, 24, 39, 0.45)` and no backdrop blur, preserving a clear corporate look.

## Icons

Use **Lucide** (`lucide-react`) with outline style and `strokeWidth: 2`. Do not use emoji for functional icons. Use `currentColor` so icons inherit the contextual text color.

Sizes:
- `sm` (16px) for badges, inputs, and small indicators
- `md` (20px) for buttons, navigation, and list actions
- `lg` (24px) for empty states and larger UI elements

## Shapes

- `rounded.sm` (4px): compact controls and small badges
- `rounded.md` (8px): default buttons, cards, and standard inputs
- `rounded.lg` (12px): modals and larger panels
- `rounded.full`: pill-shaped badges and chips

## Components

Refer to the front matter `components` section for token definitions. Core groups include `button-primary`, `button-secondary`, `button-accent`, `button-icon`, `card`, `input`, semantic badges, and `table-header`.

`button-icon` is intended for icon-only secondary actions. It should remain visually lightweight, reveal a subtle background on hover, and always include a descriptive `title` or `aria-label`.

Extended component groups:
- Overlay & feedback: `modal`, `modal-backdrop`, `toast`, `tooltip`, `spinner`
- Form controls: `dropdown-select`, `checkbox`, `radio`, `multiselect-chip`, `search-input`
- Navigation: `sidebar`, `sidebar-item-active`, `tabs`, `segmented-control`, `pagination-item-active`, `filter-bar`
- Data display: `stat-tile`, `progress-bar`, `avatar`, `empty-state`

Semantic badge colors map to state meaning consistently across interfaces:
- success states → `badge-success`
- warning states → `badge-warning`
- error states → `badge-error`
- informational states → `badge-info`

Status icons should follow semantic color usage: `check` for success, `x` for error, and `clock` for pending or neutral states.

## Do's and Don'ts

**Do:**
- Use navy (`primary`) for one main action or selected state per screen to preserve visual priority.
- Use whitespace and surface contrast (`background` vs `surface`) to establish hierarchy instead of heavy borders.
- Keep semantic badge colors consistent across screens.
- Use `table-header` for muted table headings rather than a strong branded color.
- Reserve navy-heavy surfaces for navigation or branded accents, not for the full page background.
- Use Lucide icons for functional interface elements.

**Don't:**
- Do not use navy as the primary page or content background. Keep it as an accent for buttons, selected states, and navigation highlights.
- Do not introduce colors outside the defined palette without adding them as tokens first.
- Do not deviate from the defined corner radius scale: `sm`, `md`, `lg`, and `full`.
- Do not use accent yellow for error or warning semantics; it is reserved for secondary highlights.
- Do not use backdrop blur for overlays. Keep overlays clear and professional.

- Không tự ý thêm màu ngoài palette đã định nghĩa cho badge/button — mọi màu mới phải thêm vào token trước khi dùng.
- Không dùng bo góc khác 3 mức đã định nghĩa (sm/md/lg) — tránh giao diện thiếu nhất quán.
- Không dùng accent (`#F5A623`) cho trạng thái lỗi/cảnh báo — accent chỉ dành cho CTA phụ, không mang ý nghĩa semantic.
- Không dùng backdrop-blur (glassmorphism) cho modal/overlay — giữ phong cách corporate rõ ràng.
