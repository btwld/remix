part of 'card.dart';

// Private per-component constants (sizes only)

class RemixCardStyle extends RemixContainerStyle<CardSpec, RemixCardStyle> {
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
    List<VariantStyle<CardSpec>>? variants,
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

  /// Sets container decoration
  RemixCardStyle decoration(DecorationMix value) {
    return merge(RemixCardStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets container styling
  RemixCardStyle container(BoxStyler value) {
    return merge(RemixCardStyle(container: value));
  }

  @override
  StyleSpec<CardSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: CardSpec(container: MixOps.resolve(context, $container)),
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
  RemixCardStyle withVariants(List<VariantStyle<CardSpec>> value) {
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
      container: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}

class RemixCardStyles {
  /// Base card style - surface background with border
  static RemixCardStyle get baseStyle => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.primary(), width: 1),
            ),
            borderRadius: BorderRadiusMix.all(RemixTokens.radius()),
            color: RemixTokens.onPrimary(),
          ),
        ),
      );
}

// Variants are exposed via RemixCardStyles

/// Extension providing Radix card size methods for fluent API.
///
/// Enables the pattern: `RadixCardStyles.surface().size2()`
/// instead of: `RadixCardStyles.size2().merge(RadixCardStyles.surface())`
extension RadixCardStyleExt on RemixCardStyle {
  /// Creates a size 1 card style (small).
  ///
  /// Small cards for compact layouts and dense interfaces.
  RemixCardStyle size1() {
    return merge(RadixCardStyles.size1());
  }

  /// Creates a size 2 card style (medium - default).
  ///
  /// Standard cards for most common use cases.
  RemixCardStyle size2() {
    return merge(RadixCardStyles.size2());
  }

  /// Creates a size 3 card style (large).
  ///
  /// Large cards for prominent content and accessibility needs.
  RemixCardStyle size3() {
    return merge(RadixCardStyles.size3());
  }
}
