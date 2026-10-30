---
name: building-remix-design-system
description: >-
  Builds reusable design systems on Remix (Mix + Naked UI), including
  first-party presets beside Fortal and third-party registries that
  applications install with `remix_cli`: registry
  repository scaffolding, `index.yaml` and `registry.yaml` catalogs,
  `.dart.tmpl` derivation with `{{typePrefix}}`/`{{valuePrefix}}`, cited token
  extraction, the theme item, and `@MixWidget` component recipes. Use when
  porting HeroUI web, Material, Polaris, Fluent, Carbon, or a brand to Remix as
  installable source (even if one app consumes it first), from token
  packages, Figma, docs, PDFs, screenshots, or a brief; or when authoring,
  reviewing, or publishing a Remix registry. Not for consuming a registry or
  restyling installed Remix source inside one application; use `using-remix`.
---

# Building a Design System Registry on Remix

A design system built with this skill ships through a **Remix registry**:
analyzer-checked Dart that applications install as source they own, with
`remix_cli`. It can be a first-party preset in `btwld/remix` or a self-contained
third-party registry. Third-party consumers register a namespace and install
its items:

```shell
dart run remix_cli:remix registry add @acme --repository acme/design-system --path registry --ref stable
dart run remix_cli:remix add @acme/button
```

Use `using-remix` for application UI that consumes Remix or an installed
preset, including restyling that installed source inside one application. Use
the `mix` skill alongside this one for exact Mix styler and `@MixWidget`
syntax.

## Choose the authoring route first

| Task | Route |
| --- | --- |
| Add a preset beside Vanilla/Fortal in `btwld/remix` | Read `open_code/ADDING_PRESETS.md` in that checkout. Extend `registry_source` and the existing builder, consumer harness, and CI; do not scaffold another repository or force the new preset under `vanilla`. |
| Publish a separate design-system registry | Use the repository and distribution workflow below and `references/registry.md`. |
| Port an existing web design system | Also read `references/reference-parity.md` before extracting tokens or writing recipes. |
| Restyle source owned by one app | Use `using-remix`. |

