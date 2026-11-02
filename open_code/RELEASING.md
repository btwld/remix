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

## Publish the required runtimes first

Confirm every hosted dependency floor exists on pub.dev. Runtime releases use
the existing package publishing workflows. Each package keeps its own gate; if
one fails, stop there rather than publishing around it. Remix uses `v<version>`
for pub.dev and `remix-v<version>` for Melos history. Tags follow the
[release skill's tag check](../.claude/skills/releasing-a-package/SKILL.md#check-a-tag-before-creating-it).
Runtime version preparation updates the remote catalog floor and regenerates
all affected remote presets.

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

The [package release skill](../.claude/skills/releasing-a-package/SKILL.md)
owns package-specific bump files and tag patterns. Smoke-test the promoted branch
with hosted dependencies for every preset:

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
