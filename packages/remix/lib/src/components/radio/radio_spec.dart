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

  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  const RadioSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? indicator,
    StyleSpec<TextSpec>? label,
    double? labelSpacing,
    this.containerEffects,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       indicator = indicator ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       labelSpacing = labelSpacing ?? 8;

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