The first-party checklist is also available in the
[Remix repository](https://github.com/btwld/remix/blob/main/open_code/ADDING_PRESETS.md).
The phases below apply to both authoring routes; repository creation and
publication instructions default to the third-party route.

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

Target the exported Remix components and thin compositions of them. When
styling cannot express a decision, extend in order: style, compose, propose a
general Remix API as a separate change, or approximate and record it
(`references/reference-parity.md` §2). A family that needs behavior Remix
does not provide is deferred, not built in the preset.

The official Vanilla preset is the reference implementation for every layer:
its [catalog](https://github.com/btwld/remix/blob/registry-stable/registry/vanilla/registry.yaml),
[theme templates](https://github.com/btwld/remix/tree/registry-stable/registry/vanilla/templates/theme),
and [button recipe](https://github.com/btwld/remix/blob/registry-stable/registry/vanilla/templates/button/button.dart.tmpl).
Follow its shape; do not clone its values.

## Constraints that shape every decision

Distinguish CLI constraints from the recommended third-party distribution
route. Four names are easy to confuse:

| Name | Who picks it | Example | Meaning |
| --- | --- | --- | --- |
| Preset | registry maintainers | `vanilla`, `fortal` | the design language a project selects once at `remix init` |
| Namespace | the consumer, at `registry add` | `@acme` | how a project refers to your registry |
| Prefix | the consumer, at `remix init` | `Shop` | the word rendered into every installed name (`ShopButton`) |
| Authoring word | you, once | `Acme` (value form `acme`) | the word your source uses where the prefix goes; derivation turns it into the placeholders |

- **Use `vanilla` for the normal third-party setup.** `init` resolves the
  official registry, which must contain the requested preset. The config
  accepts lowercase preset identifiers; it is not a two-name enum. Adding a
  custom preset to a third-party index alone does not make
  `remix init --preset acme` work. Every registered registry must offer the
  project's selected preset. First-party maintainers can add an official
  preset through the checklist above.
  `vanilla` is the default preset. Do not also map `fortal`: a Fortal project
  already owns `@ui/theme/*`, so an overlapping theme is rejected before
  installation. Your namespace, not the preset, identifies your system. Recommend a namespace and a prefix in your README (for example
  `@acme` and `--prefix Acme`).
- **Make a third-party registry self-contained.** Ship your own `theme` item and depend
  on no `@remix/*` items. Official and third-party items render the same
  prefixed names (`<Prefix>Tokens`, `<Prefix>Button`) into the same targets,
  and the CLI rejects overlapping owners across installations. Legacy source
  without recorded ownership requires explicit, verified `--adopt` migration.
  Tell consumers to install only `@acme/*` items.
- **Public github.com only in the production CLI.** There is no private,
  enterprise, HTTP, or local registry option. First-party maintainers can
  test unpushed catalogs through the internal checkout consumer harness;
  this is not a consumer-facing local-registry feature.
- **Templates are Dart with placeholders**: `{{typePrefix}}` (the
  consumer's prefix, `Shop`), `{{valuePrefix}}` (its lower-camel form,
  `shop`), and the icon pair `{{icon:import}}` / `{{icon:<name>}}`, which
  resolve through the registry's `icons.yaml` to the consumer's
  `iconLibrary`. Any other `{{...}}` fails installation.
- **Consumers generate code.** A template's `part '*.g.dart'` is produced by
  the consumer's `build_runner`, declared in the catalog's `generated` list.

## Workflow

Work through the phases in order; each ends with a check.

Paths below use the third-party layout. For a first-party preset, use the
checklist's paths instead: ADRs in `registry_source/docs/adr/<preset>/`, tokens
in `registry_source/specs/<preset>/tokens.json`, worksheets in that preset's
`components/` spec directory, and source in `registry_source/lib/src/<preset>/`.
Keep shared Agent worksheets separate from the new preset's parity contract.

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
4. For a reference port, map each upstream family to a Remix recipe, a
   composition, or deferred, and plan the appearance evidence in
   `references/reference-parity.md`; copying Vanilla or Fortal values is not a port.

Done when the ADR exists and every token domain has a tier and a pinned
source.

### Phase 1 — Registry repository

For a first-party preset, follow `open_code/ADDING_PRESETS.md` instead of
creating another package or derivation script. For a third-party registry,
scaffold the repository described in `references/registry.md`: an
analyzer-checked authoring package that mirrors the installed layout, a
derivation script that turns it into `registry/vanilla/templates/`, and the
`index.yaml` and `registry.yaml` catalog. Choose the authoring word (for
example `Acme`) now; it may appear only inside identifiers and at the start of
token ids (`references/registry.md` §3).

Done when the empty theme item derives, `--check` passes, and the catalog
validates in a scratch application.

### Phase 2 — Theme item

Build `tokens.dart`, `theme_data.dart`, and `theme_scope.dart` in Vanilla's
shape (`references/components.md` §1): token identities and fixed scales, concrete values per
mode with value equality, and a theme widget taking `theme`, `darkTheme`, and `mode`.
Put shared recipe helpers beside them, as Vanilla's
`effects.dart` does.
Record every value's source in `specs/tokens.yaml` and test the Dart values
against it (`references/tokens.md` §4).

Done when the theme renders in every mode and the token test passes.

### Phase 3 — Components

Per component — display components first, then buttons and inputs, overlays
last (they depend on `wrap` carrying the scope):

1. Write the worksheet `specs/components/<component>.yaml` first: anatomy,
   variants, sizes, states, consumed tokens, sourced measurements, and
   approximations.
2. Write the recipe as a top-level `@MixWidget(target: Remix<Component>.new)`
   function in the target system's vocabulary, styled only through tokens.
   Curate exposed parameters with `widgetParameters`; a hand-written facade
   over a Remix widget is a recorded exception that keeps Remix's API.
3. Add widget tests in the authoring package, derive, and add the catalog
   item with its `generated` part and package constraints.

Done when the component's tests pass and `--check` is clean.

### Phase 4 — Publish and verify

For a first-party preset, run the checkout consumer and parity gates first;
verify the hosted/published boundary separately per `open_code/RELEASING.md`.
Do not treat this workflow as authorization to push or publish.

For a third-party registry, when publication is authorized, push a working
branch, register it from a scratch application initialized
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
- A fresh application using the intended preset installs every item,
  generates its parts, analyzes clean, and runs. First-party work passes the
  checkout harness; published releases also pass the remote/hosted check.
- Reference ports have upstream measurements for the claimed modes, sizes,
  breakpoints, and visual states, a reviewed side-by-side capture, and stated
  approximations.
- Worksheets exist for every shipped component; approximations are stated.
- Consumer setup matches the authoring route. A published first-party preset
  uses `init --preset <preset>` and the official `@remix` namespace once the
  served index includes it. A third-party README names the repository, path,
  ref, and namespace to register, and tells consumers to install only that
  registry's items.

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
11. Porting upstream behavior or prop shapes (interaction policies,
    controlled/uncontrolled pairs, form engines) instead of styling Remix
    (`references/reference-parity.md` §1–2).

## References

- **`references/registry.md`** — repository layout, authoring rules,
  derivation, catalog format, the publish-and-test loop, CLI limits.
- **`references/tokens.md`** — getting tokens out of any source, traceability,
  and when an extraction script earns its place.
- **`references/components.md`** — theme item shape, recipe shape, Remix and
  Mix pitfalls, worksheet template, tests.
- **`references/reference-parity.md`** — porting a web design system: mapping
  families onto Remix, the extension order, appearance evidence, acceptance.
