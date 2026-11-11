# Release runtime, registry, and CLI independently

Use the reviewed merge commit as the candidate. Do not infer publication from
checkout version numbers. Runtime package publication, registry publication,
and CLI publication have separate gates. Publishing tags/releases is a release
operator action, not something the builder performs.

When adding a preset, follow [Adding a first-party preset](ADDING_PRESETS.md).
Extend `open-code:release:check` in the root pubspec, the promotion workflow's
hosted matrix, and the examples below. Each matrix lane sets
`REMIX_REGISTRY_RELEASE_REF` to the exact candidate SHA. Normal checkout CI
alone does not establish hosted compatibility. The commands here cover all current presets.

## Validate the candidate

With the pinned Flutter 3.44.0 SDK (`icons`, `icons-tree-shake`, and
`cli-windows` are CI-only):

```shell
fvm flutter pub get
fvm dart run melos run ci
```

The registry builder and dependency-floor checkers target `registry/`, which is
the only catalog the CLI reads. It ships no trees of its own.

The isolated consumer checker injects a test-only transport for the committed
`registry/` distribution. It exercises schema 3, the real installer, package
resolution, generation, analysis and consumers without requiring unpublished
content on GitHub. This is not a local-registry feature of the shipped CLI.

## Package version bumps and tags

Five packages publish from this monorepo and are **versioned independently**:
`remix`, `naked_ui`, `remix_cli`, `remix_ui_icons`, and `remix_ui_fonts`.
`registry_source/` is private authoring source and is never published as a
package.

Publishing is tag-triggered. A version bump never publishes anything on its
own — merging the release PR and then pushing the tag does. Read package diffs
since the last release, not just commit subjects. Apply semantic versioning:
incompatible public API/config changes are major, added API minor, and
fixes/internal/docs changes patch.

### Files that move with a version bump

**Always, for any package:**

- `packages/<pkg>/pubspec.yaml` — `version:`
- `packages/<pkg>/CHANGELOG.md` — a new top entry, matching the surrounding
  style (`## <version>` then `### Fixes` / `### Features` bullets)
- install pins in user-facing docs and skill evals — run
  `dart run tool/sync_install_pins.dart`, which rewrites the files
  `tool/install_pins.dart` lists. The READMEs ship inside the package
  tarball, so they must name the version being tagged; `docs:check` fails
  until every pin matches the pubspec.

**`naked_ui` only — the consumer floor:**

If raising Remix's consumer floor, update its `naked_ui` dependency and the root
melos shared constraint, then bootstrap the workspace. Fortal uses the workspace
behavior tests and its own specification; there is no external parity pin.

**`remix_cli` only:**

- `packages/remix_cli/lib/src/version.dart` — `remixCliVersion`, same version
  as the pubspec

**`remix_ui_fonts` only — the Vanilla theme floor:**

- `registry/vanilla/registry.yaml` — the `theme` item's `remix_ui_fonts`
  constraint must floor at the new version. Edit it, then run
  `dart run tool/build_registry.dart`. Also move the melos shared constraint
  in the root `pubspec.yaml`, and the constraint in
  `registry_source/pubspec.yaml` and `apps/playground/pubspec.yaml`, when the new
  version leaves the old caret range (any minor bump while the package is
  0.x). `tool/check_version_alignment.dart` fails until the floor matches.

**`remix_ui_icons` only — the icon table and the generated API:**

- `registry/icons.yaml` — every library that depends on `remix_ui_icons`
  (`remix` and `rounded`) must floor at the new version.
  `tool/check_version_alignment.dart` fails until they do. When the new version
  leaves the old caret range, also move the melos shared constraint and every
  workspace pubspec that declares it.
- The package is generated. Change `tool/icons/manifest.yaml` or the
  `design/icons` masters, run `dart run melos run icons:generate`, and fill in
  the CHANGELOG entry around its generated block. The `since:` of a new
  concept is the new version.
