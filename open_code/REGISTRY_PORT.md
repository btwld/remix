# Registry port — design lockdown

> **Partly superseded.** The frozen bundled snapshot this record reasons about
> was removed when `remix.yaml` schemas 1 and 2 were dropped: there is no
> `BundledRegistry`, no `packages/remix_cli/lib/src/registry/` tree, no
> `registry migrate`, and `ProjectConfig` is one class rather than L11's sealed
> pair. The decisions below are kept as written, because the reasons are what
> they were at the time and rewriting them would misreport the history. Read
> L3, L5, L7, L11 and the inventory tables as a record of a shape the
> code has since left; the checkout harness and the test fixture remain the
> non-HTTP implementations they cite.

Working record for the registry-source redesign. Locked decisions (L*) carry a
reason; open items (O*) carry the scenario that settles them. Supersedes the
internal-structure parts of [ADR 0002](../registry_source/docs/adr/fortal/0002-registry-source.md)
§"Distribution revision"; it does not touch that record's authoring ownership,
derivation invariant, or preset contents.

## The criterion

> An application owns its UI source. Remix stays the maintained behavior
> dependency, and the CLI is how versioned source gets into the application.

Every choice is tested against that sentence. Note what it does not say:
*GitHub*. The CLI is a generic installer that needs a pinned catalog and its
template bytes; where those come from is not part of the idea.

## Locked

**L1. Two contracts, named separately.**
The *published contract* is `remix.yaml` schema 3, `index.yaml` schema 1,
catalog schema 2, the `@namespace/item` grammar, and the CLI flags. Third-party
publishers and every initialized project depend on it; it changes only by
version. The *source port* is how the CLI obtains catalogs and template bytes.
It has no external consumer and is free to change.
*Reason:* `lib/remix_cli.dart` states the supported surface is the `remix`
executable, not a programmatic API. REGISTRIES.md commits the wire format. The
current code conflates the two, which is why the port is shaped like HTTP.

**L2. The port speaks catalogs and templates, not HTTP.**
*Reason:* four implementations exist and three are not HTTP — the frozen
bundled snapshot, the checkout harness, and the test fixture. To pass through an
HTTP-shaped port they forge request URLs (`uri.pathSegments[3] != 'registry'`)
and undo them on the other side. A port whose implementations must fake its
vocabulary is the wrong vocabulary.

**L3. `Installer` takes exactly one injected registry dependency.**
Not two unified into one — one, because the bundled path needs no seam at all.
`Installer` constructs `BundledRegistry` itself.
*Reason:* `registryLoader` has one production call site and one test
(`installer_test.dart:201`) that only asserts the configured preset is passed
through — re-expressible without a seam. A seam maintained for a single
assertion is not a seam.

**L4. Pinning and reading are different jobs.**
*Reason:* all three subclasses of `GitHubRegistryResolver` override
`latestOfficial` specifically. A bundled snapshot reads with no pin at all; a
`registry update` pins with no reading. Fusing them is what forces every
non-GitHub source to subclass a network client.

**L5. GitHub is the only supported registry source; the port stays internal.**
Settles O1. `remix.yaml` never names a source kind. The port exists for the
frozen snapshot, the checkout harness, and tests — all first-party.
*Accepted cost:* schema 3 always records a commit, so the checkout harness
still writes a placeholder `revision`. That placeholder is a consequence of this
lock, not of the current API shape, and the redesign does not remove it.

**L6. `RegistryCatalog` is a parsed document, not a reader and not a resolver.**
It drops `_rootUri`, `_loader`, the `rootUri:`/`loader:` parameters on `parse`,
`readTemplate`, and `resolve`. It keeps `preset`, `items`, and its parse-time
whole-catalog validation.
*Reason:* a data type carrying an I/O capability is why `parse` needs two
parameters unrelated to parsing, and why the bundled and remote paths could not
share a resolver.

**L7. The port keeps two methods. A single `read(path)` primitive is rejected.**
`catalog(preset)` and `template(file)` both survive.
*Reason:* the tempting collapse is to make the port one method and hoist
index-parsing into a shared function. It does not work: the frozen snapshot is
`lib/src/registry/{preset}/registry.yaml` with **no `index.yaml`**, while the
published layout resolves presets through one. Preset→catalog resolution is
layout-specific, so it belongs to the implementation.

**L8. Three closure walks, all kept. Revised during implementation.**
`RegistryCatalog._validateGraphAndTargets` validates a *whole published catalog*
at parse time. `RegistryGraph.resolve` validates *the requested closure* across
registries. `RegistryCatalog.resolve` answers "what is the closure of one item
in this catalog" — pure, synchronous, no I/O.
*Correction, twice over.* The first pass called all three redundant; that was
wrong, because the parse-time walk is the publisher-facing check and cannot see
cross-registry edges. The second pass still said to delete
`RegistryCatalog.resolve`; that was also wrong. Implementation found **14 call
sites** across `registry_test.dart`, `installer_test.dart`, and
`build_registry_agent_test.dart` that use it to assert catalog content
synchronously. Replacing it with `RegistryGraph.resolve` would force all of them
async and make them construct readers, to test something with no I/O in it. It
owns a real query on a parsed document and it stays.

**L9. The HTTP transport seam survives, one level down.**
`RegistryTransport` and `RegistryResponse` remain as internals of the GitHub
implementation, and `registry_source_test.dart` keeps driving them.
*Reason:* rate-limit, 404, non-200 and timeout handling is real behavior that
deserves a test at the HTTP level. What changes is that `Installer` and the
installer tests no longer see them.

