# Fortal Atlas capture

This directory contains a deterministic, inert capture of all 21 public Fortal
component families. It is designed for repository readers such as Mix Atlas;
loading it does not execute or compile Remix source code.

## Contents

- `capture.json` — integrity envelope and artifact index
- `catalog.json` — Atlas catalog index
- `light/` and `dark/` — 42 component contact-sheet PNGs and structured
  sidecars, one per component and theme
- `themes/` — strict `mix_protocol` v1 theme documents
- `components/button.component.json` — bounded Button properties, states,
  anatomy, semantics, recipe coordinates, evidence, and visual-oracle links
- `styles/button/` — projected built-in container, label, and icon style
  documents for all 20 recipes
- `protocol/coverage.json` — portable and rendered-only coverage diagnostics
- `protocol/fixtures/` — a representable built-in style fixture using Fortal
  tokens

The catalog covers Accordion, Avatar, Badge, Button, Callout, Card, Checkbox,
Dialog, Divider, Icon Button, Menu, Progress, Radio, Select, Slider, Spinner,
Switch, Tabs, Textfield, Toggle, and Tooltip. The golden test also inventories
the Fortal source tree, so adding a public `fortal_*_styles.dart` component
without adding it to this catalog fails generation instead of silently reducing
coverage.

Button retains the deep portable `component/v1` projection. It covers five
variants, four sizes, and default, hovered, pressed, focused, disabled, and
loading scenarios in light and dark themes: 240 cells total, 200 non-loading
cells, and 40 loading cells. The other 20 component families are explicitly
marked `rendered-only`: their real widgets, declared variants, sizes, and
meaningful states are visible in the contact sheets, while recipes, slots, and
resolved properties are not fabricated before a component-specific portable
adapter exists.

The producer adapter walks the real `RemixButtonStyler` sources and variants,
then uses each built-in leaf styler's normal merge semantics. It does not copy
the Fortal recipe. It calls `RemixButton.composeStyle` first so widget-owned
defaults and tooling share one source of truth. Container, label, and icon
leaves are portable after the multi-source nested-styler fix from
`btwld/mix#981`. `RemixSpinner` remains an explicit unsupported slot because no
neutral primitive has been selected.

The 200 non-loading cells reconstructed from this capture match the existing
light and dark Button screenshot oracles exactly. The 40 loading cells remain
screenshot-only until spinner support is deliberately designed.

The raw Fortal theme also contains nested color-token references in six shadow
tokens; the capture resolves those colors to concrete runtime theme values
before protocol encoding, while preserving the raw diagnostics in the coverage
report.

## Regenerate

Use the repository's Flutter 3.44.0 FVM pin on macOS:

```sh
cd packages/demo
fvm flutter test test/atlas/fortal_protocol_probe_test.dart --update-goldens
fvm flutter test test/atlas/fortal_atlas_golden_test.dart --update-goldens
fvm dart run tool/package_fortal_atlas.dart
```

Verify committed output without rewriting it:

```sh
cd packages/demo
fvm flutter test test/atlas/fortal_protocol_probe_test.dart
CI=1 fvm flutter test test/atlas/fortal_atlas_golden_test.dart
fvm dart run tool/package_fortal_atlas.dart --check
```

Repository transport metadata such as requested ref and resolved Git commit is
attached by the reader. It is deliberately not embedded in this committed
manifest, which avoids a self-referential commit identifier.
