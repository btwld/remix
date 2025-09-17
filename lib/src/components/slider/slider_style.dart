part of 'slider.dart';



class RemixSliderStyle extends RemixStyle<SliderSpec, RemixSliderStyle> {
  final Prop<StyleSpec<BoxSpec>>? $thumb;
  final Prop<Paint>? $baseTrack;
  final Prop<Paint>? $activeTrack;

  const RemixSliderStyle.create({
    Prop<StyleSpec<BoxSpec>>? thumb,
    Prop<Paint>? baseTrack,
    Prop<Paint>? activeTrack,
    super.variants,
    super.animation,
    super.modifier,
  })  : $thumb = thumb,
        $baseTrack = baseTrack,
        $activeTrack = activeTrack;

  RemixSliderStyle({
    BoxStyler? thumb,
    Paint? baseTrack,
    Paint? activeTrack,
    AnimationConfig? animation,
    List<VariantStyle<SliderSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          thumb: Prop.maybeMix(thumb),
          baseTrack: baseTrack != null ? Prop.value(baseTrack) : null,
          activeTrack: activeTrack != null ? Prop.value(activeTrack) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets thumb color
  RemixSliderStyle thumbColor(Color value) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  /// Sets base track color
  RemixSliderStyle baseTrackColor(Color value) {
    return merge(RemixSliderStyle(
      baseTrack: Paint()
        ..strokeWidth = 8
        ..color = value
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    ));
  }

  /// Sets active track color
  RemixSliderStyle activeTrackColor(Color value) {
    return merge(RemixSliderStyle(
      activeTrack: Paint()
        ..strokeWidth = 8
        ..color = value
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke,
    ));
  }

  /// Sets thumb styling
  RemixSliderStyle thumb(BoxStyler value) {
    return merge(RemixSliderStyle(thumb: value));
  }

  @override
  StyleSpec<SliderSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: SliderSpec(
        thumb: MixOps.resolve(context, $thumb),
        baseTrack: MixOps.resolve(context, $baseTrack),
        activeTrack: MixOps.resolve(context, $activeTrack),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixSliderStyle merge(RemixSliderStyle? other) {
    if (other == null) return this;

    return RemixSliderStyle.create(
      thumb: MixOps.merge($thumb, other.$thumb),
      baseTrack: MixOps.merge($baseTrack, other.$baseTrack),
      activeTrack: MixOps.merge($activeTrack, other.$activeTrack),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixSliderStyle withVariants(List<VariantStyle<SliderSpec>> value) {
    return merge(RemixSliderStyle(variants: value));
  }

  @override
  RemixSliderStyle wrap(WidgetModifierConfig value) {
    return merge(RemixSliderStyle(modifier: value));
  }

  @override
  RemixSliderStyle animate(AnimationConfig animation) {
    return merge(RemixSliderStyle(animation: animation));
  }

  @override
  List<Object?> get props => [
        $thumb,
        $baseTrack,
        $activeTrack,
        $variants,
        $animation,
        $modifier,
      ];
}


