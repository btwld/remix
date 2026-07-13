# mix_specimen

Static specimen sheets for Mix-based design systems. Renders every
variant × state combination of a component into a single contact-sheet
image — for human review, golden snapshots, and AI-agent validation.

Unlike Storybook/Widgetbook there are no knobs: nothing is interactive by
design. A specimen is an exhaustive, deterministic enumeration of what a
component can look like.

## How it works

Widget states (hover, pressed, focused, ...) are *forced*, not simulated:

1. Each sheet cell is wrapped in Mix's `WidgetStateProvider` carrying the
   scenario's states.
2. The cell builder resolves the component's styler under that provider
   (`sim.resolve(context, style)`), so `onHovered`/`onPressed`/... variants
   activate without any real interaction.
3. The resolved spec is handed to the component's `styleSpec` parameter,
   which renders it as-is and skips interaction-driven resolution.

This is what lets a sheet show *all* states side by side in one frame —
something gesture simulation (one mouse pointer per test) cannot do.

## Authoring

```dart
Specimen(
  id: 'button',
  rowAxes: const [
    SpecimenAxis('variant', 'Variant'),
    SpecimenAxis('size', 'Size'),
  ],
  scenarios: [
    ...Scenarios.interactive, // default / hovered / pressed / focused / disabled
    const SpecimenScenario('loading', props: {'loading': true}),
  ],
  rows: [
    SpecimenRow('solid-size1', (context, sim) => MyButton(
        label: 'Button',
        enabled: !sim.disabled,
        loading: sim.propOr('loading', false),
        onPressed: sim.disabled ? null : () {},
        styleSpec: sim.resolve(context, myButtonStyle()),
      ), values: const {
        'variant': SpecimenAxisValue('solid', 'Solid'),
        'size': SpecimenAxisValue('size1', 'Size 1'),
      }),
  ],
)
```

- **Row axes** are arbitrary ordered metadata such as variant, size, density,
  or tone. With one axis its value labels each row; with multiple axes every
  axis except the last creates nested section headers and the last labels rows.
- **Rows** map every declared axis ID to a `SpecimenAxisValue`. With no axes,
  the row ID remains the label for source compatibility.
- **Scenarios** are columns: forced `WidgetState`s plus prop overrides for
  states that are component properties rather than widget states
  (`loading`, `indeterminate`, ...).
- **Themes** (`SpecimenTheme`) are a sheet-level axis: one image per theme.
  A live gallery can render the same list as a switcher.

## Generating snapshots

```sh
flutter test --update-goldens        # generate/refresh sheets + sidecars
flutter test                         # compare against committed baselines
```

For a shared input to snapshots and a future viewer, create a
`SpecimenCatalog(id: ..., themes: ..., specimens: ...)` and register its tests
with `registerSpecimenCatalogGoldens(catalog)`. Golden updates also write a
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
`SpecimenGoldens.platforms` (default: macOS) because font rasterization
differs across OSes; other platforms skip the comparison. Set it in
`flutter_test_config.dart` to match where your team generates goldens,
and load real fonts there too:

```dart
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  configureSpecimenGoldenComparator();
  await loadSpecimenFonts();
  return testMain();
}
```

## AI-agent workflow

1. Run `flutter test --update-goldens`.
2. `git status` / `git diff --stat` — only changed sheets need review.
3. Read the changed PNGs; use the JSON sidecar to interpret the grid
   (row/column order, which states each column forces).

## Current limitations

- Components must honor `styleSpec` (render a pre-resolved spec). Remix
  button/checkbox/switch do; components that ignore it can't be forced.
- Widget defaults baked privately into a component's build (e.g. switch
  thumb alignment) must be mirrored in the specimen's style, since
  `styleSpec` bypasses them.
- Overlay composites (select popover, tooltip) need a forced-states scope
  in `naked_ui` to specimen their open states; planned upstream.
