part of 'divider.dart';

// Private per-component constants
const _kBlack = Color(0xFF000000);

const _kRadiusMax = 99.0;

class RemixDividerStyle extends Style<DividerSpec>
    with
        StyleModifierMixin<RemixDividerStyle, DividerSpec>,
        StyleVariantMixin<RemixDividerStyle, DividerSpec>,
        ModifierStyleMixin<RemixDividerStyle, DividerSpec>,
        BorderStyleMixin<RemixDividerStyle>,
        BorderRadiusStyleMixin<RemixDividerStyle>,
        ShadowStyleMixin<RemixDividerStyle>,
        DecorationStyleMixin<RemixDividerStyle>,
        SpacingStyleMixin<RemixDividerStyle>,
        TransformStyleMixin<RemixDividerStyle>,
        ConstraintStyleMixin<RemixDividerStyle>,
        AnimationStyleMixin<DividerSpec, RemixDividerStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixDividerStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixDividerStyle({
    BoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<DividerSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets divider color
  RemixDividerStyle color(Color value) {
    return merge(RemixDividerStyle(
      container: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets divider thickness (height for horizontal, width for vertical)
  RemixDividerStyle thickness(double value) {
    return merge(RemixDividerStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
      ),
    ));
  }

  /// Sets container padding
  RemixDividerStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixDividerStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container decoration
  RemixDividerStyle decoration(DecorationMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixDividerStyle variants(List<VariantStyle<DividerSpec>> value) {
    return merge(RemixDividerStyle(variants: value));
  }

  @override
  RemixDividerStyle wrap(ModifierConfig value) {
    return merge(RemixDividerStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixDividerStyle animate(AnimationConfig config) {
    return merge(RemixDividerStyle(animation: config));
  }

  @override
  RemixDividerStyle constraints(BoxConstraintsMix value) {
    return merge(RemixDividerStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixDividerStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixDividerStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixDividerStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixDividerStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  StyleSpec<DividerSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: DividerSpec(container: MixOps.resolve(context, $container)),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixDividerStyle merge(RemixDividerStyle? other) {
    if (other == null) return this;

    return RemixDividerStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}

/// Default divider styles and variants
class RemixDividerStyles {
  /// Default divider style
  static RemixDividerStyle get defaultStyle => RemixDividerStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: double.infinity,
            minHeight: 1,
            maxHeight: 1,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(_kRadiusMax),
            color: _kBlack.withValues(alpha: 0.2),
          ),
        ),
      );

  /// Vertical divider variant
  static RemixDividerStyle get vertical => RemixDividerStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: 1,
            maxWidth: 1,
            minHeight: double.infinity,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(_kRadiusMax),
            color: _kBlack.withValues(alpha: 0.2),
          ),
        ),
      );

  /// Thick divider variant
  static RemixDividerStyle get thick => RemixDividerStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: double.infinity,
            minHeight: 2,
            maxHeight: 2,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(_kRadiusMax),
            color: _kBlack.withValues(alpha: 0.3),
          ),
        ),
      );

  /// Dark divider variant
  // Removed colorful variants; keeping simple default and utility variants only
}
