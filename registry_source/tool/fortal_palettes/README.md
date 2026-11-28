# Fortal color sources

The eight built-in accents, the shared neutral, the error red and the
functional roles are Fortal's own foundation values. `specs/fortal_colors.json`
records every literal as a Dart colour (`0xAARRGGBB`); `generate.dart` reads
that file and emits the installed Dart source. Built-in accents pin their
content, focus, range, thumb and swatch roles there, so the theme uses them as
given; the fitting functions in `computed.dart` serve custom palettes and the
theme's high contrast switch. See
[the specification](../../specs/fortal.md#scales-and-functional-roles).

## Regenerate the built-in Dart source

`registry_source/lib/src/fortal/theme/fortal_colors.dart` is generated; do not
hand-edit it. From the repository root with the pinned SDK:

```sh
fvm dart run registry_source/tool/fortal_palettes/generate.dart
fvm dart run registry_source/tool/fortal_palettes/generate.dart --check
```

To change a value, edit `specs/fortal_colors.json`, regenerate, and review
both appearances and the component contrast tests before accepting the change.

## Generate an application's custom brand palette

Custom brand generation and the dedicated error red retain the Fortal-owned
OKLCH generator; they are distinct from the imported built-ins. A custom palette
inherits the selected named theme's neutral, defaulting to Orla. Custom generation
uses the pinned Orla page/panel reference values in each mode.

```sh
fvm dart run registry_source/tool/fortal_palettes/generate.dart \
  --name brand --seed '#8038CC' --type-prefix Acme \
  --output /path/to/app/lib/ui/theme/brand_colors.dart
```

The output imports sibling `palette.dart`. Match `--type-prefix` to the app's
`remix.yaml`, import the generated file, and pass `accentPalette: brand` to the
installed theme. Use `--palette-import` when the file lives elsewhere. Built-in
identifiers are reserved. A custom name does not change its neutral pairing.

Near-white custom fills can blend into the page despite readable labels. Use
an available high-contrast or outline treatment when the fill must identify the
control, and inspect it on its actual host surface.