- Choose the bump from `tool/icons/README.md`: a new icon, family, master, or
  redraw is minor; a removal is major; a codepoint never changes.
  `tool/icons/check.py` fails a removal from `released_api.txt` that is not a
  major version.
- After the release is published, replace `tool/icons/released_api.txt` with
  `tool/icons/public_api.txt` and set its `version:` line, so the next
  release is compared with it.
- The registry needs the CLI that reads its `icons.yaml` schema; publish
  `remix_cli` first when the schema changes, then `remix_ui_icons`, and only
  then let **Promote registry** run.

**`remix` only:** prefer the **Prepare Version Bump** workflow
(`.github/workflows/version.yml`, `workflow_dispatch`, takes an exact version).
It runs `melos version` plus `tool/sync_registry_remix.dart` and
`tool/build_registry.dart`, because the remote `registry.yaml` floor
(`remix: ^<version>`) is data melos never reaches. It pushes
`release/version-packages` and prints a compare link; it does not open the PR
or tag.

Keep compatible caret constraints unless the consumer needs a newer release.
If raising a floor, publish the dependency first. Runtime or registry-only
changes do not require a `remix_cli` version bump.

Run `dart run melos run ci:checks` before pushing, use a focused release branch
with Conventional Commit title `chore(release): <pkg> <version>`, and merge the
reviewed PR before tagging its release commit.

### Tag patterns after merge

Publishing (`.github/workflows/publish.yml`) fires on a tag push, and **each
package has its own tag pattern**, matched against its pub.dev "Automated
publishing" configuration. A mismatched tag fails OIDC auth.

| Package | Tag |
| --- | --- |
| `remix` | `v<version>` (bare) |
| `naked_ui` | `naked_ui-v<version>` |
| `remix_cli` | `remix_cli-v<version>` |
| `remix_ui_icons` | `remix_ui_icons-v<version>` |
| `remix_ui_fonts` | `remix_ui_fonts-v<version>` |

- **Never `git push --tags`.** Stale `v*` tags in this repo would start publish
  runs from the wrong commits. Check the exact remote ref and push one tag,
  explicitly, as described below.
- `remix-v<version>` publishes **nothing** — `melos version` reads it to derive
  the next changelog. A remix release wants both `v<version>` (publishes) and
  `remix-v<version>` (melos reads).
- On the first monorepo release, check that `naked_ui` moved from its former
  repo/bare `v<version>` pattern to `naked_ui-v{{version}}` in pub.dev
  automated publishing.
- If bootstrapping `remix_ui_fonts`, 0.1.0 is published by hand first from a
  clean checkout of the release commit (`dart pub publish` in
  `packages/remix_ui_fonts`), then automated publishing is enabled with
  `remix_ui_fonts-v{{version}}`.

### Check a tag before creating it

A local tag can hold an old commit under the name you are about to use. For
example, a local `v1.0.0-beta.14` is a 2024 Mix release (tag object
`41ebf88dbc1aeb2f1b1d5a7cd01f8f6b91aa89c8`, commit
`f4ceeb4592210b3b43b2e6df1d4f30143c518868`), and that commit's own workflow
publishes on `v*`. Inspect the real GitHub remote first; a checkout's `origin`
can be a local path:

```bash
git ls-remote https://github.com/btwld/remix.git \
  "refs/tags/<tag>" "refs/tags/<tag>^{}"
```

- **Absent from GitHub, no local tag:** create it at the reviewed merge.
- **Absent from GitHub, stale locally:** record the IDs, delete only the local
  tag, and recreate it at the reviewed merge:

  ```bash
  git rev-parse "refs/tags/<tag>" "refs/tags/<tag>^{commit}"
  git tag -d "<tag>"
  git tag "<tag>" <reviewed-merge>
  ```

- **Present on GitHub at the reviewed commit:** it is already pushed. Don't
  push it again.
- **Present on GitHub at any other commit:** stop. Moving a public tag needs an
  explicit decision from Leo; never force or delete it.

Then push that one ref:

```bash
git push https://github.com/btwld/remix.git "refs/tags/<tag>:refs/tags/<tag>"
```

