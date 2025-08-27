part of 'card.dart';

class RemixCardStyle extends Style<CardSpec>
    with
        StyleModifierMixin<RemixCardStyle, CardSpec>,
        StyleVariantMixin<RemixCardStyle, CardSpec> {
  final Prop<BoxSpec>? $container;

  const RemixCardStyle.create({
    Prop<BoxSpec>? container,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  }) : $container = container;

  RemixCardStyle({
    BoxMix? container,
    AnimationConfig? animation,
    List<VariantStyle<CardSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: Prop.maybeMix(container),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixCardStyle.value(CardSpec spec) => RemixCardStyle(
        container: BoxMix.maybeValue(spec.container),
      );

  @override
  WidgetSpec<CardSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: CardSpec(container: MixOps.resolve(context, $container)),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
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
  container: BoxMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
      color: RemixTokens.surface(),
      boxShadow: RemixTokens.elevationMd(),
    ),
    padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceLg()),
  ),
);

/// Default card styles and variants
class RemixCardStyles {
  /// Default card style
  static RemixCardStyle get defaultStyle => RemixCardStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
            boxShadow: RemixTokens.elevationMd(),
          ),
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceLg()),
        ),
      );

  /// Elevated card variant with stronger shadow
  static RemixCardStyle get elevated => RemixCardStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
            boxShadow: RemixTokens.elevationHigh(),
          ),
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceLg()),
        ),
      );

  /// Outlined card variant with border
  static RemixCardStyle get outlined => RemixCardStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surface(),
          ),
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceLg()),
        ),
      );

  /// Flat card variant without shadow
  static RemixCardStyle get flat => RemixCardStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusLg()),
            color: RemixTokens.surfaceVariant(),
          ),
          padding: EdgeInsetsGeometryMix.all(RemixTokens.spaceLg()),
        ),
      );
}
