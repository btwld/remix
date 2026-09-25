# Icon family development plan

**Status: proposal • 24 September 2026 • Working name: Vector UI**

## Decision in brief

Build an original family around a stable catalog of familiar icon concepts. Preserve the current Angular drawings as the starting point. Establish the validation pipeline before expanding the catalog. Target **48 icons for the pilot** and **120 for the first full Core release**, subject to a target-screen audit. Add Rounded as a separately reviewed style pack, not as a filter applied to Angular paths.

This document does not create a GitHub repository, publish a package, grant a release license, or draw new icons. It preserves the existing assets unchanged. The accompanying catalog is a proposal; “not drawn” entries are not represented as available assets.

## 1. Verified starting point

The supplied `vector-ui-icons-v4.1.zip` contains **33 canonical icons, two appearances, and three optical sizes: 198 SVG drawings**. This planning pass checked archive completeness, XML parsing, exact path agreement with `source/icons.json`, and the 198 inventory hashes. See `baseline-audit.json` for the measured results and source archive fingerprint.

The archive already contains an authored geometry builder, a shared registry, generated SVGs and sprites, an HTML guide, individual review decisions, pinned review dependencies, and prior test reports. Reuse these; do not restart the artwork or introduce an unrelated icon generator.

Three gaps matter for a public family:

- The supplied archive has no top-level release license, contribution guide, or GitHub workflow configuration. Add these during repository setup. This observation concerns the supplied archive, not any uninspected external repository.
- Prior browser reports describe Chromium and HTML injection with `set_content`. Real hosted loading, direct file opening, Firefox, branded Safari, and assistive-technology behavior remain unverified. The new pipeline must distinguish these surfaces.
- The current final-path geometry checker is polygon-specific. A Rounded pack requires curve-aware bounds and measurements, or carefully tested flattening with a declared tolerance. A parser that rejects or ignores curves cannot validate a rounded family.

Warning has a known micro-size spacing exception. Branch and Focus require context. These remain visible constraints, not evidence that the rest of the family has passed a recognition study.

## 2. Reference strategy: familiar concepts, original artwork

Use established catalogs to identify useful concepts, naming patterns, missing opposites, and common modifiers. Use our own approved construction system to draw them. Maintain a mapping table with our ID, reference ID, reference release/commit, relationship, intended use, and provenance.

**Lucide** is a useful broad coverage reference. Its homepage displayed 1,856 icons when checked. **Heroicons** is a more compact comparison; its website displayed 316 icons. **Phosphor** demonstrates a central catalog with variants and framework builds. These counts and structures explain possible scope; none prescribes how many icons our product needs. [S3, S5, S6]

Do not require a one-to-one copy of another library. Merge duplicate concepts, identify intentional omissions, and keep a backlog for uncommon domains. Do not assume that an identical name guarantees identical meaning.

The preferred production method is original path construction, not tracing downloaded SVGs. Any deliberate reuse or adaptation must keep its source and applicable notices. Lucide publishes ISC terms and Phosphor core publishes MIT terms; check the exact selected release before importing material. Choose our own distribution license only after that provenance review. [S13, S14]

The phrase “idea icons” remains unresolved. No library has been silently chosen as that reference.

## 3. Use 80/20 for scope, not for geometry

“80% rules, 20% freedom” is a design heuristic, not a published acceptance standard. Do not use it to permit arbitrary exceptions or require every icon to occupy 80% of a canvas.

For scope, define a measurable target: **cover at least 80% of recurring icon uses in an agreed set of target workflows**, while covering every critical workflow. This is a proposed project target, not a claim about the current or planned catalog.

Inventory 8–12 actual target screens when they are available. Record each icon-bearing control or status, its intended meaning, its display size, and its frequency or criticality. Measure unique-metaphor coverage and usage-weighted coverage separately. If frequency data is unavailable, report unweighted coverage and label the limitation. Do not count UI elements that do not need icons merely to inflate the denominator.

