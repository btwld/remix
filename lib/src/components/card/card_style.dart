part of 'card.dart';

class CardStyle extends Style<CardSpec> with StyleModifierMixin<CardStyle, CardSpec>, StyleVariantMixin<CardStyle, CardSpec> {
  final Prop<BoxSpec>? $container;

  const CardStyle.create({
    Prop<BoxSpec>? container,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  }) : $container = container;

  CardStyle({
    BoxMix? container,
    AnimationConfig? animation,
    List<VariantStyle<CardSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory CardStyle.value(CardSpec spec) => CardStyle(
        container: BoxMix.maybeValue(spec.container),
      );

  @override
  CardSpec resolve(BuildContext context) {
    return CardSpec(container: MixOps.resolve(context, $container));
  }

  @override
  CardStyle merge(CardStyle? other) {
    if (other == null) return this;

    return CardStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  CardStyle variant(Variant variant, CardStyle style) {
    return merge(CardStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  CardStyle variants(List<VariantStyle<CardSpec>> value) {
    return merge(CardStyle(variants: value));
  }

  @override
  CardStyle wrap(ModifierConfig value) {
    return merge(CardStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultCardStyle = CardStyle(
  container: BoxMix(
    padding: EdgeInsetsMix.all(16),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(8),
      color: Colors.white,
      boxShadow: [
        BoxShadowMix(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 2),
          blurRadius: 4,
        ),
      ],
    ),
  ),
);

/// Default card styles and variants
class CardStyles {
  /// Default card style
  static CardStyle get defaultStyle => CardStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(16),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadowMix(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
      );

  /// Elevated card variant with stronger shadow
  static CardStyle get elevated => CardStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(16),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.white,
            boxShadow: [
              BoxShadowMix(
                color: Colors.black.withValues(alpha: 0.15),
                offset: const Offset(0, 4),
                blurRadius: 8,
              ),
            ],
          ),
        ),
      );

  /// Outlined card variant with border
  static CardStyle get outlined => CardStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(16),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.grey[300]!, width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.white,
          ),
        ),
      );

  /// Flat card variant without shadow
  static CardStyle get flat => CardStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(16),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.grey[100],
          ),
        ),
      );
}
