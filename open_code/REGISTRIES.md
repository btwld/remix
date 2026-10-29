# Pinned GitHub registries

Registry publication is independent of CLI releases. New projects use schema 3;
`init` resolves the `registry-stable` branch of `btwld/remix` and stores
its full commit SHA. It validates the selected preset. No published
`registry-stable` branch means initialization fails without creating files.
Repeating initialization preserves the existing configuration and pin.

```yaml
schema: 3
prefix: Ui
preset: fortal
iconLibrary: remix # optional: remix (default) or lucide
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

The optional `iconLibrary` is resolved when templates are installed.
Registries publish `icons.yaml` beside their preset catalogs; the CLI must
ship support for that table before a registry begins using its placeholders.

`ref` records the requested branch, tag, or SHA. `revision` is the immutable
commit used for every index, catalog, and template read. Commit `remix.yaml`
and, after installation, `remix.ownership.json`. The
ownership record reserves authored and generated targets; it does not pin
content or hash local edits. `add`, `--diff`, and `--dry-run` never
resolve a newer ref or change the configuration. Network or source failures
never fall back to other content; the CLI ships none. No persistent offline
cache is provided.

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

Ownership checks also cover earlier installs, including files subsequently
removed or targets no longer present in the latest catalog. The durable owner
is the GitHub repository (case insensitive), registry path, preset, and item.
Updating a ref/revision or registering another namespace for the same source
does not change ownership. Changing the repository or registry path does.
Neither `--overwrite` nor `--adopt` can replace a known different owner.
Internal symlink aliases and case-only target differences also conflict, so
the boundary remains portable to Windows and default macOS filesystems.

One prefix, preset, and UI root remain the supported boundary. Additive
registries may depend on existing items and install to disjoint targets;
overlapping replacement design systems require a separate application setup.
The same preflight runs for ordinary installs, `--dry-run`, and `--diff`, before
any dependency process or source write. Previews never write ownership.
Commit the record with the matching configuration and source, and restore all
three together on rollback. Reservations survive source/generation failures so
rerunning the original owner can repair the installation. Run installer
commands serially within an application.

Installed generated adapters remain included in generation, including those
from registries outside the current dependency graph. Source remains owned by
the application. Restoring a previously committed configuration pin is the
registry rollback; it does not revert installed source. Review and restore that
source separately through the application's version control.

## Existing source without an ownership record

CLI 0.1.0 and 1.0.0-beta.0 did not record target owners. Upgrading the CLI
cannot infer provenance from file names, exports, a configured namespace, or
customized content. Existing unknown targets therefore fail preflight, even
with `--overwrite`. Disjoint additions remain supported and do not claim
unrelated legacy files.

After verifying where each existing item came from, attest to it explicitly.
Name every existing unknown dependency as well as the requested recipe:

```shell
remix add theme button --adopt --dry-run
remix add theme button --adopt --diff
remix add theme button --adopt
```

`--adopt` preserves authored bytes and records ownership for explicitly named
items. It otherwise follows normal installation: missing source is installed,
dependencies resolved, missing adapters generated, and source analyzed. It
cannot be combined with `--overwrite`. Known owners still take precedence, and
partially installed items still require repair. Adoption is a declaration by
the application maintainer, not automatic verification of legacy provenance.
If provenance is uncertain or systems were previously mixed, restore a known
configuration/source pair from version control or start a clean installation
and reapply local edits. Do not use adoption to relabel another system's files.

Upgrade the project-local CLI before migrating. Older CLIs ignore this record
and do not enforce the boundary; do not downgrade installer commands afterward.
This installer behavior requires a new CLI release; updating a registry pin
alone does not deliver it.

## Projects from an earlier prerelease

Schema 3 is the only readable shape. Schemas 1 and 2 shipped in earlier
prereleases and recorded no registry: they read from a snapshot that lived
inside the CLI, which no longer exists. There is no pin to migrate, so such a
project is reinitialized.

```shell
rm remix.yaml
remix init --prefix Acme --preset vanilla
remix add theme button --adopt --diff
remix add theme button --adopt
```

Pass the prefix, preset and UI path the old file recorded; a schema-1 project
recorded no preset and its `default` corresponds to `vanilla`. `init` rewrites
configuration only: installed files and generated adapters are preserved, and
nothing claims they still match the newly pinned source. That is what the
`--adopt --diff` is for. Verify provenance before adoption as described above.

## Author and publish

Edit analyzer-checked Dart under `registry_source/`, then run:

```shell
dart run tool/build_registry.dart
dart run tool/build_registry.dart --check
dart run tool/check_dependency_constraints.dart
```

Commit the entire `registry/` output; it is the only catalog the CLI reads.
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
bootstrap order and promoted-branch smoke check. Component-only changes
require promoting `registry-stable`, not a new CLI release.

## Vanilla preset naming

New projects select `vanilla` when `--preset` is omitted. The official remote
index exposes only `vanilla` and `fortal`; `default` is not a remote alias.
A project reinitialized from schema 1 or 2 records `vanilla` in its place. The
internal authoring directory remains `registry_source/lib/src/default/`.
