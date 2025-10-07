part of 'card.dart';

// Private per-component constants (sizes only)

class RemixCardStyle
    extends RemixContainerStyle<RemixCardSpec, RemixCardStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixCardStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixCardStyle({
    BoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<RemixCardSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets container padding
  RemixCardStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container background color
  RemixCardStyle color(Color value) {
    return merge(RemixCardStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixCardStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixCardStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container margin
  RemixCardStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixCardStyle alignment(Alignment value) {
    return merge(RemixCardStyle(container: BoxStyler(alignment: value)));
  }

  /// Sets container decoration
  RemixCardStyle decoration(DecorationMix value) {
    return merge(RemixCardStyle(container: BoxStyler(decoration: value)));
  }

  @override
  StyleSpec<RemixCardSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixCardSpec(container: MixOps.resolve(context, $container)),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCardStyle merge(RemixCardStyle? other) {
    if (other == null) return this;

    return RemixCardStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixCardStyle variants(List<VariantStyle<RemixCardSpec>> value) {
    return merge(RemixCardStyle(variants: value));
  }

  @override
  RemixCardStyle wrap(WidgetModifierConfig value) {
    return merge(RemixCardStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixCardStyle animate(AnimationConfig config) {
    return merge(RemixCardStyle(animation: config));
  }

  @override
  RemixCardStyle constraints(BoxConstraintsMix value) {
    return merge(RemixCardStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixCardStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCardStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCardStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixCardStyle(
      container: BoxStyler(transform: value, transformAlignment: alignment),
    ));
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}
