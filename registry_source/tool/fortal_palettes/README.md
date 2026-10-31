# Fortal palettes

These tools contain no external palette data or package dependencies. The
seed inventory comes from the Fortal Refresh brief (2026-10-29); conversion
uses OKLab and WCAG 2 luminance. See [the specification](../../specs/fortal.md) for the role contract.

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

Generation reduces chroma to fit sRGB, uses common lightness stops for
background/border/text roles, and preserves accessible seed-led solid fills.
Dark fills are lifted for visibility. A single white/basalt foreground passes
both solid and hover. Every alpha step is solved against the neutral page.
All steps are rounded to 8-bit sRGB before contrast is checked in tests.
