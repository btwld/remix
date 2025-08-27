part of 'tooltip.dart';

class RemixTooltipStyle extends Style<TooltipSpec>
    with
        StyleModifierMixin<RemixTooltipStyle, TooltipSpec>,
        StyleVariantMixin<RemixTooltipStyle, TooltipSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<TextSpec>? $text;

  const RemixTooltipStyle.create({
    Prop<BoxSpec>? container,
    Prop<TextSpec>? text,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $text = text;

  RemixTooltipStyle({
    BoxMix? container,
    TextMix? text,
    AnimationConfig? animation,
    List<VariantStyle<TooltipSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  @override
  WidgetSpec<TooltipSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: TooltipSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
      inherit: $inherit,
    );
  }

  @override
  RemixTooltipStyle merge(RemixTooltipStyle? other) {
    if (other == null) return this;

    return RemixTooltipStyle.create(
      container: MixOps.merge($container, other.$container),
      text: MixOps.merge($text, other.$text),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  RemixTooltipStyle variant(Variant variant, RemixTooltipStyle style) {
    return merge(RemixTooltipStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixTooltipStyle variants(List<VariantStyle<TooltipSpec>> value) {
    return merge(RemixTooltipStyle(variants: value));
  }

  @override
  RemixTooltipStyle wrap(ModifierConfig value) {
    return merge(RemixTooltipStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $text,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

final DefaultRemixTooltipStyle = RemixTooltipStyle(
  container: BoxMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(8),
      color: RemixTokens.textPrimary().withValues(alpha: 0.8),
    ),
    padding: EdgeInsetsMix.all(10),
  ),
  text: TextMix(
    style: TextStyleMix(
      color: RemixTokens.background(),
      fontSize: RemixTokens.fontSizeSm(),
    ),
  ),
  animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
);

extension RemixTooltipVariants on RemixTooltipStyle {
  /// Dark tooltip variant (same as default)
  static RemixTooltipStyle get dark => RemixTooltipStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: RemixTokens.textPrimary().withValues(alpha: 0.9),
          ),
          padding: EdgeInsetsGeometryMix.all(10),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.background(),
            fontSize: RemixTokens.fontSizeSm(),
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
      );

  /// Light tooltip variant with white background
  static RemixTooltipStyle get light => RemixTooltipStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(8),
            color: RemixTokens.background(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
          padding: EdgeInsetsGeometryMix.all(10),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeSm(),
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
      );

  /// Primary tooltip variant with blue colors
  static RemixTooltipStyle get primary => RemixTooltipStyle(
        container: BoxMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: RemixTokens.primary(),
          ),
          padding: EdgeInsetsGeometryMix.all(10),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.background(),
            fontSize: RemixTokens.fontSizeSm(),
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
      );
}