## Keep user-facing docs on the published release

`docs:check` rejects "unpublished", "not published yet", and "this checkout"
in the documents `userFacingDocuments` lists in `tool/install_pins.dart`, and
holds every `pub add` and `pub global activate` pin there, and in the skills'
`evals/evals.json`, to the package pubspec. `tool/sync_install_pins.dart`
rewrites the same files. Describe a candidate here, in `REGISTRIES.md`, or in a
pull request, never in those documents. After a tag publishes, confirm the pinned version resolves from pub.dev
with the hosted checks below and with a fresh app that follows `README.md`.

## Publish the required runtimes first

Confirm every hosted dependency floor exists on pub.dev. Runtime releases use
the package publishing workflows and tag patterns above. Each package keeps
its own gate; if one fails, stop there rather than publishing around it. Runtime
version preparation updates the remote catalog floor and regenerates all affected
remote presets.

Validate against hosted runtimes, without checkout substitution:

```shell
fvm dart run melos run open-code:release:check
```

## Promote the registry and bootstrap the GitHub-first CLI

Merge the reviewed commit to `main`. **Promote registry** validates
the candidate through two parallel jobs:

| Job | Proof |
| --- | --- |
| `static` | Generated registry drift, dependency constraints, version alignment, builder tests, checker/lifecycle fixture tests, and CLI tests. |
| `hosted` | A matrix of Vanilla, Fortal, and HeroUI with `fail-fast: false` and a 20-minute timeout per lane. |

Each hosted lane reads the exact workflow commit through the checkout CLI's
GitHub transport. It installs one independent canary: `dashboard_shell` for
Vanilla/Fortal and `search_field` for HeroUI. The gallery installs its first
two items incrementally, then batches every remaining item. Inventory,
dependency boundaries, generated snapshots, analysis, and fixture tests still run.
Checkout CI retains every independent install and the full incremental loop.

The hosted app pins Remix to the exact registry floor with a hosted version
override. Other overrides and path substitutions remain forbidden. A separate
pub.dev preflight rejects a stale Remix floor, including newer prereleases.
Publishing a newer version during the consumer run cannot change its resolution.

Each lane also selects the newest unretracted `remix_cli` published on pub.dev
in the documented install pin’s major line, including prereleases. It activates
that exact version, prints it, verifies `remix --version`, initializes from stable,
and runs `registry update @remix --ref <candidate-SHA>`. It installs two
representative items and analyzes their installed source. This uses the
published executable without the checkout harness or a fallback. Selection
ignores the candidate pubspec's lower bound: a synchronized install pin can
already name the next, unpublished CLI. A separate readiness guard warns if no
published version satisfies that pin; the candidate version will satisfy it
once published. This warning does not block promotion, because compatibility
must be proved with the CLI users can install today. Publish the candidate CLI
before advertising its new install pin. Missing same-major releases and pub.dev
lookup failures still block the compatibility check.

Expect approximately 6–9 minutes wall time, including canaries and the
published-CLI smoke, versus approximately 45 minutes previously. This is an
estimate from the audit; measure the first GitHub runs. Logs show one timing
line per child step. GitHub groups phases and appends a timing table to the
step summary, including on failure. Use `--verbose` for streaming child output.

`promote` needs both jobs and fast-forwards `registry-stable` only on `main`.
A dispatch on a feature branch validates its candidate and skips promotion.
The `static` job also runs `generate_skills_index.dart --check`, so a stale
`skills/index.yaml` cannot reach a pin that `remix skills install` reads.

Before creating an app, the preflight checks every runtime, generator, and icon
library floor on pub.dev. A missing Remix floor prints:

```text
remix ^X is not on pub.dev yet; push tag vX, wait for the Publish workflow, then re-run Promote registry
```

