# Vector UI Soft — 12-icon calibration pack

**Working name · 0.1.0-soft-pilot · private review build, not a public release**

12 canonical icons, two appearances, and three optical masters: **72 individual SVG drawings**. Soft is a sibling Vector UI pack, not a filter on Angular and not the planned Rounded pack.

Open [`docs/catalog/index.html`](docs/catalog/index.html) for the review catalog. Grammar: [`GRAMMAR.md`](GRAMMAR.md). Self-review: [`REVIEW.md`](REVIEW.md).

This package stays `private: true`. Do not publish it.

## What this is

Same IDs and meanings as the Angular pilot:

```text
home search plus arrow-right user file
calendar sliders warning link branch star
```

Soft is constructed from circles, stadiums, and round joins. Angular SVG bytes under `design/icons/angular/` are not edited. Product SVGs serialize as expanded `M L Z` polylines; the validator remains curve-aware.

License: BSD 3-Clause, copyright Leo Farias, consistent with the Angular family decision.

## Build and check

Pinned for this pack: CPython 3.12, Shapely 2.1.2, CairoSVG 2.8.2.

```sh
python3.12 -m venv .venv
# Activate the environment using the command for your shell.
python -m pip install -r requirements.txt
python source/build.py
python source/proof.py
python tools/run_checks.py
```

Catalog: `docs/catalog/index.html`  
Native proofs: `docs/proof/soft-native.png`  
Angular vs Soft: `docs/proof/angular-vs-soft-12.png`, `docs/proof/angular-vs-soft-24.png`

## Seams

- `source/seams.py` — IDs, tokens, fail-closed errors
- `source/lookup.py` — `icon_svg` / `select_master` (no silent pack or size fallback)
- `source/draw.py` — pack-specific construction
- `source/validate.py` — curve-aware SVG/path parser (`M L C Q A Z`)

## Restrictions

Warning requires a **visible text label** in every appearance and native size, including scaled uses of those masters. A tooltip or `aria-label` is not a substitute. Branch and 12 px Link should keep a visible label; those are usage notes, not the Warning record.

## Out of scope

Public publication, Remix catalog/web API, the remaining 36 Angular IDs, Rounded, editing PR #244.
