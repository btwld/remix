# Fortal specification

Fortal is an independent, Fortaleza-inspired design system on Remix and Naked
UI. This specification, not another component library, owns its visual contract.
The [machine-readable catalog](fortal_catalog.json) lists every shipped family,
its axes, constructor defaults, and behavior. The public component APIs remain
size-linked recipes over Remix; no behavioral component is reimplemented.

## Sources and decisions

The [design provenance](../docs/fortal/refresh-brief.md) records the original
Fortaleza brief. On 2026-11-02, the color decision changed to paired themes
using **@radix-ui/colors 3.0.0**. The [pinned source snapshot](fortal_radix_colors.json)
contains the package integrity, complete MIT notice, exact sRGB opaque and alpha
scales, and the approved pairings. `tool/fortal_palettes/radix/extract.mjs` imports
the package's structured exports. Geometry, components, behavior and contrast
requirements remain Fortal's; this is a color-data adoption, not a Radix widget port.
The [architecture decision](../../../ARCHITECTURE.md#fortal-owns-its-visual-contract-fortal-adr-0003)
records this update. Remix Icons remain the icon source.

## Paired themes

Select one named theme with `FortalTheme(accent: .mar, child: child)`. The existing
`FortalAccentColor` name is retained, but each value now selects its accent and
subtly tinted neutral together. There is no separate gray selector, `gray`
configuration parameter, or `FortalGrayColor` enum. Upstream gray names are
implementation details, not additional Fortal themes.

| Theme | Dart value | Radix accent | Paired neutral |
| --- | --- | --- | --- |
| Orla | `orla` | Gray | Gray |
| Mar | `mar` | Teal | Sage |
| Céu | `ceu` | Blue | Slate |
| Serra | `serra` | Gold | Olive |
| Sol | `sol` | Amber | Sand |
| Duna | `duna` | Brown | Sand |
| Caju | `caju` | Orange | Sand |

Orla is the default. Page backgrounds use the paired neutral's step 1; solid
panels and surface inputs use step 2. The optional translucent panel computes
an overlay that reconstructs that step-2 color over its own page. The imported
alpha scale stays unchanged. Serra now has a muted gold accent and Duna a brown
accent; their names identify these approved combinations, not the former seeds.

Error roles keep the separate generated red `fortalError` (seed `#C92E3B`,
installed as `<prefix>Error`). Error is not a theme choice. Status examples
must retain labels or icons because similar accent hues cannot carry meaning alone.
A custom `accentPalette` inherits the selected named theme's neutral pairing;
when no theme is specified it uses Orla's neutral. A named accent clears an
inherited custom accent, as before.

## Raw scales and functional roles

Each imported appearance keeps all twelve opaque and twelve alpha steps exactly
as published. sRGB values are used; `#RRGGBBAA` alpha values are converted to
Dart ARGB, and six-digit entries in an alpha scale are fully opaque. The generator
and source-fidelity tests check both modes against the pinned snapshot.

| Steps | Upstream role |
| --- | --- |
| 1–2 | Page and subtle backgrounds |
| 3–5 | Rest, hover and selected fills |
| 6–8 | Borders of increasing strength |
| 9–10 | Accent swatch and hover |
| 11–12 | Secondary and strong text |

Raw Radix steps do not by themselves guarantee Fortal's WCAG contrast thresholds
in every Flutter component and state. Functional colors keep that contract without
rewriting the source scales:

- `accentSolid` and `accentSolidHover` pair with `accentContrast` at **4.5:1**
  or more. White labels use the source fills when they meet the 4.6:1 generation
  margin; otherwise the labelled fill is deepened in OKLCH, and its hover is
  0.035 lightness deeper. Sol uses the source Amber-12 warm-brown ink with
  the original Amber fills. Source swatches remain the unmodified steps 9–10.
- `accentIndicator` and `accentTrack` identify selected marks and ranges.
  `accentMarkHover` is their hover/pressed fill; it defaults to source step 10.
  Non-luminous light marks are deepened only when their paired page/panel
  needs the 3.05:1 margin. `markContrast` is white when it keeps 3:1 on both
  the indicator and functional mark hover; otherwise it uses the source family's deep
  light-mode step 12. Custom palettes retain the validated ink fallback.
- `accentContent` and `accentContentAlpha` retain the source step-11 colors
  where they pass. Otherwise they move toward the strong source text tone in
  premultiplied OKLab, to keep **4.5:1** on soft fills 3–5 over the theme's page
  and panel. Recipes use these content roles, not raw step 11, for normal text.
- `focus8` fits source step 8 toward step 12 only as needed for **3:1** on
  the page and panel. Empty soft controls use this solid ring rather than
  relying on their low-contrast tint alone. Focus stays 2px wide with a 2px gap, except the contiguous slider ring
  specified below.
- `controlBorder` fits neutral step 8 toward neutral step 12 for **3:1** on
  the page, panel and off-track fill. Disabled controls keep quieter strokes.
- Selected surface switch and slider thumbs stay white. Their `accentThumbRing`
  uses the mark ink on a bright fill or hover, the track when it is visible on
  surrounding surfaces, and otherwise the neutral control border. Selected soft
  thumbs use accessible accent content; high contrast keeps the source knockout.

### Orla primary-role override

Orla deliberately uses a stronger default than standard Radix Gray. In light
mode, labelled solids and selected marks/tracks use Gray-12 `#202020`, hover
`#303030`, and white ink. In dark mode they use true white, Gray-12 `#EEEEEE`
on hover, and Gray-1 `#111111` ink. The white thumb retains a 2px dark ring.
Raw opaque/alpha scales, Gray-2 panels, secondary text, soft variants, focus and
disabled roles remain unchanged. This is a Fortal functional-role policy,
not a claim that Radix's default gray accent is white or black.

Ordinary solid press lightens under dark ink unless that returns to the idle
fill within 2/255 per RGB channel; then it darkens the hover by 0.92 instead.
Orla dark therefore retains distinct white/near-white/pressed states. Explicit
`highContrast` variants retain their existing source step-12/step-1 treatment;
in dark mode that fill is slightly dimmer than Orla's default white.

### Contrast requirements (both appearances)

The component and rendered-pixel gates retain their thresholds:

- Label ink on normal, hovered and pressed labelled solids: **4.5:1**.
- Normal functional content on soft fills and neutral surfaces: **4.5:1**.
- Strong source text on source fills 1–5: **7:1**.
- Mark ink, focus rings, empty control boundaries, and the white thumb or its
  outline on the track: **3:1**.
- Bare progress tracks and filled extents: a fully covered **3:1** band on
  the page, solid and translucent panels.

These guarantees cover Fortal's own surfaces; arbitrary image backgrounds and
hand-authored custom palettes need contextual checks. The former comparative
OKLab separation floor for Fortal-generated named seeds is retired: imported
families retain upstream values, and chart/status examples keep labels or icons.

### Custom palette generation

`generate.dart --name brand --seed '#8038CC'` still generates a separate OKLCH
brand palette. The generated brand and dedicated error red use WCAG luminance,
Björn Ottosson's OKLab equations, and the existing gamut and role fitting.
Custom generation uses the pinned Orla gray page/panel reference values; the
source-fidelity tests distinguish these designed values from imported scales.

Near-white custom seeds can blend into the page even with readable labels.
Use an available `highContrast: true` treatment or a visible outline when the
fill must identify the control. Check the actual component on its host surface.

## Fixed scales and geometry

- Spacing: **4, 8, 12, 16, 24, 32, 40, 48, 64px**, multiplied by scaling.
  Component and agent recipes use these tokens whenever a dimension has an equivalent step.
  Specialized measurements (20px icons, tiny indicators, em-relative inline
  typography, and bounded agent viewports) remain named tokens or proportions.
  The select trigger chevron is the reference's fixed 9px glyph (11px at size
  3), named by `selectTriggerIndicatorSize12`/`3`, and deliberately does not
  follow scaling (Radix Themes 3.3.0 `icons.tsx` L53–58, `select.css`
  L209–212); its item check marks do scale.
