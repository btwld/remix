# Vector UI — Technical calibration pilot

**Private review package · 12 icons · 72 SVGs · not a public release**

Instrument / CAD grammar for the Vector UI family. Same canonical IDs as Angular: `home`, `search`, `plus`, `arrow-right`, `user`, `file`, `calendar`, `sliders`, `warning`, `link`, `branch`, `star`. Outline and filled; native 12 / 16 / 24. `currentColor`. No silent fallback to Angular or another size.

This package is stacked on the Angular pilot ([PR #244](https://github.com/btwld/remix/pull/244)). Do not merge before that base branch lands. Do not publish.

## Build and check

Pinned like the Angular package: CPython 3.13, Shapely 2.1.2, CairoSVG 2.8.2, Pillow 12.3.0.

```sh
python3.13 -m venv .venv
. .venv/bin/activate
pip install -r requirements.txt
python source/build.py
python -m unittest tests.test_pilot -v
```

Proof catalog (self-contained HTML):

```sh
python -m http.server 8765
# http://localhost:8765/proof/index.html
```

Native rasters, 4× masters, and Angular-vs-Technical comparison PNGs are written by `source/build.py`. Do not hand-edit them.

## Grammar

See [docs/construction.md](docs/construction.md). Chamfer part overrides and the 12 px plus centering policy are also in `catalog/styles.json` and `catalog/exceptions.json`.

Warning keeps a **visible text label** at every master and appearance. Geometry improvements do not lift that rule.

## Open questions (human review)

Recorded in `catalog/open-questions.json` and the proof page:

1. Search-as-viewfinder vs crop/frame tools
2. CAD-regular star as Favorite
3. Plus keyline in mixed Angular+Technical toolbars
4. 12 px Link / Branch density

## License

BSD 3-Clause, Copyright (c) 2026, Leo Farias. The web/package metadata remains private review-only.
