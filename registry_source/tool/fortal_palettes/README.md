# Fortal color sources

The seven built-in themes pair exact **@radix-ui/colors 3.0.0** accent and
neutral scales. The source package is a development-only extraction dependency;
installed Flutter applications have no Node or Radix runtime dependency.

`specs/fortal_radix_colors.json` records the approved pairings, package integrity,
sRGB opaque/alpha values, and MIT license. `generate.dart` reads that snapshot,
retains every raw scale step, and emits the required license notice into the
installed Dart source. Functional label fills, selected marks, content and focus
roles are fitted separately to Fortal's existing contrast requirements. See
[the specification](../../specs/fortal.md#raw-scales-and-functional-roles).

## Regenerate the built-in Dart source

From the repository root with the pinned SDK:

```sh
fvm dart run registry_source/tool/fortal_palettes/generate.dart
fvm dart run registry_source/tool/fortal_palettes/generate.dart --check
```

Normal Dart generation and CI consume the committed snapshot offline. To verify
or deliberately upgrade its upstream extraction:

```sh
cd registry_source/tool/fortal_palettes/radix
npm ci --ignore-scripts
npm run check
```

For an upgrade, change the exact package pin, refresh its lockfile, run
`npm run extract`, regenerate the Dart source, and review both mode scales and
component contrast before accepting the change. The extractor imports the
package's structured exports; it does not scrape CSS or parse TypeScript.

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
