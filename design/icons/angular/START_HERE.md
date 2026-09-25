# START HERE — agent handoff

This package is the audited **Vector UI Angular icon-family pilot** (`0.5.0-pilot.2`).
It exists so another agent can finish the GitHub integration without repeating the design and validation work.

## Goal

Finish the handoff into:

- Repository: `btwld/remix`
- Branch: `feat/angular-icon-family-pilot`
- Intended repository location: `design/icons/angular/`
- Default branch: `main`

Do **not** merge to `main`, publish a package, or claim public-release readiness as part of the handoff unless the remaining release blockers below have been explicitly resolved.

## Current GitHub state

At handoff time:

- `main` was at `849dbc0c03348f13f8a99bb50bebd3b0e1321012` when the branch was created.
- `feat/angular-icon-family-pilot` exists.
- The branch is currently one commit ahead of `main` at `f745fdd79c0130817309393437e59148e16c35e0`.
- That commit adds only `.github/workflows/import-angular-icons.yml`.
- **The icon package itself has not been committed to the branch.**
- No pull request was opened.
- No merge, deployment, or package publication was performed.

Before doing anything else, inspect the live branch and confirm it still matches this description:

```sh
git fetch origin
git switch feat/angular-icon-family-pilot
git status
git log --oneline --decorate -5
git diff --stat origin/main...HEAD
git diff origin/main...HEAD -- .github/workflows/import-angular-icons.yml
```

The temporary import workflow was created during an incomplete transfer attempt. Treat it as disposable scaffolding. Remove it if you are going to copy the package normally.

## License decision

The owner selected the BSD 3-Clause License for this icon package on 2026-09-25.
`LICENSE` names Leo Farias, in the same form Mix uses: `Copyright (c) 2026, Leo Farias`.
The web package metadata is `BSD-3-Clause` and remains `private: true`.
This is not a public-release approval. Remix's root license was not applied silently.

## What is in this package

The package contains:

- 48 canonical icons.
- Outline and filled appearances.
- Native optical masters at 12, 16, and 24 px.
- 288 individual SVG files.
- Canonical catalog and restriction metadata.
- Source/build scripts.
- Web helper exports.
- Interactive HTML catalog.
- Native-size visual evidence and review sheets.
- Asset, rebuild, browser, pixel-regression, and release-gate tooling.
- The five audit fixes documented in `reports/AUDIT-FIXES.md`.

The approved icon geometry is already audited. Do not redraw or normalize the SVGs during repository import.

## Geometry lock

All 288 SVGs in this package were preserved across the audit patch. The earlier 198-file baseline was also preserved byte-for-byte.

During import:

- Do not run an SVG optimizer that rewrites paths.
- Do not round coordinates.
- Do not replace `currentColor`.
- Do not convert optical masters into one scalable master.
- Do not remove the Warning usage restriction.

If a tool changes an SVG, treat that as a design change that requires the visual checks again.

## Recommended repository import

After the license/provenance decision permits the public commit:

```sh
# from the remix checkout
git switch feat/angular-icon-family-pilot

# remove temporary bootstrap workflow if it is still present
git rm .github/workflows/import-angular-icons.yml

mkdir -p design/icons/angular
# copy the CONTENTS of this package into design/icons/angular/
```

The package contains its own `.github/` support files. When copied below `design/icons/angular/.github/`, they are inert documentation/templates; they are **not** root repository workflows. Do not overwrite Remix's existing root `.github/` configuration.

Do not modify Remix Flutter packages just to land the design source. Framework integration can be a separate change after the asset source is reviewed.

## Validate the package before committing

Run these commands from `design/icons/angular/`:

```sh
python -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements-dev.txt

python source/build.py
python tools/run_checks.py
python tests/visual/pixel_regression.py
node tests/integration/test_web.mjs
python tools/release_gate.py
```

For real browser-hosted checks on a machine that allows local HTTP:

