# Fortal specification

Fortal is an independent, Fortaleza-inspired design system on Remix and Naked
UI. This specification, not another component library, owns its visual contract.
The [machine-readable catalog](fortal_catalog.json) lists every shipped family,
its axes, constructor defaults, and behavior. The public component APIs remain
size-linked recipes over Remix; no behavioral component is reimplemented.

## Sources and decisions

The [design provenance](../docs/fortal/refresh-brief.md) records Leo Farias's
2026-10-29 brief, which established the palette names, role model, contrast
targets, and component direction. Leo's 2026-10-31
palette review replaced Mangue with Serra, set the Céu and Caju seeds, moved
errors to a dedicated red, and bounded dark solid lightness. The 2026-10-31
foreground review then separated labelled solids from marks, gave secondary
surfaces visible hue and lighter step-11 text, and stopped lifting dark solids
toward pastel. OKLab conversion
uses Björn Ottosson's published equations; contrast uses WCAG 2 relative
luminance. All palette data is generated here, with no external color dataset.
The [independence ADR](../docs/adr/fortal/0003-independent-design-system.md)
records scope and precedence. Geist and the separate Remix Icons package are
unchanged; Anton, cobogó patterns, and full Fortaleza branding are out of scope.

## Color tokens

| Palette / Dart name | Seed | Purpose |
| --- | --- | --- |
| Calçadão / `calcadao` | `#13181D` | Neutral accent and the sole gray; inverse limestone in dark mode |
| Mar / `mar` | `#036F6B` | Signature sea green |
| Céu / `ceu` | `#1A95D8` | Sky blue; white labels on a deeper sky solid |
| Serra / `serra` | `#6F7845` | Earthy olive of the hills inland |
| Sol / `sol` | `#FFCF50` | Sunny yellow and highlights |
| Duna / `duna` | `#E5C79A` | Warm sand |
| Caju / `caju` | `#E76A32` | Cashew-fruit orange-red; white labels on a deeper solid |

Error roles use a dedicated red, `fortalError` (seed `#C92E3B`, installed as
`<prefix>Error`). It is generated with the accents but is not a selectable
accent, so an orange Caju accent and a red error never share a palette.

Both theme defaults are Calçadão. The page is gray step 1 in both modes; solid
panels and surface fields are gray step 2. Panel background defaults to `solid`
with zero blur; `translucent` remains opt-in. Error roles always resolve to the
dedicated error red, independently of the current accent or a custom brand
palette. Status examples keep a text label or icon: color reinforces meaning
but never carries it alone.

| Steps | Role |
| --- | --- |
| 1–2 | Page and subtle backgrounds |
| 3–5 | Rest, hover, and pressed fills |
| 6–8 | Subtle, normal, and strong borders; 8 is also focus |
| 9–10 | Mark fill and its pressed step |
| 11–12 | Secondary and primary text |

Each appearance provides twelve opaque and twelve transparent steps plus
`surface`, `indicator`, `track`, `contrast`, `solid` and `solidHover`.
Transparent steps are derived by sRGB source-over inversion against the neutral
page; they reconstruct their solid step to within one 8-bit channel and adapt
to the underlying panel. They are fills for the page or a panel, not overlays
for another accent step: a reconstructed tint can be fully opaque. `surface` is
alpha step 3; `indicator` and `track` are solid step 9.

Labels and marks are separate jobs. Steps 9 and 10 are the mark fill and its
pressed step: selected checkboxes and radios, switch tracks, slider and
progress ranges, tab indicators, accent dots and chart series. `solid` and
`solidHover` (tokens `accentSolid`, `accentSolidHover`) are the labelled fills
of buttons, icon buttons, solid badges, avatars, code and highlighted menu and
select items, and `contrast` is fitted to them. A palette writes the labelled
pair only where it differs from steps 9 and 10; otherwise, and for palettes
constructed without it, `solid` is step 9 and `solidHover` step 10. A `solid`
supplied without `solidHover` is also its own hover, so the label pairing
holds.

The generator (`tool/fortal_palettes/`) gamut-maps OKLCH by reducing chroma.
Background, border, and text roles share lightness stops across palettes.
Chromatic seeds give steps 1–8, 11 and 12 the seed's chroma times a per-step
weight, with a 0.09 chroma floor, so low-chroma seeds (Mar, Serra, Duna) tint
their surfaces with their own hue instead of gray. Achromatic seeds and the
neutral keep the original, quieter weights. Step 11 is fitted rather than
fixed: the lightest same-hue tone, from OKLCH 0.52 (light) or 0.82 (dark), that
keeps 4.6:1 on the step-5 tint over the solid panel and on the panel.

