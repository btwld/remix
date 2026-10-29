# Vector UI icon families

Private review pack for three sibling families:

| Family | Icons | SVGs | Construction |
| --- | --- | --- | --- |
| Angular | 48 | 288 | Validated Angular geometry, outline and filled, native 12 / 16 / 24 |
| Soft | 12 | 72 | Soft primitives (circles, stadiums, round joins), not an Angular path filter |
| Technical | 12 | 72 | Technical primitives (chamfered plates, square-cut bars), not an Angular path filter |

Shared comparison surface: [`catalog/index.html`](catalog/index.html). It shows Angular, Soft, and Technical together, including every Warning cell.

This directory is the package. `package.json` is `"private": true`. The license is BSD 3-Clause, copyright Leo Farias. Do not publish it to npm or pub.dev. Do not fold these drawings into `packages/remix_ui_icons` or `registry/icons.yaml`; those are the Flutter icon track.

## Warning

Warning requires a visible text label at every native size (12, 16, and 24) and both appearances (outline and filled), in every family, including scaled uses of those masters. A tooltip or accessible name is not a substitute. Gap exceptions do not lift the rule.

## Build and check

Pinned for this pack: CPython 3.13, Shapely 2.1.2, CairoSVG 2.8.2.

```sh
cd design/icons
python3.13 -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt -r angular/requirements-dev.txt
python -m playwright install --with-deps firefox
python build.py
python tools/run_checks.py
```

`build.py` runs each family's own `source/build.py`, then writes `catalog/index.html`. Family constructors are not shared.

`tools/run_checks.py` runs the pack tests and the Angular, Soft, and Technical suites, including Firefox computed-style and raw-renderer boundary regressions. Full browser navigation and certification are separate. The maintained root `vector-ui-icons.yml` workflow runs assets and full Chromium, Firefox, and WebKit checks; reports and captures are external ephemeral evidence, configured with `VECTOR_UI_EVIDENCE_DIR`.

## Where the geometry came from

The drawings were recovered from closed, unmerged pulls and rebuilt as one pack:

- Angular `#244`, `5bcaa375a1b35d23ffc480a05f752fb72945b6d0`
- Soft `#254`, `c7bdf16848f15d22d4c49115c9399bd73c58aa3f`
- Technical `#253`, `02fa870813ad2a0246d243f25d8267dfaa26e44c`

Family READMEs describe their maintained construction and usage contracts. Use this file for the combined pack.

## Not ready to merge

Design sign-off and recognition testing remain open. Technical usage limits stay in force until real evidence supports changing them. The Angular release gate stays closed while the pack is private. Rounded is not drawn.
