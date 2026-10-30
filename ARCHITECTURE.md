# Architecture decisions

The [README](README.md) explains the current concepts. This log preserves
choices that would be costly to reverse; contracts and operating steps stay in
the linked specifications and runbooks. Add a titled, dated entry only when
context, a rejected direction, or a lasting cost needs to be found again.
Update status and link a replacement when a decision changes.

## Applications own installed source

Accepted · clean-sheet direction recorded 2026-09-10.

Install editable theme and component recipes into each app and generate
`@MixWidget` adapters against its resolved Remix/Mix versions, because manual
forwarding wrappers and parameter allowlists silently miss new runtime APIs.
The app must review and regenerate adapter diffs after recipe or constructor
changes; Remix retains rendering, interaction and accessibility machinery.

Registry source excludes generated adapters. Recipe `style` merges last;
`styleSpec` is deliberately not forwarded as a customization hook because it
bypasses recipe and token resolution. Agent installs also contain domain
behavior, so source-update review covers more than appearance.

Contract: [registry ownership and generation](open_code/REGISTRIES.md).
Workflow: [install, customize, compare](open_code/README.md).

## One analyzed authoring tree

Accepted · 2026-09-14 · migration recorded 2026-09-17 · supersedes
[retaining the private Fortal package](registry_source/docs/adr/fortal/0001-authoring-package-retention.md).

Author Vanilla, Fortal and shared Agent source in the private `registry_source`
package and derive the registries, because hand-written templates escaped
analysis and the dashboard carried both installed and package types with enum
bridges. This makes whole-tree generation, prefix round trips and installed
consumer checks mandatory, while apps continue to own installed source.

The original default catalog had 37 hand-written templates and Agent had 16
hand-written recipes. Analyzer-checked Dart replaces that parallel ownership.
Authoring words must round-trip through consumer prefixes; explicit fixed data
filenames such as `theme/fortal_colors.dart` are exempt, while their Dart types
still take the consumer prefix. Dependency floors and icon mappings remain
maintained inputs rather than wholly generated data.

Implementation: [builder](tool/build_registry.dart), [migration #208](https://github.com/btwld/remix/pull/208).
Contract: [authoring and derivation](open_code/REGISTRIES.md#authoring-and-derivation).

## Agent behavior stays separate from preset appearance

Accepted · first recorded 2026-09-10 · physical package boundary replaced
2026-09-17; domain boundary retained.

Keep conversation, permission and execution behavior in Agent domain source
rather than generic Remix or preset styling, and install it as app-owned
source without an Agent theme/runtime package. Preset recipes provide bundles
of unresolved child stylers, because resolving a child control in the parent
loses that control's interactive state, variants, animation and modifiers.

Agent specs contain only empty, static anatomy slots. Hosts own appearance,
navigation and application orchestration; there is no `AgentScope`. Source
using `@MixableSpec` requires the CLI's scoped consumer `build.yaml` support.

Details: [Agent usage](registry_source/docs/agent/README.md),
[benchmark provenance](registry_source/docs/adr/agent/provenance.md).
Checks: [installed recipe contract](open_code/fixture/test/agent_recipe_contract_test.dart).

## Registry reads use immutable GitHub pins

Accepted · current schema-3 boundary recorded 2026-09-21.

Record a full GitHub revision per namespace in `remix.yaml` and use it for
every catalog/template read, removing the CLI-bundled fallback and legacy
schema-1/2 project shapes before 1.0 so installs have one explicit source.
This requires network access and reinitializing old configurations; moving a
pin never adopts or reverts application-owned source automatically.

`ref` preserves the requested branch, tag or SHA; `revision` is the resolved
commit. Fetch failure must fail rather than substitute another catalog.

Contract and recovery: [pinned registries](open_code/REGISTRIES.md).

## Promote registry content independently

Accepted · promoted-branch workflow recorded 2026-09-23.

Advance `registry-stable` only after CI validates the candidate against hosted
runtime floors, rather than coupling each catalog update to a tagged CLI
release. An unpublished floor blocks all promotion until publication and a
rerun; recovery is a reviewed revert on `main`, followed by forward promotion.

New projects resolve the promoted branch once. Existing pins remain fixed.
Checkout consumer success cannot establish hosted minimum-version support.
Runtime packages, registry content and the installer have separate release gates.

Operating procedure: [release ordering and rollback](open_code/RELEASING.md).

## Fortal owns its visual contract

Accepted · 2026-10-29 · replaces external Radix Themes visual parity.

Use Fortal's seven seed-generated palettes and owned visual specification,
retaining twelve-step roles and Remix/Naked UI behavior, because external
parity made design changes require upstream exceptions. Fortal owns contrast
and visual regression checks; seed-led solid-fill lightness is an explicit
exception, and the former parity gate may be removed only after replacements pass.

The [original decision](registry_source/docs/adr/fortal/0003-independent-design-system.md)
preserves the design scope and deferred branding work. The maintained
[Fortal specification](registry_source/specs/fortal.md) and catalog own values;
the [original refresh brief](registry_source/docs/fortal/refresh-brief.md) is
archived input, not a current task list.

## Superseded: retain a separate private Fortal package

Superseded · decision 2026-09-14 · replaced by one analyzed authoring tree.

We initially retained the private package because moving 78 app import sites
and generated/parity fixtures supplied no consumer benefit by itself. Duplicate
source ownership and enum bridges later supplied the maintenance problem that
justified migration; the [historical record](registry_source/docs/adr/fortal/0001-authoring-package-retention.md)
keeps the original counts and reconsideration trigger.