Steps 9 and 10 follow the seed. A seed is **luminous** when a white label would
need its fill darkened by more than 0.12 OKLCH lightness: Sol, Duna and
near-white custom seeds. Luminous palettes keep one bright fill for labels and
marks. It is the seed in light mode; in dark mode it keeps the seed's lightness
clamped to 0.70–0.84 (Sol stays gold `#F3C442`, not mustard; Duna keeps its sand
seed). Their `contrast` is a tone of the palette's own hue: the lightest up to
OKLCH lightness 0.70 that keeps 4.6:1 on fill and hover, chroma up to the
seed's (at most 0.14), with yellow and sand hues rotated up to 18° toward
orange so they read warm brown (Sol `#764B00`, Duna `#694624`/`#704D2B`).

Every other palette splits its solid roles:

- **Mark fill.** In light mode, the exact seed where white marks, the page and
  the solid panel all keep the 3.05:1 generation margin; otherwise the seed's
  hue and chroma, deepened in 0.002 steps until they do. In dark mode it starts
  from the seed's lightness clamped to 0.58–0.72, so dark solids are no longer
  lifted toward pastel. Step 10 is 0.035 deeper.
- **Labelled solid.** From the mark fill, deepened further only as far as a
  white label needs to keep 4.6:1 on the fill and its 0.035-deeper hover.

The neutral accent keeps inverse limestone. The dedicated error red is curated:
its dark mark starts at 0.61 and its labelled solid sits at 0.53 in both modes,
so destructive marks and actions read red, not coral, beside Caju's orange.
Margins of 4.6:1 and 3.05:1 sit above the 4.5:1 and 3:1 requirements so 8-bit
rounding cannot cross them.

### Labels and marks

`contrast` is the label colour on `solid` and `solidHover`: button, icon button
and spinner foregrounds, solid badge and avatar text, solid code and solid
menu/select highlights. It is white for every non-luminous palette in both
modes, warm brown for Sol and Duna, and the basalt/limestone inversion for
Calçadão.

Checks and radio dots read `accentIndicatorContrast`, derived from the
`indicator` they sit on rather than from the label. It is white where white
keeps 3:1 on the indicator. Otherwise it is `contrast`, if that keeps 3:1
there, and otherwise Calçadão's dark ink. A hand-authored palette that pairs a
deep labelled solid with a bright indicator therefore still gets a dark check.

Normal selected surface-switch thumbs and enabled slider thumbs are white
surfaces with an outline, `accentThumbRing`, derived from the `track` they sit
on. Where white keeps 3:1 on the track, the outline is the track colour
itself, seamless on the track, provided that colour keeps 3:1 against the page,
the solid panel and the translucent panel a slider thumb overhangs; otherwise
it is `controlBorder`. On a bright track the outline takes the mark-ink rule
instead (warm brown on Sol and Duna). The exported
`computeAccentThumbRing(accent, controlBorder)` keeps that two-argument form.
Its optional `surfaces` lets theme resolution choose the track-coloured
outline; without them it keeps `controlBorder` wherever white already fits the
track. Off switch thumbs are white with a
`controlBorder` ring. Selected soft thumbs keep their `accent11`/`accent12`
fill, the explicit high-contrast surface thumb keeps its `accent1` knockout,
and disabled thumbs keep gray 2 with a gray-6 border (see Components).

### Control boundaries

`controlBorder` is the neutral boundary of active empty controls: unchecked
checkbox and radio outlines, the off switch's track edge and thumb ring, and
surface text field and text area borders. It is gray step 8 deepened 15%
toward step 11 in OKLab (light) and step 7 lifted 70% toward step 8 (dark), and
keeps at least **3:1** against the page, the solid panel, the translucent
panel over the default page, and the off track (gray alpha 3 over each). Soft
empty checkboxes and radios, and soft text fields and text areas, add an
`accentA8` inset ring for the same reason: their tint alone is near 1.2:1, and
a blank soft input may show no text, hint or label at all. Disabled controls
keep their quieter strokes. These guarantees cover Fortal's
own page and panel surfaces; content placed over arbitrary colours or images
must be checked in context.

High-contrast variants are a deliberate knockout: their fill is step 12 and
their foreground is step 1 (or neutral gray 1 for buttons), so in dark mode
they remain near-black on a pale tint, at 7:1 or more by construction.

### Contrast requirements (both appearances)

- `contrast` on `solid` and `solidHover`, including the derived pressed fill:
  at least **4.5:1**.
- `accentIndicatorContrast` on the indicator and step 10: at least **3:1**.
  Non-luminous mark fills keep 3:1 against the page and solid panel.
