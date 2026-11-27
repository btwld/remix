part of 'segmented_control.dart';

/// How a [RemixSegmentedControl] shares the track between its segments.
enum RemixSegmentSizing {
  /// Every segment gets the extent of the largest one.
  equal,

  /// Every segment gets its own natural extent. When the track is larger or
  /// smaller than the segments need, each one grows or shrinks in proportion.
  content,
}

/// Resolved visual properties for a [RemixSegmentedControl].
@MixableSpec(
  target: RemixSegmentedControl.new,
  extraStylerMixins: [RemixBoxStylerMixin],
)
class SegmentedControlSpec with _$SegmentedControlSpec {
  /// Layout and decoration for the persistent control track.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Main-axis sizing for the segment track layout.
  @override
  final MainAxisSize? mainAxisSize;

  /// Space between adjacent segments.
  @override
  final double? spacing;

  /// How segments share the track's main axis. `null` means
  /// [RemixSegmentSizing.equal].
  @override
  final RemixSegmentSizing? segmentSizing;

  /// Default visual style for every segment.
  @override
  final StyleSpec<SegmentedControlItemSpec> item;

  /// A surface shared by the segments that sits behind the selected segment,
  /// over the track's own fill and border, and glides to the next one when
  /// the selection changes.
  ///
  /// It takes the selected segment's bounds, so `margin` insets it and the
  /// decoration draws it. `null`, the default, draws none and leaves each
  /// segment's own selected style in charge. With no selection it draws
  /// nothing.
  @override
  final StyleSpec<BoxSpec>? indicator;

  /// Paint layers behind [indicator], such as a shadow.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? indicatorEffects;

  /// How [indicator] moves between segments. Accepts [CurveAnimationConfig]
  /// or [SpringAnimationConfig], which may overshoot. `null` glides along
  /// `Curves.easeOutCubic` over 250 ms.
  ///
  /// [RemixSegmentedControl] throws [ArgumentError] for phase and keyframe
  /// configs when it builds. While the user asks to reduce motion, the
  /// indicator moves at once.
  @override
  final AnimationConfig? indicatorMotion;

  const SegmentedControlSpec({
    StyleSpec<BoxSpec>? container,
    this.mainAxisSize,
    this.spacing,
    this.segmentSizing,
    StyleSpec<SegmentedControlItemSpec>? item,
    this.indicator,
    this.indicatorEffects,
    this.indicatorMotion,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       item = item ?? const StyleSpec(spec: SegmentedControlItemSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  SegmentedControlSpec lerp(SegmentedControlSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      indicatorEffects: RemixBoxEffectsSpec.lerpNullable(
        indicatorEffects,
        other.indicatorEffects,
        t,
      ),
    );
  }
}

/// Resolved visual properties for one segment.
@MixableSpec(
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin, IconStyleMixin],
)
class SegmentedControlItemSpec with _$SegmentedControlItemSpec {
  /// Decoration and box layout for the segment surface.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Space between the optional icon and label.
  @override
  final double? spacing;

  /// Text style for the optional label.
  @override
  final StyleSpec<TextSpec> label;

  /// Icon style for the optional icon.
  @override
  final StyleSpec<IconSpec> icon;

  /// Paint-only effects for the segment surface.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  const SegmentedControlItemSpec({
    StyleSpec<BoxSpec>? container,
    this.spacing,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
    this.containerEffects,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  SegmentedControlItemSpec lerp(SegmentedControlItemSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
    );
  }
}
