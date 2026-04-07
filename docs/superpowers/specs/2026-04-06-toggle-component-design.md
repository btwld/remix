# RemixToggle Component Design

## Overview

A toggle button component for Remix. Unlike `RemixSwitch` (a sliding on/off control), `RemixToggle` is a pressable button that stays visually active when selected — like bold/italic buttons in a toolbar.

Standalone only (no group support).

## Widget: `RemixToggle`

`StatelessWidget` wrapping `NakedToggle` from naked_ui.

### Constructor Parameters

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `selected` | `bool` | required | Current toggle state |
| `onChanged` | `ValueChanged<bool>` | required | Called when toggled |
| `enabled` | `bool` | `true` | Whether the toggle is interactive |
| `label` | `String?` | `null` | Optional text label |
| `icon` | `IconData?` | `null` | Optional icon |
| `style` | `RemixToggleStyle` | `const RemixToggleStyle.create()` | Style configuration |
| `enableFeedback` | `bool` | `true` | Haptic feedback on toggle |
| `focusNode` | `FocusNode?` | `null` | Focus management |
| `autofocus` | `bool` | `false` | Auto-request focus |
| `semanticLabel` | `String?` | `null` | Accessibility label |
| `mouseCursor` | `MouseCursor` | `SystemMouseCursors.click` | Hover cursor |

At least one of `label` or `icon` must be provided.

### Render Tree

```
NakedToggle
  └── StyleBuilder
        └── Box (container)
              └── Row (mainAxisSize: min)
                    ├── StyledIcon (if icon != null)
                    └── StyledText (if label != null)
```

When only icon or only label is provided, the Row contains a single child.

## Spec: `RemixToggleSpec`

Annotated with `@MixableSpec()`.

| Field | Type | Description |
|-------|------|-------------|
| `container` | `StyleSpec<BoxSpec>` | Outer container styling |
| `label` | `StyleSpec<TextSpec>` | Text label styling |
| `icon` | `StyleSpec<IconSpec>` | Icon styling |

## Style: `RemixToggleStyle`

Annotated with `@MixableStyler()`.

**Extends:** `RemixContainerStyle<RemixToggleSpec, RemixToggleStyle>`

**Mixins:**
- `SelectedWidgetStateVariantMixin` — `.onSelected()` for toggled-on state
- `LabelStyleMixin` — `.labelColor()`, `.labelFontSize()`, `.labelFontWeight()`, etc.
- `IconStyleMixin` — `.iconColor()`, `.iconSize()`, etc.
- `Diagnosticable`

**Fields (MixableField):**
- `$container` — `Prop<StyleSpec<BoxSpec>>?` (setter: `BoxStyler`)
- `$label` — `Prop<StyleSpec<TextSpec>>?` (setter: `TextStyler`)
- `$icon` — `Prop<StyleSpec<IconSpec>>?` (setter: `IconStyler`)

**Methods:**
- All inherited from `RemixContainerStyle` (`.padding()`, `.margin()`, `.backgroundColor()`, `.borderRadius()`, etc.)
- All from `LabelStyleMixin` and `IconStyleMixin`
- `.onSelected()` for selected-state styling
- `.alignment(Alignment)` override
- `.spacing(double)` — gap between icon and label
- `.call()` — creates a `RemixToggle` widget with this style applied
- Standard: `.animate()`, `.merge()`, `.resolve()`, `.variants()`, `.wrap()`

## Fortal Presets: `FortalToggleStyles`

### Enums

```dart
enum FortalToggleVariant { ghost, outline }
enum FortalToggleSize { size1, size2, size3 }
```

### Static Methods

- `.ghost({FortalToggleSize size})` — Borderless, subtle `gray3` background on hover, `accent3` background + `accent11` text/icon when selected
- `.outline({FortalToggleSize size})` — `gray7` border, `accent9` fill + `accentContrast` text/icon when selected
- `.create({required FortalToggleVariant variant, FortalToggleSize size})` — Factory
- `.base(FortalToggleSize size)` — Shared sizing: padding, border radius, font size, icon size

### Size Scale

| Size | Padding (H/V) | Border Radius | Font Size | Icon Size |
|------|---------------|---------------|-----------|-----------|
| `size1` | `space2` / `space1` | `radius2` | `text1` | 14 |
| `size2` | `space3` / `space2` | `radius2` | `text2` | 16 |
| `size3` | `space4` / `space2` | `radius3` | `text3` | 18 |

### Interaction States

All variants share:
- **Hover:** Subtle background shift
- **Pressed:** Slight scale down (0.97)
- **Focused:** Focus ring using `focus8` token
- **Disabled:** Reduced opacity, non-interactive
- **Selected:** Accent-colored fill/text (variant-specific)

## File Structure

```
packages/remix/lib/src/components/toggle/
├── toggle.dart                 # Library root with imports and parts
├── toggle_widget.dart          # RemixToggle StatelessWidget
├── toggle_style.dart           # RemixToggleStyle
├── toggle_spec.dart            # RemixToggleSpec
├── toggle.g.dart               # Generated (build_runner)
└── fortal_toggle_styles.dart   # FortalToggleStyles presets

packages/remix/test/components/toggle/
├── toggle_widget_test.dart     # Widget rendering and interaction tests
├── toggle_style_test.dart      # Style merging, variants, chaining tests
└── toggle_spec_test.dart       # Spec copyWith, lerp, equality tests
```

## Exports

Add to `packages/remix/lib/remix.dart`:
```dart
export 'src/components/toggle/toggle.dart';
```

Add to Fortal barrel export if applicable.

## Testing Strategy

**Widget tests:** Renders with label, icon, both. Toggles on tap. Respects `enabled`. Applies selected style. Accessibility semantics.

**Style tests:** Merge behavior. Variant application. Chainable methods. `.onSelected()` override.

**Spec tests:** `copyWith()`, `lerp()`, equality, `debugFillProperties`.
