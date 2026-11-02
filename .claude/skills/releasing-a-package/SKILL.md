---
name: releasing-a-package
description: >-
  Use when cutting a release of a package in the Remix monorepo — naked_ui,
  remix, remix_cli, remix_ui_icons, or remix_ui_fonts. Covers choosing the
  next version, every file that must move with a version bump, the contract
  checkers that fail when one is missed, the release pull request, and the tag
  that triggers publishing. Also trigger when a `Contract checks` CI job fails
  on a release pull request, or when asked what the next version of a package
  should be.
---

# Releasing a package

Five packages publish from this monorepo and are **versioned independently**:
`remix`, `naked_ui`, `remix_cli`, `remix_ui_icons`, `remix_ui_fonts`.
`registry_source/` is private authoring source and is never published as a
package.

Publishing is tag-triggered. A version bump never publishes anything on its
own — merging the release PR and then pushing the tag does.

## 1. Decide the version

Read package diffs since the last release, not just commit subjects. Apply
semantic versioning: incompatible public API/config changes are major, added
API minor, fixes/internal/docs changes patch. Packages are independent.

## 2. Change every file the version lives in

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
  `tool/check_version_alignment.dart` fails until they do. When the new version leaves the old caret range, also move
  the melos shared constraint and every workspace pubspec that declares it.
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

## 3. Verify locally before pushing

Run the contract checks:

```bash
dart run melos run ci:checks
```

`ci:checks` includes version/floor alignment, CI coverage and the owned Fortal
specification. `dart analyze` exits 0 on infos; existing infos are not failures.

## 4. Release pull request

Use a focused release branch and Conventional Commit title
`chore(release): <pkg> <version>`. State the released behavior and why the bump
level is appropriate. Merge the reviewed PR before tagging its release commit.

## 5. Tag after merge

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

Rules that have already cost a release here:

- **Never `git push --tags`.** Stale `v*` tags in this repo would start publish
  runs from the wrong commits. Check the exact remote ref and push one tag,
  explicitly, as described below.
- `remix-v<version>` publishes **nothing** — `melos version` reads it to derive
  the next changelog. A remix release wants both `v<version>` (publishes) and
  `remix-v<version>` (melos reads).
- A `remix` release raises the registry floor, so the **Promote registry** run
  for its merge fails until pub.dev serves that version. Once it does, re-run
  **Promote registry** on `main` (Actions → Promote registry → Run workflow)
  or `registry-stable` stays on the previous floor.
- On the first monorepo release, check that `naked_ui` moved from its former
  repo/bare `v<version>` pattern. Its pub.dev tag pattern must be `naked_ui-v{{version}}` before the first release
  from this monorepo, or the job authenticates against the old pattern and
  fails.
- If bootstrapping `remix_ui_fonts`, 0.1.0 is published by hand first from a
  clean checkout of the release commit (`dart pub publish` in `packages/remix_ui_fonts`); pub.dev
  offers automated publishing only for an existing package. After that,
  enable automated publishing for it with the tag pattern
  `remix_ui_fonts-v{{version}}`; every later release follows the tag flow
  above.
- A `remix_cli` release additionally requires `registry-stable` to resolve and
  pass the hosted check; its publish job gates on
  `melos run open-code:release:check` against hosted packages.

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

For the order of the current `remix_cli`, `naked_ui`, `remix_ui_icons`, and
Remix release, see
[Bootstrap the current train](../../../open_code/RELEASING.md#bootstrap-the-current-train).
