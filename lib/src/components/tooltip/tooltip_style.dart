part of 'tooltip.dart';

// Private per-component constants (sizes only)
const _kFontSizeSm = 12.0;

class RemixTooltipStyle extends Style<TooltipSpec>
    with
        VariantStyleMixin<RemixTooltipStyle, TooltipSpec>,
        BorderStyleMixin<RemixTooltipStyle>,
        WidgetModifierStyleMixin<RemixTooltipStyle, TooltipSpec>,
        BorderRadiusStyleMixin<RemixTooltipStyle>,
        ShadowStyleMixin<RemixTooltipStyle>,
        DecorationStyleMixin<RemixTooltipStyle>,
        SpacingStyleMixin<RemixTooltipStyle>,
        TransformStyleMixin<RemixTooltipStyle>,
        ConstraintStyleMixin<RemixTooltipStyle>,
        AnimationStyleMixin<TooltipSpec, RemixTooltipStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;

  const RemixTooltipStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text;

  RemixTooltipStyle({
    BoxStyler? container,
    TextStyler? text,
    AnimationConfig? animation,
    List<VariantStyle<TooltipSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets container padding
  RemixTooltipStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixTooltipStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container background color
  RemixTooltipStyle color(Color value) {
    return merge(RemixTooltipStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixTooltipStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixTooltipStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container decoration
  RemixTooltipStyle decoration(DecorationMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(decoration: value)));
  }

  @override
  StyleSpec<TooltipSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: TooltipSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixTooltipStyle merge(RemixTooltipStyle? other) {
    if (other == null) return this;

    return RemixTooltipStyle.create(
      container: MixOps.merge($container, other.$container),
      text: MixOps.merge($text, other.$text),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixTooltipStyle variants(List<VariantStyle<TooltipSpec>> value) {
    return merge(RemixTooltipStyle(variants: value));
  }

  @override
  RemixTooltipStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTooltipStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixTooltipStyle animate(AnimationConfig config) {
    return merge(RemixTooltipStyle(animation: config));
  }

  @override
  RemixTooltipStyle constraints(BoxConstraintsMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixTooltipStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTooltipStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTooltipStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixTooltipStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
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

/// Canonical access to default and variants
class RemixTooltipStyles {
  /// Base tooltip style - compact overlay design
  static RemixTooltipStyle get baseStyle => RemixTooltipStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(RemixTokens.spaceSm()),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.all(RemixTokens.radius()),
            color: RemixTokens.primary(),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.onPrimary(),
            fontSize: _kFontSizeSm,
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
      );


}
