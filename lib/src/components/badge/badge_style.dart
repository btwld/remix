part of 'badge.dart';

class BadgeStyle extends Style<BadgeSpec> with StyleModifierMixin<BadgeStyle, BadgeSpec>, StyleVariantMixin<BadgeStyle, BadgeSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<TextSpec>? $text;
  final Prop<IconSpec>? $icon;

  const BadgeStyle.create({
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

  BadgeStyle({
    BoxMix? container,
    TextMix? text,
    IconMix? icon,
    AnimationConfig? animation,
    List<VariantStyle<BadgeSpec>>? variants,
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

  factory BadgeStyle.value(BadgeSpec spec) => BadgeStyle(
        container: BoxMix.maybeValue(spec.container),
        text: TextMix.maybeValue(spec.text),
        icon: IconMix.maybeValue(spec.icon),
      );

  /// Factory for background color
  factory BadgeStyle.color(Color value) {
    return BadgeStyle(container: BoxMix(decoration: BoxDecorationMix(color: value)));
  }

  /// Factory for border radius
  factory BadgeStyle.borderRadius(double radius) {
    return BadgeStyle(container: BoxMix(decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(radius))));
  }

  /// Factory for padding
  factory BadgeStyle.padding(double value) {
    return BadgeStyle(container: BoxMix(padding: EdgeInsetsMix.all(value)));
  }

  /// Factory for text color
  factory BadgeStyle.textColor(Color value) {
    return BadgeStyle(text: TextMix(style: TextStyleMix(color: value)));
  }

  // Instance methods (chainable)

  /// Sets background color
  BadgeStyle color(Color value) {
    return merge(BadgeStyle.color(value));
  }

  /// Sets border radius
  BadgeStyle borderRadius(double radius) {
    return merge(BadgeStyle.borderRadius(radius));
  }

  /// Sets padding
  BadgeStyle padding(double value) {
    return merge(BadgeStyle.padding(value));
  }

  /// Sets text color
  BadgeStyle textColor(Color value) {
    return merge(BadgeStyle.textColor(value));
  }

  /// Sets animation
  BadgeStyle animate(AnimationConfig animation) {
    return merge(BadgeStyle(animation: animation));
  }

  /// Sets variant
  @override
  BadgeStyle variant(Variant variant, BadgeStyle style) {
    return merge(BadgeStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  BadgeStyle variants(List<VariantStyle<BadgeSpec>> value) {
    return merge(BadgeStyle(variants: value));
  }

  @override
  BadgeStyle wrap(ModifierConfig value) {
    return merge(BadgeStyle(modifier: value));
  }

  @override
  BadgeSpec resolve(BuildContext context) {
    return BadgeSpec(
      container: MixOps.resolve(context, $container),
      text: MixOps.resolve(context, $text),
      icon: MixOps.resolve(context, $icon),
    );
  }

  @override
  BadgeStyle merge(BadgeStyle? other) {
    if (other == null) return this;

    return BadgeStyle.create(
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

final DefaultBadgeStyle = BadgeStyle(
  container: BoxMix(
    padding: EdgeInsetsMix.symmetric(vertical: 4, horizontal: 8),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(4),
      color: Colors.grey[200],
    ),
  ),
  text: TextMix(
    style: TextStyleMix(fontSize: 12, fontWeight: FontWeight.w500),
  ),
  icon: IconMix(size: 14),
);

/// Default badge styles and variants
class BadgeStyles {
  /// Default badge style
  static BadgeStyle get defaultStyle => BadgeStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(4),
            color: Colors.grey[200],
          ),
        ),
        text: TextMix(
          style: TextStyleMix(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        icon: IconMix(size: 14),
      );

  /// Primary badge variant
  static BadgeStyle get primary => BadgeStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(4),
            color: Colors.blue,
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.white, size: 14),
      );

  /// Success badge variant
  static BadgeStyle get success => BadgeStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(4),
            color: Colors.green,
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.white, size: 14),
      );

  /// Warning badge variant
  static BadgeStyle get warning => BadgeStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(4),
            color: Colors.orange,
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.white, size: 14),
      );

  /// Danger badge variant
  static BadgeStyle get danger => BadgeStyle(
        container: BoxMix(
          padding: EdgeInsetsMix.symmetric(vertical: 4, horizontal: 8),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(4),
            color: Colors.red,
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.white, size: 14),
      );
}
