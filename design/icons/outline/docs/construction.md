# Outline construction contract

The visual direction remains the supplied outline interface family: flat expanded paths, square terminals, sharp or deliberately chamfered corners, restrained detail, and editable `currentColor` artwork. The build is geometry-driven, not generated-image crops.

| Native canvas | Nominal outline | Open-glyph heavier token | Meaningful gap target |
|---|---:|---:|---:|
| 12 × 12 | 1 px | 2 px | 1 px |
| 16 × 16 | 1.5 px | 2.5 px | 1.5 px |
| 24 × 24 | 2 px | 3 px | 2 px |

These are project rules, not universal design standards. Baseline glyphs include documented optical exceptions and object-specific weights. Gear's teeth are filled projections around a nominal-width root contour. Internal punctuation can have a native optical specification.

A canvas is not a compulsory painted box. Key shapes guide proportions; dense symbols can occupy less space. Sliders retains its locked two-row, 18 × 16 px field at 24 px. Gear is separate artwork, not a renamed Sliders.

`pairModel: silhouette` uses matched outer bounds and a deliberate object counterpart. `pairModel: weight` uses regular/heavier open glyphs. Keep appearance changes inside fixed component controls. Filled does not mean filling every hole.

The gap rule concerns meaningful openings or separated parts, not every tapered corner. A geometric minimum over every edge pair is not a reliable universal acceptance measure. Info and Help have authored frame/punctuation regions; their 12/16/24 frame clearances meet 1/1.5/2 px respectively.

## Warning gap contract

`warning_parts()` in `source/outline/baseline.py` is the inspectable frame and punctuation. `tests/test_shape_corrections.py` measures the exported paths against these targets, and `catalog/exceptions.json` records the results.

| Measure | Target 12 / 16 / 24 | Measured 12 / 16 / 24 |
|---|---:|---:|
| Outline mark to frame | 1 / 1.5 / 2 | 1 / 1.5 / 2 |
| Outline stem to dot | 1 / 1.5 / 2 | 1 / **1** / 2 |
| Filled punctuation width | 1 / 1.5 / 2 | 1 / 1.5 / 2 |
| Filled stem to dot | 1 / 1.5 / 2 | 1 / 1.5 / 2 |

The 16 px outline stem-to-dot gap is a recorded exception: a 1.5 px gap would leave a stem no taller than its dot. To make this room the triangle overshoots the normal padding: a triangle covers far less of its box than a square does. Its painted bounds reach the canvas top and left at 12 px and the left at 16 px. Meeting these numbers does not remove the visible-label rule in `catalog/restrictions.json`, and it says nothing about recognition.

## Recorded drawing decisions

These are 2026-11-01 local design judgments between prototypes compared at native size. None is a recognition result.

- **Link:** two open hooks on one 45° axis, each returning into the other's mouth. Closed interlocked rings read literally at 24 px but filled in at 12 px, and a staggered horizontal pair read as an S. Open strokes keep one topology at every master and no counter that can vanish. Filled 24 px uses the heavier 3 px token because 2.5 px barely separated it from the 2 px outline; its two ends are drawn back 0.35 px to hold the 2 px hook gap. Filled 12/16 px stay at 1.5/2 px.
- **Calendar:** a header rail at contour weight, with one off-center date at 16/24 px. Two date marks read as eyes under the bindings. The 12 px master keeps only the frame, bindings and rail. The cut corner is removed here because it competed with the rail; it stays on Copy, Lock, Folder and Trash.
- **Terminal:** a square window with an open prompt and a cursor at every master, so the frame does not repeat File's clipped corner and the prompt does not close into a play triangle.
- **File:** two unequal left-aligned lines at 24 px, because a single centered bar has the form of a file-minus. 12/16 px stay plain.

Only M/L/Z expanded polygons are supported by the Outline parser. It rejects curves rather than silently ignoring them. legacy fillet proposal requires a curve-aware bounds and measurement implementation or tested flattening with a declared tolerance before any legacy fillet proposal release.

## Scope heuristic

80/20 is a proposed workflow-coverage target, not a rule that every icon occupies 80% of a canvas or receives 20% arbitrary deviation. Measure it against actual target screens before claiming coverage.

## Rationale sources

IBM's grid/key-shape guidance supports consistent proportions with fine optical adjustment and warns against crowded elements. Its exact 32 px construction specification is not copied into this 24 px project. See `SOURCES.md`.
