# Fortal palettes

These tools contain no external palette data or package dependencies. The
seed inventory comes from the Fortal Refresh brief (2026-10-29), as revised by
the 2026-10-31 palette review; conversion uses OKLab and WCAG 2 luminance.
See [the specification](../../specs/fortal.md) for the role contract.

The built-in run writes the seven accents, the dedicated error red
(`fortalError`, not a selectable accent), and the neutral alpha swatches.

From the repository root, with the pinned SDK:

```sh
fvm dart run registry_source/tool/fortal_palettes/generate.dart
fvm dart run registry_source/tool/fortal_palettes/generate.dart --check
```

Generate an application's custom palette in its installed theme directory:

```sh
fvm dart run registry_source/tool/fortal_palettes/generate.dart \
  --name brand --seed '#8038CC' --type-prefix Acme --output /path/to/app/lib/ui/theme/brand_colors.dart
```

The output imports the sibling `palette.dart` installed with `@remix/theme`.
Match `--type-prefix` to the app prefix in `remix.yaml`. The generator defaults
to `Fortal`; the CLI project prefix defaults to `Ui`.
Use `--palette-import` to choose a different Dart import. Import that output
in the app and pass `accentPalette: brand` to its prefixed theme widget. The
palette owns both modes; all named accents remain available in nested scopes.
The generated identifiers start with the requested lower-camel name, not the
consumer's prefix, so a palette can be renamed independently of UI classes.
A custom name may not reuse a built-in identifier (`calcadao`, `serra`,
`<prefix>Error`, `blackAlpha` and the rest), and a custom palette is never
generated as the neutral because of its name.

Generation reduces chroma to fit sRGB and uses common lightness stops for
background, border and text roles. Chromatic seeds tint steps 1–8, 11 and 12
with at least 0.09 chroma, so low-chroma seeds read as their hue; step 11 is
the lightest same-hue tone that keeps 4.6:1 on the step-5 tint over the solid
panel.

Labels and marks are separate roles:

- **Luminous seeds** (a white label would need more than 0.12 OKLCH lightness
  of darkening: Sol, Duna, near-white seeds) keep one bright fill. Their dark
  fill keeps the seed's lightness clamped to 0.70–0.84, with a same-hue ink:
  the lightest tone up to lightness 0.70 that keeps 4.6:1 on fill and hover,
  warm brown for yellows and a deep neutral for gray seeds.
- **Every other seed** gets a mark fill (steps 9 and 10) and a labelled solid
  with white labels:
  - the mark fill is the seed where white marks, the page and the panel keep
    3:1, deepened just enough otherwise; in dark mode it starts from the
    seed's lightness clamped to 0.58–0.72 instead of being lifted;
  - the labelled solid deepens further only as far as a white label needs on
    it and its hover.

The output writes `solid:`/`solidHover:` only where they differ from steps 9
and 10, and needs the installed `palette.dart` that accepts them; older
five-argument palettes still compile and keep their labels on steps 9 and 10.
Checks and thumb outlines are derived by the theme from the indicator and
track (see the specification's labels-and-marks section). Every alpha step is
solved against the neutral page, so alpha steps are fills, not overlays for
other accent steps. All steps are rounded to 8-bit sRGB before contrast is
checked in tests.

## Very light custom accents

Near-white solids can blend with the page despite readable labels. Use an
available high-contrast control treatment or an explicit step-8 border when a
visible boundary matters. The [owned policy](../../specs/fortal.md#very-light-custom-accents)
defines the guarantees and measurements; generation preserves seed identity.
