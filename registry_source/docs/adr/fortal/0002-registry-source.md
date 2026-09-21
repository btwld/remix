# ADR 0002 — Registry source

Date: 2026-09-14. Status: accepted. Supersedes
[ADR 0001](0001-authoring-package-retention.md).

## Decision

Every file under `registry/**/templates/` is build
output. One builder, `tool/build_registry.dart`, derives it from analyzer-checked
Dart under `registry_source/`, and a drift check over the whole tree fails CI on
any hand edit. Applications consume installed source only.

```text
packages/           what pub.dev sees: remix, remix_ui_icons, remix_cli
registry_source/    one private package: the authored catalog
  lib/src/default/  the default preset, authored under the word Vanilla
  lib/src/fortal/   the Fortal preset, authored under the word Fortal
  lib/src/agent/    Agent behavior, merged into both presets
```

`registry_source` is one package, not three, so nothing in it is a dependency
of anything: the recipes reach Agent behavior by relative path. It has no
version and no publish target. `packages/` now reads as "published".

## Distribution revision — 2026-09-19

Registry output publishes independently through GitHub `registry-v*` releases.
`registry/index.yaml` schema 1 selects preset catalogs; catalog schema 2 adds
qualified dependencies while preserving the existing Dart template contract.
New projects store schema-3 named sources and full commit pins in `remix.yaml`.
Every fetch uses the pinned commit, and changing a pin is explicit and does not
change installed source. The CLI remains a generic installer.

`packages/remix_cli/lib/src/registry/` is now a frozen compatibility snapshot
for schema-1/2 projects, not builder output to refresh. Its byte-level regression
coverage is separate from current-source drift and dependency-floor checks,
which target `registry/`. Migration is explicit and configuration-only.
No remote error falls back to the bundle. Cross-registry dependencies require
project registration, and conflicting target ownership fails before writes.

See [registry contract](../../../../open_code/REGISTRIES.md) and
[release ordering](../../../../open_code/RELEASING.md). This revises the former
bundled-only distribution decision; it does not change authoring ownership,
prefix rendering, preset contents, or installed-source ownership.

## Configuration revision — 2026-09-21

`packages/remix_cli/lib/src/registry/` is removed, along with `remix.yaml`
schemas 1 and 2 and `remix registry migrate`. Remix is pre-1.0 and does not owe
those prereleases a compatibility path, and keeping one cost more than it
bought: the snapshot was a second catalog that drifted from `registry/` in
silence, it let `add` bypass the pin for projects that named none, and it made
a registry edit and its consumer update unlandable in one commit.

Schema 3 is now the only readable configuration, so every read goes through a
pin the project recorded. A project on an earlier schema deletes `remix.yaml`
and reruns `remix init`; installed source is untouched, which is what the
subsequent `add --diff` is for.

This supersedes the preceding revision's frozen-snapshot paragraph only.
`registry/index.yaml` schema 1 and catalog schema 2 are unchanged, as are
authoring ownership, the derivation invariant, prefix rendering, preset
contents, and installed-source ownership.

The CLI-internal structure behind that contract — how the installer obtains
catalogs and template bytes — is superseded by
[the registry port lockdown](../../../../open_code/REGISTRY_PORT.md). The
published schemas described above are unchanged.

## What this reverses

| record | it said | now |
|---|---|---|
| [PRESETS.md](../../../../open_code/PRESETS.md) decision 7 | `remix_fortal` leaves pub.dev; **the directory stays** at `packages/remix_fortal` | the source is `registry_source/lib/src/fortal`; `remix_fortal` is no longer a package name anywhere |
| [ADR 0001](0001-authoring-package-retention.md) | retain the package; reconsider on duplicate source ownership | the trigger fired: `apps/dashboard` carried 38 installed `lib/ui/` files *and* 31 `package:remix_fortal` importers, bridged by five identity-mapped enum switches in `pages/chat_page.dart` |
| [Agent ADR 0001](../agent/0001-package-boundary.md) | recipes are hand-authored `.tmpl` files under `open_code/agent_recipes/` | recipes are Dart in each preset's `recipes/`, analyzed against `lib/src/agent` beside them |

Not reversed: Agent behavior stays private and installs as source. Publishing
it was considered and rejected; the Agent ADR's "neither required nor planned"
stands. It is not a package at all any more, only source that is tested and
derived.

## Why

The default preset was 37 hand-written templates with no analyzer behind them,
and the 16 Agent recipes were the same. Both now derive from formatted,
analyzed source, which is the rule PRESETS.md decision 3 already stated for
Fortal. The proof for the default preset was mechanical: rendering the
templates with the word `Vanilla` (zero collisions across the tree) and deriving
back was byte-identical before any human edited the result.

The Fortal move is the retention ADR's own trigger. Three applications reached
`package:remix_fortal` directly while one of them also installed the derived
source; the dashboard needed enum bridges to hand Fortal settings to its own
installed `Ui*` types. Once every application installs, the package is only a
source tree, and `packages/` should not suggest otherwise.

## The invariant

Derivation is plain text substitution of one word per source, asserted to
round-trip. The authoring word must therefore appear nowhere in a source
package except as the prefix, comments included. Recipes are the one
two-word case: they name Agent behavior while authoring, and the builder
rewrites the `../../agent/` import to the installed relative path and the
identifier-initial `Agent` to the consumer prefix before the preset's own word
goes. `uiAgentComposerRecipe()` keeps its domain name; `AgentComposerStyler`
becomes the installed `UiComposerStyler`.

`tool/check_open_code_dogfood.dart` fails when any `apps/*/lib` file outside
`lib/ui/` imports `package:registry_source`.
