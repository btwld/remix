// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'button.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixButtonSpec implements Spec<RemixButtonSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;
  StyleSpec<RemixSpinnerSpec> get spinner;
  IconAlignment get iconAlignment;

  @override
  Type get type => RemixButtonSpec;

  @override
  RemixButtonSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    StyleSpec<RemixSpinnerSpec>? spinner,
    IconAlignment? iconAlignment,
  }) {
    return RemixButtonSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
      spinner: spinner ?? this.spinner,
      iconAlignment: iconAlignment ?? this.iconAlignment,
    );
  }

  @override
  RemixButtonSpec lerp(RemixButtonSpec? other, double t) {
    return RemixButtonSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      icon: icon.lerp(other?.icon, t),
      spinner: spinner.lerp(other?.spinner, t),
      iconAlignment: MixOps.lerpSnap(iconAlignment, other?.iconAlignment, t),
    );
  }

  @override
  List<Object?> get props => [container, label, icon, spinner, iconAlignment];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixButtonSpec &&
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
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DiagnosticsProperty('spinner', spinner))
      ..add(DiagnosticsProperty('iconAlignment', iconAlignment));
  }
}

@Deprecated(
  'Rename to `_\$RemixButtonSpec` and migrate the class declaration to `class RemixButtonSpec with _\$RemixButtonSpec`. The `_\$RemixButtonSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixButtonSpecMethods = _$RemixButtonSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Creates a Fortal-themed button style.
///
/// The `@MixWidget` generator derives the `FortalButton` widget from this
/// function name.
class FortalButton extends StatelessWidget {
  const FortalButton({
    super.key,
    this.variant = .solid,
    this.size = .size2,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.loading = false,
    this.enabled = true,
    this.enableFeedback = true,
    required this.onPressed,
    this.focusNode,
  });

  final FortalButtonVariant variant;

  final FortalButtonSize size;

  final String label;

  final IconData? leadingIcon;

  final IconData? trailingIcon;

  final bool loading;

  final bool enabled;

  final bool enableFeedback;

  final VoidCallback? onPressed;

  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return fortalButtonStyle(variant: this.variant, size: this.size).call(
      label: this.label,
      leadingIcon: this.leadingIcon,
      trailingIcon: this.trailingIcon,
      loading: this.loading,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      onPressed: this.onPressed,
      focusNode: this.focusNode,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixButtonStyleMixin on Style<RemixButtonSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<IconAlignment>? get $iconAlignment;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<RemixSpinnerSpec>>? get $spinner;

  /// Sets the container.
  RemixButtonStyle container(FlexBoxStyler value) {
    return merge(RemixButtonStyle(container: value));
  }

  /// Sets the icon.
  RemixButtonStyle icon(IconStyler value) {
    return merge(RemixButtonStyle(icon: value));
  }

  /// Sets the iconAlignment.
  RemixButtonStyle iconAlignment(IconAlignment value) {
    return merge(RemixButtonStyle(iconAlignment: value));
  }

  /// Sets the label.
  RemixButtonStyle label(TextStyler value) {
    return merge(RemixButtonStyle(label: value));
  }

  /// Sets the spinner.
  RemixButtonStyle spinner(RemixSpinnerStyle value) {
    return merge(RemixButtonStyle(spinner: value));
  }

  /// Sets the animation configuration.
  RemixButtonStyle animate(AnimationConfig value) {
    return merge(RemixButtonStyle(animation: value));
  }

  /// Sets the style variants.
  RemixButtonStyle variants(List<VariantStyle<RemixButtonSpec>> value) {
    return merge(RemixButtonStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixButtonStyle wrap(WidgetModifierConfig value) {
    return merge(RemixButtonStyle(modifier: value));
  }

  /// Merges with another [RemixButtonStyle].
  @override
  RemixButtonStyle merge(RemixButtonStyle? other) {
    return RemixButtonStyle.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      iconAlignment: MixOps.merge($iconAlignment, other?.$iconAlignment),
      label: MixOps.merge($label, other?.$label),
      spinner: MixOps.merge($spinner, other?.$spinner),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixButtonSpec>] using [context].
  @override
  StyleSpec<RemixButtonSpec> resolve(BuildContext context) {
    final spec = RemixButtonSpec(
      container: MixOps.resolve(context, $container),
      icon: MixOps.resolve(context, $icon),
      iconAlignment: MixOps.resolve(context, $iconAlignment),
      label: MixOps.resolve(context, $label),
      spinner: MixOps.resolve(context, $spinner),
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
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('iconAlignment', $iconAlignment))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('spinner', $spinner));
  }

  @override
  List<Object?> get props => [
    $container,
    $icon,
    $iconAlignment,
    $label,
    $spinner,
    $animation,
    $modifier,
    $variants,
  ];
}
