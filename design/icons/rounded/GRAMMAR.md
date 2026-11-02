# Vector UI — Rounded style pack grammar

**Status:** the style contract for the private Rounded source pack: 77 concepts, 462 native drawings. Not a public pack, not a legacy fillet proposal spec, and not a change to Outline.

**Location:** `design/icons/rounded/`

**Shared family:** Vector UI. Rounded shares canonical IDs, labels, and meanings with Outline. It does not reuse Outline path geometry, does not round Outline polygons as a post-process, and does not silently substitute Outline (or legacy fillet proposal) artwork when a Rounded drawing is missing.

Construction, validation, and review bind to these rules.

---

## 1. Visual intent and where Rounded is appropriate

Rounded is the **human-facing** Vector UI grammar: continuous curvature, capsule terminals, circular nodes, and slightly more open counters. It should feel calm and approachable on consumer, onboarding, content, and settings surfaces where a sharp engineering tool language would be too severe.

Rounded is **not** a general replacement for Outline. Use Outline on dense production/admin surfaces, data tables, and developer tools where crisp square terminals and chamfers aid alignment at 12 px. Rounded is **not** decorative illustration: it remains a 12/16/24 px UI icon family with the same semantic IDs, two appearances, `currentColor`, and no ornamental cuts.

Twelve calibration concepts set the grammar, chosen to stress it. Their 72 drawings are pinned byte for byte in `tests/fixtures/calibration-72-sha256.json`. The other 65 concepts are constructed from the same primitives and tokens, in `source/glyphs/`:

| ID | Why it is in the set |
|---|---|
| `home` | Closed silhouette, roof junction, doorway counter |
| `search` | Open weight pair, circular lens vs Outline octagon |
| `plus` | Open crossing stems, terminal language |
| `arrow-right` | Diagonal + direction cue |
| `user` | Circular head vs Outline octagon, shoulder curve |
| `file` | Portrait rounded page + turned-down corner without a sharp clip |
| `calendar` | Dense object, tabs, date marks, optical simplification |
| `sliders` | Circular knobs vs Outline squares, two-row density |
| `warning` | Acute figure, punctuation, visible-label restriction |
| `link` | Woven capsule rings on one axis; do not fill the counters |
| `branch` | Topology, circular nodes, small-size recognition |
| `star` | Concave/convex corners, silhouette pair, blob risk |

---

## 2. Corner / curve language

| Token | Rounded | Outline (locked) | Legacy fillet proposal |
|---|---|---|---|
| Object outer corners | `CORNER_TOKEN` 1.6 / 2.4 / 3.4 px at 12 / 16 / 24 (≈ **1.6–1.7×** outline). Large enough to change the silhouette. Used on the home feet, file page corners, and calendar body. | Sharp, or a deliberate chamfer | Circular fillet on an otherwise Outline skeleton; radius ≈ 0.5–1× outline; topology unchanged |
| Acute cues (roof peak, file dog-ear, warning apex) | Still **round**, never chamfered. `ACUTE_JOIN` 1.25 / 2.0 / 2.6 px (≈ **1.25–1.33×** outline), so a ring's inner contour keeps a visible radius too. Sits below `CORNER_TOKEN` so the cue does not blob. The apex stays on its keyline, because the corner circle sits on it. This is a Rounded hierarchy, distinct from the legacy fillet proposal. | Sharp / chamfer | Fillet on Outline vertices |
| Pointed silhouette (star) | **Exception:** `STAR_JOIN` 0.65 / 0.85 / 1.0 (≈ **0.5×** outline). 1.0×+ join on a five-point star collapses optical mass (~30% light vs Outline) and turns the glyph into a flower. Round points and round notches remain; the smaller join is so the star still reads as a star on mixed-pack screens. Documented, distinct from the legacy fillet proposal (the legacy fillet proposal would fillet an Outline star skeleton). | Sharp points | Fillet on Outline star vertices |
| Cut terminals (fold slit, header rail, door jambs, link weave) | `CUT_JOIN` 0.3 / 0.45 / 0.6 px (0.3× outline), so a boolean cut still ends round | Sharp | Not applicable |
| Capsule objects | Stadiums and circles are legal key shapes | Octagons, boxes, cut-boxes | Unlikely as a default key shape |

