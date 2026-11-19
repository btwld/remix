part of 'popover.dart';

/// Resolved visual properties for a [RemixPopover] overlay.
@MixableSpec(target: RemixPopover.new, extraStylerMixins: [RemixBoxStylerMixin])
class PopoverSpec with _$PopoverSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;
  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  /// Opens and closes the panel with a transition.
  ///
  /// The builder receives the open and close animation and the trigger's
  /// bounds, and the panel stays mounted until the exit has played. `null`
  /// shows and hides the panel at once.
  @override
  final RemixPanelTransition? panelTransition;

  const PopoverSpec({
    StyleSpec<BoxSpec>? container,
    this.containerEffects,
    this.panelTransition,
  }) : container = container ?? const StyleSpec(spec: BoxSpec());

  // Deliberate: route effects through lerpNullable so shadows/blends animate;
  // the generator's default snap-lerps unrecognized spec types.
  @override
  PopoverSpec lerp(PopoverSpec? other, double t) {
    final generated = super.lerp(other, t);
    if (other == null) return generated;
    return generated.copyWith(
      containerEffects: RemixBoxEffectsSpec.lerpNullable(
        containerEffects,
        other.containerEffects,
        t,
      ),
      panelTransition: generated.panelTransition,
    );
  }
}

/// Backward-compatible name for [PopoverSpec].
///
/// The generated style API is based on [PopoverSpec], so resolved values use
/// `PopoverSpec` as their runtime type.
typedef RemixPopoverSpec = PopoverSpec;
