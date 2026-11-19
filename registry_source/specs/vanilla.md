# Vanilla spec

Vanilla is Remix's default preset: a neutral, minimal theme inspired by
shadcn/ui's default theme (style `new-york-v4`, base color `neutral`, on
Tailwind v4). This file records the reference values Vanilla takes, where they
come from, and where Vanilla deliberately differs. The aim is "close, not perfect": the same palette, scale,
geometry, and states, rendered by Flutter rather than by a browser.

## Source

| | |
|---|---|
| Repository | [`shadcn-ui/ui`](https://github.com/shadcn-ui/ui) |
| Commit | `db2db460a26fa84fb65c8d903b213925fbdee9ed` (2026-09-28) |
| Theme | `apps/v4/registry/themes.ts`, entry `neutral` (the same values as `public/r/colors/neutral.json`) |
| Components | `apps/v4/registry/new-york-v4/ui/*.tsx` |
| Typography | `apps/v4/registry/new-york-v4/examples/typography-*.tsx`, the Typography page's examples: utility classes on plain elements, with no `ui/` component |
| Utilities | Tailwind CSS v4.3.3 defaults (spacing, type scale, shadows, transition) |

The canonical theme is the registry's `neutral` entry, not the docs site's own
`app/globals.css`. The reference authors colors in OKLCH; the hex values below are the
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

`VanillaTokens` names match the reference's CSS variables (`card-foreground`
is `cardForeground`). Light / dark:

| Token | Light | Dark | Reference (light / dark) |
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
derived from it, and never go below zero:

| Token | Formula | Value |
|---|---|---|
| `radiusSm` | radius − 4 | 6 |
| `radiusMd` | radius − 2 | 8 |
| `radiusLg` | radius | 10 |
| `radiusXl` | radius + 4 | 14 |

**Type.** Tailwind's `text-*` sizes and line heights, with no tracking. Each
step is a `TextStyleToken` carrying the family, size, and line height, with
`TextLeadingDistribution.even` so text sits in its line box as CSS places it.
Recipes choose weights independently: most use 400, 500 (`font-medium`),
or 600 (`font-semibold`), and h1 asks for 800 (`font-extrabold`).

| Token | Size / line height |
|---|---|
| `textXs` | 12 / 16 |
| `textSm` | 14 / 20 (body copy and control labels) |
| `textBase` | 16 / 24 |
| `textLg` | 18 / 28 |
| `textXl` | 20 / 28 |
| `text2xl` | 24 / 32 |
| `text3xl` | 30 / 36 |
| `text4xl` | 36 / 40 |
| `textMono` | 14 / 20 in `monoFontFamily` |

**Font.** Geist and Geist Mono, from `package:remix_ui_fonts`.
`VanillaThemeData.light()` and `.dark()` set `fontFamily` to
`RemixFonts.geist` and `monoFontFamily` to `RemixFonts.geistMono`, so the
installed `theme` item declares `remix_ui_fonts` and every Vanilla install
carries the fonts. A null `fontFamily` leaves the family to the platform, and
a null `monoFontFamily` uses `fontFamily`.

**Spacing.** Tailwind's 4px grid, as constants on `VanillaTokens` in `theme/tokens.dart`:
`VanillaTokens.s0_5` (2) through `s16` (64). Spacing is not a token: the
reference does not theme it, and arithmetic on an unresolved token cannot be
written.

**Control sizes.** `h-8`, `h-9`, `h-10`: 32, 36, 40. Icons `size-4` (16), with
`size-3.5` (14) for sort indicators and `size-3` (12) beside `text-xs`.

**Shadows.** `VanillaShadow` in `theme/effects.dart`, black at the given alpha:

| Level | Layers (y, blur, spread, alpha) |
|---|---|
| `xs` | (1, 2, 0, 5%) |
| `sm` | (1, 3, 0, 10%) + (1, 2, −1, 10%) |
| `md` | (4, 6, −1, 10%) + (2, 4, −2, 10%) |
| `lg` | (10, 15, −3, 10%) + (4, 6, −4, 10%) |

