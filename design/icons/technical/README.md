# Vector UI — Technical calibration pilot

**Private review package · 12 icons · 72 SVGs · not a public release**

Instrument / CAD grammar for the Vector UI family. Same canonical IDs as Angular: `home`, `search`, `plus`, `arrow-right`, `user`, `file`, `calendar`, `sliders`, `warning`, `link`, `branch`, `star`. Outline and filled; native 12 / 16 / 24. `currentColor`. No silent fallback to Angular or another size.

Technical is a sibling family in the unified `design/icons` pack. It remains private; do not publish.

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

## Supported-use limits

Label Search beside crop/frame/view tools and give the CAD-regular star an
explicit Favorite label. Technical plus retains its tighter inset; align mixed
toolbars using control bounds. Keep visible labels on 12 px Link and Branch.
Geometry tests do not establish recognition. These limits are maintained in
`source/contract.py` and rendered in the comparison and proof pages.

## License

BSD 3-Clause, Copyright (c) 2026, Leo Farias. The web/package metadata remains private review-only.
