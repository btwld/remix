// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radio.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixRadioSpecMethods on Spec<RemixRadioSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get container;
  StyleSpec<BoxSpec>? get indicator;

  @override
  RemixRadioSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? indicator,
  }) {
    return RemixRadioSpec(
      container: container ?? this.container,
      indicator: indicator ?? this.indicator,
    );
  }

  @override
  RemixRadioSpec lerp(RemixRadioSpec? other, double t) {
    return RemixRadioSpec(
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

mixin _$RemixRadioStyleMixin on Style<RemixRadioSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<BoxSpec>>? get $indicator;

  /// Sets the container.
  RemixRadioStyle container(BoxStyler value) {
    return merge(RemixRadioStyle(container: value));
  }

  /// Sets the indicator.
  RemixRadioStyle indicator(BoxStyler value) {
    return merge(RemixRadioStyle(indicator: value));
  }

  /// Sets the animation configuration.
  RemixRadioStyle animate(AnimationConfig value) {
    return merge(RemixRadioStyle(animation: value));
  }

  /// Sets the style variants.
  RemixRadioStyle variants(List<VariantStyle<RemixRadioSpec>> value) {
    return merge(RemixRadioStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixRadioStyle wrap(WidgetModifierConfig value) {
    return merge(RemixRadioStyle(modifier: value));
  }

  /// Merges with another [RemixRadioStyle].
  @override
  RemixRadioStyle merge(RemixRadioStyle? other) {
    return RemixRadioStyle.create(
      container: MixOps.merge($container, other?.$container),
      indicator: MixOps.merge($indicator, other?.$indicator),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixRadioSpec>] using context.
  @override
  StyleSpec<RemixRadioSpec> resolve(BuildContext context) {
    final spec = RemixRadioSpec(
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
