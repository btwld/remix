// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkbox_group.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixCheckboxGroupItem]: the checkbox recipe on an item
/// that carries its own label.
///
/// [minimumTapTargetSize] sets the widget's default tap target, as on
/// `HeroUiCheckbox`.
class HeroUiCheckboxGroupItem<T extends Object> extends StatelessWidget {
  const HeroUiCheckboxGroupItem({
    super.key,
    this.variant = .primary,
    this.invalid = false,
    this.minimumTapTargetSize = heroUiCheckboxTapTarget,
    this.style = const CheckboxStyler.create(),
    required this.value,
    required this.label,
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
  const HeroUiCheckboxGroupItem.primary({
    super.key,
    this.invalid = false,
    this.minimumTapTargetSize = heroUiCheckboxTapTarget,
    this.style = const CheckboxStyler.create(),
    required this.value,
    required this.label,
    this.semanticLabel,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.enableFeedback = true,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = HeroUiCheckboxVariant.primary;

  /// The `default` fill.
  const HeroUiCheckboxGroupItem.secondary({
    super.key,
    this.invalid = false,
    this.minimumTapTargetSize = heroUiCheckboxTapTarget,
    this.style = const CheckboxStyler.create(),
    required this.value,
    required this.label,
    this.semanticLabel,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.enableFeedback = true,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = HeroUiCheckboxVariant.secondary;

  final HeroUiCheckboxVariant variant;

  final bool invalid;

  final Size minimumTapTargetSize;

  final CheckboxStyler style;

  final T value;

  final String label;

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
      style: heroUiCheckboxGroupItemStyle(
        variant: variant,
        invalid: invalid,
        minimumTapTargetSize: minimumTapTargetSize,
        style: style,
      ),
      value: value,
      label: label,
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
