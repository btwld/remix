part of 'radio.dart';

/// Defines the resolved styling structure for [RemixRadio].
///
/// The spec is populated by [RadioStyler] and consumed by the widget when
/// building the control. It provides three [StyleSpec] segments representing the
/// container (outer ring), the indicator fill shown when the radio is selected,
/// and the optional visible label.
@MixableSpec(
  target: RemixRadio.new,
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin],
)
class RadioSpec with _$RadioSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<BoxSpec> indicator;

  /// Styling specification for the optional visible radio label.
  @override
  final StyleSpec<TextSpec> label;

  /// Gap between the radio and its optional visible label.
  @override
  final double labelSpacing;

  /// Whether [indicator] is built while the radio is unselected too.
  ///
  /// `false`, the default, removes the indicator when the radio is unselected.
  /// With `true` it stays mounted in every state, so a style can hide it while
  /// unselected (for example with zero opacity and a smaller scale), animate it
  /// out on deselection, or preview it while pressed.
  @override
  final bool keepIndicatorMounted;

  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  const RadioSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<TextSpec>? label,
    double? labelSpacing,
    this.containerEffects,
    bool? keepIndicatorMounted,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       indicator = indicator ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       labelSpacing = labelSpacing ?? 8,
       keepIndicatorMounted = keepIndicatorMounted ?? false;

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  RadioSpec lerp(RadioSpec? other, double t) {
    if (other == null) return this;
    final generated = super.lerp(other, t);
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
    );
  }
}

/// Backward-compatible name for [RadioSpec].
///
/// The generated style API is based on [RadioSpec], so resolved values use
/// `RadioSpec` as their runtime type.
typedef RemixRadioSpec = RadioSpec;
