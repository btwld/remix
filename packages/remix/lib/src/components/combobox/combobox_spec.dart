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
  final StyleSpec<BoxSpec> panel;

  /// Suggestion row and label, resolved in the option's own state.
  @override
  final StyleSpec<ComboboxOptionSpec> option;

  const ComboboxSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextFieldSpec>? field,
    StyleSpec<BoxSpec>? panel,
    StyleSpec<ComboboxOptionSpec>? option,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       field = field ?? const StyleSpec(spec: TextFieldSpec()),
       panel = panel ?? const StyleSpec(spec: BoxSpec()),
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
