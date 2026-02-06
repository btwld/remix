// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSwitchSpecMethods on Spec<RemixSwitchSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get container;
  StyleSpec<BoxSpec>? get thumb;

  @override
  RemixSwitchSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? thumb,
  }) {
    return RemixSwitchSpec(
      container: container ?? this.container,
      thumb: thumb ?? this.thumb,
    );
  }

  @override
  RemixSwitchSpec lerp(RemixSwitchSpec? other, double t) {
    return RemixSwitchSpec(
      container: container?.lerp(other?.container, t),
      thumb: thumb?.lerp(other?.thumb, t),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('thumb', thumb));
  }

  @override
  List<Object?> get props => [container, thumb];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixSwitchStyleMixin on Style<RemixSwitchSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<BoxSpec>>? get $thumb;

  /// Sets the container.
  RemixSwitchStyle container(BoxStyler value) {
    return merge(RemixSwitchStyle(container: value));
  }

  /// Sets the thumb.
  RemixSwitchStyle thumb(BoxStyler value) {
    return merge(RemixSwitchStyle(thumb: value));
  }

  /// Sets the animation configuration.
  RemixSwitchStyle animate(AnimationConfig value) {
    return merge(RemixSwitchStyle(animation: value));
  }

  /// Sets the style variants.
  RemixSwitchStyle variants(List<VariantStyle<RemixSwitchSpec>> value) {
    return merge(RemixSwitchStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixSwitchStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSwitchStyle(modifier: value));
  }

  /// Merges with another [RemixSwitchStyle].
  @override
  RemixSwitchStyle merge(RemixSwitchStyle? other) {
    return RemixSwitchStyle.create(
      container: MixOps.merge($container, other?.$container),
      thumb: MixOps.merge($thumb, other?.$thumb),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSwitchSpec>] using context.
  @override
  StyleSpec<RemixSwitchSpec> resolve(BuildContext context) {
    final spec = RemixSwitchSpec(
      container: MixOps.resolve(context, $container),
      thumb: MixOps.resolve(context, $thumb),
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
      ..add(DiagnosticsProperty('thumb', $thumb));
  }

  @override
  List<Object?> get props => [
    $container,
    $thumb,
    $animation,
    $modifier,
    $variants,
  ];
}
