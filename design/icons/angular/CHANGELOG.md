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

No public release, license grant, Core 120 completion, Rounded availability, user-recognition result, or cross-browser certification is implied by this version.
