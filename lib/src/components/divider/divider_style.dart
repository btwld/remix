part of 'divider.dart';

// Private per-component constants (none)

class RemixDividerStyle extends RemixContainerStyle<DividerSpec, RemixDividerStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixDividerStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixDividerStyle({
    BoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<DividerSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets divider color
  RemixDividerStyle color(Color value) {
    return merge(RemixDividerStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets divider thickness (height for horizontal, width for vertical)
  RemixDividerStyle thickness(double value) {
    return merge(RemixDividerStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
      ),
    ));
  }

  /// Sets container padding
  RemixDividerStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixDividerStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container decoration
  RemixDividerStyle decoration(DecorationMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixDividerStyle withVariants(List<VariantStyle<DividerSpec>> value) {
    return merge(RemixDividerStyle(variants: value));
  }

  @override
  RemixDividerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixDividerStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixDividerStyle animate(AnimationConfig config) {
    return merge(RemixDividerStyle(animation: config));
  }

  @override
  RemixDividerStyle constraints(BoxConstraintsMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixDividerStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixDividerStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixDividerStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixDividerStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  StyleSpec<DividerSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: DividerSpec(container: MixOps.resolve(context, $container)),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixDividerStyle merge(RemixDividerStyle? other) {
    if (other == null) return this;

    return RemixDividerStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}


