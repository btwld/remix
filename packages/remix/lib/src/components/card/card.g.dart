// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixCardSpecMethods on Spec<RemixCardSpec>, Diagnosticable {
  StyleSpec<BoxSpec>? get container;

  @override
  RemixCardSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixCardSpec(container: container ?? this.container);
  }

  @override
  RemixCardSpec lerp(RemixCardSpec? other, double t) {
    return RemixCardSpec(container: container?.lerp(other?.container, t));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixCardStyleMixin on Style<RemixCardSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;

  /// Sets the container.
  RemixCardStyle container(BoxStyler value) {
    return merge(RemixCardStyle(container: value));
  }

  /// Sets the animation configuration.
  RemixCardStyle animate(AnimationConfig value) {
    return merge(RemixCardStyle(animation: value));
  }

  /// Sets the style variants.
  RemixCardStyle variants(List<VariantStyle<RemixCardSpec>> value) {
    return merge(RemixCardStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixCardStyle wrap(WidgetModifierConfig value) {
    return merge(RemixCardStyle(modifier: value));
  }

  /// Merges with another [RemixCardStyle].
  @override
  RemixCardStyle merge(RemixCardStyle? other) {
    return RemixCardStyle.create(
      container: MixOps.merge($container, other?.$container),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixCardSpec>] using context.
  @override
  StyleSpec<RemixCardSpec> resolve(BuildContext context) {
    final spec = RemixCardSpec(container: MixOps.resolve(context, $container));

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('container', $container));
  }

  @override
  List<Object?> get props => [$container, $animation, $modifier, $variants];
}