- Step 11 on steps 1–3: at least **4.5:1**. Actual alpha soft text over fills
  3–5 on both page and solid panel must also pass 4.5:1.
- Step 12 on steps 1–5: at least **7:1**.
- Step 8 on steps 1–2 and the neutral page/panel: at least **3:1**.
- `controlBorder` on page, solid panel, translucent panel and off track: at
  least **3:1**. A thumb's white fill or its `accentThumbRing` on steps 9–10:
  at least **3:1**.
- A bare progress bar's whole track and its filled extent each keep a fully
  covered band at **3:1** or more against the page, solid panel and
  translucent panel, at 0, part and full.

Custom palettes generated from one `#RRGGBB` seed use the same model and can
be supplied as `FortalTheme(accentPalette: brand)`. An explicit named accent
clears an inherited custom palette. See the palette tool README for the command.

### Very light custom accents

Luminous fills preserve a light seed when its label meets the contrast
contract. They do not guarantee 3:1 against the page: for example, `#F4F4F0`
remains `#F4F4F0` in light mode, about 1.05:1 against the neutral page, while
its deep neutral ink (`#2E2E2C`) reaches 12.3:1. This also preserves the
intended Sol and Duna fills, whose checks, dots and thumb outlines take the
dark ink. In dark mode such seeds take the 0.84 lightness cap, so their dark
fill is a light tone (`#CDCCB2`) with that ink rather than the seed itself.
Use `highContrast: true` on controls that expose it when a stronger active
fill is needed, or choose an outline/surface treatment with an explicit
step-8 border. Focus remains step 8; label and focus guarantees apply in both
modes. Check the actual component and background when using a custom palette.

## Fixed scales and geometry

- Spacing: **4, 8, 12, 16, 24, 32, 40, 48, 64px**, multiplied by scaling.
  Component and agent recipes use these tokens whenever a dimension has an equivalent step.
  Specialized measurements (20px icons, tiny indicators, em-relative inline
  typography, and bounded agent viewports) remain named tokens or proportions.
- Type: **12, 14, 16, 18, 20, 24, 28, 36, 60px**. Accordion and disclosure
  size 2 use `text2`, not an intermediate 15px style. Text8 has a 40px line box.
- Radius: `none`, `small`, `medium` (default), `large`, `full`; scaling:
  90, 95, 100 (default), 105, 110 percent. `highContrast` remains available.
- Compact painted controls retain their sizes, inside a **40px minimum hit
  target**, which does not shrink at 90/95% scaling. Hosts must leave room for
  that target instead of imposing a smaller tight constraint.
- Focus: one **2px solid accent-8 outline, 2px outside** the painted control.
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
toasts retain outer elevation; a shadow means the surface floats. Surface text
fields and text areas use an opaque gray-2 fill and the `controlBorder` frame,
so a field without a visible label can still be found; soft fields and areas
keep their accent-3 fill inside an accent-8 ring, the recipe's base frame so
caller frames still win. Error replaces either frame with error step 8, and
disabled clears the soft ring (error keeps its precedence). Select triggers keep their gray-7 frame (gray alpha 8
when open or hovered): their value and chevron identify them.
Enabled surface input hints use secondary gray content; enabled soft input
hints and icons use secondary accent content. Disabled input treatments stay separate.

Selected surface switch thumbs are white with a 2px `accentThumbRing`, or
`accent1` against the high-contrast `accent12` track. Selected soft thumbs use
`accent11`, promoted to `accent12` at high contrast. Off thumbs stay white with
a 1px `controlBorder` ring on a track edged in `controlBorder`; the selected
surface track keeps its quiet gray-alpha-5 edge. Disabled switches keep a
neutral gray-2 thumb with a gray-6 border and drop the active track edge
(surface keeps the quiet edge, soft has none), whatever the selection, focus
or press state. Slider thumbs are white with a 2px `accentThumbRing`; the thumb
is identified by its fill or its ring. The soft slider range is step 6 alone,
with no accent alpha layered over it. Geometry and state precedence are shared.

Progress bars carry their value without text, in two extents. The whole track
(gray alpha 3, or gray alpha 4 for soft) is edged in a 1px inset
`controlBorder`, so the total stays readable at 0. The surface fill is the
track role with a 1px inset `accentThumbRing` outline: seamless where the fill
already contrasts, warm brown on bright Sol and Duna fills. The soft fill is
step 8 alone, which keeps 3:1 on the page and panels. High contrast fills with
step 12 and no outline. Height, radius, value and semantics are unchanged.

Solid button hover and press recolor only the fill. Hover uses `solidHover`. Press
applies the Radix-derived CSS operations to the fill colour itself: darker
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
