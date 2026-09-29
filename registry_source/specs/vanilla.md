# Vanilla: the shadcn/ui target

Vanilla is Remix's default preset. Its look is shadcn/ui's default theme:
style `new-york-v4`, base color `neutral`, on Tailwind v4. This file records the
values Vanilla takes from shadcn, where they come from, and where Vanilla
deliberately differs. The aim is "close, not perfect": the same palette, scale,
geometry, and states, rendered by Flutter rather than by a browser.

## Source

| | |
|---|---|
| Repository | [`shadcn-ui/ui`](https://github.com/shadcn-ui/ui) |
| Commit | `db2db460a26fa84fb65c8d903b213925fbdee9ed` (2026-09-28) |
| Theme | `apps/v4/registry/themes.ts`, entry `neutral` (the same values as `public/r/colors/neutral.json`) |
| Components | `apps/v4/registry/new-york-v4/ui/*.tsx` |
| Utilities | Tailwind CSS v4.3.3 defaults (spacing, type scale, shadows, transition) |

The canonical theme is the registry's `neutral` entry, not the docs site's own
`app/globals.css`. shadcn authors colors in OKLCH; the hex values below are the
sRGB conversions, rounded to the nearest 8-bit channel.

## How this is enforced

- `registry_source/test/vanilla/vanilla_spec.dart` holds the component targets
  below as data. `spec_conformance_test.dart` resolves each recipe and compares.
  A target is `pending` until the recipe is moved onto it, then `enforced`.
- `state_distinguishability_test.dart` resolves every interactive recipe at rest
  and in each state, and fails when a state paints the same as rest, or paints
  its fill in the `border` color.
- `theme_scope_test.dart` checks that a bare `Text` below the root scope reads in
  the theme's body run and `foreground` under every host.
- `tool/check_vanilla_scale.dart` (`melos run vanilla:scale:check`) reports
  numeric literals in `components/*.dart` that are off the spacing and type
  scale. Its allowlist may only shrink.
- `open_code/fixture/test/open_code_test.dart` pins the token values and the
  installed recipes in a fresh consumer.

## Tokens

`VanillaTokens` names match shadcn's CSS variables (`card-foreground` is
`cardForeground`). Light / dark:

| Token | Light | Dark | shadcn (light / dark) |
|---|---|---|---|
| `background` | `#FFFFFF` | `#0A0A0A` | `oklch(1 0 0)` / `oklch(0.145 0 0)` |
| `foreground` | `#0A0A0A` | `#FAFAFA` | `oklch(0.145 0 0)` / `oklch(0.985 0 0)` |
| `card`, `popover` | `#FFFFFF` | `#171717` | `oklch(1 0 0)` / `oklch(0.205 0 0)` |
| `cardForeground`, `popoverForeground` | `#0A0A0A` | `#FAFAFA` | `oklch(0.145 0 0)` / `oklch(0.985 0 0)` |
| `primary` | `#171717` | `#E5E5E5` | `oklch(0.205 0 0)` / `oklch(0.922 0 0)` |
| `primaryForeground` | `#FAFAFA` | `#171717` | `oklch(0.985 0 0)` / `oklch(0.205 0 0)` |
| `secondary`, `muted`, `accent` | `#F5F5F5` | `#262626` | `oklch(0.97 0 0)` / `oklch(0.269 0 0)` |
| `secondaryForeground`, `accentForeground` | `#171717` | `#FAFAFA` | `oklch(0.205 0 0)` / `oklch(0.985 0 0)` |
| `mutedForeground` | `#707070` | `#A1A1A1` | `oklch(0.556 0 0)` (`#737373`) / `oklch(0.708 0 0)` |
| `destructive` | `#E7000B` | `#FF6467` | `oklch(0.577 0.245 27.325)` / `oklch(0.704 0.191 22.216)` |
| `destructiveForeground` | `#FFFFFF` | `#FFFFFF` | `text-white` in `button.tsx` and `badge.tsx` |
| `border` | `#E5E5E5` | white at 10% | `oklch(0.922 0 0)` / `oklch(1 0 0 / 10%)` |
| `input` | `#E5E5E5` | white at 15% | `oklch(0.922 0 0)` / `oklch(1 0 0 / 15%)` |
| `ring` | `#A1A1A1` | `#737373` | `oklch(0.708 0 0)` / `oklch(0.556 0 0)` |
| `chart1`–`chart5` | `#D4D4D4`, `#737373`, `#525252`, `#404040`, `#262626` | same | `oklch(0.87 / 0.556 / 0.439 / 0.371 / 0.269 0 0)` |
| `sidebar` | `#FAFAFA` | `#171717` | `oklch(0.985 0 0)` / `oklch(0.205 0 0)` |
| `sidebarForeground` | `#0A0A0A` | `#FAFAFA` | `oklch(0.145 0 0)` / `oklch(0.985 0 0)` |
| `sidebarPrimary` | `#171717` | `#1447E6` | `oklch(0.205 0 0)` / `oklch(0.488 0.243 264.376)` |
| `sidebarPrimaryForeground` | `#FAFAFA` | `#FAFAFA` | `oklch(0.985 0 0)` |
| `sidebarAccent` | `#F5F5F5` | `#262626` | `oklch(0.97 0 0)` / `oklch(0.269 0 0)` |
| `sidebarAccentForeground` | `#171717` | `#FAFAFA` | `oklch(0.205 0 0)` / `oklch(0.985 0 0)` |
| `sidebarBorder` | `#E5E5E5` | white at 10% | `oklch(0.922 0 0)` / `oklch(1 0 0 / 10%)` |
| `sidebarRing` | `#A1A1A1` | `#737373` | `oklch(0.708 0 0)` / `oklch(0.556 0 0)` |

