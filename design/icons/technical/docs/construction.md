# Vector UI — Technical grammar (calibration spec)

**Status:** local calibration spec · not a public style pack · 25 September 2026
**Scope:** 12-icon pilot only (`home`, `search`, `plus`, `arrow-right`, `user`, `file`, `calendar`, `sliders`, `warning`, `link`, `branch`, `star`)
**Location:** this file is the written grammar. Implementation lives in this package (`design/icons/technical/`). Do not edit Angular geometry. Not a public catalog.

This document is written **before drawing**. Artwork that disagrees with it is a spec bug or a recorded exception. It is not an automatic transform of Angular paths, and it is not a renamed Angular pack.

---

## 1. Visual intent and target product contexts

Technical is the **instrument / CAD / console** grammar of Vector UI.

It should read as machined plates, orthogonal pipes, and 45° chamfers: the marks you would cut on a panel, not the marks you would draw with a round nib. Target contexts, when a product actually needs this voice:

- developer tools, IDEs, and workflow consoles
- data platforms, observability, and industrial readouts
- settings and inspector chrome where precision matters more than friendliness

It is **not** the default product UI voice. Angular remains the existing interface family. Technical is an alternate pack with the same semantic IDs.

Calibration question this pilot answers: can twelve diverse concepts (open actions, objects, dense controls, status, diagonal metaphors) be drawn in this grammar at native 12 / 16 / 24 without copying Angular geometry?

---

## 2. Shared family contract (unchanged)

Technical must honor the Vector UI contract already proven on Angular:

| Dimension | Rule |
|---|---|
| Canonical IDs | Same twelve IDs and meanings as Angular. No aliases in this pilot. |
| Appearances | `outline` and `filled` for every ID. |
| Optical masters | Native drawings at 12, 16, and 24 px. Display 14 uses 16; 20 and 32 use 24. No master is a scaled copy of another. |
| Color | `currentColor` only. No baked fills, no multi-color. |
| Warning | Visible-label restriction remains **concept-level** for every appearance and master, including scaled uses. Geometry improvements do not lift the restriction. |
| Fail closed | Unknown pack, ID, appearance, or master raises. No silent fallback to Angular, to another size, or to a substitute metaphor. |
| Angular lock | Angular SVG bytes are read-only. This pilot must not edit them. |

Pair models stay with the concept, not the pack:

| ID | Pair model | Meaning (Angular, retained) |
|---|---|---|
| `home` | silhouette | Home or top-level destination. Not Back. |
| `search` | weight | Find content. Lens stays open in both weights. |
| `plus` | weight | Add or create. Not expand / zoom-in. |
| `arrow-right` | weight | Literal right arrow. App chooses direction. |
| `user` | silhouette | A person or profile. |
| `file` | silhouette | A document. Not a duplicate action. |
| `calendar` | silhouette | A date or calendar. |
| `sliders` | silhouette | Adjust parameters. Not filter or gear. |
| `warning` | silhouette | Warning. Visible text label required. |
| `link` | weight | A link or related resource. Loops stay open. |
| `branch` | silhouette | A branching relationship. Label at small sizes. |
| `star` | silhouette | Favorite or rating. Distinct from Focus. |

`silhouette`: matched outer bounds; filled is the solid counterpart; holes that are part of the metaphor stay holes.
`weight`: open glyph; filled means the heavier token, never a hollow contour filled in.

---

## 3. Grid, orthogonal, and chamfer policy

Construction grid is the native canvas. Author on **0.5 px** at 12 and 16, **0.5 px** at 24 (integer preferred). Do not introduce 0.25 px construction points.

**Orthogonal first.** Primary structure is horizontal and vertical: plates, pipes, rails, tabs, stems, doors, nodes.

**Default plate corner is a 45° chamfer**, not a sharp 90° and not a radius.

| Native canvas | Outline weight | Open-glyph heavy | Chamfer cut | Padding / gap target |
|---:|---:|---:|---:|---:|
| 12 | 1 | 2 | 1 | 1 |
| 16 | 1.5 | 2.5 | 1.5 | 1.5 |
| 24 | 2 | 3 | 2 | 2 |

