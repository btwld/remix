// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkbox.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixCheckboxSpecMethods on Spec<RemixCheckboxSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get container;
  StyleSpec<IconSpec>? get indicator;

  @override
  RemixCheckboxSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<IconSpec>? indicator,
  }) {
    return RemixCheckboxSpec(
      container: container ?? this.container,
      indicator: indicator ?? this.indicator,
    );
  }

  @override
  RemixCheckboxSpec lerp(RemixCheckboxSpec? other, double t) {
    return RemixCheckboxSpec(
      container: container?.lerp(other?.container, t),
      indicator: indicator?.lerp(other?.indicator, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('indicator', indicator));
  }

  @override
  List<Object?> get props => [container, indicator];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixCheckboxStyleMixin on Style<RemixCheckboxSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $indicator;

  /// Sets the container.
  RemixCheckboxStyle container(BoxStyler value) {
    return merge(RemixCheckboxStyle(container: value));
  }

  /// Sets the indicator.
  RemixCheckboxStyle indicator(IconStyler value) {
    return merge(RemixCheckboxStyle(indicator: value));
  }

  /// Sets the animation configuration.
  RemixCheckboxStyle animate(AnimationConfig value) {
    return merge(RemixCheckboxStyle(animation: value));
  }

  /// Sets the style variants.
  RemixCheckboxStyle variants(List<VariantStyle<RemixCheckboxSpec>> value) {
    return merge(RemixCheckboxStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixCheckboxStyle wrap(WidgetModifierConfig value) {
    return merge(RemixCheckboxStyle(modifier: value));
  }

  /// Merges with another [RemixCheckboxStyle].
  @override
  RemixCheckboxStyle merge(RemixCheckboxStyle? other) {
    return RemixCheckboxStyle.create(
      container: MixOps.merge($container, other?.$container),
      indicator: MixOps.merge($indicator, other?.$indicator),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixCheckboxSpec>] using context.
  @override
  StyleSpec<RemixCheckboxSpec> resolve(BuildContext context) {
    final spec = RemixCheckboxSpec(
      container: MixOps.resolve(context, $container),
      indicator: MixOps.resolve(context, $indicator),
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
      ..add(DiagnosticsProperty('indicator', $indicator));
  }

  @override
  List<Object?> get props => [
    $container,
    $indicator,
    $animation,
    $modifier,
    $variants,
  ];
}
