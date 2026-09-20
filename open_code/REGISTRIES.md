# Pinned GitHub registries

Registry releases are independent of CLI releases. New projects use schema 3;
`init` selects the latest stable GitHub `registry-v*` release from
`conceptadev/remix`, validates the selected preset, and stores its full commit
SHA. No compatible release means initialization fails without creating files.
Repeating initialization preserves the existing configuration and pin.

```yaml
schema: 3
prefix: Ui
preset: fortal
paths:
  ui: lib/ui
defaultRegistry: "@remix"
registries:
  "@remix":
    repository: conceptadev/remix
    path: registry
    ref: registry-v1
    revision: "<resolved-full-commit-sha>"
```

`ref` records the requested branch, tag, or SHA. `revision` is the immutable
commit used for every index, catalog, and template read. Commit `remix.yaml`;
there is no separate source lockfile. `add`, `--diff`, and `--dry-run` never
resolve a newer ref or change the configuration. Network or source failures
never fall back to bundled content. No persistent offline cache is provided.

## Register and install

```shell
remix registry add @company --repository owner/repo --path registry --ref v1
remix add @company/button
remix add button
```

Bare top-level names use `defaultRegistry`; bare dependencies use their owning
registry. `@namespace/item` dependencies reference explicitly configured
registries. An item cannot register or redirect a registry. Every source must
provide the project's selected preset. Registration without `--ref` resolves
the repository default branch once and records both its name and its commit.
Namespaces use lowercase `@name` identifiers, optionally containing digits,
hyphens and underscores. Item names remain lowercase Dart-style identifiers.

Public github.com repositories only are supported. Private repositories,
GitHub Enterprise, arbitrary HTTP registries and local registries are outside
this release. Paths must be repository-relative, normalized, and free of
traversal or URI escapes.

The namespace convention follows [shadcn's registry conventions](https://ui.shadcn.com/docs/registry/namespace).
Remix deliberately retains its Dart templates, YAML schemas, dependency
constraints, generated-file declarations and prefix rendering. It does not
use React transformations or shadcn's JSON wire format.

## Update and review

```shell
remix registry update @company --ref v2
remix add @company/button --diff
remix add @company/button --overwrite
```

Updating validates and changes only that namespace's pin. Without `--ref`, it
resolves that source's previously requested ref again. It does not install or
merge source. Normal installs preserve authored files; overwrite replaces only
the explicitly requested item, never customized dependencies. The CLI resolves
the complete dependency graph and templates before dependency installation or
writes, rejects cycles and conflicting target owners, and intersects package
constraints. Output identifies namespaces and the resolved revisions.

Installed generated adapters remain included in generation, including those
from registries outside the current dependency graph. Source remains owned by
the application. Restoring a previously committed configuration pin is the
registry rollback; it does not revert installed source. Review and restore that
source separately through the application's version control.

## Migrate existing projects

Schemas 1 and 2 keep using the frozen CLI-bundled snapshot. They are never
silently rewritten, and upgrading the CLI does not update their templates.
Schema 1 retains the default preset.

```shell
remix registry migrate --ref registry-v1
remix add button --diff
```

Omit `--ref` to select the latest stable registry release. Migration translates
the frozen `default` preset to `vanilla`, validates that canonical preset, and
changes configuration only: prefix, UI path, installed files, and generated
adapters are preserved. `fortal` remains unchanged. The command reports a
preset rename, prints the next review command, and does not claim existing
source matches the new snapshot.

## Author and publish

Edit analyzer-checked Dart under `registry_source/`, then run:

```shell
dart run tool/build_registry.dart
dart run tool/build_registry.dart --check
dart run tool/check_dependency_constraints.dart
```

Commit the entire `registry/` output. Never update
`packages/remix_cli/lib/src/registry/`: it is a frozen compatibility snapshot.
The root `registry/index.yaml` uses schema 1 and maps presets to relative
catalog paths. Catalog schema 2 permits qualified dependencies; schema 1
remains readable and permits only local dependency names.

```yaml
schema: 1
presets:
  vanilla: vanilla/registry.yaml
  fortal: fortal/registry.yaml
```

Within a schema-2 catalog, `registryDependencies: [theme, "@company/icons"]`
means the owning registry's theme plus the configured company registry's icons.
Distinct items must never own the same authored or generated target. Shared
items should instead be declared as dependencies. Templates declare sources
under `templates/`, destinations under `@ui/`, package constraints, generated
adapters and exports using the existing catalog format.

See [release instructions](RELEASING.md) for the independent registry gate,
bootstrap order and published-revision smoke check. Component-only changes
require a registry release, not a new CLI release.

## Vanilla preset naming

New projects select `vanilla` when `--preset` is omitted. The official remote
index exposes only `vanilla`; `default` is not a remote alias. Fortal
publishes to the same index in a follow-up change.
Schema-1/2 projects retain their frozen bundled `default` snapshot, and
initializing again preserves their configuration without migrating it. An
explicit migration records `vanilla` in schema 3. The internal authoring
directory remains `registry_source/lib/src/default/`.
