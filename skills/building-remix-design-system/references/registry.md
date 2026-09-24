# Registry reference

How a design system becomes a Remix registry: repository layout, authoring
rules, derivation, the catalog format, and the publish-and-test loop. Examples
use a system named "Acme" registered as `@acme`.

## Table of Contents

- [Repository layout](#1-repository-layout)
- [Authoring package](#2-authoring-package)
- [Authoring rules](#3-authoring-rules)
- [Derivation](#4-derivation)
- [Catalog](#5-catalog)
- [Publish and test](#6-publish-and-test)
- [Limits](#7-limits)

## 1. Repository layout

```text
acme-design-system/            public github.com repository
  source/                      authoring package: analyzed and tested, never published
    pubspec.yaml
    lib/theme/                 tokens.dart, theme_data.dart, theme_scope.dart
    lib/components/            one recipe per component (+ its .g.dart part)
    test/
  specs/
    tokens.yaml                token inventory, values, citations (references/tokens.md)
    components/<name>.yaml     one worksheet per component
  docs/adr/                    scope, sources, theme model decisions
  tool/
    derive_templates.dart      source/lib → registry/vanilla/templates
  registry/
    index.yaml                 presets → catalog paths
    vanilla/registry.yaml      the catalog
    vanilla/templates/         derived output: never edit by hand
  README.md                    consumer instructions
```

The `registry/` directory is what the CLI reads; everything else serves
authoring and review.

## 2. Authoring package

Author real, analyzed Dart and derive templates from it. Hand-written `.tmpl`
files have no analyzer behind them, and their first compiler is a consumer's
application.

- `publish_to: none`, no version. Nothing depends on it.
- **Mirror the installed layout.** Consumers receive `@ui/theme/*.dart` and
  `@ui/components/*.dart`; author under `source/lib/theme/` and
  `source/lib/components/` so relative imports (`../theme/tokens.dart`)
  resolve identically in both places.
- Dependencies: `remix` and `mix_annotations`; dev dependencies `build_runner`,
  `mix_generator`, `flutter_test`. Use the **same constraints as the official
  Vanilla catalog** at the revision you test against — read them from
  [`registry/vanilla/registry.yaml` on `registry-stable`](https://github.com/conceptadev/remix/blob/registry-stable/registry/vanilla/registry.yaml)
  rather than copying a version from memory. Upgrade them together.
- `@MixWidget` recipes need no `build.yaml`; consumers do not get one either.
  Keep recipes on `@MixWidget` so installation stays build-config-free.
- Commit the generated `.g.dart` parts so the package analyzes and tests; they
  are not templates.

## 3. Authoring rules

**One authoring word.** Pick a PascalCase word, for example `Acme`. Derivation
replaces every `Acme` with `{{typePrefix}}` and every `acme` with
`{{valuePrefix}}`, comments and strings included. A consumer initialized with
`--prefix Ui` receives `UiButton`, `uiButtonStyle`, and token ids such as
`'ui.color.primary'`. So the word must appear **only** at the start of an
identifier or a token id:

| Source | Installed for `--prefix Ui` | OK? |
| --- | --- | --- |
| `class AcmeButton` | `class UiButton` | yes |
| `ButtonStyler acmeButtonStyle(...)` | `ButtonStyler uiButtonStyle(...)` | yes |
| `ColorToken('acme.color.primary')` | `ColorToken('ui.color.primary')` | yes |
| `/// Follows the Acme brand guide.` | `/// Follows the Ui brand guide.` | **no** |
| `// Generated from @acme/tokens 3.1.0` | `// Generated from @ui/tokens 3.1.0` | **no** |
| file `acme_button.dart` | file name is not rendered | **no** |

Write prose as "this design system"; keep upstream package names and
provenance out of shipped source (they belong in `specs/` and the ADR).

**Imports.** Templates may import only:

- `package:flutter/widgets.dart` (and `foundation.dart`/`services.dart`) —
  never Material or Cupertino;
- `package:remix/remix.dart`, which re-exports Mix — never `package:mix` or
  `package:naked_ui` directly, since consumers do not declare them;
- `package:mix_annotations/mix_annotations.dart` in files with a generated
  part;
- relative imports of files the same item or its dependencies install.

**No literal `{{`** anywhere in source; the CLI rejects any placeholder other
than the two it renders.

## 4. Derivation

Templates are build output. Never edit a `.tmpl` by hand — the next
derivation overwrites it and `--check` fails until it does. Review and fix
the authored source instead; a template that has no authored source is
itself a finding.

A short script owned by the repository. Its contract:

- Walks `source/lib`, skipping `.g.dart` files.
- Rejects the authoring word in a file path, a literal `{{`, and any
  occurrence of the word that does not start an identifier or a token id.
- Writes `registry/vanilla/templates/<same relative path>.tmpl`, deleting
  templates whose source is gone.
- `--check` compares instead of writing and fails on any missing, changed, or
  stale template. Run it in CI.

```dart
// tool/derive_templates.dart: run from the repository root.
// `dart run tool/derive_templates.dart` writes; `--check` only compares.
import 'dart:io';

const typeWord = 'Acme';
const valueWord = 'acme';
const sourceRoot = 'source/lib';
const templateRoot = 'registry/vanilla/templates';

// The word may only start an identifier (AcmeButton, acmeButtonStyle) or a
// token id ('acme.color.primary'); anywhere else it becomes the prefix.
final leak = RegExp('(?<![A-Za-z0-9_])(?:$typeWord|$valueWord)(?![A-Z.])');

void main(List<String> args) {
  final expected = <String, String>{};
  final sources = Directory(sourceRoot)
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'));
  for (final file in sources) {
    final relative = file.path.substring(sourceRoot.length + 1);
    final source = file.readAsStringSync();
    final hit = leak.firstMatch(source);
    if (relative.contains(valueWord) || source.contains('{{') || hit != null) {
      throw StateError('$relative: authoring word or "{{" at ${hit?.start}');
    }
    expected['$templateRoot/$relative.tmpl'] = source
        .replaceAll(typeWord, '{{typePrefix}}')
        .replaceAll(valueWord, '{{valuePrefix}}');
  }

  final root = Directory(templateRoot);
  final existing = root.existsSync()
      ? root.listSync(recursive: true).whereType<File>().map((f) => f.path)
      : const Iterable<String>.empty();
  final stale = existing.where((path) => !expected.containsKey(path)).toList();
  final changed = [
    for (final MapEntry(:key, :value) in expected.entries)
      if (!File(key).existsSync() || File(key).readAsStringSync() != value) key,
  ];

  if (args.contains('--check')) {
    if (stale.isEmpty && changed.isEmpty) return;
    stderr.writeln('Template drift:\n${[...stale, ...changed].join('\n')}');
    exitCode = 1;
    return;
  }
  for (final path in stale) {
    File(path).deleteSync();
  }
  for (final path in changed) {
    File(path)
      ..createSync(recursive: true)
      ..writeAsStringSync(expected[path]!);
  }
}
```

## 5. Catalog

`registry/index.yaml` (schema 1) maps presets to catalogs. Offer `vanilla`
only:

```yaml
schema: 1
presets:
  vanilla: vanilla/registry.yaml
```

`registry/vanilla/registry.yaml` (schema 2) lists items. Item names match
`^[a-z][a-z0-9_]*$`.

```yaml
schema: 2
items:
  theme:
    dependencies:
      remix: "<the official vanilla catalog's remix constraint>"
    files:
      - source: templates/theme/tokens.dart.tmpl
        target: "@ui/theme/tokens.dart"
      - source: templates/theme/theme_data.dart.tmpl
        target: "@ui/theme/theme_data.dart"
      - source: templates/theme/theme_scope.dart.tmpl
        target: "@ui/theme/theme_scope.dart"
    exports:
      - theme/tokens.dart
      - theme/theme_data.dart
      - theme/theme_scope.dart

  button:
    registryDependencies:
      - theme
    dependencies:
      mix_annotations: "<same constraint as the official catalog>"
    devDependencies:
      build_runner: "<same constraint as the official catalog>"
      mix_generator: "<same constraint as the official catalog>"
    files:
      - source: templates/components/button.dart.tmpl
        target: "@ui/components/button.dart"
    generated:
      - "@ui/components/button.g.dart"
    exports:
      - components/button.dart
```

| Field | Required | Meaning |
| --- | --- | --- |
| `files` | yes | template `source` (starts with `templates/`) → installed `target` (starts with `@ui/`) |
| `registryDependencies` | no | items installed first; a bare name is an item of this registry |
| `dependencies` | no | pub constraints the installed source needs at runtime |
| `devDependencies` | no | pub constraints needed only to build (codegen) |
| `generated` | no | `@ui/` files the consumer's `build_runner` must produce |
| `exports` | no | paths, relative to the UI folder, added to the CLI-managed barrel |

Item design rules:

- **The theme is one shared item** that every component depends on, so any
  single `add` installs a working theme.
- **One item per component**, one generated part per item.
- **No two items may own the same target**, and no item may own `@ui/ui.dart`
  (the CLI assembles that barrel). A file two components need is a third
  item both depend on.
- Declare every package a template imports under `dependencies`; the CLI
  rejects constraints that do not intersect across the graph.
- Every relative import in an installed file must resolve to a target the
  item or its dependencies install.
- No `@remix/...` dependencies (see the self-contained constraint in
  `SKILL.md`).

## 6. Publish and test

The CLI reads registries from GitHub only. Test every catalog or template
change from a pushed branch in a scratch application initialized with the
`vanilla` preset (the CLI requires Flutter 3.44 or newer):

```shell
flutter create --empty scratch && cd scratch
flutter pub add dev:remix_cli
dart run remix_cli:remix init --prefix Ui
dart run remix_cli:remix registry add @acme \
  --repository acme/design-system --path registry --ref my-change
dart run remix_cli:remix add @acme/button --dry-run
dart run remix_cli:remix add @acme/button
```

`--dry-run` resolves the whole graph and renders every template without
writing, so catalog and placeholder errors surface there. `add` then writes,
formats, runs `build_runner` for declared parts (failing if one is not
produced), and analyzes the UI folder. Install every item, build the app, and
render each component inside the installed scope.

Iterate by pushing to the same branch, then:

```shell
dart run remix_cli:remix registry update @acme
dart run remix_cli:remix add @acme/button --overwrite
```

Use a prefix other than your authoring word in the scratch app; that is what
exposes a leaked word.

**Choose the ref consumers follow.** A branch (for example `stable`) that you
fast-forward only to a commit that passed the scratch-app check lets
consumers move with a bare `registry update`. Tags and SHAs stay fixed until
the consumer passes `--ref`. Every consumer records the resolved commit in
`remix.yaml`, so moving your branch never changes an application until it
updates its pin.

**Consumer README.** State the namespace, the exact `registry add` command,
that the application must be initialized with the `vanilla` preset, and that
it should install only `@acme/*` items.

## 7. Limits

| Not supported | Consequence |
| --- | --- |
| A preset other than `vanilla` or `fortal` | `registry add` fails: the project's preset must exist in every registry |
| Private repositories, GitHub Enterprise, HTTP or local registries | publish publicly; test through pushed branches |
| Placeholders other than `{{typePrefix}}` / `{{valuePrefix}}` | installation fails with an unsupported-token error |
| Changing a consumer's `defaultRegistry` from the CLI | consumers name items explicitly: `add @acme/button` |
| An offline cache | installs need network access to github.com |
