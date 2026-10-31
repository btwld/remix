# Registry reference

How a design system becomes a Remix registry: repository layout, authoring
rules, derivation, the catalog format, and the publish-and-test loop. Examples
use a system named "Acme" registered as `@acme`.

## 1. Repository layout

```text
acme-design-system/            public github.com repository
  source/                      authoring package: analyzed and tested, never published
    pubspec.yaml
    lib/theme/                 tokens.dart, theme_data.dart, theme_scope.dart, and any scale or helper files
    lib/components/            one recipe per component (+ its .g.dart part)
    test/
  specs/
    tokens.yaml                token inventory, values, citations (references/tokens.md)
    components/<name>.yaml     one worksheet per component
  ARCHITECTURE.md               significant decisions, if needed; reuse an existing log
  tool/
    derive_templates.dart      source/lib → registry/vanilla/templates
    extract/                   tier 1–2 token extraction, if any (references/tokens.md)
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
  [`registry/vanilla/registry.yaml` on `registry-stable`](https://github.com/btwld/remix/blob/registry-stable/registry/vanilla/registry.yaml)
  rather than copying a version from memory. Upgrade them together.
- `@MixWidget` recipe installs stay build-config-free. `@MixableSpec` installs
  write a consumer `build.yaml` that enables the spec-styler builder.
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
provenance out of shipped source (keep it in the brief/spec or decision log).

**Imports.** Templates may import:

- widgets-layer Flutter (`widgets.dart`, `foundation.dart`, `services.dart`)
  — never Material or Cupertino, which consumers may not have as ancestors;
- `package:remix/remix.dart`, which re-exports Mix — never `package:mix`
  directly;
- `package:mix_annotations/mix_annotations.dart` in files with a generated
  part;
- any other package the item declares under `dependencies`, as the official
  Vanilla catalog does for `mix_chart` (declare
  `naked_ui` with the constraint `remix` uses when a component needs behavior
  Remix does not wrap);
- relative imports of files the same item or its dependencies install.

**Fonts, icons, and assets.** The CLI writes Dart files into the UI folder
and adds package dependencies; it cannot add `fonts:` or `assets:` to a
consumer's pubspec. Ship icons and fonts as a pub package an item declares
(Vanilla's `theme` item declares `remix_ui_fonts`; icon packages come from
`icons.yaml`, below), or document the
consumer's pubspec step in the README; preserve any significant tradeoff in the decision log.

**No literal `{{`** anywhere in source; the CLI rejects any placeholder other
than the ones it renders: `{{typePrefix}}`, `{{valuePrefix}}`,
`{{icon:import}}`, and `{{icon:<name>}}`. The icon pair resolves through
`icons.yaml` beside `index.yaml` (`schema: 1` or `2`, `libraries` with each
library's `dependency`, `import`, and `class`, and `icons` mapping every
canonical name to a constant in every library). In schema 2 an icon may leave
out a library that does not draw it by naming a `fallback` library that does
(`checkCircled: {lucide: circleCheck, fallback: lucide}`), and the default
library's constant may differ from the canonical name; schema 2 needs
`remix_cli` 1.0.0-beta.1. A template with an icon constant also carries
`{{icon:import}}` in its import block; the CLI imports and adds the package of
every library the file's icons render from.

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

Use the maintained [official builder](https://github.com/btwld/remix/blob/main/tool/build_registry.dart)
and its [tests](https://github.com/btwld/remix/blob/main/test/tool/build_registry_test.dart)
as the implementation reference. Keep the derivation script local and small;
assert rendering with a different consumer prefix and deriving it back yields
byte-identical source. Compare the entire output tree, including catalog
structure, so orphaned files cannot escape drift checks.

The official registry has explicit stable data filename exceptions such as
`theme/fortal_colors.dart`. These preserve literal imports, while Dart types
still render with the consumer prefix; a filename exception is not permission
for arbitrary prefix leakage. Catalog dependency floors and icon mappings are
maintained inputs, as [the official contract](https://github.com/btwld/remix/blob/main/open_code/REGISTRIES.md#authoring-and-derivation)
explains.

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
- Group files by installable component. Compound items may declare multiple
  adapters; list every generated part (the official chart item generates three
  adapters in one `chart.g.dart` file).
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
`vanilla` preset (the CLI refuses a Flutter older than its minimum and names
the version it needs):

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

The [main skill](../SKILL.md#constraints-that-shape-every-decision) owns preset,
public-GitHub and placeholder limits. There is no offline cache; installs need
network access. The CLI does not change a consumer's `defaultRegistry`, so name
third-party items explicitly (`add @acme/button`).
