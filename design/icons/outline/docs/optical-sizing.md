# Optical sizing

| Display size | Master | Interpretation |
|---:|---:|---|
| 12 | 12 | Native micro drawing; prefer visible labels |
| 14 | 16 | Scaled compact drawing |
| 16 | 16 | Native compact drawing |
| 20 | 24 | Scaled regular drawing |
| 24 | 24 | Native regular drawing |
| 32 | 24 | Enlarged regular drawing |

The helper supports finite positive display sizes up to 1024 px, but only the listed display sizes are reviewed in the guide. Below 12 px is not reviewed. Other sizes use the stated size-selection rule and may soften pixel alignment. An explicit `master` override must be one of 12/16/24.

Do not claim every master has entirely unrelated paths. Directional arrows and chevrons deliberately share per-size centerlines through exact rotations, with the 12 px outline nudge described below. Object detail, spacing, and contour widths are authored for the native sizes. A separate master is not a promise that each outline has the same apparent weight as a filled object.

## Odd-width and grid policy

A stroke with an odd pixel width cannot be both centered and crisp on an even canvas. The rule is the same for every master; these are the cases it produces:

- **1 px strokes sit on the pixel left of or above center.** At 12 px, straight shafts, bars and punctuation use column or row 5-6, so they render at full strength rather than as two half-strength lines. This is why Plus, Minus, Menu, More, Branch, Chart, Download, Upload, the arrows and Warning's mark share center 5.5. Warning's 1 px mark at 16 px uses column 7-8 for the same reason. A row of arrows shares one pixel line: left and down are rotated and then nudged, because a pure rotation would land them on 6-7.
- **16 px objects and repeated bars sit on the half-pixel grid.** A 1.5 px contour cannot be crisp on both edges at 1×, but on this grid one edge is crisp at 1× and both are crisp at 2×. Scaling the 24 px drawing would leave edges on thirds, which are never crisp at 1× or 2×. Repeated bars and dots also share one pixel phase, so they render at equal weight.
- **A single symmetric 1.5 px stem at 16 px stays centered at ±0.25.** This covers stems such as Plus, Minus, the arrow shafts, Sliders rails, and Info and Help marks. Two 75% lines are softer than a half-pixel stem; this is an accepted tradeoff, because moving one stem off center would skew the head or crossing built around it.
- **Diagonals are not snapped.** Only axis-aligned edges carry this rule. Diagonal vertices keep their angle, and pixel softness on a diagonal is not a defect.

The product concepts follow the same rule. At 12 px, Type, Sun, Dot and Box are built on the 5.5 center, so their single strokes render at full strength. Align and Table use whole-pixel rows. Each size also carries detail decisions: Layers has two lower sheets only at 24 px, Align has a fourth row only at 24 px, and Wand has no accent marks at 12 px, one at 16 px, and two at 24 px.

Pixel snapshots detect regression. Optical review compares recognition cues, meaningful negative space, local line widths, silhouette density, centering, and edge pressure in context. Painted area and centroids are diagnostics, not quality scores or automatic centering instructions.
