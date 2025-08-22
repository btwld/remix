part of 'badge.dart';

class RemixBadgeStyle extends Style<BadgeSpec> with StyleModifierMixin<RemixBadgeStyle, BadgeSpec>, StyleVariantMixin<RemixBadgeStyle, BadgeSpec> {
  final Prop<WidgetContainerProperties>? $container;
  final Prop<TextSpec>? $text;
  final Prop<IconSpec>? $icon;

  const RemixBadgeStyle.create({
    Prop<WidgetContainerProperties>? container,
    Prop<TextSpec>? text,
    Prop<IconSpec>? icon,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixBadgeStyle({
    WidgetContainerPropertiesMix? container,
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

  factory RemixBadgeStyle.value(BadgeSpec spec) => RemixBadgeStyle(
        container: WidgetContainerPropertiesMix.maybeValue(spec.container),
        text: TextMix.maybeValue(spec.text),
        icon: IconMix.maybeValue(spec.icon),
      );

  /// Factory for background color
  factory RemixBadgeStyle.color(Color value) {
    return RemixBadgeStyle(container: WidgetContainerPropertiesMix.color(value));
  }

  /// Factory for border radius
  factory RemixBadgeStyle.borderRadius(double radius) {
    return RemixBadgeStyle(container: WidgetContainerPropertiesMix(decoration: BoxDecorationMix(borderRadius: BorderRadiusMix.circular(radius))));
  }

  /// Factory for padding
  factory RemixBadgeStyle.padding(double value) {
    return RemixBadgeStyle(container: WidgetContainerPropertiesMix.padding(EdgeInsetsGeometryMix.all(value)));
  }

  /// Factory for text color
  factory RemixBadgeStyle.textColor(Color value) {
    return RemixBadgeStyle(text: TextMix(style: TextStyleMix(color: value)));
  }

  // Instance methods (chainable)

  /// Sets background color
  RemixBadgeStyle color(Color value) {
    return merge(RemixBadgeStyle.color(value));
  }

  /// Sets border radius
  RemixBadgeStyle borderRadius(double radius) {
    return merge(RemixBadgeStyle.borderRadius(radius));
  }

  /// Sets padding
  RemixBadgeStyle padding(double value) {
    return merge(RemixBadgeStyle.padding(value));
  }

  /// Sets text color
  RemixBadgeStyle textColor(Color value) {
    return merge(RemixBadgeStyle.textColor(value));
  }

  /// Sets animation
  RemixBadgeStyle animate(AnimationConfig animation) {
    return merge(RemixBadgeStyle(animation: animation));
  }

  /// Sets variant
  @override
  RemixBadgeStyle variant(Variant variant, RemixBadgeStyle style) {
    return merge(RemixBadgeStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixBadgeStyle variants(List<VariantStyle<BadgeSpec>> value) {
    return merge(RemixBadgeStyle(variants: value));
  }

  @override
  RemixBadgeStyle wrap(ModifierConfig value) {
    return merge(RemixBadgeStyle(modifier: value));
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
  RemixBadgeStyle merge(RemixBadgeStyle? other) {
    if (other == null) return this;

    return RemixBadgeStyle.create(
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

final DefaultRemixBadgeStyle = RemixBadgeStyle(
  container: WidgetContainerPropertiesMix(
    padding: EdgeInsetsGeometryMix.symmetric(vertical: 4, horizontal: 8),
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
class RemixBadgeStyles {
  /// Default badge style
  static RemixBadgeStyle get defaultStyle => RemixBadgeStyle(
        container: WidgetContainerPropertiesMix(
          padding: EdgeInsetsGeometryMix.symmetric(vertical: 4, horizontal: 8),
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
  static RemixBadgeStyle get primary => RemixBadgeStyle(
        container: WidgetContainerPropertiesMix(
          padding: EdgeInsetsGeometryMix.symmetric(vertical: 4, horizontal: 8),
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
  static RemixBadgeStyle get success => RemixBadgeStyle(
        container: WidgetContainerPropertiesMix(
          padding: EdgeInsetsGeometryMix.symmetric(vertical: 4, horizontal: 8),
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
  static RemixBadgeStyle get warning => RemixBadgeStyle(
        container: WidgetContainerPropertiesMix(
          padding: EdgeInsetsGeometryMix.symmetric(vertical: 4, horizontal: 8),
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
  static RemixBadgeStyle get danger => RemixBadgeStyle(
        container: WidgetContainerPropertiesMix(
          padding: EdgeInsetsGeometryMix.symmetric(vertical: 4, horizontal: 8),
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
