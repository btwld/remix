part of 'slider.dart';

const Size _remixSliderDefaultThumbSize = Size.square(16);
const double _remixSliderDefaultTrackThickness = 8;
const Color _remixSliderDefaultTrackColor = MixColors.grey;
const Color _remixSliderDefaultRangeColor = MixColors.black;

/// What a [RemixSliderThumbOverlayBuilder] receives for one thumb.
@immutable
final class RemixSliderThumbOverlayInfo {
  const RemixSliderThumbOverlayInfo({
    required this.index,
    required this.value,
    required this.states,
  });

  /// The thumb's position in the slider's values: `0` for a single slider, `0`
  /// or `1` for a range slider.
  final int index;

  /// The thumb's current value, between the slider's `min` and `max`.
  final double value;

  /// The thumb's own interaction states. `WidgetState.pressed` means it is
  /// being dragged, and `WidgetState.focused` that it has keyboard focus.
  final Set<WidgetState> states;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemixSliderThumbOverlayInfo &&
          index == other.index &&
          value == other.value &&
          setEquals(states, other.states);

  @override
  int get hashCode =>
      Object.hash(index, value, Object.hashAllUnordered(states));
}

/// Builds a widget drawn over one slider thumb, such as a value bubble.
typedef RemixSliderThumbOverlayBuilder =
    Widget Function(BuildContext context, RemixSliderThumbOverlayInfo thumb);

/// Shared visuals for [RemixSlider] and [RemixRangeSlider].
@MixableSpec(target: RemixSlider.new, extraStylerMixins: [RemixBoxStylerMixin])
class SliderSpec with _$SliderSpec {
  static const Size defaultThumbSize = _remixSliderDefaultThumbSize;
  static const double defaultTrackStrokeWidth =
      _remixSliderDefaultTrackThickness;

  /// Layout boundary for the complete track.
  @override
  final StyleSpec<BoxSpec> track;

  /// Established solid-color track API.
  @override
  final Color trackColor;

  /// Established unfilled-track width API.
  @override
  final double trackWidth;

  /// Paint layers behind the track.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? trackEffects;

  /// Layout boundary for the selected range.
  @override
  final StyleSpec<BoxSpec> range;

  /// Established solid-color selected-range API.
  @override
  final Color rangeColor;

  /// Established selected-range width API.
  @override
  final double rangeWidth;

  /// Paint layers behind the selected range.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? rangeEffects;

  /// Layout and decoration for every visual thumb.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> thumb;

  /// Paint layers behind every thumb.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? thumbEffects;

  /// Additional overlay painted only when the focused thumb should show a
  /// focus highlight for the current input modality.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? thumbFocusEffects;

  /// Whole-subtree blend used for state recipes such as disabled sliders.
  @override
  final BlendMode? blendMode;

  /// How a thumb moves to a value that does not come from dragging it: a key
  /// press, a press on the track, or a value the app sets. Accepts
  /// [CurveAnimationConfig] (such as `AnimationConfig.curve(...)`) or
  /// [SpringAnimationConfig] (such as `AnimationConfig.springDescription(...)`),
  /// which may overshoot. The selected range follows the moving thumbs.
  ///
  /// `null`, the default, jumps to every new value. While a thumb is dragged
  /// it follows the pointer, and under reduced motion every change jumps.
  /// The slider throws [ArgumentError] for phase and keyframe configs when it
  /// builds. `onEnd` runs only when a move completes, not when it is
  /// interrupted.
  @override
  final AnimationConfig? thumbMotion;

  /// Builds a widget over each thumb, such as a bubble that shows its value.
  ///
  /// The widget takes its natural size, is centered on the thumb, and moves
  /// with it, so offset it with a transform to place it above. It may paint
  /// outside the slider, takes no pointer input, and is excluded from
  /// semantics because the slider already announces its value. `null`, the
  /// default, draws nothing. Pass a top-level or static function so resolved
  /// specs compare equal across rebuilds.
  @override
  final RemixSliderThumbOverlayBuilder? thumbOverlay;

  const SliderSpec({
    StyleSpec<BoxSpec>? track,
    Color? trackColor,
    double? trackWidth,
    this.trackEffects,
    StyleSpec<BoxSpec>? range,
    Color? rangeColor,
    double? rangeWidth,
    this.rangeEffects,
    StyleSpec<BoxSpec>? thumb,
    this.thumbEffects,
    this.thumbFocusEffects,
    this.blendMode,
    this.thumbMotion,
    this.thumbOverlay,
  }) : trackColor = trackColor ?? _remixSliderDefaultTrackColor,
       trackWidth = trackWidth ?? _remixSliderDefaultTrackThickness,
       rangeColor = rangeColor ?? _remixSliderDefaultRangeColor,
       rangeWidth = rangeWidth ?? _remixSliderDefaultTrackThickness,
       track = track ?? const StyleSpec(spec: BoxSpec()),
       range = range ?? const StyleSpec(spec: BoxSpec()),
       thumb = thumb ?? const StyleSpec(spec: BoxSpec());

  /// Largest track or range width used for layout clearance.
  double get trackThickness => math.max(trackWidth, rangeWidth);

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  SliderSpec lerp(SliderSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      trackEffects: RemixBoxEffectsSpec.lerpNullable(
        trackEffects,
        other.trackEffects,
        t,
      ),
      rangeEffects: RemixBoxEffectsSpec.lerpNullable(
        rangeEffects,
        other.rangeEffects,
        t,
      ),
      thumbEffects: RemixBoxEffectsSpec.lerpNullable(
        thumbEffects,
        other.thumbEffects,
        t,
      ),
      thumbFocusEffects: RemixBoxEffectsSpec.lerpNullable(
        thumbFocusEffects,
        other.thumbFocusEffects,
        t,
      ),
    );
  }
}

/// Backward-compatible name for [SliderSpec].
///
/// The generated style API is based on [SliderSpec], so resolved values use
/// `SliderSpec` as their runtime type.
typedef RemixSliderSpec = SliderSpec;
