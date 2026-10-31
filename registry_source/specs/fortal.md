# Fortal specification

Fortal is an independent, Fortaleza-inspired design system on Remix and Naked
UI. This specification, not another component library, owns its visual contract.
The [machine-readable catalog](fortal_catalog.json) lists every shipped family,
its axes, constructor defaults, and behavior. The public component APIs remain
size-linked recipes over Remix; no behavioral component is reimplemented.

## Sources and decisions

The [Fortal Refresh brief](../docs/fortal/refresh-brief.md) (Leo Farias,
2026-10-29) supplies the names, seeds,
role model, contrast targets, and component decisions below. Leo's 2026-10-31
palette review replaced Mangue with Serra, set the Céu and Caju seeds, moved
errors to a dedicated red, and bounded dark solid lightness. OKLab conversion
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
| Céu / `ceu` | `#1A95D8` | Sky blue, with deep navy labels |
| Serra / `serra` | `#6F7845` | Earthy olive of the hills inland |
| Sol / `sol` | `#FFCF50` | Sunny yellow and highlights |
| Duna / `duna` | `#E5C79A` | Warm sand |
| Caju / `caju` | `#E76A32` | Cashew-fruit orange-red, with deep brown labels |

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
| 9–10 | Solid fill and hover |
| 11–12 | Secondary and primary text |

Each appearance provides twelve opaque and twelve transparent steps plus
`contrast`, `surface`, `indicator`, and `track`. Transparent steps are derived
by sRGB source-over inversion against the neutral page; they reconstruct their
solid step to within one 8-bit channel and adapt to the underlying panel.
`surface` is alpha step 3; `indicator` and `track` are solid step 9.

The generator (`tool/fortal_palettes/`) gamut-maps OKLCH by reducing chroma.
Background, border, and text roles share lightness stops across palettes.
The solid/hover pair deliberately follows the seed instead: forcing Sol and
basalt to identical lightness would lose their identities. Light seeds are
retained when accessible. In dark mode the solid takes the seed's OKLCH
lightness clamped to 0.70–0.84: darker seeds are lifted to stay visible, while
light seeds keep their character (Sol is gold `#F3C442`, not mustard; Duna
keeps its sand seed). The neutral accent uses inverse limestone. The error
red's dark solid is curated at 0.64 so it reads as red, not coral, beside
Caju's orange. The generator fits the pair together to white or to a dark
reference (basalt), with a 4.6:1 generation margin above the 4.5:1 requirement.

### On-solid ink

`contrast` is the one foreground role for solid fills: button and badge
labels, solid avatar text, selected surface switch thumbs, checkbox marks,
radio dots and solid menu/select highlights. Where white serves the fitted
fill, it stays white. Otherwise the ink is a deep tone of the palette's own
hue rather than generic basalt: the lightest tone up to OKLCH lightness 0.30
that keeps 4.6:1 on both step 9 and step 10. Its chroma is 0.6× the seed's,
at most 0.09, gamut-mapped by chroma reduction; yellow and sand hues rotate up
to 18° toward orange so they read warm brown rather than olive. Lightness
descends in 0.002 steps, and basalt is the fallback if no family tone passes.
Fills are fitted first and never move for the ink, so hover cannot collapse.
The neutral Calçadão keeps white on basalt and basalt on limestone; gray and
near-white custom seeds get a deep neutral. Where a fill leaves little headroom
(light Céu and Caju), the ink stays near basalt's lightness but keeps its hue.

High-contrast variants are a deliberate knockout: their fill is step 12 and
their foreground is step 1 (or neutral gray 1 for buttons), so in dark mode
they remain near-black on a pale tint, at 7:1 or more by construction.

### Contrast requirements (both appearances)

- `contrast` on steps 9 and 10: at least **4.5:1**.
- Step 11 on steps 1–3: at least **4.5:1**. Actual alpha soft text over fills
  3–5 on both page and solid panel must also pass 4.5:1.
- Step 12 on steps 1–5: at least **7:1**.
- Step 8 on steps 1–2 and the neutral page/panel: at least **3:1**.

Custom palettes generated from one `#RRGGBB` seed use the same model and can
be supplied as `FortalTheme(accentPalette: brand)`. An explicit named accent
clears an inherited custom palette. See the palette tool README for the command.

### Very light custom accents

Solid fills preserve a light seed when its label meets the contrast contract.
They do not guarantee 3:1 against the page: for example, `#F4F4F0` remains
`#F4F4F0` in light mode, about 1.05:1 against the neutral page, while its
deep neutral ink (`#2E2E2C`) reaches 12.3:1. This also preserves the intended
Sol and Duna fills. In dark mode such seeds take the 0.84 lightness cap, so
their dark solid is a light tone (`#CDCCB2`) with that ink rather than the
seed itself.
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
fields, text areas, and select triggers use opaque gray-2 fill and gray-7 border.
Enabled surface input hints use secondary gray content; enabled soft input
hints and icons use secondary accent content. Disabled input treatments stay separate.

Selected surface switch thumbs use `accentContrast`, or `accent1` against the
high-contrast `accent12` track. Selected soft thumbs use `accent11`, promoted
to `accent12` at high contrast. Off thumbs stay white; disabled thumbs keep
neutral gray-2 fill and a gray-6 border. Geometry and state precedence are shared.

The polish board presents all families and sizes in light/dark pairs on a 4px
grid. Check padding against height, text centering, matched icon size/gap,
40px hit targets, and distinct hover/press/disabled states in both modes.
Caller style overrides are always merged last.

## Enforcement

- `tool/check_fortal.dart` (`melos run fortal:check`) holds the catalog against
  source enums, defaults, public constructors, recipe inventory, and tests.
- `tool/fortal_palettes/generate.dart --check` rejects palette drift.
- `test/fortal/palette_contrast_test.dart` checks all four targets, alpha soft
  labels, and compositing for every accent and the error red, plus
  non-curated/extreme brand seeds, the dark-solid policy, the on-solid ink
  policy, distinct hovers, and Fortal's own comparative separation between
  accents and the error red. `test/fortal/fortal_on_solid_ink_test.dart`
  resolves solid button labels, switch thumbs, checkbox marks and radio dots
  to that ink for every palette in both modes.
- `test/fortal/spec_conformance_test.dart` checks theme defaults, token values,
  error roles independent of accents and custom palettes, flat surfaces, filled
  fields, and scaling.
- Focus, control matrices, keyboard/semantics and theme-scope tests retain
  Remix/Naked UI behavior coverage. Fortal-owned goldens cover both modes.
- `tool/generate_fortal_catalog.dart --check`, `docs:check`, registry derivation,
  and installed-consumer checks prevent source/documentation/distribution drift.
