part of 'slider.dart';

class RemixSliderStyle extends Style<SliderSpec>
    with StyleModifierMixin<RemixSliderStyle, SliderSpec>, StyleVariantMixin<RemixSliderStyle, SliderSpec> {
  final Prop<WidgetContainerProperties>? $thumb;
  final Prop<Paint>? $baseTrack;
  final Prop<Paint>? $activeTrack;
  final Prop<Paint>? $division;

  const RemixSliderStyle.create({
    Prop<WidgetContainerProperties>? thumb,
    Prop<Paint>? baseTrack,
    Prop<Paint>? activeTrack,
    Prop<Paint>? division,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $thumb = thumb,
        $baseTrack = baseTrack,
        $activeTrack = activeTrack,
        $division = division;

  RemixSliderStyle({
    WidgetContainerPropertiesMix? thumb,
    Paint? baseTrack,
    Paint? activeTrack,
    Paint? division,
    AnimationConfig? animation,
    List<VariantStyle<SliderSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          thumb: thumb != null ? Prop.mix(thumb) : null,
          baseTrack: baseTrack != null ? Prop.value(baseTrack) : null,
          activeTrack: activeTrack != null ? Prop.value(activeTrack) : null,
          division: division != null ? Prop.value(division) : null,
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
        );

  factory RemixSliderStyle.value(SliderSpec spec) => RemixSliderStyle(
        thumb: WidgetContainerPropertiesMix.maybeValue(spec.thumb),
      );

  @override
  SliderSpec resolve(BuildContext context) {
    return SliderSpec(
      thumb: MixOps.resolve(context, $thumb),
      baseTrack: MixOps.resolve(context, $baseTrack),
      activeTrack: MixOps.resolve(context, $activeTrack),
      division: MixOps.resolve(context, $division),
    );
  }

  @override
  RemixSliderStyle merge(RemixSliderStyle? other) {
    if (other == null) return this;

    return RemixSliderStyle.create(
      thumb: MixOps.merge($thumb, other.$thumb),
      baseTrack: MixOps.merge($baseTrack, other.$baseTrack),
      activeTrack: MixOps.merge($activeTrack, other.$activeTrack),
      division: MixOps.merge($division, other.$division),
      variants: mergeVariantLists($variants, other.$variants),
      animation: other.$animation ?? $animation,
      modifier: $modifier?.merge(other.$modifier) ?? other.$modifier,
      inherit: other.$inherit ?? $inherit,
    );
  }

  @override
  RemixSliderStyle variant(Variant variant, RemixSliderStyle style) {
    return merge(RemixSliderStyle(variants: [VariantStyle(variant, style)]));
  }

  @override
  RemixSliderStyle variants(List<VariantStyle<SliderSpec>> value) {
    return merge(RemixSliderStyle(variants: value));
  }
  
  @override
  RemixSliderStyle wrap(ModifierConfig value) {
    return merge(RemixSliderStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $thumb,
        $baseTrack,
        $activeTrack,
        $division,
        $variants,
        $animation,
        $modifier,
        $inherit,
      ];
}

// Default style
final DefaultRemixSliderStyle = RemixSliderStyle(
  thumb: WidgetContainerPropertiesMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(color: Colors.black, width: 2)),
      shape: BoxShape.circle,
      color: Colors.white,
    ),
  ),
  baseTrack: Paint()
    ..strokeWidth = 8
    ..color = Colors.grey
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke,
  activeTrack: Paint()
    ..strokeWidth = 8
    ..color = Colors.black
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke,
  division: Paint()
    ..strokeWidth = 8
    ..color = Colors.black.withValues(alpha: 0.26)
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke,
  animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
);

// Hover style
final RemixSliderHoverStyle = RemixSliderStyle(
  thumb: WidgetContainerPropertiesMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(color: Colors.blue, width: 2)),
    ),
  ),
);

// Disabled style
final RemixSliderDisabledStyle = RemixSliderStyle(
  thumb: WidgetContainerPropertiesMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(color: Colors.grey.shade400, width: 2),
      ),
      color: Colors.grey.shade300,
    ),
  ),
  baseTrack: Paint()
    ..strokeWidth = 8
    ..color = Colors.grey.shade300
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke,
  activeTrack: Paint()
    ..strokeWidth = 8
    ..color = Colors.grey.shade400
    ..strokeCap = StrokeCap.round
    ..style = PaintingStyle.stroke,
);

extension SliderVariants on RemixSliderStyle {
  /// Primary slider variant with blue colors
  static RemixSliderStyle get primary => RemixSliderStyle(
        thumb: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.blue[500]!, width: 2)),
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadowMix(
                color: Colors.blue.withValues(alpha: 0.3),
                offset: const Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        baseTrack: Paint()
          ..strokeWidth = 8
          ..color = Colors.blue[100]!
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        activeTrack: Paint()
          ..strokeWidth = 8
          ..color = Colors.blue[500]!
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        division: Paint()
          ..strokeWidth = 8
          ..color = Colors.blue[300]!.withValues(alpha: 0.5)
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Secondary slider variant with grey colors
  static RemixSliderStyle get secondary => RemixSliderStyle(
        thumb: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.grey[600]!, width: 2)),
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        baseTrack: Paint()
          ..strokeWidth = 8
          ..color = Colors.grey[300]!
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        activeTrack: Paint()
          ..strokeWidth = 8
          ..color = Colors.grey[600]!
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        division: Paint()
          ..strokeWidth = 8
          ..color = Colors.grey[500]!.withValues(alpha: 0.5)
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Compact slider variant with smaller track
  static RemixSliderStyle get compact => RemixSliderStyle(
        thumb: WidgetContainerPropertiesMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.black, width: 1.5)),
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        baseTrack: Paint()
          ..strokeWidth = 4
          ..color = Colors.grey
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        activeTrack: Paint()
          ..strokeWidth = 4
          ..color = Colors.black
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        division: Paint()
          ..strokeWidth = 4
          ..color = Colors.black.withValues(alpha: 0.26)
          ..strokeCap = StrokeCap.round
          ..style = PaintingStyle.stroke,
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );
}
