// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkbox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Checkbox recipe.
///
/// It reads top to bottom: the box and its focus ring, then the variant's
/// colors for rest, selected and disabled, then the touch target.
///
/// [highContrast] moves the selected fill (surface) or mark (soft) to accent
/// step 12.
class FortalCheckbox extends StatelessWidget {
  const FortalCheckbox({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
    this.style = const CheckboxStyler.create(),
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.tristate = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.indeterminateIcon,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// A surface fill inside a 1px neutral frame, filled with the accent when
  /// selected.
  const FortalCheckbox.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const CheckboxStyler.create(),
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.tristate = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.indeterminateIcon,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalCheckboxVariant.surface;

  /// An accent tint inside a 1px accent ring, with an accent-colored mark.
  const FortalCheckbox.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const CheckboxStyler.create(),
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.tristate = false,
    this.checkedIcon,
    this.uncheckedIcon,
    this.indeterminateIcon,
    this.focusNode,
    this.autofocus = false,
    this.enableFeedback = true,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalCheckboxVariant.soft;

  final FortalCheckboxVariant variant;

  final FortalCheckboxSize size;

  final bool highContrast;

  final CheckboxStyler style;

  final bool? selected;

  final ValueChanged<bool?>? onChanged;

  final bool enabled;

  final bool tristate;

  final IconData? checkedIcon;

  final IconData? uncheckedIcon;

  final IconData? indeterminateIcon;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool enableFeedback;

  final String? label;

  final String? semanticLabel;

  final Size minimumTapTargetSize;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return RemixCheckbox(
      key: this.key,
      style: fortalCheckboxStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
      selected: this.selected,
      onChanged: this.onChanged,
      enabled: this.enabled,
      tristate: this.tristate,
      checkedIcon: this.checkedIcon,
      uncheckedIcon: this.uncheckedIcon,
      indeterminateIcon: this.indeterminateIcon,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      enableFeedback: this.enableFeedback,
      label: this.label,
      semanticLabel: this.semanticLabel,
      minimumTapTargetSize: this.minimumTapTargetSize,
      mouseCursor: this.mouseCursor,
    );
  }
}

/// The Fortal CheckboxGroupItem recipe: the checkbox recipe plus a label.
///
/// It exists because `RemixCheckboxGroup` is behavioral and carries no styler,
/// so, unlike the menu, select, segmented control and toggle group items, there
/// is no parent recipe to push item styling down. Radio group items are the
/// same. Without this,
/// callers hand-attach a styler to each item and a missed one in a loop renders
/// unstyled beside its styled siblings.
class FortalCheckboxGroupItem<T extends Object> extends StatelessWidget {
  const FortalCheckboxGroupItem({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
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
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// A surface fill inside a 1px neutral frame, filled with the accent when
  /// selected.
  const FortalCheckboxGroupItem.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalCheckboxVariant.surface;

  /// An accent tint inside a 1px accent ring, with an accent-colored mark.
  const FortalCheckboxGroupItem.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalCheckboxVariant.soft;

  final FortalCheckboxVariant variant;

  final FortalCheckboxSize size;

  final bool highContrast;

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

  final Size minimumTapTargetSize;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return RemixCheckboxGroupItem<T>(
      key: this.key,
      style: fortalCheckboxGroupItemStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
      value: this.value,
      label: this.label,
      semanticLabel: this.semanticLabel,
      enabled: this.enabled,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      checkedIcon: this.checkedIcon,
      uncheckedIcon: this.uncheckedIcon,
      enableFeedback: this.enableFeedback,
      minimumTapTargetSize: this.minimumTapTargetSize,
      mouseCursor: this.mouseCursor,
    );
  }
}
