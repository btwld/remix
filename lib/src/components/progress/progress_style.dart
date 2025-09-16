part of 'progress.dart';



class RemixProgressStyle
    extends RemixContainerStyle<ProgressSpec, RemixProgressStyle> {
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
    WidgetModifierConfig? modifier,
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

  /// Sets container styling
  RemixProgressStyle container(BoxStyler value) {
    return merge(RemixProgressStyle(container: value));
  }

  @override
  RemixProgressStyle withVariants(List<VariantStyle<ProgressSpec>> value) {
    return merge(RemixProgressStyle(variants: value));
  }

  @override
  RemixProgressStyle wrap(WidgetModifierConfig value) {
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