## Scales

**Radius.** One `radius` field, 10 (`--radius: 0.625rem`). The steps are
derived as shadcn derives them, and never go below zero:

| Token | Formula | Value |
|---|---|---|
| `radiusSm` | radius − 4 | 6 |
| `radiusMd` | radius − 2 | 8 |
| `radiusLg` | radius | 10 |
| `radiusXl` | radius + 4 | 14 |

**Type.** Tailwind's `text-*` sizes and line heights, with no tracking. Each
step is a `TextStyleToken` carrying the family, size, and line height, with
`TextLeadingDistribution.even` so text sits in its line box as CSS places it.
Weights are 400, 500 (`font-medium`), and 600 (`font-semibold`).

| Token | Size / line height |
|---|---|
| `textXs` | 12 / 16 |
| `textSm` | 14 / 20 (body copy and control labels) |
| `textBase` | 16 / 24 |
| `textLg` | 18 / 28 |
| `textXl` | 20 / 28 |
| `text2xl` | 24 / 32 |
| `text3xl` | 30 / 36 |
| `textMono` | 14 / 20 in `monoFontFamily` |

**Font.** Geist and Geist Mono, from `package:remix_ui_fonts`. Until that
package is published, `fontFamily` and `monoFontFamily` default to null and
the platform family renders.

**Spacing.** Tailwind's 4px grid, as constants in `theme/scale.dart`:
`VanillaSpace.s0_5` (2) through `s12` (48). Spacing is not a token: shadcn does
not theme it, and arithmetic on an unresolved token cannot be written.

**Control sizes.** `h-8`, `h-9`, `h-10`: 32, 36, 40. Icons `size-4` (16), with
`size-3.5` (14) for check marks and `size-3` (12) beside `text-xs`.

**Shadows.** `VanillaShadow` in `theme/effects.dart`, black at the given alpha:

| Level | Layers (y, blur, spread, alpha) |
|---|---|
| `xs` | (1, 2, 0, 5%) |
| `sm` | (1, 3, 0, 10%) + (1, 2, −1, 10%) |
| `md` | (4, 6, −1, 10%) + (2, 4, −2, 10%) |
| `lg` | (10, 15, −3, 10%) + (4, 6, −4, 10%) |

