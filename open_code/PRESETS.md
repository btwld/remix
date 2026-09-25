# Presets: application-owned source

See [pinned GitHub registries](REGISTRIES.md) for namespaces, revision updates,
migration, and independent registry releases.

## Current implementation

The official Remix GitHub distribution provides `vanilla` and `fortal`.
Their manifests and templates are derived from analyzer-checked Dart by
`tool/build_registry.dart`; none are hand-authored. The initial `carbon`
vertical slice is independently authored and published by
[`btwld/flutter-carbon`](https://github.com/btwld/flutter-carbon).

```text
registry_source/                 one private workspace package
  lib/src/default/              Vanilla theme, components, Agent recipes
  lib/src/fortal/               Fortal theme, components, Agent recipes
  lib/src/agent/                shared Agent behavior, models, support
  lib/src/dashboard/            shared dashboard composition
registry/
  vanilla/                     derived registry.yaml and templates/
  fortal/                      derived registry.yaml and templates/
```

The accepted [registry-source ADR](../registry_source/docs/adr/fortal/0002-registry-source.md)
records the hard cutoff. The old package names are not consumer dependencies.
Agent behavior stays private during authoring and installs as editable source;
it is not a separately published runtime package.

## Consumer contract

A preset is chosen once at initialization. Theme tokens and component variants
belong to that preset, so a consumer cannot mix the preset trees.

```shell
dart run remix_cli:remix init --prefix Acme --preset fortal
dart run remix_cli:remix add button
dart run remix_cli:remix add composer_recipe
```

```yaml
schema: 3
prefix: Acme
preset: fortal
paths:
  ui: lib/ui
defaultRegistry: "@remix"
registries:
  "@remix":
    repository: btwld/remix
    path: registry
    ref: registry-stable
    revision: "<resolved-full-commit-sha>"
```

The official index exposes `vanilla` and `fortal`. The Carbon repository's own
index exposes `carbon`, and the CLI knows its default `@carbon` source.
`default` was the name an earlier prerelease used for `vanilla` and is not a
preset either registry serves.
Installed type names and token IDs use the consumer prefix, for example
`AcmeButton` and `acme.accent.9`.
`Fortal` is an authoring prefix, not a required installed prefix; the review
catalog deliberately chooses it as its consumer prefix.

A recipe installs its dependency closure, not the entire catalog. The eight
Agent surfaces (`activity`, `answer`, `composer`, `execution`, `message`,
`permission`, `plan`, `transcript`) can install bare or through their
`*_recipe` bundles. Shared `models` and `support` install transitively.
The `dashboard_shell` grouped recipe combines shared composition with one
preset adapter and installs only its shell dependency closure. It leaves the
host entry point, routes, page body, authentication, and persistence alone.
The `dashboard_demo` grouped recipe adds the full twelve-destination reference
application: Overview, Chat, Customers, Orders, Settings, Charts, Actions,
Forms & Inputs, Data Display, Overlays, Navigation, and Typography. Both
Vanilla and Fortal share the information architecture and product content; component
galleries render each preset's own public variants. The host still owns the
entry point, theme scope, routes, authentication, and persistence.

Installed Dart imports the public `remix` API, not `registry_source`.
`mix_chart` and `remix_ui_icons` remain opt-in hosted dependencies of the items
that use them. Items with generated parts declare the generation dependencies;
the consumer generates its own adapters rather than copying authoring outputs.

Carbon currently exposes only `theme` and `button`. Its installed source uses
the consumer prefix, includes the four Carbon theme maps, and has no Agent,
chart, icon, or dashboard items. Its source and publication gate live in the
separate Carbon repository, not the official `@remix` catalog.

When installed source uses `@MixableSpec`, the CLI enables the supported
spec-styler builder in the consumer's `build.yaml`. A new builder is scoped to
literal installed paths. Existing all-source settings remain all-source;
existing filters are extended only for missing installed paths. Explicit
exclusions, disabled builders, or competing target ownership fail preflight.
Both `$default` and package-named default targets are supported. Dry-run and
diff show proposed changes without writing them.

## Authoring and derivation

Edit official Dart under `registry_source/lib/src/`, never `.tmpl` output.
Vanilla uses the authoring word `Vanilla`, Fortal uses `Fortal`, and shared
behavior uses `Agent`. The builder checks prefix round trips and rewrites shared Agent
imports to their installed relative paths. Relative source imports determine
registry dependencies; generated parts determine adapter targets.

Fortal's Radix color table remains pinned source with a parity contract. Its
internal theme barrel excludes the unprefixed color-table globals from the
consumer's public barrel. Hosted dependency floors are shared through the
Vanilla registry and checked for drift.

```shell
dart run melos run open-code:registry:build
dart run melos run open-code:registry:check
```

The build command derives both official presets. The check runs builder tests and
compares the complete output trees, including unexpected or missing files.
`--preset vanilla` or `--preset fortal` selects one preset when invoking
`tool/build_registry.dart` directly.

## Repository consumers

- `apps/playground`: full Vanilla catalog, prefix `Playground`; its indigo
  theme customization is declared in the dogfood checker.
- `apps/demo`: non-Agent Fortal review catalog, prefix `Fortal`.
- `apps/dashboard`: full Fortal catalog including Agent surfaces and recipes,
  prefix `Ui`. Workspace → Chat demonstrates the eight surfaces together.

All three consume installed source. The repository dashboard pages and its
simulated runner remain application-owned. The reusable `dashboard_shell` and
full `dashboard_demo` are distributed as separate stacked registry items; a
standalone composed `chat` item is still separate work.

## Verification and release

```shell
dart run melos run ci
```

CI includes analysis, clean generation, formatting, registry derivation,
parity, docs, package tests, installed-source comparisons, and fresh checkout
consumers for both official presets. Passing checkout checks does not establish
hosted release installability. The separate Carbon repository runs its own
consumer gate.

[RELEASING.md](RELEASING.md) describes package dry-runs, hosted runtime checks,
CLI publication, and verification of published registry assets. Discontinuing
the old hosted Fortal package is a release action after those checks, not part
of the source-tree migration.

## Separate follow-ups

- In-place preset switching and initialization theme knobs.
- A standalone composed chat registry item.
- Deliberate visual changes beyond the existing Agent recipes. The
  [worksheet reconciliation](../registry_source/specs/README.md) distinguishes
  reference measurements from shipped defaults.

The original five-commit preset plan is preserved in Git history; it is not a
pending execution checklist for this implementation.
