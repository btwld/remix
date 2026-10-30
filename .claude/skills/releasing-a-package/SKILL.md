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

Read the actual changes, not the commit subjects.

```bash
git log <last-release-commit>..HEAD --format='%h %ad %s' --date=short -- packages/<pkg>
git show <sha> -- packages/<pkg>          # read every diff
```

Apply semantic versioning:

| Change | Bump |
| --- | --- |
| Public API added | minor |
| Public API or required consumer configuration changed incompatibly | major |
| Fix, internal change, message/doc-only change | patch |

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

**`remix_ui_icons` only — the icon table:**

- `registry/icons.yaml` — the `remix` library's `remix_ui_icons` dependency
  must floor at the new version. `tool/check_version_alignment.dart` fails
  until it does.

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

Individual checkers, when you want to isolate one:

```bash
dart run tool/check_version_alignment.dart     # registry floor vs remix version
dart run tool/check_ci_coverage.dart           # melos ci steps vs CI jobs
dart run melos run fortal:check                # owned specification and palette drift
```

`ci:checks` is what the `Contract checks` CI job runs. Its steps are listed
under `ci:checks:` in the root `pubspec.yaml`. Note `dart analyze` exits 0 on
info-level issues, so pre-existing infos in the output are not the failure.

## 4. Release pull request

Branch, commit, push, open the PR:

```bash
git checkout -b chore/release-<pkg>-<version-dashed>
# edits from step 2
git commit -m "chore(release): <pkg> <version>"
gh pr create --base main --title "chore(release): <pkg> <version>" --body ...
```

The PR title is linted by the `Validate PR title` job — use the conventional
`chore(release): ` prefix. In the body, state the changes being released and
why the bump level is right.

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

```bash
git checkout main && git pull
git tag naked_ui-v1.0.1 && git push origin naked_ui-v1.0.1
```

Rules that have already cost a release here:

- **Never `git push --tags`.** Stale `v*` tags in this repo would start
  publish runs from the wrong commits. Push one tag, explicitly.
- `remix-v<version>` publishes **nothing** — `melos version` reads it to derive
  the next changelog. A remix release wants both `v<version>` (publishes) and
  `remix-v<version>` (melos reads).
- A `remix` release raises the registry floor, so the **Promote registry** run
  for its merge fails until pub.dev serves that version. Once it does, re-run
  **Promote registry** on `main` (Actions → Promote registry → Run workflow)
  or `registry-stable` stays on the previous floor.
- `naked_ui` published from its own repo on the bare `v<version>` pattern. Its
  pub.dev tag pattern must be `naked_ui-v{{version}}` before the first release
  from this monorepo, or the job authenticates against the old pattern and
  fails.
- `remix_ui_fonts` 0.1.0 is published by hand first, from a clean checkout of
  the release commit (`dart pub publish` in `packages/remix_ui_fonts`); pub.dev
  offers automated publishing only for an existing package. After that,
  enable automated publishing for it with the tag pattern
  `remix_ui_fonts-v{{version}}`; every later release follows the tag flow
  above.
- A `remix_cli` release additionally requires `registry-stable` to resolve and
  pass the hosted check; its publish job gates on
  `melos run open-code:release:check` against hosted packages.
