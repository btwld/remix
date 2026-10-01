# Acceptance criteria and review checklist

**Proposal, not executed test results.** This expands the validation section of PLAN.md. The inventory check performed for this plan is recorded separately in baseline-audit.json.

## Gate status model

Use `not-run`, `pass`, `fail`, `review-needed`, `approved-exception`, and `unsupported` as distinct states. An exception does not become an unrestricted pass. Report status per theme, appearance, optical size, and use context.

## Automated release blockers

| ID | Check | Required evidence |
|---|---|---|
| A01 | Canonical catalog IDs are unique and stable | Schema report; duplicate-name report; rename migration notes |
| A02 | All promised theme/appearance/size combinations exist | Exact set difference against the declared matrix |
| A03 | Search keywords and API aliases are different fields | No alias collisions or cycles; tests for settings/sliders/filter behavior |
| A04 | Asset XML is valid and safe | Allowed element/attribute set; no scripts, event handlers, foreign objects, raster payloads, or external references |
| A05 | Geometry is finite, visible, and inside approved bounds | Final-path bounds; empty-path and nonfinite-value tests; overshoot exceptions |
| A06 | CurrentColor and transparent counters work | Inline color-change test; light/dark render; no white patch masquerading as a cutout |
| A07 | Runtime paths match the approved source | Registry, individual SVG, sprite, HTML download, and adapter equality checks |
| A08 | Generated files are reproducible | Clean build with pinned dependencies; no unexplained diff |
| A09 | Exports are usable in a clean consumer | Actual package import, build, render, and TypeScript checks where provided |
| A10 | Package size does not include unrelated icons by default | One-icon import bundle inspection; full-dynamic resolver kept opt-in |
| A11 | SVG IDs do not collide | Multiple inline instances and multiple sprite usages in one document |
| A12 | All promised downloads really work | Actual HTTP and offline download tests; compare bytes to package assets |
| A13 | Catalog and docs have no missing icons or stale previews | Manifest-derived counts; search and filter coverage; no old source in exports |
| A14 | Baseline and changes remain traceable | Release hashes, construction revision, review decisions, and changelog |
| A15 | Source provenance and release license are present | Per-source record and top-level license review, not an assumed license |

Current expanded outlines are filled paths. Testing a `stroke-width` attribute is not enough to establish thickness. Keep construction parameters and inspect the resulting geometry.

## Geometry diagnostics requiring review

| ID | Diagnostic | Decision rule |
|---|---|---|
| O01 | Painted dimensions and edge pressure | Compare similar structures; do not force equal areas or full keyline occupancy |
| O02 | Important internal gaps and openings | Use authored critical regions with native 1/1.5/2 px targets; review flagged cases |
| O03 | Frame/stem thickness | Measure stable representative sections, not pointed tips; compare intended native tokens |
| O04 | Outline/filled relationship | Apply silhouette or weight pair policy; fixed component layout; review apparent motion |
| O05 | Topology and disappearing details | Record intended components/counters per master; simplification must preserve meaning |
| O06 | Raster clarity | Native 100% CSS-size captures at 1×/2×, then magnified pixel inspection |
| O07 | Visual balance | Compare neighborhood strips and keyline overlays; area centroid alone is not an optical center |
| O08 | Curve correctness for future Rounded | Real curve bounds or validated flattening with declared tolerance; never ignore unsupported commands |

A minimum distance between all boundaries is not a useful universal gap measure: intended joins and tapered corners approach zero. Annotate the meaningful opening or separate components instead. Do not treat an intentionally narrow Bookmark as an undersized Grid.

## Required optical views

For every concept: outline/filled at native 12/16/24; light and dark; 1× and 2×; equal-size neighboring controls; large geometry overlay; paired state toggle without layout shift. Add 14/20/32 display-size checks, clearly marked as scaled previews. Report the actual chosen master.

Use twelve reference concepts for calibration, not twelve identical bounding boxes. Review every new icon individually. Large generated presentation images are not validation evidence for the actual SVGs.