The attached 120-icon proposal is a starting hypothesis. Replace low-value proposals after the screen audit rather than drawing extra icons to defend an arbitrary count. Specialist commerce/location symbols are particularly dependent on product scope.

## 4. Scope and variant model

| Milestone | Canonical icons | Angular drawings | What changes |
|---|---:|---:|---|
| Existing baseline | 33 | 198 | Preserve and import |
| Pilot | 48 total | 288 | Add 15 selected gaps; validate the workflow |
| Full Core target | 120 total | 720 | Add 72 after the pilot, in small batches |
| Rounded pilot | 12 selected icons | 72 new Rounded drawings | Test a second grammar; Angular remains unchanged |
| Rounded parity target | Same 120 IDs | 720 per style pack | 1,440 drawings across Angular and Rounded |

The calculation is `icon count × 2 appearances × 3 optical sizes`. An outline/filled file is a drawing, not a new semantic icon. A 14, 20, or 32 px preview is not a new optical master.

Start with Angular only. Curated Rounded comes next. Defer Soft, Technical, multicolor, duotone, variable weight, animated icons, and an icon font until a clear user need justifies their design and validation cost.

### Keep four dimensions separate

| Dimension | Example | Rule |
|---|---|---|
| Canonical glyph ID | `sliders` | Stable across packs |
| Style pack | `angular`, later `rounded` | Different visual grammar |
| Appearance | `outline`, `filled` | Deliberately paired drawings |
| Optical master | `12`, `16`, `24` | Native drawings with reviewed simplification |

Application state is separate again: selected, pressed, disabled, loading, or destructive is a component behavior. Do not create a new SVG for every state when color, labels, and component semantics can express it. Fluent provides a regular/filled distinction; it also cautions against overcomplex modifiers. Material explicitly separates fill, weight, and optical size. [S2, S7]

For open symbols such as Plus and arrows, “filled” may mean the approved heavier form rather than a hollow outline being filled in. Record `pairModel: weight` versus `pairModel: silhouette`. A third `shared` value can be proposed only when reviewers document why both appearances should intentionally use identical geometry.

Do not fabricate a readable 12 px asset for a metaphor that cannot support one. Redraw first; otherwise restrict that size to labeled use or mark it unsupported with no silent fallback. A promised rectangular release matrix must either be completed properly or explicitly revised before publication.

### Naming and compatibility

Retain all current IDs. Keep `sliders` as the adjustment-controls glyph. Add a separate `gear` candidate for settings and `filter` candidate for a funnel. “Settings” can remain a search keyword; it must not automatically make three distinct glyphs API synonyms. Use true aliases only for a documented rename of the same glyph. Literal naming also follows Fluent’s distinction between the object depicted and its application function. [S2]

A proposed pack should share meanings and approximate visual skeletons, not force identical SVG path coordinates. Rounded needs new corners, transitions, terminal treatment, and optical review. Changing `stroke-linejoin` cannot round already expanded polygon paths.

## 5. Repository and source of truth

Use one repository initially. Preserve the existing Python construction pipeline, with pinned dependencies, instead of rewriting it just to resemble another project. Add the smallest web/package tooling needed for validation, the catalog, and individual imports.

```text
icon-family/
  README.md
  LICENSE                         # choose before public release
  CHANGELOG.md
  CONTRIBUTING.md
  catalog/
    icons.json                    # canonical IDs, labels, categories, keywords
    aliases.json                  # true compatibility aliases only
    schemas/
    reference-map.json            # reviewed reference IDs and provenance
  source/
    angular/                      # editable construction + native parameters
    rounded/                      # added only after its pilot is approved
    shared/                       # genuinely reusable primitives
  generated/
    angular/outline/12/sliders.svg
    angular/filled/24/sliders.svg
    sprites/
  packages/
    svg/                          # first distribution surface
    react/                        # first framework adapter after pilot
  docs/
    construction.md
    optical-sizing.md
    accessibility.md
    exceptions.md
    catalog/                      # generated HTML examples
  tests/
    schema/
    assets/
    geometry/
    visual/
    integration/
  .github/
    workflows/
    ISSUE_TEMPLATE/
    PULL_REQUEST_TEMPLATE.md
    CODEOWNERS
```

