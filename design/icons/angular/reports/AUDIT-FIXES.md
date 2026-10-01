# Audit patch: Vector UI Angular pilot.2

**Five audit fixes implemented. All 48 icons and 288 SVG drawings are preserved byte for byte.**

This is a private review build, version `0.5.0-pilot.2`. It does not approve a public release, license, or new icon geometry.

## F01 — Selected controls in forced-colors mode

The selected Favorite no longer inherits a surface-wide black foreground. The controls use paired system colors: `Highlight` with `HighlightText`, and `ButtonFace` with `ButtonText`. SVG foregrounds inherit from their controls. A scoped forced-color-adjust rule protects selected control pairings without forcing the brand palette onto the whole page.

The browser tests sample painted screenshot pixels, not only SVG element counts. Both emulated light and dark forced-color schemes were tested, with selected and unselected Stars, the primary action label, keyboard toggles, fixed control dimensions, and focus visibility. Measured foreground/background samples were 11.31:1 for the selected light-theme control and 8.728:1 for the selected dark-theme control in this Chromium environment. These are local samples, not a universal palette guarantee.

Evidence: [forced light](../review/audit-patch/forced-light.png), [forced dark](../review/audit-patch/forced-dark.png), and [browser regression results](audit-browser-chromium-content.json).

## F02 — A real coordinate grid and native proof

Every enlarged icon now has its own overlay in the same SVG viewBox and at the same origin. One native unit becomes 1 CSS pixel at 1× or 4 CSS pixels at 4×. The reference inset is explicitly labeled as a guide, not a requirement that the artwork touch the boundary. The canvas-center cross is also distinct from optical centering.

The **Native raster proof** is separate from the enlarged view. It rasterizes the exact exported path at device resolution. Its origin is snapped to the device-pixel grid. The checks cover every icon and master, both appearances, 1×/4× inspection scales, and 1×/2× pixel densities. A fractional-position fixture verifies that panel centering does not add an unintended raster offset. No grid is painted over the native proof.

Results: **576 coordinate-pair instances and 1,152 native raster instances** checked. These are repeated views of the same 288 drawings, not new artwork. Native proof alignment at other fractional densities or unusual zoom settings is not claimed as tested.

Evidence: [coordinate inspector at 1× density](../review/audit-patch/coordinate-inspector-1x.png) and [2× density](../review/audit-patch/coordinate-inspector-2x.png).

## F03 — Warning guidance from one record

`catalog/restrictions.json` now owns the Warning usage rule for all six native appearance/size combinations. **A visible text label is required for outline and filled at 12, 16, and 24 px, including scaled uses of those masters.** A tooltip or accessible name does not replace that visible label.

Catalog notes, inspector text, optical-review documentation, usage documentation, and the JavaScript `getIconUsage()` helper use the same record. They no longer carry conflicting hand-written requirements. Each cell is bound to the exact SVG SHA-256.

The three inherited outline gap exceptions are retained. Two explicit filled-punctuation exceptions document the smaller opening widths at 16 and 24 px. These are restrictions, not passes against the general gap target. Named owner and reviewer fields are still pending; no independent approval has been fabricated.

```js
import {getIconUsage} from './packages/web/index.mjs';
const rule = getIconUsage('warning', {appearance: 'filled', size: 20});
// rule.master === 24
// rule.visibleLabelRequired === true
```

Evidence: [generated usage guidance](../docs/usage-restrictions.md), [restriction source](../catalog/restrictions.json), and [mobile inspector](../review/audit-patch/warning-guidance-mobile.png).

## F04 — Reports cannot silently outlive their inputs

All required technical reports now include a shared evidence envelope. It covers geometry source, build scripts, tests and fixtures, catalog records, dependency definitions and the new pinned development dependency closure, generated outputs, package files, workflow files, and relevant Python/Node/Cairo/GEOS/package versions. Reports also carry a payload hash. Adding, removing, or changing a covered file invalidates old evidence. Changes during a run turn the report into a failure.

The release gate rejects unstamped reports, altered payloads, mismatched runtimes, and stale input sets. A mutation test uses a disposable project copy and the **actual release gate**: after a build-source mutation, all four synthetic successful technical reports are rejected. The original project is not mutated by this test.

The rebuild check now starts in a clean temporary tree with generated outputs removed. It reproduces **357 product files** without modifying the reviewed checkout. Snapshot-creation mode cannot count as a passing pixel-regression result.