Chamfer cut equals outline weight. A chamfer that would collapse a part below one contour width is reduced or omitted for that part, and the omission is a recorded exception in `catalog/exceptions.json`. Declared defaults and part overrides must also appear in `catalog/styles.json` so catalog and construction cannot disagree. Dense 12 px slider knobs and branch nodes currently use cut `0.75` for that reason.

Sharp 90° corners are allowed only for:

- square-cut terminals of open bars (`plus`, arrow shaft, slider rails)
- interior marks that would become unreadable if chamfered (date cells, punctuation)
- the gable **peak** of `home` (recognition of “house”)

There is no round corner in this pack.

---

## 4. Terminal and joint language

**Terminals** of open strokes are **square cuts perpendicular to the stroke**. They are authored as rectangles (axis-aligned) or as direction-aligned bars (45°). They are not round caps and not pointed nibs.

**Joints** of orthogonal pipes are T or L unions. Inner corners of pipe joints stay square. Outer corners of **plates** take the chamfer.

**Mitre on 45°** bars: the end is square to the bar, which on a 45° bar is itself 45° to the canvas. That is correct Technical, not an Angular leftover.

Do not use Shapely round caps (`cap_style=1`) or round joins (`join_style=1`). If a boolean op introduces a near-touching hairline, rewrite the parts; do not leave a gap that will fill at raster size.

---

## 5. Contour / weight model

Expanded fills, not live SVG strokes. Final artwork is `fill="currentColor"` + `fill-rule="evenodd"` polygons.

- Outline objects: contour width = outline token; interior of the shell is a hole.
- Filled objects: solid plate minus metaphor holes (door, date cells, warning marks, node counters as specified).
- Open glyphs (`plus`, `arrow-right`, `search` handle, `link`): outline uses the outline token; filled uses the heavy token. Search lens and link loops remain unfilled in both appearances.

Weights are **not** scaled after expansion. A 12 px master is drawn at 12, not reduced from 24.

Technical uses the same numeric tokens as Angular (1 / 1.5 / 2 and 2 / 2.5 / 3) so the pack can sit in the same chrome. Difference is grammar, not a global hairline restyle.

---

## 6. Diagonal policy

Allowed non-axis angles:

| Angle | Where |
|---|---|
| **45° only** | Chamfers; `search` handle; `arrow-right` head; `home` roof planes; `file` dog-ear; `link` is **not** diagonal (axis-aligned shackles). |
| **Metaphor exception** | `warning` triangle sides (isosceles warning plate). Vertices still receive plate chamfers. |
| **Metaphor exception** | `star` five-point geometry (regular star, not an optically fudged Angular copy). |

Forbidden in this pack: arbitrary 20–40° “friendly” diagonals, circular approximations beyond the 45° octagon that a chamfered square already is, and any curve.

If a concept seems to need a circle (`search` lens, `user` head), draw a **chamfered square** (viewfinder / ID plate), not an octagon-from-circle.

---

## 7. Density and negative space

Prefer dropping a mark over crowding a mark.

| ID | 12 | 16 | 24 |
|---|---|---|---|
| `file` | fold only | fold only | fold + one content slot |
| `calendar` | two tabs + one date cell | two tabs + two cells | two tabs + header rail + two cells |
| `sliders` | two rows, smaller knobs | two rows | two rows, chamfered knobs, full pad |
| `user` | head + body, keep a gap | same | same, gap ≥ outline token |
| `branch` | three nodes, label required in UI | three nodes | three nodes, chamfered junction boxes |
| `warning` | chamfered plate + punctuation | same | same; do not add extra ticks |
| `star` | five points, no inner decoration | same | same |
| `home` | door kept (metaphor) | door | door |
| `search` | open lens + 45° handle | same | same |
| `link` | two open shackles + overlap | same | same |

Meaningful openings (lens, door, date cells, node counters, warning frame-to-mark) target 1 / 1.5 / 2 px. Hairline pockets from boolean residue are defects.

Dense symbols may occupy less than the full padded field (`sliders` may sit in a compact two-row stack). A canvas is not a painted box.

---

## 8. Filled vs outline pairing