**Motion.** `VanillaMotion.standard`: 150ms on `Curves.fastOutSlowIn`, which is
Tailwind's `transition` default, `cubic-bezier(0.4, 0, 0.2, 1)`.

**Focus.** `focus-visible:ring-[3px] ring-ring/50`: a 3px band of `ring` at 50%,
drawn outside the control with no offset. A control with a border also turns
its border `ring` (`focus-visible:border-ring`).

**Disabled.** Opacity 0.5; colors are unchanged.

## Components

Heights, padding, and gaps are logical pixels. "md", "sm", and "xl" radii are
the steps above. The source column names the file under
`apps/v4/registry/new-york-v4/ui/`.

| Component | Target | Source |
|---|---|---|
| Button | h 32/36/40; px 12/16/24; gap 6/8/8; `text-sm` w500 at every size; icon 16; radius md | `button.tsx` |
| Button fills | primary, hover primary/90; secondary, hover secondary/80; destructive, hover /90 (dark: /60, hover /70); ghost hover accent (dark accent/50) | `button.tsx` |
| Button outline | border `input`, fill `background`, `shadow-xs`, hover accent | `button.tsx` |
| Icon button | 32/36/40 squares, icon 16, the button's fills | `button.tsx` (`icon-*` sizes) |
| Link | `text-sm`, underline on hover | `button.tsx` (`link`) |
| Badge | radius full; 1px border on every variant, transparent except outline; `text-xs` w500; px 8, py 2; icon 12 | `badge.tsx` |
| Toggle | h 32/36/40, min-w equal to h; px 6/8/10; `text-sm` w500; hover muted + muted-fg; on accent + accent-fg; outline adds `input` border + `shadow-xs` | `toggle.tsx` |
| Toggle group | items px 12, radius 0 inside a clipped md container, gap 0; outline adds the border and `shadow-xs` | `toggle-group.tsx` |
| Text field | h 36; px 12, py 4; border `input`, transparent fill, `shadow-xs`; `text-sm`; placeholder muted-fg | `input.tsx` |
| Text area | min-h 64; px 12, py 8 | `textarea.tsx` |
| Field label and helper | label `text-sm` w500, gap 8; helper `text-sm` muted-fg; error helper `destructive` | `label.tsx`, `field.tsx` |
| Select trigger | the text field's metrics, gap 8; chevron 16 at 50% | `select.tsx` |
| Select content | `popover` fill, border, radius md, `shadow-md`, p 4, min-w 128 | `select.tsx` |
| Select item | h 32; pl 8, pr 32, py 6; radius sm; highlight accent | `select.tsx` |
| Checkbox | 16, radius 4, border `input`, `shadow-xs`; checked primary; check 14; no hover fill | `checkbox.tsx` |
| Radio | 16, border `input` in both states, `shadow-xs`; dot 8 primary | `radio-group.tsx` |
| Switch | 32 × 18.4, transparent 1px border, `shadow-xs`; off `input` (dark input/80), on primary; thumb 16, no border | `switch.tsx` |
| Slider | rail 6 muted, range primary; thumb 16, 1px primary border, white, `shadow-sm`; 4px ring/50 on hover and focus | `slider.tsx` |
| Tabs (filled) | list h 36, p 3, radius lg, muted; tab radius md, px 8, py 4, gap 6; inactive foreground/60; active background + `shadow-sm` | `tabs.tsx` |
| Tabs (line) | transparent list; active tab marked by a 2px `foreground` underline | `tabs.tsx` (`variant=line`) |
| Segmented control | styled as the filled tab list | `tabs.tsx` |
| Sidebar | `sidebar` fill, `sidebarBorder` edge; content p 8, section gap 16 | `sidebar.tsx` |
| Sidebar destination | h 32, p 8, gap 8, radius md; hover and current `sidebarAccent`, current w500 | `sidebar.tsx` (`SidebarMenuButton`) |
| Sidebar label | h 32, px 8, `text-xs` w500, `sidebarForeground`/70, no tracking | `sidebar.tsx` (`SidebarGroupLabel`) |
| Sidebar layout | collapsed width 48 | `sidebar.tsx` (`SIDEBAR_WIDTH_ICON`) |
| Menu | content as the select's; items h 32, px 8, py 6, radius sm; label `text-sm` w500; separator full-bleed | `dropdown-menu.tsx` |
| Accordion, disclosure | trigger py 16, no px, `text-sm` w500, underline on hover; chevron 16 muted-fg; content pb 16 | `accordion.tsx` |
| Card | `card` fill, border, radius xl, `shadow-sm`, p 24 | `card.tsx` |
| Dialog | radius lg, border, `shadow-lg`, p 24, max-w 512; title `text-lg` w600; description `text-sm` muted-fg; gap 8 | `dialog.tsx` |
| Popover | `popover` fill, border, radius md, `shadow-md`, p 16, w 288 | `popover.tsx` |
| Toast | `popover` fill, border, radius lg, w 356, shadow (0, 4, 12, 10%), description 14 | `sonner.tsx` (sonner defaults) |
| Tooltip | `foreground` fill, radius md, px 12, py 6, `text-xs` `background`; delay 0 | `tooltip.tsx` |
| Callout | radius lg, border, `card` fill, px 16, py 12, gap 12, `text-sm`; destructive text, description destructive/90 | `alert.tsx` |
| Data table | header h 40, no fill, px 8, `text-sm` w500 foreground; cells p 8; row min 36; row hover muted/50, selected muted; frame radius md | `table.tsx` |
| Avatar | 32; fallback muted, `text-sm` muted-fg; icon 16 | `avatar.tsx` |
| Skeleton | `accent`, pulsing to accent/50; radius md | `skeleton.tsx` |
| Progress | h 8, track primary/20, indicator primary, radius full | `progress.tsx` |
| Spinner | 16 | `spinner.tsx` |
| Chart | tooltip px 10, py 6, radius lg, border/50, `text-xs`; axis labels `text-xs` | `chart.tsx` |

