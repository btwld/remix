part of 'card.dart';

// Private per-component constants (no shared tokens)
const _kBlack = Color(0xFF000000);
const _kWhite = Color(0xFFFFFFFF);
const _kDisabled = Color(0xFF9E9E9E);

const _kSpaceSm = 8.0;
const _kSpaceMd = 12.0;
const _kSpaceLg = 16.0;

const _kRadiusSm = 4.0;
const _kRadiusMd = 6.0;
const _kRadiusLg = 8.0;

const _kFontSizeSm = 12.0;
const _kFontSizeMd = 14.0;
const _kFontSizeLg = 16.0;

const _kIconSizeSm = 14.0;
const _kIconSizeMd = 16.0;
const _kIconSizeLg = 18.0;

class RemixCardStyle extends Style<CardSpec>
    with
        StyleModifierMixin<RemixCardStyle, CardSpec>,
        StyleVariantMixin<RemixCardStyle, CardSpec>,
        ModifierStyleMixin<RemixCardStyle, CardSpec>,
        BorderStyleMixin<RemixCardStyle>,
        BorderRadiusStyleMixin<RemixCardStyle>,
        ShadowStyleMixin<RemixCardStyle>,
        DecorationStyleMixin<RemixCardStyle>,
        SpacingStyleMixin<RemixCardStyle>,
        TransformStyleMixin<RemixCardStyle>,
        ConstraintStyleMixin<RemixCardStyle>,
        AnimationStyleMixin<CardSpec, RemixCardStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixCardStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixCardStyle({
    BoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<CardSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets container padding
  RemixCardStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container background color
  RemixCardStyle color(Color value) {
    return merge(RemixCardStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets container border radius
  RemixCardStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixCardStyle(
      container: BoxStyler(
        decoration: BoxDecorationMix(borderRadius: radius),
      ),
    ));
  }

  /// Sets container margin
  RemixCardStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCardStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container decoration
  RemixCardStyle decoration(DecorationMix value) {
    return merge(RemixCardStyle(container: BoxStyler(decoration: value)));
  }

  @override
  StyleSpec<CardSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: CardSpec(container: MixOps.resolve(context, $container)),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCardStyle merge(RemixCardStyle? other) {
    if (other == null) return this;

    return RemixCardStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixCardStyle variants(List<VariantStyle<CardSpec>> value) {
    return merge(RemixCardStyle(variants: value));
  }

  @override
  RemixCardStyle wrap(ModifierConfig value) {
    return merge(RemixCardStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixCardStyle animate(AnimationConfig config) {
    return merge(RemixCardStyle(animation: config));
  }

  @override
  RemixCardStyle constraints(BoxConstraintsMix value) {
    return merge(RemixCardStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixCardStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCardStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCardStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixCardStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}

/// Default card styles and variants
final DefaultRemixCardStyle = RemixCardStyle(
  container: BoxStyler(
    padding: EdgeInsetsMix.all(_kSpaceLg),
    decoration: BoxDecorationMix(
      borderRadius: BorderRadiusMix.circular(_kRadiusLg),
      color: _kWhite,
      boxShadow: [
        BoxShadowMix(
          color: _kBlack.withValues(alpha: 0.1),
          offset: const Offset(0, 2),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ],
    ),
  ),
);

class RemixCardStyles {
  /// Default card style
  static RemixCardStyle get defaultStyle => DefaultRemixCardStyle;
}

extension CardVariants on RemixCardStyle {
  /// Solid card variant (default)
  static RemixCardStyle get solid => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(_kSpaceLg),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(_kRadiusLg),
            color: _kWhite,
            boxShadow: [
              BoxShadowMix(
                color: _kBlack.withValues(alpha: 0.1),
                offset: const Offset(0, 2),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
        ),
      );

  /// Outline card variant
  static RemixCardStyle get outline => RemixCardStyle(
        container: BoxStyler(
          padding: EdgeInsetsMix.all(_kSpaceLg),
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: _kBlack, width: 1)),
            borderRadius: BorderRadiusMix.circular(_kRadiusLg),
            color: _kWhite,
          ),
        ),
      );
}
