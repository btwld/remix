// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkbox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Checkbox recipe.
///
/// It reads top to bottom: the square, then the variant's frame, fill and
/// mark, then press, disabled and the focus ring around the touch target.
/// The fill and mark are drawn by [_UiCheckMark], which springs the fill
/// in from 60%, draws the check on and morphs it into the dash.
///
/// [highContrast] moves the selected fill (surface) or mark (soft) to accent
/// step 12.
class UiCheckbox extends StatelessWidget {
  const UiCheckbox({
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
    this.description,
    this.semanticLabel,
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// A surface square inside a 1px strong frame, filled with the control ink
  /// when selected.
  const UiCheckbox.surface({
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
    this.description,
    this.semanticLabel,
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiCheckboxVariant.surface;

  /// The surface square at rest; selected, a 10% control-ink tint inside a
  /// control-ink frame, with a control-ink mark.
  const UiCheckbox.soft({
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
    this.description,
    this.semanticLabel,
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiCheckboxVariant.soft;

  final UiCheckboxVariant variant;

  final UiCheckboxSize size;

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

  final String? description;

  final String? semanticLabel;

  final Size minimumTapTargetSize;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext _) {
    return RemixCheckbox(
      style: uiCheckboxStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      selected: selected,
      onChanged: onChanged,
      enabled: enabled,
      tristate: tristate,
      checkedIcon: checkedIcon,
      uncheckedIcon: uncheckedIcon,
      indeterminateIcon: indeterminateIcon,
      focusNode: focusNode,
      autofocus: autofocus,
      enableFeedback: enableFeedback,
      label: label,
      description: description,
      semanticLabel: semanticLabel,
      minimumTapTargetSize: minimumTapTargetSize,
      mouseCursor: mouseCursor,
    );
  }
}

/// The Fortal CheckboxGroupItem recipe: the checkbox recipe plus a label and
/// an optional description under it.
///
/// It exists because `RemixCheckboxGroup` is behavioral and carries no styler,
/// so, unlike the menu, select, segmented control and toggle group items, there
/// is no parent recipe to push item styling down. Radio group items are the
/// same. Without this,
/// callers hand-attach a styler to each item and a missed one in a loop renders
/// unstyled beside its styled siblings.
class UiCheckboxGroupItem<T extends Object> extends StatelessWidget {
  const UiCheckboxGroupItem({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
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
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// A surface square inside a 1px strong frame, filled with the control ink
  /// when selected.
  const UiCheckboxGroupItem.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiCheckboxVariant.surface;

  /// The surface square at rest; selected, a 10% control-ink tint inside a
  /// control-ink frame, with a control-ink mark.
  const UiCheckboxGroupItem.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
    this.minimumTapTargetSize = const Size.square(48),
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = UiCheckboxVariant.soft;

  final UiCheckboxVariant variant;

  final UiCheckboxSize size;

  final bool highContrast;

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

  final Size minimumTapTargetSize;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext _) {
    return RemixCheckboxGroupItem<T>(
      style: uiCheckboxGroupItemStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
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
