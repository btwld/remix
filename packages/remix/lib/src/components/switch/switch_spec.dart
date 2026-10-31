part of 'switch.dart';

/// Resolved visual values for a [RemixSwitch].
@MixableSpec(
  target: RemixSwitch.new,
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin],
)
class SwitchSpec with _$SwitchSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<BoxSpec> thumb;

  /// Styling specification for the optional visible switch label.
  @override
  final StyleSpec<TextSpec> label;

  /// Gap between the switch and its optional visible label.
  @override
  final double labelSpacing;

  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? trackEffects;

  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? thumbEffects;

  const SwitchSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? thumb,
    StyleSpec<TextSpec>? label,
    double? labelSpacing,
    this.trackEffects,
    this.thumbEffects,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       thumb = thumb ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       labelSpacing = labelSpacing ?? 8;

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  SwitchSpec lerp(SwitchSpec? other, double t) {
    if (other == null) return this;
    final generated = super.lerp(other, t);
    return generated.copyWith(
      trackEffects: RemixBoxEffectsSpec.lerpNullable(
        trackEffects,
        other.trackEffects,
        t,
      ),
      thumbEffects: RemixBoxEffectsSpec.lerpNullable(
        thumbEffects,
        other.thumbEffects,
        t,
      ),
    );
  }
}

/// Backward-compatible name for [SwitchSpec].
///
/// The generated style API is based on [SwitchSpec], so resolved values use
/// `SwitchSpec` as their runtime type.
typedef RemixSwitchSpec = SwitchSpec;
