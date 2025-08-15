part of 'slider.dart';

class RemixSliderStyle extends Style<SliderSpec>
    with StyleModifierMixin<RemixSliderStyle, SliderSpec>, StyleVariantMixin<RemixSliderStyle, SliderSpec> {
  final Prop<BoxSpec>? $thumb;
  final Prop<PaintData>? $baseTrack;
  final Prop<PaintData>? $activeTrack;
  final Prop<PaintData>? $division;

  const RemixSliderStyle.create({
    Prop<BoxSpec>? thumb,
    Prop<PaintData>? baseTrack,
    Prop<PaintData>? activeTrack,
    Prop<PaintData>? division,
    super.variants,
    super.animation,
    super.modifier,
    super.inherit,
  })  : $thumb = thumb,
        $baseTrack = baseTrack,
        $activeTrack = activeTrack,
        $division = division;

  RemixSliderStyle({
    BoxMix? thumb,
    PaintData? baseTrack,
    PaintData? activeTrack,
    PaintData? division,
    AnimationConfig? animation,
    List<VariantStyle<SliderSpec>>? variants,
    ModifierConfig? modifier,
    bool? inherit,
  }) : this.create(
          thumb: thumb != null ? Prop.mix(thumb) : null,
          baseTrack: Prop.maybe(baseTrack),
          activeTrack: Prop.maybe(activeTrack),
          division: Prop.maybe(division),
          variants: variants,
          animation: animation,
          modifier: modifier,
          inherit: inherit,
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
  thumb: BoxMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(color: Colors.black, width: 2)),
      shape: BoxShape.circle,
      color: Colors.white,
    ),
  ),
  baseTrack: const PaintData(
    strokeWidth: 8,
    color: Colors.grey,
    strokeCap: StrokeCap.round,
  ),
  activeTrack: const PaintData(
    strokeWidth: 8,
    color: Colors.black,
    strokeCap: StrokeCap.round,
  ),
  division: PaintData(
    strokeWidth: 8,
    color: Colors.black.withValues(alpha: 0.26),
    strokeCap: StrokeCap.round,
  ),
  animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
);

// Hover style
final RemixSliderHoverStyle = RemixSliderStyle(
  thumb: BoxMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(BorderSideMix(color: Colors.blue, width: 2)),
    ),
  ),
);

// Disabled style
final RemixSliderDisabledStyle = RemixSliderStyle(
  thumb: BoxMix(
    decoration: BoxDecorationMix(
      border: BoxBorderMix.all(
        BorderSideMix(color: Colors.grey.shade400, width: 2),
      ),
      color: Colors.grey.shade300,
    ),
  ),
  baseTrack: PaintData(
    strokeWidth: 8,
    color: Colors.grey.shade300,
    strokeCap: StrokeCap.round,
  ),
  activeTrack: PaintData(
    strokeWidth: 8,
    color: Colors.grey.shade400,
    strokeCap: StrokeCap.round,
  ),
);

extension SliderVariants on RemixSliderStyle {
  /// Primary slider variant with blue colors
  static RemixSliderStyle get primary => RemixSliderStyle(
        thumb: BoxMix(
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
        baseTrack: PaintData(
          strokeWidth: 8,
          color: Colors.blue[100]!,
          strokeCap: StrokeCap.round,
        ),
        activeTrack: PaintData(
          strokeWidth: 8,
          color: Colors.blue[500]!,
          strokeCap: StrokeCap.round,
        ),
        division: PaintData(
          strokeWidth: 8,
          color: Colors.blue[300]!.withValues(alpha: 0.5),
          strokeCap: StrokeCap.round,
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Secondary slider variant with grey colors
  static RemixSliderStyle get secondary => RemixSliderStyle(
        thumb: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.grey[600]!, width: 2)),
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        baseTrack: PaintData(
          strokeWidth: 8,
          color: Colors.grey[300]!,
          strokeCap: StrokeCap.round,
        ),
        activeTrack: PaintData(
          strokeWidth: 8,
          color: Colors.grey[600]!,
          strokeCap: StrokeCap.round,
        ),
        division: PaintData(
          strokeWidth: 8,
          color: Colors.grey[500]!.withValues(alpha: 0.5),
          strokeCap: StrokeCap.round,
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );

  /// Compact slider variant with smaller track
  static RemixSliderStyle get compact => RemixSliderStyle(
        thumb: BoxMix(
          decoration: BoxDecorationMix(
            border: BoxBorderMix.all(BorderSideMix(color: Colors.black, width: 1.5)),
            shape: BoxShape.circle,
            color: Colors.white,
          ),
        ),
        baseTrack: const PaintData(
          strokeWidth: 4,
          color: Colors.grey,
          strokeCap: StrokeCap.round,
        ),
        activeTrack: const PaintData(
          strokeWidth: 4,
          color: Colors.black,
          strokeCap: StrokeCap.round,
        ),
        division: PaintData(
          strokeWidth: 4,
          color: Colors.black.withValues(alpha: 0.26),
          strokeCap: StrokeCap.round,
        ),
        animation: AnimationConfig.easeInOut(const Duration(milliseconds: 200)),
      );
}