- Type: **12, 14, 16, 18, 20, 24, 28, 36, 60px**. Accordion and disclosure
  size 2 use `text2`, not an intermediate 15px style. Text8 has a 40px line box.
  Fortal sets no font family; the application supplies it, as the
  [registry contract](../../open_code/REGISTRIES.md#preset-and-generation-contract)
  states.
- Radius: `none`, `small`, `medium` (default), `large`, `full`; scaling:
  90, 95, 100 (default), 105, 110 percent. `highContrast` remains available.
- Control radii follow Radix Themes 3.3.0 per size. Buttons, icon buttons and
  select triggers use radius 1/2/3 (`base-button.css` L45–55, `select.css`
  L165–199); text fields, text areas and segmented controls use radius 2/2/3
  (`text-field.css` L192–245, `text-area.css` L79–105,
  `segmented-control.css` L251–275). At size 1 a field is therefore 1px
  rounder than a button or select beside it; this is intended.
- Toggles at sizes 1–3 have the Button minimum heights, 24/32/40px, labelled or
  icon-only, with content centred and horizontal padding only. They grow
  beyond that only when their content is taller, as with enlarged text.
- Compact painted controls retain their sizes, inside a **40px minimum hit
  target**, which does not shrink at 90/95% scaling. Hosts must leave room for
  that target instead of imposing a smaller tight constraint.
- Focus: one **2px solid functional `focus8` outline, 2px outside** the painted control.
  The helper reads `focusRingWidth` and `focusRingOffset`; it never changes
  layout or replaces a variant's border. Text inputs show it on focus; other
  controls show it on keyboard-visible focus. Disabled controls do not ring.
  Sortable table headers measure the outline from inside their cell padding,
  keeping the complete ring visible within the table's rounded clip.

## Components

`classic` is absent from button, icon button, card, checkbox, radio, switch,
slider, progress, text field, text area, segmented control, and kbd. There are
no aliases or deprecations. Kbd defaults to its sole `soft` variant; segmented
control retains its sole `surface` variant. Other variants and behavioral APIs
are listed in the catalog. Toast's independent `classic` floating treatment is
not a raised-card/control variant and uses the ordinary elevation scale.

Cards and controls have no blurred/offset shadows or gradients. Crisp inset
frames are borders, not elevation. Menus, popovers, dialogs, tooltips, and
toasts retain outer elevation; a shadow means the surface floats.

Fortal's elevation shadows carry no ring, so the anchored menu, select,
popover and combobox panels share a 1px gray-7 edge. Radix Themes 3.3.0 gives
its menu, select and popover panels one edge through the ring inside
`--shadow-5` (`shadow.css` L26–29, `base-menu.css` L184). The menu paints its
edge as a foreground decoration, so items sized to a panel width keep it.

Surface text fields and text areas use an opaque gray-2 fill and the
`controlBorder` frame, so a field without a visible label can still be found;
soft fields and areas keep their accent-3 fill inside a fitted `focus8` ring,
the recipe's base frame so caller frames still win. Error replaces either
frame with error step 8, and disabled clears the soft ring (error keeps its
precedence). Enabled surface input hints use secondary gray content; enabled
soft input hints and icons use secondary accent content. Disabled input
treatments stay separate.

Select triggers keep their gray-7 frame (gray alpha 8 when open or hovered):
their value and chevron identify them. A trigger always paints its value or
placeholder and a gray-12 chevron (at least 11.5:1 on gray-2), so under WCAG
1.4.11 its frame (about 1.5:1) is not the information that identifies it; a
text field can be empty and unlabelled, so its frame is. Radix Themes 3.3.0
frames both with gray-a7 (`select.css` L299, `text-field.css` L286); Fortal
strengthens only the field.

Selected surface switch thumbs are white with a 2px `accentThumbRing`, or
`accent1` against the high-contrast `accent12` track. Selected soft thumbs use
`accentContent`, promoted to `accent12` at high contrast. Off thumbs stay white with
a 1px `controlBorder` ring on a track edged in `controlBorder`; the selected
surface track keeps its quiet gray-alpha-5 edge. Disabled switches keep a
neutral gray-2 thumb with a gray-6 border and drop the active track edge
(surface keeps the quiet edge, soft has none), whatever the selection, focus
or press state. Slider thumbs are white with a 2px `accentThumbRing` in light
and gray3 in dark; the thumb
is identified by its fill or its ring. The soft slider range is step 6 alone,
with no accent alpha layered over it. Geometry and state precedence are shared.

Progress bars carry their value without text, in two extents. The whole track
(gray alpha 3, or gray alpha 4 for soft) is edged in a 1px inset
`controlBorder`, so the total stays readable at 0. The surface fill is the
track role with a 1px inset `accentThumbRing` outline: seamless where the fill
already contrasts, warm brown on bright Sol fills. The soft fill is
the fitted `focus8` role, which keeps 3:1 on the page and panels. High contrast fills with
step 12 and no outline. Height, radius, value and semantics are unchanged.

Solid button hover and press recolor only the fill. Hover uses `solidHover`. Press
applies the brightness and saturation operations to the fill colour itself: darker
(brightness 0.92, saturate 1.1) under a light label, lighter (brightness 1.08)
under a deep ink, so the label keeps its contrast. High-contrast hover and
press recolor the step-12 fill with their light/dark operation sets. No solid
state filters the painted subtree, so labels, icons, spinners and the focus
ring keep their colours, and `fortalClearFilter()` still clears a caller's
own filter when disabled.

The polish board presents all families and sizes in light/dark pairs on a 4px
grid. Check padding against height, text centering, matched icon size/gap,
40px hit targets, and distinct hover/press/disabled states in both modes.
Caller style overrides are always merged last.

## Combobox

Combobox promotes `apps/demo/lib/components/combobox.dart` into the registry.
Its surface/soft and size1/size2/size3 axes match TextField; it calls the same
field recipe, including disabled colors and the focus outline without layout
shift. The floating panel uses colorPanel, gray7 border, radius3, shadow3,
space1 padding, space2 gap and a gray9 overflow thumb. Remix owns fades and
scrolling. Rows grow from 24/32/32px minima, with space3 horizontal and 6px
vertical padding, radius2, text1/2/3 and gray12 labels. A transparent 1px
accent8 border reserves keyboard highlight geometry. Hover uses accentA3,
keyboard highlight accentA5 with the accent8 border, and press accentA7.
Acceptance appears as the field value; there is no persistent selected or
per-option disabled state. No preset behavior is added. Test coverage includes
both modes, every accent, field matrices, contrast and RTL at 200% text.

## Enforcement

- `tool/check_fortal.dart` (`melos run fortal:check`) holds the catalog against
  source enums, defaults, public constructors, recipe inventory, and tests.
- `tool/fortal_palettes/generate.dart --check` rejects palette drift.
- `test/fortal/palette_contrast_test.dart` checks labels on the labelled
  pair, marks on the mark fill, alpha soft labels composited over their tints,
  and the ramp targets for every accent and the error red. It also covers
  non-curated/extreme brand seeds, dark mark placement, family inks, distinct
  hovers for marks and labelled solids, and Fortal's own comparative
  separation of mark fills and labelled solids between accents and the error
  red, plus the `controlBorder` and `accentThumbRing` guarantees.
- `test/fortal/fortal_on_solid_ink_test.dart` resolves real button, badge,
  checkbox, radio and switch styles for every palette in both modes through
  idle, hover and press. Labels must read `contrast` on the labelled fill;
  checks and dots the derived mark ink on the indicator; switch thumbs white
  with their outline.
- `test/fortal/fortal_custom_palette_roles_test.dart` covers hand-authored
  split palettes (bright indicator beside a deep labelled solid), reuse of a
  supplied ink only where it reaches 3:1, five-argument constructors, a solid
  without hover, a deep track against a dark page, and the two-argument
  `computeAccentThumbRing` call.
- `test/dashboard/dashboard_theme_panel_test.dart` renders the theme panel and
  checks every selected accent swatch's tick on its fill, idle, hovered and
  pressed, in both modes.
- `test/fortal/fortal_control_contrast_render_test.dart` renders mounted
  controls on the page, solid panel and translucent panel for every palette
  and both modes, and measures painted pixels: empty checkbox/radio outlines,
  off and selected switch thumbs, slider thumbs, progress track and fill
  extents at 0, part and full, text input borders, and solid
  and high-contrast button labels and focus rings through hover, press and
  focus combinations, including a real pointer hover followed by a press.
- `test/fortal/spec_conformance_test.dart` checks theme defaults, token values,
  error roles independent of accents and custom palettes, flat surfaces, filled
  fields, and scaling.
- Focus, control matrices, keyboard/semantics and theme-scope tests retain
  Remix/Naked UI behavior coverage. Fortal-owned goldens cover both modes.
- `tool/generate_fortal_catalog.dart --check`, `docs:check`, registry derivation,
  and installed-consumer checks prevent source/documentation/distribution drift.

### Slider and range slider

`range_slider` installs `FortalRangeSlider`, depending on the shared `slider`
recipe. Both use `FortalSliderSize` (size1–size3), `FortalSliderVariant`
(surface, soft), and high contrast. The demo's reviewed slider treatment is the
source for their shared polish: 48px interaction height at normal scaling,
accentA7/2px hover halo, accentA6/space1 press halo with an accent12 edge,
and a contiguous accent11/2px visible-focus ring. The zero focus gap prevents
rail-coloured notches between neighbouring handles. Dark idle handles use a
neutral gray3 edge. Disabled sliders show gray5 rail, gray8 interval and a
gray4 light / gray9 dark face with gray9 hairline, using srcOver in both modes;
interaction halos are suppressed. Per-thumb state belongs to Remix.
Two ordered values, minimum spacing, snapping, RTL and semantics retain Remix's
API. Custom value formatters use the base widget with the recipe.

## Calendar and picker families

The design source is the reviewed Appointment date and Reporting period stories
in `apps/demo/lib/components/{calendar,range_calendar,date_picker,date_range_picker}.dart`
at d8ad0b877 (calendar polish round 4). These are Fortal designs, not reference
ports. Four independently installable hand-written composites retain Remix's
controlled civil-date APIs; CalendarSpec has no widget generator target, and
pickers combine five independently overridable child stylers.

- Calendar: 44px minimum day targets scale with text; seven columns plus space3
  padding. Navigation retains 44px targets; its space4 chevrons scale with text,
  as do the 9px selector indicators. Select captions have 146px scaled widths,
  touchTargetMin minimum height, and space2 horizontal padding. Text2 days,
  text1 gray11 weekdays, space2 header gap, space1 weekday and row gaps, radius3.
- Today: gray12 bold numeral and gray9 ring (range uses gray10), retaining
  selected ink when today is also selected. Ordinary days hover gray4 and press
  gray6. Selected days use accentSolid/accentContrast, 90% hover and 80% press.
  Disabled days use gray9; unavailable days add a strike.
- Ranges: directional radius3 caps in accentSolid, accent4 interiors; draft
  accent4 with accent5 caps and 2px accent8 perimeter. Blocked draft uses
  error3/error11. Stale committed selection has gray4/gray3 caps/interior in
  light, gray3 / the midpoint of gray2 and gray3 in dark, distinct from the live middle. Keyboard day focus
  uses the reviewed 2px border contour; dark uses gray11 so it separates from
  accent8, light uses focus8. This inset day treatment preserves connected bands.
- Pickers: outline Button, calendar icon scaled from space4, gray10 placeholder,
  focus8 open border, Popover with zero extra padding and 480px scaled maximum.
  Single/range trigger width floors are 200/260px scaled; labels and formatting
  stay caller-owned. Nested selector panels cap at six touchTargetMin steps
  (240px at normal scale), scaled with text, with a persistent gray9 scroll cue.
- Caller styles merge last. `summaryBuilder`, localized labels, RTL and range
  semantics pass through unchanged. No new date or interaction machinery.

The calendar regression suite exercises both modes, actual pointer and keyboard
states, geometry, contrast and 200% RTL. The polish board adds all four families
to Inputs, so its Linux Inputs master must be regenerated on Linux.