- **Silhouette pair:** outer bounds match within 0.002 px. Filled area is greater than outline area. Metaphor holes remain holes (home door, calendar cells, warning punctuation, search is *not* silhouette).
- **Weight pair:** same centerline skeleton; filled is heavier. Bounds may grow. Do not outline a plus and then fill the plus as a boxed shape.
- Filled is not “color in every hole.” Search lens, link loops, and sliders’ rail gaps stay open.
- No third `shared` pair model in this pilot.

---

## 9. Optical-size simplification

Masters are independent drawings that share a skeleton.

- **12:** keep the metaphor, drop secondary interior marks, keep chamfer ≥ 1 if the part is large enough.
- **Odd-width centering (allowed policy, not an Angular copy):** a 1 px orthogonal bar on a 12 px even canvas cannot be both canvas-centered and integer-edged. Technical **keeps the canvas center**. A 1 px `plus` stem therefore occupies `5.5–6.5`, not Angular’s integer `5–6` split (center `5.5`, shifted off the canvas midpoint). Half-pixel edges here are the 1 px token plus centering, not a crispness fudge. Record the policy in `catalog/styles.json` so it cannot silently flip.
- **16:** intermediate; two calendar cells; no file content slot.
- **24:** full grammar, including file slot and calendar header rail.

Never generate 12 by scaling 24 expanded paths. Never generate 16 by averaging 12 and 24.

Reviewed display sizes remain 12 / 14 / 16 / 20 / 24 / 32 with the Angular master-selection rule. This pilot does not ship a web helper; the rule is documented so a future API cannot invent a fourth master.

---

## 10. How Technical differs visibly from Angular, Rounded, and Soft

These are **recognition tests**, not marketing copy. A reviewer should tell the packs apart at 24 px outline without reading labels.

| | Angular (exists) | Technical (this spec) | Rounded (not drawn) | Soft (not drawn) |
|---|---|---|---|---|
| Corners | Sharp, or *ad hoc* chamfer / octagon | **Systematic 45° plate chamfer** | Curve radius | Larger, friendlier radius |
| Terminals | Square from stroke buffer | Square-cut bars; plates chamfered | Round caps | Pill caps |
| Circles | Octagon approximating a circle (`search`, `user`) | Chamfered **square** viewfinder / ID plate | True curves | True curves, lighter |
| Structure | Mixed diagonals, some optical offsets | Orthogonal pipes + 45° only | Same skeletons, round joins | Looser, more organic |
| Objects | UI-friendly houses, docs, stars | Machined plates, dog-ear fold, junction boxes | Same objects, round | Same objects, soft |
| Curves | None (M/L/Z) | None (M/L/Z) | Required | Required |
| Personality | Product UI | Instrument / CAD | Friendly UI | Soft / consumer |

Concrete anti-copies for this pilot:

- `search` is a **viewfinder square**, not Angular’s circular octagon.
- `user` is a **chamfered ID plate + torso**, not Angular’s circular-octagon head.
- `home` uses **45° roof planes** on a chamfered body; peak stays sharp.
- `file` uses a **large 45° dog-ear** plus three small plate chamfers, not a single clipped corner on an otherwise sharp sheet.
- `arrow-right` head is a **45° chevron of two bars**, not a stretched polyline.
- `link` is two **axis-aligned chamfered shackles**, not U-shaped chain ends.
- `star` is a **regular five-point star** (CAD-regular), not Angular’s optically tuned coordinates.
- `warning` is a **chamfered caution plate**, not a sharp yield triangle.
- `plus` is inset to a tighter keyline than Angular’s pad-to-pad cross. At 12 px outline it stays canvas-centered (half-pixel edges); it does not use Angular’s integer `5–6` stem split.
- `sliders` knobs are **chamfered plates** on orthogonal rails, full padded width at 24.
- `branch` nodes are **chamfered junction boxes**.
- `calendar` keeps a **header rail** at 24 (Angular removed it).

If a Technical drawing’s path `d` equals the Angular `d` for the same ID/appearance/master, the drawing has failed this spec.

---

## 11. Accessibility assumptions that belong to components, not glyph geometry

Icons do not provide the accessible name, the visible warning label, contrast against arbitrary product surfaces, RTL flipping, or 44 px hit targets.

Component rules (same as Angular; not solved by redrawing):

