part of 'badge.dart';

class RemixBadgeStyle extends Style<BadgeSpec>
    with
        StyleModifierMixin<RemixBadgeStyle, BadgeSpec>,
        StyleVariantMixin<RemixBadgeStyle, BadgeSpec> {
  final Prop<ContainerSpec>? $container;
  final Prop<TextSpec>? $text;
  final Prop<IconSpec>? $icon;

  const RemixBadgeStyle.create({
    Prop<ContainerSpec>? container,
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
    ContainerSpecMix? container,
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
        container: ContainerSpecMix.maybeValue(spec.container),
        text: TextMix.maybeValue(spec.text),
        icon: IconMix.maybeValue(spec.icon),
      );

  /// Factory for background color
  factory RemixBadgeStyle.color(Color value) {
    return RemixBadgeStyle(container: ContainerSpecMix.color(value));
  }

  /// Factory for border radius
  factory RemixBadgeStyle.borderRadius(double radius) {
    return RemixBadgeStyle(
      container: ContainerSpecMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
        ),
      ),
    );
  }

  /// Factory for padding
  factory RemixBadgeStyle.padding(double value) {
    return RemixBadgeStyle(
      container: ContainerSpecMix.padding(EdgeInsetsGeometryMix.all(value)),
    );
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
  container: ContainerSpecMix(
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
      color: RemixTokens.surfaceVariant(),
    ),
    padding: EdgeInsetsGeometryMix.symmetric(
      vertical: RemixTokens.spaceXs(),
      horizontal: RemixTokens.spaceSm(),
    ),
  ),
  text: TextMix(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: RemixTokens.fontSizeSm(),
      fontWeight: FontWeight.w500,
    ),
  ),
  icon:
      IconMix(color: RemixTokens.textPrimary(), size: RemixTokens.iconSizeSm()),
);

/// Default badge styles and variants
class RemixBadgeStyles {
  /// Default badge style
  static RemixBadgeStyle get defaultStyle => RemixBadgeStyle(
        container: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.surfaceVariant(),
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(
          color: RemixTokens.textPrimary(),
          size: RemixTokens.iconSizeSm(),
        ),
      );

  /// Primary badge variant
  static RemixBadgeStyle get primary => RemixBadgeStyle(
        container: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.primary(),
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.surface(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(
          color: RemixTokens.surface(),
          size: RemixTokens.iconSizeSm(),
        ),
      );

  /// Success badge variant
  static RemixBadgeStyle get success => RemixBadgeStyle(
        container: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.success(),
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.surface(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(
          color: RemixTokens.surface(),
          size: RemixTokens.iconSizeSm(),
        ),
      );

  /// Warning badge variant
  static RemixBadgeStyle get warning => RemixBadgeStyle(
        container: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.warning(),
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.surface(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(
          color: RemixTokens.surface(),
          size: RemixTokens.iconSizeSm(),
        ),
      );

  /// Danger badge variant
  static RemixBadgeStyle get danger => RemixBadgeStyle(
        container: ContainerSpecMix(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(RemixTokens.radiusSm()),
            color: RemixTokens.danger(),
          ),
          padding: EdgeInsetsGeometryMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
        ),
        text: TextMix(
          style: TextStyleMix(
            color: RemixTokens.surface(),
            fontSize: RemixTokens.fontSizeSm(),
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(
          color: RemixTokens.surface(),
          size: RemixTokens.iconSizeSm(),
        ),
      );
}
