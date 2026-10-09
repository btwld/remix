# Standalone Carbon registry: reference design and execution plan

**Status:** Prerelease review in progress, 2026-09-25. Local Remix implementation
and cleanup checks pass; hosted release gates remain.
Carbon is the first standalone registry; a generic example registry is not a
prerequisite. This plan replaces the distribution assumptions in the earlier
Carbon and GitHub-first plans. It does not itself publish or move source. The
selected public coordinates are `btwld/flutter-carbon`, `@carbon`, and
`stable`.

Leo subsequently authorized publishing `remix_cli` and promoting Carbon's
`stable` ref **through this plan's passing gates**. The first CLI release is
`0.0.1-beta.1`; its pub package name remains `remix_cli`, while global
activation installs the direct terminal command `remix`. GitHub Actions began
executing again on 2026-09-25 after the earlier billing lock; all review and
release gates still apply.

## Execution status — 2026-09-25

| Task | Status | Evidence / remaining gate |
| --- | --- | --- |
| 1. Standalone contract | Complete locally | An isolated, non-official SHA-pinned Carbon registry test passes; the fresh checkout-Remix Carbon consumer generated, analyzed, and passed its widget tests. |
| 2. Custom-source init and known-preset defaults | Implemented and verified locally; beta release pending | CLI options, source/preset validation, no-write failures, offline reruns, custom-default add modes and pin update pass. The CLI-shipped lookup maps Vanilla/Fortal → `@remix` and Carbon → `@carbon`; explicit sources override it. All 212 CLI tests and analysis pass on the latest review candidate. Isolated path activation installs and runs `remix --version` as `0.0.1-beta.1`. No hosted CLI release yet. |
| 3. Independent source | Public candidate verified; release-gate review pending | Public `btwld/flutter-carbon` `main` is still `695822576e5ed92d4a3711fb9406050cc4f1a8ae`. All 18 derived Carbon catalog/template files and the authoring source, tests, token pipeline, and reference data match the former Remix copy byte-for-byte. The original push workflow's attempt 2 passed `verify` for that SHA. [Carbon PR #1](https://github.com/btwld/flutter-carbon/pull/1) pins the hosted promotion consumer to the first CLI beta and documents the direct `remix` command; `verify` passed on its head `d93e4bdc8`, and maintainer review is pending. After merge, reverify its new `main` SHA before promotion. `stable` has not moved. |
| 4. Cleanup and publication | Local checks passed; new-head GitHub checks and maintainer review pending | The original uncommitted Remix branch remains preserved. [btwld/remix#245](https://github.com/btwld/remix/pull/245) now points to `1c53217cc`, a docs-only follow-up to the tested implementation head `b9a9598a3`. The follow-up explicitly pins first-beta install examples. On this head, all 212 CLI tests, 43 focused builder/consumer-checker tests, docs checks, and a clean `dart pub publish --dry-run` with zero warnings pass locally. Earlier full CI and hosted Vanilla/Fortal consumers passed on `b9a9598a3`; GitHub checks on `1c53217cc` are rerunning. `tilucasoli` is requested for review and has not submitted one. Merge and CLI publication remain pending. |

`btwld/flutter-carbon`, `@carbon`, and `stable` are the selected public
coordinates. The repository is public, but `stable` has not been promoted.

Passing local and hosted checks is not the plan's release completion. It still
needs maintainer approval and merge of Remix PR #245, the first `remix_cli`
publication, Carbon's hosted-CLI exact-commit promotion gate, and a fresh bare
`remix init --preset carbon` consumer pinned to the promoted SHA. Carbon
`verify` has passed, but no CLI publication or `stable` promotion is claimed.

## Resume sequence from this state

1. **Finish the Remix cleanup locally — done 2026-09-25.** The three stale CI
   descriptions named in Task 4 now say that checkout and hosted Remix checks
   cover the two **official** presets; Carbon is verified by its own
   repository. The net-diff scope against `origin/main` and active
   official-Carbon claims were checked; the scoped candidate still needs its
   normal review in step 2. `registry/index.yaml` contains only
   Vanilla and Fortal, and no Carbon authoring or fixture path remains. Ran
   `fvm dart run melos run docs:check`,
   `fvm dart run melos run open-code:registry:check`,
   `fvm dart run tool/check_ci_coverage.dart`, the 22 focused consumer-checker
   tests, and `git diff --check`; all passed.
   The earlier full checkout CI pass need not be repeated solely for prose
   changes; rerun it if executable behavior changes.
2. **Prepare a reviewed Remix integration — in progress.** Preserve the original
   uncommitted 60-commit-ahead branch and its earlier user edits; do not merge
   that detour. The scoped candidate is ready-for-review PR [#245](https://github.com/btwld/remix/pull/245),
   branch `leoafarias/standalone-carbon-registry-cli`. Local pinned-SDK CI
   passed at its `f8f3de2b6` head. GitHub `main` advanced from the PR's base
   `849dbc0c0` to `9cfb81aa4` with the BTWLD repository transfer. A cleanly
   merged candidate in `/Users/leofarias/conductor/workspaces/remix/.carbon-pr-sync.s9ELYW`
   retains `btwld/remix` as the official source; the legacy redirect stays
   tested. It was committed as `b9a9598a3`; full pinned-SDK CI, authenticated
   hosted Vanilla/Fortal release checks, and a clean publish dry-run pass.
   PR #245 has a conventional `feat:` title and records the validation. Its
   docs-only beta-install follow-up is `1c53217cc`; local CLI tests, focused
   tests, docs checks, and package dry-run pass there. New-head GitHub checks
   are rerunning. BTWLD maintainer `tilucasoli` has been requested but has
   not reviewed it; obtain approval and passing new-head checks before merge
   and publication.
3. **Unblock and verify the Carbon candidate.** The public standalone `main`
   candidate is `695822576e5ed92d4a3711fb9406050cc4f1a8ae`, and its
   worktree is clean. The original `push` workflow was rerun on 2026-09-25
   after GitHub Actions resumed, and its `verify` job passed on the exact SHA.
   This rerun did not promote `stable`. Carbon PR #1 corrects the hosted CLI
   install in its promotion workflow for the prerelease-only first package;
   merge it through review, then rerun `verify` for its new exact `main` SHA.
   The earlier dynamic CodeQL run cannot
   be retried with `gh run rerun`, so its stale billing failure is not a passing
   check. If source changes
   are needed, use a new candidate SHA and repeat the derived-output, token,
   dependency, source-test, and exact-commit consumer gates. Do not move
   `stable` to bypass CI.
4. **Release the CLI before Carbon promotion.** `remix_cli` still returns 404
   from pub.dev. On the reviewed Remix candidate, rerun the package publish
   dry-run and official hosted Vanilla/Fortal release checks, then use the
   authorized uploader for the first `remix_cli` publication at
   `0.0.1-beta.1` and configure
   automated publishing for `btwld/remix` with the documented tag pattern.
   Verify the hosted CLI itself before using it as Carbon's promotion gate.
   Do not publish from the dirty, unreviewed working branch.
5. **Promote and prove Carbon.** Dispatch the Carbon promotion workflow from
   its `main` candidate only after `verify` passes and the hosted CLI exists.
   Its hosted-CLI fresh consumer must pin the exact candidate SHA, install
   Button, generate, analyze, and test before the workflow fast-forwards
   `stable`. Verify `stable` equals that tested SHA. In a new app using the
   hosted CLI, run bare `remix init --preset carbon`, confirm `@carbon` and its
   full-SHA pin, install and test Button, and confirm the pin moves only after
   `registry update`. Re-run official Vanilla/Fortal hosted checks. Protect
   `stable` against force pushes and deletion after first promotion.

**Release authorization recorded:** Leo approved publication and Carbon
promotion through passing gates. GitHub Actions now executes real job steps;
review and release gates must still pass. Neither `stable` nor a release may
bypass a failed gate.

## Recommendation

Make Carbon a separate public GitHub registry with its own `carbon` preset,
commit-pinned by consumers under `@carbon`. Keep Remix as the runtime behavior
package and `remix_cli` as the generic installer. Keep the explicit
custom-source path to `remix init`, and add CLI-shipped defaults for the current
supported presets: Vanilla/Fortal resolve to the official `@remix` source;
Carbon resolves to `btwld/flutter-carbon` at `stable` under `@carbon`. The CLI
still validates each preset against that repository's own `registry/index.yaml`
and records a full commit SHA. Do not publish Carbon as a third preset in the
official `@remix` registry merely to make initialization work.

This is a distribution decision, not a request for a second runtime package.
Installed theme and component Dart remains application-owned. The official
registry continues to offer Vanilla and Fortal. The accepted cost is a CLI
release for custom initialization and an independently maintained publication
pipeline. A Carbon project cannot register official `@remix` items until the
official registry also offers the `carbon` preset; it can still depend on the
hosted Remix runtime package.

| Option | What works | Why it is not the target |
| --- | --- | --- |
| Carbon inside official `@remix` | The earlier branch could derive and test it before transfer. | Not another registry; shares official promotion and ownership. |
| `@carbon` add-on labeled `vanilla` | Current `registry add` can install it into a Vanilla project. | Misstates the design language and cannot cleanly initialize a Carbon-only project. |
| Standalone `@carbon` with `preset: carbon` | Own pin, catalog, release gate, and source lifecycle. | Requires a backward-compatible custom-source `init` option and publisher setup. **Recommended.** |

## Evidence at the start of execution

- The fetched `origin/main` and `origin/registry-stable` are at `849dbc0c0`.
  Their `registry/index.yaml` maps only `vanilla` and `fortal`.
- This branch initially had Carbon theme, Button, four-theme token pipeline,
  tests, and derived `registry/carbon/` templates. It also added Carbon to the
  *official* index; that placement was the part to reconsider, not the work on
  the Carbon components.
- `remix registry add` accepts a public GitHub repository and validates the
  project's already-selected preset. `remix init` currently always pins
  `conceptadev/remix` as `@remix`. The existing registry guide explicitly notes
  that a third-party registry cannot yet introduce its own preset.
- `remix.yaml` schema 3 already represents a custom `defaultRegistry`, custom
  preset, and full-SHA pin. The graph and source readers already accept them.
  The missing capability is the normal CLI path that creates that configuration.
- The current registry builder depends on the Remix workspace root and reads
  dependency floors from the Vanilla catalog. A standalone publisher must own
  its own floors and generation gate rather than silently depending on those
  files in Remix.

## What the separate registry looks like

The consumer contract is the existing index/catalog/template format; no new
wire schema is proposed:

```text
registry/
  index.yaml                       # schema 1; carbon -> carbon/registry.yaml
  carbon/
    registry.yaml                  # schema 2; theme, button, later items
    templates/
      theme/                       # ordinary .dart.tmpl source, including tokens
      button/button.dart.tmpl
```

`index.yaml` contains:

```yaml
schema: 1
presets:
  carbon: carbon/registry.yaml
```

The `button` entry in `carbon/registry.yaml` keeps the existing contract
(excerpt; the `theme` item lists all of its generated token libraries):

```yaml
schema: 2
items:
  button:
    registryDependencies:
      - theme
    dependencies:
      mix_annotations: ^2.2.0-beta.1
    devDependencies:
      build_runner: ^2.10.1
      mix_generator: ^2.2.0-beta.3
    files:
      - source: templates/button/button.dart.tmpl
        target: "@ui/components/button.dart"
    generated:
      - "@ui/components/button.g.dart"
    exports:
      - components/button.dart
```

The first catalog retains the current `theme → button` closure, the current
Remix and generator constraints, all theme/token files, generated Button
adapter declaration, and exports. Template targets remain rooted at `@ui/`;
the registry never writes `@ui/ui.dart`. Carbon attribution and the pinned IBM
source manifest travel with the installed files.

A successfully initialized project should record this shape in `remix.yaml`:

```yaml
schema: 3
prefix: Acme
preset: carbon
paths:
  ui: lib/ui
defaultRegistry: "@carbon"
registries:
  "@carbon":
    repository: "<chosen-public-owner/repository>"
    path: "registry"
    ref: "stable"
    revision: "<resolved-full-commit-sha>"
```

The repository name and consumer-facing namespace/ref have been selected;
the example above is a contract illustration, and the public repository now
exists.
Keep the registry public while the CLI supports only public `github.com`.

## Task 1 — Prove the standalone distribution contract locally

**Files or components:** The current `registry/carbon/` output,
`packages/remix_cli/test/checkout_registry.dart`,
`packages/remix_cli/test/registry_test.dart`, and a proposed focused
standalone-registry test.

**Change:** Assemble an isolated registry root in a temporary test directory
from the current generated Carbon catalog and template closure; do not commit
a duplicate distribution. Parse it through the same index/catalog rules used
for a GitHub source and render it with a non-official `RegistrySource` pin.
Use this fixture to make ownership, paths, provenance, and the exact dependency
closure visible before moving the authoring source.

**Validation:** Assert `carbon` resolves, `theme` precedes `button`, every
declared template exists, target and generated paths are unique, and installed
source does not import `registry_source`, `mix`, Naked UI, charts, icons, or
Agent. `mix_annotations` is an intentional runtime dependency;
`mix_generator` and `build_runner` are intentional development dependencies.
A scratch consumer must generate and analyze with the current Remix runtime.
Retain existing Vanilla/Fortal tests unchanged.

## Task 2 — Let a new project initialize from its chosen registry

**Files or components:** `packages/remix_cli/lib/src/cli.dart`,
`installer.dart`, `project_config.dart`, registry-source tests, init-command
tests, and `docs/guides/registries.mdx`.

**Change:** Extend `remix init` with an optional source selection, for example
`--registry @carbon --repository OWNER/REPO --path registry --ref stable`.
Require namespace and repository together, and reject `--path` or `--ref`
without them. With no explicit source, use CLI-shipped defaults only for the
currently supported presets: `vanilla` and `fortal` use the official
`@remix`/`btwld/remix`/`registry-stable` source (updated to match the
2026-09-25 canonical repository transfer); `carbon` uses
`@carbon`/`btwld/flutter-carbon`/`stable`. An unknown preset needs explicit
`--registry` and `--repository`; custom sources override the lookup. Do not
fetch an additional central discovery file. Resolve the ref to a full SHA,
open its index, validate
the requested preset, and only then write `remix.yaml` and the managed barrel.
Set `defaultRegistry` to the selected namespace and record only the selected
source at initialization. An existing configuration must not be silently
repointed by a later `init`; ref changes use `registry update`, while
repository/path/namespace changes require an explicit future migration or
reinitialization. Do not change schema 3 or expose local/private/HTTP
registries as part of this feature.

**Validation:** Test the Vanilla/Fortal and Carbon default lookup, unknown
preset guidance, explicit custom-source override, custom preset and source,
idempotent rerun, mismatched rerun, missing preset/ref/repository, network
failure before any write, and exact-SHA reads. Ensure `add button`, `--diff`,
`--dry-run`, `--overwrite`, and `registry update` work with the custom default
namespace. Cross-registry dependencies remain opt-in through explicit
`registry add`; no dependency auto-registers a source.

## Task 3 — Give Carbon one source of truth in its own repository

**Files or components:** Current `registry_source/lib/carbon.dart`,
`registry_source/lib/src/carbon/`, `registry_source/tool/carbon/`,
`registry_source/test/carbon/`, `registry_source/reference/carbon_1_114_0/`,
the Carbon ADR/runbook/component map, `tool/build_registry.dart`,
`registry/carbon/`, and the proposed standalone repository.

**Change:** Transfer the existing analyzer-checked Carbon source, token lock,
generator, notices, focused tests, reference data, and component roadmap into
the standalone repository before removing their copies from Remix. Give that
repository an authoring Dart package, its own dependency-floor inputs, a
deterministic publisher that derives `registry/index.yaml` and the Carbon
catalog/templates, drift checks, CI, README, and attribution/license files.
Extract only the generic builder behavior Carbon actually needs; do not fork
the entire multi-preset/Agent builder or import `remix_cli/src/` as a publisher
API. Preserve the generic nested shared-file path support added to Remix's
builder, with Vanilla/Fortal regression coverage, if it remains useful there.
Keep generated `.g.dart` adapters build-runner-owned and install only ordinary
token `.dart` files. Preserve prefix substitution and provenance byte-for-byte
in the emitted templates.

**Validation:** Compare the standalone `theme` and `button` catalog, rendered
source, token files, and consumer behavior against the current branch before
retiring the in-repo copy. Run token determinism, Dart analysis, Carbon widget
tests, catalog drift, and fresh checkout/hosted Remix consumers in the new
repository. Do not delete the source in Remix until this parity check passes.

## Task 4 — Clean this checkout and separate publication

**Files or components:** The new registry's CI and README; this repository's
official index, builder, consumer checks, fixtures, CI/release scripts, docs,
and Carbon authoring tree. Use this disposition checklist for the current
Carbon branch, including its five uncommitted official-preset edits:

| Current Remix files | Disposition after standalone parity |
| --- | --- |
| `registry/carbon/`, Carbon line in `registry/index.yaml` | Move the derived catalog/templates to the new registry's publisher; leave the official index with Vanilla/Fortal only. |
| `registry_source/lib/carbon.dart`, `registry_source/lib/src/carbon/`, `registry_source/test/carbon/`, `registry_source/reference/carbon_1_114_0/`, `registry_source/tool/carbon/` | Transfer source, tests, locked token pipeline, reference data, and notices to the new repository; remove duplicate authoring copies here only after parity. |
| Carbon spec in `tool/build_registry.dart`; Carbon-specific assertions in `test/tool/build_registry_test.dart` and `packages/remix_cli/test/registry_test.dart` | Remove official Carbon-preset assumptions; keep and test generic builder/registry behavior, including nested paths and custom-source parsing. |
| `open_code/carbon_fixture/`, Carbon contract in `tool/check_open_code.dart`, Carbon checks in `test/tool/check_open_code_test.dart`, `analysis_options.yaml`, `pubspec.yaml` | Move the Carbon consumer smoke to the new repository; remove Carbon-only Remix fixture/jobs/exclusion/scripts while retaining generic CLI and Vanilla/Fortal checks. |
| `.github/workflows/ci.yaml`, `.github/workflows/registry.yml`, `.github/workflows/publish.yml`, `.github/workflows/version.yml` | Revert Carbon-specific matrix, token, hosted-consumer, and promotion assumptions here; keep official promotion for Vanilla/Fortal. New-repo CI owns Carbon validation and promotion. |
| `docs/open-code.mdx`, `open_code/README.md`, `open_code/PRESETS.md`, `open_code/REGISTRIES.md`, `open_code/RELEASING.md`, `packages/remix_cli/README.md`, `docs/guides/registries.mdx` | Replace claims that Carbon is an official preset with the custom-init contract and a link to the separate registry; keep general registry instructions accurate. |
| `registry_source/docs/adr/carbon/0001-carbon-preset.md`, `registry_source/docs/carbon/runbook.md`, `registry_source/docs/carbon/component-map.md` | Make the new repository canonical for Carbon design/roadmap docs; retain only an accurate migration pointer here if useful. Do not leave the current ADR's official-GitHub-registry claim or obsolete bundled-CLI instructions as active guidance. |

The five files uncommitted at the start were `.github/workflows/registry.yml`,
`open_code/REGISTRIES.md`, `open_code/RELEASING.md`, the Carbon ADR, and the
Carbon runbook. Review their current edits individually during cleanup; do
not discard the worktree or blindly revert unrelated content.

**Change:** Keep the official registry index and promotion gate scoped to
Vanilla/Fortal. Remove the pending official Carbon distribution entry and
official-preset consumer assertions only after the standalone candidate is
verified; preserve relevant generic CLI tests. Do not merge this branch into
the official registry while it still advertises Carbon under `@remix`. In the
new public repository, advance a `stable` ref only after derived-output,
dependency, token, and fresh consumer checks pass. Release the CLI with
custom-source init and the known-preset lookup before presenting
the standalone registry as a supported consumer path. Document custom init,
namespace choice, pin/update/diff, source ownership, and IBM attribution. Do
not publish a new CLI solely for component-content changes after custom init
has shipped.

**Validation:** Audit the final Remix diff against the table: no official
Carbon index entry, Carbon-only source/fixture/CI path, or documentation that
claims Carbon is an official `@remix` catalog remains. Document bare
`remix init --preset carbon` only as the CLI lookup to the separate `@carbon`
source. Run the
existing Vanilla/Fortal builder, CLI, consumer, CI-coverage, and registry
promotion checks. Smoke-test the exact Carbon candidate commit over GitHub
using the normal CLI, then advance `stable`. A fresh app initializes with
`preset: carbon`, pins that commit under its chosen namespace, installs and tests
`button`, and updates only after `registry update`. The official registry
still initializes and installs Vanilla/Fortal. A failed promotion does not
move `stable`; existing consumer pins remain valid.

## Later component work and recovery

Only after the standalone theme/Button release is verified, use the transferred
Carbon component map in the new repository to add components as independently
reviewable registry changes. Do not include native widgets, charts, an icon
package, or Agent/dashboard surfaces in the
first release. Each needs its own behavior and dependency contract.

Rollback of a bad registry promotion is a revert promoted through CI; never
force-reset the stable branch. Restoring an older `remix.yaml` pin does not
restore installed application-owned source, which the app must review or
restore separately.

**Readiness:** The local contract, custom-source CLI path, known-preset default
lookup, public candidate, exact-commit GitHub consumer smoke, and checkout and
hosted official consumers are verified. New-head PR checks and maintainer
reviews are pending on Remix #245 and Carbon #1. Remix merge remains before
the first CLI release; Carbon promotion, hosted default-init verification, and
`stable` protection follow through the stated gates.