**Motion.** `VanillaTokens.motion`: 150ms on `Curves.fastOutSlowIn`, which is
Tailwind's `transition` default, `cubic-bezier(0.4, 0, 0.2, 1)`.

**Focus.** `focus-visible:ring-[3px] ring-ring/50`: a 3px band of `ring` at 50%,
drawn outside the control with no offset. A control with a border also turns
its border `ring` (`focus-visible:border-ring`). Text fields and text areas
ring on any focus, including a click (see Deviations). A toggle-group option
draws the band inside itself (see Deviations).

**Disabled.** Opacity 0.5; colors are unchanged.

## Components

Heights, padding, and gaps are logical pixels. "md", "sm", and "xl" radii are
the steps above. The source column names the file under
`apps/v4/registry/new-york-v4/ui/`, or under `apps/v4/registry/new-york-v4/`
for an `examples/` file, with the lines the values come from.

| Component | Target | Source |
|---|---|---|
| Button | h 32/36/40; px 12/16/24; gap 6/8/8; `text-sm` w500 at every size; icon 16; radius md | `button.tsx` |
| Button fills | primary, hover primary/90; secondary, hover secondary/80; destructive, hover /90 (dark: /60, hover /70); ghost hover accent (dark accent/50) | `button.tsx` |
| Button outline | border `input`; fill `background` (dark `input`/30); `shadow-xs`; hover `accent` (dark `input`/50) | `button.tsx` |
| Icon button | 32/36/40 squares, icon 16, the button's fills | `button.tsx` (`icon-*` sizes) |
| Link | `text-sm`, underline on hover | `button.tsx` (`link`) |
| Breadcrumbs | list `text-sm` muted-fg on one line; gap 10 between steps and separators; steps keep their width while the trail fits, then share what the separators leave, shortest first; link `font-normal`, hover foreground with no underline, the Link focus ring; a step without a page muted-fg; current page `font-normal` foreground, never a link; separator ChevronRight 14 muted-fg, outside semantics, mirrored in RTL (see Deviations); a navigation landmark labelled `Breadcrumb` | `breadcrumb.tsx` (`Breadcrumb`, `BreadcrumbList`, `BreadcrumbLink`, `BreadcrumbPage`, `BreadcrumbSeparator`) |
| Badge | radius full; 1px border on every variant, transparent except outline; `text-xs` w500; px 8, py 2 | `badge.tsx` |
| Heading | `h1` `text4xl` w800 centered; `h2` `text3xl` w600 with a 1px `border` rule below 8px of padding; `h3` `text2xl` w600; `h4` `textXl` w600. All use `foreground` and −0.025em tracking; semantics default to levels 1–4. | `examples/typography-h1.tsx` through `typography-h4.tsx`, L3 |
| Text | `p` `textBase` on a 28px line, `lead` `textXl` muted-fg, `large` `textLg` w600, `small` `textSm` w500 on a 14px line, `muted` `textSm` muted-fg, `blockquote` `textBase` italic with a 2px `border` rule at the start and 24px between the rule and text. Other weights are w400; other colors are `foreground`. | `examples/typography-p.tsx`, `typography-lead.tsx`, `typography-small.tsx`, `typography-muted.tsx`, `typography-blockquote.tsx` L3; `typography-large.tsx` L2 |
| Code | `textMono` (14 / 20) w600 (see Deviations) `foreground` on a `muted` chip; px 4, py 2, radius 4 (see Deviations); plain text to assistive technology | `examples/typography-inline-code.tsx` L3 |
| Kbd | h 20 (see Deviations), min-w 20, px 4, radius sm; `muted` fill; `text-xs` w500 muted-fg in the sans family, centered; inside a tooltip (the `tooltip` variant) `background`/20 fill (dark /10) and `background` text; plain text to assistive technology | `kbd.tsx` L3–16 (`Kbd`: classes L8, tooltip rule L10) |
| Kbd group | keys in a row, gap 4, centered on one line; one semantics node | `kbd.tsx` L18–26 (`KbdGroup`: classes L22) |
| Toggle | h 32/36/40, min-w equal to h; px 6/8/10; `text-sm` w500; hover muted + muted-fg; on accent + accent-fg; outline adds an `input` border and `shadow-xs` | `toggle.tsx` |
| Toggle group | items px 12, radius 0 inside a clipped md container, gap 0; outline adds the border | `toggle-group.tsx` |
| Text field | h 36; px 12, py 4; border `input`, transparent fill, `shadow-xs`; `text-sm`; placeholder muted-fg | `input.tsx` |
| Text area | min-h 64; px 12, py 8 | `textarea.tsx` |
| Search field | the text field's box: h 36, border `input`, `shadow-xs`, radius md, the field's focus ring, disabled fade; search icon 16 muted-fg, 12 from the start and 8 before the text; clear button a 24 ghost square, radius sm, icon 16 muted-fg (hover `accent` and accent-fg), 8 after the text and 4 from the end, shown only while enabled, editable, and not empty; Escape clears (see Deviations); keyboard action `search` | `input-group.tsx` (`InputGroup`, `InputGroupAddon` inline-start and inline-end, `InputGroupButton` `size="icon-xs"`), `input.tsx` |
| Field label and helper | label `text-sm` w500, gap 8; helper `text-sm` muted-fg; error helper `destructive` | `label.tsx`, `field.tsx` |
| Combobox | TextField recipe field (36px minimum); Select-like popover panel with border, radius md, p 4, effects shadow md, 8px gap, max height 320px, min width 128px; rows controlSm minimum, px 8, py 6, radius sm, text-sm popover-foreground; 1px row gap; stable label weight across states; keyboard highlight accent, hover accent at 85%, press primary at 18% light / 20% dark; accent-foreground labels; caller overrides last | Designed from the Sol combobox brief, reusing `input.tsx` and `select.tsx`; Remix owns a persistent scroll cue; RawAutocomplete pins the panel to the field width. No selected-option API; rows that `isOptionDisabled` marks have no disabled style yet. |
| Select trigger | the text field's metrics, gap 8; chevron 10 at 50% (see Deviations) | `select.tsx` |
| Select content | `popover` fill, border, radius md, `shadow-md`, p 4, min-w 128, never narrower than the trigger (the default `item-aligned` position) | `select.tsx` |
| Select item | h 32; px 8, py 6 (see Deviations); radius sm; highlight accent; check 10 muted-fg | `select.tsx` |
| Checkbox | 16, radius 4, border `input`, `shadow-xs`; checked primary; check 10 (see Deviations); no hover fill; label `text-sm` w500, gap 12 | `checkbox.tsx`, `label.tsx` |
| Radio | 16, border `input` in both states, `shadow-xs`; dot 8 primary; label `text-sm` w500, gap 12 | `radio-group.tsx`, `label.tsx` |
| Switch | 32 × 18.4, transparent 1px border, `shadow-xs`; off `input` (dark input/80), on primary; thumb 16, no border; label `text-sm` w500, gap 8 | `switch.tsx`, `label.tsx` |
| Slider | 48px hit area; pill rail 6 muted-fg (light) / ring (dark), range primary; white thumb 16, 1px primary (light) / primary-fg (dark) border, `shadow-sm`; opaque 2px hover halo at 40%, 6px pressed halo at 65%, contiguous 3px primary focus ring | `slider.tsx`; local slider polish |
| Range slider | shares Slider's tokens and geometry for both independently styled thumbs; interval runs between the bounds; 48px hit area, RTL follows Remix | `slider.tsx`; Remix range-slider contract |
| Tabs (filled) | list h 36, p 3, radius lg, muted; tab radius md, px 8, py 4, gap 6; inactive foreground/60; active background + `shadow-sm` | `tabs.tsx` |
| Tabs (line) | transparent list; active tab marked by a 2px `foreground` underline | `tabs.tsx` (`variant=line`) |
| Segmented control | styled as the filled tab list | `tabs.tsx` |
| App bar | `background` fill; toolbar h 64 including a `border` bottom hairline, px 16; gap 12 between leading, title, and actions and between actions; title `text-lg` w600 | none (see Deviations) |
| Sidebar | `sidebar` fill, `sidebarBorder` edge; content p 8, section gap 16 | `sidebar.tsx` |
| Sidebar destination | h 32, px 8, py 6 (see Deviations), gap 8, radius md; hover and current `sidebarAccent`, current w500 | `sidebar.tsx` (`SidebarMenuButton`) |
| Sidebar label | h 32, px 8, `text-xs` w500, `sidebarForeground`/70, no tracking | `sidebar.tsx` (`SidebarGroupLabel`) |
| Sidebar layout | collapsed width 48 | `sidebar.tsx` (`SIDEBAR_WIDTH_ICON`) |
| Menu | content as the select's; items h 32, px 8, py 6, radius sm; icons muted-fg even when highlighted, choice check and submenu chevron 10 (see Deviations); separator full-bleed | `dropdown-menu.tsx` |
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

