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

Do not claim every master has entirely unrelated paths. Directional arrows and chevrons deliberately share per-size centerlines through exact rotations. Object detail, spacing, and contour widths are authored for the native sizes. A separate master is not a promise that each outline has the same apparent weight as a filled object.

Pixel snapshots detect regression. Optical review compares recognition cues, meaningful negative space, local line widths, silhouette density, centering, and edge pressure in context. Painted area and centroids are diagnostics, not quality scores or automatic centering instructions.
