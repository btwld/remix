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
its [catalog](https://github.com/conceptadev/remix/blob/registry-stable/registry/vanilla/registry.yaml),
[theme templates](https://github.com/conceptadev/remix/tree/registry-stable/registry/vanilla/templates/theme),
and [button recipe](https://github.com/conceptadev/remix/blob/registry-stable/registry/vanilla/templates/button/button.dart.tmpl).
Follow its shape; do not clone its values.

## Constraints that shape every decision

These are enforced by the CLI; design around them rather than discovering
them at publish time. Three names are easy to confuse:

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
  that already installed Fortal items owns `@ui/theme/*`, and your theme item
  would collide with those files. Your namespace, not the preset, identifies your
  system. Recommend a namespace and a prefix in your README (for example
  `@acme` and `--prefix Acme`).
- **Make the registry self-contained.** Ship your own `theme` item and depend
  on no `@remix/*` items. Official and third-party items render the same
  prefixed names (`<Prefix>Tokens`, `<Prefix>Button`) into the same targets,
  and the CLI treats an existing file as installed without checking which
  registry wrote it. Tell consumers to install only `@acme/*` items.
- **Public github.com only.** There is no private, enterprise, HTTP, or local
  registry, so every test of catalog changes goes through a pushed branch.
- **Templates are Dart with two placeholders**: `{{typePrefix}}` (the
  consumer's prefix, `Acme`) and `{{valuePrefix}}` (its lower-camel form,
  `acme`). Any other `{{...}}` fails installation.
- **Consumers generate code.** A template's `part '*.g.dart'` is produced by
  the consumer's `build_runner`, declared in the catalog's `generated` list.

## Workflow

Work through the phases in order; each ends with a check.

### Phase 0 — Sources and decisions

1. Inventory every design source and classify each token domain by tier
   (machine-readable, queryable, document, images, or a brief). Pin what can be
   pinned: exact package versions and commits, file versions, retrieval dates,
   sha256 hashes. Read `references/tokens.md`.
2. Record an ADR (`docs/adr/0001-scope-and-sources.md`): source tiers and
   conflict precedence, the theme model, which components the first release
   covers, what is out of scope, font and icon strategy, naming and trademark
   constraints, and the namespace consumers should use.
3. Decide the theme model: which modes (light/dark, high contrast), role-based
   names (`interactivePrimary`) or numbered scales (`accent1–12`). **Preserve
   the target system's model**; never translate it into Vanilla's or Radix's
   vocabulary. When designing from a brief, pick one deliberately and record
   why.

Done when the ADR exists and every token domain has a tier and a pinned
source.

### Phase 1 — Registry repository

Scaffold the repository described in `references/registry.md`: an
analyzer-checked authoring package that mirrors the installed layout, a
derivation script that turns it into `registry/vanilla/templates/`, and the
`index.yaml` and `registry.yaml` catalog. Choose the authoring word (for
example `Acme`) now; it may appear only inside identifiers and at the start of
token ids (`references/registry.md` §3).

Done when the empty theme item derives, `--check` passes, and the catalog
validates in a scratch application.

### Phase 2 — Theme item

Build `tokens.dart`, `theme_data.dart`, and `theme_scope.dart` in Vanilla's
shape (`references/components.md` §1): token identities, concrete values per
mode with value equality, and a scope taking `theme`, `darkTheme`, and `mode`.
Record every value's source in `specs/tokens.yaml` and test the Dart values
against it (`references/tokens.md` §4).

Done when the theme renders in every mode and the token test passes.

### Phase 3 — Components

Per component — display components first, then buttons and inputs, overlays
last (they depend on `wrap` carrying the scope):

1. Write the worksheet `specs/components/<component>.yaml` first: anatomy,
   variants, sizes, states, consumed tokens, sourced measurements, behavior,
   and approximations.
2. Write the recipe as a top-level `@MixWidget(target: Remix<Component>.new)`
   function in the target system's vocabulary, styled only through tokens.
   Hand-write a facade instead only when the public API cannot be expressed
   over the Remix widget.
3. Add widget tests in the authoring package, derive, and add the catalog
   item with its `generated` part and package constraints.

Done when the component's tests pass and `--check` is clean.

### Phase 4 — Publish and verify

Push a working branch, register it from a scratch application initialized
with the `vanilla` preset, and install every item (`references/registry.md`
§6). Advance the branch consumers follow only after that application builds,
analyzes clean, and renders every component.

## Definition of done (per release)

- The authoring package analyzes clean and its tests pass: every variant and
  size in every theme mode, measured default geometry, focus, disabled, and
  loading visuals.
- `specs/tokens.yaml` covers the whole inventory; the token test passes; no
  value lacks a citation or a recorded design rationale.
- Derivation `--check` passes: committed templates match the authored source
  byte for byte.
- A scratch `vanilla` application installs every item from the pushed ref,
  generates its parts, analyzes clean, and runs.
- Worksheets exist for every shipped component; approximations are stated.
- The README tells consumers the namespace, repository, path, and ref to
  register, and that only `@<namespace>/*` items belong in their app.

## Pitfall index

Each is explained where it applies.

1. The authoring word standing on its own in prose, provenance, or a file
   name — it becomes the consumer's prefix (`references/registry.md` §3).
2. Importing `package:mix` or Material in a template — reach Mix through
   `package:remix/remix.dart` and use only widgets-layer Flutter
   (`references/registry.md` §3).
3. Re-testing with `add <item> --overwrite` after a theme change — installed
   dependencies are not refreshed (`references/registry.md` §6).
4. A token without a value in the active theme — recipes throw when they
   resolve it (`references/components.md` §1).
5. Loading is Remix's disabled state; a recipe `bool loading` shared with the
   target keeps both in step (`references/components.md` §3).
6. Enum values or widget names borrowed from Vanilla or Fortal instead of the
   target system's vocabulary (`references/components.md` §2).
7. Focus rings drawn with a border shift layout (`references/components.md` §3).
8. `token().withValues(...)` accumulates through merges; use a `ContextToken`
   (`references/components.md` §3).
9. `InheritedTheme.wrap` must rebuild the `MixScope`, or overlays lose tokens
   (`references/components.md` §1).
10. Invented values for tokens the source does not define
    (`references/tokens.md` §2).

## References

- **`references/registry.md`** — repository layout, authoring rules,
  derivation, catalog format, the publish-and-test loop, CLI limits.
- **`references/tokens.md`** — getting tokens out of any source, traceability,
  and when an extraction script earns its place.
- **`references/components.md`** — theme item shape, recipe shape, Remix and
  Mix pitfalls, worksheet template, tests.
