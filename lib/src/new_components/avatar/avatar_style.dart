part of 'avatar.dart';

class AvatarStyle extends Style<AvatarSpec> with StyleModifierMixin<AvatarStyle, AvatarSpec>, StyleVariantMixin<AvatarStyle, AvatarSpec> {
  final Prop<BoxSpec>? $container;
  final Prop<TextSpec>? $text;
  final Prop<IconSpec>? $icon;

  const AvatarStyle.create({
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

  AvatarStyle({
    BoxMix? container,
    TextMix? text,
    IconMix? icon,
    AnimationConfig? animation,
    List<VariantStyle<AvatarSpec>>? variants,
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

  factory AvatarStyle.value(AvatarSpec spec) => AvatarStyle(
        container: BoxMix.maybeValue(spec.container),
        text: TextMix.maybeValue(spec.text),
        icon: IconMix.maybeValue(spec.icon),
      );

  /// Factory for avatar size
  factory AvatarStyle.size(double value) {
    return AvatarStyle(
      container: BoxMix(
        constraints: BoxConstraintsMix(
          minWidth: value,
          maxWidth: value,
          minHeight: value,
          maxHeight: value,
        ),
      ),
    );
  }

  /// Factory for background color
  factory AvatarStyle.color(Color value) {
    return AvatarStyle(container: BoxMix(decoration: BoxDecorationMix(color: value)));
  }

  /// Factory for border radius (for non-circular avatars)
  factory AvatarStyle.borderRadius(double radius) {
    return AvatarStyle(
      container: BoxMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }

  /// Factory for text color
  factory AvatarStyle.textColor(Color value) {
    return AvatarStyle(text: TextMix(style: TextStyleMix(color: value)));
  }

  /// Factory for icon color
  factory AvatarStyle.iconColor(Color value) {
    return AvatarStyle(icon: IconMix(color: value));
  }

  // Instance methods (chainable)

  /// Sets avatar size
  AvatarStyle size(double value) {
    return merge(AvatarStyle.size(value));
  }

  /// Sets background color
  AvatarStyle color(Color value) {
    return merge(AvatarStyle.color(value));
  }

  /// Sets border radius
  AvatarStyle borderRadius(double radius) {
    return merge(AvatarStyle.borderRadius(radius));
  }

  /// Sets text color
  AvatarStyle textColor(Color value) {
    return merge(AvatarStyle.textColor(value));
  }

  /// Sets icon color
  AvatarStyle iconColor(Color value) {
    return merge(AvatarStyle.iconColor(value));
  }

  /// Sets animation
  AvatarStyle animate(AnimationConfig animation) {
    return merge(AvatarStyle(animation: animation));
  }

  /// Sets variant
  @override
  AvatarStyle variant(Variant variant, AvatarStyle style) {
    return merge(AvatarStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  AvatarStyle variants(List<VariantStyle<AvatarSpec>> value) {
    return merge(AvatarStyle(variants: value));
  }

  @override
  AvatarStyle wrap(ModifierConfig value) {
    return merge(AvatarStyle(modifier: value));
  }

  @override
  AvatarSpec resolve(BuildContext context) {
    return AvatarSpec(
      container: MixOps.resolve(context, $container),
      text: MixOps.resolve(context, $text),
      icon: MixOps.resolve(context, $icon),
    );
  }

  @override
  AvatarStyle merge(AvatarStyle? other) {
    if (other == null) return this;

    return AvatarStyle.create(
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

final DefaultAvatarStyle = AvatarStyle(
  container: BoxMix(
    alignment: Alignment.center,
    constraints: BoxConstraintsMix(
      minWidth: 50,
      maxWidth: 50,
      minHeight: 50,
      maxHeight: 50,
    ),
    decoration: BoxDecorationMix(
      shape: BoxShape.circle,
      color: Colors.grey[300],
    ),
    clipBehavior: Clip.antiAlias,
  ),
  text: TextMix(
    style: TextStyleMix(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
  ),
  icon: IconMix(color: Colors.black, size: 24),
);
