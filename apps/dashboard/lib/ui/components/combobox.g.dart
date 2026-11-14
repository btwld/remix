// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combobox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Ui Combobox recipe: an editable field with a panel of suggestions.
///
/// The field shares TextField's recipe. Suggestions use the Select panel's
/// token roles with growing rows and separate hover, keyboard and press fills.
/// Remix owns filtering callbacks, traversal, acceptance, fades and scrollbar.
/// Eligible suggestions have no persistent selected or per-option disabled
/// state; acceptance writes the value into the field. A custom field builder
/// owns its editor styling. Caller overrides merge last.
class UiCombobox<T extends Object> extends StatelessWidget {
  const UiCombobox({
    super.key,
    this.variant = .surface,
    this.size = .size2,
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

  /// The `gray2` fill inside a 1px neutral frame.
  const UiCombobox.surface({
    super.key,
    this.size = .size2,
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
  }) : variant = UiComboboxVariant.surface;

  /// An accent tint inside a 1px accent ring.
  const UiCombobox.soft({
    super.key,
    this.size = .size2,
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
  }) : variant = UiComboboxVariant.soft;

  final UiComboboxVariant variant;

  final UiComboboxSize size;

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
      style: uiComboboxStyle(
        variant: this.variant,
        size: this.size,
        style: this.style,
      ),
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
