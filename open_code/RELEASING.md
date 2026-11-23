# Release runtime, registry, and CLI independently

Use the reviewed merge commit as the candidate. Do not infer publication from
checkout version numbers. Runtime package publication, registry publication,
and CLI publication have separate gates. GitHub Actions creates package tags
and Releases; the registry builder does not.

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

Merging the release PR to `main` starts **Tag releases**, which creates the
tags and dispatches **Publish to pub.dev**. Read package diffs since the last
release, not just commit subjects. Apply semantic versioning:
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
- The package is generated. Change `packages/remix_ui_icons/tool/icons/manifest.yaml`
  or the `design/icons` masters, run `dart run melos run icons:generate`, and
  fill in the CHANGELOG entry around its generated block. The `since:` of a new
  concept is the new version.
- Follow the maintainer policy in `packages/remix_ui_icons/tool/icons/README.md`:
  a new icon, family, master, or redraw is minor; a removal is major; a codepoint
  never changes. For removals, `packages/remix_ui_icons/tool/icons/check.py`
  accepts a major bump or a minor bump within `0.x`; the maintainer policy
  still requires a major bump.
- After the release is published, replace
  `packages/remix_ui_icons/tool/icons/released_api.txt` with
  `packages/remix_ui_icons/tool/icons/public_api.txt` and set its `version:`
  line, so the next release is compared with it.
- The registry needs the CLI that reads its `icons.yaml` schema; publish
  `remix_cli` first when the schema changes, then `remix_ui_icons`, and only
  then let **Promote registry** run.

**`remix` only:** prefer the **Prepare Version Bump** workflow
(`.github/workflows/version.yml`, `workflow_dispatch`, takes an exact version).
It runs `melos version` and verifies that `packages/remix/pubspec.yaml`
matches the request before syncing floors. It then runs
`tool/sync_registry_remix.dart` and
`tool/build_registry.dart`, because the remote `registry.yaml` floor
(`remix: ^<version>`) is data melos never reaches. It pushes
`release/version-packages` and prints a compare link; it does not open the PR
or tag.

If the requested version was not prepared, look for the Melos warning that
Remix “depends on an ignored package that has pending changes.” Melos names
Remix in that warning, not the excluded dependency. Check its workspace
dependencies for unreleased versionable commits. If `naked_ui` is the blocker,
version and release it separately first, following the `naked_ui` steps above,
then re-dispatch **Prepare Version Bump** for Remix.

Keep compatible caret constraints unless the consumer needs a newer release.
If raising a floor, publish the dependency first. Runtime or registry-only
changes do not require a `remix_cli` version bump.

Run `dart run melos run ci:checks` before pushing, use a focused release branch
with Conventional Commit title `chore(release): <pkg> <version>`, and merge the
reviewed PR to start the release.

### Tag patterns after merge

**Tag releases** creates missing tags at the merge SHA when the package's
version changed in the push and its changelog has a `## <version>` heading. It
reports and skips existing remote tags, including tags at a different commit.
If either Remix tag points to a different commit, the workflow leaves its
partner alone rather than splitting the pair across commits.
Tags created with `GITHUB_TOKEN` do not trigger a push workflow, so automation
dispatches **Publish to pub.dev** on each newly created publishing tag.
Existing CLI consumer checks and the `Production` environment gate still apply.

**Before the next release**, for each package, open pub.dev → **Admin** →
**Automated publishing** and tick **Enable publishing from workflow_dispatch events**.
Without it, a dispatched publish fails OIDC authentication. Each package's tag
pattern must also match its pub.dev configuration:

| Package | Tag |
| --- | --- |
| `remix` | `v<version>` (bare) |
| `naked_ui` | `naked_ui-v<version>` |
| `remix_cli` | `remix_cli-v<version>` |
| `remix_ui_icons` | `remix_ui_icons-v<version>` |
| `remix_ui_fonts` | `remix_ui_fonts-v<version>` |

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

### GitHub Releases and notes