**L10. Pins and reader-opening stay on one interface, not two.**
A separate `RegistryPins` interface is rejected.
*Reason:* splitting them gives `Installer` three constructor seams (pins,
opener, and a concrete GitHub resolver for `registry add --repository`), which
is worse than today. One interface with three operations keeps L3 true. The
checkout harness implements `latestOfficial` and `open` honestly and throws
`UnsupportedError` from `resolve`, which it never reaches — verified: the
harness runs only `init` and `add`.

## The model

```dart
/// Everything the installer needs from the outside world. One seam.
abstract interface class RegistrySources {
  Future<RegistrySource> latestOfficial();
  Future<RegistrySource> resolve({
    required String repository,
    String path,
    String? ref,
  });
  RegistryReader open(RegistrySource pin, String preset);
}

/// One already-pinned registry, serving one preset. Implemented by GitHub and
/// by the frozen bundle.
abstract interface class RegistryReader {
  Future<RegistryCatalog> catalog();
  Future<String> template(RegistryFile file);
}
```

| object | one line |
|---|---|
| `RegistrySources` | The single injected seam: pin, resolve, open. |
| `GitHubSources` | `final`. The only production implementation; owns the transport. |
| `RegistryReader` | Read one pinned registry, for one preset: catalog and template bytes. |
| `BundledRegistry` | `RegistryReader` over the frozen `package:` snapshot. Constructed internally; never injected. |
| `RegistrySource` | The pin: repository, path, ref, revision. Unchanged. |
| `RegistryCatalog` | A parsed catalog document: preset plus items. No I/O. |
| `RegistryItem`, `RegistryFile` | Published-contract shapes. Unchanged. |
| `RegistryGraph` | The resolved closure over one or more readers, across registries. |

### Flows

1. **init** — `sources.latestOfficial()` → `sources.open(pin, preset).catalog()`
   to prove the preset exists → write schema 3. Failure writes nothing.
2. **registry add / update / migrate** — `sources.resolve(...)` →
   `open(pin, preset).catalog()` to validate → rewrite configuration only.
3. **add** — read config → schema 3 opens one reader per namespace, schema 1/2
   constructs one `BundledRegistry` → `RegistryGraph` → render → plan → install.

### What this removes

| removed | why it existed |
|---|---|
| `RegistryLoader` typedef, field, constructor parameter | a second source seam for schema 1/2 (L3) |
| `RegistryCatalog._rootUri`, `_loader`, two `parse` parameters | the catalog doubling as a reader (L6) |
| `RegistryAssetLoader`, `PackageRegistryAssetLoader` | absorbed into `RegistryReader` / `BundledRegistry` |
| 3 subclasses of the HTTP client | `latestOfficial` fused to reading (L4, L10) |
| `uri.pathSegments[3] != 'registry'` URL forgery | a directory impersonating a Git host |
| `_DependencyInspection` | a one-field wrapper around `List<_DependencyRequirement>` |

Not removed, contrary to an earlier pass: the checkout harness's placeholder
`revision`. See L5.

| | today | after |
|---|---|---|
| Types to obtain a catalog and template bytes | 5 | 2 |
| `Installer` registry seams | 2 | 1 |
| Subclasses of a network client | 3 | 0 |
| Install-time closure walks | 2 | 2 (unchanged — see L8) |

## Implementation notes

Landed; see `.context/plans/registry-port.md`. Three deviations from the plan,
all recorded above or here:

- **A reader is opened per `(pin, preset)`, not per pin.** `RegistryReader`'s
  methods take no preset. A project selects exactly one preset and the graph
  already passed `config.preset` to every load, so a preset argument on both the
  constructor and the methods would have been redundant.
- **`RegistryCatalog.resolve` survives** (L8).
- **`catalogPathForPreset` was extracted** rather than left inside the GitHub
  reader, once the checkout harness needed the same published-layout rule. It is
  the one piece of index handling both share.

One bug was introduced and caught before it shipped: the first version of
`_GitHubRegistry.template` resolved against the registry root instead of the
preset's catalog directory, which would have fetched
`registry/templates/...` instead of `registry/vanilla/templates/...`. The
reader now memoizes the catalog directory, so one reader fetches `index.yaml`
once regardless of call order.

## Settled

**L11. `ProjectConfig` is sealed: `LegacyProject` and `PinnedProject`.**
Settles O2. A legacy project carries `schema` (1 or 2) and no registries; a
pinned project carries `defaultRegistry` and `registries` and is always
schema 3. `ProjectConfig.parse` returns whichever the document describes.
*What it removed:* the `create` factory and three of its runtime throws —
"defaultRegistry is required", "Registry sources require schema 3", and the
schema range check — are now unrepresentable rather than rejected. Four
force-unwraps are gone (`config.defaultRegistry!` in the graph,
`config.registries[...]` reached through a nullable), `add` and `registry`
branch by `switch` on the type instead of `config.schema == 3`, and
`_validatePreset`'s `bundled:` boolean is replaced by each subclass validating
its own rule: a legacy preset must be one of the bundled names, a pinned preset
only has to be a lowercase identifier because third-party registries name their
own presets.
*What stayed a runtime throw:* "defaultRegistry must name a configured
registry" is a relation between two fields, not a shape, so it belongs in the
constructor.

**L12. `runInstallerCli` is shared by `bin/remix.dart` and the harness.**
Settles O3.
*Reason:* not the six duplicated lines — the drift. A new command added to the
real entry point would otherwise not reach the consumer checks, and nothing
would report that gap.

## Open

None. O1 settled by L5, O2 by L11, O3 by L12.