```sh
python -m playwright install --with-deps chromium firefox webkit
python tests/integration/browser_checks.py --mode full --browser chromium
python tests/integration/audit_browser_checks.py --mode full --browser chromium
python tests/integration/browser_checks.py --mode full --browser firefox
python tests/integration/audit_browser_checks.py --mode full --browser firefox
python tests/integration/browser_checks.py --mode full --browser webkit
python tests/integration/audit_browser_checks.py --mode full --browser webkit
```

Do not relabel the earlier Chromium content-mode checks as hosted-browser evidence. The previous environment blocked HTTP and file navigation.

## Verify that the import did not change SVGs

The package includes `FILE-MANIFEST.sha256` and generated checksums. After copying, verify them from `design/icons/angular/`.

At minimum:

```sh
sha256sum -c FILE-MANIFEST.sha256
```

If files were intentionally omitted from the repository import, document exactly which non-product files were omitted and why. Do not omit SVGs, catalog records, restrictions, or source-of-truth build files.

## Warning restriction

`warning` is intentionally restricted.

A visible text label is required for outline and filled Warning at 12, 16, and 24 px, including scaled uses of those masters. The rule comes from `catalog/restrictions.json` and is surfaced in the generated catalog and helper APIs.

Do not weaken this rule just to make a release gate green.

## Audit fixes already applied

The current package already includes these corrections:

1. Forced-colors selected-state contrast fix.
2. Coordinate-aligned inspection grid plus separate native raster proof.
3. One authoritative Warning usage rule.
4. Input/toolchain fingerprints so reports cannot silently outlive source changes.
5. Strict SVG export-format validation.

See `reports/AUDIT-FIXES.md` for exact evidence and boundaries.

## Remaining release blockers

The package is still a **private review build**, not a 1.0/public release.

Do not claim these are complete unless new evidence exists:

- Final family name.
- Ownership/provenance decision.
- Public distribution license.
- Independent design approval.
- User recognition study.
- Screen-reader testing.
- Physical-device testing.
- Hosted browser integration.
- Firefox/WebKit browser evidence.
- Branded Safari evidence if required.
- Review of immutable/pinned GitHub Action references.
- Any other blocker still reported by `python tools/release_gate.py`.

The release gate is supposed to stay closed until these are resolved.

## Suggested commit and PR sequence

After the package is legally cleared for the public repository and the checks pass:

```sh
git add design/icons/angular .github/workflows/import-angular-icons.yml
git status
```

If the temporary workflow was removed, it should appear as a deletion. Review the staged diff carefully.

Suggested commit message:

```text
feat(icons): add audited Angular icon-family pilot
```

Then push the existing branch and open a **draft** PR into `main`.

Suggested PR title:

```text
feat(icons): add Angular icon-family pilot
```

The PR description should state:

- 48 icons / 288 SVGs.
- Outline + filled.
- 12/16/24 optical masters.
- Geometry preserved from the audited package.
- Warning restriction.
- Which validation checks passed on the current host.
- Which browser/human/release gates remain open.
- The license/provenance decision that permits the public commit.

Do not merge merely because technical checks are green.

## Files to read in order

1. `START_HERE.md` — this handoff.
2. `README.md` — package overview and normal commands.
3. `reports/AUDIT-FIXES.md` — latest detailed audit patch.
4. `docs/VALIDATION-REPORT.md` — validation scope and boundaries.
5. `docs/construction.md` — icon construction rules.
6. `docs/optical-sizing.md` — native master logic.
7. `docs/usage-restrictions.md` — usage restrictions.
8. `EXECUTION-STATUS.md` — historical pilot status.
9. `planning/NEXT.md` — future Core 120 / Rounded work.

## Definition of done for this handoff

This GitHub handoff is complete when:

- The owner has explicitly resolved the public-license/provenance question.
- The actual package exists under `design/icons/angular/` on `feat/angular-icon-family-pilot`.
- The temporary import workflow is removed or deliberately replaced.
- The 288 SVG hashes still match the audited package.
- Package checks pass in the target checkout.
- Any new hosted/cross-browser evidence is recorded honestly.
- A draft PR is open against `main` with remaining nontechnical blockers clearly listed.
- `main` is not modified except through the normal reviewed PR process.

If any of those facts cannot be verified, stop and report the gap rather than guessing.