A rounded rectangle in Rounded is a **key shape**, not a softened box. If reducing an *object* corner would restore an Outline reading, the radius is too small.

Do not author chamfers in Rounded. Do not take an Outline polygon and run an offset on it as a pack generator. Each Rounded icon is constructed from Rounded primitives.

Passing a radius does not establish a corner. `buffer(+r).buffer(-r)` restores the original corner: that recipe left File, Home, and Warning almost sharp while passing `CORNER_TOKEN`. Key shapes are therefore authored as `rounded_hull` of their corner circles, and tests measure the radius on the exported path.

The legacy fillet proposal, when drawn, must still read as Outline-with-fillets. Rounded object corners occupy the 1.6–1.7× band so that pack cannot collapse into the legacy fillet proposal’s 0.5–1× band.

---

## 3. Terminal language

Open-glyph ends are **round caps** (full semicircles with radius = stroke/2).

- Plus, arrows, link strokes, search handles, and branch connectors terminate in capsules.
- Square caps are Outline. Rounded does not use them.
- Pointed arrow tips in Rounded are round-joined polylines: the tip is a circular arc of radius stroke/2, not a mitre and not a square cut. Direction must still read; if a blunt tip fails at 12 px, lengthen the head or simplify, do not switch to a square cap.
- Arrows are one continuous shape: the shaft runs into the tip, at a 45° head half-angle and a head span of two thirds of the canvas, in all six drawings. This is a design judgment; a detached shaft was not a functional failure. The outline 12 shaft sits on a pixel row (y 5–6), so it is as solid as its head at 1×.
- Arrow left, up, and down are exact reflections of that native arrow, not redraws. Left and right share a pixel row; up and down share a pixel column (x 5–6). Chevrons do the same from one native chevron, and they sit on the canvas centre because they have no long straight stroke to blur.

---

## 4. Contour / weight model

Nominal contour widths match Outline so mixed-pack screens stay optically compatible. The *model* is different: round joins and caps, circular nodes, stadium rails.

| Native canvas | Outline | Open-glyph filled (weight pair) | Meaningful gap target |
|---:|---:|---:|---:|
| 12 | 1.0 | 2.0 | 1.0 |
| 16 | 1.5 | 2.5 | 1.5 |
| 24 | 2.0 | 3.0 | 2.0 |

`pairModel: silhouette` — outline is a ring of the filled outer shape (same outer bounds). Filled does not fill recognition-critical holes (door, date marks, warning punctuation).

`pairModel: weight` — the same centerline, heavier capsule. Search, link, ban, and bold keep their counters in both appearances. Plus, arrows, chevrons, dots, and bars are solid in both appearances; “filled” means heavier, not hollow.

**Contour marks in filled.** A positive mark in outline is cut out of the filled shape at the same width, so it stays at the gap target from the edge. Some parts stay at contour weight in both styles because the shape needs them thin: Copy's rear sheet, Lock's shackle, Trash's lid, Laptop's base, Sun's rays, Layers' lower edges.

Padding / keyline: 1 / 1.5 / 2 px matching Outline. Rounded round caps may optically undershoot a square-cap neighbor; that is expected, not a license to thicken past the token.

---

## 5. Diagonal treatment

Diagonals are **round-capped, round-joined** strokes or rotated stadiums.

- Outline diagonals pick up mitre mass and square ends; Rounded diagonals do not.
- Search handles, link loops, and arrow chevrons are the proof cases.
- Do not stair-step a diagonal into an octagon to fake a curve (that is Outline’s search lens). Rounded search is a circle.

---

## 6. Density / negative-space behavior

Rounded prefers **slightly larger counters** than Outline at the same size, because round joins eat corner interior.

