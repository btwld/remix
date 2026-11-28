// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkbox_group.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixCheckboxGroupItem]: the checkbox recipe on an item
/// that carries its own label.
///
/// [minimumTapTargetSize] sets the widget's default tap target, as on
/// `UiCheckbox`.
class UiCheckboxGroupItem<T extends Object> extends StatelessWidget {
  const UiCheckboxGroupItem({
    super.key,
    this.variant = .primary,
    this.invalid = false,
    this.minimumTapTargetSize = uiCheckboxTapTarget,
    this.style = const CheckboxStyler.create(),
    required this.value,
    required this.label,
    this.description,
    this.semanticLabel,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.enableFeedback = true,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// The field surface fill, with its shadow.
  const UiCheckboxGroupItem.primary({
    super.key,
    this.invalid = false,
    this.minimumTapTargetSize = uiCheckboxTapTarget,
    this.style = const CheckboxStyler.create(),
    required this.value,
    required this.label,
    this.description,
    this.semanticLabel,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.enableFeedback = true,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiCheckboxVariant.primary;

  /// The `default` fill.
  const UiCheckboxGroupItem.secondary({
    super.key,
    this.invalid = false,
    this.minimumTapTargetSize = uiCheckboxTapTarget,
    this.style = const CheckboxStyler.create(),
    required this.value,
    required this.label,
    this.description,
    this.semanticLabel,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.enableFeedback = true,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiCheckboxVariant.secondary;

  final UiCheckboxVariant variant;

  final bool invalid;

  final Size minimumTapTargetSize;

  final CheckboxStyler style;

  final T value;

  final String label;

  final String? description;

  final String? semanticLabel;

  final bool enabled;

  final FocusNode? focusNode;

  final bool autofocus;

  final IconData? checkedIcon;

  final IconData? uncheckedIcon;

  final bool enableFeedback;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext _) {
    return RemixCheckboxGroupItem<T>(
      style: uiCheckboxGroupItemStyle(
        variant: variant,
        invalid: invalid,
        minimumTapTargetSize: minimumTapTargetSize,
        style: style,
      ),
      value: value,
      label: label,
      description: description,
      semanticLabel: semanticLabel,
      enabled: enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      checkedIcon: checkedIcon,
      uncheckedIcon: uncheckedIcon,
      enableFeedback: enableFeedback,
      minimumTapTargetSize: minimumTapTargetSize,
      mouseCursor: mouseCursor,
    );
  }
}
