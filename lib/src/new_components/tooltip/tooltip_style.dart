part of 'tooltip.dart';

class TooltipStyle extends Style<TooltipSpec>
    with StyleModifierMixin<TooltipStyle, TooltipSpec>, StyleVariantMixin<TooltipStyle, TooltipSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<TextSpec>? $text;

  const TooltipStyle.create({
    Prop<BoxSpec>? container,
    Prop<TextSpec>? text,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $text = text;

  TooltipStyle({
    BoxMix? container,
    TextMix? text,
    AnimationConfig? animation,
    List<VariantStyle<TooltipSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          text: text != null ? Prop.mix(text) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  @override
  TooltipSpec resolve(BuildContext context) {
    return TooltipSpec(
      container: MixOps.resolve(context, $container),
      text: MixOps.resolve(context, $text),
    );
  }

  @override
  TooltipStyle merge(TooltipStyle? other) {
    if (other == null) return this;

    return TooltipStyle.create(
      container: MixOps.merge($container, other.$container),
      text: MixOps.merge($text, other.$text),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  TooltipStyle variant(Variant variant, TooltipStyle style) {
    return merge(TooltipStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  TooltipStyle variants(List<VariantStyle<TooltipSpec>> value) {
    return merge(TooltipStyle(variants: value));
  }
  
  @override
  TooltipStyle wrap(ModifierConfig value) {
    return merge(TooltipStyle(modifier: value));
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

final DefaultTooltipStyle = TooltipStyle(
  container: BoxMix(
    padding: EdgeInsetsMix.all(10),
    decoration: BoxDecorationMix(
      color: Colors.black.withValues(alpha: 0.8),
      borderRadius: BorderRadiusMix.circular(8),
    ),
  ),
  text: TextMix(
    style: TextStyleMix(
      color: Colors.white,
      fontSize: 14,
    ),
  ),
  animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
);

extension TooltipVariants on TooltipStyle {
  /// Dark tooltip variant (same as default)
  static TooltipStyle get dark => TooltipStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(10),
          decoration: BoxDecorationMix(
            color: Colors.black.withValues(alpha: 0.9),
            borderRadius: BorderRadiusMix.circular(8),
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      );

  /// Light tooltip variant with white background
  static TooltipStyle get light => TooltipStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(10),
          decoration: BoxDecorationMix(
            color: Colors.white,
            borderRadius: BorderRadiusMix.circular(8),
            border: BoxBorderMix.all(
              BorderSideMix(color: Colors.grey[300]!, width: 1),
            ),
            boxShadow: [
              BoxShadowMix(
                color: Colors.black.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.black87,
            fontSize: 14,
          ),
        ),
      );

  /// Primary tooltip variant with blue colors
  static TooltipStyle get primary => TooltipStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(10),
          decoration: BoxDecorationMix(
            color: Colors.blue[600],
            borderRadius: BorderRadiusMix.circular(8),
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      );
}