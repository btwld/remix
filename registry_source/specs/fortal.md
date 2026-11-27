# Fortal specification

Fortal is an independent, Fortaleza-inspired design system on Remix and Naked
UI. This specification, not another component library, owns its visual contract.
The [machine-readable catalog](fortal_catalog.json) lists every shipped family,
its axes, constructor defaults, and behavior. The public component APIs remain
size-linked recipes over Remix; no behavioral component is reimplemented.

In the catalog, `recipe` overrides the family ID when locating its Dart file.
An axis with `enumOwner` uses that family's enum. The owner can set `enumRecipe`
when its enum declarations live outside its widget recipe.

## Sources and decisions

Fortal's visual values are its own foundation. The colour literals live in
[`fortal_colors.json`](fortal_colors.json), a file of Dart colour literals
that `tool/fortal_palettes/generate.dart` renders into the installed Dart
source; the type ramp, radius ladder, shadows and motion constants are set in
the theme layer. The [design provenance](../docs/fortal/refresh-brief.md)
records the original Fortaleza brief, and the
[architecture decision](../../../ARCHITECTURE.md#fortal-owns-its-visual-contract-fortal-adr-0003)
records that Fortal owns its visual contract. Geometry, components, behavior
and the contrast gates remain Fortal's. Remix Icons remain the icon source.

## Accents and the neutral

Select an accent with `FortalTheme(accent: .mar, child: child)`. Every accent
shares one untinted neutral scale. An accent recolours the selection controls
(checkbox, radio, switch, slider, toggle group), accent text, soft tints, the
focus outline and the chart series. It never recolours the page, panels,
borders, body text or the solid button, which is ink under every accent.
There is no separate gray selector.

| Accent | Dart value | Hue | Step 9, light / dark |
| --- | --- | --- | --- |
| Orla | `orla` | neutral | `#353535` / `#bebebe` |
| Mar | `mar` | green | `#0db879` / `#53dca6` |
| Céu | `ceu` | blue | `#0562ef` / `#6ba3ff` |
| Serra | `serra` | violet | `#7747ff` / `#a78bff` |
| Sol | `sol` | amber | `#f3ad20` / `#ffcb62` |
| Duna | `duna` | coral | `#f15f55` / `#ff9386` |
| Caju | `caju` | orange | `#f48120` / `#ffad5e` |
| Jambo | `jambo` | rose | `#ed4e9d` / `#ff8bc5` |

Orla is the default. The page is neutral step 1 (white, `#141414` in dark),
input surfaces are step 2 (white, `#191919` in dark), and floating panels
(`colorPanelSolid`) are the raised surface: white in light and `#1f1f1f` in
dark, one step above the input surface. The translucent panel is the raised
surface at 88 percent. Body text is step 12 (`#0b0b0b`, `#f2f2f2` in dark),
secondary text step 11 and muted text step 10. The borders are steps 6 to 8
(`border-subtle`, `border`, `border-strong`), which in light sit lighter than
the hover fills at steps 4 and 5; the scale is role-anchored, not monotone.

Error roles keep the dedicated `fortalError` palette (installed as
`<prefix>Error`), built from the danger rose `#bb2c54` (`#f0738f` in dark).
Error is not a theme choice. Status examples must retain labels or icons
because similar hues cannot carry meaning alone. A custom `accentPalette`
takes the shared neutral. A named accent clears an inherited custom accent,
as before.

## Scales and functional roles

Each accent has twelve opaque and twelve alpha steps. Steps 9, 10 and 11
are the accent, its strong tone and that tone again; step 3 is the subtle
tint; step 8 is the strong tone at 72 percent; steps 1, 2, 4, 5, 6 and 7 are
the subtle tint at 0.25, 0.5, 1.4, 1.8, 2.4 and 3.2 times its alpha; opaque
steps 1 to 8 composite the alpha step over the page; step 12 mixes the strong
tone halfway to the foreground in OKLab.

| Steps | Role |
| --- | --- |
| 1–2 | Page tints |
| 3 | The soft fill (`accentSurface`) |
| 4–5 | Hovered and pressed soft fills |
| 6–7 | Soft borders |
| 8 | The focus outline tone |
| 9 | The accent swatch: progress fill, selected calendar day |
| 10–11 | The strong tone: a swatch's hover and accent text |
| 12 | Strong text |

Functional roles take the foundation's values as they are:

- `accentSolid` is the neutral ink (neutral step 12) under every accent,
  `accentSolidHover` the ink at 91 percent over the page, and
  `accentContrast` the page colour. Labels keep **4.5:1** or more.
- `accentIndicator`, `accentTrack` and `accentMarkHover` are the accent's
  control fill; `accentIndicatorContrast` is its glyph ink: white, a dark ink
  on amber, and `#141414` for dark Orla. `accentRange` is the slider range and
  `accentThumb` the selected switch thumb; both differ from the track only
  for dark Orla. `accentSwatchContrast` is the ink on a step-9 swatch.
- `accentContent` and `accentContentAlpha` are the strong tone.
- `focus8` and `focusA8` are the strong tone at 72 percent; `focusA5` is
  alpha step 5.
- `controlBorder` is the strong neutral border (step 8). `controlTrack`,
  `controlTrackHover` and `controlThumb` are the off state of switches and
  sliders. `accentThumbRing` is transparent: thumbs carry `shadowThumb`.
- `success`, `warning`, `info` and the seven `tone*` colours (teal, sky,
  orchid, violet, rose, amber, green) do not follow the accent.

### High contrast

The default look takes those values exactly, and some boundaries fall below
3:1: the control border and the off track on the page, the white thumb on the
light off track, and for amber and orange the control fill and its glyph.
`FortalThemeData.highContrast`, also `FortalTheme(highContrast: true)`, is
one theme-level switch that moves those roles to fitted values:
`controlBorder` and `controlTrack` toward neutral step 12 until **3:1** on
the page, panels and the off track; the accent's indicator, track and mark
hover toward its strong tone until **3:1** on the page and panels; and the
mark ink, `accentThumbRing`, `focus8`, `accentContent`, `accentContentAlpha`
and step 12 through the fitting functions in `computed.dart`. The same
functions serve a hand-authored `accentPalette`, which carries no pinned
roles. Per-family `highContrast` parameters keep their step-12 fill and
step-1 knockout treatment on top of the switch.

### Contrast requirements (high contrast, both appearances)

The component and rendered-pixel gates hold under the high contrast switch:

- Label ink on normal, hovered and pressed labelled solids: **4.5:1**.
- Normal functional content on soft fills and neutral surfaces: **4.5:1**.
- Strong text on fills 1–5: **7:1**.
- Mark ink, focus rings, empty control boundaries, and the thumb or its
  outline on the track: **3:1**.
- Bare progress tracks and filled extents: a fully covered **3:1** band on
  the page, solid and translucent panels.

The default look is held to the foundation's literals instead, in
`test/fortal/fortal_foundation_test.dart`. Labels on the ink solid, strong
text, focus rings and progress fills pass the same floors in the default look
for every accent but dark amber's strong text. These guarantees cover
Fortal's own surfaces; arbitrary image backgrounds and hand-authored custom
palettes need contextual checks.

### Custom palette generation

`generate.dart --name brand --seed '#8038CC'` generates a separate OKLCH
brand palette. The generated brand uses WCAG luminance, Björn Ottosson's
OKLab equations, and the existing gamut and role fitting against the shared
neutral's page and panel. A generated palette carries no pinned roles, so the
theme fits its content, focus, mark ink and thumb ring in both modes.

Near-white custom seeds can blend into the page even with readable labels.
Use an available `highContrast: true` treatment or a visible outline when the
fill must identify the control. Check the actual component on its host surface.

## Fixed scales and geometry

- Spacing: **4, 8, 12, 16, 24, 32, 40, 48, 64px** (`space1`–`space9`) plus the
  off-ladder **18, 20 and 56px** (`space18`, `space20`, `space56`), multiplied
  by scaling. Control heights are **32, 40, 44 and 48px**
  (`controlHeight1`–`controlHeight4`). Component and agent recipes use these
  tokens whenever a dimension has an equivalent step. Specialized measurements
  (20px icons, tiny indicators, em-relative inline typography, and bounded
  agent viewports) remain named tokens or proportions. The select trigger
  chevron is a fixed 9px glyph (11px at size 3), named by
  `selectTriggerIndicatorSize12`/`3`, and deliberately does not follow
  scaling; its item check marks do scale.
- Type: **12, 13, 15, 17, 20, 22, 28, 34, 40px** (`text1`–`text9`), plus
  `textField` at **14px** for typed text. Steps 1 to 6 are body text in Inter
  at 1.4 leading (1.2 at step 5, 1.15 at step 6) and −0.01em tracking (−0.02em
  at step 6); steps 7 to 9 are display text in Geist at 1.1 leading and
  −0.03em. Leading is split evenly around the glyphs, as a CSS line box does.
  Accordion and disclosure size 2 use `text2`. The theme sets body text to
  `RemixFonts.inter`, display text to `RemixFonts.geist` and code to
  `RemixFonts.geistMono`; the unnamed `FortalThemeData` constructor accepts a
  null family to leave it to the application. The Fortal registry therefore
  declares `remix_ui_fonts`.
- Radius: `none`, `small`, `medium` (default), `large`, `full`; scaling:
  90, 95, 100 (default), 105, 110 percent. At medium the ladder is
  **6, 10, 12, 14, 16, 20, 24px** (`radius1`–`radius7`): 14 is the control
  radius, 12 and 16 its small and large offsets, 10 the radius of items inside
  a control, 6 small marks, 20 the panel radius and 24 the surface radius.
  Other factors scale the whole ladder. `highContrast` remains available per
  family and on the theme.
- Toggles at sizes 1–3 have the Button minimum heights, 24/32/40px, labelled or
  icon-only, with content centred and horizontal padding only. They grow
  beyond that only when their content is taller, as with enlarged text.
- Compact painted controls retain their sizes, inside a **40px minimum hit
  target**, which does not shrink at 90/95% scaling. Hosts must leave room for
  that target instead of imposing a smaller tight constraint.
- Focus: one **2px `focus8` outline, 2px outside** the painted control, the
  accent's strong tone at 72 percent. The helper reads `focusRingWidth` and
  `focusRingOffset`; it never changes layout or replaces a variant's border.
  Text inputs show it on focus; other controls show it on keyboard-visible
  focus. Disabled controls do not ring. Sortable table headers measure the
  outline from inside their cell padding, keeping the complete ring visible
  within the table's rounded clip.
- Shadows: six levels. Levels 1, 3 and 5 are the resting, raised and floating
  shadows (offsets 1, 6 and 20px, blurs 2, 18 and 48px in light, each above
  level 1 with a second tight layer; one denser layer in dark); levels 2 and 4
  sit midway between their neighbours and level 6 extends level 5 by a
  quarter. `shadowThumb` is the three-layer shadow of switch and slider
  thumbs. CSS blur values are converted with `fortalBlurRadius` so Flutter's
  Gaussian matches the designed one.
- Motion: `FortalMotion` holds the durations (instant 100, fast 150, exit
  140, standard 200, considered 360ms), the eases (enter, standard, exit and
  in-out cubic béziers), the springs (responsive, gentle, snappy, smooth,
  morph and the 440ms transform spring) and the stagger steps. Motion does not
  vary with the accent, appearance, radius or scaling, so these are constants
  rather than scope tokens.

## Components

`classic` is absent from button, icon button, card, checkbox, radio, switch,
slider, progress, text field, text area, segmented control, and kbd. There are
no aliases or deprecations. Kbd has one look (`soft`) and segmented control
one (`surface`); neither takes a `variant`. Other variants
and behavioral APIs are listed in the catalog. Toast's independent `classic`
floating treatment is not a raised-card/control variant and uses the ordinary
elevation scale.

Resting cards and controls cast no shadow and carry no gradients. Crisp inset
frames are borders, not elevation. A hovered button or card may cast the
resting or raised shadow and thumbs carry `shadowThumb`; menus, popovers,
dialogs, tooltips and toasts cast the floating levels.

Fortal's elevation shadows carry no ring, so the anchored menu, select,
popover and combobox panels share a 1px gray-7 edge. The menu paints its
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
text field can be empty and unlabelled, so its frame is.

Selected surface switch thumbs are white with a 2px `accentThumbRing`
(transparent by default, the fitted ring under the theme's high contrast
switch), or `accent1` against the high-contrast `accent12` track. Selected soft thumbs use
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
Acceptance appears as the field value; there is no persistent selected state,
and rows that `isOptionDisabled` marks have no disabled style yet. No preset
behavior is added. Test coverage includes
both modes, every accent, field matrices, contrast and RTL at 200% text.

## Avatar group

Avatar group promotes the dashboard's avatar stack into the registry. It is a
hand-written row of the avatar recipe, so it adds no colors or radii of its own.
`FortalAvatarGroupSize` size1–size4 select avatar sizes 1–4 (24/32/40/48px),
with a space1 gap at sizes 1–2 and space2 at sizes 3–4. Each
`FortalAvatarGroupMember` is a soft avatar showing its image over its initials,
under its own accent when it names one. `max` (default 4) counts every visible
slot, the count included: a group of up to `max` members shows them all; a
larger one shows the first `max − 1` and one solid `+N` avatar in the ambient
accent for the rest, capped at `99+`. Labels of two or more characters, the
count included, use the two-character fallback type.

The avatars never overlap. An overlapping stack needs a seam to keep each
avatar distinct: a page-colored ring, which is a shadow outside a floating
layer, or a cut that follows the next avatar's corner, which would read the
radius the avatar recipe keeps private. Fortal therefore spaces them. The row
is one semantics node labelled with every member's name, the counted ones
included, or with `semanticLabel`; it has no focus stop. `highContrast`
reaches every avatar, and a caller `style` merges last into each. Tests cover
both modes, per-member accents, images, the count and its edges (`max` 1,
exactly `max`, one more, 150 members), RTL order and 200% text.

## Breadcrumbs

Breadcrumbs promote the dashboard header's trail into the registry: a
hand-written row of `FortalBreadcrumbItem(label, onPressed:, semanticLabel:)`
steps. `FortalBreadcrumbsSize` size1–size3 set text1/text2/text3, with
12/12/16px (space3/space3/space4) chevrons a space1/space2/space2 gap from
the steps; size2 is the default and the dashboard's. A step with `onPressed` is
a `FortalLink` at the trail's size, so it keeps the link's accent text, hover
underline, 40px target, focus ring and Enter activation. A step without one
is gray11 regular text. The last step is the current page in gray12 medium
and is never a link, whatever its `onPressed`.

Chevrons are gray11 `chevronRight` glyphs, mirrored in right-to-left text and
excluded from semantics. The trail keeps to one line. Every step keeps its
natural width while the trail fits; past that, the chevrons and gaps keep
theirs and the steps take fair shares of the rest, so a short step stays
whole and the longer ones ellipsize. Even shares, as flexible row children
take, would cut a long step beside a short one when the whole trail fits.
Item `semanticLabel`s replace their labels. The trail is a navigation landmark
whose steps stay their own nodes, named by its `semanticLabel` or
"Breadcrumb". The layout reports its first step's baseline, dry and laid out,
and clips its painting when even its chevrons and gaps are wider than the box.
Tests cover both modes, sizes, keyboard focus and activation, fitting and
truncation, RTL and 200% text.

## Search field

`FortalSearchField` uses `NakedSearchField` for behavior and `FortalTextField`
for the editor. The size (`size1`–`size3`) and variant (`surface` or `soft`)
match the text field at each text scale. There is no visible label or helper
text; `semanticLabel` names the field. The leading `search` glyph takes the
field's icon theme (16px, gray11 on surface, accent content on soft).
`textInputAction` defaults to search. Caller-supplied controllers and focus
nodes remain caller-owned. Removing the caller's controller preserves its
last editing value.

The clear button is a ghost icon button: size1 (12px `close` glyph) on size1
and size2 fields and size2 (16px) on size3, gray11 with grayA3/grayA4 hover
and press on surface, accent content on soft. Its trailing `touchTargetMin`
(40px minimum) overlay avoids increasing the field height. The editor always
reserves that space, so its width and tap area do not change when Clear
appears. Clear is visible only when the field is enabled, editable, and
nonempty. It shares the editor's tap region, takes no Tab stop, and has its
own semantics node so Flutter web does not lose editor focus when it appears.

Clear empties the text, calls `onChanged('')` before `onCleared`, and returns
focus to the editor whether activated by tap, semantics, or Escape. An Escape
that clears also consumes repeats and release. During active composition in
an enabled, editable field, the input method keeps the press through release.
A fresh Escape in a read-only or empty field bubbles, even if a read-only
editor retains a composing range. A caller `style` merges last.

## Surface

Surface promotes the dashboard's emphasis surfaces into the registry. The card
has one resting look, so a page built from cards alone asks the same
attention of every block; `FortalSurfaceVariant` settles that hierarchy once.
`fortalSurfaceStyle()` is the card recipe at a `FortalCardSize`
(size1–size5: 12/16/24/32/48px padding, radius4/4/5/5/6; default size2) with
the variant's fill and hairline. Emphasis comes from fill and contrast alone:
no variant casts a shadow.

| Variant | Rest | Hover | Press |
| --- | --- | --- | --- |
| `surface` | colorPanel, gray6 frame | gray7 frame | gray3 fill |
| `soft` | accentA3, accentA4 frame | accentA5 frame | accentA4 fill |
| `quiet` | grayA2, grayA3 frame | grayA4 frame | grayA3 fill |
| `inverse` | the surface card in the opposite appearance | | |

`FortalSurface` renders `inverse` inside a nested theme in the other mode with
no background, so its text, controls and charts resolve their own tokens and
keep their contrast: a dark panel in light mode and a light one in dark mode,
for the one block a page leads with. `padded: false` runs content to the
frame, as a cover image or a table needs.

With `onPressed` the whole surface is one button: it takes the hover, press,
the card's focus ring and Enter/Space, and its required `semanticLabel`
replaces the child's own semantics. Without `onPressed`, a `semanticLabel`
names the surface as a container. A caller `style` merges last. This absorbs
the dashboard's pressable surface; its `standard` and `tinted` emphases are
`surface` and `soft`. Tests cover every variant in both modes, sizes,
interaction fills, inverse contrast for every accent, keyboard focus, RTL and
200% text, and `spec_conformance` holds every variant flat.

## Enforcement

- `tool/check_fortal.dart` (`melos run fortal:check`) holds the catalog against
  source enums, defaults, public constructors, recipe inventory, and tests.
- `tool/fortal_palettes/generate.dart --check` rejects drift between
  `fortal_colors.json` and the generated Dart source.
- `test/fortal/fortal_foundation_test.dart` holds every colour token to its
  foundation literal under every accent in both appearances, the type ramp,
  the radius ladder, the shadow conversion and the motion constants, and
  checks that the high contrast switch meets the contrast gates.
- `test/fortal/palette_contrast_test.dart` checks, under the high contrast
  switch, labels on the labelled pair, marks on the mark fill, alpha soft
  labels composited over their tints, and the ramp targets for every accent
  and the error red. It also covers non-curated/extreme brand seeds, dark
  mark placement, family inks, distinct hovers for labelled solids, the error
  red's separation from Caju, and the `controlBorder`, `controlTrack` and
  `accentThumbRing` guarantees.
- `test/fortal/fortal_on_solid_ink_test.dart` resolves real button, badge,
  checkbox, radio and switch styles for every palette in both modes through
  idle, hover and press under the high contrast switch. Labels must read
  `contrast` on the labelled fill; checks and dots the derived mark ink on the
  indicator; switch thumbs white with their outline.
- `test/fortal/fortal_custom_palette_roles_test.dart` covers hand-authored
  split palettes (bright indicator beside a deep labelled solid), reuse of a
  supplied ink only where it reaches 3:1, five-argument constructors, a solid
  without hover, a deep track against a dark page, and the two-argument
  `computeAccentThumbRing` call.
- `test/dashboard/dashboard_theme_panel_test.dart` renders the theme panel and
  checks every selected accent swatch's tick on its fill, idle, hovered and
  pressed, in both modes.
- `test/fortal/fortal_control_contrast_render_test.dart` renders mounted
  controls under the high contrast switch on the page, solid panel and
  translucent panel for every palette and both modes, and measures painted
  pixels: empty checkbox/radio outlines,
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
API.

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
  error3/error11. Stale committed selection has gray5/gray4 caps/interior in
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

## Charts

The `chart` item styles `mix_chart`'s line, bar and pie charts; data, bounds,
ticks, tooltips and semantics stay `mix_chart`'s. The plot is transparent and
frameless and clips its marks.

- Value axis: `mix_chart` measures formatted ticks and reserves enough width
  for their labels and `space2` label space. Line-chart ticks stay centered
  on their values (`fitInside` off), so the top tick extends half a label
  line above the chart: leave that room above a line chart inside a clipping
  parent. Bar charts keep their end ticks fitted inside, because `mix_chart`
  clips the whole bar chart, labels included. The category axis keeps its
  edge labels inside the plot.
- Labels are `text1` in `gray11`; the horizontal grid is `grayA5` at
  `borderWidth1`.
- Series colors meet WCAG 1.4.11's 3:1 on the page and the solid and
  translucent panels. `fortalChartPalette` starts with the accent's
  `accentIndicator`, then the other named families without the accent's own;
  `computeChartSeries` takes each family's first step from 9 that keeps
  Fortal's 3.05:1 mark margin there, and does the same for an accent
  indicator that falls short. `highContrast` uses step 12 throughout. Color
  never carries meaning alone: label the series or slices.
- Series order after the accent: Mar, Caju, Céu, Serra, Sol, Duna, Jambo,
  then Orla's gray. Green, orange and blue are the most distinct families, so
  they lead; violet, amber, coral and rose follow, and gray, the least
  distinct, is last.
- Pie labels are off by default. A chart that shows them colors each slice's
  label with `fortalPieSliceLabelColor(sliceColor)` (installed as
  `<prefix>PieSliceLabelColor`), which picks white or Orla's dark step-1 ink
  to meet WCAG 1.4.3's 4.5:1 on every series color.
- Legends are the caller's, as in Vanilla: the `chart` item ships none. The
  `dashboard_demo` item's `FortalDashboardChartLegend` is a worked example.
- Bars round all four corners with `radius2`, as Vanilla's do. `mix_chart`
  applies one radius to positive and negative bars alike, so rounding only
  the top would round a negative bar at its baseline.
- A marker on an axis bound is cut by the plot's clip. Give the data room
  past its extremes with the axis bounds; turning clipping off would let
  lines cross the axes when bounds are narrower than the data or the
  viewport zooms.
