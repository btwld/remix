part of 'badge.dart';

// Private per-component constants (sizes only)
const _kFontSizeSm = 12.0;

class RemixBadgeStyle extends Style<BadgeSpec>
    with
        VariantStyleMixin<RemixBadgeStyle, BadgeSpec>,
        BorderStyleMixin<RemixBadgeStyle>,
        WidgetModifierStyleMixin<RemixBadgeStyle, BadgeSpec>,
        BorderRadiusStyleMixin<RemixBadgeStyle>,
        ShadowStyleMixin<RemixBadgeStyle>,
        DecorationStyleMixin<RemixBadgeStyle>,
        SpacingStyleMixin<RemixBadgeStyle>,
        TransformStyleMixin<RemixBadgeStyle>,
        ConstraintStyleMixin<RemixBadgeStyle>,
        AnimationStyleMixin<BadgeSpec, RemixBadgeStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;

  const RemixBadgeStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text;

  RemixBadgeStyle({
    BoxStyler? container,
    TextStyler? text,
    AnimationConfig? animation,
    List<VariantStyle<BadgeSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  // Instance methods (chainable)

  /// Sets background color
  RemixBadgeStyle color(Color value) {
    return merge(RemixBadgeStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets border radius
  RemixBadgeStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixBadgeStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets padding
  RemixBadgeStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(padding: value)));
  }

  /// Sets text color
  RemixBadgeStyle textColor(Color value) {
    return merge(RemixBadgeStyle(
      text: TextStyler(style: TextStyleMix(color: value)),
    ));
  }


  // Additional convenience methods that delegate to container

  /// Sets margin
  RemixBadgeStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(margin: value)));
  }

  /// Sets decoration
  RemixBadgeStyle decoration(DecorationMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets constraints
  @override
  RemixBadgeStyle constraints(BoxConstraintsMix value) {
    return merge(RemixBadgeStyle(container: BoxStyler(constraints: value)));
  }

  /// Sets animation
  @override
  RemixBadgeStyle animate(AnimationConfig animation) {
    return merge(RemixBadgeStyle(animation: animation));
  }

  @override
  RemixBadgeStyle variants(List<VariantStyle<BadgeSpec>> value) {
    return merge(RemixBadgeStyle(variants: value));
  }

  @override
  RemixBadgeStyle wrap(WidgetModifierConfig value) {
    return merge(RemixBadgeStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixBadgeStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixBadgeStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixBadgeStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixBadgeStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  StyleSpec<BadgeSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: BadgeSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
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
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $text,
        $variants,
        $animation,
        $modifier,
      ];
}

/// Default badge styles and variants
class RemixBadgeStyles {
  /// Base badge style - compact design with primary color
  static RemixBadgeStyle get baseStyle => RemixBadgeStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.symmetric(
            vertical: RemixTokens.spaceXs(),
            horizontal: RemixTokens.spaceSm(),
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.all(RemixTokens.radius()),
            color: RemixTokens.primary(),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.onPrimary(),
            fontSize: _kFontSizeSm,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
}
