// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkbox.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixCheckbox].
///
/// [invalid] paints the error treatment; validation stays with the app.
/// [minimumTapTargetSize] sets the widget's default tap target to HeroUI's 24px
/// `touch-target`; the style itself does not read it.
class HeroUiCheckbox extends StatelessWidget {
  const HeroUiCheckbox({
    super.key,
    this.variant = .primary,
    this.invalid = false,
    this.minimumTapTargetSize = heroUiCheckboxTapTarget,
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

  const HeroUiCheckbox.primary({
    super.key,
    this.invalid = false,
    this.minimumTapTargetSize = heroUiCheckboxTapTarget,
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
  }) : variant = HeroUiCheckboxVariant.primary;

  const HeroUiCheckbox.secondary({
    super.key,
    this.invalid = false,
    this.minimumTapTargetSize = heroUiCheckboxTapTarget,
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
  }) : variant = HeroUiCheckboxVariant.secondary;

  final HeroUiCheckboxVariant variant;

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
      style: heroUiCheckboxStyle(
        variant: this.variant,
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
