import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';
import 'package:remix/remix.dart';

import 'support.dart';

/// Vanilla's component targets as data: the enforced half of
/// `registry_source/specs/vanilla.md`.
///
/// Each [SpecTarget] resolves one recipe, reads one property, and names the
/// value shadcn gives it. `spec_conformance_test.dart` runs every target in
/// both themes.
///
/// A target belongs to the pull request that moves its recipe onto the spec
/// (`E` for the interaction layer, `F1`–`F5` for the component sweep). It is
/// checked once that phase is listed in [enforcedPhases]; until then it is
/// reported as skipped, so the distance to the spec stays visible.
const enforcedPhases = <String>{'E', 'F1', 'F2'};

/// One measured property of one resolved recipe.
final class SpecTarget {
  const SpecTarget._({
    required this.component,
    required this.property,
    required this.source,
    required this.phase,
    required this.actual,
    required this.expected,
  });

  /// The component, as `registry_source/specs/vanilla.md` names it.
  final String component;

  /// What is measured.
  final String property;

  /// The shadcn file and classes the target comes from.
  final String source;

  /// The pull request that enforces this target.
  final String phase;

  /// Resolves the recipe under a theme and reads the property.
  final Future<Object?> Function(WidgetTester tester, VanillaThemeData theme)
  actual;

  /// The target value, or a matcher, under a theme.
  final Object? Function(VanillaThemeData theme) expected;

  /// Whether [phase] has landed.
  bool get isEnforced => enforcedPhases.contains(phase);
}