Authored construction is authoritative for geometry; the canonical catalog is authoritative for identity and availability. Generated geometry, SVGs, sprites, docs, and adapters must derive from these inputs. Never edit generated paths to patch an appearance without changing the source.

Phosphor core uses assets and catalog metadata as a foundation for search and downstream libraries. Heroicons exposes individual, size-specific component imports. Apply those structural ideas without copying their artwork or immediately maintaining every framework. [S3, S4]

Use `theme` or `family` for a pack prop in future APIs; reserve SVG/React `style` for CSS. Offer static per-icon imports as the default, with an optional dynamic resolver. Test that importing one icon does not pull in the full catalog. No actual package namespace is committed until the name is selected.

Each asset record should identify its canonical ID, theme, appearance, optical size, source revision, pair model, intended minimum use size, known exceptions, directionality policy, and review status. Keep shape-level search keywords separate from the accessible name of a control.

## 6. Construction contract

Retain Angular’s current visual direction. Lock a short contract containing fixed canvases, square ends, approved diagonals, contour logic, and native-size behavior. Do not turn a nominal field into a hard requirement that every icon fill the same space.

Start with the existing nominal outline widths: **1 / 1.5 / 2 px at 12 / 16 / 24 px**. Keep the proposed meaningful-gap targets of **1 / 1.5 / 2 px**, but apply them to annotated important openings and channels, not to the tips of triangles or every converging edge. These are our project parameters, not universal standards.

The locked Sliders is a useful dense-icon reference: two rows, a smaller field, and restrained handle mass. Compare new dense objects against it, Calendar, and Terminal. Do not force them to have the same painted area as a single arrow.

Choose twelve calibration icons spanning different structures: Home, Search, Plus, Arrow right, User, File, Calendar, Sliders, Warning, Link, Branch, and Star. Their current inclusion does not erase known exceptions. Use them to establish review behavior and diagnostic ranges. IBM explicitly treats the grid as guidance, allows fine adjustment, and warns against crowding. [S1]

Construction tokens are not a license to scale or stretch expanded strokes. Inspect final paths and raster output after export and optimization. When authoring curves for Rounded, validate curve bounds and flattening error before using the same geometry diagnostics.

## 7. Validation: four distinct gates

**A. Technical gate — automated blockers.** Validate schema, canonical-name uniqueness, all promised combinations, safe SVG content, finite coordinates, viewBox, currentColor behavior, transparent holes, sprite IDs, exact export agreement, reproducible generation, checksums, package imports, and actual downloads. No scripts, event handlers, external images, or unexpected network references in icon assets.

**B. Optical gate — measurements plus design approval.** Measure actual bounds, relevant gaps, contour thickness, component topology, and outline/filled displacement. Render native pixels and a neighborhood strip. Measurements flag anomalies; a reviewer decides perceived balance. Do not use one black-area percentage, centroid position, path count, or “consistency score” as universal proof of quality. A known exception must name an owner, rationale, affected sizes, evidence, and allowed use.

**C. Interface gate — real rendering and accessible controls.** Render all native combinations in light/dark at 1× and 2×. Exercise 14, 20, and 32 px display sizes separately. Include compact toolbars, navigation, content rows, forms, notification panels, and labeled alerts. Test normal and bold UI text, selection without layout shift, focus visibility, keyboard action, and non-color state cues.

Use 44 × 44 px default interactive controls in our examples, with an explicit compact-control policy. This is our chosen target; WCAG 2.2’s minimum target criterion is 24 × 24 CSS px with specified exceptions. Test meaningful non-text cues at 3:1 where the criterion applies. Accessible names belong to the control, not automatically to the SVG. Toggle buttons use a stable label and `aria-pressed` when appropriate. [S10, S11, S12]

