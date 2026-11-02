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

`warning_parts()` in `source/outline/baseline.py` is the inspectable frame and punctuation. `tests/test_shape_corrections.py` measures the exported paths against these targets.

| Measure | Target 12 / 16 / 24 | Measured 12 / 16 / 24 |
|---|---:|---:|
| Outline mark to frame | 1 / 1.5 / 2 | 1 / 1.5 / 2 |
| Outline stem to dot | 1 / 1.5 / 2 | 1 / **1** / 2 |
| Filled punctuation width | 1 / 1.5 / 2 | 1 / 1.5 / 2 |
| Filled stem to dot | 1 / 1.5 / 2 | 1 / 1.5 / 2 |

The 16 px outline stem-to-dot gap is a recorded exception: a 1.5 px gap would leave a stem no taller than its dot. To make this room the triangle overshoots the normal padding: a triangle covers far less of its box than a square does. Its painted bounds reach the canvas top and left at 12 px and the left at 16 px. Meeting these numbers does not remove the visible-label rule in `catalog/restrictions.json`, and it says nothing about recognition.

`catalog/exceptions.json` is active-only: it lists values currently below their target, each with its measurement and reason. A value that reaches its target drops off the register, and the tests and Git history keep its measurement. A record is a disclosure, not an approval. Owner and reviewer stay null until a person accepts it, and dropping a record changes no visible-label, design, recognition or release hold.

## Recorded drawing decisions

These are 2026-11-01 local design judgments between prototypes compared at native size. None is a recognition result.

- **Link:** two open hooks on one 45° axis, each returning into the other's mouth. Closed interlocked rings read literally at 24 px but filled in at 12 px, and a staggered horizontal pair read as an S. Open strokes keep one topology at every master and no counter that can vanish. Filled 24 px uses the heavier 3 px token because 2.5 px barely separated it from the 2 px outline; its two ends are drawn back 0.35 px to hold the 2 px hook gap. Filled 12/16 px stay at 1.5/2 px, which leaves hook gaps of 0.94 and 1.48 px against the general 1 and 1.5 px targets. Both are active exceptions, with no added label rule.
- **Calendar:** a header rail at contour weight, with one off-center date at 16/24 px. Two date marks read as eyes under the bindings. The 12 px master keeps only the frame, bindings and rail. The cut corner is removed here because it competed with the rail; it stays on Copy, Lock, Folder and Trash.
- **Terminal:** a square window with an open prompt and a cursor at every master, so the frame does not repeat File's clipped corner and the prompt does not close into a play triangle.
- **File:** two unequal left-aligned lines at 24 px, because a single centered bar has the form of a file-minus. 12/16 px stay plain.

Only M/L/Z expanded polygons are supported by the Outline parser. It rejects curves rather than silently ignoring them. legacy fillet proposal requires a curve-aware bounds and measurement implementation or tested flattening with a declared tolerance before any legacy fillet proposal release.

## Product inventory decisions

These 29 concepts complete the shared inventory. Constructors live in `source/outline/product/`, grouped by kind. They are local design judgments from native-size boards, not recognition results. `tests/test_product_inventory.py` checks structure from exported paths.

- **Circle, Check circle, Close circle, Ban:** there are no curves here, so Circle is a regular octagon. The enclosed status marks use Info's frame, with longer flats for their marks. Check and Close fit inside the clearance target. Filled Ban is divided by its negative slash, so it cannot read as a filled Close circle.
- **Circle, Square, Dot:** Square sits a step inside Circle's keyline, because corners carry more visual mass. Dot is solid in both styles, because hollow belongs to Circle. It stays under 55% of Circle's width.
- **Loader:** seven of eight octagon facets, cut radially so the gaps have parallel sides. Its facet ends are therefore not square. With square ends, holding the gap target at the heavier weight shortened each facet to a block about as long as it was wide. The omitted facet makes rotation visible. The radial facets separate it from Sun's hub and rays.
- **Code and Terminal:** Code has source brackets and a slash and no frame; Terminal keeps a window and a prompt. Filled Code stops at 1.25 and 1.75 px at 12 and 16 px, because heavier strokes turned the brackets into arrowheads.
- **Dashboard and Grid:** Dashboard is four panels in staggered columns, so panels are unequal. Grid stays four equal cells.
- **Group, Focus, User:** Group is a marching-ants selection frame around two objects. It has side dashes, which Focus does not, and it means grouped selection, not people. Outline objects are apart; Filled objects overlap into one. Group needs a visible label at 12 px, like Focus.
- **Chevrons:** two copies of the native Chevron, with pitch tuned per weight to hold the gap. Painted bounds are centered, not the tip coordinates.
- **Align:** selected-object alignment, not paragraph formatting. A vertical guide and two panels of different widths, at every master. Left and Right share an edge beside the guide and are exact mirrors. Center shares one x coordinate, with the guide running above, between and below the panels; it is a vertical axis, matching the registry's `alignCenterHorizontally`.
- **Activity:** its peaks are cut flat on the pixel grid. A full mitre ended in a sliver thinner than a pixel, which CoreText's edge coverage rendered at half strength, more than a pixel outside anything Cairo painted that strongly.
- **Bold and Type:** authored letters, no font outlines. Bold's waist is a notch between chamfered bowls. Type's head drops and foot keep it apart from Plus.
- **Box and Layers:** both use 2:1 slopes rather than 45°, which flatten the top face and leave room for the lower faces or sheets. Box shows three faces. Layers is a top sheet over open V strokes.
- **Moon and Sun:** Moon is a faceted crescent with equal inner facets at 24 px, because longer axis edges read as an L. Sun's rays clear each other by the gap target, which keeps them short. Filled Sun changes the hub, not the rays.
- **Wand:** Filled uses a concave sparkle, because a solid diamond on the rod read as a hammer head.
- **Input:** a tall I-beam breaks the field into two open brackets, so no closed window competes with Terminal.

Exported product paths contain real corners only. A boolean union leaves vertices along straight edges, which the font compiler drops, and Cairo samples a pixel row differently when a vertex falls inside it. That made Box 16 differ from its own glyph by up to 12/255, so `product.draw()` removes them and a test renders each drawing on the font grid.

No product drawing needed a measured gap exception: every separated part and counter meets its general target, so `catalog/exceptions.json` is unchanged.

Four drawings coincide with a scaled 24 px master: Circle in both styles and outline Ban at 12 px, and filled Square at 16 px. They have no detail to vary, and 1 and 2 px contours keep the 12:24 ratio. All other masters carry their own decisions, and `tests/test_product_inventory.py` fails if another one coincides.

## Scope heuristic

80/20 is a proposed workflow-coverage target, not a rule that every icon occupies 80% of a canvas or receives 20% arbitrary deviation. Measure it against actual target screens before claiming coverage.

## Rationale sources

IBM's grid/key-shape guidance supports consistent proportions with fine optical adjustment and warns against crowded elements. Its exact 32 px construction specification is not copied into this 24 px project. See `SOURCES.md`.
