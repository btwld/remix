# RemixToggle Component Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Create a standalone toggle button component (`RemixToggle`) that stays visually active when selected, supporting icon, label, or both.

**Architecture:** Container-based approach using `RemixContainerStyle` with `NakedToggle` from naked_ui for accessible toggle behavior. Three spec fields: `container` (BoxSpec), `label` (TextSpec), `icon` (IconSpec). Fortal presets with `ghost` and `outline` variants at 3 sizes.

**Tech Stack:** Flutter, Mix (styling engine), mix_annotations + mix_generator (code generation), naked_ui (headless behavior), Fortal (design tokens)

---

## File Structure

| File | Action | Responsibility |
|------|--------|----------------|
| `packages/remix/lib/src/components/toggle/toggle.dart` | Create | Library root: imports, part declarations |
| `packages/remix/lib/src/components/toggle/toggle_spec.dart` | Create | `RemixToggleSpec` — immutable data holder with `container`, `label`, `icon` |
| `packages/remix/lib/src/components/toggle/toggle_style.dart` | Create | `RemixToggleStyle` — fluent style API extending `RemixContainerStyle` |
| `packages/remix/lib/src/components/toggle/toggle_widget.dart` | Create | `RemixToggle` — `StatelessWidget` wrapping `NakedToggle` |
| `packages/remix/lib/src/components/toggle/fortal_toggle_styles.dart` | Create | `FortalToggleStyles` — ghost/outline variants at 3 sizes |
| `packages/remix/lib/src/components/toggle/toggle.g.dart` | Generated | Code-generated mixins (build_runner) |
| `packages/remix/lib/remix.dart` | Modify | Add toggle export |
| `packages/remix/test/components/toggle/toggle_spec_test.dart` | Create | Spec tests |
| `packages/remix/test/components/toggle/toggle_style_test.dart` | Create | Style tests |
| `packages/remix/test/components/toggle/toggle_widget_test.dart` | Create | Widget tests |

---

### Task 1: Create toggle library root and spec

**Files:**
- Create: `packages/remix/lib/src/components/toggle/toggle.dart`
- Create: `packages/remix/lib/src/components/toggle/toggle_spec.dart`

- [ ] **Step 1: Create the toggle directory**

```bash
mkdir -p packages/remix/lib/src/components/toggle
```

- [ ] **Step 2: Create the library root file**

Create `packages/remix/lib/src/components/toggle/toggle.dart`:

```dart
library remix_toggle;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mix/mix.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:naked_ui/naked_ui.dart';

import '../../utilities/remix_style.dart';
import '../../fortal/fortal.dart';
import '../../utilities/selected_mixin.dart';
import '../../style/mixins/label_style_mixin.dart';
import '../../style/mixins/icon_style_mixin.dart';

part 'toggle_spec.dart';
part 'toggle_style.dart';
part 'toggle_widget.dart';
part 'fortal_toggle_styles.dart';
part 'toggle.g.dart';
```

- [ ] **Step 3: Create the spec file**

Create `packages/remix/lib/src/components/toggle/toggle_spec.dart`:

```dart
part of 'toggle.dart';

@MixableSpec()
class RemixToggleSpec extends Spec<RemixToggleSpec>
    with Diagnosticable, _$RemixToggleSpecMethods {
  @override
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;
  @override
  final StyleSpec<IconSpec> icon;

  const RemixToggleSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());
}
```

- [ ] **Step 4: Commit**

```bash
git add packages/remix/lib/src/components/toggle/toggle.dart packages/remix/lib/src/components/toggle/toggle_spec.dart
git commit -m "feat(toggle): add library root and spec"
```

---

### Task 2: Create toggle style

**Files:**
- Create: `packages/remix/lib/src/components/toggle/toggle_style.dart`

- [ ] **Step 1: Create the style file**

Create `packages/remix/lib/src/components/toggle/toggle_style.dart`:

