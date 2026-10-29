# ADR 0002 — Registry source

Date: 2026-09-14. Status: accepted. Supersedes
[ADR 0001](0001-authoring-package-retention.md).

## Decision

One private authoring package, `registry_source`, owns the analyzer-checked Dart
catalog. `tool/build_registry.dart` derives every file under
`registry/**/templates/` and the catalog structure. Whole-tree drift checks fail
on hand-edited generated output. Applications consume installed source, not the
private authoring package.

```text
packages/           independently published packages
registry_source/    private authored catalog and parity tests
  lib/src/default/  Vanilla theme, components and recipes
  lib/src/fortal/   Fortal theme, components and recipes
  lib/src/agent/    shared domain behavior, models and support
registry/           generated catalogs and templates
```

Recipes reach shared Agent behavior through relative imports during authoring.
No installed item depends on `registry_source`, and it has no publish target.
Catalog structure and templates are generated; the Vanilla catalog's dependency
and dev-dependency floors are maintained release inputs read back by the builder. The icon mapping
and library floors in `registry/icons.yaml` are also maintained inputs.

## Current distribution contract

The [registry contract](../../../../open_code/REGISTRIES.md) defines the CLI's
catalog, template and source boundaries. `registry/index.yaml` uses schema 1;
preset catalogs use schema 2. Projects use schema-3 `remix.yaml` with named
registries and full commit pins. Fetches use the recorded revision, never a
bundled fallback, and changing a pin does not change installed source.

The maintained promotion workflow validates hosted runtimes before advancing
`registry-stable`. New initialization resolves that branch to a full commit;
existing pins stay fixed. Publication prerequisites and recovery are defined in
[release ordering](../../../../open_code/RELEASING.md). A passing checkout
consumer is not proof that a published dependency floor supplies new APIs.

Earlier schema-1/2 project configuration and the bundled compatibility catalog
were removed before 1.0. Projects on those retired configurations initialize a
schema-3 configuration; installed files remain application-owned and can be
compared with `add --diff`. There is no second bundled catalog to refresh.

## Historical rationale and supersession

| Record | Earlier boundary | Current boundary |
|---|---|---|
| [PRESETS.md](../../../../open_code/PRESETS.md) | Private preset package retained as authoring source | Authoring lives in `registry_source/lib/src/fortal`; applications install source |
| [ADR 0001](0001-authoring-package-retention.md) | Retain the package until duplicate ownership justified migration | The dashboard had both installed source and package importers, with enum bridges between their types; one authoring tree removed that duplication |
| [Agent ADR 0001](../agent/0001-package-boundary.md) | Separate domain authoring and hand-authored recipe templates | Domain behavior and analyzed Dart recipes share the private authoring package; behavior remains separate from styling |

The original default preset had 37 hand-written templates without an analyzer,
and the 16 Agent recipes had the same weakness. Analyzer-checked source gives
all presets one derivation contract. Prefix rendering followed by derivation
was byte-identical before visual edits, separating source ownership from design
changes.

Removing the private Fortal package boundary also removed application imports
and identity-mapped enum bridges alongside already-installed `Ui*` source.
Tests and reference fixtures stayed with the single authoring tree. Agent
behavior still installs as editable source; a hosted Agent runtime package is
neither required nor planned.

## Derivation and consumer invariants

Derivation is prefix substitution with an asserted round trip. An authoring
word occurs only in replaceable identifier prefixes and token identifiers,
including within comments. Recipes additionally rewrite shared Agent imports
to installed relative paths and replace identifier-initial `Agent` before the
preset's own prefix. `uiAgentComposerRecipe()` retains its domain name;
`AgentComposerStyler` becomes the installed `UiComposerStyler`.

`tool/check_consumer_apps.dart` compares installed consumers with registry
output and rejects `package:registry_source` imports outside owned `lib/ui/`
source. Fresh consumer checks exercise the actual installer and generator.
