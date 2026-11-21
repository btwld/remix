// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkbox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Checkbox recipe.
///
/// A 16px box with 4px corners, an `input` outline and a 10px check. It has no
/// hover or pressed fragment: a checkbox flips its own state, and that is the
/// feedback. The label is a form label, `textSm` at medium weight.
class PlaygroundCheckbox extends StatelessWidget {
  const PlaygroundCheckbox({
    super.key,
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
  Widget build(BuildContext _) {
    return RemixCheckbox(
      style: playgroundCheckboxStyle(style: style),
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
      semanticLabel: semanticLabel,
      minimumTapTargetSize: minimumTapTargetSize,
      mouseCursor: mouseCursor,
    );
  }
}

/// The Checkbox recipe for one option in a `RemixCheckboxGroup`.
///
/// The group has no styler, so each option needs its own adapter. It is the
/// same checkbox as [playgroundCheckboxStyle], so it delegates.
class PlaygroundCheckboxGroupItem<T extends Object> extends StatelessWidget {
  const PlaygroundCheckboxGroupItem({
    super.key,
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
  Widget build(BuildContext _) {
    return RemixCheckboxGroupItem<T>(
      style: playgroundCheckboxGroupItemStyle(style: style),
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