```dart
part of 'toggle.dart';

@MixableStyler()
class RemixToggleStyle
    extends RemixContainerStyle<RemixToggleSpec, RemixToggleStyle>
    with
        LabelStyleMixin<RemixToggleStyle>,
        IconStyleMixin<RemixToggleStyle>,
        SelectedWidgetStateVariantMixin<RemixToggleSpec, RemixToggleStyle>,
        Diagnosticable,
        _$RemixToggleStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixToggleStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixToggleStyle({
    BoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixToggleSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container alignment.
  @override
  RemixToggleStyle alignment(Alignment value) {
    return merge(RemixToggleStyle(container: BoxStyler(alignment: value)));
  }

  /// Sets the background color.
  RemixToggleStyle backgroundColor(Color value) {
    return merge(
      RemixToggleStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets the foreground color (label and icon).
  RemixToggleStyle foregroundColor(Color value) {
    return labelColor(value).iconColor(value);
  }

  /// Sets the shape of the toggle.
  RemixToggleStyle shape(ShapeBorderMix value) {
    return merge(
      RemixToggleStyle(
        container: BoxStyler(decoration: ShapeDecorationMix(shape: value)),
      ),
    );
  }

  @override
  RemixToggleStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixToggleStyle(container: BoxStyler(padding: value)));
  }

  @override
  RemixToggleStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixToggleStyle(container: BoxStyler(margin: value)));
  }

  @override
  RemixToggleStyle decoration(DecorationMix value) {
    return merge(RemixToggleStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixToggleStyle constraints(BoxConstraintsMix value) {
    return merge(RemixToggleStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixToggleStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixToggleStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixToggleStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixToggleStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  /// Creates a [RemixToggle] widget with this style applied.
  RemixToggle call({
    required bool selected,
    required ValueChanged<bool> onChanged,
    String? label,
    IconData? icon,
    bool enabled = true,
    bool enableFeedback = true,
    FocusNode? focusNode,
    bool autofocus = false,
    String? semanticLabel,
    MouseCursor mouseCursor = SystemMouseCursors.click,
  }) {
    return RemixToggle(
      selected: selected,
      onChanged: onChanged,
      label: label,
      icon: icon,
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      mouseCursor: mouseCursor,
      style: this,
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add packages/remix/lib/src/components/toggle/toggle_style.dart
git commit -m "feat(toggle): add style class with fluent API"
```

---

### Task 3: Create toggle widget

**Files:**
- Create: `packages/remix/lib/src/components/toggle/toggle_widget.dart`

- [ ] **Step 1: Create the widget file**

Create `packages/remix/lib/src/components/toggle/toggle_widget.dart`:

```dart
part of 'toggle.dart';

/// A customizable toggle button component.
///
/// Unlike [RemixSwitch] which is a sliding on/off control,
/// [RemixToggle] is a pressable button that stays visually active when selected.
///
/// At least one of [label] or [icon] must be provided.
///
/// ## Example
///
/// ```dart
/// RemixToggle(
///   selected: _isBold,
///   onChanged: (value) {
///     setState(() {
///       _isBold = value;
///     });
///   },
///   label: 'Bold',
///   icon: Icons.format_bold,
/// )
/// ```
class RemixToggle extends StatelessWidget {
  const RemixToggle({
    super.key,
    this.enabled = true,
    required this.selected,
    required this.onChanged,
    this.label,
    this.icon,
    this.style = const RemixToggleStyle.create(),
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  }) : assert(
         label != null || icon != null,
         'At least one of label or icon must be provided',
       );

  /// Whether this toggle is enabled.
  final bool enabled;

  /// Whether the toggle is currently selected.
  final bool selected;

  /// Called when the user toggles the button.
  final ValueChanged<bool> onChanged;

  /// Optional text label.
  final String? label;

  /// Optional icon.
  final IconData? icon;

  /// The style configuration for the toggle.
  final RemixToggleStyle style;

  static final styleFrom = RemixToggleStyle.new;

  /// Whether to enable haptic feedback when toggled.
  final bool enableFeedback;

  /// The focus node for the toggle.
  final FocusNode? focusNode;

  /// Whether the toggle should automatically request focus when it is created.
  final bool autofocus;

  /// The semantic label for the toggle.
  final String? semanticLabel;

  /// Cursor when hovering over the toggle.
  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return NakedToggle(
      value: selected,
      onChanged: enabled ? onChanged : null,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      builder: (context, state, _) {
        return StyleBuilder(
          style: style,
          controller: NakedState.controllerOf(context),
          builder: (context, spec) {
            final children = <Widget>[
              if (icon != null) StyledIcon(icon: icon, styleSpec: spec.icon),
              if (label != null)
                StyledText(label!, styleSpec: spec.label),
            ];

            return Box(
              styleSpec: spec.container,
              child: children.length == 1
                  ? children.first
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    ),
            );
          },
        );
      },
    );
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add packages/remix/lib/src/components/toggle/toggle_widget.dart
git commit -m "feat(toggle): add widget wrapping NakedToggle"
```

---

### Task 4: Create Fortal toggle styles

**Files:**
- Create: `packages/remix/lib/src/components/toggle/fortal_toggle_styles.dart`

- [ ] **Step 1: Create the Fortal styles file**

Create `packages/remix/lib/src/components/toggle/fortal_toggle_styles.dart`:

```dart
part of 'toggle.dart';

enum FortalToggleSize { size1, size2, size3 }

enum FortalToggleVariant { ghost, outline }

/// Factory class for creating Fortal-compliant toggle styles.
class FortalToggleStyles {
  const FortalToggleStyles._();

