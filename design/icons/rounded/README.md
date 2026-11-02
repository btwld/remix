# Vector UI Rounded

**Working name · 0.2.0-private · private source pack, not a public release**

77 canonical concepts, two appearances, and three optical masters: **462 individual SVG drawings**. Rounded is a sibling Vector UI family, not a filter on Outline and distinct from the undrawn fillet proposal previously called Rounded.

Open [`docs/catalog/index.html`](docs/catalog/index.html) for the review catalog. Grammar: [`GRAMMAR.md`](GRAMMAR.md).

This package stays `private: true`. Do not publish it. `packages/remix_ui_icons` compiles these drawings into its Flutter release.

## What this is

Concept IDs, labels, and meanings are shared with Outline. `source/seams.py` lists all 77, in order, and `catalog/icons.json` carries each one's meaning, construction note, and usage.

Rounded is constructed from circles, stadiums, and round joins. It reads no Outline paths and copies no external icon or font outline. Bold and Type are authored letterforms. Outline SVG bytes under `design/icons/outline/` are not edited. Product SVGs serialize as expanded `M L Z` polylines; the validator remains curve-aware.

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
Native proofs at 4×, 2×, and 1×: `docs/proof/rounded-native.png`, `docs/proof/rounded-native-dark.png`
Outline vs Rounded, for concepts Outline has drawn: `docs/proof/outline-vs-rounded-12.png`, `docs/proof/outline-vs-rounded-24.png`

## Seams

- `source/seams.py` — IDs, tokens, fail-closed errors
- `source/lookup.py` — `icon_svg` / `select_master` (no silent pack or size fallback)
- `source/draw.py` — the calibration drawings and the dispatch for every concept
- `source/glyphs/` — constructors grouped by how a glyph is built: `direction`, `marks`, `frames`, `objects`, and the shared `kit`
- `source/validate.py` — curve-aware SVG/path parser (`M L C Q A Z`)

## Sizes

Native 12, 16, and 24 are separate drawings. Use 12 for secondary information, 16 for compact UI, and 20 or 24 for primary UI. Display sizes map through `MASTER_SELECTION`; any other size raises. Artwork size is not target size.

## Restrictions

Warning requires a **visible text label** in every appearance and native size, including scaled uses of those masters. A tooltip or `aria-label` is not a substitute.

Branch also requires a visible text label at every size and appearance, and Link requires one at 12 px. These rules are separate from the Warning record.

Help, Focus, and Group require a visible text label at 12 px, and a contextual one is recommended at other sizes. Arrow up right keeps a visible action label. Other concepts take their name from the enclosing control, and 12 px remains for labeled information.

## Exceptions

Below-target values are measured on each build and listed in [`catalog/exceptions.json`](catalog/exceptions.json). A record discloses a tradeoff; `owner` and `reviewer` stay `null` until a person accepts it. See [`GRAMMAR.md`](GRAMMAR.md) section 6.

## Not established here

Recognition has not been tested with people, and no design owner has signed off. Passing the geometry checks is not either of those. Out of scope: public publication of this directory, concepts beyond the shared inventory, and the legacy fillet proposal.
