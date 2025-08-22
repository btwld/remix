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
        color: Colors.grey[300]!,
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(6),
      color: Colors.white,
    ),
    padding: EdgeInsetsMix.all(12),
  ),
  text: TextMix(
    style: TextStyleMix(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  icon: IconMix(color: Colors.black, size: 16),
);

extension CalloutVariants on RemixCalloutStyle {
  /// Info callout variant with blue colors
  static RemixCalloutStyle get info => RemixCalloutStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.blue[300]!,
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: Colors.blue[50],
          ),
          padding: EdgeInsetsGeometryMix.all(12),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.blue[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.blue[600], size: 16),
      );

  /// Success callout variant with green colors
  static RemixCalloutStyle get success => RemixCalloutStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.green[300]!,
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: Colors.green[50],
          ),
          padding: EdgeInsetsGeometryMix.all(12),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.green[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.green[600], size: 16),
      );

  /// Warning callout variant with orange colors
  static RemixCalloutStyle get warning => RemixCalloutStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.orange[300]!,
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: Colors.orange[50],
          ),
          padding: EdgeInsetsGeometryMix.all(12),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.orange[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.orange[600], size: 16),
      );

  /// Error callout variant with red colors
  static RemixCalloutStyle get error => RemixCalloutStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.red[300]!,
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: Colors.red[50],
          ),
          padding: EdgeInsetsGeometryMix.all(12),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.red[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.red[600], size: 16),
      );
}
