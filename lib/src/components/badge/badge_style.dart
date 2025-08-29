part of 'badge.dart';

class RemixBadgeStyle extends Style<BadgeSpec>
    with
        StyleModifierMixin<RemixBadgeStyle, BadgeSpec>,
        StyleVariantMixin<RemixBadgeStyle, BadgeSpec> {
  final Prop<WidgetSpec<BoxSpec>>? $container;
  final Prop<WidgetSpec<TextSpec>>? $text;
  final Prop<WidgetSpec<IconSpec>>? $icon;

  const RemixBadgeStyle.create({
    Prop<WidgetSpec<BoxSpec>>? container,
    Prop<WidgetSpec<TextSpec>>? text,
    Prop<WidgetSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixBadgeStyle({
    BoxStyle? container,
    TextStyling? text,
    IconStyle? icon,
    AnimationConfig? animation,
    List<VariantStyle<BadgeSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Factory for background color
  factory RemixBadgeStyle.color(Color value) {
    return RemixBadgeStyle(
      container: BoxStyle(decoration: BoxDecorationMix(color: value)),
    );
  }

  /// Factory for border radius
  factory RemixBadgeStyle.borderRadius(double radius) {
    return RemixBadgeStyle(
      container: BoxStyle(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    );
  }

  /// Factory for padding
  factory RemixBadgeStyle.padding(double value) {
    return RemixBadgeStyle(
      container: BoxStyle(padding: EdgeInsetsMix.all(value)),
    );
  }

  /// Factory for text color
  factory RemixBadgeStyle.textColor(Color value) {
    return RemixBadgeStyle(
      text: TextStyling(style: TextStyleMix(color: value)),
    );
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
  WidgetSpec<BadgeSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: BadgeSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
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
      ];
}

final DefaultRemixBadgeStyle = RemixBadgeStyle(
  container: BoxStyle(
    padding: EdgeInsetsMix.symmetric(
      vertical: RemixTokens.spaceXs(),
      horizontal: RemixTokens.spaceSm(),
    ),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
      color: RemixTokens.surfaceVariant(),
    ),
  ),
  text: TextStyling(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: RemixTokens.fontSizeSm(),
      fontWeight: FontWeight.w500,
    ),
  ),
  icon: IconStyle(
    color: RemixTokens.textPrimary(),
    size: RemixTokens.iconSizeSm(),
  ),
);

/// Default badge styles and variants
class RemixBadgeStyles {
  /// Default badge style
  static RemixBadgeStyle get defaultStyle => RemixBadgeStyle(
        container: BoxStyle(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.surfaceVariant(),
          ),
        ),
        text: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyle(
          color: RemixTokens.textPrimary(),
          size: RemixTokens.iconSizeSm(),
        ),
      );

  /// Primary badge variant
  static RemixBadgeStyle get primary => RemixBadgeStyle(
        container: BoxStyle(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.primary(),
          ),
        ),
        text: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.surface(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyle(
          color: RemixTokens.surface(),
          size: RemixTokens.iconSizeSm(),
        ),
      );

  /// Success badge variant
  static RemixBadgeStyle get success => RemixBadgeStyle(
        container: BoxStyle(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.success(),
          ),
        ),
        text: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.surface(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyle(
          color: RemixTokens.surface(),
          size: RemixTokens.iconSizeSm(),
        ),
      );

  /// Warning badge variant
  static RemixBadgeStyle get warning => RemixBadgeStyle(
        container: BoxStyle(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.warning(),
          ),
        ),
        text: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.surface(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyle(
          color: RemixTokens.surface(),
          size: RemixTokens.iconSizeSm(),
        ),
      );

  /// Danger badge variant
  static RemixBadgeStyle get danger => RemixBadgeStyle(
        container: BoxStyle(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.danger(),
          ),
        ),
        text: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.surface(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyle(
          color: RemixTokens.surface(),
          size: RemixTokens.iconSizeSm(),
        ),
      );
}
