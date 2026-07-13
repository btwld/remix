# Repository Agent Instructions

These instructions apply to the entire repository. Keep `CLAUDE.md` as a
pointer to this file instead of duplicating guidance there.

## Toolchain and workspace safety

- Use the Flutter version pinned by `.fvmrc`: run Flutter and Dart commands
  through `fvm`. The system Flutter may have an incompatible Dart SDK.
- Preserve unrelated and pre-existing working-tree changes. Do not discard,
  reformat, or commit work outside the requested scope.
- Run commands from the package they target unless a command explicitly
  operates on the workspace.
- Do not claim a change is complete from inspection alone. Run the relevant
  formatter check, analyzer, tests, and visual checks described below.

## Specimen design contract

`packages/mix_specimen` is a generic engine for static design-system specimen
sheets. It must depend on Mix, not Remix or Fortal.

- A specimen sheet is intentionally non-interactive. It exhaustively renders
  declared component appearances for human and AI review.
- Themes are separate sheets. Scenarios are columns. Appearance axes are rows.
- Keep axes generic. The engine may model `variant`, `size`, `density`, `tone`,
  or other consumer-defined axes, but must not define Fortal-specific enums or
  assume that every design system has size and variant axes.
- Axis and value IDs are stable machine-readable metadata. Labels are the
  corresponding human-readable text displayed in sheets.
- Axis declaration order controls presentation. With multiple row axes, all
  axes except the last form section groups; the last axis labels concrete rows.
- Preserve caller-declared row, scenario, specimen, and theme order. Do not
  silently sort visual output.
- Keep one golden image per component and theme. Do not replace reviewable
  component sheets with one enormous `all.png`.

Design-system catalogs belong to their consumer package, not the generic
engine. Definitions that will also power a live viewer must live under that
package's `lib/` tree; production code must not import a catalog from `test/`.

## Creating or extending a specimen

1. Inventory the component's public appearance inputs: variants, sizes,
   boolean/enum visual states, and relevant theme combinations.
2. Define generic row-axis metadata and generate the Cartesian product of the
   component's appearance values. Use stable row IDs such as
   `solid-size1` and explicit labels such as `Solid` and `Size 1`.
3. Choose scenario columns from the shared state sets, then add prop-driven
   scenarios such as loading or indeterminate only when they visibly change
   the component.
4. Force widget states with `WidgetStateProvider`, resolve the Mix style using
   the cell builder's context, and inject the resulting pre-resolved spec.
5. Audit the component's normal style-resolution path before injecting a spec.
   A pre-resolved spec bypasses private defaults. Mirror every required default
   in the specimen style—for example, `RemixButton` uses
   `MainAxisSize.min`, while `RemixSwitch` supplies thumb alignment.
6. Add the specimen to its catalog so golden tests and future viewers share
   one definition.
7. Regenerate the PNG, per-sheet JSON sidecar, and catalog index together.

Do not simulate hover or press with a real pointer when forced-state resolution
can render every state in one frame. Overlay components are an exception: spike
and document their capture behavior before adding them to ordinary sheets.

## Golden generation and comparison

The current Fortal artifacts live under `packages/playground/test/goldens/`.
The same convention applies to other consumer-owned catalogs.

Run golden updates in a single process on a configured baseline platform
(currently macOS):

```sh
cd packages/playground
fvm flutter test --update-goldens --reporter failures-only
fvm flutter test --reporter failures-only
```

Always run comparison mode immediately after update mode. Update mode proves
that artifacts can be generated; comparison mode proves that the committed
bytes are deterministic.

For engine changes, also run:

```sh
cd packages/mix_specimen
fvm dart format lib test --output=none --set-exit-if-changed
fvm flutter analyze --fatal-infos
fvm flutter test --reporter failures-only
```

For playground/catalog changes, run:

```sh
cd packages/playground
fvm dart format lib test --output=none --set-exit-if-changed
fvm flutter analyze --fatal-infos
fvm flutter test --reporter failures-only
```

If a Remix component's rendering or `styleSpec` path changes, also run the
Remix analyzer and full test suite:

```sh
cd packages/remix
fvm flutter analyze --fatal-infos
fvm flutter test --reporter failures-only
```

Validate generated metadata and repository hygiene:

```sh
find packages/playground/test/goldens -name '*.json' -print0 | xargs -0 -n1 jq empty
git diff --check
git status --short
```

Commit PNGs, JSON sidecars, and `catalog.json` together. Do not commit build
directories, tool caches, failure diffs, or other transient test output.

## Required visual review

Passing golden tests is necessary but not sufficient. Open every new or
changed PNG at original resolution and inspect it directly.

Check all of the following:

- Titles, section headers, row labels, and scenario columns are complete and
  aligned.
- No cell is clipped, overflowing, overlapping, or unexpectedly stretched.
- Real fonts and icons render; reject block glyphs, missing icons, or yellow
  debug underlines.
- Every declared size changes all intended dimensions. Check natural width,
  height, padding, typography, icon size, border radius, and indicator size—not
  merely one visible dimension.
- Default, hovered, pressed, focused, disabled, selected, loading, and other
  declared scenarios are visually correct and meaningfully distinct where the
  design specifies a difference.
- Light and dark sheets resolve their real theme tokens rather than recoloring
  one baseline mechanically.
- Animated content is captured at the fixed deterministic pump frame.
- The JSON sidecar row axes, row count, scenario order, props, and file name
  match the pixels being reviewed.

When showing screenshots in a Conductor response, embed the actual generated
PNG using an absolute local path so it renders inline, for example:

```markdown
![Button — light](</absolute/workspace/path/packages/playground/test/goldens/fortal-light/button.png>)
```

Label each image with its component and theme. If visual review finds a defect,
report it before presenting the screenshots as approved.

## Completion checklist

Before committing or handing off specimen work, confirm:

- The engine remains design-system agnostic.
- Catalog definitions are reusable by both tests and production viewers.
- Format checks and analyzers are clean.
- Engine and consumer tests pass.
- Golden update and immediate comparison both pass.
- Generated JSON parses and matches the sheet structure.
- Every changed screenshot has been reviewed at original resolution.
- `git diff --check` is clean and `git status` contains only intended files.

