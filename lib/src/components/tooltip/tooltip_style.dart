part of 'tooltip.dart';

// Private per-component constants
const _kBlack = Color(0xFF000000);
const _kWhite = Color(0xFFFFFFFF);

const _kSpaceSm = 10.0;
const _kRadiusMd = 8.0;
const _kFontSizeSm = 12.0;

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

final DefaultRemixTooltipStyle = RemixTooltipStyle(
  container: BoxStyler(
    padding: EdgeInsetsMix.all(_kSpaceSm),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(_kRadiusMd),
      color: _kBlack.withValues(alpha: 0.8),
    ),
  ),
  text: TextStyler(
    style: TextStyleMix(color: _kWhite, fontSize: _kFontSizeSm),
  ),
  animation: AnimationConfig.ease(const Duration(milliseconds: 100)),
);

// Removed colorful variants; using a single defaultStyle only
