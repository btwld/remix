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

/// Fortal-themed button style and widget presets.
class FortalButton extends StatelessWidget {
  const FortalButton({
    super.key,
    this.variant = .solid,
    this.size = .size2,
    required this.label,
    this.leadingIcon,
    this.trailingIcon,
    this.textBuilder,
    this.leadingIconBuilder,
    this.trailingIconBuilder,
    this.loadingBuilder,
    this.loading = false,
    this.enabled = true,
    this.onPressed,
    this.onLongPress,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticHint,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  final FortalButtonVariant variant;

  final FortalButtonSize size;

  final String label;

  final IconData? leadingIcon;

  final IconData? trailingIcon;

  final RemixButtonTextBuilder? textBuilder;

  final RemixButtonIconBuilder? leadingIconBuilder;

  final RemixButtonIconBuilder? trailingIconBuilder;

  final RemixButtonLoadingBuilder? loadingBuilder;

  final bool loading;

  final bool enabled;

  final VoidCallback? onPressed;

  final VoidCallback? onLongPress;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool enableFeedback;

  final String? semanticLabel;

  final String? semanticHint;

  final bool excludeSemantics;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return fortalButtonStyler(variant: this.variant, size: this.size).call(
      key: this.key,
      label: this.label,
      leadingIcon: this.leadingIcon,
      trailingIcon: this.trailingIcon,
      textBuilder: this.textBuilder,
      leadingIconBuilder: this.leadingIconBuilder,
      trailingIconBuilder: this.trailingIconBuilder,
      loadingBuilder: this.loadingBuilder,
      loading: this.loading,
      enabled: this.enabled,
      onPressed: this.onPressed,
      onLongPress: this.onLongPress,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      enableFeedback: this.enableFeedback,
      semanticLabel: this.semanticLabel,
      semanticHint: this.semanticHint,
      excludeSemantics: this.excludeSemantics,
      mouseCursor: this.mouseCursor,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixButtonStylerMixin on Style<RemixButtonSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<RemixSpinnerSpec>>? get $spinner;
  Prop<IconAlignment>? get $iconAlignment;

  /// Sets the container.
  RemixButtonStyler container(FlexBoxStyler value) {
    return merge(RemixButtonStyler(container: value));
  }

  /// Sets the label.
  RemixButtonStyler label(TextStyler value) {
    return merge(RemixButtonStyler(label: value));
  }

  /// Sets the icon.
  RemixButtonStyler icon(IconStyler value) {
    return merge(RemixButtonStyler(icon: value));
  }

  /// Sets the spinner.
  RemixButtonStyler spinner(RemixSpinnerStyler value) {
    return merge(RemixButtonStyler(spinner: value));
  }

  /// Sets the iconAlignment.
  RemixButtonStyler iconAlignment(IconAlignment value) {
    return merge(RemixButtonStyler(iconAlignment: value));
  }

  /// Sets the animation configuration.
  RemixButtonStyler animate(AnimationConfig value) {
    return merge(RemixButtonStyler(animation: value));
  }

  /// Sets the style variants.
  RemixButtonStyler variants(List<VariantStyle<RemixButtonSpec>> value) {
    return merge(RemixButtonStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixButtonStyler wrap(WidgetModifierConfig value) {
    return merge(RemixButtonStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixButtonStyler modifier(WidgetModifierConfig value) {
    return merge(RemixButtonStyler(modifier: value));
  }

  /// Merges with another [RemixButtonStyler].
  @override
  RemixButtonStyler merge(RemixButtonStyler? other) {
    return RemixButtonStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      icon: MixOps.merge($icon, other?.$icon),
      spinner: MixOps.merge($spinner, other?.$spinner),
      iconAlignment: MixOps.merge($iconAlignment, other?.$iconAlignment),
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
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
      spinner: MixOps.resolve(context, $spinner),
      iconAlignment: MixOps.resolve(context, $iconAlignment),
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
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('spinner', $spinner))
      ..add(DiagnosticsProperty('iconAlignment', $iconAlignment));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $icon,
    $spinner,
    $iconAlignment,
    $animation,
    $modifier,
    $variants,
  ];
}
