// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combobox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Combobox recipe.
///
/// The field reuses [vanillaTextFieldStyle], with its focus, error and
/// disabled treatments; the panel and rows follow the Select recipe.
///
/// Keyboard highlight is `accent` with a `ring` border, hover a lighter tint,
/// press a primary tint. Suggestions are eligible values only, so Remix has no
/// per-option disabled or selected state.
///
/// A custom `fieldBuilder` owns its field recipe; custom `optionBuilder`
/// content inherits the row's text style.
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
    this.isOptionDisabled,
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

  final bool Function(T option)? isOptionDisabled;

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
      isOptionDisabled: this.isOptionDisabled,
      onOpen: this.onOpen,
      onClose: this.onClose,
      excludeSemantics: this.excludeSemantics,
    );
  }
}