## Deviations

| Where | shadcn | Vanilla | Why |
|---|---|---|---|
| `mutedForeground`, light | `#737373` | `#707070` | 4.54:1 on `muted`, so a muted caption on a muted surface clears the 4.5:1 text floor. `#737373` measures 4.35:1 there. |
| Destructive fill, dark, hover | `/90` | `/70` | At 90% the light dark-theme red measures about 3.5:1 against its white label. Rest stays at shadcn's 60%. |
| `destructiveForeground` | hardcoded `text-white` | a token, `#FFFFFF` | Keeps the pairing editable in one place. |
| Pressed state | none | none | Vanilla dropped its old pressed step: a press lands on the hover fill. An 80% destructive fill would fail 4.5:1 with the new red. |
| Outline button, dark | `bg-input/30`, hover `bg-input/50` | `background`, hover `accent` | One fill rule for both brightnesses; the difference is a few percent of lightness. |
| Button padding with an icon | `has-[>svg]:px-3` | the size's padding | A recipe cannot see its children. |
| Text field size | `text-base` below `md` | `text-sm` everywhere | Flutter has no viewport-conditional recipe; 14 is the desktop value. |
| Toggle group, outline | per-item borders sharing edges | one border on the clipped group | A recipe cannot tell the first and last items apart. |
| Chart palette | gray ramp | gray ramp | shadcn's lightest series measures about 1.5:1 on the light page; Vanilla keeps the palette and picks each pie label from `foreground` or `background` by contrast (`vanillaPieSliceLabelColor`). |
| Sidebar layout, dashboard shell | 48 collapsed | 48 for `sidebar_layout`; the dashboard shell keeps its own 72 | The dashboard shell is out of this spec's scope. |
| Tooltip delay | `delayDuration = 0` on the provider | 0 | Matches; recorded because Vanilla used to wait 500ms. |
| Font until `remix_ui_fonts` is published | Geist | platform family | `fontFamily` stays null so installs do not depend on an unpublished package. |
