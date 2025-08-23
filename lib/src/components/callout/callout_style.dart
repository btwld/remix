part of 'callout.dart';

class RemixCalloutStyle extends Style<CalloutSpec>
    with
        StyleModifierMixin<RemixCalloutStyle, CalloutSpec>,
        StyleVariantMixin<RemixCalloutStyle, CalloutSpec> {
  final Prop<ContainerProperties>? $container;
  final Prop<TextSpec>? $text;
  final Prop<IconSpec>? $icon;

  const RemixCalloutStyle.create({
    Prop<ContainerProperties>? container,
    Prop<TextSpec>? text,
    Prop<IconSpec>? icon,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixCalloutStyle({
    ContainerPropertiesMix? container,
    TextMix? text,
    IconMix? icon,
    AnimationConfig? animation,
    List<VariantStyle<CalloutSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          container: container != null ? Prop.mix(container) : null,
          text: text != null ? Prop.mix(text) : null,
          icon: icon != null ? Prop.mix(icon) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixCalloutStyle.value(CalloutSpec spec) => RemixCalloutStyle(
        container: ContainerPropertiesMix.maybeValue(spec.container),
        text: TextMix.maybeValue(spec.text),
        icon: IconMix.maybeValue(spec.icon),
      );

  @override
  CalloutSpec resolve(BuildContext context) {
    return CalloutSpec(
      container: MixOps.resolve(context, $container),
      text: MixOps.resolve(context, $text),
      icon: MixOps.resolve(context, $icon),
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
      inherit: other.$inherit ?? $inherit,
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
        $inherit,
      ];
}

final DefaultRemixCalloutStyle = RemixCalloutStyle(
  container: ContainerPropertiesMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: RemixTokens.border(),
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(6),
      color: RemixTokens.background(),
    ),
    padding: EdgeInsetsMix.all(12),
  ),
  text: TextMix(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  icon: IconMix(color: RemixTokens.textPrimary(), size: 16),
);

extension CalloutVariants on RemixCalloutStyle {
  /// Info callout variant with blue colors
  static RemixCalloutStyle get info => RemixCalloutStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.primary().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.primary().withValues(alpha: 0.1),
          ),
          padding: EdgeInsetsGeometryMix.all(12),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: RemixTokens.primary(), size: 16),
      );

  /// Success callout variant with green colors
  static RemixCalloutStyle get success => RemixCalloutStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.success().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.success().withValues(alpha: 0.1),
          ),
          padding: EdgeInsetsGeometryMix.all(12),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.success(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: RemixTokens.success(), size: 16),
      );

  /// Warning callout variant with orange colors
  static RemixCalloutStyle get warning => RemixCalloutStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.warning().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.warning().withValues(alpha: 0.1),
          ),
          padding: EdgeInsetsGeometryMix.all(12),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.warning(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: RemixTokens.warning(), size: 16),
      );

  /// Error callout variant with red colors
  static RemixCalloutStyle get error => RemixCalloutStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: RemixTokens.danger().withValues(alpha: 0.6),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: RemixTokens.danger().withValues(alpha: 0.1),
          ),
          padding: EdgeInsetsGeometryMix.all(12),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.danger(),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: RemixTokens.danger(), size: 16),
      );
}