| Where | Reference | Vanilla | Why |
|---|---|---|---|
| `mutedForeground`, light | `#737373` | `#707070` | 4.54:1 on `muted`, so a muted caption on a muted surface clears the 4.5:1 text floor. `#737373` measures 4.35:1 there. |
| Destructive fill, dark, hover | `/90` | `/70` | At 90% the light dark-theme red measures about 3.5:1 against its white label. Rest stays at 60%. |
| `destructiveForeground` | hardcoded `text-white` | a token, `#FFFFFF` | Keeps the pairing editable in one place. |
| Pressed state | none | none | Vanilla dropped its old pressed step: a press lands on the hover fill. An 80% destructive fill would fail 4.5:1 with the new red. |
| Button padding with an icon | `has-[>svg]:px-3` | the size's padding | A recipe cannot see its children. |
| Text field size | `text-base` below `md` | `text-sm` everywhere | Flutter has no viewport-conditional recipe; 14 is the desktop value. |
| Checkbox, select, and menu 9×9 glyphs | `size-3.5` (14) / `size-4` (16) | 10 (`VanillaTokens.s2_5`) | The reference sizes padded 24×24 Lucide icons; Remix draws edge-to-edge 9×9 paths (`thickCheck`, `chevronDown`, `thickChevronRight`), which match the painted mark at 10. |
| Select trigger vertical padding | `px-3 py-2`, `data-[size=default]:h-9` | 36 min height, `py-1` (4), the text field's | CSS fixes the height and lets the 20px line overrun the padding; Flutter lays the line out inside the padding and border, so `py-2` would make a 38px trigger beside a 36px text field. |
| Select item horizontal padding | `pl-2 pr-8` (8 / 32) | `px-2` (8) | CSS positions the check mark inside the 32px right gutter (`right-2`); Remix lays the check mark out in the row after the label, so `px-2` places it 8px from the trailing edge. |
| Slider and range slider | hover and focus ring | press uses a stronger, wider halo | Keeps grab feedback visible on touch devices, which do not hover. |
| Toggle group, outline | per-item borders sharing edges | one border on the clipped group | A recipe cannot tell the first and last items apart. |
| Toggle group, outline | `shadow-xs` | no shadow | Flutter paints a decoration shadow under the whole box, where it shows through a transparent fill as a gray wash. Controls that draw `shadow-xs` in the effects layer cut the box out as CSS does, but the strip has no effects layer. |
| Chart palette | gray ramp | gray ramp | The reference's lightest series measures about 1.5:1 on the light page, and the darkest two (`chart4`, `chart5`) about 1.3 to 1.8:1 on the dark page and card; Vanilla keeps the palette and picks each pie label from `foreground` or `background` by contrast (`vanillaPieSliceLabelColor`). |
| Slider rail and feedback | muted rail, shared 4px ring/50 | mid-gray pill rail; opaque surface-aware hover/press halos, contiguous primary keyboard ring | Keep rail ends visible, distinguish input states, and avoid uneven translucent rings over the interval. Both recipes reserve a 48px gesture target. Supply `surfaceColor` on cards or tinted panels so halos blend against the actual surface. The dark thumb border separates overlapping white handles. |
| Focus ring | `ring/50`, 3px | `ring` at 50%, 3px | Matches the reference, which is below the 3:1 non-text floor: about 1.5:1 on the light page and 1.85:1 on the dark. The old Vanilla `focusRing` cleared 3:1. Raise the band's alpha in the recipes, or darken `ring`, where focus visibility matters more than matching. |
| Toggle group option focus | band drawn outside, the focused item lifted with `focus-visible:z-10` | the same 3px band drawn inside the option | The group clips its options to the rounded strip, which would crop an outside band on the first and last option, and a filled neighbor painted after the focused option would cover its side of one. A recipe cannot lift an option above its neighbors, so the band goes inside. |
| Text field and text area focus | `focus-visible:` | any focus (`onFocused`) | Browsers treat a focused text input as `:focus-visible` even after a click, but Mix's `onFocusVisible` does not, so the recipe keys the ring on `onFocused` to show it on click as the reference does. Other controls stay on `onFocusVisible`. |
| Breadcrumbs layout | `flex flex-wrap break-words gap-1.5 sm:gap-2.5` | one line: every step at its natural width while the trail fits, otherwise fair shares of what the separators and gaps leave, with a step shorter than its share kept whole and the longer ones ellipsized; 10 (`s2_5`) everywhere | A trail is a page header's title, so it keeps the header's one-line height instead of wrapping it taller. 10 is the reference's `sm:` (640px and up) gap: Flutter has no viewport-conditional recipe, as with the text field's `md:text-sm`. |
| Breadcrumb separator | `ChevronRight` in both directions | mirrored in right-to-left text | The chevron points from a parent to its child; unmirrored it would point back up the trail in RTL. |
| Breadcrumb ellipsis | `BreadcrumbEllipsis`: a `size-9` box with `MoreHorizontal` (16) and an `sr-only` "More" | not ported | It is a static glyph that the reference pairs with a caller-built dropdown of the hidden steps; `breadcrumbs` takes plain items and ellipsizes long steps instead of collapsing them. Compose a `menu` for a collapsed trail. |
| Breadcrumb link focus and current page | `BreadcrumbLink` has no focus style (the browser outline); `BreadcrumbPage` is `role="link" aria-disabled aria-current="page"` | the Link recipe's 3px `ring/50` band; the current page is plain text | Vanilla rings every keyboard-focused control. Flutter semantics have no current-page state, and a disabled link adds a link role with nothing to follow. |
| Search field clearing | an `InputGroupButton` the caller shows and wires; Escape is the browser's | built in: the button shows only while the field is enabled, editable, and not empty; clearing reports `''` to `onChanged` and keeps focus in the field; Escape clears when there is text and spends that press's key repeats, so holding it does not go on to the dialog; during an input-method composition it stays with the input method; with nothing to clear it passes up | A search field nearly always wants a way to clear the query, so Vanilla builds the button and Escape in instead of leaving every caller to wire the addon, track emptiness, and restore focus. Passing Escape up only when there is nothing to clear keeps an enclosing dialog closable without one press doing both. |
| Search field clear button | `icon-xs`: `size-6`, `rounded-[calc(var(--radius)-5px)]` (5), 4.8 from the end (`pr-3` less `-mr-[0.45rem]`) | 24 square, `radiusSm` (6), 4 (`s1`) from the end | Vanilla's radius steps start at radius − 4 and its spacing steps are whole 2px multiples, so the nearest steps stand in. The 24px square meets the WCAG 2.5.8 minimum but not touch guidance; a larger one would grow the field past the text field's 36px. |
| Heading, Text, and Code | no `ui/` components; the Typography page styles plain elements | `heading`, `text`, and `code` | Vanilla gives the styles reusable recipes and the item names Fortal already uses. |
| Typography layout | scroll anchor offsets, vertical margins, and `text-balance` on h1 | normal Flutter wrapping; scroll and spacing left to the parent | The recipe does not own the scrolling container, neighboring blocks, or line-breaking strategy. Pass a width constraint to make an h2 rule span the content. |
| Typography color and direction | ordinary text inherits page foreground; blockquote rule stays on the left | explicit `foreground` and a rule on the leading side | The color does not depend on the host's default text style; the rule mirrors in RTL. |
| Typography list and table | `typography-list.tsx` and `typography-table.tsx` examples | not part of `text` | Lists lay out markers beside wrapped items, and tables are covered by `data_table`. |
| Code padding | `px-[0.3rem] py-[0.2rem]` (4.8 / 3.2) around an inline box | 4 (`s1`) across and 2 (`s0_5`) down, around the 20px line | Vanilla's spacing steps are whole 2px multiples. CSS paints an inline element's fill around the font's content area, 18.2px for Geist Mono at 14px, so the reference chip is about 25px tall; Flutter's box wraps the 20px line, and 2px above and below gives 24 where 4 would give 28. |
| Code radius | `rounded`, a fixed 0.25rem (4) that `--radius` does not move | `radiusSm` clamped to 4 | The same 4 at the shipped radius; following the theme below 4 keeps a square theme square, as the checkbox does. |
| Code color and wrapping | inherits the paragraph's color; the chip breaks with the line | `foreground`; one chip that wraps inside itself | In running text the chip is a `WidgetSpan`, which does not pass the paragraph's style down and lays its child out as one box. |
| Kbd height | `h-5`: a fixed 20px box, the 16px line centered by `items-center` | 2px (`s0_5`) above and below the 16px line, 20px at 100% text | CSS fixes the box and lets the line sit inside it; Flutter lays the line out inside the padding, so a fixed 20px box would clip the label once the text scales. The padding gives the same 20px cap and grows with the text. |
| Kbd in a tooltip | `[[data-slot=tooltip-content]_&]:bg-background/20 text-background dark:bg-background/10`, applied by the ancestor | the `tooltip` variant (`VanillaKbd.tooltip`) | A recipe cannot see its ancestors, so the caller picks the inverted cap inside a tooltip's content. |
| Kbd icons | `[&_svg:not([class*='size-'])]:size-3` and `gap-1` for an icon child | not ported: a key is text | Every reference example (`examples/kbd-*.tsx`) draws its keys as text or Unicode key symbols (⌘ ⇧ ⌥ ⌃ ⏎), which a `Text` draws too. Geist has no ⌘, ⌥, ⌃, or ⏎, so those come from the platform's fallback font. |
| Kbd interaction | `pointer-events-none select-none` | neither | A key cap has no gesture handler, so a tap on it already reaches the control around it, as the reference's pass-through does. Flutter text is selectable only inside a `SelectionArea`, where a key is selected with the sentence it sits in. |
| Kbd semantics | `<kbd>`, which has no role, read inline with the text around it | plain text; a group is one merged node; no `keyboardKey` flag | Flutter would stop at each key of a shortcut, so `VanillaKbdGroup` merges its keys into one phrase. Flutter's `keyboardKey` flag marks a key of an on-screen keyboard, which a key cap is not. |
| Callout, destructive | description at `destructive/90` | one text color for the whole callout | `CalloutSpec` has a single text role, so the description cannot take its own color. |
| Current filled tab, dark | `bg-input/30` over the list | `input` at 30% pre-blended over `muted`, opaque | Flutter paints the tab's `shadow-sm` under the whole box, so a translucent fill would show it through and darken the tab. The shadow stays a decoration shadow rather than moving to the tab's effects layer. |
| App bar | no `ui/` primitive | the header the Vanilla dashboard already shipped | shadcn builds page headers inline in its blocks. Vanilla keeps the dashboard's metrics so the `app_bar` item and the dashboard shell look the same, and names the row height `vanillaAppBarToolbarHeight` so a sidebar header can line up with it. |
| Sidebar destination padding | `h-8 p-2` | 32 min height, 8px across and 6px down | CSS fixes the height and lets the 20px line overrun the padding; Flutter lays the line out inside it, so `p-2` would make a 36px row. |
| Sidebar layout, dashboard shell | 48 collapsed | 48 for `sidebar_layout`; the dashboard shell keeps its own 72 | The dashboard shell is out of this spec's scope. |
| Tooltip delay | `delayDuration = 0` on the provider | 0 | Matches; recorded because Vanilla used to wait 500ms. |
| Font | Geist and Geist Mono | Geist and Geist Mono from `remix_ui_fonts` | The bundled faces are static (Geist 400, 500, 600, 700; Geist Mono 400, 500). The closest bundled weights are 700 for h1's 800 and 500 for inline code's 600. Blockquote italics use synthesized slant. |

