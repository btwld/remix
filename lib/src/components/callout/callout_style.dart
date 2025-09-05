part of 'callout.dart';

// Private per-component constants (no shared tokens)
const _kBlack = Color(0xFF000000);
const _kWhite = Color(0xFFFFFFFF);

const _kSpaceMd = 12.0;

const _kRadiusMd = 6.0;

const _kFontSizeMd = 14.0;

const _kIconSizeMd = 16.0;

class RemixCalloutStyle extends Style<CalloutSpec>
    with
        StyleModifierMixin<RemixCalloutStyle, CalloutSpec>,
        StyleVariantMixin<RemixCalloutStyle, CalloutSpec>,
        ModifierStyleMixin<RemixCalloutStyle, CalloutSpec>,
        BorderStyleMixin<RemixCalloutStyle>,
        BorderRadiusStyleMixin<RemixCalloutStyle>,
        ShadowStyleMixin<RemixCalloutStyle>,
        DecorationStyleMixin<RemixCalloutStyle>,
        SpacingStyleMixin<RemixCalloutStyle>,
        TransformStyleMixin<RemixCalloutStyle>,
        ConstraintStyleMixin<RemixCalloutStyle>,
        AnimationStyleMixin<CalloutSpec, RemixCalloutStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixCalloutStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $text = text,
        $icon = icon;

  RemixCalloutStyle({
    BoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<CalloutSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          text: Prop.maybeMix(text),
          icon: Prop.maybeMix(icon),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets container padding
  RemixCalloutStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCalloutStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixCalloutStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCalloutStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container background color
  RemixCalloutStyle color(Color value) {
    return merge(RemixCalloutStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixCalloutStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixCalloutStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container decoration
  RemixCalloutStyle decoration(DecorationMix value) {
    return merge(RemixCalloutStyle(container: BoxStyler(decoration: value)));
  }

  @override
  StyleSpec<CalloutSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: CalloutSpec(
        container: MixOps.resolve(context, $container),
        text: MixOps.resolve(context, $text),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCalloutStyle merge(RemixCalloutStyle? other) {
    if (other == null) return this;

    return RemixCalloutStyle.create(
      container: MixOps.merge($container, other.$container),
      text: MixOps.merge($text, other.$text),
      icon: MixOps.merge($icon, other.$icon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixCalloutStyle variants(List<VariantStyle<CalloutSpec>> value) {
    return merge(RemixCalloutStyle(variants: value));
  }

  @override
  RemixCalloutStyle wrap(ModifierConfig value) {
    return merge(RemixCalloutStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixCalloutStyle animate(AnimationConfig config) {
    return merge(RemixCalloutStyle(animation: config));
  }

  @override
  RemixCalloutStyle constraints(BoxConstraintsMix value) {
    return merge(RemixCalloutStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixCalloutStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCalloutStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCalloutStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixCalloutStyle(
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

final DefaultRemixCalloutStyle = RemixCalloutStyle(
  container: BoxStyler(
    padding: EdgeInsetsMix.all(_kSpaceMd),
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(
        color: _kBlack.withValues(alpha: 0.2),
        width: 1,
      )),
      borderRadius: BorderRadiusMix.circular(_kRadiusMd),
      color: _kWhite,
    ),
  ),
  text: TextStyler(
    style: TextStyleMix(
      color: _kBlack,
      fontSize: _kFontSizeMd,
      fontWeight: FontWeight.w500,
    ),
  ),
  icon: IconStyler(color: _kBlack, size: _kIconSizeMd),
);

class RemixCalloutStyles {
  static RemixCalloutStyle get defaultStyle => DefaultRemixCalloutStyle;
}

extension CalloutVariants on RemixCalloutStyle {
  /// Solid callout variant (default) - white background, black text, subtle black border
  static RemixCalloutStyle get solid => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(_kSpaceMd),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(
              color: _kBlack.withValues(alpha: 0.2),
              width: 1,
            )),
            borderRadius: BorderRadiusMix.circular(_kRadiusMd),
            color: _kWhite,
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: _kBlack,
            fontSize: _kFontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: _kBlack, size: _kIconSizeMd),
      );

  /// Outline callout variant - transparent background, black border, black text
  static RemixCalloutStyle get outline => RemixCalloutStyle(
        container: BoxStyler(
          padding: EdgeInsetsGeometryMix.all(_kSpaceMd),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: _kBlack, width: 1)),
            borderRadius: BorderRadiusMix.circular(_kRadiusMd),
            color: _kWhite.withValues(alpha: 0.0),
          ),
        ),
        text: TextStyler(
          style: TextStyleMix(
            color: _kBlack,
            fontSize: _kFontSizeMd,
            fontWeight: FontWeight.w500,
          ),
        ),
        icon: IconStyler(color: _kBlack, size: _kIconSizeMd),
      );
}
