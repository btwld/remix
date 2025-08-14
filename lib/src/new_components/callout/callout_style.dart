part of 'callout.dart';

class CalloutStyle extends Style<CalloutSpec>
    with StyleModifierMixin<CalloutStyle, CalloutSpec>, StyleVariantMixin<CalloutStyle, CalloutSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<TextSpec>? $text;
  final Prop<IconSpec>? $icon;

  const CalloutStyle.create({
    Prop<BoxSpec>? container,
    Prop<TextSpec>? text,
    Prop<IconSpec>? icon,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $text = text,
        $icon = icon;

  CalloutStyle({
    BoxMix? container,
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

  factory CalloutStyle.value(CalloutSpec spec) => CalloutStyle(
        container: BoxMix.maybeValue(spec.container),
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
  CalloutStyle merge(CalloutStyle? other) {
    if (other == null) return this;

    return CalloutStyle.create(
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
  CalloutStyle variant(Variant variant, CalloutStyle style) {
    return merge(CalloutStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  CalloutStyle variants(List<VariantStyle<CalloutSpec>> value) {
    return merge(CalloutStyle(variants: value));
  }
  
  @override
  CalloutStyle wrap(ModifierConfig value) {
    return merge(CalloutStyle(modifier: value));
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

final DefaultCalloutStyle = CalloutStyle(
  container: BoxMix(
    padding: EdgeInsetsMix.all(12),
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: Colors.grey[300]!,
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(6),
      color: Colors.white,
    ),
  ),
  text: TextMix(
    style: TextStyleMix(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
  ),
  icon: IconMix(
    color: Colors.black,
    size: 16,
  ),
);

extension CalloutVariants on CalloutStyle {
  /// Info callout variant with blue colors
  static CalloutStyle get info => CalloutStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.blue[300]!,
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: Colors.blue[50],
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.blue[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(
          color: Colors.blue[600],
          size: 16,
        ),
      );

  /// Success callout variant with green colors
  static CalloutStyle get success => CalloutStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.green[300]!,
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: Colors.green[50],
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.green[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(
          color: Colors.green[600],
          size: 16,
        ),
      );

  /// Warning callout variant with orange colors
  static CalloutStyle get warning => CalloutStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.orange[300]!,
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: Colors.orange[50],
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.orange[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(
          color: Colors.orange[600],
          size: 16,
        ),
      );

  /// Error callout variant with red colors
  static CalloutStyle get error => CalloutStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.all(12),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: Colors.red[300]!,
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(6),
            color: Colors.red[50],
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.red[700],
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(
          color: Colors.red[600],
          size: 16,
        ),
      );
}