**D. Recognition gate — people performing tasks.** Run an initial formative study with approximately 6–8 representative users as a planning choice. Check unlabeled interpretation, confusion with neighboring icons, and task completion with the actual label/context. Prioritize Warning, Focus, Branch, Sliders/Gear/Filter, external-link/arrow, and save/bookmark/star. Repeated confusion triggers revision, a visible label, or a restricted use. This sample is for finding problems, not claiming a statistically established universal recognition percentage. Critical or regulated uses need domain-specific review beyond this general library plan.

No one gate substitutes for another. A valid SVG may still be visually poor; an attractive screenshot may still hide a broken download; a recognizable object may still have the wrong label for its action.

## 8. Continuous checks and release evidence

On every pull request, run schema/asset checks for the entire catalog and render changed icons together with their calibration neighbors. Re-run full light/dark contact sheets for changes to shared primitives or export settings. Capture differences against approved baselines and require a reason for each intended change.

Before a release, run the full browser matrix on Chromium, Firefox, and WebKit; add real Safari/device checks for the promised support scope. Playwright WebKit is not branded Safari. Keep separate baselines by browser and environment, since rendering changes with system configuration. Pin fonts, runtime, browser binaries, viewport, device-pixel ratio, and animation state. [S8, S9]

Do not auto-approve new screenshot baselines simply to turn a failed test green. Do not compare different browsers pixel-for-pixel against one shared baseline. Browser comparisons detect regressions, not semantic correctness.

Serve the built guide through the same HTTP path as production. Also test direct file opening when offline HTML is promised. Verify imports and rendering in a clean sample application, rather than assuming the source repository’s environment represents a downstream consumer.

The published evidence should report these separately: promised asset coverage, technical status, optical sign-off, context-test status, recognition-study status, known exceptions, and browser coverage. Do not add them together into a single misleading pass count.

## 9. Phased delivery and approvals

| Phase | Work | Exit criterion |
|---|---|---|
| 0 — Baseline and naming | Import the current archive; keep hashes; audit names, provenance, target screens, and release policies | Stable baseline; approved vocabulary; measured or explicitly provisional scope |
| 1 — Validation foundation | Separate source/generated files; schema; existing test migration; actual serving; review templates; CI | Existing 33 icons reproducible; known exceptions explicit; required jobs run |
| 2 — 48-icon pilot | Add the 15 selected missing icons; compare all 48 as a family; create one consuming example app | Every promised drawing and example present; technical and optical gates signed off; recognition findings recorded |
| 3 — Core to 120 | Add remaining proposals in batches of 6–12 concepts; revise the backlog from screen coverage | Each batch completes all six drawings per icon and its review; no accumulating “24 px only” debt |
| 4 — First public Core release | Clean install; imports; hosted/offline guide; browser and accessibility checks; license and changelog | Full declared matrix; no unresolved blockers; exceptions and support scope published |
| 5 — Rounded pilot | Build twelve matching concepts with a separate grammar and curve-aware checks | Approved appearance and semantics at all three sizes; no change to Angular baseline |
| 6 — Rounded parity | Extend approved Rounded grammar to the same Core catalog | Declared parity, no hidden fallback, independent review evidence |

The pilot additions are Arrow left, Arrow up, Arrow down, four Chevrons, Minus, Edit, Save, Refresh, Filter, Gear, Info, and Help. They are included in the 120 target, not added on top of it.

Estimate production time after the pilot. Record design time, small-size correction time, review time, and rework per concept. Do not extrapolate speed from exporting SVG files: export is cheap, optical decisions are not.

Use separate design and engineering sign-off roles when possible. The artwork author should not be the only person who approves a controversial optical exception. A reviewer may be the same person on a small team only if that limitation is recorded.

## 10. Definition of done

