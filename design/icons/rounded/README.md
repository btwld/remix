# Vector UI Rounded — 12-icon calibration pack

**Working name · 0.1.0-soft-pilot · private review build, not a public release**

12 canonical icons, two appearances, and three optical masters: **72 individual SVG drawings**. Rounded is a sibling Vector UI pack, not a filter on Outline and distinct from the undrawn fillet proposal previously called Rounded.

Open [`docs/catalog/index.html`](docs/catalog/index.html) for the review catalog. Grammar: [`GRAMMAR.md`](GRAMMAR.md).

This package stays `private: true`. Do not publish it.

## What this is

Same IDs and meanings as the Outline pilot:

```text
home search plus arrow-right user file
calendar sliders warning link branch star
```

Rounded is constructed from circles, stadiums, and round joins. Outline SVG bytes under `design/icons/outline/` are not edited. Product SVGs serialize as expanded `M L Z` polylines; the validator remains curve-aware.

License: BSD 3-Clause, copyright Leo Farias, consistent with the Outline family decision.

## Build and check

Pinned for this pack: CPython 3.13, Shapely 2.1.2, CairoSVG 2.8.2.

```sh
python3.13 -m venv .venv
# Activate the environment using the command for your shell.
python -m pip install -r requirements.txt
python source/build.py
python source/proof.py
python tools/run_checks.py
```

Catalog: `docs/catalog/index.html`  
Native proofs: `docs/proof/rounded-native.png`
Outline vs Rounded: `docs/proof/outline-vs-rounded-12.png`, `docs/proof/outline-vs-rounded-24.png`

## Seams

- `source/seams.py` — IDs, tokens, fail-closed errors
- `source/lookup.py` — `icon_svg` / `select_master` (no silent pack or size fallback)
- `source/draw.py` — pack-specific construction
- `source/validate.py` — curve-aware SVG/path parser (`M L C Q A Z`)

## Restrictions

Warning requires a **visible text label** in every appearance and native size, including scaled uses of those masters. A tooltip or `aria-label` is not a substitute.

Branch also requires a visible text label at every size and appearance, and Link requires one at 12 px. These rules are separate from the Warning record.

## Exceptions

Below-target values are measured on each build and listed in [`catalog/exceptions.json`](catalog/exceptions.json). A record discloses a tradeoff; `owner` and `reviewer` stay `null` until a person accepts it. See [`GRAMMAR.md`](GRAMMAR.md) section 6.

## Out of scope

Public publication, Remix catalog/web API, the remaining 36 Outline IDs, legacy fillet proposal. The unified pack comparison catalog includes the shipped families.