- Meaningful openings should meet the gap target in the table above unless an exception is recorded.
- Do not crowd micro punctuation. Calendar has no date marks at 12 or 16 and a row of three at 24. File has two unequal left-aligned lines at 24 only, because one centered bar has the form of file-minus. Trash slots, Lock's keyhole, and Chat's content line appear at 24 only.
- Dense compositions (sliders, calendar, warning, branch) occupy only the space they need; a canvas is not a compulsory painted box.
- Avoid sub-pixel holes. If a counter cannot stay ≥ ~0.9 / 1.35 / 1.8 px inscribed diameter at 12 / 16 / 24, remove it. This is why File's turned-down corner is solid in outline.
- An odd-width mark needs an odd-pixel centre. Warning is centred on a pixel column at 12 and 16 (x 5.5 and 7.5), so its stem paints one solid column at 1×. Its gaps stay at target.
- A 1 px stroke at 12 sits on one pixel line: rows and columns at x.5. Menu, Minus, the arrows, Upload, Download, Chart, Type, and Align center do this. Where the outline stroke leaves the canvas centre it stays inside the rows its filled partner paints, so switching styles does not jump. Each offset is registered.
- Info's stem is the exception inside a symmetric frame: the circle has no centre column, so a 1 px stem would sit visibly to one side. It is 1.5 px on the canvas centre, covering two columns evenly.

### Registered exceptions

`catalog/exceptions.json` is rebuilt from measurements by `source/build.py`. It lists only values currently below their contract, in one schema (`catalog/schemas/exceptions.schema.json`). A value that reaches its target drops off, so resolved records do not linger as active failures. `owner` and `reviewer` stay `null` until a person accepts the tradeoff; a record is a disclosure, not an approval. Targets above do not change because a value is registered.

| Rule | Where | Why it stays |
|---|---|---|
| `weave-separation` | Link, all six drawings | An over/under cut between two crossing strokes. It is not a counter or an opening, and the gap target would cut the rings apart. Link's three counters are measured separately and meet the floor. |
| `open-glyph-filled-width` | Link filled 12 | 1.75 px, not 2, so it is no denser than the 16 master and its counters stay open at 1×. |
| `open-glyph-filled-width` | Code, Group, and Loader, filled 12 and 16 | 1.5 and 2 px. Several parts must share the canvas at the gap target. Each is still heavier than its outline partner. |
| `counter-inscribed-diameter` | Branch outline 16 | The one exception to "remove it" above: the node rings distinguish outline from filled. Measured about 1.28 px on the flattened path (1.3 nominal) against 1.35. |
| `weight-pair-centerline-offset` | Outline 12 of the arrows (left, right, up, down), Upload, Download, Minus, Menu, Chart, Type | 0.5 px from its filled partner, whose 2 px stroke is already crisp on the canvas centre. |
| `canvas-centre-offset` | Warning 12 and 16, both styles | 0.5 px left of the canvas centre. It would show in an icon-only centred use, and Warning always carries a visible label. |
| `canvas-centre-offset` | Align center 12, both styles | 0.5 px left of the canvas centre, so its axis is one solid column. It shares its bounds across the styles. |

---

## 7. Filled vs outline pairing rules

| Model | Outline | Filled | Bound rule |
|---|---|---|---|
| `silhouette` | Ring (and positive marks) of the shared outer shape | Solid outer shape minus the same counters | Outer bounds match within 0.05 px |
| `weight` | Nominal capsule width | Heavier capsule on the same centerline | Filled area > outline area; bounds may grow with the heavier cap. Registered exceptions: filled widths and the 12 px centerline offsets listed in section 6 |

Filled is never “outline with the hole painted in” for search, link, ban, bold, or other hole-as-meaning glyphs. Ban is the proof case: a solid disc would lose the sign, so filled is a heavier ring and bar with both counters open.

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

Any other size, any missing master, and any other pack raises. Rounded must not fall back to Outline or to another Rounded size.

Simplification, 12 → 16 → 24:

- **12:** drop internal content marks (file lines, calendar dates, Trash slots, Table's second row); larger relative counters; fewer nodes and teeth (Gear has six); plain letterforms. Visible labels are mandatory on `warning`, `branch`, `link`, `help`, `focus`, and `group`.
- **16:** compact; still no file lines or calendar dates. Type's serifs appear here. Filled strokes on Code, Group, and Loader stay thinner than the action weight.
- **24:** full grammar, including file lines, a row of calendar dates, Lock's keyhole, a second Layers edge, and roomier punctuation.

Native sizes are artwork sizes, not target sizes. Use 12 for secondary information, 16 for compact UI, and 20 or 24 for primary UI, through the display mapping above. Touch and pointer targets are the control's job.

Do not claim the three masters have unrelated metaphors. They share topology; spacing, radius, and marks are authored per size.

---

## 9. How Rounded differs from Outline and from the legacy fillet proposal

```text
Outline   square caps, sharp/chamfer corners, octagons & cut-boxes, M/L/Z only
legacy fillet proposal   (planned) Outline skeletons + circular fillets; same topology; curve-aware
Rounded      capsule terminals, circular nodes, stadiums as key shapes,
          continuous curvature large enough to change the silhouette,
          constructed from Rounded primitives, never a filter on Outline paths
```

Concrete tells:

- Search lens is a **circle**, not an octagon.
- Slider knobs and branch/user heads are **circles**, not boxes/octagons.
- Plus/arrow terminals are **round**, not square.
- File/calendar/home/warning outer corners are **radiused key shapes**, not chamfers.
- Star points and inner notches are **round-joined**. Join radius is the `STAR_JOIN` exception (~0.5× outline) so mass tracks Outline; this is not a fillet from the legacy proposal on an Outline star.
- Info, Help, and the status glyphs sit in a **circle**, not an octagon. Gear's teeth, Bell's clapper, and Grid's panels are **round**, not cut or boxed.

The legacy fillet proposal, when drawn later, should still be recognizable as Outline with fillets. Rounded should not. If a Rounded icon is mistaken for “Outline with border-radius,” the construction failed the grammar.

---

## 10. Accessibility / contrast assumptions that belong to UI, not glyph geometry

These rules are **interface contracts**. Passing geometry tests is not a WCAG audit.

- Enclosing controls supply the accessible name. Standalone SVGs may carry a `<title>`; in a named button the inner SVG is `aria-hidden`.
- Warning requires a **visible text label** at every appearance and native master, including scaled uses of those masters. A tooltip or `aria-label` is not a substitute. This restriction is concept-level (same meaning as Outline) and is bound to Rounded artwork hashes on every build.
- Branch requires a visible text label at every appearance and native master, and Link requires one at 12 px. These rules are separate from the Warning restriction record. Labels do not resolve crowded geometry, and looking clear is not evidence of recognition.
- Help, Focus, and Group require a visible label at 12 px and recommend a contextual one at other sizes. Arrow up right and Wand keep a visible action label, and Check circle, Ban, and Close circle are paired with text that states the status. These rules match Outline because they describe the concept, not its geometry. Other concepts take their name from the enclosing control; 12 px remains for labeled information.
- Circle, Square, and Dot imply no control behavior. Loader's animation belongs to the caller. Play and the literal arrows do not auto-mirror.
- Contrast, focus rings, 44 px targets, forced-colors, and RTL mirroring policy live in the product UI. Glyphs use `currentColor` and do not encode state color. Literal arrows do not auto-mirror.
- Non-text contrast of the icon against its surface is the app’s job. Rounded does not paint a background chip.

---

## 11. Allowed SVG / path primitives and validator implications

### Construction primitives (source of truth)

Python geometry, not hand-edited SVG:

- `circle`, `ring` (circular)
- `stadium` / round-capped `line` (capsule)
- `rounded_rect` / `rounded_rect_ring`
- `rounded_hull`: a convex key shape (house, page, warning, torso) from its corner circles, **authored in Rounded coordinates**, not derived from Outline vertices
- `round_convex`: rounds convex corners by shrinking and then expanding, for the terminals a boolean cut leaves
- `round_all`: rounds convex and concave corners together (star)
- Boolean union / difference / intersection
- Round cap `cap_style=round`, round join `join_style=round`

`source/glyphs/kit.py` adds `stroke` (a round-capped polyline with rounded centerline corners), `soften_concave` for inner junctions, and exact reflections. Bold and Type are authored from these, not from a font outline.

Stroke-as-attribute SVG is not used. Exports are expanded `fill="currentColor"` / `fill-rule="evenodd"` paths, same document shell as Outline, so both packs inline the same way.

### Serialized path commands (product)

**Product SVGs are expanded `M L Z` polylines.** Rounded is constructed with round caps/joins and circular nodes; Shapely boolean unions flatten those curves at `quad_segs=8` and a 0.0001 export grid. That flattening is the **shipping representation**, not a claim that Rounded is an Outline-style sharp-polygon grammar.

Do not describe the 462 files as native-arc/`C` exports. They are not.

### Font-unit phase

`remix_ui_icons` compiles at 15360 units per em, so a coordinate moves by up to half a font unit: 1/1920 px at 16. That is invisible, but Cairo stores coordinates in 1/256 px steps and samples coverage on a coarse grid at 1×. A coordinate just beside a step can round across it, and one pixel changes by up to 1/15 of full coverage. The native-size gate rejects that. No threshold moves for it.

The fix belongs in the drawing. A master that fails is snapped to `FONT_EXACT_GRID`, 1/80 px, the coarsest grid exact in both four-decimal SVG and font units at every master, so it compiles with nothing to round. The grid is too fine to change the drawing at any visible size, and the corners stay round. Today this applies to two masters, listed in `FONT_EXACT_MASTERS`: Play and Box, outline 16. `tests/test_font_phase.py` rounds every master to font units with CairoSVG and holds it to the same limits as the compiled-font gate.

### Validator commands (construction / test infrastructure)

The parser **accepts** `M L C Q A Z` and **rejects** everything else. It flattens `C Q A` at declared sagitta 0.05 px so a future native-arc drawing, or a hand-edited curve, cannot be silently ignored. That is fail-closed measurement infrastructure. It is not product export.

Reject: `H V S T` shorthand, `script`, event handlers, `href`, images, filters, strokes, gradients, non-`currentColor` fills, entities/doctype.

### Curve-aware validation is required

Outline’s parser **rejects curves**. Rounded **cannot** reuse it as the pack validator, even while its products happen to serialize as `M L Z`.

Minimum trustworthy Rounded validator:

1. XML: exact `svg > title + path` structure, SVG namespace, `currentColor`, `evenodd`, native square viewBox, no extra attributes or mixed content (same safety posture as Outline).
2. Path lexer: `M L C Q A Z` and finite numbers (products today use `M L Z` only).
3. Flatten `C Q A` to polylines with **declared sagitta/flatness 0.05 px**, then build Shapely polygons.
4. Validity, non-empty, bounds inside the native canvas.
5. Fail closed on unknown commands; do not ignore curves.

---

## 12. Shared family contract (must not break)

- Canonical IDs, labels, and meanings come from the shared inventory contract. Outline carries the same concepts.
- Outline + filled; native 12 / 16 / 24 masters; 77 × 2 × 3 = **462** SVGs. Coverage is complete: there is no Rounded concept without all six drawings.
- `currentColor`.
- Warning visible-label restriction remains in force at the concept level.
- No silent fallback between packs or sizes.
- Outline bytes stay frozen. Rounded construction must not import or rewrite Outline SVG geometry.

---

## 13. Out of scope for this source pack

- Public npm or pub.dev publication of this directory; `packages/remix_ui_icons` compiles the drawings into its Flutter release
- Concepts beyond the shared inventory
- Drawing the legacy fillet proposal
- User-recognition study, independent design sign-off, WCAG certification
