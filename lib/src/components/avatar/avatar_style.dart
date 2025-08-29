part of 'avatar.dart';

class RemixAvatarStyle extends Style<AvatarSpec>
    with
        StyleModifierMixin<RemixAvatarStyle, AvatarSpec>,
        StyleVariantMixin<RemixAvatarStyle, AvatarSpec> {
  final Prop<WidgetSpec<BoxSpec>>? $container;
  final Prop<WidgetSpec<TextSpec>>? $text;
  final Prop<WidgetSpec<IconSpec>>? $icon;

  const RemixAvatarStyle.create({
    Prop<WidgetSpec<BoxSpec>>? container,
    Prop<WidgetSpec<TextSpec>>? text,
    Prop<WidgetSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixAvatarStyle({
    BoxStyle? container,
    TextStyling? text,
    IconStyle? icon,
    AnimationConfig? animation,
    List<VariantStyle<AvatarSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Factory for avatar size
  factory RemixAvatarStyle.size(double value) {
    return RemixAvatarStyle(
      container: BoxStyle(
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
      container: BoxStyle(decoration: BoxDecorationMix(color: value)),
    );
  }

  /// Factory for border radius (for non-circular avatars)
  factory RemixAvatarStyle.borderRadius(double radius) {
    return RemixAvatarStyle(
      container: BoxStyle(
        decoration: BoxDecorationMix(
          borderRadius: BorderRadiusMix.circular(radius),
          shape: BoxShape.rectangle,
        ),
      ),
    );
  }

  /// Factory for text color
  factory RemixAvatarStyle.textColor(Color value) {
    return RemixAvatarStyle(
      text: TextStyling(style: TextStyleMix(color: value)),
    );
  }

  /// Factory for icon color
  factory RemixAvatarStyle.iconColor(Color value) {
    return RemixAvatarStyle(icon: IconStyle(color: value));
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
  WidgetSpec<AvatarSpec> resolve(BuildContext context) {
    return WidgetSpec(
      spec: AvatarSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
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

final DefaultRemixAvatarStyle = RemixAvatarStyle(
  container: BoxStyle(
    alignment: Alignment.center,
    constraints: BoxConstraintsMix(
      minWidth: 50,
      maxWidth: 50,
      minHeight: 50,
      maxHeight: 50,
    ),
    decoration: BoxDecorationMix(
      shape: BoxShape.circle,
      color: RemixTokens.surface(),
    ),
    clipBehavior: Clip.antiAlias,
  ),
  text: TextStyling(
    style: TextStyleMix(
      color: RemixTokens.textPrimary(),
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),
  ),
  icon: IconStyle(color: RemixTokens.textPrimary(), size: 24),
);

extension AvatarVariants on RemixAvatarStyle {
  /// Primary avatar variant with blue background and white text
  static RemixAvatarStyle get primary => RemixAvatarStyle(
        container: BoxStyle(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 50,
            maxWidth: 50,
            minHeight: 50,
            maxHeight: 50,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.primary(),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.background(),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyle(color: RemixTokens.background(), size: 24),
      );

  /// Secondary avatar variant with grey background
  static RemixAvatarStyle get secondary => RemixAvatarStyle(
        container: BoxStyle(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 50,
            maxWidth: 50,
            minHeight: 50,
            maxHeight: 50,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.textSecondary(),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.background(),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyle(color: RemixTokens.background(), size: 24),
      );

  /// Small avatar variant (32x32)
  static RemixAvatarStyle get small => RemixAvatarStyle(
        container: BoxStyle(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 32,
            maxWidth: 32,
            minHeight: 32,
            maxHeight: 32,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.surface(),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyle(color: RemixTokens.textPrimary(), size: 16),
      );

  /// Large avatar variant (64x64)
  static RemixAvatarStyle get large => RemixAvatarStyle(
        container: BoxStyle(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 64,
            maxWidth: 64,
            minHeight: 64,
            maxHeight: 64,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.surface(),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextStyling(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyle(color: RemixTokens.textPrimary(), size: 32),
      );
}
