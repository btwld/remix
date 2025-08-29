part of 'card.dart';

class RemixCardStyle extends Style<CardSpec>
    with
        StyleModifierMixin<RemixCardStyle, CardSpec>,
        StyleVariantMixin<RemixCardStyle, CardSpec> {
  final Prop<WidgetSpec<BoxSpec>>? $container;

  const RemixCardStyle.create({
    Prop<WidgetSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixCardStyle({
    BoxStyle? container,
    AnimationConfig? animation,
    List<VariantStyle<CardSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  WidgetSpec<CardSpec> resolve(BuildContext context) {
    return WidgetSpec(
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
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  RemixCardStyle variant(Variant variant, RemixCardStyle style) {
    return merge(RemixCardStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixCardStyle variants(List<VariantStyle<CardSpec>> value) {
    return merge(RemixCardStyle(variants: value));
  }

  @override
  RemixCardStyle wrap(ModifierConfig value) {
    return merge(RemixCardStyle(modifier: value));
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}

final DefaultRemixCardStyle = RemixCardStyle(
  container: BoxStyle(
    padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
      color: RemixTokens.surface(),
      boxShadow: RemixTokens.elevationMd(),
    ),
  ),
);

/// Default card styles and variants
class RemixCardStyles {
  /// Default card style
  static RemixCardStyle get defaultStyle => RemixCardStyle(
        container: BoxStyle(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
            boxShadow: RemixTokens.elevationMd(),
          ),
        ),
      );

  /// Elevated card variant with stronger shadow
  static RemixCardStyle get elevated => RemixCardStyle(
        container: BoxStyle(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
            boxShadow: RemixTokens.elevationHigh(),
          ),
        ),
      );

  /// Outlined card variant with border
  static RemixCardStyle get outlined => RemixCardStyle(
        container: BoxStyle(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
          ),
        ),
      );

  /// Flat card variant without shadow
  static RemixCardStyle get flat => RemixCardStyle(
        container: BoxStyle(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surfaceVariant(),
          ),
        ),
      );
}
