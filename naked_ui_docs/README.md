# Naked UI documentation

This directory owns Naked UI documentation for the active package in
`packages/naked_ui`. `navigation.json` lists every page. The independent Remix
`docs/`, `docs.json`, `apps/docs` and package release workflows are unchanged.

The 18 archived pages were imported from `btwld/naked_ui`; `SOURCES.json` records
the exact revision and original bytes. Keep its BSD-3-Clause `LICENSE` alongside
this content. The pages are adapted to naked_ui 1.5.0. Five additional pages cover
Combobox, Menubar, Scrollbar, TextMagnifier and ToggleGroup. The `widget/switch`
route remains valid and documents `NakedToggle(asSwitch: true)`.

`NakedSource` includes select maintained examples from `apps/naked_ui_example`.
The producer expands them as fenced code; do not duplicate the included source.
Only literal filenames in that directory are supported. Other examples are
complete Dart blocks or API-reference excerpts.

With the SDK pinned by `.fvmrc`:

```sh
flutter pub get --enforce-lockfile
python3 tool/check_naked_ui_docs.py
python3 tool/prepare_naked_ui_docs.py
```

The first check validates navigation/retired APIs and analyzes complete Dart
examples. Constructor signatures and fragments are API reference excerpts,
reviewed against package source. Generated outputs live under `.dart_tool`.
`mix-website` consumes the independently staged snapshot as a commit-addressed,
SHA-256 verified input, mounted at `/naked-ui/docs`. Site releases are separate
from package tags. Update public README links at domain cutover; do not redirect
old worker-script URLs or remove the existing Remix Pages retirement worker.
