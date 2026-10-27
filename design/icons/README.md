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
python -m pip install -r requirements.txt
python build.py
python tools/run_checks.py
```

`build.py` runs each family's own `source/build.py`, then writes `catalog/index.html`. Family constructors are not shared.

`tools/run_checks.py` runs the pack tests and then the recovered Angular, Soft, and Technical suites. Browser certification is not part of that command.

## Where the geometry came from

The drawings were recovered from closed, unmerged pulls and rebuilt as one pack:

- Angular `#244`, `5bcaa375a1b35d23ffc480a05f752fb72945b6d0`
- Soft `#254`, `c7bdf16848f15d22d4c49115c9399bd73c58aa3f`
- Technical `#253`, `02fa870813ad2a0246d243f25d8267dfaa26e44c`

Family READMEs still describe those pilots. Use this file for the pack.

## Not ready to merge

Design sign-off, recognition testing, and the Technical open questions are still open. The Angular release gate is meant to stay closed while the pack is private. Rounded is not drawn.
