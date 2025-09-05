part of 'tooltip.dart';

class RemixTooltipStyle extends Style<TooltipSpec>
    with
        StyleModifierMixin<RemixTooltipStyle, TooltipSpec>,
        StyleVariantMixin<RemixTooltipStyle, TooltipSpec>,
        ModifierStyleMixin<RemixTooltipStyle, TooltipSpec>,
        BorderStyleMixin<RemixTooltipStyle>,
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
    ModifierConfig? modifier,
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
  RemixTooltipStyle wrap(ModifierConfig value) {
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
    return merge(RemixTooltipStyle(container: BoxStyler(foregroundDecoration: value)));
  }
  
  @override
  RemixTooltipStyle transform(Matrix4 value, {AlignmentGeometry alignment = Alignment.center}) {
    return merge(RemixTooltipStyle(container: BoxStyler(transform: value, alignment: alignment)));
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

final DefaultRemixTooltipStyle = RemixTooltipStyle(
  container: BoxStyler(
    padding: EdgeInsetsMix.all(10),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(8),
      color: RemixTokens.textPrimary().withValues(alpha: 0.8),
    ),
  ),
  text: TextStyler(
    style: TextStyleMix(
      color: RemixTokens.background(),
      fontSize: RemixTokens.fontSizeSm(),
    ),
  ),
  animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
);

extension RemixTooltipVariants on RemixTooltipStyle {
  /// Dark tooltip variant (same as default)
  static RemixTooltipStyle get dark => RemixTooltipStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(10),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: RemixTokens.textPrimary().withValues(alpha: 0.9),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.background(),
            fontSize: RemixTokens.fontSizeSm(),
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
      );

  /// Light tooltip variant with white background
  static RemixTooltipStyle get light => RemixTooltipStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(10),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(
              BorderSideMix(color: RemixTokens.border(), width: 1),
            ),
            borderRadius: BorderRadiusMix.circular(8),
            color: RemixTokens.background(),
            boxShadow: [
              BoxShadowMix(
                color: RemixTokens.textPrimary().withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.textPrimary(),
            fontSize: RemixTokens.fontSizeSm(),
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
      );

  /// Primary tooltip variant with blue colors
  static RemixTooltipStyle get primary => RemixTooltipStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(10),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(8),
            color: RemixTokens.primary(),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: RemixTokens.background(),
            fontSize: RemixTokens.fontSizeSm(),
          ),
        ),
        animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
      );
}
