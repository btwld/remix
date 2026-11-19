// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkbox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixCheckbox]: a 20px box with 6px corners and a 2px
/// edge that fills `accent` when checked or mixed.
///
/// [invalid] draws the edge and label in `danger`. The check mark is Remix's
/// indicator at 12px. [style] merges last.
class DeuiCheckbox extends StatelessWidget {
  const DeuiCheckbox({
    super.key,
    this.invalid = false,
    this.minimumTapTargetSize = deuiCheckboxTapTarget,
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
    this.mouseCursor = SystemMouseCursors.click,
  });

  final bool invalid;

  final Size minimumTapTargetSize;

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

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext context) {
    return RemixCheckbox(
      key: this.key,
      style: deuiCheckboxStyle(
        invalid: this.invalid,
        minimumTapTargetSize: this.minimumTapTargetSize,
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
