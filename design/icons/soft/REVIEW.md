# Soft pack — self-review (grammar + adversarial pass)

Against [`GRAMMAR.md`](GRAMMAR.md) and the local adversarial review of the first calibration prototype.

This is a **code + grammar review of the 12-icon pack**, not a user-recognition study and not a merge/public-release decision.

## Verdict

**PROMOTE TO NEXT REVIEW** — credible enough for formal pack-candidate / organizational visual review. Not a merge. Not a public release. Not a claim that Rounded is settled.

The first adversarial pass was **ITERATE LOCALLY**. This pass wired object radii to the declared Soft band, settled the five hotspots with drawings or explicit notes, trimmed dead contracts, and made the curve story match the files.

## Spec vs drawings

| Clause | Verdict |
|---|---|
| Soft intent; not an Angular replacement | Met. Circles/stadiums as key shapes (search, user, sliders, branch, plus). |
| Object corners in the Soft band (~1.6–1.7× outline), not Rounded’s 0.5–1× | Met. `CORNER_TOKEN` 1.6 / 2.4 / 3.4 is imported and used on home body, file page, calendar, user shoulders, warning triangle. |
| Acute cues stay round, may be smaller | Met. `ACUTE_JOIN` 1.0 / 1.5 / 2.0 on home roof. |
| Star mass vs Rounded collapse | **Documented exception.** `STAR_JOIN` 0.65 / 0.85 / 1.0 (~0.5× outline). 1.0×+ join on this silhouette collapsed mass ~30% vs Angular and clustered the points. Round points/notches remain; this is not a fillet on an Angular star skeleton. |
| Round terminals | Met. Plus taper is tested. |
| Shared weight/padding tokens | Met. |
| Search = circle | Met. Compactness > 0.92 tested. |
| Optical simplification 12→16→24 | Met. File bar at 24 only; calendar 1 mark at 12. |
| Silhouette vs weight; holes on search/link | Met. Bound 0.05 px. |
| Fail-closed lookup | Met. |
| Warning visible-label, concept-level | Met. Not weakened to make gaps pass. All 6 cells still miss gap targets and stay excepted. |
| Product path commands | **Honest.** 72 files are `M L Z` only. Catalog/styles/README state that flattening is the product representation. Validator still accepts `C Q A`. `circle_arc_path` was removed rather than overclaiming native-arc export. |
| Angular freeze | Met. 288 hashes unchanged. |
| Not a cosmetic Angular filter | Met. `draw.py` does not import Angular. All 72 path `d` strings differ. |

## Five hotspots

| Hotspot | Before | After |
|---|---|---|
| 12 px filled Link peanut/heart | Overlapping heavy stadiums; holes collapsed toward a peanut. | Diagonal interlocking **circular rings**. Holes stay open. Native 1× filled 12 can still compact; catalog requires a visible label at 12. Motif remains chain-rings, not Angular brackets — family decision, not hidden. |
| 16 px Home doorway dominance | Door filled the body; outline read as an arch. | Narrower, lower door (`7.05–8.95` × starting `11.7`). Roof still uses `ACUTE_JOIN`; body uses `CORNER_TOKEN`. House reads first. |
| 12 px File weak fold | ~1.05× corners; fold disappeared into a rounded rect. | Moderate dog-ear + `CORNER_TOKEN` page corners + outline crease along the fold. Filled has no crease (a slit read as damage). |
| Star optical mass ~30% light vs Angular | Filled 24 area/canvas ≈ 0.19 vs Angular ≈ 0.28. | Filled 24 ≈ 0.27 of canvas, ≥ 0.85× Angular area. Join is the documented `STAR_JOIN` exception. |
| 12 px filled Arrow bluntness | Tip sliver ~1.5 on a 2.0 stem; direction weak. | Longer chevron (`10.7` tip). Round join still truncates the point; direction reads. Remaining softness is the Soft diagonal language, not an unrecorded miss. |

## Dead contracts trimmed

- `CORNER_TOKEN` is wired into drawers (no longer a dead seam name).
- `tests/geometry/paths.py` Middle Man is gone.
- `circle_arc_path` is gone; products do not claim `A`/`C`/`Q`.
- Inventory CSV remains as a generated listing (low cost, produced by build).

## Tests

`python tools/run_checks.py` — 19 methods, OK.

| Seam | Result |
|---|---|
| 12 IDs / 72 SVGs / Soft-only availability | pass |
| No silent pack/size/appearance fallback | pass |
| Warning visible-label hashes bound | pass |
| Round plus terminals | pass |
| Circular search lens | pass |
| Not Angular path copies; draw isolation | pass |
| Silhouette bounds 0.05; weight holes kept | pass |
| `CORNER_TOKEN` / `STAR_JOIN` wired | pass |
| Star mass vs Angular | pass |
| Products `M L Z` only | pass |
| Angular 288 SHA-256 freeze | pass |
| Deterministic rebuild | pass |
| SVG safety / currentColor / native rasters | pass |
| Curve-aware parser accepts `A`/`C`/`Q`; rejects `H`/`V`/script | pass |

## Remaining design questions (human agency)

1. Soft Link motif is interlocking rings; Angular is brackets. Same concept, different metaphor. Family should accept or reject that reconstruction.
2. Native 12 filled Link can still compact; labeled use at 12 is the recorded mitigation. A later pass could try a different 12 construction.
3. `STAR_JOIN` (~0.5×) sits in Rounded’s numeric band. The exception is written so Soft does not accidentally occupy Rounded’s *skeleton+fillet* niche. Rounded is still undrawn.
4. Whether a later pack should emit native `A` for pure circles/stadiums. This pack will not claim that until products contain those commands.
5. Independent design sign-off and recognition study are not done.

## Architecture notes

Kept: `seams.py`, `lookup.py`, `draw.py` + `primitives.py`, pack-specific `validate.py`, catalog/proof HTML+PNG. Depth stays in the drawings. No parametric icon DSL.