SpecTarget _target<S extends Spec<S>>(
  String component,
  String property, {
  required String source,
  required String phase,
  required Style<S> Function() style,
  Set<WidgetState> states = const {},
  required Object? Function(StyleSpec<S> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => SpecTarget._(
  component: component,
  property: property,
  source: source,
  phase: phase,
  actual: (tester, theme) async =>
      read(await resolveVanilla(tester, style(), theme: theme, states: states)),
  expected: expected,
);

SpecTarget _pumped<S extends Spec<S>>(
  String component,
  String property, {
  required String source,
  required String phase,
  required Widget Function() widget,
  required Object? Function(StyleSpec<S> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => SpecTarget._(
  component: component,
  property: property,
  source: source,
  phase: phase,
  actual: (tester, theme) async =>
      read(await pumpedSpec<S>(tester, widget(), theme: theme)),
  expected: expected,
);

bool _isDark(VanillaThemeData theme) => theme.brightness == Brightness.dark;

Radius _radius(VanillaThemeData theme, RadiusToken step) =>
    tokenOf(theme, step);

BorderRadius _rounded(VanillaThemeData theme, RadiusToken step) =>
    BorderRadius.all(_radius(theme, step));

/// shadcn's focus ring: a 3px band of `ring` at 50%, with no offset.
BorderSide _focusRing(VanillaThemeData theme) =>
    BorderSide(color: tint(theme.ring, 0.5), width: 3);

/// A hairline border in [color] on every side.
Border _hairline(Color color) => Border.all(color: color, width: 1);

/// A form control's fill: transparent, or `dark:bg-input/30`.
Color _fieldFill(VanillaThemeData theme) =>
    tint(theme.input, _isDark(theme) ? 0.3 : 0);

/// The destructive fill at rest, `dark:bg-destructive/60`.
Color _destructiveFill(VanillaThemeData theme) =>
    tint(theme.destructive, _isDark(theme) ? 0.6 : 1);

// -- button -------------------------------------------------------------------

SpecTarget _button(
  String property, {
  VanillaButtonVariant variant = .primary,
  VanillaButtonSize size = .medium,
  Set<WidgetState> states = const {},
  String phase = 'F1',
  String source = 'button.tsx',
  required Object? Function(StyleSpec<ButtonSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<ButtonSpec>(
  'button',
  property,
  source: source,
  phase: phase,
  style: () => vanillaButtonStyle(variant: variant, size: size),
  states: states,
  read: read,
  expected: expected,
);

BoxDecoration? _buttonDecoration(StyleSpec<ButtonSpec> spec) =>
    flexDecorationOf(spec.spec.container);

final _buttonTargets = <SpecTarget>[
  for (final (size, height, paddingX, gap) in const [
    (VanillaButtonSize.small, 32.0, 12.0, 6.0),
    (VanillaButtonSize.medium, 36.0, 16.0, 8.0),
    (VanillaButtonSize.large, 40.0, 24.0, 8.0),
  ]) ...[
    _button(
      '${size.name} height',
      size: size,
      source: 'button.tsx: h-8 / h-9 / h-10',
      read: (spec) => boxOf(spec.spec.container)?.constraints?.minHeight,
      expected: (_) => height,
    ),
    _button(
      '${size.name} padding',
      size: size,
      source: 'button.tsx: px-3 / px-4 / px-6',
      read: (spec) => boxOf(spec.spec.container)?.padding,
      expected: (_) => EdgeInsets.symmetric(horizontal: paddingX),
    ),
    _button(
      '${size.name} gap',
      size: size,
      source: 'button.tsx: gap-1.5 / gap-2',
      read: (spec) => flexOf(spec.spec.container)?.spacing,
      expected: (_) => gap,
    ),
    _button(
      '${size.name} label is text-sm',
      size: size,
      source: 'button.tsx: text-sm',
      read: (spec) => spec.spec.label.spec.style?.fontSize,
      expected: (_) => 14.0,
    ),
    _button(
      '${size.name} icon is size-4',
      size: size,
      source: 'button.tsx: [&_svg]:size-4',
      read: (spec) => spec.spec.icon.spec.size,
      expected: (_) => 16.0,
    ),
  ],
  _button(
    'label line height',
    source: 'button.tsx: text-sm (20px line)',
    read: (spec) {
      final style = spec.spec.label.spec.style;
      return style?.height == null ? null : style!.height! * style.fontSize!;
    },
    expected: (_) => closeTo(20, 1e-9),
  ),
  _button(
    'label weight',
    source: 'button.tsx: font-medium',
    read: (spec) => spec.spec.label.spec.style?.fontWeight,
    expected: (_) => FontWeight.w500,
  ),
  _button(
    'radius',
    source: 'button.tsx: rounded-md',
    read: (spec) => _buttonDecoration(spec)?.borderRadius,
    expected: (theme) => _rounded(theme, VanillaTokens.radiusMd),
  ),
  _button(
    'primary hover',
    states: const {WidgetState.hovered},
    source: 'button.tsx: hover:bg-primary/90',
    read: (spec) => _buttonDecoration(spec)?.color,
    expected: (theme) => tint(theme.primary, 0.9),
  ),
  _button(
    'secondary hover',
    variant: .secondary,
    states: const {WidgetState.hovered},
    source: 'button.tsx: hover:bg-secondary/80',
    read: (spec) => _buttonDecoration(spec)?.color,
    expected: (theme) => tint(theme.secondary, 0.8),
  ),
  _button(
    'destructive fill',
    variant: .destructive,
    source: 'button.tsx: bg-destructive dark:bg-destructive/60',
    read: (spec) => _buttonDecoration(spec)?.color,
    expected: _destructiveFill,
  ),
  _button(
    'ghost hover',
    variant: .ghost,
    states: const {WidgetState.hovered},
    source: 'button.tsx: hover:bg-accent dark:hover:bg-accent/50',
    read: (spec) => _buttonDecoration(spec)?.color,
    expected: (theme) => tint(theme.accent, _isDark(theme) ? 0.5 : 1),
  ),
  _button(
    'outline border',
    variant: .outline,
    source: 'button.tsx: border dark:border-input',
    read: (spec) => _buttonDecoration(spec)?.border,
    expected: (theme) => _hairline(theme.input),
  ),
  _button(
    'outline fill',
    variant: .outline,
    source: 'button.tsx: bg-background',
    read: (spec) => _buttonDecoration(spec)?.color,
    expected: (theme) => theme.background,
  ),
  _button(
    'outline shadow',
    variant: .outline,
    source: 'button.tsx: shadow-xs',
    read: (spec) => _buttonDecoration(spec)?.boxShadow,
    expected: (_) => VanillaShadow.xs.shadows,
  ),
  _button(
    'outline hover',
    variant: .outline,
    states: const {WidgetState.hovered},
    source: 'button.tsx: hover:bg-accent',
    read: (spec) => _buttonDecoration(spec)?.color,
    expected: (theme) => theme.accent,
  ),
  _button(
    'focus ring',
    states: const {WidgetState.focused},
    phase: 'E',
    source: 'button.tsx: focus-visible:ring-[3px] ring-ring/50',
    read: (spec) => spec.spec.containerEffects?.outline,
    expected: _focusRing,
  ),
  _button(
    'focus ring has no offset',
    states: const {WidgetState.focused},
    phase: 'E',
    source: 'button.tsx: focus-visible:ring-[3px]',
    read: (spec) => spec.spec.containerEffects?.outlineOffset,
    expected: (_) => 0.0,
  ),
  _button(
    'outline focus border',
    variant: .outline,
    states: const {WidgetState.focused},
    phase: 'E',
    source: 'button.tsx: focus-visible:border-ring',
    read: (spec) => _buttonDecoration(spec)?.border,
    expected: (theme) => _hairline(theme.ring),
  ),
  _button(
    'transition',
    phase: 'E',
    source: 'button.tsx: transition-all (150ms ease)',
    read: (spec) => spec.animation,
    expected: (_) => VanillaMotion.standard,
  ),
];

// -- icon button --------------------------------------------------------------

SpecTarget _iconButton(
  String property, {
  VanillaIconButtonVariant variant = .primary,
  VanillaIconButtonSize size = .medium,
  Set<WidgetState> states = const {},
  String phase = 'F1',
  required String source,
  required Object? Function(StyleSpec<IconButtonSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<IconButtonSpec>(
  'icon button',
  property,
  source: source,
  phase: phase,
  style: () => vanillaIconButtonStyle(variant: variant, size: size),
  states: states,
  read: read,
  expected: expected,
);

final _iconButtonTargets = <SpecTarget>[
  for (final (size, edge) in const [
    (VanillaIconButtonSize.small, 32.0),
    (VanillaIconButtonSize.medium, 36.0),
    (VanillaIconButtonSize.large, 40.0),
  ]) ...[
    _iconButton(
      '${size.name} square',
      size: size,
      source: 'button.tsx: size-8 / size-9 / size-10',
      read: (spec) => spec.spec.container.spec.constraints,
      expected: (_) => BoxConstraints.tight(Size.square(edge)),
    ),
    _iconButton(
      '${size.name} icon is size-4',
      size: size,
      source: 'button.tsx: [&_svg]:size-4',
      read: (spec) => spec.spec.icon.spec.size,
      expected: (_) => 16.0,
    ),
  ],
  _iconButton(
    'destructive fill',
    variant: .destructive,
    source: 'button.tsx: bg-destructive dark:bg-destructive/60',
    read: (spec) => decorationOf(spec.spec.container)?.color,
    expected: _destructiveFill,
  ),
  _iconButton(
    'secondary hover',
    variant: .secondary,
    states: const {WidgetState.hovered},
    source: 'button.tsx: hover:bg-secondary/80',
    read: (spec) => decorationOf(spec.spec.container)?.color,
    expected: (theme) => tint(theme.secondary, 0.8),
  ),
  _iconButton(
    'ghost hover',
    variant: .ghost,
    states: const {WidgetState.hovered},
    source: 'button.tsx: hover:bg-accent dark:hover:bg-accent/50',
    read: (spec) => decorationOf(spec.spec.container)?.color,
    expected: (theme) => tint(theme.accent, _isDark(theme) ? 0.5 : 1),
  ),
  _iconButton(
    'outline border',
    variant: .outline,
    source: 'button.tsx: border dark:border-input',
    read: (spec) => decorationOf(spec.spec.container)?.border,
    expected: (theme) => _hairline(theme.input),
  ),
  _iconButton(
    'outline shadow',
    variant: .outline,
    source: 'button.tsx: shadow-xs',
    read: (spec) => decorationOf(spec.spec.container)?.boxShadow,
    expected: (_) => VanillaShadow.xs.shadows,
  ),
  _iconButton(
    'focus ring',
    states: const {WidgetState.focused},
    phase: 'E',
    source: 'button.tsx: focus-visible:ring-[3px] ring-ring/50',
    read: (spec) => spec.spec.containerEffects?.outline,
    expected: _focusRing,
  ),
  _iconButton(
    'transition',
    phase: 'E',
    source: 'button.tsx: transition-all',
    read: (spec) => spec.animation,
    expected: (_) => VanillaMotion.standard,
  ),
];

// -- link ---------------------------------------------------------------------

SpecTarget _link(
  String property, {
  Set<WidgetState> states = const {},
  String phase = 'F1',
  required String source,
  required Object? Function(StyleSpec<LinkSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<LinkSpec>(
  'link',
  property,
  source: source,
  phase: phase,
  style: vanillaLinkStyle,
  states: states,
  read: read,
  expected: expected,
);

final _linkTargets = <SpecTarget>[
  _link(
    'label is text-sm',
    source: 'button.tsx: link, text-sm',
    read: (spec) => spec.spec.label.spec.style?.fontSize,
    expected: (_) => 14.0,
  ),
  _link(
    'color',
    source: 'button.tsx: link, text-primary',
    read: (spec) => spec.spec.label.spec.style?.color,
    expected: (theme) => theme.primary,
  ),
  _link(
    'no underline at rest',
    source: 'button.tsx: link, underline-offset-4',
    read: (spec) => spec.spec.label.spec.style?.decoration,
    expected: (_) => anyOf(isNull, TextDecoration.none),
  ),
  _link(
    'underline on hover',
    states: const {WidgetState.hovered},
    source: 'button.tsx: link, hover:underline',
    read: (spec) => spec.spec.label.spec.style?.decoration,
    expected: (_) => TextDecoration.underline,
  ),
];

// -- badge --------------------------------------------------------------------

SpecTarget _badge(
  String property, {
  VanillaBadgeVariant variant = .primary,
  required String source,
  required Object? Function(StyleSpec<BadgeSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<BadgeSpec>(
  'badge',
  property,
  source: source,
  phase: 'F1',
  style: () => vanillaBadgeStyle(variant: variant),
  read: read,
  expected: expected,
);

final _badgeTargets = <SpecTarget>[
  _badge(
    'radius',
    source: 'badge.tsx: rounded-full',
    read: (spec) => decorationOf(spec.spec.container)?.borderRadius,
    expected: (_) => isFullyRounded,
  ),
  _badge(
    'padding',
    source: 'badge.tsx: px-2 py-0.5',
    read: (spec) => spec.spec.container.spec.padding,
    expected: (_) => const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
  ),
  _badge(
    'label',
    source: 'badge.tsx: text-xs font-medium',
    read: (spec) => (
      spec.spec.label.spec.style?.fontSize,
      spec.spec.label.spec.style?.fontWeight,
    ),
    expected: (_) => (12.0, FontWeight.w500),
  ),
  for (final variant in const [
    VanillaBadgeVariant.primary,
    VanillaBadgeVariant.secondary,
    VanillaBadgeVariant.destructive,
  ])
    _badge(
      '${variant.name} has a transparent 1px border',
      variant: variant,
      source: 'badge.tsx: border border-transparent',
      read: (spec) => decorationOf(spec.spec.container)?.border,
      expected: (_) => _hairline(const Color(0x00000000)),
    ),
  _badge(
    'outline border',
    variant: .outline,
    source: 'badge.tsx: outline, border-border',
    read: (spec) => decorationOf(spec.spec.container)?.border,
    expected: (theme) => _hairline(theme.border),
  ),
];

// -- toggle -------------------------------------------------------------------

SpecTarget _toggle(
  String property, {
  VanillaToggleVariant variant = .ghost,
  VanillaToggleSize size = .medium,
  Set<WidgetState> states = const {},
  String phase = 'F1',
  required String source,
  required Object? Function(StyleSpec<ToggleSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<ToggleSpec>(
  'toggle',
  property,
  source: source,
  phase: phase,
  style: () => vanillaToggleStyle(variant: variant, size: size),
  states: states,
  read: read,
  expected: expected,
);

final _toggleTargets = <SpecTarget>[
  for (final (size, height, paddingX) in const [
    (VanillaToggleSize.small, 32.0, 6.0),
    (VanillaToggleSize.medium, 36.0, 8.0),
    (VanillaToggleSize.large, 40.0, 10.0),
  ]) ...[
    _toggle(
      '${size.name} height and min width',
      size: size,
      source: 'toggle.tsx: h-8 min-w-8 / h-9 min-w-9 / h-10 min-w-10',
      read: (spec) {
        final constraints = boxOf(spec.spec.container)?.constraints;
        return (constraints?.minHeight, constraints?.minWidth);
      },
      expected: (_) => (height, height),
    ),
    _toggle(
      '${size.name} padding',
      size: size,
      source: 'toggle.tsx: px-1.5 / px-2 / px-2.5',
      read: (spec) => boxOf(spec.spec.container)?.padding,
      expected: (_) => EdgeInsets.symmetric(horizontal: paddingX),
    ),
    _toggle(
      '${size.name} label is text-sm',
      size: size,
      source: 'toggle.tsx: text-sm',
      read: (spec) => spec.spec.label.spec.style?.fontSize,
      expected: (_) => 14.0,
    ),
    _toggle(
      '${size.name} icon is size-4',
      size: size,
      source: 'toggle.tsx: [&_svg]:size-4',
      read: (spec) => spec.spec.icon.spec.size,
      expected: (_) => 16.0,
    ),
  ],
  _toggle(
    'hover',
    states: const {WidgetState.hovered},
    source: 'toggle.tsx: hover:bg-muted hover:text-muted-foreground',
    read: (spec) => (
      flexDecorationOf(spec.spec.container)?.color,
      spec.spec.label.spec.style?.color,
    ),
    expected: (theme) => (theme.muted, theme.mutedForeground),
  ),
  _toggle(
    'on',
    states: const {WidgetState.selected},
    source: 'toggle.tsx: data-[state=on]:bg-accent text-accent-foreground',
    read: (spec) => (
      flexDecorationOf(spec.spec.container)?.color,
      spec.spec.label.spec.style?.color,
    ),
    expected: (theme) => (theme.accent, theme.accentForeground),
  ),
  _toggle(
    'on draws no border',
    states: const {WidgetState.selected},
    source: 'toggle.tsx: default variant has no border',
    read: (spec) => flexDecorationOf(spec.spec.container)?.border,
    expected: (_) => paintsNoBorder,
  ),
  _toggle(
    'outline border',
    variant: .outline,
    source: 'toggle.tsx: outline, border border-input',
    read: (spec) => flexDecorationOf(spec.spec.container)?.border,
    expected: (theme) => _hairline(theme.input),
  ),
  // Deviation: no `shadow-xs`. `ToggleSpec` has no effects layer, and a
  // decoration shadow under a transparent fill reads as a gray wash.
  _toggle(
    'outline has no decoration shadow',
    variant: .outline,
    source: 'toggle.tsx: outline, shadow-xs (see specs/vanilla.md)',
    read: (spec) => flexDecorationOf(spec.spec.container)?.boxShadow,
    expected: (_) => anyOf(isNull, isEmpty),
  ),
  _toggle(
    'outline hover',
    variant: .outline,
    states: const {WidgetState.hovered},
    source: 'toggle.tsx: outline, hover:bg-accent hover:text-accent-foreground',
    read: (spec) => (
      flexDecorationOf(spec.spec.container)?.color,
      spec.spec.label.spec.style?.color,
    ),
    expected: (theme) => (theme.accent, theme.accentForeground),
  ),
  _toggle(
    'focus ring',
    states: const {WidgetState.focused},
    phase: 'E',
    source: 'toggle.tsx: focus-visible:ring-[3px] ring-ring/50',
    read: (spec) {
      final border = flexForegroundOf(spec.spec.container)?.border;
      return border is Border ? border.top : null;
    },
    expected: (theme) => BorderSide(
      color: tint(theme.ring, 0.5),
      width: 3,
      strokeAlign: BorderSide.strokeAlignOutside,
    ),
  ),
  _toggle(
    'transition',
    phase: 'E',
    source: 'toggle.tsx: transition-[color,box-shadow]',
    read: (spec) => spec.animation,
    expected: (_) => VanillaMotion.standard,
  ),
];

// -- toggle group -------------------------------------------------------------

SpecTarget _toggleGroup(
  String property, {
  VanillaToggleGroupVariant variant = .ghost,
  Set<WidgetState> states = const {},
  required String source,
  required Object? Function(StyleSpec<ToggleGroupSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<ToggleGroupSpec>(
  'toggle group',
  property,
  source: source,
  phase: 'F1',
  style: () => vanillaToggleGroupStyle(variant: variant),
  states: states,
  read: read,
  expected: expected,
);

final _toggleGroupTargets = <SpecTarget>[
  _toggleGroup(
    'no gap between items',
    source: 'toggle-group.tsx: spacing = 0',
    read: (spec) => flexOf(spec.spec.container)?.spacing,
    expected: (_) => 0.0,
  ),
  _toggleGroup(
    'the group is clipped to radius md',
    source: 'toggle-group.tsx: rounded-md, items rounded-none',
    read: (spec) => (
      flexDecorationOf(spec.spec.container)?.borderRadius,
      boxOf(spec.spec.container)?.clipBehavior,
    ),
    expected: (theme) =>
        (_rounded(theme, VanillaTokens.radiusMd), Clip.antiAlias),
  ),
  _toggleGroup(
    'items are square-cornered',
    source: 'toggle-group.tsx: data-[spacing=0]:rounded-none',
    read: (spec) =>
        flexDecorationOf(spec.spec.item.spec.container)?.borderRadius,
    expected: (_) => anyOf(isNull, BorderRadius.zero),
  ),
  _toggleGroup(
    'item padding',
    source: 'toggle-group.tsx: px-3',
    read: (spec) => boxOf(spec.spec.item.spec.container)?.padding,
    expected: (_) => const EdgeInsets.symmetric(horizontal: 12),
  ),
  _toggleGroup(
    'outline border sits on the group',
    variant: .outline,
    source: 'toggle-group.tsx: outline, border-input (see specs/vanilla.md)',
    read: (spec) => (
      flexDecorationOf(spec.spec.container)?.border,
      flexDecorationOf(spec.spec.container)?.boxShadow,
    ),
    expected: (theme) => (_hairline(theme.input), anyOf(isNull, isEmpty)),
  ),
];

// -- text field ---------------------------------------------------------------

SpecTarget _textField(
  String property, {
  bool area = false,
  Set<WidgetState> states = const {},
  String phase = 'F2',
  required String source,
  required Object? Function(StyleSpec<TextFieldSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<TextFieldSpec>(
  area ? 'text area' : 'text field',
  property,
  source: source,
  phase: phase,
  style: area ? vanillaTextAreaStyle : vanillaTextFieldStyle,
  states: states,
  read: read,
  expected: expected,
);

final _textFieldTargets = <SpecTarget>[
  _textField(
    'height',
    source: 'input.tsx: h-9',
    read: (spec) => spec.spec.container.spec.constraints?.minHeight,
    expected: (_) => 36.0,
  ),
  _textField(
    'padding',
    source: 'input.tsx: px-3 py-1',
    read: (spec) => spec.spec.container.spec.padding,
    expected: (_) => const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
  ),
  _textField(
    'surface',
    source: 'input.tsx: border-input bg-transparent dark:bg-input/30 shadow-xs',
    read: (spec) {
      final decoration = decorationOf(spec.spec.container);
      return (
        decoration?.border,
        decoration?.color,
        spec.spec.containerEffects?.behindContent?.shadows,
      );
    },
    expected: (theme) => (
      _hairline(theme.input),
      _fieldFill(theme),
      _effectShadows(VanillaShadow.xs),
    ),
  ),
  _textField(
    'value and placeholder',
    source: 'input.tsx: md:text-sm placeholder:text-muted-foreground',
    read: (spec) => (
      spec.spec.text.spec.style?.fontSize,
      spec.spec.hintText.spec.style?.color,
    ),
    expected: (theme) => (14.0, theme.mutedForeground),
  ),
  _textField(
    'label',
    source: 'label.tsx: text-sm font-medium',
    read: (spec) => (
      spec.spec.label.spec.style?.fontSize,
      spec.spec.label.spec.style?.fontWeight,
    ),
    expected: (_) => (14.0, FontWeight.w500),
  ),
  _textField(
    'label, field, and helper gap',
    source: 'field.tsx: gap-2',
    read: (spec) => flexOf(spec.spec.layout)?.spacing,
    expected: (_) => 8.0,
  ),
  _textField(
    'helper',
    source: 'field.tsx: FieldDescription text-sm text-muted-foreground',
    read: (spec) => (
      spec.spec.helperText.spec.style?.fontSize,
      spec.spec.helperText.spec.style?.color,
    ),
    expected: (theme) => (14.0, theme.mutedForeground),
  ),
  _textField(
    'error helper',
    states: const {WidgetState.error},
    source: 'field.tsx: FieldError text-destructive',
    read: (spec) => spec.spec.helperText.spec.style?.color,
    expected: (theme) => theme.destructive,
  ),
  _textField(
    'error border',
    states: const {WidgetState.error},
    source: 'input.tsx: aria-invalid:border-destructive',
    read: (spec) => decorationOf(spec.spec.container)?.border,
    expected: (theme) => _hairline(theme.destructive),
  ),
  _textField(
    'text area minimum height',
    area: true,
    source: 'textarea.tsx: min-h-16',
    read: (spec) => spec.spec.container.spec.constraints?.minHeight,
    expected: (_) => 64.0,
  ),
  _textField(
    'text area padding',
    area: true,
    source: 'textarea.tsx: px-3 py-2',
    read: (spec) => spec.spec.container.spec.padding,
    expected: (_) => const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  ),
  _textField(
    'focus ring',
    states: const {WidgetState.focused},
    phase: 'E',
    source: 'input.tsx: focus-visible:ring-[3px] ring-ring/50',
    read: (spec) => spec.spec.containerEffects?.outline,
    expected: _focusRing,
  ),
  _textField(
    'focus border',
    states: const {WidgetState.focused},
    phase: 'E',
    source: 'input.tsx: focus-visible:border-ring',
    read: (spec) => decorationOf(spec.spec.container)?.border,
    expected: (theme) => _hairline(theme.ring),
  ),
];

// -- select -------------------------------------------------------------------

SpecTarget _select(
  String property, {
  Set<WidgetState> states = const {},
  String phase = 'F2',
  required String source,
  required Object? Function(StyleSpec<SelectSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<SelectSpec>(
  'select',
  property,
  source: source,
  phase: phase,
  style: vanillaSelectStyle,
  states: states,
  read: read,
  expected: expected,
);

List<RemixBoxShadow> _effectShadows(VanillaShadow level) => [
  for (final shadow in level.shadows)
    RemixBoxShadow(
      color: shadow.color,
      offset: shadow.offset,
      blurRadius: shadow.blurRadius,
      spreadRadius: shadow.spreadRadius,
    ),
];

final _selectTargets = <SpecTarget>[
  _select(
    'trigger',
    source: 'select.tsx: h-9 px-3 gap-2',
    read: (spec) {
      final container = spec.spec.trigger.spec.container;
      return (
        boxOf(container)?.constraints?.minHeight,
        boxOf(container)?.padding,
        flexOf(container)?.spacing,
      );
    },
    expected: (_) =>
        (36.0, const EdgeInsets.symmetric(horizontal: 12, vertical: 8), 8.0),
  ),
  _select(
    'trigger surface',
    source:
        'select.tsx: border-input bg-transparent dark:bg-input/30 shadow-xs',
    read: (spec) {
      final decoration = flexDecorationOf(spec.spec.trigger.spec.container);
      return (
        decoration?.border,
        decoration?.color,
        spec.spec.trigger.spec.containerEffects?.behindContent?.shadows,
      );
    },
    expected: (theme) => (
      _hairline(theme.input),
      _fieldFill(theme),
      _effectShadows(VanillaShadow.xs),
    ),
  ),
  _select(
    'chevron',
    source: 'select.tsx: ChevronDownIcon size-4 opacity-50',
    read: (spec) => (
      spec.spec.trigger.spec.indicator.spec.size,
      spec.spec.trigger.spec.indicatorOpacity,
    ),
    expected: (_) => (16.0, 0.5),
  ),
  _select(
    'content surface',
    source: 'select.tsx: rounded-md border bg-popover shadow-md',
    read: (spec) {
      final content = spec.spec.content.spec;
      final decoration = decorationOf(content.container);
      return (
        decoration?.color,
        decoration?.border,
        decoration?.borderRadius,
        content.containerEffects?.behindContent?.shadows,
      );
    },
    expected: (theme) => (
      theme.popover,
      _hairline(theme.border),
      _rounded(theme, VanillaTokens.radiusMd),
      _effectShadows(VanillaShadow.md),
    ),
  ),
  _select(
    'content inset and width',
    source: 'select.tsx: p-1 min-w-[8rem]',
    read: (spec) {
      final box = spec.spec.content.spec.container.spec;
      return (box.padding, box.constraints?.minWidth);
    },
    expected: (_) => (const EdgeInsets.all(4), 128.0),
  ),
  _select(
    'item',
    source: 'select.tsx: SelectItem py-1.5 pr-8 pl-2 rounded-sm',
    read: (spec) {
      final container = spec.spec.item.spec.container;
      return (
        boxOf(container)?.constraints?.minHeight,
        boxOf(container)?.padding,
        flexDecorationOf(container)?.borderRadius,
      );
    },
    expected: (theme) => (
      32.0,
      const EdgeInsets.only(left: 8, right: 32, top: 6, bottom: 6),
      _rounded(theme, VanillaTokens.radiusSm),
    ),
  ),
  _select(
    'trigger focus ring',
    states: const {WidgetState.focused},
    phase: 'E',
    source: 'select.tsx: focus-visible:ring-[3px] ring-ring/50',
    read: (spec) => spec.spec.trigger.spec.containerEffects?.outline,
    expected: _focusRing,
  ),
];

// -- checkbox -----------------------------------------------------------------

SpecTarget _checkbox(
  String property, {
  bool selected = false,
  String phase = 'F2',
  required String source,
  required Object? Function(StyleSpec<CheckboxSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _pumped<CheckboxSpec>(
  'checkbox',
  property,
  source: source,
  phase: phase,
  widget: () =>
      VanillaCheckbox(selected: selected, label: 'Probe', onChanged: (_) {}),
  read: read,
  expected: expected,
);

final _checkboxTargets = <SpecTarget>[
  _checkbox(
    'box',
    source: 'checkbox.tsx: size-4 rounded-[4px]',
    read: (spec) => (
      spec.spec.container.spec.constraints,
      decorationOf(spec.spec.container)?.borderRadius,
    ),
    expected: (_) => (
      BoxConstraints.tight(const Size.square(16)),
      const BorderRadius.all(Radius.circular(4)),
    ),
  ),
  _checkbox(
    'unchecked surface',
    source: 'checkbox.tsx: border-input shadow-xs',
    read: (spec) {
      final decoration = decorationOf(spec.spec.container);
      return (
        decoration?.border,
        spec.spec.containerEffects?.behindContent?.shadows,
      );
    },
    expected: (theme) =>
        (_hairline(theme.input), _effectShadows(VanillaShadow.xs)),
  ),
  _checkbox(
    'checked',
    selected: true,
    source: 'checkbox.tsx: data-[state=checked]:bg-primary border-primary',
    read: (spec) => (
      decorationOf(spec.spec.container)?.color,
      decorationOf(spec.spec.container)?.border,
      spec.spec.indicator.spec.color,
    ),
    expected: (theme) =>
        (theme.primary, _hairline(theme.primary), theme.primaryForeground),
  ),
  _checkbox(
    'check mark',
    selected: true,
    source: 'checkbox.tsx: CheckIcon size-3.5',
    read: (spec) => spec.spec.indicator.spec.size,
    expected: (_) => 14.0,
  ),
];

// -- radio --------------------------------------------------------------------

SpecTarget _radio(
  String property, {
  Set<WidgetState> states = const {},
  required String source,
  required Object? Function(StyleSpec<RadioSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<RadioSpec>(
  'radio',
  property,
  source: source,
  phase: 'F2',
  style: vanillaRadioStyle,
  states: states,
  read: read,
  expected: expected,
);

final _radioTargets = <SpecTarget>[
  _radio(
    'unchosen surface',
    source: 'radio-group.tsx: size-4 border-input shadow-xs',
    read: (spec) {
      final decoration = decorationOf(spec.spec.container);
      return (
        spec.spec.container.spec.constraints,
        decoration?.border,
        spec.spec.containerEffects?.behindContent?.shadows,
      );
    },
    expected: (theme) => (
      BoxConstraints.tight(const Size.square(16)),
      _hairline(theme.input),
      _effectShadows(VanillaShadow.xs),
    ),
  ),
  _radio(
    'chosen keeps the input border',
    states: const {WidgetState.selected},
    source: 'radio-group.tsx: border-input in every state',
    read: (spec) => decorationOf(spec.spec.container)?.border,
    expected: (theme) => _hairline(theme.input),
  ),
  _radio(
    'dot',
    states: const {WidgetState.selected},
    source: 'radio-group.tsx: CircleIcon size-2 fill-primary',
    read: (spec) => (
      spec.spec.indicator.spec.constraints,
      decorationOf(spec.spec.indicator)?.color,
    ),
    expected: (theme) =>
        (BoxConstraints.tight(const Size.square(8)), theme.primary),
  ),
];

// -- switch -------------------------------------------------------------------

SpecTarget _switch(
  String property, {
  Set<WidgetState> states = const {},
  required String source,
  required Object? Function(StyleSpec<SwitchSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<SwitchSpec>(
  'switch',
  property,
  source: source,
  phase: 'F2',
  style: vanillaSwitchStyle,
  states: states,
  read: read,
  expected: expected,
);

final _switchTargets = <SpecTarget>[
  _switch(
    'track',
    source: 'switch.tsx: h-[1.15rem] w-8 border border-transparent shadow-xs',
    read: (spec) {
      final decoration = decorationOf(spec.spec.container);
      return (
        spec.spec.container.spec.constraints,
        decoration?.border,
        spec.spec.trackEffects?.behindContent?.shadows,
      );
    },
    expected: (_) => (
      BoxConstraints.tight(const Size(32, 18.4)),
      _hairline(const Color(0x00000000)),
      _effectShadows(VanillaShadow.xs),
    ),
  ),
  _switch(
    'off track',
    source: 'switch.tsx: data-[state=unchecked]:bg-input dark:bg-input/80',
    read: (spec) => decorationOf(spec.spec.container)?.color,
    expected: (theme) => tint(theme.input, _isDark(theme) ? 0.8 : 1),
  ),
  _switch(
    'on track',
    states: const {WidgetState.selected},
    source: 'switch.tsx: data-[state=checked]:bg-primary',
    read: (spec) => decorationOf(spec.spec.container)?.color,
    expected: (theme) => theme.primary,
  ),
  _switch(
    'thumb',
    source: 'switch.tsx: SwitchThumb size-4, no border',
    read: (spec) => (
      spec.spec.thumb.spec.constraints,
      decorationOf(spec.spec.thumb)?.border,
    ),
    expected: (_) =>
        (BoxConstraints.tight(const Size.square(16)), paintsNoBorder),
  ),
];

// -- slider -------------------------------------------------------------------

SpecTarget _slider(
  String property, {
  Set<WidgetState> states = const {},
  required String source,
  required Object? Function(StyleSpec<SliderSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<SliderSpec>(
  'slider',
  property,
  source: source,
  phase: 'F2',
  style: vanillaSliderStyle,
  states: states,
  read: read,
  expected: expected,
);

final _sliderTargets = <SpecTarget>[
  _slider(
    'thumb',
    source: 'slider.tsx: size-4 border border-primary bg-white shadow-sm',
    read: (spec) {
      final decoration = decorationOf(spec.spec.thumb);
      return (
        spec.spec.thumb.spec.constraints,
        decoration?.border,
        decoration?.color,
        decoration?.boxShadow,
      );
    },
    expected: (theme) => (
      BoxConstraints.tight(const Size.square(16)),
      _hairline(theme.primary),
      const Color(0xFFFFFFFF),
      VanillaShadow.sm.shadows,
    ),
  ),
  _slider(
    'hover ring',
    states: const {WidgetState.hovered},
    source: 'slider.tsx: hover:ring-4 ring-ring/50',
    read: (spec) => spec.spec.thumbEffects?.outline,
    expected: (theme) => BorderSide(color: tint(theme.ring, 0.5), width: 4),
  ),
  _slider(
    'focus ring',
    states: const {WidgetState.focused},
    source: 'slider.tsx: focus-visible:ring-4 ring-ring/50',
    read: (spec) => spec.spec.thumbFocusEffects?.outline,
    expected: (theme) => BorderSide(color: tint(theme.ring, 0.5), width: 4),
  ),
];

// -- tabs and segmented control -----------------------------------------------

final _tabsTargets = <SpecTarget>[
  _target<TabBarSpec>(
    'tabs',
    'list',
    source: 'tabs.tsx: TabsList h-9 p-[3px] rounded-lg bg-muted',
    phase: 'F3',
    style: vanillaTabBarStyle,
    read: (spec) {
      final box = boxOf(spec.spec.container);
      return (
        box?.constraints?.minHeight,
        box?.padding,
        flexDecorationOf(spec.spec.container)?.borderRadius,
        flexDecorationOf(spec.spec.container)?.color,
      );
    },
    expected: (theme) => (
      36.0,
      const EdgeInsets.all(3),
      _rounded(theme, VanillaTokens.radiusLg),
      theme.muted,
    ),
  ),
  _target<TabSpec>(
    'tabs',
    'tab',
    source: 'tabs.tsx: TabsTrigger rounded-md px-2 py-1 gap-1.5 text-sm',
    phase: 'F3',
    style: vanillaTabStyle,
    read: (spec) => (
      boxOf(spec.spec.container)?.padding,
      flexOf(spec.spec.container)?.spacing,
      flexDecorationOf(spec.spec.container)?.borderRadius,
      spec.spec.label.spec.style?.fontSize,
    ),
    expected: (theme) => (
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      6.0,
      _rounded(theme, VanillaTokens.radiusMd),
      14.0,
    ),
  ),
  _target<TabSpec>(
    'tabs',
    'inactive label',
    source: 'tabs.tsx: text-foreground/60 dark:text-muted-foreground',
    phase: 'F3',
    style: vanillaTabStyle,
    read: (spec) => spec.spec.label.spec.style?.color,
    expected: (theme) =>
        _isDark(theme) ? theme.mutedForeground : tint(theme.foreground, 0.6),
  ),
  _target<TabSpec>(
    'tabs',
    'active tab',
    source: 'tabs.tsx: data-[state=active]:bg-background shadow-sm',
    phase: 'F3',
    style: vanillaTabStyle,
    states: const {WidgetState.selected},
    read: (spec) => (
      flexDecorationOf(spec.spec.container)?.boxShadow,
      spec.spec.label.spec.style?.color,
    ),
    expected: (theme) => (VanillaShadow.sm.shadows, theme.foreground),
  ),
  _target<SegmentedControlSpec>(
    'segmented control',
    'track',
    source: 'tabs.tsx: TabsList p-[3px] rounded-lg bg-muted',
    phase: 'F3',
    style: vanillaSegmentedControlStyle,
    read: (spec) => (
      spec.spec.container.spec.padding,
      decorationOf(spec.spec.container)?.borderRadius,
      decorationOf(spec.spec.container)?.color,
    ),
    expected: (theme) => (
      const EdgeInsets.all(3),
      _rounded(theme, VanillaTokens.radiusLg),
      theme.muted,
    ),
  ),
  _target<SegmentedControlSpec>(
    'segmented control',
    'chosen segment',
    source: 'tabs.tsx: rounded-md data-[state=active]:bg-background shadow-sm',
    phase: 'F3',
    style: vanillaSegmentedControlStyle,
    states: const {WidgetState.selected},
    read: (spec) {
      final decoration = decorationOf(spec.spec.item.spec.container);
      return (
        decoration?.borderRadius,
        decoration?.color,
        decoration?.boxShadow,
        decoration?.border,
      );
    },
    expected: (theme) => (
      _rounded(theme, VanillaTokens.radiusMd),
      theme.background,
      VanillaShadow.sm.shadows,
      paintsNoBorder,
    ),
  ),
];

// -- sidebar ------------------------------------------------------------------

SpecTarget _sidebar(
  String property, {
  Set<WidgetState> states = const {},
  required String source,
  required Object? Function(StyleSpec<SidebarSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<SidebarSpec>(
  'sidebar',
  property,
  source: source,
  phase: 'F3',
  style: vanillaSidebarStyle,
  states: states,
  read: read,
  expected: expected,
);

final _sidebarTargets = <SpecTarget>[
  _sidebar(
    'panel',
    source: 'sidebar.tsx: bg-sidebar border-r',
    read: (spec) {
      final decoration = flexDecorationOf(spec.spec.container);
      final border = decoration?.border;
      return (
        decoration?.color,
        border is BorderDirectional ? border.end : null,
      );
    },
    expected: (theme) =>
        (theme.sidebar, BorderSide(color: theme.sidebarBorder)),
  ),
  _sidebar(
    'content inset and section gap',
    source: 'sidebar.tsx: SidebarGroup p-2, SidebarContent gap-2 + p-2',
    read: (spec) =>
        (boxOf(spec.spec.content)?.padding, flexOf(spec.spec.content)?.spacing),
    expected: (_) => (const EdgeInsets.all(8), 16.0),
  ),
  _sidebar(
    'destination',
    source: 'sidebar.tsx: SidebarMenuButton h-8 p-2 gap-2 rounded-md',
    read: (spec) {
      final container = spec.spec.destination.spec.container;
      return (
        boxOf(container)?.constraints?.minHeight,
        boxOf(container)?.padding,
        flexOf(container)?.spacing,
        flexDecorationOf(container)?.borderRadius,
      );
    },
    expected: (theme) => (
      32.0,
      const EdgeInsets.all(8),
      8.0,
      _rounded(theme, VanillaTokens.radiusMd),
    ),
  ),
  _sidebar(
    'destinations gap',
    source: 'sidebar.tsx: SidebarMenu gap-1',
    read: (spec) => flexOf(spec.spec.destinations)?.spacing,
    expected: (_) => 4.0,
  ),
  _sidebar(
    'current destination',
    states: const {WidgetState.selected},
    source: 'sidebar.tsx: data-[active=true]:bg-sidebar-accent font-medium',
    read: (spec) {
      final destination = spec.spec.destination.spec;
      return (
        flexDecorationOf(destination.container)?.color,
        destination.label.spec.style?.color,
        destination.label.spec.style?.fontWeight,
        flexDecorationOf(destination.container)?.border,
      );
    },
    expected: (theme) => (
      theme.sidebarAccent,
      theme.sidebarAccentForeground,
      FontWeight.w500,
      paintsNoBorder,
    ),
  ),
  _sidebar(
    'hovered destination',
    states: const {WidgetState.hovered},
    source: 'sidebar.tsx: hover:bg-sidebar-accent',
    read: (spec) =>
        flexDecorationOf(spec.spec.destination.spec.container)?.color,
    expected: (theme) => theme.sidebarAccent,
  ),
  _sidebar(
    'section label',
    source: 'sidebar.tsx: SidebarGroupLabel text-xs font-medium',
    read: (spec) {
      final style = spec.spec.sectionLabel.spec.style;
      return (
        style?.fontSize,
        style?.fontWeight,
        style?.color,
        style?.letterSpacing,
      );
    },
    expected: (theme) => (
      12.0,
      FontWeight.w500,
      tint(theme.sidebarForeground, 0.7),
      anyOf(isNull, 0.0),
    ),
  ),
  SpecTarget._(
    component: 'sidebar layout',
    property: 'collapsed width',
    source: 'sidebar.tsx: SIDEBAR_WIDTH_ICON = 3rem',
    phase: 'F3',
    actual: (tester, theme) async => const VanillaSidebarLayout(
      sidebar: SizedBox.shrink(),
      body: SizedBox.shrink(),
    ).collapsedWidth,
    expected: (_) => 48.0,
  ),
];

// -- menu ---------------------------------------------------------------------

SpecTarget _menu(
  String property, {
  required String source,
  required Object? Function(StyleSpec<MenuSpec> spec) read,
  required Object? Function(VanillaThemeData theme) expected,
}) => _target<MenuSpec>(
  'menu',
  property,
  source: source,
  phase: 'F3',
  style: vanillaMenuStyle,
  read: read,
  expected: expected,
);

final _menuTargets = <SpecTarget>[
  _menu(
    'panel',
    source: 'dropdown-menu.tsx: rounded-md border bg-popover p-1 shadow-md',
    read: (spec) {
      final overlay = spec.spec.overlay;
      final decoration = flexDecorationOf(overlay);
      return (
        decoration?.color,
        decoration?.borderRadius,
        boxOf(overlay)?.padding,
        boxOf(overlay)?.constraints?.minWidth,
        spec.spec.containerEffects?.behindContent?.shadows,
      );
    },
    expected: (theme) => (
      theme.popover,
      _rounded(theme, VanillaTokens.radiusMd),
      const EdgeInsets.all(4),
      128.0,
      _effectShadows(VanillaShadow.md),
    ),
  ),
  _menu(
    'item',
    source: 'dropdown-menu.tsx: DropdownMenuItem px-2 py-1.5 rounded-sm',
    read: (spec) {
      final container = spec.spec.item.spec.container;
      return (
        boxOf(container)?.constraints?.minHeight,
        boxOf(container)?.padding,
        flexDecorationOf(container)?.borderRadius,
      );
    },
    expected: (theme) => (
      32.0,
      const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      _rounded(theme, VanillaTokens.radiusSm),
    ),
  ),
];

// -- accordion and disclosure -------------------------------------------------

final _accordionTargets = <SpecTarget>[
  _target<AccordionSpec>(
    'accordion',
    'trigger',
    source: 'accordion.tsx: AccordionTrigger py-4 text-sm font-medium',
    phase: 'F3',
    style: vanillaAccordionStyle,
    read: (spec) => (
      boxOf(spec.spec.trigger)?.padding,
      spec.spec.title.spec.style?.fontSize,
      spec.spec.title.spec.style?.fontWeight,
    ),
    expected: (_) =>
        (const EdgeInsets.symmetric(vertical: 16), 14.0, FontWeight.w500),
  ),
  _target<AccordionSpec>(
    'accordion',
    'chevron',
    source: 'accordion.tsx: ChevronDownIcon size-4 text-muted-foreground',
    phase: 'F3',
    style: vanillaAccordionStyle,
    read: (spec) =>
        (spec.spec.trailingIcon.spec.size, spec.spec.trailingIcon.spec.color),
    expected: (theme) => (16.0, theme.mutedForeground),
  ),
  _target<AccordionSpec>(
    'accordion',
    'underline on hover',
    source: 'accordion.tsx: hover:underline',
    phase: 'F3',
    style: vanillaAccordionStyle,
    states: const {WidgetState.hovered},
    read: (spec) => spec.spec.title.spec.style?.decoration,
    expected: (_) => TextDecoration.underline,
  ),
  _target<AccordionSpec>(
    'accordion',
    'content',
    source: 'accordion.tsx: AccordionContent pt-0 pb-4',
    phase: 'F3',
    style: vanillaAccordionStyle,
    read: (spec) => spec.spec.content.spec.padding,
    expected: (_) => const EdgeInsets.only(bottom: 16),
  ),
  SpecTarget._(
    component: 'disclosure',
    property: 'trigger',
    source: 'accordion.tsx: AccordionTrigger py-4, no px',
    phase: 'F3',
    actual: (tester, theme) async {
      final spec = await interactedSpec<DisclosureSpec>(
        tester,
        (focusNode) => SizedBox(
          width: 320,
          child: VanillaDisclosure(
            trigger: const Text('Details'),
            content: const Text('Body'),
            focusNode: focusNode,
          ),
        ),
        theme: theme,
      );
      return spec.spec.trigger.spec.padding;
    },
    expected: (_) => const EdgeInsets.symmetric(vertical: 16),
  ),
];

// -- surfaces -----------------------------------------------------------------

final _surfaceTargets = <SpecTarget>[
  _target<CardSpec>(
    'card',
    'surface',
    source: 'card.tsx: rounded-xl border bg-card py-6 shadow-sm',
    phase: 'F4',
    style: vanillaCardStyle,
    read: (spec) {
      final decoration = decorationOf(spec.spec.container);
      return (
        decoration?.color,
        decoration?.border,
        decoration?.borderRadius,
        decoration?.boxShadow,
        spec.spec.container.spec.padding,
      );
    },
    expected: (theme) => (
      theme.card,
      _hairline(theme.border),
      _rounded(theme, VanillaTokens.radiusXl),
      VanillaShadow.sm.shadows,
      const EdgeInsets.all(24),
    ),
  ),
  _target<DialogSpec>(
    'dialog',
    'panel',
    source: 'dialog.tsx: rounded-lg border p-6 shadow-lg sm:max-w-lg',
    phase: 'F4',
    style: vanillaDialogStyle,
    read: (spec) {
      final box = spec.spec.container.spec;
      final decoration = decorationOf(spec.spec.container);
      return (
        decoration?.borderRadius,
        decoration?.boxShadow,
        box.padding,
        box.constraints?.maxWidth,
      );
    },
    expected: (theme) => (
      _rounded(theme, VanillaTokens.radiusLg),
      VanillaShadow.lg.shadows,
      const EdgeInsets.all(24),
      512.0,
    ),
  ),
  _target<DialogSpec>(
    'dialog',
    'title and description',
    source: 'dialog.tsx: text-lg font-semibold; text-sm text-muted-foreground',
    phase: 'F4',
    style: vanillaDialogStyle,
    read: (spec) => (
      spec.spec.title.spec.style?.fontSize,
      spec.spec.title.spec.style?.fontWeight,
      spec.spec.description.spec.style?.fontSize,
      spec.spec.description.spec.style?.color,
    ),
    expected: (theme) => (18.0, FontWeight.w600, 14.0, theme.mutedForeground),
  ),
  _target<PopoverSpec>(
    'popover',
    'panel',
    source: 'popover.tsx: w-72 rounded-md border bg-popover p-4 shadow-md',
    phase: 'F4',
    style: vanillaPopoverStyle,
    read: (spec) {
      final box = spec.spec.container.spec;
      final decoration = decorationOf(spec.spec.container);
      return (
        decoration?.color,
        decoration?.borderRadius,
        decoration?.boxShadow,
        box.padding,
        box.constraints?.minWidth,
        box.constraints?.maxWidth,
      );
    },
    expected: (theme) => (
      theme.popover,
      _rounded(theme, VanillaTokens.radiusMd),
      VanillaShadow.md.shadows,
      const EdgeInsets.all(16),
      288.0,
      288.0,
    ),
  ),
  _target<ToastSpec>(
    'toast',
    'surface',
    source: 'sonner.tsx: --normal-bg popover, --border-radius radius',
    phase: 'F4',
    style: vanillaToastStyle,
    read: (spec) {
      final decoration = flexDecorationOf(spec.spec.container);
      return (
        decoration?.color,
        decoration?.borderRadius,
        decoration?.boxShadow,
        boxOf(spec.spec.container)?.constraints?.maxWidth,
        spec.spec.description.spec.style?.fontSize,
      );
    },
    expected: (theme) => (
      theme.popover,
      _rounded(theme, VanillaTokens.radiusLg),
      const [
        BoxShadow(
          color: Color(0x1A000000),
          offset: Offset(0, 4),
          blurRadius: 12,
        ),
      ],
      356.0,
      14.0,
    ),
  ),
  _target<TooltipSpec>(
    'tooltip',
    'bubble',
    source: 'tooltip.tsx: rounded-md px-3 py-1.5 text-xs',
    phase: 'F4',
    style: vanillaTooltipStyle,
    read: (spec) => (
      decorationOf(spec.spec.container)?.borderRadius,
      spec.spec.container.spec.padding,
      spec.spec.label.spec.style?.fontSize,
    ),
    expected: (theme) => (
      _rounded(theme, VanillaTokens.radiusMd),
      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      12.0,
    ),
  ),
  _target<TooltipSpec>(
    'tooltip',
    'delay',
    source: 'tooltip.tsx: delayDuration = 0',
    phase: 'F4',
    style: vanillaTooltipStyle,
    read: (spec) => spec.spec.waitDuration,
    expected: (_) => Duration.zero,
  ),
  _target<CalloutSpec>(
    'callout',
    'surface',
    source: 'alert.tsx: rounded-lg border px-4 py-3 gap-x-3 bg-card',
    phase: 'F4',
    style: vanillaCalloutStyle,
    read: (spec) => (
      flexDecorationOf(spec.spec.container)?.borderRadius,
      flexDecorationOf(spec.spec.container)?.color,
      boxOf(spec.spec.container)?.padding,
      flexOf(spec.spec.container)?.spacing,
    ),
    expected: (theme) => (
      _rounded(theme, VanillaTokens.radiusLg),
      theme.card,
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      12.0,
    ),
  ),
  _target<CalloutSpec>(
    'callout',
    'destructive text',
    source: 'alert.tsx: destructive, text-destructive',
    phase: 'F4',
    style: () => vanillaCalloutStyle(variant: .destructive),
    read: (spec) => spec.spec.text.spec.style?.color,
    expected: (theme) => theme.destructive,
  ),
];

// -- data and display ---------------------------------------------------------

final _displayTargets = <SpecTarget>[
  _target<DataTableSpec>(
    'data table',
    'header',
    source: 'table.tsx: TableHead h-10 px-2 font-medium text-foreground',
    phase: 'F5',
    style: vanillaDataTableStyle,
    read: (spec) => (
      decorationOf(spec.spec.headerRow)?.color,
      spec.spec.headerCell.spec.padding,
      spec.spec.headerLabel.spec.style?.fontSize,
      spec.spec.headerLabel.spec.style?.fontWeight,
      spec.spec.headerLabel.spec.style?.color,
    ),
    expected: (theme) => (
      anyOf(isNull, const Color(0x00000000)),
      const EdgeInsets.symmetric(horizontal: 8),
      14.0,
      FontWeight.w500,
      theme.foreground,
    ),
  ),
  _target<DataTableSpec>(
    'data table',
    'cells',
    source: 'table.tsx: TableCell p-2',
    phase: 'F5',
    style: vanillaDataTableStyle,
    read: (spec) => spec.spec.bodyCell.spec.padding,
    expected: (_) => const EdgeInsets.all(8),
  ),
  _target<DataTableSpec>(
    'data table',
    'row hover',
    source: 'table.tsx: TableRow hover:bg-muted/50',
    phase: 'F5',
    style: vanillaDataTableStyle,
    states: const {WidgetState.hovered},
    read: (spec) => decorationOf(spec.spec.bodyRow)?.color,
    expected: (theme) => tint(theme.muted, 0.5),
  ),
  _target<DataTableSpec>(
    'data table',
    'selected row',
    source: 'table.tsx: TableRow data-[state=selected]:bg-muted',
    phase: 'F5',
    style: vanillaDataTableStyle,
    states: const {WidgetState.selected},
    read: (spec) => decorationOf(spec.spec.bodyRow)?.color,
    expected: (theme) => theme.muted,
  ),
  _target<AvatarSpec>(
    'avatar',
    'fallback',
    source: 'avatar.tsx: size-8; AvatarFallback bg-muted text-muted-foreground',
    phase: 'F5',
    style: vanillaAvatarStyle,
    read: (spec) => (
      spec.spec.container.spec.constraints,
      decorationOf(spec.spec.container)?.color,
      spec.spec.label.spec.style?.color,
      spec.spec.icon.spec.size,
    ),
    expected: (theme) => (
      BoxConstraints.tight(const Size.square(32)),
      theme.muted,
      theme.mutedForeground,
      16.0,
    ),
  ),
  _target<SkeletonSpec>(
    'skeleton',
    'pulse',
    source: 'skeleton.tsx: animate-pulse rounded-md bg-accent',
    phase: 'F5',
    style: vanillaSkeletonStyle,
    read: (spec) => (
      decorationOf(spec.spec.container)?.color,
      spec.spec.pulseColor,
      decorationOf(spec.spec.container)?.borderRadius,
    ),
    expected: (theme) => (
      theme.accent,
      tint(theme.accent, 0.5),
      _rounded(theme, VanillaTokens.radiusMd),
    ),
  ),
  _target<ProgressSpec>(
    'progress',
    'track',
    source: 'progress.tsx: bg-primary/20',
    phase: 'F5',
    style: vanillaProgressStyle,
    read: (spec) => decorationOf(spec.spec.track)?.color,
    expected: (theme) => tint(theme.primary, 0.2),
  ),
  _target<SpinnerSpec>(
    'spinner',
    'size',
    source: 'spinner.tsx: size-4',
    phase: 'F5',
    style: vanillaSpinnerStyle,
    read: (spec) => spec.spec.size,
    expected: (_) => 16.0,
  ),
];

/// Every Vanilla target, in the order `specs/vanilla.md` lists components.
final vanillaSpecTargets = <SpecTarget>[
  ..._buttonTargets,
  ..._iconButtonTargets,
  ..._linkTargets,
  ..._badgeTargets,
  ..._toggleTargets,
  ..._toggleGroupTargets,
  ..._textFieldTargets,
  ..._selectTargets,
  ..._checkboxTargets,
  ..._radioTargets,
  ..._switchTargets,
  ..._sliderTargets,
  ..._tabsTargets,
  ..._sidebarTargets,
  ..._menuTargets,
  ..._accordionTargets,
  ..._surfaceTargets,
  ..._displayTargets,
];
