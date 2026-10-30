# Vector UI — Soft style pack grammar

**Status:** local calibration spec for a 12-icon pilot. Not a public pack, not a Rounded spec, and not a change to Angular.

**Pilot location:** `design/icons/soft/`

**Shared family:** Vector UI. Soft reuses Angular’s canonical IDs and meanings. It does not reuse Angular path geometry, does not round Angular polygons as a post-process, and does not silently substitute Angular (or Rounded) artwork when a Soft drawing is missing.

This document is the style contract the pilot implements against. Construction, validation, and review bind to these rules.

---

## 1. Visual intent and where Soft is appropriate

Soft is the **human-facing** Vector UI grammar: continuous curvature, capsule terminals, circular nodes, and slightly more open counters. It should feel calm and approachable on consumer, onboarding, content, and settings surfaces where a sharp engineering tool language would be too severe.

Soft is **not** a general replacement for Angular. Use Angular on dense production/admin surfaces, data tables, and developer tools where crisp square terminals and chamfers aid alignment at 12 px. Soft is **not** decorative illustration: it remains a 12/16/24 px UI icon family with the same semantic IDs, two appearances, `currentColor`, and no ornamental cuts.

Calibration set (12 IDs, chosen to stress the grammar):

| ID | Why it is in the set |
|---|---|
| `home` | Closed silhouette, roof junction, doorway counter |
| `search` | Open weight pair, circular lens vs Angular octagon |
| `plus` | Open crossing stems, terminal language |
| `arrow-right` | Diagonal + direction cue |
| `user` | Circular head vs Angular octagon, shoulder curve |
| `file` | Soft page + folded corner without a sharp clip |
| `calendar` | Dense object, tabs, date marks, optical simplification |
| `sliders` | Circular knobs vs Angular squares, two-row density |
| `warning` | Acute figure, punctuation, visible-label restriction |
| `link` | Open overlapping loops; do not fill the holes |
| `branch` | Topology, circular nodes, small-size recognition |
| `star` | Concave/convex corners, silhouette pair, blob risk |

---

## 2. Corner / curve language

| Token | Soft | Angular (locked) | Planned Rounded |
|---|---|---|---|
| Object outer corners | `CORNER_TOKEN` 1.6 / 2.4 / 3.4 px at 12 / 16 / 24 (≈ **1.6–1.7×** outline). Large enough to change the silhouette. Wired into home body, file page, calendar, user shoulders, warning triangle. | Sharp, or a deliberate chamfer | Circular fillet on an otherwise Angular skeleton; radius ≈ 0.5–1× outline; topology unchanged |
| Acute cues (roof peak, file dog-ear, warning apex) | Still **round**, never chamfered. `ACUTE_JOIN` ≥ **1.0×** outline (1.0 / 1.5 / 2.0). May sit below `CORNER_TOKEN` so the cue does not blob. This is a Soft hierarchy, not Rounded. | Sharp / chamfer | Fillet on Angular vertices |
| Pointed silhouette (star) | **Exception:** `STAR_JOIN` 0.65 / 0.85 / 1.0 (≈ **0.5×** outline). 1.0×+ join on a five-point star collapses optical mass (~30% light vs Angular) and turns the glyph into a flower. Round points and round notches remain; the smaller join is so the star still reads as a star on mixed-pack screens. Documented, not Rounded (Rounded would fillet an Angular star skeleton). | Sharp points | Fillet on Angular star vertices |
| Capsule objects | Stadiums and circles are legal key shapes | Octagons, boxes, cut-boxes | Unlikely as a default key shape |

A rounded rectangle in Soft is a **key shape**, not a softened box. If reducing an *object* corner would restore an Angular reading, the radius is too small.

Do not author chamfers in Soft. Do not take an Angular polygon and run `buffer(+r).buffer(-r)` on it as a pack generator. Each Soft icon is constructed from Soft primitives.

Rounded, when drawn, must still read as Angular-with-fillets. Soft object corners occupy the 1.6–1.7× band so that pack cannot collapse into Rounded’s 0.5–1× band.

---

## 3. Terminal language

Open-glyph ends are **round caps** (full semicircles with radius = stroke/2).

