part of 'progress.dart';

// Private per-component constants (sizes only)
const _kBarHeight = 6.0;

class RemixProgressStyle extends Style<ProgressSpec>
    with
        StyleModifierMixin<RemixProgressStyle, ProgressSpec>,
        StyleVariantMixin<RemixProgressStyle, ProgressSpec>,
        ModifierStyleMixin<RemixProgressStyle, ProgressSpec>,
        BorderStyleMixin<RemixProgressStyle>,
        BorderRadiusStyleMixin<RemixProgressStyle>,
        ShadowStyleMixin<RemixProgressStyle>,
        DecorationStyleMixin<RemixProgressStyle>,
        SpacingStyleMixin<RemixProgressStyle>,
        TransformStyleMixin<RemixProgressStyle>,
        ConstraintStyleMixin<RemixProgressStyle>,
        AnimationStyleMixin<ProgressSpec, RemixProgressStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $track;
  final Prop<StyleSpec<BoxSpec>>? $indicator;
  final Prop<StyleSpec<BoxSpec>>? $trackContainer;

  const RemixProgressStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? track,
    Prop<StyleSpec<BoxSpec>>? indicator,
    Prop<StyleSpec<BoxSpec>>? trackContainer,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $track = track,
        $indicator = indicator,
        $trackContainer = trackContainer;

  RemixProgressStyle({
    BoxStyler? container,
    BoxStyler? track,
    BoxStyler? indicator,
    BoxStyler? trackContainer,
    AnimationConfig? animation,
    List<VariantStyle<ProgressSpec>>? variants,
    ModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          track: Prop.maybeMix(track),
          indicator: Prop.maybeMix(indicator),
          trackContainer: Prop.maybeMix(trackContainer),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets progress height
  RemixProgressStyle height(double value) {
    return merge(RemixProgressStyle(
      container: BoxStyler(
        constraints: BoxConstraintsMix(minHeight: value, maxHeight: value),
      ),
    ));
  }

  /// Sets track color
  RemixProgressStyle trackColor(Color value) {
    return merge(RemixProgressStyle(
      track: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets fill color
  RemixProgressStyle indicatorColor(Color value) {
    return merge(RemixProgressStyle(
      indicator: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets track styling
  RemixProgressStyle track(BoxStyler value) {
    return merge(RemixProgressStyle(track: value));
  }

  /// Sets fill styling
  RemixProgressStyle indicator(BoxStyler value) {
    return merge(RemixProgressStyle(indicator: value));
  }

  /// Sets outer container styling
  RemixProgressStyle trackContainer(BoxStyler value) {
    return merge(RemixProgressStyle(trackContainer: value));
  }

  @override
  RemixProgressStyle variants(List<VariantStyle<ProgressSpec>> value) {
    return merge(RemixProgressStyle(variants: value));
  }

  @override
  RemixProgressStyle wrap(ModifierConfig value) {
    return merge(RemixProgressStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixProgressStyle animate(AnimationConfig config) {
    return merge(RemixProgressStyle(animation: config));
  }

  @override
  RemixProgressStyle constraints(BoxConstraintsMix value) {
    return merge(RemixProgressStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixProgressStyle decoration(DecorationMix value) {
    return merge(RemixProgressStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixProgressStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixProgressStyle(container: BoxStyler(margin: value)));
  }

  @override
  RemixProgressStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixProgressStyle(container: BoxStyler(padding: value)));
  }

  @override
  RemixProgressStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixProgressStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixProgressStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixProgressStyle(
      container: BoxStyler(alignment: alignment, transform: value),
    ));
  }

  @override
  StyleSpec<ProgressSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: ProgressSpec(
        container: MixOps.resolve(context, $container),
        track: MixOps.resolve(context, $track),
        indicator: MixOps.resolve(context, $indicator),
        trackContainer: MixOps.resolve(context, $trackContainer),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixProgressStyle merge(RemixProgressStyle? other) {
    if (other == null) return this;

    return RemixProgressStyle.create(
      container: MixOps.merge($container, other.$container),
      track: MixOps.merge($track, other.$track),
      indicator: MixOps.merge($indicator, other.$indicator),
      trackContainer: MixOps.merge($trackContainer, other.$trackContainer),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $track,
        $indicator,
        $trackContainer,
        $variants,
        $animation,
        $modifier,
      ];
}

// Removed colorful variants; using simple defaultStyle only

/// Canonical access to default and variants
class RemixProgressStyles {
  /// Default progress style
  static RemixProgressStyle get defaultStyle => RemixProgressStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minHeight: _kBarHeight,
            maxHeight: _kBarHeight,
          ),
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
          ),
          clipBehavior: Clip.antiAlias,
        ),
        track: BoxStyler(
          decoration: BoxDecorationMix(
            color: RemixTokens.primary().withValues(alpha: 0.15),
          ),
        ),
        indicator: BoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(SpaceTokens.radius()),
            color: RemixTokens.primary(),
          ),
        ),
        trackContainer: BoxStyler(),
      );
}
