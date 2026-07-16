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
- `components/` — 21 strict `mix_atlas/component/v2` documents with embedded
  Mix Protocol style libraries
- `protocol/coverage.json` — portable inventory, totals, and token diagnostics
- `protocol/fixtures/` — a representable built-in style fixture using Fortal
  tokens

The catalog covers Accordion, Avatar, Badge, Button, Callout, Card, Checkbox,
Dialog, Divider, Icon Button, Menu, Progress, Radio, Select, Slider, Spinner,
Switch, Tabs, Textfield, Toggle, and Tooltip. The golden test also inventories
the Fortal source tree, so adding a public `fortal_*_styles.dart` component
without adding it to this catalog fails generation instead of silently reducing
coverage.

Every catalog entry has a portable adapter and document. Together they contain
exactly 148 recipes and 613 recipe × state cells per theme, for 1,226 light and
dark renders. Coverage reports zero rendered-only components and zero
placeholder nodes. Whole contact sheets remain visual oracles; the component
documents are the primary selectable catalog representation.

Each adapter walks the real Fortal composite styler and recursively projects
its built-in Mix leaf sources and widget-state variants. Component-v2 embeds
those canonical style documents under stable recipe and slot identifiers.
Custom scalar visuals such as spinner timing and strokes, slider geometry, and
progress fractions use typed bindings. Compound components use explicit
anatomy and nested-component references; runtime callbacks, editing, and
overlays are inert diagnostics rather than visual placeholders.

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
