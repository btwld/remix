part of 'avatar.dart';

// Private per-component constants (no shared tokens)
// Color constants removed; using tokens
const _kSizeSmall = 32.0;
const _kSizeMedium = 50.0;
const _kSizeLarge = 80.0;

const _kFontSizeSmall = 12.0;
const _kFontSizeMedium = 18.0;
const _kFontSizeLarge = 24.0;

const _kIconSizeSmall = 16.0;
const _kIconSizeMedium = 24.0;
const _kIconSizeLarge = 32.0;

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
    return merge(
      RemixAvatarStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixAvatarStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixAvatarStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
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
  /// Solid avatar style (default) - primary background with onPrimary text/icon
  static RemixAvatarStyle get solid => RemixAvatarStyle(
        container: BoxStyler(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: _kSizeMedium,
            maxWidth: _kSizeMedium,
            minHeight: _kSizeMedium,
            maxHeight: _kSizeMedium,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.primary(),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.onPrimary(),
            fontSize: _kFontSizeMedium,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon:
            IconStyler(color: RemixTokens.onPrimary(), size: _kIconSizeMedium),
      );

  /// Outline avatar style - transparent background with primary border
  static RemixAvatarStyle get outline => RemixAvatarStyle(
        container: BoxStyler(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: _kSizeMedium,
            maxWidth: _kSizeMedium,
            minHeight: _kSizeMedium,
            maxHeight: _kSizeMedium,
          ),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.primary(), width: 1),
            ),
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.primary(),
            fontSize: _kFontSizeMedium,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyler(color: RemixTokens.primary(), size: _kIconSizeMedium),
      );

  /// Small size variant
  static RemixAvatarStyle get small => RemixAvatarStyle(
        container: BoxStyler(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: _kSizeSmall,
            maxWidth: _kSizeSmall,
            minHeight: _kSizeSmall,
            maxHeight: _kSizeSmall,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.primary(),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.onPrimary(),
            fontSize: _kFontSizeSmall,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyler(color: RemixTokens.onPrimary(), size: _kIconSizeSmall),
      );

  /// Large size variant
  static RemixAvatarStyle get large => RemixAvatarStyle(
        container: BoxStyler(
          alignment: Alignment.center,
          constraints: BoxConstraintsMix(
            minWidth: _kSizeLarge,
            maxWidth: _kSizeLarge,
            minHeight: _kSizeLarge,
            maxHeight: _kSizeLarge,
          ),
          decoration: BoxDecorationMix(
            shape: BoxShape.circle,
            color: RemixTokens.primary(),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.onPrimary(),
            fontSize: _kFontSizeLarge,
            fontWeight: FontWeight.w400,
          ),
        ),
        icon: IconStyler(color: RemixTokens.onPrimary(), size: _kIconSizeLarge),
      );

  /// Default style alias
  static RemixAvatarStyle get defaultStyle => solid;
}
