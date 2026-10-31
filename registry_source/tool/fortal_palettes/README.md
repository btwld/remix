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

Generation reduces chroma to fit sRGB, uses common lightness stops for
background/border/text roles, and preserves accessible seed-led solid fills.
Dark solids take the seed's OKLCH lightness clamped to 0.70–0.84: dark seeds
are lifted for visibility and light seeds keep their character. The solid and
hover are fitted to white or a dark reference; a dark side then takes the
palette's on-solid ink: its own hue, the lightest tone up to lightness 0.70
that keeps 4.6:1 on both fill and hover, chroma up to the seed's (warm brown
for yellows; a deep neutral for gray seeds). Bright fills get a visibly
coloured ink; mid-tone fills keep a deep one. Thumbs are not inked: the theme
outlines a white thumb with that ink as `accentThumbRing`. See the
specification's on-solid ink policy. Every alpha step is solved against the
neutral page. All steps are rounded to 8-bit sRGB before
contrast is checked in tests.

## Very light custom accents

Near-white solids can blend with the page despite readable labels. Use an
available high-contrast control treatment or an explicit step-8 border when a
visible boundary matters. The [owned policy](../../specs/fortal.md#very-light-custom-accents)
defines the guarantees and measurements; generation preserves seed identity.
