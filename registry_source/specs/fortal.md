# Fortal specification

Fortal is an independent, Fortaleza-inspired design system on Remix and Naked
UI. This specification, not another component library, owns its visual contract.
The [machine-readable catalog](fortal_catalog.json) lists every shipped family,
its axes, constructor defaults, and behavior. The public component APIs remain
size-linked recipes over Remix; no behavioral component is reimplemented.

## Sources and decisions

The [Fortal Refresh brief](../docs/fortal/refresh-brief.md) (Leo Farias,
2026-10-29) supplies the names, seeds,
role model, contrast targets, and component decisions below. OKLab conversion
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
| Céu / `ceu` | `#006EBE` | Sky blue |
| Mangue / `mangue` | `#1D7D3E` | Mangrove green |
| Sol / `sol` | `#FFCF50` | Yellow and highlights |
| Duna / `duna` | `#E5C79A` | Warm sand |
| Caju / `caju` | `#CB4333` | Red and errors |

Both theme defaults are Calçadão. The page is gray step 1 in both modes; solid
panels and surface fields are gray step 2. Panel background defaults to `solid`
with zero blur; `translucent` remains opt-in. Error roles always resolve to Caju,
independently of the current accent or a custom brand palette.

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
retained when accessible; dark fills are lifted, with inverse limestone for
the neutral accent. The generator fits the pair together to one white or basalt
foreground, with a 4.6:1 generation margin above the 4.5:1 requirement.

### Contrast requirements (both appearances)

- `contrast` on steps 9 and 10: at least **4.5:1**.
- Step 11 on steps 1–3: at least **4.5:1**. Actual alpha soft text over fills
  3–5 on both page and solid panel must also pass 4.5:1.
- Step 12 on steps 1–5: at least **7:1**.
- Step 8 on steps 1–2 and the neutral page/panel: at least **3:1**.

Custom palettes generated from one `#RRGGBB` seed use the same model and can
be supplied as `FortalTheme(accentPalette: brand)`. An explicit named accent
clears an inherited custom palette. See the palette tool README for the command.

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

The polish board presents all families and sizes in light/dark pairs on a 4px
grid. Check padding against height, text centering, matched icon size/gap,
40px hit targets, and distinct hover/press/disabled states in both modes.
Caller style overrides are always merged last.

## Enforcement

- `tool/check_fortal.dart` (`melos run fortal:check`) holds the catalog against
  source enums, defaults, public constructors, recipe inventory, and tests.
- `tool/fortal_palettes/generate.dart --check` rejects palette drift.
- `test/fortal/palette_contrast_test.dart` checks all four targets, alpha soft
  labels, compositing, and non-curated/extreme brand seeds.
- `test/fortal/spec_conformance_test.dart` checks theme defaults, token values,
  Caju errors, flat surfaces, filled fields, and scaling.
- Focus, control matrices, keyboard/semantics and theme-scope tests retain
  Remix/Naked UI behavior coverage. Fortal-owned goldens cover both modes.
- `tool/generate_fortal_catalog.dart --check`, `docs:check`, registry derivation,
  and installed-consumer checks prevent source/documentation/distribution drift.
