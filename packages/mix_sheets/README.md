# mix_sheets

Static component sheets for Mix-based design systems. Renders every
variant × state combination of a component into a single contact-sheet
image — for human review, golden snapshots, and AI-agent validation.

Unlike Storybook/Widgetbook there are no knobs: nothing is interactive by
design. A sheet is an exhaustive, deterministic enumeration of what a
component can look like.

## How it works

Widget states (hover, pressed, focused, ...) are *forced*, not simulated:

1. Each sheet cell is wrapped in Mix's `WidgetStateProvider` carrying the
   scenario's states.
2. The cell builder resolves the component's styler under that provider
   (`cell.resolve(context, style)`), so `onHovered`/`onPressed`/... variants
   activate without any real interaction.
3. The resolved spec is handed to the component's `styleSpec` parameter,
   which renders it as-is and skips interaction-driven resolution.

This is what lets a sheet show *all* states side by side in one frame —
something gesture simulation (one mouse pointer per test) cannot do.

## Authoring

```dart
ComponentSheet(
  id: 'button',
  rowAxes: const [
    SheetAxis('variant', 'Variant'),
    SheetAxis('size', 'Size'),
  ],
  scenarios: [
    ...SheetScenarios.interactive,
    const SheetScenario('loading', props: {'loading': true}),
  ],
  rows: [
    SheetRow('solid-size1', (context, cell) => MyButton(
        label: 'Button',
        enabled: !cell.disabled,
        loading: cell.propOr('loading', false),
        onPressed: cell.disabled ? null : () {},
        styleSpec: cell.resolve(context, myButtonStyle()),
      ), values: const {
        'variant': SheetAxisValue('solid', 'Solid'),
        'size': SheetAxisValue('size1', 'Size 1'),
      }),
  ],
)
```

- **Row axes** are arbitrary ordered metadata such as variant, size, density,
  or tone. With one axis its value labels each row; with multiple axes every
  axis except the last creates nested section headers and the last labels rows.
- **Rows** map every declared axis ID to a `SheetAxisValue`. With no axes,
  the row ID remains the label for source compatibility.
- **Scenarios** are columns: forced `WidgetState`s plus prop overrides for
  states that are component properties rather than widget states
  (`loading`, `indeterminate`, ...).
- **Themes** (`SheetTheme`) are a sheet-level axis: one image per theme.
  `SheetCatalogViewer` renders the same list as a switcher.

## Live viewer

`SheetCatalogViewer` accepts exactly one catalog. Its controller normalizes
missing or invalid IDs to the first caller-declared sheet and theme, while
preserving declaration order for navigation and search. The selected theme is
applied only inside the non-interactive, two-axis scrolling canvas.

Use `SheetOverlayHost` around bounded overlay cells so real component
overlays use a local Navigator/Overlay and remain inside both the live sheet
and golden repaint boundary.

## Generating snapshots

```sh
flutter test --update-goldens        # generate/refresh sheets + sidecars
flutter test                         # compare against committed baselines
```

For a shared input to snapshots and a future viewer, create a
`SheetCatalog(id: ..., themes: ..., sheets: ...)` and register its tests
with `registerSheetCatalogGoldens(catalog)`. Golden updates also write a
deterministically ordered `goldens/catalog.json` index.

Output per component per theme:

```
test/goldens/fortal-light/button.png    # the contact sheet
test/goldens/fortal-light/button.json   # axes metadata (rows, columns, states)
test/goldens/catalog.json               # catalog index
```

Commit both. Visual regression review then *is* PR review: a styling change
shows up as a changed PNG in the diff.

Goldens are only generated/compared on the platforms in
`SheetGoldens.platforms` (default: macOS) because font rasterization
differs across OSes; other platforms skip the comparison. Set it in
`flutter_test_config.dart` to match where your team generates goldens,
and load real fonts there too:

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  configureSheetGoldenComparator();
  await loadSheetFonts();
  return testMain();
}
```

## AI-agent workflow

1. Read `catalog.json` to find component/theme artifacts.
2. Read the selected JSON sidecar to interpret stable IDs, labels, axes,
   scenarios, states, and props.
3. Open the referenced PNG at original resolution.
4. Use a deep-linked live viewer only as supplemental browser evidence.

## Current limitations

- Components must honor `styleSpec` and render a pre-resolved spec.
- Widget defaults baked privately into a component's build (e.g. switch
  thumb alignment) must be mirrored in the sheet's style, since
  `styleSpec` bypasses them.
- Overlay composites need deterministic public controller/initial-open APIs
  and must be hosted inside a bounded `SheetOverlayHost`.
