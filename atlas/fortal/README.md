# Fortal Atlas capture

This directory contains a deterministic, inert capture of the Fortal Button.
It is designed for repository readers such as Mix Atlas; loading it does not
execute or compile Remix source code.

## Contents

- `capture.json` — integrity envelope and artifact index
- `catalog.json` — Atlas catalog index
- `light/` and `dark/` — Button contact-sheet PNGs and structured sidecars
- `themes/` — strict `mix_protocol` v1 theme documents
- `protocol/coverage.json` — supported and unsupported protocol probes
- `protocol/fixtures/` — a representable built-in style fixture using Fortal
  tokens

The capture covers five Button variants, four sizes, and default, hovered,
pressed, focused, disabled, and loading scenarios in light and dark themes.

`RemixButtonStyler` is a custom composite styler and is intentionally recorded
as unsupported by the fixed `mix_protocol` v1 vocabulary. The raw Fortal theme
also contains nested color-token references in six shadow tokens; the capture
resolves those colors to concrete runtime theme values before protocol
encoding, while preserving the raw diagnostics in the coverage report.

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
