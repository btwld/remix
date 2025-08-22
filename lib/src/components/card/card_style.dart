part of 'card.dart';

class RemixCardStyle extends Style<CardSpec> with StyleModifierMixin<RemixCardStyle, CardSpec>, StyleVariantMixin<RemixCardStyle, CardSpec> {
  final Prop<WidgetContainerProperties>? $container;

  const RemixCardStyle.create({
    Prop<WidgetContainerProperties>? container,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  }) : $container = container;

  RemixCardStyle({
    WidgetContainerPropertiesMix? container,
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

  factory RemixCardStyle.value(CardSpec spec) => RemixCardStyle(
        container: WidgetContainerPropertiesMix.maybeValue(spec.container),
      );

  @override
  CardSpec resolve(BuildContext context) {
    return CardSpec(container: MixOps.resolve(context, $container));
  }

  @override
  RemixCardStyle merge(RemixCardStyle? other) {
    if (other == null) return this;

    return RemixCardStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
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
  List<Object?> get props => [
        $container,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixCardStyle = RemixCardStyle(
  container: WidgetContainerPropertiesMix(
    padding: EdgeInsetsGeometryMix.all(16),
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
class RemixCardStyles {
  /// Default card style
  static RemixCardStyle get defaultStyle => RemixCardStyle(
        container: WidgetContainerPropertiesMix(
          padding: EdgeInsetsGeometryMix.all(16),
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
  static RemixCardStyle get elevated => RemixCardStyle(
        container: WidgetContainerPropertiesMix(
          padding: EdgeInsetsGeometryMix.all(16),
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
  static RemixCardStyle get outlined => RemixCardStyle(
        container: WidgetContainerPropertiesMix(
          padding: EdgeInsetsGeometryMix.all(16),
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
  static RemixCardStyle get flat => RemixCardStyle(
        container: WidgetContainerPropertiesMix(
          padding: EdgeInsetsGeometryMix.all(16),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: Colors.grey[100],
          ),
        ),
      );
}