## Interface and accessibility checks

| ID | Check | Expected result |
|---|---|---|
| I01 | Button and SVG semantics | Button has the action name; decorative inner SVG is hidden; standalone informative SVG is named |
| I02 | Keyboard operation | Tab reaches controls; Enter/Space work; no keyboard trap |
| I03 | Toggle behavior | Stable action name and appropriate aria-pressed state; ordinary actions are not false toggles |
| I04 | Focus on each surface | Focus visible on off-white, black, lime, cobalt, and forced-colors mode |
| I05 | Required visual-cue contrast | Check applicable 3:1 non-text threshold without rounding a failed result upward |
| I06 | Target size | Default 44 × 44 project controls; compact cases separately evaluated against target-size criterion |
| I07 | Non-color meaning | Status and selected state retain non-color cues; labels remain available |
| I08 | Text pairing | Regular/bold UI labels and technical metadata do not make icons look oversized or weak |
| I09 | Directionality | Explicit RTL policy by metaphor; no blanket mirroring of media, literal directions, or technical symbols |
| I10 | Responsive layout | Guide, dialog, download controls, and examples at 320/375/768/1440 CSS px, plus zoom checks |
| I11 | Loading contexts | Actual HTTP hosting, direct file opening when promised, and consuming package tested separately |
| I12 | Browser/device scope | Chromium/Firefox/WebKit records; real Safari and assistive technology before claiming those supports |

W3C sources S10–S12 in PLAN.md define the relevant criteria and button behavior. The project checklist is not itself a WCAG certification.

## Recognition protocol

Start with a formative 6–8-person study as a planning estimate. Recruit intended users rather than only icon designers. Randomize presentation, avoid showing a reference library alongside our glyph, and record confusion rather than prompting users toward the answer.

First ask what the unlabeled symbol suggests. Then ask users to perform the actual task in the interface with its planned labels. Include likely confusions: Sliders/Gear/Filter; Focus/Expand/Star; Save/Bookmark; File/Copy; Link/External link; Warning/Info/Error; Back/Undo. Record size, theme, appearance, label, task, interpretation, incorrect actions, hesitation, and notes.

Interpretation must be judged against the intended task, not exact vocabulary. A repeated misinterpretation, failure on a critical task, or confusion with a destructive action triggers redesign or stronger labeling. Do not publish a population-wide accuracy claim from this small formative sample. Test any future icon-only use separately.

## Exception record template

```json
{
  "id": "warning-gap-12",
  "icon": "warning",
  "theme": "angular",
  "appearance": "outline",
  "opticalSize": 12,
  "rule": "meaningful-mark-to-frame-gap",
  "status": "review-needed",
  "measuredEvidence": "link-to-current-measurement",
  "rationale": "retain or redraw after native-size inspection",
  "permittedUse": "labeled-information-only-until-approved",
  "owner": "to-assign",
  "reviewer": "to-assign",
  "sourceRevision": "to-record",
  "revisitWhen": "geometry or intended usage changes"
}
```

This is a template, not a new approval of the current Warning.

## Pull request evidence

A proposal states the unmet use case, chosen metaphor, related icons, category, pair model, all promised sizes, provenance, and RTL policy. A completed change includes real SVG previews, native strips, before/after evidence, an actual component example, automated reports, optical review, and any exception record. Keep batches to 6–12 concepts; split larger changes by semantic group.

Reviewers sign separate technical and optical decisions. Recognition findings stay separate. Updating an expected screenshot requires an explanation and approval; it is not a way to waive a failed check.

## Release checklist

The catalog's declared matrix is complete; no blockers remain; each intentional exception has an owner and public restriction; required browser support has evidence; diagrams and previews come from current assets; the runtime download agrees with the release files; a clean consumer works; the license and notices are complete; a changelog and immutable tag identify the release; checksums match; the support limitations are stated.

Future Rounded cannot be advertised as complete until it either matches the Core catalog or explicitly declares its own partial scope. Missing variants must show as unsupported, not silently fall back to a different theme.