An icon is ready when its identity is clear; every promised appearance and size exists; its source reproduces its exports; automated blockers are clear; the native-size and interface views have been reviewed; relevant recognition concerns are resolved or constrained; metadata and examples are complete; and provenance is recorded.

A release is ready when the complete promised catalog meets those conditions, the support matrix is tested or accurately narrowed, and the package can be installed in a clean consumer. A quarantined or restricted icon is not counted as an unrestricted success.

Use semantic versioning for the declared public API. Additions can be minor releases; compatible corrections can be patches; removals, name changes without compatibility aliases, or meaning changes need a breaking-change policy. Treat major visual redesigns as a new style revision or a deliberate major release, not a silent patch. Published versions remain immutable. [S15]

## Decisions still needed

The family name, distribution license, first target product/screens, public launch size, and identity of the intended reference library remain open. These do not prevent baseline setup or planning, but they should be settled before a public release. Rounded remains a later proposal, not an approved redesign of the locked Angular icons.

**Recommended next milestone: establish the repository and validation on the existing 33 icons, then complete the 48-icon pilot.**

---

## Sources

**[S1] [IBM UI icon design](https://www.ibm.com/design/language/iconography/ui-icons/design/)** — Grid, key shapes, fine adjustments, and internal spacing. IBM uses its own dimensions; our 12/16/24 system is not an IBM standard.

**[S2] [Fluent 2 iconography](https://fluent2.microsoft.design/iconography)** — Recognizable metaphors, regular/filled behavior, literal naming, localization, and restraint with modifiers.

**[S3] [Phosphor core repository](https://github.com/phosphor-icons/core)** — Source assets plus catalog metadata power search and framework-specific builds.

**[S4] [Heroicons repository](https://github.com/tailwindlabs/heroicons)** — Separate size/appearance import paths and individual component exports.

**[S5] [Heroicons catalog](https://heroicons.com/)** — The page displayed 316 icons when checked. A publisher-reported catalog count, not a requirement for this project.

**[S6] [Lucide homepage](https://lucide.dev/)** — The page displayed 1,856 icons when checked. Its breadth is a coverage reference, not an instruction to redraw the entire set.

**[S7] [Material Symbols guide](https://developers.google.com/fonts/docs/material_symbols)** — Separates fill, weight, grade, and optical-size axes. We are not adopting its entire variable-font system.

**[S8] [Playwright visual comparisons](https://playwright.dev/docs/test-snapshots)** — Screenshot baselines depend on browser, operating system, settings, and hardware; pin environments and review changes.

**[S9] [Playwright browsers](https://playwright.dev/docs/browsers)** — Chromium, Firefox, and WebKit testing. Bundled WebKit is not a test of branded Safari.

**[S10] [WCAG 2.2 non-text contrast](https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html)** — At least 3:1 for necessary visual information against adjacent colors, subject to the criterion's scope and exceptions.

**[S11] [WCAG 2.2 target size minimum](https://www.w3.org/WAI/WCAG22/Understanding/target-size-minimum.html)** — 24 by 24 CSS px minimum target with specified exceptions. The plan chooses 44 by 44 px default controls as a project rule.

**[S12] [WAI-ARIA button pattern](https://www.w3.org/WAI/ARIA/apg/patterns/button/)** — Accessible names, keyboard action, focus behavior, and stable labels with aria-pressed for toggle buttons.

**[S13] [Lucide license](https://lucide.dev/license)** — ISC terms include notice retention for reused material. Check the exact selected release and its notices.

**[S14] [Phosphor core license](https://github.com/phosphor-icons/core/blob/main/LICENSE)** — MIT terms for reused Phosphor material; provenance and notice requirements still matter.

**[S15] [Semantic Versioning 2.0.0](https://semver.org/)** — Declare the public API, keep published releases immutable, and use explicit compatibility rules.

**[S16] [Phosphor homepage repository](https://github.com/phosphor-icons/homepage)** — Documents Thin, Light, Regular, Bold, Fill, and Duotone weights; a useful multi-variant model, not a launch scope requirement.
