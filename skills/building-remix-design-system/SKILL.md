---
name: building-remix-design-system
description: >-
  Builds reusable design systems on Remix (Mix + Naked UI) and publishes them
  as Remix registries that applications install with `remix_cli`: registry
  repository scaffolding, `index.yaml` and `registry.yaml` catalogs,
  `.dart.tmpl` derivation with `{{typePrefix}}`/`{{valuePrefix}}`, cited token
  extraction, the theme item, and `@MixWidget` component recipes. Use when
  porting Material, Polaris, Fluent, Carbon, or a brand to Remix as
  installable source (even if one app consumes it first), from token
  packages, Figma, docs, PDFs, screenshots, or a brief; or when authoring,
  reviewing, or publishing a Remix registry. Not for consuming a registry or
  restyling installed Remix source inside one application; use `using-remix`.
---

# Building a Design System Registry on Remix

A design system built with this skill is a **Remix registry**: a public GitHub
repository of analyzer-checked Dart that applications install as source they
own, with `remix_cli`. Consumers register it under a namespace and install its
items:

```shell
dart run remix_cli:remix registry add @acme --repository acme/design-system --path registry --ref stable
dart run remix_cli:remix add @acme/button
```

Use `using-remix` for application UI that consumes Remix or an installed
preset, including restyling that installed source inside one application. Use
the `mix` skill alongside this one for exact Mix styler and `@MixWidget`
syntax.

## What you are building

```
naked_ui        interaction behavior (focus, press, semantics, keyboard)
   ↑
mix             styling engine: stylers, tokens, MixScope, variants
   ↑
remix           component machinery: Remix* widgets and their *Styler types
   ↑
your registry   a theme item (tokens + values + scope) and one item per
                component recipe, installed into each application's UI folder
```

Your registry adds only the target system's design decisions. Remix keeps
rendering, interaction, accessibility, and loading/disabled rules; never
reimplement them.

The official Vanilla preset is the reference implementation for every layer:
its [catalog](https://github.com/btwld/remix/blob/registry-stable/registry/vanilla/registry.yaml),
[theme templates](https://github.com/btwld/remix/tree/registry-stable/registry/vanilla/templates/theme),
and [button recipe](https://github.com/btwld/remix/blob/registry-stable/registry/vanilla/templates/button/button.dart.tmpl).
Follow its shape; do not clone its values.

## Constraints that shape every decision

These are enforced by the CLI; design around them rather than discovering
them at publish time. Four names are easy to confuse:

| Name | Who picks it | Example | Meaning |
| --- | --- | --- | --- |
| Preset | fixed by the official registry | `vanilla`, `fortal` | the design language a project selects once at `remix init` |
| Namespace | the consumer, at `registry add` | `@acme` | how a project refers to your registry |
| Prefix | the consumer, at `remix init` | `Shop` | the word rendered into every installed name (`ShopButton`) |
| Authoring word | you, once | `Acme` (value form `acme`) | the word your source uses where the prefix goes; derivation turns it into the placeholders |

- **Publish under the `vanilla` preset.** A project selects one preset at
  `remix init`, and every registry it registers must offer that preset. A
  third-party registry cannot introduce a new preset such as `acme`.
  `vanilla` is the default preset. Do not also map `fortal`: a Fortal project
  already owns `@ui/theme/*`, so your theme item would be skipped as installed
  and your recipes would then fail against Fortal's tokens. Your namespace,
  not the preset, identifies your system. Recommend a namespace and a prefix in your README (for example
  `@acme` and `--prefix Acme`).
- **Make the registry self-contained.** Ship your own `theme` item and depend
  on no `@remix/*` items. Official and third-party items render the same
  prefixed names (`<Prefix>Tokens`, `<Prefix>Button`) into the same targets,
  and the CLI treats an existing file as installed without checking which
  registry wrote it. Tell consumers to install only `@acme/*` items.
- **Public github.com only.** There is no private, enterprise, HTTP, or local
  registry, so every test of catalog changes goes through a pushed branch.
- **Templates are Dart with placeholders**: `{{typePrefix}}` (the
  consumer's prefix, `Shop`), `{{valuePrefix}}` (its lower-camel form,
  `shop`), and the icon pair `{{icon:import}}` / `{{icon:<name>}}`, which
  resolve through the registry's `icons.yaml` to the consumer's
  `iconLibrary`. Any other `{{...}}` fails installation.
- **Consumers generate code.** A template's `part '*.g.dart'` is produced by
  the consumer's `build_runner`, declared in the catalog's `generated` list.

## Workflow

1. **Sources and scope.** Inventory token domains and classify/pin their sources
   with [tokens](references/tokens.md). Preserve the target's theme model and
   vocabulary; decide modes, fonts/icons and scope explicitly. Keep evidence
   in the brief/spec. Record a short decision only for a costly boundary,
   rejected direction or lasting tradeoff; prefer an existing architecture log
   over creating a numbered ADR. Routine reversible choices need no new record.
2. **Authoring and derivation.** Use the [registry layout](references/registry.md):
   a private analyzed Dart package mirroring installed paths, generated
   templates, catalogs, prefix round trips and whole-tree `--check` coverage.
3. **Theme.** Build token identities/scales, mode values with equality, and a
   scope taking `theme`, `darkTheme`, `mode`, `child`. Cover every token in every
   supported mode; check values against one cited specification.
4. **Components.** Use the target system's vocabulary and `@MixWidget` recipes.
   For a new measurable visual contract, record anatomy, variants, states,
   measurements and deviations before implementing; extend an existing spec
   when it already owns that contract. An ordinary fix needs no new worksheet.
   See [components](references/components.md) for loading/focus, unresolved child
   styles, merge order and overlay scope hazards.
5. **Publish and verify.** Analyze/test authored code, derive and check for
   drift, then use a pushed branch in a fresh `vanilla` scratch app with a
   different prefix. Install every item, generate, analyze, build and render
   each component/mode. Advance the consumer ref only after those checks.

The consumer README must state namespace, repository/path/ref, required preset,
exclusive `@<namespace>/*` use and host/theme setup. Refresh every changed item,
including theme dependencies, during iteration; `--overwrite` only replaces
named items. [Registry](references/registry.md#6-publish-and-test) owns that loop.

## References

- [Registry](references/registry.md): layout, prefix leakage, derivation, catalogs,
  public-GitHub limits, target ownership and scratch installs.
- [Tokens](references/tokens.md): inventory, provenance, source tiers, conflicts
  and deliberate upgrades.
- [Components](references/components.md): scope/recipe shapes, concrete runtime
  pitfalls, contract worksheets and tests.
