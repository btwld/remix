part of 'avatar.dart';

class RemixAvatarStyle extends Style<AvatarSpec>
    with
        StyleModifierMixin<RemixAvatarStyle, AvatarSpec>,
        StyleVariantMixin<RemixAvatarStyle, AvatarSpec> {
  final Prop<ContainerProperties>? $container;
  final Prop<TextSpec>? $text;
  final Prop<IconSpec>? $icon;

  const RemixAvatarStyle.create({
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

  RemixAvatarStyle({
    ContainerPropertiesMix? container,
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

  factory RemixAvatarStyle.value(AvatarSpec spec) => RemixAvatarStyle(
        container: ContainerPropertiesMix.maybeValue(spec.container),
        text: TextMix.maybeValue(spec.text),
        icon: IconMix.maybeValue(spec.icon),
      );

  /// Factory for avatar size
  factory RemixAvatarStyle.size(double value) {
    return RemixAvatarStyle(
      container: ContainerPropertiesMix(
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
  factory RemixAvatarStyle.color(Color value) {
    return RemixAvatarStyle(
      container: ContainerPropertiesMix(
        decoration: BoxDecorationMix(color: value),
      ),
    );
  }

  /// Factory for border radius (for non-circular avatars)
  factory RemixAvatarStyle.borderRadius(double radius) {
    return RemixAvatarStyle(
      container: ContainerPropertiesMix(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }

  /// Factory for text color
  factory RemixAvatarStyle.textColor(Color value) {
    return RemixAvatarStyle(text: TextMix(style: TextStyleMix(color: value)));
  }

  /// Factory for icon color
  factory RemixAvatarStyle.iconColor(Color value) {
    return RemixAvatarStyle(icon: IconMix(color: value));
  }

  // Instance methods (chainable)

  /// Sets avatar size
  RemixAvatarStyle size(double value) {
    return merge(RemixAvatarStyle.size(value));
  }

  /// Sets background color
  RemixAvatarStyle color(Color value) {
    return merge(RemixAvatarStyle.color(value));
  }

  /// Sets border radius
  RemixAvatarStyle borderRadius(double radius) {
    return merge(RemixAvatarStyle.borderRadius(radius));
  }

  /// Sets text color
  RemixAvatarStyle textColor(Color value) {
    return merge(RemixAvatarStyle.textColor(value));
  }

  /// Sets icon color
  RemixAvatarStyle iconColor(Color value) {
    return merge(RemixAvatarStyle.iconColor(value));
  }

  /// Sets animation
  RemixAvatarStyle animate(AnimationConfig animation) {
    return merge(RemixAvatarStyle(animation: animation));
  }

  /// Sets variant
  @override
  RemixAvatarStyle variant(Variant variant, RemixAvatarStyle style) {
    return merge(RemixAvatarStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixAvatarStyle variants(List<VariantStyle<AvatarSpec>> value) {
    return merge(RemixAvatarStyle(variants: value));
  }

  @override
  RemixAvatarStyle wrap(ModifierConfig value) {
    return merge(RemixAvatarStyle(modifier: value));
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
  RemixAvatarStyle merge(RemixAvatarStyle? other) {
    if (other == null) return this;

    return RemixAvatarStyle.create(
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

final DefaultRemixAvatarStyle = RemixAvatarStyle(
  container: ContainerPropertiesMix(
    decoration: BoxDecorationMix(
      shape: BoxShape.circle,
      color: Colors.grey[300],
    ),
    alignment: Alignment.center,
    constraints: BoxConstraintsMix(
      minWidth: 50,
      maxWidth: 50,
      minHeight: 50,
      maxHeight: 50,
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

extension AvatarVariants on RemixAvatarStyle {
  /// Primary avatar variant with blue background and white text
  static RemixAvatarStyle get primary => RemixAvatarStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.blue[500],
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 50,
            maxWidth: 50,
            minHeight: 50,
            maxHeight: 50,
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconMix(color: Colors.white, size: 24),
      );

  /// Secondary avatar variant with grey background
  static RemixAvatarStyle get secondary => RemixAvatarStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.grey[500],
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 50,
            maxWidth: 50,
            minHeight: 50,
            maxHeight: 50,
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconMix(color: Colors.white, size: 24),
      );

  /// Small avatar variant (32x32)
  static RemixAvatarStyle get small => RemixAvatarStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 32,
            maxWidth: 32,
            minHeight: 32,
            maxHeight: 32,
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.black,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconMix(color: Colors.black, size: 16),
      );

  /// Large avatar variant (64x64)
  static RemixAvatarStyle get large => RemixAvatarStyle(
        container: ContainerPropertiesMix(
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: Colors.grey[300],
          ),
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 64,
            maxWidth: 64,
            minHeight: 64,
            maxHeight: 64,
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextMix(
          style: TextStyleMix(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconMix(color: Colors.black, size: 32),
      );
}