- Plus, arrows, link strokes, search handles, and branch connectors terminate in capsules.
- Square caps are Angular. Soft does not use them.
- Pointed arrow tips in Soft are round-joined polylines: the tip is a circular arc of radius stroke/2, not a mitre and not a square cut. Direction must still read; if a blunt tip fails at 12 px, lengthen the head or simplify, do not switch to a square cap.

---

## 4. Contour / weight model

Nominal contour widths match Angular so mixed-pack screens stay optically compatible. The *model* is different: round joins and caps, circular nodes, stadium rails.

| Native canvas | Outline | Open-glyph filled (weight pair) | Meaningful gap target |
|---:|---:|---:|---:|
| 12 | 1.0 | 2.0 | 1.0 |
| 16 | 1.5 | 2.5 | 1.5 |
| 24 | 2.0 | 3.0 | 2.0 |

`pairModel: silhouette` — outline is a ring of the filled outer shape (same outer bounds). Filled does not fill recognition-critical holes (door, date marks, warning punctuation).

`pairModel: weight` — the same centerline, heavier capsule. Search and link keep transparent lenses/loops in both appearances. Plus and arrow-right are solid capsules in both appearances; “filled” means heavier, not hollow.

Padding / keyline: 1 / 1.5 / 2 px matching Angular. Soft round caps may optically undershoot a square-cap neighbor; that is expected, not a license to thicken past the token.

---

## 5. Diagonal treatment

Diagonals are **round-capped, round-joined** strokes or rotated stadiums.

- Angular diagonals pick up mitre mass and square ends; Soft diagonals do not.
- Search handles, link loops, and arrow chevrons are the proof cases.
- Do not stair-step a diagonal into an octagon to fake a curve (that is Angular’s search lens). Soft search is a circle.

---

## 6. Density / negative-space behavior

Soft prefers **slightly larger counters** than Angular at the same size, because round joins eat corner interior.

- Meaningful openings should meet the gap target in the table above unless an exception is recorded.
- Do not crowd micro punctuation. Calendar keeps one date mark at 12 and two at 16/24. File keeps a content bar at 24 only.
- Dense compositions (sliders, calendar, warning, branch) occupy only the space they need; a canvas is not a compulsory painted box.
- Avoid sub-pixel holes. If a counter cannot stay ≥ ~0.9 / 1.35 / 1.8 px inscribed diameter at 12 / 16 / 24, remove it.

---

## 7. Filled vs outline pairing rules

| Model | Outline | Filled | Bound rule |
|---|---|---|---|
| `silhouette` | Ring (and positive marks) of the shared outer shape | Solid outer shape minus the same counters | Outer bounds match within 0.05 px |
| `weight` | Nominal capsule width | Heavier capsule on the same centerline | Filled area > outline area; bounds may grow with the heavier cap |

Filled is never “outline with the hole painted in” for search, link, or other hole-as-meaning glyphs.

Appearance is an explicit argument. There is no default of “if filled is missing, use outline.”

---

## 8. Optical-size simplification rules

Three **native masters**, not one drawing scaled. Reviewed display-size mapping (explicit, not a silent neighbor pick):

| Display px | Master |
|---:|---:|
| 12 | 12 |
| 14 | 16 |
| 16 | 16 |
| 20 | 24 |
| 24 | 24 |
| 32 | 24 |

Any other size, any missing master, and any other pack raises. Soft must not fall back to Angular or to another Soft size.

Simplification, 12 → 16 → 24:

- **12:** drop internal content marks (file bar); one calendar mark; larger relative counters; fewer nodes on connectors; prefer labels on `warning` and `branch`.
- **16:** compact; two calendar marks; still no file content bar.
- **24:** full grammar, including file content bar and roomier punctuation.

Do not claim the three masters have unrelated metaphors. They share topology; spacing, radius, and marks are authored per size.

---

## 9. How Soft differs from Angular and from planned Rounded

```text
Angular   square caps, sharp/chamfer corners, octagons & cut-boxes, M/L/Z only
Rounded   (planned) Angular skeletons + circular fillets; same topology; curve-aware
Soft      capsule terminals, circular nodes, stadiums as key shapes,
          continuous curvature large enough to change the silhouette,
          constructed from Soft primitives, never a filter on Angular paths
```

Concrete tells in this pilot:

- Search lens is a **circle**, not an octagon.
- Slider knobs and branch/user heads are **circles**, not boxes/octagons.
- Plus/arrow terminals are **round**, not square.
- File/calendar/home/warning outer corners are **radiused key shapes**, not chamfers.
- Star points and inner notches are **round-joined**. Join radius is the `STAR_JOIN` exception (~0.5× outline) so mass tracks Angular; this is not a Rounded fillet on an Angular star.

Rounded, when drawn later, should still be recognizable as Angular with fillets. Soft should not. If a Soft icon is mistaken for “Angular with border-radius,” the construction failed the grammar.

---

## 10. Accessibility / contrast assumptions that belong to UI, not glyph geometry

These rules are **interface contracts**. Passing geometry tests is not a WCAG audit.

- Enclosing controls supply the accessible name. Standalone SVGs may carry a `<title>`; in a named button the inner SVG is `aria-hidden`.
- Warning requires a **visible text label** at every appearance and native master, including scaled uses of those masters. A tooltip or `aria-label` is not a substitute. This restriction is concept-level (same meaning as Angular) and is bound to Soft artwork hashes after the pilot build.
- Branch should keep a visible label at 12 px (usage note, not the same restriction record as Warning).
- Contrast, focus rings, 44 px targets, forced-colors, and RTL mirroring policy live in the product UI. Glyphs use `currentColor` and do not encode state color. Literal arrows do not auto-mirror.
- Non-text contrast of the icon against its surface is the app’s job. Soft does not paint a background chip.

---

## 11. Allowed SVG / path primitives and validator implications

### Construction primitives (source of truth)

Python geometry, not hand-edited SVG:

- `circle`, `ring` (circular)
- `stadium` / round-capped `line` (capsule)
- `rounded_rect` / `rounded_rect_ring`
- `round_join` polygon (star, house, warning) via round buffer, **authored in Soft coordinates**, not derived from Angular vertices
- Boolean union / difference / intersection
- Round cap `cap_style=round`, round join `join_style=round`

Stroke-as-attribute SVG is not used. Exports are expanded `fill="currentColor"` / `fill-rule="evenodd"` paths, same document shell as Angular, so both packs inline the same way.

### Serialized path commands (product)

**Product SVGs in this pilot are expanded `M L Z` polylines.** Soft is constructed with round caps/joins and circular nodes; Shapely boolean unions flatten those curves at `quad_segs=8` and a 0.0001 export grid. That flattening is the **shipping representation**, not a claim that Soft is an Angular-style sharp-polygon grammar.

Do not describe the 72 files as native-arc/`C` exports. They are not.

### Validator commands (construction / test infrastructure)

The parser **accepts** `M L C Q A Z` and **rejects** everything else. It flattens `C Q A` at declared sagitta 0.05 px so a future native-arc drawing, or a hand-edited curve, cannot be silently ignored. That is fail-closed measurement infrastructure. It is not product export.

Reject: `H V S T` shorthand, `script`, event handlers, `href`, images, filters, strokes, gradients, non-`currentColor` fills, entities/doctype.

### Curve-aware validation is required

Angular’s parser **rejects curves**. Soft **cannot** reuse it as the pack validator, even while this pilot’s products happen to serialize as `M L Z`.

Minimum trustworthy Soft validator:

1. XML: exact `svg > title + path` structure, SVG namespace, `currentColor`, `evenodd`, native square viewBox, no extra attributes or mixed content (same safety posture as Angular).
2. Path lexer: `M L C Q A Z` and finite numbers (products today use `M L Z` only).
3. Flatten `C Q A` to polylines with **declared sagitta/flatness 0.05 px**, then build Shapely polygons.
4. Validity, non-empty, bounds inside the native canvas.
5. Fail closed on unknown commands; do not ignore curves.

---

## 12. Shared family contract (must not break)

- Canonical IDs and meanings match Angular for the 12 pilot icons.
- Outline + filled; native 12 / 16 / 24 masters; 12 × 2 × 3 = **72** SVGs.
- `currentColor`.
- Warning visible-label restriction remains in force at the concept level.
- No silent fallback between packs or sizes.
- Angular bytes stay frozen. Soft construction must not import or rewrite Angular SVG geometry.

---

## 13. Out of scope for this pilot

- Public package publication, npm, or Remix catalog/web API
- Drawing the remaining 36 Angular IDs in Soft
- Drawing Rounded
- Editing, merging, or pushing PR #244 (this pack stacks on that branch; it must not merge first)
- User-recognition study, independent design sign-off, WCAG certification
