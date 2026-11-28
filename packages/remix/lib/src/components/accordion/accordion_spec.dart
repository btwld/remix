part of 'accordion.dart';

/// Resolved visual properties for a [RemixAccordion].
@MixableSpec(
  target: RemixAccordion.new,
  extraStylerMixins: [RemixBoxStylerMixin],
)
class AccordionSpec with _$AccordionSpec {
  /// Outer panel: radius, border, fill, and clipping shared by [trigger] and
  /// [content].
  ///
  /// Not [forwardStyler]-forwarded: [trigger] already forwards the top-level
  /// Box shorthand (`.color()`, `.borderRadius()`, ...), and a spec cannot
  /// forward two fields without colliding. Reach [container] explicitly.
  @override
  final StyleSpec<BoxSpec> container;

  /// Layered fills, strokes, and backdrop blur painted with [container].
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<FlexBoxSpec> trigger;

  /// Outline and paint layers drawn around [trigger] only, so a focus ring
  /// does not wrap the revealed content.
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? triggerEffects;
  @override
  final StyleSpec<IconSpec> leadingIcon;
  @override
  final StyleSpec<TextSpec> title;
  @override
  final StyleSpec<IconSpec> trailingIcon;
  @override
  final StyleSpec<BoxSpec> content;

  /// How [content] opens and closes. Accepts [CurveAnimationConfig] (such as
  /// `AnimationConfig.curve(...)`) or [SpringAnimationConfig] (such as
  /// `AnimationConfig.springDescription(...)`). Wrap two configs in
  /// `AnimationConfig.reversible(open, reverse: close)` to close on different
  /// timing. `null` opens and closes linearly over 200 ms.
  ///
  /// A toggle during a transition turns the same panel around from where it
  /// is; a curve then takes the share of its duration that is left to cover,
  /// and a spring keeps its velocity. A curve's `delay` and a config's
  /// `onEnd` are not used. [RemixAccordion] throws [ArgumentError] for phase
  /// and keyframe configs when it builds. This is separate from the styler's
  /// own `animate`, which animates style changes.
  @override
  final AnimationConfig? contentMotion;

  const AccordionSpec({
    StyleSpec<BoxSpec>? container,
    this.containerEffects,
    StyleSpec<FlexBoxSpec>? trigger,
    this.triggerEffects,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<TextSpec>? title,
    StyleSpec<IconSpec>? trailingIcon,
    StyleSpec<BoxSpec>? content,
    this.contentMotion,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       trigger = trigger ?? const StyleSpec(spec: FlexBoxSpec()),
       leadingIcon = leadingIcon ?? const StyleSpec(spec: IconSpec()),
       title = title ?? const StyleSpec(spec: TextSpec()),
       trailingIcon = trailingIcon ?? const StyleSpec(spec: IconSpec()),
       content = content ?? const StyleSpec(spec: BoxSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  AccordionSpec lerp(AccordionSpec? other, double t) {
    if (other == null) return this;
    final generated = super.lerp(other, t);

    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
      triggerEffects: RemixBoxEffectsSpec.lerpNullable(
        triggerEffects,
        other.triggerEffects,
        t,
      ),
    );
  }
}

/// Backward-compatible name for [AccordionSpec].
///
/// The generated style API is based on [AccordionSpec], so resolved values use
/// `AccordionSpec` as their runtime type.
typedef RemixAccordionSpec = AccordionSpec;
