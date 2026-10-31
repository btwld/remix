# Architecture decisions

Use the [README core concepts](README.md#core-concepts) for today's model.
This log records costly choices, their reasons and consequences; specifications,
contracts and runbooks remain separate. Update status and link the replacement
when a decision changes. Dates identify the original decision or first record.

## Applications own installed source

2026-09-10 · Accepted · [Registry contract](open_code/REGISTRIES.md) · [Walkthrough](open_code/README.md)

Install editable themes/recipes and generate adapters in the app against its
resolved Remix/Mix versions, because manual wrappers and parameter allowlists
silently miss new runtime APIs. Apps must review/regenerate adapter diffs after
recipe or constructor changes, and review installed Agent behavior as well as
appearance; Remix retains rendering, interaction and accessibility machinery.

## One analyzed authoring tree (Fortal ADR-0002)

2026-09-14 · Accepted; migration recorded 2026-09-17 · Supersedes Fortal ADR-0001 · [Contract](open_code/REGISTRIES.md#authoring-and-derivation) · [Migration #208](https://github.com/btwld/remix/pull/208)

Author Vanilla, Fortal and shared Agent source in the private `registry_source`
package and derive registries, replacing hand-written templates that escaped
analysis and duplicate installed/package types with enum bridges. This requires
whole-tree drift checks, prefix round trips and installed-consumer verification;
explicit fixed data filenames such as `theme/fortal_colors.dart` stay stable
while Dart types take the consumer prefix, and dependency floors/icon mappings
remain maintained inputs.

## Agent behavior separate from preset appearance (Agent ADR-0001)

2026-09-10 · Accepted; separate-package layout replaced 2026-09-17 · [Usage](registry_source/docs/agent/README.md) · [Provenance](registry_source/docs/adr/agent/provenance.md) · [Recipe checks](open_code/fixture/test/agent_recipe_contract_test.dart)

Keep conversation, permission and execution behavior in Agent domain source,
installed as app-owned source without an Agent theme/runtime package, so generic
Remix and visual presets do not own domain state machines. Presets provide
bundles of unresolved child stylers because parent resolution loses each child
control's interactive state, variants, animation and modifiers. Hosts own
appearance/orchestration, Agent anatomy defaults stay empty, and installed
`@MixableSpec` source requires scoped consumer `build.yaml` support.

## Registry reads use immutable GitHub pins

2026-09-21 · Accepted · [Contract and recovery](open_code/REGISTRIES.md)

Record a full GitHub revision per namespace in `remix.yaml` for every catalog
and template read, removing the bundled fallback and legacy schema-1/2 project
shapes before 1.0 so installs have one explicit source. This requires network
access and reinitializing old configurations; changing a pin never adopts or
reverts application-owned source, and fetch failure must fail rather than
substitute another catalog.

## Promote registry content independently

2026-09-23 · Accepted · [Release ordering and rollback](open_code/RELEASING.md)

Advance `registry-stable` only after CI validates hosted runtime floors,
rather than tying each catalog update to a tagged CLI release. An unpublished
floor blocks all promotion until publication and a rerun; recovery is a reviewed
revert on `main` followed by forward promotion, while existing app pins remain
fixed. Runtime, registry and installer releases have separate gates because
checkout consumer success cannot establish hosted minimum-version support.

## Fortal owns its visual contract (Fortal ADR-0003)

2026-10-29 · Accepted; supersedes Radix Themes visual parity · [Specification](registry_source/specs/fortal.md) · [Archived brief](registry_source/docs/fortal/refresh-brief.md)

Use seven owned, deterministic seed-generated palettes and Fortal's own visual
specification, retaining twelve-step roles and Remix/Naked UI behavior, because
external parity made design changes require upstream exceptions. Fortal owns
contrast and widget/golden checks, with seed-led solid-fill lightness an explicit
exception; the former parity gate may be removed only after replacements pass.
The unreleased preset drops classic control/card/inline variants without aliases,
keeps radius/scaling/appearance and high-contrast options, and defers full
Fortaleza branding, Anton and cobogó patterns.

## Retain the private Fortal package (Fortal ADR-0001, superseded)

2026-09-14 · Superseded by [Fortal ADR-0002](#one-analyzed-authoring-tree-fortal-adr-0002)

Initially retain the private authoring/parity-test package because moving 78 app
import sites (39 demo, 30 dashboard, 9 playground) and generated/parity fixtures
supplied no consumer benefit by itself. This retained migration and duplicated
ownership costs; demonstrated duplication and enum bridges later justified the
single analyzed tree, while private authoring never implied a hosted release.
