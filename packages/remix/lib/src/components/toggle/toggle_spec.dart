part of 'toggle.dart';

/// Resolved visual properties for a [RemixToggle].
@MixableSpec(
  target: RemixToggle.new,
  extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin, IconStyleMixin],
)
class ToggleSpec with _$ToggleSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<FlexBoxSpec> container;

  /// Outline and paint layers drawn around [container] without affecting
  /// layout, such as a focus ring.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  @override
  final StyleSpec<TextSpec> label;
  @override
  final StyleSpec<IconSpec> icon;

  const ToggleSpec({
    StyleSpec<FlexBoxSpec>? container,
    this.containerEffects,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec()),
       icon = icon ?? const StyleSpec(spec: IconSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  ToggleSpec lerp(ToggleSpec? other, double t) {
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

/// Backward-compatible name for [ToggleSpec].
///
/// The generated style API is based on [ToggleSpec], so resolved values use
/// `ToggleSpec` as their runtime type.
typedef RemixToggleSpec = ToggleSpec;