If a floor is missing, the run fails within seconds and
`registry-stable` does not move. `main` shows that failure until the floor
is published. Publish the runtime, wait until pub.dev serves it, then
re-run **Promote registry** on `main` (Actions → Promote registry → Run
workflow). Another push to `main` retries the same way. Promotion always
takes the head of `main`, so while an unpublished floor is on `main`, no
registry change is promoted until that publish and re-run.

After the first promotion creates `registry-stable`, protect that branch:
only GitHub Actions may push, and force pushes and deletion are disabled.

Roll a bad promotion back by reverting that commit on `main` and letting
the workflow fast-forward `registry-stable` to the revert. Moving the
branch back by hand takes a force push, which that protection rejects, and
the next push to `main` would advance the branch over the reset. Projects
that already pinned a revision stay on it either way.

Optionally repeat the fast smoke after promotion. The workflow already checked
the candidate against hosted packages and the published CLI. This aggregate
installs every item in all presets, with two incremental adds and one batch per
gallery, and skips independent apps:

```shell
REMIX_REGISTRY_RELEASE_SMOKE=1 fvm dart run melos run open-code:release:check
```

After the initial registry and CLI bootstrap, CLI publication and registry
promotion can run in either order: promotion tests the newest already-published
CLI, while CLI publication tests the already-promoted registry. A candidate that
requires new CLI behavior must remain compatible with the released major line
or wait for that CLI's publication.

Normal component changes require only that promotion. The same CLI installs
the new commit after an explicit `registry update`; existing pins do not
move. Keep schema compatibility with released CLI versions.

## Release the CLI only for installer changes

Before publishing, run `dart pub publish --dry-run` in `packages/remix_cli`.
Update its version, `lib/src/version.dart` and changelog according to the
package release workflow; do not infer a new CLI version from a registry
version.

The CLI publish workflow requires `registry-stable` to resolve and runs
the fast aggregate against its GitHub content with hosted runtime packages.
After `init`, the smoke reads the index, preset catalog, and icons at the exact
revision recorded in `remix.yaml`. That catalog supplies every gallery item,
its authored and generated inventory, runtime dependencies, and exact Remix
floor. It includes items removed from the candidate as well as excluding items
not yet promoted; the item plan never comes from the candidate's hardcoded list.
The published floors must exist but may predate newer runtime releases. Candidate
promotion retains the separate newest-Remix-floor requirement.

The stable smoke compiles the installed public barrel and analyzes all installed
source using a minimal app, so candidate gallery widgets and generated snapshots
cannot demand unpromoted items. Candidate validation retains its full committed
gallery, behavior tests, and snapshot checks. There is no checkout fallback for a
missing branch or catalog. Bootstrap requires an initial stable registry and an
initial published CLI; subsequent CLI tags can publish before or after promotion
of the corresponding registry changes.

If the CLI has never been published, the authorized uploader must perform the
first pub.dev publication and configure automated publishing for repository
`btwld/remix`, tag pattern `remix_cli-v{{version}}`. Later releases use
that tag pattern. Never republish an existing version.

After publication, verify the exact hosted CLI:

```shell
fvm dart run tool/check_open_code.dart --source hosted --hosted-cli --install batch --independent none
fvm dart run tool/check_open_code.dart --preset fortal --source hosted --hosted-cli --install batch --independent none
fvm dart run tool/check_open_code.dart --preset heroui --source hosted --hosted-cli --install batch --independent none
```

Each branch-based `init` makes one unauthenticated GitHub API request; GitHub
allows 60 an hour. These smoke commands use three requests total, one per preset.
The default hosted plan includes one independent canary per preset and plans six
inits total. Candidate SHAs need no API call to resolve their revision.
Use `--independent all` for a full isolation investigation; checkout and `both`
already default to that. Avoid repeated full branch-based smokes on a shared IP.

## Rollback and migration

Restore the previously committed `remix.yaml` revision to select an older
registry snapshot. This does not revert installed, application-owned source;
review or restore that source separately through application version control.

Schemas 1 and 2 are not readable. A project still on one names no registry, so
it is reinitialized rather than migrated. See [the registry contract](REGISTRIES.md)
for source ownership.

