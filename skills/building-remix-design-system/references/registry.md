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

- `publish_to: none`, no version. Nothing depends on it. Name it without the
  authoring word (for example `design_source`), and import between its
  `lib/` files relatively: a `package:design_source/...` import would install
  as a URI the consumer cannot resolve.
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

**One authoring word.** Pick a PascalCase word that is not part of any
ordinary word or other identifier, for example `Acme`; its lower-camel form
(`acme`) is the value word. Derivation replaces every `Acme` with
`{{typePrefix}}` and every `acme` with `{{valuePrefix}}`, comments and strings
included. A consumer initialized with `--prefix Shop` receives `ShopButton`,
`shopButtonStyle`, and token ids such as `'shop.color.primary'`. So the word
belongs only inside identifiers and at the start of quoted ids, never as a
word of its own:

| Source | Installed for `--prefix Shop` | OK? |
| --- | --- | --- |
| `class AcmeButton` | `class ShopButton` | yes |
| `ButtonStyler acmeButtonStyle(...)` | `ButtonStyler shopButtonStyle(...)` | yes |
| `Color resolveAcmePalette()` | `Color resolveShopPalette()` | yes |
| `/// Wraps [AcmeButton].` | `/// Wraps [ShopButton].` | yes |
| `ColorToken('acme.color.primary')`, `ValueKey('acme-row')` | `'shop.color.primary'`, `'shop-row'` | yes |
| `/// Follows the Acme brand guide.` | `/// Follows the Shop brand guide.` | **no** |
| `// Generated from @acme/tokens 3.1.0` | `// Generated from @shop/tokens 3.1.0` | **no** |
| `const title = 'ACME';` | not replaced; ships as written | **no** |
| file `acme_button.dart` or `AcmeButton.dart` | file names are not rendered | **no** |

Write prose as "this design system"; keep upstream package names and
provenance out of shipped source (they belong in `specs/` and the ADR).

**Imports.** Templates may import:

- widgets-layer Flutter (`widgets.dart`, `foundation.dart`, `services.dart`)
  — never Material or Cupertino, which consumers may not have as ancestors;
- `package:remix/remix.dart`, which re-exports Mix — never `package:mix`
  directly;
- `package:mix_annotations/mix_annotations.dart` in files with a generated
  part;
- any other package the item declares under `dependencies`, as the official
  Vanilla catalog does for `remix_ui_icons` and `mix_chart` (declare
  `naked_ui` with the constraint `remix` uses when a component needs behavior
  Remix does not wrap);
- relative imports of files the same item or its dependencies install.

**Fonts, icons, and assets.** The CLI writes Dart files into the UI folder
and adds package dependencies; it cannot add `fonts:` or `assets:` to a
consumer's pubspec. Ship icons and fonts as a pub package an item declares
(Vanilla's `icons` item declares `remix_ui_icons`), or document the
consumer's pubspec step in the README. Record the choice in the ADR.

**No literal `{{`** anywhere in source; the CLI rejects any placeholder other
than the two it renders.

## 4. Derivation

Templates are build output. Never edit a `.tmpl` by hand — the next
derivation overwrites it and `--check` fails until it does. Review and fix
the authored source instead; a template that has no authored source is
itself a finding.

A short script owned by the repository. Its contract:

- Walks `source/lib`, skipping `.g.dart` files.
- Rejects the word (any case) in a file path, a literal `{{`, the word
  standing on its own (the "no" rows above), and any other spelling such as
  `ACME` that substitution would leave behind.
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

// A leak is the word standing on its own instead of inside an identifier
// (AcmeButton, resolveAcmePalette, acmeButtonStyle) or opening a quoted id
// ('acme.color.primary', 'acme-row').
final leak = RegExp(
  '(?<![A-Za-z0-9_])$typeWord(?![A-Z0-9_])'
  "|(?<![A-Za-z0-9_'\"])$valueWord(?![A-Z0-9_])"
  "|(?<=['\"])$valueWord(?![A-Z0-9_.-])",
);
final anySpelling = RegExp(typeWord, caseSensitive: false);

void main(List<String> args) {
  final expected = <String, String>{};
  final sources = Directory(sourceRoot)
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'));
  for (final file in sources) {
    final relative = file.path.substring(sourceRoot.length + 1);
    final source = file.readAsStringSync();
    final template = source
        .replaceAll(typeWord, '{{typePrefix}}')
        .replaceAll(valueWord, '{{valuePrefix}}');
    final problem = anySpelling.hasMatch(relative)
        ? 'authoring word in the file path'
        : source.contains('{{')
        ? 'literal "{{"'
        : leak.hasMatch(source)
        ? 'authoring word at offset ${leak.firstMatch(source)!.start}'
        : anySpelling.hasMatch(template)
        ? 'another spelling of the authoring word'
        : null;
    if (problem != null) throw StateError('$relative: $problem');
    expected['$templateRoot/$relative.tmpl'] = template;
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
`vanilla` preset (the CLI stops with its minimum Flutter version if the
installed one is older):

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
dart run remix_cli:remix add @acme/theme @acme/button --overwrite
```

`--overwrite` rewrites only the items you name; installed dependencies are
kept exactly as they are. Name every item the change touched — `theme` after
any token change — or recreate the scratch app, otherwise the check runs
against stale source.

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
