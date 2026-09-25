# Angular construction contract

The visual direction remains the supplied angular interface family: flat expanded paths, square terminals, sharp or deliberately chamfered corners, restrained detail, and editable `currentColor` artwork. The build is geometry-driven, not generated-image crops.

| Native canvas | Nominal outline | Open-glyph heavier token | Meaningful gap target |
|---|---:|---:|---:|
| 12 × 12 | 1 px | 2 px | 1 px |
| 16 × 16 | 1.5 px | 2.5 px | 1.5 px |
| 24 × 24 | 2 px | 3 px | 2 px |

These are project rules, not universal design standards. Baseline glyphs include documented optical exceptions and object-specific weights. Gear's teeth are filled projections around a nominal-width root contour. Internal punctuation can have a native optical specification.

A canvas is not a compulsory painted box. Key shapes guide proportions; dense symbols can occupy less space. Sliders retains its locked two-row, 18 × 16 px field at 24 px. Gear is separate artwork, not a renamed Sliders.

`pairModel: silhouette` uses matched outer bounds and a deliberate object counterpart. `pairModel: weight` uses regular/heavier open glyphs. Keep appearance changes inside fixed component controls. Filled does not mean filling every hole.

The gap rule concerns meaningful openings or separated parts, not every tapered corner. A geometric minimum over every edge pair is not a reliable universal acceptance measure. Info and Help have authored frame/punctuation regions; their 12/16/24 frame clearances meet 1/1.5/2 px respectively. Warning remains an explicit inherited exception.

Only M/L/Z expanded polygons are supported by the Angular parser. It rejects curves rather than silently ignoring them. Rounded requires a curve-aware bounds and measurement implementation or tested flattening with a declared tolerance before any Rounded release.

## Scope heuristic

80/20 is a proposed workflow-coverage target, not a rule that every icon occupies 80% of a canvas or receives 20% arbitrary deviation. Measure it against actual target screens before claiming coverage.

## Rationale sources

IBM's grid/key-shape guidance supports consistent proportions with fine optical adjustment and warns against crowded elements. Its exact 32 px construction specification is not copied into this 24 px project. See `SOURCES.md`.
