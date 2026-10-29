# ADR 0001 — Agent domain boundary

Status: accepted. Agent surfaces and preset recipes are authored and tested in
the private `registry_source` package and installed as application-owned source.
The [registry-source decision](../fortal/0002-registry-source.md) superseded the
original separate-package layout, not the domain/behavior boundary below.

## Decision

Author Agent domain surfaces under `registry_source/lib/src/agent`, composed
from public Remix primitives and Mix styling machinery. Keep conversation,
permission and execution state machines out of the generic Remix barrel and
out of preset styling code. Do not introduce an `AgentScope`.

## Why

Remix supplies unstyled component machinery. A preset supplies a design language
over those primitives. Conversation, permission and plan surfaces instead add
domain anatomies and status machines; they are not a new color scale.

A separate domain source boundary keeps Remix generic and presets free of
behavior ownership. Generated Agent specs expose named visual slots with empty
default values. Hosts own color, typography, spacing, dimensions, radii, status
visuals and motion recipes. This separation does not require a third published
package or a private runtime dependency.

## What the design-system skill applies

- Workspace scaffold and Material-free library
- Do not re-export Remix or Mix
- Host owns Overlay and Navigator

## What it does not apply

- A generated token map, theme enum, or package-owned visual defaults
- `@MixWidget` wrappers as the primary shape (those wrap matching Remix
  anatomies; these surfaces do not match)

The authoring source uses `@MixableSpec` generation for ordinary `style`
resolution, `styleSpec` bypass, fluent `Agent*Styler`s, and named nested slots. A `MixScope`
is needed only when host styles use scoped tokens.

Agent specs are co-located with their widgets and contain only static,
Agent-owned anatomy. Each composed Remix control accepts its own unresolved
styler on the Agent constructor. Resolving a button, text field, card, or
disclosure spec in the parent would detach it from that control's Naked state
controller and discard variant, animation, and modifier metadata.

## Supported domain surfaces

Composer, message, transcript, answer, permission, execution, plan, activity.
No shell widget, no file tree, no highlighter, no citation engine.

## Runtime and recipe split

The domain source owns behavior. The application owns appearance and receives
installed `remix_cli` source rather than an Agent theme.

| Remix Agent owns | The application owns |
|---|---|
| Controller and focus-node ownership, IME handling | The composer, message, and permission recipes |
| Permission latches and status machines | Every colour, size, radius, and inset |
| Live-edge follow and release | The theme those values resolve from |
| Accessibility semantics and keyboard rules | Per-instance overrides at the call site |
| `Agent*Spec` slot names, empty by default | Which installed recipes a surface reuses |

The installed-consumer tests in `open_code/fixture/test/composer_recipe_test.dart`
and `open_code/fixture/test/agent_recipe_contract_test.dart` exercise recipe
composition, child-style ownership and generated installed source. Component
behavior and lifecycle tests live under `registry_source/test/agent/components/`.
`tool/check_consumer_apps.dart` compares committed installed consumers with the
registry; fresh checkout consumers separately exercise each component and recipe
with its dependency closure. Hosted release checks remain a separate gate.

The recipe is a **bundle**, not a single styler. `AgentComposer` takes
`style`, `surfaceStyle`, `fieldStyle`, `submitStyle`, and `stopStyle`, and
`AgentComposerSpec` holds only the toolbar, so one `@MixWidget` recipe cannot
supply the other four. `uiAgentComposerRecipe()` returns all five and the call
site spreads them. The four child stylers stay unresolved, for the reason the
section above gives.

## Source distribution and remaining boundaries

Each registry contains eight component items, eight opt-in recipe items, plus
shared `models` and `support`. Source comes from `registry_source/lib/src/agent`;
generated adapters come from the consumer's resolved Mix generator. No installed item depends on this private
package. Public model files are exported; internal support helpers stay out of
the managed barrel. The existing theme item owns the single Remix dependency
floor, inherited through support.

`tool/build_registry.dart` derives this source into `templates/agent/**` of
both presets as an extension of each preset's own source; the preset writer
merges it and owns the whole tree, so regeneration cannot prune it and a
whole-tree drift check covers it.

Mix's spec-styler builder is opt-in at the current supported version. The CLI
therefore enables it for installed spec sources in application `build.yaml`,
preserving unrelated settings and refusing explicit exclusions or disabled
builders. This is a discovered prerequisite to distribution, not a new theme,
registry schema, or copied generated implementation.

All eight surfaces expose preset-specific recipe bundles, authored as Dart in
`registry_source/lib/src/{default,fortal}/recipes/` against these components,
and derived into each preset. The dashboard and playground use those installed
bundles; their chat orchestration remains application-owned rather than a
runtime API.
Hosted release validation remains a separate release gate. Private-package
publication is neither required nor planned for these source-distributed items.
