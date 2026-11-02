# Unreleased — product inventory follow-up

Corrects new masters only. All 288 pilot SVGs and snapshots, the ledger and the frozen fixtures are unchanged, and thresholds are unchanged.

- Align left, center and right: redraw as selected-object alignment, with a vertical guide and two panels of different widths. Replaces text rows, which were the wrong meaning. IDs are unchanged; the pair model is now silhouette.
- Box and six other concepts (Ban, Bold, Group, Input, Table, Type): export real corners only, so an SVG and its compiled glyph rasterize alike. Geometry is unchanged.
- Activity: cut mitred peaks flat on the pixel grid, which removes stray coverage in Flutter at 12 px.

# Unreleased — complete product inventory

Adds 29 concepts and 174 native SVGs, for 77 concepts and 462 SVGs. All 288 existing SVG bytes, the 70-entry revision ledger and the frozen fixtures are unchanged, and those fixtures are now explicitly legacy scope. No version, release or approval status changes.

- Add Activity, Align center/left/right, Ban, Bold, Box, Check circle, Chevrons left/right, Circle, Close circle, Code, Cursor, Dashboard, Dot, Group, Heart, Input, Laptop, Layers, Loader, Moon, Smartphone, Square, Sun, Table, Type and Wand. See `docs/construction.md`.
- Add `tests/test_product_inventory.py`, which checks semantics, bounds, counters, pairs and master independence from exported paths, and 174 native pixel snapshots created after reviewing light and dark boards. Thresholds are unchanged.
- The guide's new-concepts filter now shows these 29; earlier additions are tagged PILOT.
- Add no exception or restriction records. New usage guidance for Group, Wand and status marks is in the catalog notes.

# Unreleased — shape corrections

Owner-authorized local corrections after the 2026-11-01 shape reviews. No version, release or approval status changes. The exact revised SVGs are listed in `tests/fixtures/shape-revision-2026-11-01.json`.

- Warning: redraw frame and punctuation. Outline clearances and filled widths now meet their targets, except the 16 px outline stem-to-dot gap. The visible-label rule is unchanged.
- Link: replace bracket-and-dash with two open interlocking hooks on one diagonal axis.
- Calendar: add a contour-weight header rail, use one off-center date at 16/24 px and none at 12 px, and remove the cut corner.
- Terminal: use a square window, with an open prompt and a cursor at every master.
- File: use two unequal left-aligned lines at 24 px instead of one centered bar.
- Help: give the 16 px hook a short stem centered over the dot.
- Small-master grid: record one odd-width policy and apply it to Pause, Chat, Lock, Menu, More, Chart, Search, Refresh, the arrows, Download, Upload, Arrow up right, Folder, Home, User, Copy and Bell. See `docs/optical-sizing.md`.
- Link: raise the filled 24 px stroke to the heavier 3 px token, drawing its two ends back to hold the 2 px hook gap.
- README: stop leading with the historical pilot capture, and label its age where it is linked.
- Exceptions: keep only active below-target records. The five Warning records that now meet their targets leave the register; their measurements stay as ordinary tests, and every hold is unchanged.
- Exceptions: register the filled Link 12/16 px hook gaps, which sit just under the general gap target. Filled 24 px meets its target and stays off the register. No artwork changes.
- Tests: add measured geometry and raster regressions, and pin revisions in a hash ledger while the original fixtures stay immutable.

# 0.5.0-pilot.2 — Audit patch

- Fix selected controls and their SVGs in forced-colors mode.
- Replace the panel grid with per-icon coordinate and keyline overlays.
- Add device-aligned native raster proofs, separate from enlarged vectors.
- Generate Warning guidance from a single geometry-bound restriction record.
- Bind validation to source, tests, outputs, dependencies, and tool versions.
- Rebuild in a clean temporary tree and reject stale or altered evidence.
- Reject unsupported SVG attributes and values with an explicit allowlist.
- Add negative/mutation tests and browser regressions for the audit findings.
- Preserve all 288 SVG bytes and all existing pixel baselines.

# Changelog

## 0.5.0-pilot.1 — local review build

Added 15 canonical concepts: Arrow left/up/down; Chevron left/right/up/down; Minus; Edit; Save; Refresh; Filter; Gear; Info; Help. There are 90 new native SVGs and 288 total canonical SVGs.

Preserved all 198 original v0.4.1 SVG bytes. Moved catalog organization to the planned semantic categories without renaming existing glyph IDs. Sliders, Gear, and Filter remain separate; “settings” is a search keyword only.

Introduced the manifest/schema, deterministic repository build, seven sprites, 48 isolated module imports, a complete generated catalog, GitHub workflow, native pixel snapshots, safety and geometry checks, release gate, and explicit remaining-work ledger.

Local drawing corrections during the pilot: enlarged Gear's filled hub; removed small inward contour artifacts by using a clean octagonal hub; widened the 16 px Edit counter; removed Save's thin slot seam; opened Info/Help punctuation spacing to the authored native gap targets.

No public release, license grant, Core 120 completion, legacy fillet proposal availability, user-recognition result, or cross-browser certification is implied by this version.
