part of 'callout.dart';

class RemixCalloutStyle extends Style<CalloutSpec>
    with
        StyleModifierMixin<RemixCalloutStyle, CalloutSpec>,
        StyleVariantMixin<RemixCalloutStyle, CalloutSpec> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixCalloutStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixCalloutStyle({
    BoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<CalloutSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  @override
  StyleSpec<CalloutSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: CalloutSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCalloutStyle merge(RemixCalloutStyle? other) {
    if (other == null) return this;

    return RemixCalloutStyle.create(
      container: MixOps.merge($container, other.$container),
      text: MixOps.merge($text, other.$text),
      icon: MixOps.merge($icon, other.$icon),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
    );
  }

  @override
  RemixCalloutStyle variant(Variant variant, RemixCalloutStyle style) {
    return merge(RemixCalloutStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixCalloutStyle variants(List<VariantStyle<CalloutSpec>> value) {
    return merge(RemixCalloutStyle(variants: value));
  }

  @override
  RemixCalloutStyle wrap(ModifierConfig value) {
    return merge(RemixCalloutStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $text,
        $icon,
        $variants,
        $animation,
        $modifier,
      ];
}

final DefaultRemixCalloutStyle = RemixCalloutStyle(
  container: BoxStyler(
    padding: EdgeInsetsMix.all(12),
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(6),
      color: RemixTokens.background(),
    ),
  ),
  text: TextStyler(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  icon: IconStyler(color: RemixTokens.textPrimary(), size: 16),
);

extension CalloutVariants on RemixCalloutStyle {
  /// Info callout variant with blue colors
  static RemixCalloutStyle get info => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.primary().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.primary().withValues(alpha: 0.1),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.primary(), size: 16),
      );

  /// Success callout variant with green colors
  static RemixCalloutStyle get success => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.success().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.success().withValues(alpha: 0.1),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.success(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.success(), size: 16),
      );

  /// Warning callout variant with orange colors
  static RemixCalloutStyle get warning => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.warning().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.warning().withValues(alpha: 0.1),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.warning(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.warning(), size: 16),
      );

  /// Error callout variant with red colors
  static RemixCalloutStyle get error => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.danger().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.danger().withValues(alpha: 0.1),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.danger(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.danger(), size: 16),
      );
}