  /// Factory constructor with variant and size parameters.
  static RemixToggleStyle create({
    FortalToggleVariant variant = .ghost,
    FortalToggleSize size = .size2,
  }) {
    return switch (variant) {
      .ghost => ghost(size: size),
      .outline => outline(size: size),
    };
  }

  /// Base sizing and shared styling.
  static RemixToggleStyle base({
    FortalToggleSize size = .size2,
  }) {
    return RemixToggleStyle()
        .foregroundColor(FortalTokens.gray12())
        .onFocused(
          RemixToggleStyle().borderAll(
            color: FortalTokens.focusA8(),
            width: FortalTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixToggleStyle()
              .backgroundColor(FortalTokens.grayA3())
              .foregroundColor(FortalTokens.gray8()),
        )
        .merge(_sizeStyle(size));
  }

  /// Ghost variant: borderless, subtle background on hover, accent on selected.
  static RemixToggleStyle ghost({
    FortalToggleSize size = .size2,
  }) {
    return base(size: size)
        .backgroundColor(Colors.transparent)
        .onHovered(
          RemixToggleStyle().backgroundColor(FortalTokens.grayA3()),
        )
        .onPressed(
          RemixToggleStyle().scale(0.97),
        )
        .onSelected(
          RemixToggleStyle()
              .backgroundColor(FortalTokens.accent3())
              .foregroundColor(FortalTokens.accent11()),
        );
  }

  /// Outline variant: border-based, accent fill when selected.
  static RemixToggleStyle outline({
    FortalToggleSize size = .size2,
  }) {
    return base(size: size)
        .backgroundColor(Colors.transparent)
        .borderAll(
          color: FortalTokens.gray7(),
          width: FortalTokens.borderWidth1(),
          strokeAlign: BorderSide.strokeAlignInside,
        )
        .onHovered(
          RemixToggleStyle().backgroundColor(FortalTokens.grayA3()),
        )
        .onPressed(
          RemixToggleStyle().scale(0.97),
        )
        .onSelected(
          RemixToggleStyle()
              .backgroundColor(FortalTokens.accent9())
              .foregroundColor(FortalTokens.accentContrast())
              .borderAll(color: FortalTokens.accent9()),
        );
  }

  // Internal size builder
  static RemixToggleStyle _sizeStyle(FortalToggleSize size) {
    return switch (size) {
      .size1 => RemixToggleStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.symmetric(
            horizontal: FortalTokens.space2(),
            vertical: FortalTokens.space1(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: FortalTokens.radius2(),
          ),
        ),
        label: TextStyler(style: TextStyleMix.ref(FortalTokens.text1)),
        icon: IconStyler(size: 14),
      ),
      .size2 => RemixToggleStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.symmetric(
            horizontal: FortalTokens.space3(),
            vertical: FortalTokens.space2(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: FortalTokens.radius2(),
          ),
        ),
        label: TextStyler(style: TextStyleMix.ref(FortalTokens.text2)),
        icon: IconStyler(size: 16),
      ),
      .size3 => RemixToggleStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.symmetric(
            horizontal: FortalTokens.space4(),
            vertical: FortalTokens.space2(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: FortalTokens.radius3(),
          ),
        ),
        label: TextStyler(style: TextStyleMix.ref(FortalTokens.text3)),
        icon: IconStyler(size: 18),
      ),
    };
  }
}
```

- [ ] **Step 2: Commit**

```bash
git add packages/remix/lib/src/components/toggle/fortal_toggle_styles.dart
git commit -m "feat(toggle): add Fortal ghost and outline presets"
```

---

### Task 5: Run code generation and add export

**Files:**
- Generated: `packages/remix/lib/src/components/toggle/toggle.g.dart`
- Modify: `packages/remix/lib/remix.dart`

- [ ] **Step 1: Run build_runner to generate toggle.g.dart**

```bash
cd packages/remix && flutter pub run build_runner build --delete-conflicting-outputs
```

Expected: Generates `toggle.g.dart` with `_$RemixToggleSpecMethods` and `_$RemixToggleStyleMixin` mixins.

- [ ] **Step 2: Verify the generated file exists**

```bash
ls packages/remix/lib/src/components/toggle/toggle.g.dart
```

Expected: File exists.

- [ ] **Step 3: Add the export to remix.dart**

In `packages/remix/lib/remix.dart`, add after the tooltip export line:

```dart
export 'src/components/toggle/toggle.dart';
```

- [ ] **Step 4: Verify the library compiles**

```bash
cd packages/remix && flutter analyze lib/src/components/toggle/
```

Expected: No errors.

- [ ] **Step 5: Commit**

```bash
git add packages/remix/lib/src/components/toggle/toggle.g.dart packages/remix/lib/remix.dart
git commit -m "feat(toggle): add generated code and barrel export"
```

---

### Task 6: Write spec tests

**Files:**
- Create: `packages/remix/test/components/toggle/toggle_spec_test.dart`

- [ ] **Step 1: Create test directory**

```bash
mkdir -p packages/remix/test/components/toggle
```

- [ ] **Step 2: Create the spec test file**

Create `packages/remix/test/components/toggle/toggle_spec_test.dart`:

```dart
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('RemixToggleSpec', () {
    group('Constructor', () {
      test('creates spec with default values when no parameters provided', () {
        const spec = RemixToggleSpec();

        expect(spec.container, isA<StyleSpec<BoxSpec>>());
        expect(spec.label, isA<StyleSpec<TextSpec>>());
        expect(spec.icon, isA<StyleSpec<IconSpec>>());
      });

      test('creates spec with provided parameters', () {
        final container = StyleSpec(spec: BoxSpec());
        final label = StyleSpec(spec: TextSpec());
        final icon = StyleSpec(spec: IconSpec());

        final spec = RemixToggleSpec(
          container: container,
          label: label,
          icon: icon,
        );

        expect(spec.container, equals(container));
        expect(spec.label, equals(label));
        expect(spec.icon, equals(icon));
      });
    });

    group('copyWith', () {
      test('returns new instance with updated properties', () {
        const originalSpec = RemixToggleSpec();
        final newContainer = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(container: newContainer);

        expect(updatedSpec, isNot(same(originalSpec)));
        expect(updatedSpec.container, equals(newContainer));
      });

      test('preserves immutability - original spec unchanged', () {
        const originalSpec = RemixToggleSpec();
        final originalContainer = originalSpec.container;
        final newContainer = StyleSpec(spec: BoxSpec());

        final updatedSpec = originalSpec.copyWith(container: newContainer);

        expect(originalSpec.container, equals(originalContainer));
        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.container, isNot(same(originalContainer)));
      });

      test('returns new instance with all properties updated', () {
        const originalSpec = RemixToggleSpec();
        final newContainer = StyleSpec(spec: BoxSpec());
        final newLabel = StyleSpec(spec: TextSpec());
        final newIcon = StyleSpec(spec: IconSpec());

        final updatedSpec = originalSpec.copyWith(
          container: newContainer,
          label: newLabel,
          icon: newIcon,
        );

        expect(updatedSpec.container, equals(newContainer));
        expect(updatedSpec.label, equals(newLabel));
        expect(updatedSpec.icon, equals(newIcon));
      });
    });

    group('lerp', () {
      test('returns spec equal to this when other is null', () {
        const spec = RemixToggleSpec();
        const RemixToggleSpec? other = null;

        final result = spec.lerp(other, 0.5);

        expect(result, equals(spec));
      });

      test('interpolates between two specs at t=0.0', () {
        final spec1 = RemixToggleSpec(
          container: StyleSpec(spec: BoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );
        final spec2 = RemixToggleSpec(
          container: StyleSpec(spec: BoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );

        final result = spec1.lerp(spec2, 0.0);

        expect(result, isNot(same(spec1)));
        expect(result.container, equals(spec1.container));
        expect(result.label, equals(spec1.label));
        expect(result.icon, equals(spec1.icon));
      });

      test('interpolates between two specs at t=1.0', () {
        final spec1 = RemixToggleSpec(
          container: StyleSpec(spec: BoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );
        final spec2 = RemixToggleSpec(
          container: StyleSpec(spec: BoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );

        final result = spec1.lerp(spec2, 1.0);

        expect(result, isNot(same(spec2)));
        expect(result.container, equals(spec2.container));
        expect(result.label, equals(spec2.label));
        expect(result.icon, equals(spec2.icon));
      });

      test('interpolates between two specs at t=0.5', () {
        final spec1 = RemixToggleSpec(
          container: StyleSpec(spec: BoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );
        final spec2 = RemixToggleSpec(
          container: StyleSpec(spec: BoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );

        final result = spec1.lerp(spec2, 0.5);

        expect(result, isNotNull);
        expect(result.container, isNotNull);
        expect(result.label, isNotNull);
        expect(result.icon, isNotNull);
      });
    });

    group('Equality and Props', () {
      test('two specs with same properties are equal', () {
        const spec1 = RemixToggleSpec();
        const spec2 = RemixToggleSpec();

        expect(spec1, equals(spec2));
        expect(spec1.hashCode, equals(spec2.hashCode));
      });

      test('two specs with different properties are not equal', () {
        final spec1 = RemixToggleSpec(
          container: StyleSpec(
            spec: const BoxSpec(),
            animation: AnimationConfig.linear(
              const Duration(milliseconds: 100),
            ),
          ),
        );
        final spec2 = RemixToggleSpec(
          container: StyleSpec(
            spec: const BoxSpec(),
            animation: AnimationConfig.linear(
              const Duration(milliseconds: 200),
            ),
          ),
        );

        expect(spec1, isNot(equals(spec2)));
      });

      test('props list contains all properties', () {
        const spec = RemixToggleSpec();

        expect(spec.props, hasLength(3));
        expect(spec.props, contains(spec.container));
        expect(spec.props, contains(spec.label));
        expect(spec.props, contains(spec.icon));
      });
    });

    group('Diagnostic Support', () {
      test('debugFillProperties works without throwing', () {
        const spec = RemixToggleSpec();

        expect(
          () => spec.debugFillProperties(DiagnosticPropertiesBuilder()),
          returnsNormally,
        );
      });

      test('can be converted to string for debugging', () {
        const spec = RemixToggleSpec();

        expect(spec.toString(), isA<String>());
        expect(spec.toString(), isNotEmpty);
      });
    });

    group('Edge Cases', () {
      test('copyWith handles null parameters correctly', () {
        const spec = RemixToggleSpec();
        final originalContainer = spec.container;

        final updatedSpec = spec.copyWith(container: null);

        expect(updatedSpec.container, equals(originalContainer));
      });

      test('handles empty StyleSpec', () {
        const spec = RemixToggleSpec(
          container: StyleSpec(spec: BoxSpec()),
          label: StyleSpec(spec: TextSpec()),
          icon: StyleSpec(spec: IconSpec()),
        );

        expect(spec.container, isNotNull);
        expect(spec.label, isNotNull);
        expect(spec.icon, isNotNull);
      });
    });

    group('Default Values', () {
      test('provides default values for all properties', () {
        const spec = RemixToggleSpec();

        expect(spec.container, isNotNull);
        expect(spec.label, isNotNull);
        expect(spec.icon, isNotNull);
      });
    });
  });
}
```

- [ ] **Step 3: Run spec tests**

```bash
cd packages/remix && flutter test test/components/toggle/toggle_spec_test.dart
```

Expected: All tests pass.

- [ ] **Step 4: Commit**

```bash
git add packages/remix/test/components/toggle/toggle_spec_test.dart
git commit -m "test(toggle): add spec tests"
```

---

### Task 7: Write style tests

**Files:**
- Create: `packages/remix/test/components/toggle/toggle_style_test.dart`

- [ ] **Step 1: Create the style test file**

Create `packages/remix/test/components/toggle/toggle_style_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_methods.dart';

void main() {
  group('RemixToggleStyle', () {
    group('Constructors', () {
      test('default constructor creates valid instance', () {
        final style = RemixToggleStyle();

        expect(style, isNotNull);
        expect(style, isA<RemixToggleStyle>());
      });

      test('create constructor with all parameters', () {
        final container = Prop.maybeMix(BoxStyler());
        final label = Prop.maybeMix(TextStyler());
        final icon = Prop.maybeMix(IconStyler());
        final variants = <VariantStyle<RemixToggleSpec>>[];

        final style = RemixToggleStyle.create(
          container: container,
          label: label,
          icon: icon,
          variants: variants,
        );

        expect(style, isNotNull);
        expect(style.$container, equals(container));
        expect(style.$label, equals(label));
        expect(style.$icon, equals(icon));
        expect(style.$variants, equals(variants));
      });

      test('constructor with styler parameters', () {
        final containerStyler = BoxStyler();
        final labelStyler = TextStyler();
        final iconStyler = IconStyler();

        final style = RemixToggleStyle(
          container: containerStyler,
          label: labelStyler,
          icon: iconStyler,
        );

        expect(style, isNotNull);
        expect(style.$container, isNotNull);
        expect(style.$label, isNotNull);
        expect(style.$icon, isNotNull);
      });
    });

    group('Style Methods', () {
      styleMethodTest(
        'alignment',
        initial: RemixToggleStyle(),
        modify: (style) => style.alignment(Alignment.center),
        expect: (style) {
          expect(
            style.$container,
            equals(Prop.maybeMix(BoxStyler(alignment: Alignment.center))),
          );
        },
      );

      styleMethodTest(
        'backgroundColor',
        initial: RemixToggleStyle(),
        modify: (style) => style.backgroundColor(Colors.blue),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(decoration: BoxDecorationMix(color: Colors.blue)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'padding',
        initial: RemixToggleStyle(),
        modify: (style) => style.padding(EdgeInsetsGeometryMix.all(16.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(padding: EdgeInsetsGeometryMix.all(16.0)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'margin',
        initial: RemixToggleStyle(),
        modify: (style) => style.margin(EdgeInsetsGeometryMix.all(8.0)),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(BoxStyler(margin: EdgeInsetsGeometryMix.all(8.0))),
            ),
          );
        },
      );

      styleMethodTest(
        'constraints',
        initial: RemixToggleStyle(),
        modify: (style) => style.constraints(
          BoxConstraintsMix(minWidth: 20.0, minHeight: 20.0),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  constraints: BoxConstraintsMix(
                    minWidth: 20.0,
                    minHeight: 20.0,
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'decoration',
        initial: RemixToggleStyle(),
        modify: (style) => style.decoration(
          BoxDecorationMix(
            color: Colors.blue,
            borderRadius: BorderRadiusMix.circular(8.0),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  decoration: BoxDecorationMix(
                    color: Colors.blue,
                    borderRadius: BorderRadiusMix.circular(8.0),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'foregroundDecoration',
        initial: RemixToggleStyle(),
        modify: (style) => style.foregroundDecoration(
          BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
          ),
        ),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  foregroundDecoration: BoxDecorationMix(
                    border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
                  ),
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'transform',
        initial: RemixToggleStyle(),
        modify: (style) =>
            style.transform(Matrix4.identity(), alignment: Alignment.topLeft),
        expect: (style) {
          expect(
            style.$container,
            equals(
              Prop.maybeMix(
                BoxStyler(
                  transform: Matrix4.identity(),
                  transformAlignment: Alignment.topLeft,
                ),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'labelColor',
        initial: RemixToggleStyle(),
        modify: (style) => style.labelColor(Colors.white),
        expect: (style) {
          expect(
            style.$label,
            equals(
              Prop.maybeMix(
                TextStyler(style: TextStyleMix(color: Colors.white)),
              ),
            ),
          );
        },
      );

      styleMethodTest(
        'iconColor',
        initial: RemixToggleStyle(),
        modify: (style) => style.iconColor(Colors.blue),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(color: Colors.blue))),
          );
        },
      );

      styleMethodTest(
        'iconSize',
        initial: RemixToggleStyle(),
        modify: (style) => style.iconSize(24.0),
        expect: (style) {
          expect(
            style.$icon,
            equals(Prop.maybeMix(IconStyler(size: 24.0))),
          );
        },
      );

      styleMethodTest(
        'variants',
        initial: RemixToggleStyle(),
        modify: (style) => style.variants(<VariantStyle<RemixToggleSpec>>[]),
        expect: (style) {
          expect(style.$variants, equals(<VariantStyle<RemixToggleSpec>>[]));
        },
      );

      styleMethodTest(
        'wrap',
        initial: RemixToggleStyle(),
        modify: (style) => style.wrap(WidgetModifierConfig.clipOval()),
        expect: (style) {
          expect(style.$modifier, equals(WidgetModifierConfig.clipOval()));
        },
      );

      styleMethodTest(
        'animate',
        initial: RemixToggleStyle(),
        modify: (style) =>
            style.animate(AnimationConfig.linear(const Duration(seconds: 1))),
        expect: (style) {
          expect(
            style.$animation,
            equals(AnimationConfig.linear(const Duration(seconds: 1))),
          );
        },
      );
    });

    group('Core Methods', () {
      testWidgets('resolve method returns StyleSpec', (
        WidgetTester tester,
      ) async {
        final style = RemixToggleStyle();

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                final spec = style.resolve(context);

                expect(spec, isA<StyleSpec<RemixToggleSpec>>());
                expect(spec.spec, isA<RemixToggleSpec>());
                expect(spec.spec.container, isA<StyleSpec<BoxSpec>>());
                expect(spec.spec.label, isA<StyleSpec<TextSpec>>());
                expect(spec.spec.icon, isA<StyleSpec<IconSpec>>());

                return Container();
              },
            ),
          ),
        );
      });

      test('merge with null returns style equal to original', () {
        final originalStyle = RemixToggleStyle();

        final mergedStyle = originalStyle.merge(null);

        expect(mergedStyle, equals(originalStyle));
      });

      test('merge combines properties correctly', () {
        final style1 = RemixToggleStyle(
          container: BoxStyler(alignment: Alignment.centerLeft),
        );
        final style2 = RemixToggleStyle(
          label: TextStyler(style: TextStyleMix(color: Colors.blue)),
        );

        final merged = style1.merge(style2);

        expect(
          merged.$container,
          equals(Prop.maybeMix(BoxStyler(alignment: Alignment.centerLeft))),
        );
        expect(
          merged.$label,
          equals(
            Prop.maybeMix(TextStyler(style: TextStyleMix(color: Colors.blue))),
          ),
        );
      });
    });

    group('Call Method', () {
      testWidgets('call method creates RemixToggle with all parameters', (
        tester,
      ) async {
        final style = RemixToggleStyle().backgroundColor(Colors.blue);
        final focusNode = FocusNode();

        final toggleWidget = style.call(
          selected: true,
          onChanged: (value) {},
          label: 'Bold',
          icon: Icons.format_bold,
          enabled: false,
          enableFeedback: false,
          focusNode: focusNode,
          autofocus: true,
          semanticLabel: 'Test Toggle',
          mouseCursor: SystemMouseCursors.forbidden,
        );

        expect(toggleWidget, isA<RemixToggle>());
        expect(toggleWidget.selected, equals(true));
        expect(toggleWidget.label, equals('Bold'));
        expect(toggleWidget.icon, equals(Icons.format_bold));
        expect(toggleWidget.enabled, equals(false));
        expect(toggleWidget.enableFeedback, equals(false));
        expect(toggleWidget.focusNode, same(focusNode));
        expect(toggleWidget.autofocus, equals(true));
        expect(toggleWidget.semanticLabel, equals('Test Toggle'));
        expect(toggleWidget.mouseCursor, equals(SystemMouseCursors.forbidden));
        expect(toggleWidget.style, same(style));

        focusNode.dispose();
      });

      testWidgets('call method creates RemixToggle with minimal parameters', (
        tester,
      ) async {
        final style = RemixToggleStyle();

        final toggleWidget = style.call(
          selected: false,
          onChanged: (v) {},
          label: 'Test',
        );

        expect(toggleWidget, isA<RemixToggle>());
        expect(toggleWidget.selected, equals(false));
        expect(toggleWidget.enabled, equals(true));
        expect(toggleWidget.enableFeedback, equals(true));
        expect(toggleWidget.style, same(style));
      });
    });

    group('Equality', () {
      test('identical styles are equal', () {
        final style1 = RemixToggleStyle();
        final style2 = RemixToggleStyle();

        expect(style1, equals(style2));
        expect(style1.hashCode, equals(style2.hashCode));
      });

      test('styles with different properties are not equal', () {
        final style1 = RemixToggleStyle().backgroundColor(Colors.blue);
        final style2 = RemixToggleStyle().backgroundColor(Colors.red);

        expect(style1, isNot(equals(style2)));
      });

      test('props list contains all properties', () {
        final style = RemixToggleStyle();

        expect(style.props, hasLength(6));
        expect(style.props, contains(style.$container));
        expect(style.props, contains(style.$label));
        expect(style.props, contains(style.$icon));
        expect(style.props, contains(style.$variants));
        expect(style.props, contains(style.$animation));
        expect(style.props, contains(style.$modifier));
      });
    });
  });
}
```

- [ ] **Step 2: Run style tests**

```bash
cd packages/remix && flutter test test/components/toggle/toggle_style_test.dart
```

Expected: All tests pass.

- [ ] **Step 3: Commit**

```bash
git add packages/remix/test/components/toggle/toggle_style_test.dart
git commit -m "test(toggle): add style tests"
```

---

### Task 8: Write widget tests

**Files:**
- Create: `packages/remix/test/components/toggle/toggle_widget_test.dart`

- [ ] **Step 1: Create the widget test file**

Create `packages/remix/test/components/toggle/toggle_widget_test.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixToggle', () {
    group('Basic Rendering', () {
      testWidgets('renders toggle with label only', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
        expect(find.text('Bold'), findsOneWidget);
      });

      testWidgets('renders toggle with icon only', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            icon: Icons.format_bold,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('renders toggle with both icon and label', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            icon: Icons.format_bold,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
        expect(find.text('Bold'), findsOneWidget);
      });

      testWidgets('renders in selected state', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: true,
            onChanged: (value) {},
            label: 'Bold',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('renders with custom style', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: RemixToggleStyle().backgroundColor(Colors.blue),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('calls onChanged when tapped', (tester) async {
        bool wasChanged = false;
        bool newValue = false;

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {
              wasChanged = true;
              newValue = value;
            },
            label: 'Bold',
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixToggle));
        await tester.pumpAndSettle();

        expect(wasChanged, isTrue);
        expect(newValue, isTrue);
      });

      testWidgets('toggles between states', (tester) async {
        bool toggleValue = false;

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return RemixToggle(
                selected: toggleValue,
                onChanged: (value) {
                  setState(() {
                    toggleValue = value;
                  });
                },
                label: 'Bold',
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(toggleValue, isFalse);

        await tester.tap(find.byType(RemixToggle));
        await tester.pumpAndSettle();

        expect(toggleValue, isTrue);

        await tester.tap(find.byType(RemixToggle));
        await tester.pumpAndSettle();

        expect(toggleValue, isFalse);
      });

      testWidgets('does not call onChanged when disabled', (tester) async {
        bool wasChanged = false;

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {
              wasChanged = true;
            },
            label: 'Bold',
            enabled: false,
          ),
        );
        await tester.pumpAndSettle();

        await tester.tap(find.byType(RemixToggle));
        await tester.pumpAndSettle();

        expect(wasChanged, isFalse);
      });
    });

    group('Focus', () {
      testWidgets('accepts focusNode parameter', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            focusNode: focusNode,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
        focusNode.dispose();
      });

      testWidgets('handles autofocus parameter', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            autofocus: true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('can request focus programmatically', (tester) async {
        final focusNode = FocusNode();

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            focusNode: focusNode,
          ),
        );
        await tester.pumpAndSettle();

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isTrue);
        focusNode.dispose();
      });
    });

    group('Styling', () {
      testWidgets('applies padding styling', (tester) async {
        final customStyle = RemixToggleStyle().padding(
          EdgeInsetsGeometryMix.all(16.0),
        );

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('applies multiple style methods', (tester) async {
        final customStyle = RemixToggleStyle()
            .backgroundColor(Colors.blue)
            .labelColor(Colors.white)
            .iconColor(Colors.white)
            .padding(EdgeInsetsGeometryMix.all(8.0))
            .decoration(
              BoxDecorationMix(
                borderRadius: BorderRadiusMix.circular(8.0),
              ),
            );

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            icon: Icons.format_bold,
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('applies animation config', (tester) async {
        final customStyle = RemixToggleStyle().animate(
          AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Fortal Styles', () {
      testWidgets('renders with ghost variant', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: FortalToggleStyles.ghost(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('renders with outline variant', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            style: FortalToggleStyles.outline(),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });

      testWidgets('renders with all sizes', (tester) async {
        for (final size in FortalToggleSize.values) {
          await tester.pumpRemixApp(
            RemixToggle(
              selected: false,
              onChanged: (value) {},
              label: 'Bold',
              style: FortalToggleStyles.ghost(size: size),
            ),
          );
          await tester.pumpAndSettle();

          expect(find.byType(RemixToggle), findsOneWidget);
        }
      });

      testWidgets('create factory works for all variant/size combos', (
        tester,
      ) async {
        for (final variant in FortalToggleVariant.values) {
          for (final size in FortalToggleSize.values) {
            await tester.pumpRemixApp(
              RemixToggle(
                selected: false,
                onChanged: (value) {},
                label: 'Bold',
                style: FortalToggleStyles.create(
                  variant: variant,
                  size: size,
                ),
              ),
            );
            await tester.pumpAndSettle();

            expect(find.byType(RemixToggle), findsOneWidget);
          }
        }
      });
    });

    group('Semantics and Accessibility', () {
      testWidgets('accepts semanticLabel parameter', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            semanticLabel: 'Toggle bold formatting',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Mouse Cursor', () {
      testWidgets('accepts mouseCursor parameter', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            mouseCursor: SystemMouseCursors.forbidden,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Haptic Feedback', () {
      testWidgets('handles disabled feedback', (tester) async {
        await tester.pumpRemixApp(
          RemixToggle(
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
            enableFeedback: false,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('Key Parameter', () {
      testWidgets('accepts and respects key parameter', (tester) async {
        const key = ValueKey('toggle_key');

        await tester.pumpRemixApp(
          RemixToggle(
            key: key,
            selected: false,
            onChanged: (value) {},
            label: 'Bold',
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(key), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles rapid toggling', (tester) async {
        bool toggleValue = false;

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return RemixToggle(
                selected: toggleValue,
                onChanged: (value) {
                  setState(() {
                    toggleValue = value;
                  });
                },
                label: 'Bold',
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        for (int i = 0; i < 10; i++) {
          await tester.tap(find.byType(RemixToggle));
          await tester.pump();
        }
        await tester.pumpAndSettle();

        expect(find.byType(RemixToggle), findsOneWidget);
      });
    });

    group('State Changes', () {
      testWidgets('updates when selected value changes programmatically', (
        tester,
      ) async {
        bool toggleValue = false;

        await tester.pumpRemixApp(
          StatefulBuilder(
            builder: (context, setState) {
              return Column(
                children: [
                  RemixToggle(
                    selected: toggleValue,
                    onChanged: (value) {
                      setState(() {
                        toggleValue = value;
                      });
                    },
                    label: 'Bold',
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        toggleValue = !toggleValue;
                      });
                    },
                    child: const Text('Toggle Programmatically'),
                  ),
                ],
              );
            },
          ),
        );
        await tester.pumpAndSettle();

        expect(toggleValue, isFalse);

        await tester.tap(find.text('Toggle Programmatically'));
        await tester.pumpAndSettle();

        expect(toggleValue, isTrue);
      });
    });
  });
}
```

- [ ] **Step 2: Run widget tests**

```bash
cd packages/remix && flutter test test/components/toggle/toggle_widget_test.dart
```

Expected: All tests pass.

- [ ] **Step 3: Commit**

```bash
git add packages/remix/test/components/toggle/toggle_widget_test.dart
git commit -m "test(toggle): add widget tests"
```

---

### Task 9: Run full test suite and verify

- [ ] **Step 1: Run all toggle tests**

```bash
cd packages/remix && flutter test test/components/toggle/
```

Expected: All tests pass.

- [ ] **Step 2: Run the full project analysis**

```bash
cd packages/remix && flutter analyze
```

Expected: No analysis errors.

- [ ] **Step 3: Final commit if any cleanup needed**

Only if changes were needed during verification.
