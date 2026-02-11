// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divider.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixDividerSpecMethods on Spec<RemixDividerSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;

  @override
  RemixDividerSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixDividerSpec(container: container ?? this.container);
  }

  @override
  RemixDividerSpec lerp(RemixDividerSpec? other, double t) {
    return RemixDividerSpec(container: container.lerp(other?.container, t));
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

mixin _$RemixDividerStyleMixin on Style<RemixDividerSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;

  /// Sets the container.
  RemixDividerStyle container(BoxStyler value) {
    return merge(RemixDividerStyle(container: value));
  }

  /// Sets the animation configuration.
  RemixDividerStyle animate(AnimationConfig value) {
    return merge(RemixDividerStyle(animation: value));
  }

  /// Sets the style variants.
  RemixDividerStyle variants(List<VariantStyle<RemixDividerSpec>> value) {
    return merge(RemixDividerStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixDividerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixDividerStyle(modifier: value));
  }

  /// Merges with another [RemixDividerStyle].
  @override
  RemixDividerStyle merge(RemixDividerStyle? other) {
    return RemixDividerStyle.create(
      container: MixOps.merge($container, other?.$container),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixDividerSpec>] using context.
  @override
  StyleSpec<RemixDividerSpec> resolve(BuildContext context) {
    final spec = RemixDividerSpec(
      container: MixOps.resolve(context, $container),
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
    properties..add(DiagnosticsProperty('container', $container));
  }

  @override
  List<Object?> get props => [$container, $animation, $modifier, $variants];
}
