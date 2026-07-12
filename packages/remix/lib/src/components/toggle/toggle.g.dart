// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixToggleSpec implements Spec<RemixToggleSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixToggleSpec;

  @override
  RemixToggleSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixToggleSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  @override
  RemixToggleSpec lerp(RemixToggleSpec? other, double t) {
    return RemixToggleSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      icon: icon.lerp(other?.icon, t),
    );
  }

  @override
  List<Object?> get props => [container, label, icon];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixToggleSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }
}

@Deprecated(
  'Rename to `_\$RemixToggleSpec` and migrate the class declaration to `class RemixToggleSpec with _\$RemixToggleSpec`. The `_\$RemixToggleSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixToggleSpecMethods = _$RemixToggleSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed preset for [RemixToggle].
class FortalToggle extends StatelessWidget {
  const FortalToggle({
    super.key,
    this.variant = .ghost,
    this.size = .size2,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.label,
    this.icon,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  });

  const FortalToggle.ghost({
    super.key,
    this.size = .size2,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.label,
    this.icon,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalToggleVariant.ghost;

  const FortalToggle.outline({
    super.key,
    this.size = .size2,
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.label,
    this.icon,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalToggleVariant.outline;

  final FortalToggleVariant variant;

  final FortalToggleSize size;

  final bool selected;

  final ValueChanged<bool>? onChanged;

  final bool enabled;

  final String? label;

  final IconData? icon;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final String? semanticLabel;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return fortalToggleStyler(variant: this.variant, size: this.size).call(
      key: this.key,
      selected: this.selected,
      onChanged: this.onChanged,
      enabled: this.enabled,
      label: this.label,
      icon: this.icon,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      semanticLabel: this.semanticLabel,
      mouseCursor: this.mouseCursor,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixToggleStylerMixin on Style<RemixToggleSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $icon;

  /// Sets the container.
  RemixToggleStyler container(FlexBoxStyler value) {
    return merge(RemixToggleStyler(container: value));
  }

  /// Sets the label.
  RemixToggleStyler label(TextStyler value) {
    return merge(RemixToggleStyler(label: value));
  }

  /// Sets the icon.
  RemixToggleStyler icon(IconStyler value) {
    return merge(RemixToggleStyler(icon: value));
  }

  /// Sets the animation configuration.
  RemixToggleStyler animate(AnimationConfig value) {
    return merge(RemixToggleStyler(animation: value));
  }

  /// Sets the style variants.
  RemixToggleStyler variants(List<VariantStyle<RemixToggleSpec>> value) {
    return merge(RemixToggleStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixToggleStyler wrap(WidgetModifierConfig value) {
    return merge(RemixToggleStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixToggleStyler modifier(WidgetModifierConfig value) {
    return merge(RemixToggleStyler(modifier: value));
  }

  /// Merges with another [RemixToggleStyler].
  @override
  RemixToggleStyler merge(RemixToggleStyler? other) {
    return RemixToggleStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixToggleSpec>] using [context].
  @override
  StyleSpec<RemixToggleSpec> resolve(BuildContext context) {
    final spec = RemixToggleSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}
