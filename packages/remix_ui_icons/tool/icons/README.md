# remix_ui_icons generator

Compiles the Vector UI masters in [`design/icons`](../../../../design/icons)
into the `RemixIcons` font and the package's Dart API. Python 3.13, uv
0.11.24, and GlyphPact 1.1.0 are pinned in `pyproject.toml` and `uv.lock`.

From the repository root:

```sh
dart run melos run icons:generate   # regenerate every artifact
dart run melos run icons:check      # the checks CI runs, without Flutter
```

## Inputs

- `manifest.yaml` is the source of truth: the families, every concept with its
  Dart name, families, tags, RTL behavior, label requirement, and version, and
  what became of every 0.1.x name (an exact replacement, a partial match, or
  removed, each with the closest Lucide icon).
- `design/icons/<family>/generated/<family>/<style>/<master>/<concept>.svg`
  are the drawings. They are already filled outlines (one `currentColor`
  path, even-odd fill, no strokes), so nothing is expanded before the build;
  `sources.py` rejects any master that is not.
- `codepoints.lock.json` is the append-only codepoint lock, in GlyphPact's
  format.

## Outputs

`generate.py` writes, and `generate.py --check` verifies:

- `lib/src/generated/fonts/RemixIcons.otf`, compiled by GlyphPact with
  lossless conversion required. `font-report.json` records the build.
- `lib/src/generated/*_icons.dart`: `OutlineIcons`, `RoundedIcons`,
  `MonoIcons`, and the `RemixIcons` facade with its deprecated aliases.
- `lib/src/generated/icon_sets.dart` (opt-in `sized.dart`) and
  `lib/src/generated/icons_index.dart` (opt-in `icons_index.dart`).
- `MIGRATION.md` and the generated blocks in `README.md` and `CHANGELOG.md`.
- `public_api.txt`, the generated public API.

## Codepoints

Codepoints start at `0xE200`. A new glyph takes the next codepoint above
every one ever assigned, a glyph that leaves the manifest moves to the lock's
`retired` list, and no codepoint is reassigned. `0xE000`–`0xE13D` held the
0.1.x Radix glyphs and is reserved. `check.py --base-lock` compares the lock
with an earlier one and fails on any deleted or moved entry.

The font uses 15360 units per em, so a pixel of every master is a whole
number of font units, and keeps six decimals of the drawings' coordinates.

## Checks

`check.py` runs, in order: the drift check; the lock rules; that the
generated Dart declares every glyph at its locked codepoint and every alias is
deprecated; a raster comparison of every glyph in the font with its SVG
(`raster.py`, at native size and 8x, plus the 288 reviewed Outline
snapshots); and the API gate. With `--flutter`, it also renders every glyph
through Flutter (`flutter/glyph_render_test.dart`).

`tree_shake.py --flutter <flutter>` builds a release web app that refers to a
few glyphs and fails unless the shipped font holds exactly those glyphs. CI
runs it on Flutter 3.41.0, the package's floor, and on current stable.

## Releasing

The API gate compares the generated API with `released_api.txt`, the API of
the last published release, and fails when a release that is not a major
version removes a member. After publishing, replace `released_api.txt` with
the new `public_api.txt` and set its `version:` line.

## Changing the icons

- **Redraw:** edit the master in `design/icons`, rebuild the pack, then run
  `icons:generate`. The codepoint is unchanged; ship it in a minor release.
- **New concept, family, or master:** add it to `manifest.yaml` with
  `since:` set to the next version, then generate. It takes new codepoints.
  Minor release.
- **Rename:** add the new concept and keep the old name as an `exact` legacy
  entry so `RemixIcons` keeps a deprecated alias. Minor release.
- **Removal:** major release only. The lock retires its codepoints.
