// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combobox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI v3 ComboBox appearance over Remix's editable suggestions API.
///
/// The field reuses TextField, while the panel and rows follow ComboBox's
/// ListBox (the same anatomy as Select). Remix owns editing, filtering
/// callbacks, traversal, acceptance, overflow fades and the scrollbar.
/// Accepted values appear in the editor; suggestions have no persistent
/// selected or per-option disabled state. Custom field builders own their
/// field appearance, and caller style overrides merge last.
class HeroUiCombobox<T extends Object> extends StatelessWidget {
  const HeroUiCombobox({
    super.key,
    this.variant = .primary,
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

  const HeroUiCombobox.primary({
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
  }) : variant = HeroUiComboboxVariant.primary;

  const HeroUiCombobox.secondary({
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
  }) : variant = HeroUiComboboxVariant.secondary;

  final HeroUiComboboxVariant variant;

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
      style: heroUiComboboxStyle(variant: this.variant, style: this.style),
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
