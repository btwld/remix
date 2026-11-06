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

  /// Row appearance; focused means RawAutocomplete's keyboard highlight.
  @override
  final StyleSpec<BoxSpec> option;

  /// Default label and inherited text style for custom visual content.
  @override
  final StyleSpec<TextSpec> optionLabel;

  const ComboboxSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextFieldSpec>? field,
    StyleSpec<BoxSpec>? panel,
    StyleSpec<BoxSpec>? option,
    StyleSpec<TextSpec>? optionLabel,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       field = field ?? const StyleSpec(spec: TextFieldSpec()),
       panel = panel ?? const StyleSpec(spec: BoxSpec()),
       option = option ?? const StyleSpec(spec: BoxSpec()),
       optionLabel = optionLabel ?? const StyleSpec(spec: TextSpec());
}
