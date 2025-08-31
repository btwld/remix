part of 'card.dart';

class RemixCardStyle extends Style<CardSpec>
    with
        StyleModifierMixin<RemixCardStyle, CardSpec>,
        StyleVariantMixin<RemixCardStyle, CardSpec> {
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
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

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
  container: BoxStyler(
    padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
      color: RemixTokens.surface(),
      boxShadow: [
        BoxShadowMix(
          color: RemixTokens.textPrimary().withValues(alpha: 0.1),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ],
    ),
  ),
);

/// Default card styles and variants
class RemixCardStyles {
  /// Default card style
  static RemixCardStyle get defaultStyle => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      );

  /// Elevated card variant with stronger shadow
  static RemixCardStyle get elevated => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.15),
                offset: const Offset(0, 4),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      );

  /// Outlined card variant with border
  static RemixCardStyle get outlined => RemixCardStyle(
        container: BoxStyler(
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
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceLg()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surfaceVariant(),
          ),
        ),
      );
}
