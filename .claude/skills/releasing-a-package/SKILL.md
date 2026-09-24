---
name: releasing-a-package
description: >-
  Use when cutting a release of a package in the Remix monorepo — naked_ui,
  remix, remix_cli, or remix_ui_icons. Covers choosing the next version,
  every file that must move with a version bump, the contract checkers that
  fail when one is missed, the release pull request, and the tag that triggers
  publishing. Also trigger when a `Contract checks` CI job fails on a release
  pull request, or when asked what the next version of a package should be.
---

# Releasing a package

Four packages publish from this monorepo and are **versioned independently**:
`remix`, `naked_ui`, `remix_cli`, `remix_ui_icons`. `registry_source/` is
private authoring source and is never published as a package.

Publishing is tag-triggered. A version bump never publishes anything on its
own — merging the release PR and then pushing the tag does.

## 1. Decide the version

Read the actual changes, not the commit subjects.

```bash
git log <last-release-commit>..HEAD --format='%h %ad %s' --date=short -- packages/<pkg>
git show <sha> -- packages/<pkg>          # read every diff
```

Then apply semver. `naked_ui` 1.0.0 and `remix` both commit to it publicly, so
the rule is not advisory:

| Change | Bump |
| --- | --- |
| Public API added | minor |
| Public API removed or changed incompatibly | major |
| Fix, internal change, message/doc-only change | patch |

A change to a user-visible `ErrorHint`, assert message, or doc comment is a
**patch** — it ships in the package but moves no API surface.

## 2. Change every file the version lives in

This is where releases break. The version is duplicated across contract
files on purpose, and a checker fails on each one that drifts.

**Always, for any package:**

- `packages/<pkg>/pubspec.yaml` — `version:`
- `packages/<pkg>/CHANGELOG.md` — a new top entry, matching the surrounding
  style (`## <version>` then `### Fixes` / `### Features` bullets)

**`naked_ui` only — the Fortal parity pin:**

- `registry_source/tool/fortal_parity/check.dart` —
  `const _expectedNakedUiVersion`

  The parity contract records the **byte-exact tested** Naked UI resolution, so
  it must equal the workspace member's version. Leave
  `_expectedNakedUiConstraint` (`'^1.0.0'`) alone — that is the *consumer
  range* in `packages/remix/pubspec.yaml`, and it only changes on a major.
  Missing this is the classic release-PR failure:

  ```
  Fortal parity contract failed (1 findings):
  - The packages/naked_ui workspace member must be version 1.0.0.
  ```

**`remix_cli` only:**

- `packages/remix_cli/lib/src/version.dart` — `remixCliVersion`, same version
  as the pubspec

**`remix` only:** prefer the **Prepare Version Bump** workflow
(`.github/workflows/version.yml`, `workflow_dispatch`, takes an exact version).
It runs `melos version` plus `tool/sync_registry_remix.dart` and
`tool/build_registry.dart`, because the remote `registry.yaml` floor
(`remix: ^<version>`) is data melos never reaches. It pushes
`release/version-packages` and prints a compare link; it does not open the PR
or tag.

Dependents pinned with a caret (`packages/remix/pubspec.yaml` has
`naked_ui: ^1.0.0`) need **no** edit for a minor or patch.

## 3. Verify locally before pushing

Run the same job CI runs — it is seconds, and it catches all of the above:

```bash
dart run melos run ci:checks
```

Individual checkers, when you want to isolate one:

```bash
dart run tool/check_version_alignment.dart     # registry floor vs remix version
dart run tool/check_ci_coverage.dart           # melos ci steps vs CI jobs
cd registry_source && dart run tool/fortal_parity/check.dart   # must run from registry_source
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
- A `remix_cli` release additionally requires `registry-stable` to resolve and
  pass the hosted check; its publish job gates on
  `melos run open-code:release:check` against hosted packages.