After publication succeeds, **Publish to pub.dev** creates a GitHub Release
on the publishing tag (never `remix-v<version>`). To override the notes, include
`.github/release-notes/<tag>.md` in the release PR, for example
`.github/release-notes/v1.0.0.md` for Remix. Otherwise, the workflow uses the
version's changelog section, or GitHub's generated notes if the section is
empty or only links elsewhere. The workflow appends the version's pub.dev
link. A version with a prerelease suffix is marked as a prerelease, and only
stable Remix releases are marked latest. An existing GitHub Release is left alone.

### Manual recovery

Check the **Tag releases** summary first. A manual dispatch of **Tag releases**
on `main` considers every current package version with a changelog heading and
missing tag, even if the version did not change in the last push. Only use it
if the current `main` SHA is the intended release commit for the missing tags
and none of the missing publishing tags name versions already on pub.dev.

If a publishing tag exists at the intended commit but publishing was not
dispatched, fix the reported issue first and, for Remix, confirm both tags
point to that commit. Then run `gh workflow run publish.yml --ref '<publishing-tag>'`
if the version is not already published. If only GitHub Release creation failed,
rerun the failed job instead of republishing.

A hand-pushed publishing tag still runs **Publish to pub.dev** and creates a
GitHub Release after publishing. Use this fallback only for a missing tag and
**never `git push --tags`**.

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
that exact version, prints it, verifies `remix --version`, initializes from
stable, and runs `registry update @remix --ref <candidate-SHA>`. When
`registry-stable` does not exist, it writes a `remix.yaml` that pins `@remix`
to the candidate before `init`, so promotion can create the branch. That run
does not prove that a fresh default `remix init` resolves `registry-stable`;
use the checklist below after promotion creates it. A failed branch lookup
blocks the check. It installs two representative items and analyzes
their installed source. This uses the published executable without the
checkout harness or a fallback. Selection ignores the candidate pubspec's lower
bound: a synchronized install pin can already name the next, unpublished CLI.
A separate readiness guard warns if no published version satisfies that pin;
the candidate version will satisfy it once published. This warning does not
block promotion, because compatibility must be proved with the CLI users can
install today. Publish the candidate CLI before advertising its new install
pin. Missing same-major releases and pub.dev lookup failures still block the
compatibility check.

Expect approximately 6–9 minutes wall time, including canaries and the
published-CLI smoke, versus approximately 45 minutes previously. This is an
estimate from the audit; measure the first GitHub runs. Logs show one timing
line per child step. GitHub groups phases and appends a timing table to the
step summary, including on failure. Pass `--verbose` to
`dart run tool/check_open_code.dart` to stream its child output.

`promote` needs both jobs and fast-forwards `registry-stable` only on `main`.
A dispatch on a feature branch validates its candidate and skips promotion.
The `static` job also runs `generate_skills_index.dart --check`, so a stale
`skills/index.yaml` cannot reach a pin that `remix skills install` reads.

Before creating an app, the preflight checks every runtime, generator, and icon
library floor on pub.dev. A missing Remix floor prints:

```text
remix ^X is not on pub.dev yet; push tag vX, wait for the Publish workflow, then re-run Promote registry
```

If a floor is missing, the run fails within seconds and does not advance
`registry-stable`. For a Remix-owned package, check **Tag releases** and wait
for **Publish to pub.dev** to make that version available. Use the manual
recovery steps if needed. For an upstream dependency, wait for its publisher
or revise the candidate.

Once the required floors are available, retry promotion. **Promote registry**
validates and pushes the run's event SHA. **Re-run jobs** retries the original
SHA; use it only if that SHA is still the intended candidate and can
fast-forward `registry-stable`.
**Run workflow** on `main` starts a new run at the head of `main` at dispatch.
A new push to `main` likewise starts a run for that push's SHA.

If `registry-stable` is missing, a push to `main` or a dispatch on `main`
starts validation. The workflow creates the branch at the validated run SHA
only after both the static and hosted jobs pass, including the published-CLI
check.

After the initial registry and CLI bootstrap, CLI publication and registry
promotion can run in either order: promotion tests the newest already-published
CLI, while CLI publication tests the already-promoted registry. A candidate that
requires new CLI behavior must remain compatible with the released major line
or wait for that CLI's publication.

