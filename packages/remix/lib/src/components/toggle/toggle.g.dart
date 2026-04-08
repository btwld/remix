// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixToggleSpecMethods on Spec<RemixToggleSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, label, icon];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixToggleStyleMixin on Style<RemixToggleSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<TextSpec>>? get $label;

  /// Sets the container.
  RemixToggleStyle container(FlexBoxStyler value) {
    return merge(RemixToggleStyle(container: value));
  }

  /// Sets the icon.
  RemixToggleStyle icon(IconStyler value) {
    return merge(RemixToggleStyle(icon: value));
  }

  /// Sets the label.
  RemixToggleStyle label(TextStyler value) {
    return merge(RemixToggleStyle(label: value));
  }

  /// Sets the animation configuration.
  RemixToggleStyle animate(AnimationConfig value) {
    return merge(RemixToggleStyle(animation: value));
  }

  /// Sets the style variants.
  RemixToggleStyle variants(List<VariantStyle<RemixToggleSpec>> value) {
    return merge(RemixToggleStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixToggleStyle wrap(WidgetModifierConfig value) {
    return merge(RemixToggleStyle(modifier: value));
  }

  /// Merges with another [RemixToggleStyle].
  @override
  RemixToggleStyle merge(RemixToggleStyle? other) {
    return RemixToggleStyle.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      label: MixOps.merge($label, other?.$label),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixToggleSpec>] using context.
  @override
  StyleSpec<RemixToggleSpec> resolve(BuildContext context) {
    final spec = RemixToggleSpec(
      container: MixOps.resolve(context, $container),
      icon: MixOps.resolve(context, $icon),
      label: MixOps.resolve(context, $label),
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
      ..add(DiagnosticsProperty('label', $label));
  }

  @override
  List<Object?> get props => [
    $container,
    $icon,
    $label,
    $animation,
    $modifier,
    $variants,
  ];
}
