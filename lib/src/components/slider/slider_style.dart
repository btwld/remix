part of 'slider.dart';

class RemixSliderStyle
    extends RemixContainerStyle<RemixSliderSpec, RemixSliderStyle> {
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
    List<VariantStyle<RemixSliderSpec>>? variants,
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

  /// Sets thumb alignment
  RemixSliderStyle alignment(Alignment value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(alignment: value)));
  }

  // RemixContainerStyle mixin implementations
  @override
  RemixSliderStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(padding: value)));
  }

  @override
  RemixSliderStyle color(Color value) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  @override
  RemixSliderStyle size(double width, double height) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  @override
  RemixSliderStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(decoration: BoxDecorationMix(borderRadius: radius)),
    ));
  }

  @override
  RemixSliderStyle constraints(BoxConstraintsMix value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(constraints: value)));
  }

  @override
  RemixSliderStyle decoration(DecorationMix value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(decoration: value)));
  }

  @override
  RemixSliderStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixSliderStyle(thumb: BoxStyler(margin: value)));
  }

  @override
  RemixSliderStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixSliderStyle(thumb: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixSliderStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixSliderStyle(
      thumb: BoxStyler(transform: value, transformAlignment: alignment),
    ));
  }

  @override
  StyleSpec<RemixSliderSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixSliderSpec(
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
  RemixSliderStyle variants(List<VariantStyle<RemixSliderSpec>> value) {
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