Normal component changes do not require a CLI release. Existing pins do not
move automatically. `remix registry update @remix` re-resolves the saved ref
when called without `--ref`; it follows `registry-stable` only if that is the
saved ref, and it does not change installed source. Keep schema compatibility
with released CLI versions.

## Release checklist and log

1. **Merge** the reviewed release PR to `main`. Record the maintainer, merge
   SHA, and UTC time. For a package bump, confirm **Tag releases** created the
   expected tags and **Publish to pub.dev** produced the pub.dev version and
   its GitHub Release.
2. **Promote.** Match the **Promote registry** run to the intended merge SHA
   and verify that `Promote registry-stable` succeeded and the branch points to
   that SHA. Record the run link, previous and new SHAs, and outcome; for a
   failed run, include the failing step and log. A newer `main` run can replace
   a pending run or advance the branch before smoke testing. If that happens,
   log the intended SHA as superseded rather than keep waiting or credit a
   different SHA with its results.
3. **Smoke-test default init.** Use the published CLI in fresh Vanilla,
   Fortal, and HeroUI Flutter apps, without a preseeded `remix.yaml`. Run
   `remix init` for Vanilla, `remix init --preset fortal` for Fortal, and
   `remix init --preset heroui` for HeroUI. Each init must succeed and record
   the intended promoted SHA in `registries["@remix"].revision`. If a newer
   promotion changes the resolved SHA, record the superseded check instead
   of counting it as a pass. In each app, use `remix add` to install
   representative items, then run `flutter pub get` and `flutter analyze`;
   all three commands must succeed. Record the CLI version, items, and result
   for each preset. If verification fails after the push, record **promoted;
   verification failed** and decide whether to restore the registry or fix
   forward: the branch is already live.

   For broader coverage, this optional aggregate uses the checkout CLI with
   `registry-stable` and hosted runtimes. It installs every item in all presets,
   with two incremental adds and one batch per gallery, and skips independent
   apps. It does not replace the published-CLI smoke.

   ```shell
   REMIX_REGISTRY_RELEASE_SMOKE=1 fvm dart run melos run open-code:release:check
   ```

4. **Post one `Release log` comment** on the release PR. Use one row for the
   merge, one for promotion, and one per preset smoke. Include a protection
   row only if protection was checked or changed; record the ruleset ID if
   available. Each row records the step, operator, a link to the commit, run,
   or ruleset, UTC time, result, and rollback action (or not applicable).

### Restore the published registry

Use a known-good promoted SHA as a reference to restore its behavior in a
reviewed PR on current `main`, not to copy its old dependency floors. Keep
floors aligned with the workspace where required, and match the Remix floor
to the newest unretracted Remix version on pub.dev, including prereleases.
Regenerate `registry/` with
`dart run melos run open-code:registry:build`. If the old behavior is not
compatible with the current runtime, ship a forward fix instead of lowering
the floor.

After merge, let **Promote registry** validate and fast-forward
`registry-stable` to the new commit, then repeat the smoke tests and log the
rollback. The restored behavior has a new SHA; do not reset, force-push, or
delete `registry-stable`. Existing projects stay on their pinned revisions.

**Protection:** The active `registry-stable protection` ruleset targets only
`refs/heads/registry-stable` and blocks force pushes and deletion with no
bypass actors.

The remaining follow-up is a separate ruleset restricting creation and updates
on the same ref, with **Always allow** for only a dedicated GitHub App installed
on this repository with `Contents: write`. An admin enables that ruleset only
after the **Promote registry** job on `main` uses the app's installation token
for its push instead of `GITHUB_TOKEN`.

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

## Roll back an app

Restore the previously committed `remix.yaml` revision to select an older
registry snapshot. Changing the pin alone does not revert installed,
application-owned source. To undo an install, restore `remix.yaml`, the
`remix.ownership.json` record, and installed source together through the
app's version control. If the install changed `pubspec.yaml` or
`pubspec.lock`, revert only the install-related changes in those files and
keep unrelated dependency edits. See [the registry contract](REGISTRIES.md#update-and-review).

Schemas 1 and 2 are not readable. A project still on one names no registry, so
it is reinitialized rather than migrated. See [the registry contract](REGISTRIES.md)
for source ownership.

