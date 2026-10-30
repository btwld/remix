# Reference showcases

Separate **product examples** (real composition and interaction) from
**coverage galleries** (public variants, sizes and exceptional states). One app
may contain both, with distinct contracts.

## Product examples

Prefer Fortal presets and ordinary composition. Add an app-owned wrapper only
when it names a repeated product concept or centralizes a real policy, such as
a status badge, action menu, or disclosure affordance. A wrapper that merely
renames one Fortal constructor makes the example harder to learn from.

Use the extension points owned by the component:

- Build rich menu visuals with `RemixMenuTrigger.builder`, even when the menu
  is `FortalMenu`. The trigger is a configuration object, not a widget, and
  there is no separate `FortalMenuTrigger`.
- Build a disclosure indicator with `FortalDisclosure.triggerBuilder` and
  `state.isExpanded`. Return visual content, not another button; the
  disclosure keeps the interaction and semantics.
- Preserve Remix behavioral roots such as `RemixTabs` and
  `RemixAccordionGroup` around Fortal-styled children.

Keep repeated policy in the smallest app-owned component. Do not create a
parallel component library inside the example.

## Theme and contrast

Follow [theme/host placement](../SKILL.md#place-the-theme-scope). Resolve
showcase chrome from active tokens. A nested semantic accent should inherit
brightness, gray, radius, scaling and panel settings.

Built-in soft badges pass 4.5:1; review custom palettes separately. Use
`highContrast` for product content where warranted, preserve defaults in
variant matrices, and show a separate contrast axis when reviewing contrast.

## Coverage galleries

Derive axes from the public enum values whenever the gallery promises complete
coverage. Keep values, labels, and cells connected through typed data instead
of parallel lists:

<!-- dart-excerpt: GalleryMatrix is an app-owned gallery helper -->

```dart
GalleryMatrix<FortalButtonVariant, FortalButtonSize>(
  rows: FortalButtonVariant.values,
  columns: FortalButtonSize.values,
  rowLabelBuilder: (value) => value.name,
  columnLabelBuilder: (value) => value.name,
  cellBuilder: (context, variant, size) => FortalButton(
    variant: variant,
    size: size,
    onPressed: () {},
    label: 'Button',
  ),
)
```

`GalleryMatrix` is an app-owned helper, not a Remix API. Derive rows/columns
from enum values; runtime-selected variants belong in matrices, named
constructors in fixed product examples. Render underlying widgets directly so
wrappers cannot hide defaults. Use `GridBox` for two-dimensional comparisons
(see `mix`); a `Wrap` suits a single axis.

## Verification

- Assert or test that a matrix builds `rows.length * columns.length` specimen
  cells and derives its axes from the intended public enums.
- Exercise disabled, loading, validation, indeterminate, expanded, and
  interactive states separately when they are not enum axes.
- Give icon-only controls, menus, grouped choices, progress, and charts
  meaningful semantics; do not count visible text elsewhere as their label.
- Test custom menu and disclosure visuals through the supported builder APIs
  so a nested interactive trigger cannot regress in later refactors.
- Run the showcase in each supported brightness and with representative accent,
  gray, radius, and scaling settings. Nested accent scopes must inherit all
  unrelated settings.
- Confirm overlay and route content remains below the outer `FortalTheme` and
  has the required caller-owned `Overlay` or `Navigator`.
