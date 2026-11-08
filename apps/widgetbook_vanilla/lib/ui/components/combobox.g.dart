// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combobox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Combobox recipe.
///
/// Remix owns editing, filtering callbacks, suggestion traversal, acceptance,
/// overlay geometry and accessibility semantics. This recipe supplies the
/// field, floating suggestions panel and option rows. The field reuses
/// [vanillaTextFieldStyle], including its focus, error and disabled treatments;
/// the panel and rows follow the application's Select recipe.
///
/// Keyboard highlight uses accent, hover a lighter tint, and press a stronger
/// primary tint. Suggestions
/// are eligible values only: Remix has no per-option disabled or selected
/// state. The disabled treatment belongs to the editor. Custom field builders
/// own their field recipe; custom option content inherits the row's text style.
class VanillaCombobox<T extends Object> extends StatelessWidget {
  const VanillaCombobox({
    super.key,
    this.style = const ComboboxStyler.create(),
    required this.optionsBuilder,
    this.onSelected,
    this.displayStringForOption = RawAutocomplete.defaultStringForOption,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.label,
    this.hintText,
    this.enabled = true,
    this.autofocus = false,
    this.semanticLabel,
    this.fieldBuilder,
    this.optionBuilder,
    this.optionsViewOpenDirection = OptionsViewOpenDirection.down,
    this.onOpen,
    this.onClose,
    this.excludeSemantics = false,
  });

  final ComboboxStyler style;

  final AutocompleteOptionsBuilder<T> optionsBuilder;

  final ValueChanged<T>? onSelected;

  final AutocompleteOptionToString<T> displayStringForOption;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final TextEditingValue? initialValue;

  final String? label;

  final String? hintText;

  final bool enabled;

  final bool autofocus;

  final String? semanticLabel;

  final NakedComboboxFieldBuilder<T>? fieldBuilder;

  final Widget Function(BuildContext context, T option)? optionBuilder;

  final OptionsViewOpenDirection optionsViewOpenDirection;

  final VoidCallback? onOpen;

  final VoidCallback? onClose;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return RemixCombobox<T>(
      key: this.key,
      style: vanillaComboboxStyle(style: this.style),
      optionsBuilder: this.optionsBuilder,
      onSelected: this.onSelected,
      displayStringForOption: this.displayStringForOption,
      controller: this.controller,
      focusNode: this.focusNode,
      initialValue: this.initialValue,
      label: this.label,
      hintText: this.hintText,
      enabled: this.enabled,
      autofocus: this.autofocus,
      semanticLabel: this.semanticLabel,
      fieldBuilder: this.fieldBuilder,
      optionBuilder: this.optionBuilder,
      optionsViewOpenDirection: this.optionsViewOpenDirection,
      onOpen: this.onOpen,
      onClose: this.onClose,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