## Calendar recipes (designed from the Vanilla scale)

These are native recipe decisions using the existing Vanilla palette and
scales rather than claiming upstream calendar parity. `calendar` and
`range_calendar` install hand-written facades because `CalendarSpec` has no
generator target. Ghost IconButton navigation follows the outer day columns;
Select captions retain intrinsic text height and scale their minimum width.
Their minimum height matches the 48px navigation target, keeping the visible
header controls flush with the calendar’s 12px content inset.

- Geometry: square `s12` day targets, scaling with text when the viewport allows;
  `radiusSm` corners, `textSm` labels and `textXs` muted weekdays. Container
  padding is `s3`, header-to-weekday spacing `s2`, and weekday-to-first-week
  spacing `s1`. Equal zero row/column gutters preserve connected range bands.
- Ordinary days rest transparent, hover in accent, and press in primary at
  22% / 32% (light / dark). Today uses a ring-token hairline and semibold label.
  Selection uses primary / primaryForeground, retaining that family at 90%
  on hover and 80% on press. Focus uses the shared inset ring plus a contrasting
  inner keyline without changing day geometry.
- Disabled ordinary days use mutedForeground and disabledOpacity. Disabled
  selections and the previous committed range while drafting use primary at
  18% / 28% with full-opacity mutedForeground, keeping the selection recognizable.
  Unavailable dates additionally strike through.
- Range endpoints use primary caps with directional corners. Interiors use
  primary at 9% / 24%, stepping to 15% / 32% on hover and 22% / 40% on press.
  Preview uses primary at 12% / 20% with a 60% primary perimeter hairline;
  blocked previews use full-strength destructive labels without a tinted fill.
- Pickers merge caller child stylers last over outline Button, Popover, calendar,
  ghost IconButton and Select recipes. The panel retains its rounded border and
  shadow with a `s1` offset. The calendar owns the single `s3` padding layer;
  the outer panel adds no padding. Width follows the seven day targets, calendar
  padding and panel border. Trigger icons use mutedForeground and scale with text.
  Bounded range labels use compact endpoints or wrap to retain both dates.

The Vanilla spec, state, layout and pixel focus suites enforce these decisions;
calendar recipe tests cover real day and range states in both theme modes.