- Label the control. Hide decorative inline SVG (`aria-hidden="true"`). Do not double-name icon + button.
- `warning` requires a **visible** text label at every master and scaled use. A tooltip or `aria-label` is not a substitute.
- `branch` should be labeled at 12 px; prefer 16+ for actions.
- Color is not meaning. Status uses label + shape.
- Literal arrows do not auto-mirror in RTL; the app selects `arrow-left` / `arrow-right` when those IDs exist. This pilot only draws `arrow-right`.
- `currentColor` inherits from the control. Forced-colors and contrast are component/theme problems.
- This spec is not a WCAG certification, screen-reader study, or recognition study.

---

## 12. Allowed SVG / path primitives and validator implications

**Sufficient primitives: `M` / `L` / `Z` only.**

Why curves are not needed: Technical structure is axis-aligned plates, square-cut bars, and 45° chamfers. All of those are straight-edged polygons. A chamfered rectangle is an octagon. A 45° bar is a rectangle rotated in coordinate space, still `L` segments. Star and warning are straight-sided polygons.

Validator implications:

- Fail closed on `C`, `Q`, `A`, `S`, `T`, `H`, `V` (compact), lowercase relative commands, and any non-`[MLZ0-9.\-\s]` content.
- Do **not** add curve support in this pilot “for completeness.” Rounded/Soft will need a curve-aware parser later; grafting it on now would let invalid Technical sneak through as ignored commands.
- Independent XML parse of serialized SVG: exact `svg > title + path`, `fill="currentColor"`, `fill-rule="evenodd"`, native `width`/`height`/`viewBox`, no event handlers, no images, no doctype/entities.
- Geometry must be finite, non-empty, valid, and inside the canvas.
- No additional path commands are introduced. If a future icon genuinely needs a curve, that is a Rounded/Soft problem or a spec revision — not a silent parser relaxation.

---

## 13. Module seams (Matt Pocock: define before implementing)

Test these seams. Do not test private vertex lists.

| Seam | Module | Contract |
|---|---|---|
| Identity | `source/contract.py` | Frozen 12 IDs, appearances, masters, pair models, meanings. |
| Resolve | `contract.resolve(pack, id, appearance, master)` | Returns a drawing key or raises `UnavailablePack`, `UnknownIcon`, `UnavailableAppearance`, `UnavailableMaster`. Never returns Angular. |
| Tokens | `source/grammar.py` | `tokens(n) -> {weight outline/heavy, chamfer, pad, gap}` |
| Primitives | `source/grammar.py` | `plate`, `bar`, `ring`, `chamfer_polygon` — unit-tested for 8-vertex plates and 45° edges. |
| Draw | `source/icons.py` | `draw(id, n, appearance) -> shapely geometry` |
| Export | `source/export.py` | `path_data`, `svg_text`, `parse_path`, `parse_svg` |
| Build | `source/build.py` | Writes 72 SVGs + registry/inventory/proof. Deterministic. |
| Angular lock | tests | SHA-256 of `design/icons/angular/generated/angular/**` matches committed inventory. |

Implementation details (Shapely boolean order, helper names) are not the spec.

---

## 14. Pilot delivery and non-goals

Delivered in `.context/style-pack-work/technical-pilot/`:

- construction source of truth
- 72 generated SVGs (12 × 2 × 3)
- catalog metadata, restrictions, exceptions
- review catalog / proof page
- seam tests, rebuild, SVG safety, optical matrix, Angular hash lock, native rasters

Not in this pass:

- public catalog or API promotion
- Rounded or Soft drawings
- Core 120 expansion
- editing PR #244 / Angular geometry
- web helper package, sprites for production, npm publish

---

## 15. Open design questions (do not fake answers)

1. Is a chamfered-square lens still recognizable as Search next to a view/crop tool? Needs a recognition pass.
2. Does a regular (not optically shifted) star feel too “sheriff/CAD” for Favorite?
3. Should Technical `plus` stay on the same outer keyline as Angular for toolbar alignment, or keep the tighter inset?
4. If warning punctuation meets the gap target, do we still keep the concept-level visible-label rule? **This spec says yes** until a recognition study says otherwise.
5. Is 45°-only too rigid for a later 120-icon set (e.g. refresh, chat tail)?
6. Independent design owner/reviewer: unset.

Record spacing/recognition exceptions in `catalog/exceptions.json` after measurement, not before.
