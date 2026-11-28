// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combobox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Combobox recipe: an editable field with a panel of suggestions.
///
/// The field takes TextField's recipe with its own frame: a quiet frame at
/// rest, the strong frame over the muted fill while hovered or open, and the
/// accent frame while focused with the panel closed. The panel is the raised
/// surface 8px below the field; it grows in on the snappy spring and leaves
/// faster than it came. Suggestions are 36px rows that take the muted fill
/// under the pointer, the keyboard and a press.
///
/// Remix owns filtering callbacks, traversal, acceptance and scrolling.
/// Eligible suggestions have no persistent selected or per-option disabled
/// state; acceptance writes the value into the field. A custom field builder
/// owns its editor styling. Caller overrides merge last.
class FortalCombobox<T extends Object> extends StatelessWidget {
  const FortalCombobox({
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
    this.helperText,
    this.errorText,
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

  /// The surface fill inside a 1px strong frame.
  const FortalCombobox.surface({
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
    this.helperText,
    this.errorText,
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
  }) : variant = FortalTextFieldVariant.surface;

  /// The muted surface fill with no frame until hovered or focused.
  const FortalCombobox.soft({
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
    this.helperText,
    this.errorText,
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
  }) : variant = FortalTextFieldVariant.soft;

  final FortalTextFieldVariant variant;

  final FortalTextFieldSize size;

  final ComboboxStyler style;

  final AutocompleteOptionsBuilder<T> optionsBuilder;

  final ValueChanged<T>? onSelected;

  final AutocompleteOptionToString<T> displayStringForOption;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final TextEditingValue? initialValue;

  final String? label;

  final String? hintText;

  final String? helperText;

  final String? errorText;

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
  Widget build(BuildContext _) {
    return RemixCombobox<T>(
      style: fortalComboboxStyle(variant: variant, size: size, style: style),
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      displayStringForOption: displayStringForOption,
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      label: label,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      enabled: enabled,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      fieldBuilder: fieldBuilder,
      optionBuilder: optionBuilder,
      optionsViewOpenDirection: optionsViewOpenDirection,
      isOptionDisabled: isOptionDisabled,
      onOpen: onOpen,
      onClose: onClose,
      excludeSemantics: excludeSemantics,
    );
  }
}
