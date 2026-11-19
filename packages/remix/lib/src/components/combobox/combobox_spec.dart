part of 'combobox.dart';

/// Resolved anatomy for [RemixCombobox].
@MixableSpec(
  target: RemixCombobox.new,
  extraStylerMixins: [RemixBoxStylerMixin],
)
class ComboboxSpec with _$ComboboxSpec {
  /// Root layout around the editor. Panel geometry belongs to RawAutocomplete.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Default editor appearance, resolved in the editor's own state.
  @override
  final StyleSpec<TextFieldSpec> field;

  /// Bounded suggestions surface.
  @override
  final StyleSpec<ComboboxPanelSpec> panel;

  /// Suggestion row and label, resolved in the option's own state.
  @override
  final StyleSpec<ComboboxOptionSpec> option;

  const ComboboxSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextFieldSpec>? field,
    StyleSpec<ComboboxPanelSpec>? panel,
    StyleSpec<ComboboxOptionSpec>? option,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       field = field ?? const StyleSpec(spec: TextFieldSpec()),
       panel = panel ?? const StyleSpec(spec: ComboboxPanelSpec()),
       option = option ?? const StyleSpec(spec: ComboboxOptionSpec());
}

/// Resolved visual values for a combobox suggestion.
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin, LabelStyleMixin])
class ComboboxOptionSpec with _$ComboboxOptionSpec {
  /// Row appearance; focused means RawAutocomplete's keyboard highlight.
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  /// Default label and inherited text style for custom visual content.
  @override
  final StyleSpec<TextSpec> label;

  const ComboboxOptionSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec());
}

/// Suggestions surface, effects and persistent overflow cue.
@MixableSpec(extraStylerMixins: [RemixBoxStylerMixin])
class ComboboxPanelSpec with _$ComboboxPanelSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;

  @override
  @MixableField(setterType: RemixBoxEffectsMix)
  final RemixBoxEffectsSpec? containerEffects;

  /// Defaults to the inherited text color at 35% opacity.
  @override
  final Color? scrollbarColor;

  /// Logical width of the overflow thumb; defaults to 4px.
  @override
  final double? scrollbarThickness;

  const ComboboxPanelSpec({
    StyleSpec<BoxSpec>? container,
    this.containerEffects,
    this.scrollbarColor,
    this.scrollbarThickness,
  }) : container = container ?? const StyleSpec(spec: BoxSpec());

  @override
  ComboboxPanelSpec lerp(ComboboxPanelSpec? other, double t) {
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
