# HeroUI web 3.2.6 reference

This directory pins the upstream evidence for the HeroUI preset: what HeroUI
looks like, so the recipes in `lib/src/heroui` can be checked against it.
Behavior is Remix's and is not recorded here. Scope and the family map are in
[ADR 0002](../../docs/adr/heroui/0002-reference-design-over-remix.md).

## Files

| File | What it pins |
| --- | --- |
| `sources.json` | `@heroui/react` and `@heroui/styles` 3.2.6 tarball URLs and SHA-512 integrity, the provenance commit `e385ac202b2cdb94b1bf6fa76d32c31c8259cc5e`, and the pinned docs pages |
| `source/` | The compiled CSS, theme variables, and component sources for the mapped families; `source/files.json` holds each file's SHA-256 |
| `families.json` | Every upstream family: mapped to a Remix-backed item, composed, or deferred with a reason |
| `chromium/tokens.json` | Browser-resolved values of the theme's CSS variables in both modes |
| `measurements.json` | Rendered geometry and paint of the upstream components (both modes, 375 and 1024 px, plus hover/pressed/focus states), one case per line |
| `LICENSE.upstream` | The Apache-2.0 text shipped in the upstream repository |

Package metadata declares MIT while the repository's `LICENSE` is Apache-2.0;
the Apache text is retained and no affiliation with HeroUI is implied.

## Regenerating

`tool/heroui_parity/chromium` renders the real upstream components in
Chromium and writes raw captures to `chromium/*.json` (not committed; see its
README). `dart run tool/heroui_parity/slim_measurements.dart` then derives
`measurements.json` from them, keeping the shipped families and the styles
the recipe tests compare.

`dart run tool/heroui_parity/check.dart` verifies the snapshot hashes, that
the token inventory (`specs/heroui/tokens.json`), `HeroUiTokens`, and the
browser capture agree, and that every item maps to an upstream family and has
a worksheet. Upgrade the pins in a separate change and regenerate the
evidence before changing expected values.