Fingerprints detect accidental changes and stale evidence. **They are not cryptographic signatures or protection against a maintainer who can rewrite both the code and the reports.** Reports from a different toolchain must be rerun. A final release should run checks against the intended release checkout, not reuse status fields from another build.

Evidence: [clean rebuild](rebuild.json), [asset/mutation tests](asset-checks.json), and [fingerprint implementation](../tools/evidence.py).

## F05 — SVG export validation rejects unknown behavior

The standalone Angular SVG parser now accepts only its declared export format: the SVG namespace, one title, one expanded path, exact native dimensions, currentColor, evenodd fill, and the expected accessibility attributes. Unknown attributes and wrong values fail closed.

The tests reject root opacity, display, color and stroke overrides, unexpected path/title attributes, namespace substitutions, unsupported markup, mixed content, comments/directives, and invalid dimension/fill/role values. All **288 existing files** still parse successfully. Browser/raster checks remain separate safeguards.

This validator is **not** a generic SVG sanitizer, nor does it claim support for a future curve-based Rounded pack.

## Executed checks

| Check | Result |
|---|---|
| Asset and audit unit methods | **28 passed**, including 11 new audit methods |
| Pilot SVG preservation | **288 / 288 unchanged** |
| Earlier v0.4.1 baseline | **198 / 198 unchanged** |
| Reviewed pixel baseline files | **288 / 288 unchanged; none regenerated** |
| Native pixel regression | **288 passed** |
| Clean rebuild | **357 products reproduced identically** |
| Node outputs / isolated imports | **288 comparisons / 48 imports passed** |
| Existing Chromium catalog checks | **150 passed**, content mode |
| Additional audit browser checks | **1,219 passed**, content mode |
| Coordinate-pair / native-raster instances | **576 / 1,152 checked** |
| Report freshness at handoff | All current stamped reports match the exact input set and toolchain |

Browser: Chromium `144.0.7559.96` via system executable. Python Playwright: 1.57.0. Actual tool versions are included in each report envelope.

## Remaining boundaries

HTTP and file navigation both returned `ERR_BLOCKED_BY_ADMINISTRATOR`. Both strict full-mode runners fail instead of silently treating injected HTML as a real URL load. The successful interaction checks used explicit **content mode**, so hosted loading, direct-file loading, and browser module fetching remain unverified.

Firefox and WebKit launch attempts failed because their executables are not installed. Their reports record failures, not successful cross-browser tests. No branded Safari, physical Windows contrast-theme, real-device, screen-reader, independent-design, or recognition study was performed. GitHub Actions has not run remotely. The dependency lock records the installed development closure; a clean network installation was not tested.

The public release gate remains blocked on **13 requirements**, including ownership, independent approval, naming, licensing, browser integration, immutable action pins, and human evidence. This is intentional. The patch does not redraw Warning, approve its ownership, or remove its restrictions.

## Re-run

```sh
python tools/run_checks.py
python tests/integration/browser_checks.py --mode full --browser chromium
python tests/integration/audit_browser_checks.py --mode full --browser chromium
python tools/release_gate.py
```

Use the appropriate browser executable/install for the host. Repeat both full-mode browser runners for Firefox and WebKit. Content mode is diagnostic only. Do not regenerate pixel baselines merely to turn a failure into a pass.

Input-set SHA-256: `caed40983ba2b334573bf6355d6ae004dd0479476eb473f05528ee47be921311`

Toolchain SHA-256: `1af211d9822574dd196d6671c07e1085e6e041b6730ff218201ac86cd377e1f0`

## Technical references

- [W3C CSS Color Adjustment, forced palettes and system-color pairing](https://www.w3.org/TR/css-color-adjust-1/)
- [W3C non-text contrast guidance](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)
- [Playwright Python emulation](https://playwright.dev/python/docs/emulation)

The references inform implementation. They do not certify this package.

## Applying the optional source patch

The separate `vector-ui-audit-fixes.patch` was checked with `git apply --check` against the supplied pilot.1 tree. It contains authored changes, not replacement SVG artwork or generated reports. The complete project ZIP is already built. To apply only the source changes at the original repository root:

```sh
git apply --check /path/to/vector-ui-audit-fixes.patch
git apply /path/to/vector-ui-audit-fixes.patch
python source/build.py
python tools/run_checks.py
```

Run the full browser checks shown above on a host that can navigate to the test URLs. Do not carry old success reports into the new build.
