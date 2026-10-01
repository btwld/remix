# Contributing

This repository is a private pilot. Do not publish a new license or accept public third-party artwork without the owner's decision.

## Propose a concept

State the unmet interface need, literal glyph name, control action, nearest confusions, category, and expected sizes. Search existing keywords before adding an ID. A new function does not necessarily need a new drawing.

## Draw

Author native geometry in `source/angular/additions.py` or a new construction module. Reuse final-width primitives, not stretched expanded SVGs. Do not trace a reference library and call the result original. Record any externally reused material and its terms before importing it.

Every promised concept has outline / filled at 12 / 16 / 24 px. Open glyphs may use a regular/heavier pair. Do not produce micro versions only by scaling 24 px output. Directional copies may share native geometry through exact rotation/reflection.

Do not edit `generated/`, the registry, sprites, helper path data, or catalog HTML by hand. Change the authoritative construction or catalog and rebuild. Existing baseline paths are locked; a deliberate baseline change needs a separate migration decision and updated evidence, not an unexplained hash refresh.

## Validate

1. Run `python source/build.py` and `python tools/run_checks.py`.
2. Run full browser tests where available. Report unsupported contexts, not a substitute full pass.
3. Inspect 12/16/24 native renderings on light/dark surfaces at 1× and 2×. Then examine magnified geometry.
4. Compare the new symbol with its closest family neighbors in equal-size controls and test outline/filled placement.
5. Review changed snapshots before proposing new baselines. Never update them automatically in CI.
6. Supply a per-icon decision and any scoped exception. Measurements are not design scores.

Review small batches of 6–12 concepts. Keep generated edits and metadata in the same pull request. Reject silent fallback for missing pack, appearance, size, or glyph.

## Approval

Technical checks, optical approval, and recognition findings are separate. The author must not be represented as an independent reviewer. A public release also needs the distribution license, provenance, browser evidence, and named maintainers. See `docs/release-checklist.md`.
