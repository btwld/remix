# Release runtime, registry, and CLI independently

Use the reviewed merge commit as the candidate. Do not infer publication from
checkout version numbers. Runtime package publication, registry publication,
and CLI publication have separate gates. Publishing tags/releases is a release
operator action, not something the builder performs.

When adding a preset, follow [Adding a first-party preset](ADDING_PRESETS.md).
Extend both the aggregate hosted checks and the explicit remote-candidate smoke
commands in `.github/workflows/registry.yml`, plus the examples below. Normal
CI coverage does not establish that the promotion workflow smoke-tests a new
preset. The commands here cover all currently implemented presets.

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

## Publish the registry before the GitHub-first CLI

Merge the reviewed commit to `main`. **Promote registry** validates
generation drift, dependency constraints, CLI compatibility, and all supported
presets against hosted runtimes. It smoke-tests that commit, then
fast-forwards `registry-stable`. A hand-started run promotes only when it
is executing `main`.

If the registry's Remix floor is not on pub.dev yet, the run fails and
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

Smoke-test the promoted branch with hosted dependencies for all presets:

```shell
REMIX_REGISTRY_RELEASE_REF=registry-stable fvm dart run tool/check_open_code.dart --source hosted
REMIX_REGISTRY_RELEASE_REF=registry-stable fvm dart run tool/check_open_code.dart --preset fortal --source hosted
REMIX_REGISTRY_RELEASE_REF=registry-stable fvm dart run tool/check_open_code.dart --preset heroui --source hosted
```

Normal component changes require only that promotion. The same CLI installs
the new commit after an explicit `registry update`; existing pins do not
move. Keep schema compatibility with released CLI versions.

## Release the CLI only for installer changes

Before publishing, run `dart pub publish --dry-run` in `packages/remix_cli`.
Update its version, `lib/src/version.dart` and changelog according to the
package release workflow; do not infer a new CLI version from a registry
version.

The CLI publish workflow requires `registry-stable` to resolve and runs
all supported consumer presets against its GitHub content with hosted runtime packages.
A missing `registry-stable` branch must fail; there is no local content to
substitute, and nothing may be added to bypass the bootstrap order.

If the CLI has never been published, the authorized uploader must perform the
first pub.dev publication and configure automated publishing for repository
`btwld/remix`, tag pattern `remix_cli-v{{version}}`. Later releases use
that tag pattern. Never republish an existing version.

After publication, verify the exact hosted CLI:

```shell
fvm dart run tool/check_open_code.dart --source hosted --hosted-cli
fvm dart run tool/check_open_code.dart --preset fortal --source hosted --hosted-cli
fvm dart run tool/check_open_code.dart --preset heroui --source hosted --hosted-cli
```

Every item a preset installs alone starts a fresh `remix init`, and an `init`
that resolves the registry by branch name makes one unauthenticated GitHub API
request; GitHub allows 60 an hour. The three presets' commands together use
most of that, so keep each preset's list of independently installed items
short. HeroUI's is derived from its registry: the items that depend on an item
besides the theme.

## Rollback and migration

Restore the previously committed `remix.yaml` revision to select an older
registry snapshot. This does not revert installed, application-owned source;
review or restore that source separately through application version control.

Schemas 1 and 2 are not readable. A project still on one names no registry, so
it is reinitialized rather than migrated. See [the registry contract](REGISTRIES.md)
for source ownership.
