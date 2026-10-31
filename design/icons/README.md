# Vector UI icon families

Private review pack for three sibling families:

| Family | Icons | SVGs | Construction |
| --- | --- | --- | --- |
| Outline | 48 | 288 | Validated Outline geometry, outline and filled, native 12 / 16 / 24 |
| Rounded | 12 | 72 | Rounded primitives (circles, stadiums, round joins), not an Outline path filter |
| Mono | 12 | 72 | Mono primitives (chamfered plates, square-cut bars), not an Outline path filter |

Angular is now **Outline**, Soft is now **Rounded**, and Technical is now **Mono**.
The appearance names `outline` and `filled` are unchanged.

Shared comparison surface: [`catalog/index.html`](catalog/index.html). It shows Outline, Rounded, and Mono together, including every Warning cell.

This directory is the package. `package.json` is `"private": true`. The license is BSD 3-Clause, copyright Leo Farias. Do not publish it to npm or pub.dev. Do not fold these drawings into `packages/remix_ui_icons` or `registry/icons.yaml`; those are the Flutter icon track.

## Warning

Warning requires a visible text label at every native size (12, 16, and 24) and both appearances (outline and filled), in every family, including scaled uses of those masters. A tooltip or accessible name is not a substitute. Gap exceptions do not lift the rule.

## Build and check

Pinned for this pack: CPython 3.13, Shapely 2.1.2, CairoSVG 2.8.2.

```sh
cd design/icons
python3.13 -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt -r outline/requirements-dev.txt
python -m playwright install --with-deps firefox
python build.py
python tools/run_checks.py
```

`build.py` runs each family's own `source/build.py`, then writes `catalog/index.html`. Family constructors are not shared.

`tools/run_checks.py` runs the pack tests and the Outline, Rounded, and Mono suites, including Firefox computed-style and raw-renderer boundary regressions. Full browser navigation and certification are separate. The maintained root `vector-ui-icons.yml` workflow runs assets and full Chromium, Firefox, and WebKit checks; reports and captures are external ephemeral evidence, configured with `VECTOR_UI_EVIDENCE_DIR`.

## Where the geometry came from

The drawings were recovered from closed, unmerged pulls and rebuilt as one pack:

- Outline `#244`, `5bcaa375a1b35d23ffc480a05f752fb72945b6d0`
- Rounded `#254`, `c7bdf16848f15d22d4c49115c9399bd73c58aa3f`
- Mono `#253`, `02fa870813ad2a0246d243f25d8267dfaa26e44c`

Family READMEs describe their maintained construction and usage contracts. Use this file for the combined pack.

## Not ready to merge

Design sign-off and recognition testing remain open. Mono usage limits stay in force until real evidence supports changing them. The Angular release gate stays closed while the pack is private. The undrawn fillet proposal previously called Rounded needs a product naming decision.

Existing web API pack/package identifiers, sprite symbol IDs, pilot version tags,
immutable fixture keys, and captions in the committed raster proofs retain their
historical spellings pending compatibility decisions. The family catalogs also
retain the unavailable legacy roadmap keys
(`rounded`, plus Mono’s `soft`); resolving those keys together with the old fillet
proposal requires a product decision. The Angular release gate keeps its name
and remains closed. License and copyright text is unchanged.
