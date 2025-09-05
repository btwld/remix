part of 'avatar.dart';

class RemixAvatarStyle extends Style<AvatarSpec>
    with
        StyleModifierMixin<RemixAvatarStyle, AvatarSpec>,
        StyleVariantMixin<RemixAvatarStyle, AvatarSpec>,
        ModifierStyleMixin<RemixAvatarStyle, AvatarSpec>,
        BorderStyleMixin<RemixAvatarStyle>,
        BorderRadiusStyleMixin<RemixAvatarStyle>,
        ShadowStyleMixin<RemixAvatarStyle>,
        DecorationStyleMixin<RemixAvatarStyle>,
        SpacingStyleMixin<RemixAvatarStyle>,
        TransformStyleMixin<RemixAvatarStyle>,
        ConstraintStyleMixin<RemixAvatarStyle>,
        AnimationStyleMixin<AvatarSpec, RemixAvatarStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixAvatarStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixAvatarStyle({
    BoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
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

  // Instance methods (chainable)

  /// Sets avatar size with width and height
  @override
  RemixAvatarStyle size(double width, double height) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  /// Sets avatar size to a square
  RemixAvatarStyle square(double size) {
    return this.size(size, size);
  }

  /// Sets avatar size with width and height (alias)
  RemixAvatarStyle sizeWH(double width, double height) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  /// Sets background color
  RemixAvatarStyle color(Color value) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets border radius
  RemixAvatarStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(
          borderRadius: radius,
          shape: BoxShape.rectangle,
        ),
      ),
    ));
  }

  /// Sets text color
  RemixAvatarStyle textColor(Color value) {
    return merge(RemixAvatarStyle(
      text: TextStyler(style: TextStyleMix(color: value)),
    ));
  }

  /// Sets icon color
  RemixAvatarStyle iconColor(Color value) {
    return merge(RemixAvatarStyle(icon: IconStyler(color: value)));
  }

  // Additional convenience methods that delegate to container

  /// Sets padding
  RemixAvatarStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(padding: value)));
  }

  /// Sets margin
  RemixAvatarStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixAvatarStyle decoration(DecorationMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets constraints
  RemixAvatarStyle constraints(BoxConstraintsMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(constraints: value)));
  }

  /// Sets animation
  RemixAvatarStyle animate(AnimationConfig animation) {
    return merge(RemixAvatarStyle(animation: animation));
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
  StyleSpec<AvatarSpec> resolve(BuildContext context) {
    return StyleSpec(
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
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  // Abstract method implementations for mixins (only missing ones)
  
  @override
  RemixAvatarStyle foregroundDecoration(DecorationMix value) {
    return merge(RemixAvatarStyle(container: BoxStyler(foregroundDecoration: value)));
  }
  
  @override
  RemixAvatarStyle transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) {
    return merge(RemixAvatarStyle(container: BoxStyler(transform: value, alignment: alignment)));
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

/// Default avatar styles and variants
class RemixAvatarStyles {
  /// Default avatar style
  static RemixAvatarStyle get defaultStyle => RemixAvatarStyle(
        container: BoxStyler(
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
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyler(color: RemixTokens.textPrimary(), size: 24),
      );

  /// Small avatar variant
  static RemixAvatarStyle get small => RemixAvatarStyle(
        container: BoxStyler(
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
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyler(color: RemixTokens.textPrimary(), size: 16),
      );

  /// Large avatar variant
  static RemixAvatarStyle get large => RemixAvatarStyle(
        container: BoxStyler(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: 80,
            maxWidth: 80,
            minHeight: 80,
            maxHeight: 80,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.surface(),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyler(color: RemixTokens.textPrimary(), size: 32),
      );

  /// Primary avatar variant with blue background and white text
  static RemixAvatarStyle get primary => RemixAvatarStyle(
        container: BoxStyler(
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
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.background(),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: RemixTokens.background(), size: 24),
      );

  /// Secondary avatar variant with grey background
  static RemixAvatarStyle get secondary => RemixAvatarStyle(
        container: BoxStyler(
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
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.background(),
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyler(color: RemixTokens.background(), size: 24),
      );
}
