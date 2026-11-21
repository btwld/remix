// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixSwitch].
///
/// The label sits inside the control's tap target. A description beneath it is
/// `HeroUiSwitchGroup`'s. [invalid] turns the label danger, as
/// `[data-invalid] .label`; `switch.css` has no invalid treatment for the
/// control itself.
class HeroUiSwitch extends StatelessWidget {
  const HeroUiSwitch({
    super.key,
    this.size = .md,
    this.invalid = false,
    this.style = const SwitchStyler.create(),
    required this.selected,
    this.label,
    this.semanticLabel,
    this.minimumTapTargetSize = Size.zero,
    this.onChanged,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  final HeroUiSwitchSize size;

  final bool invalid;

  final SwitchStyler style;

  final bool selected;

  final String? label;

  final String? semanticLabel;

  final Size minimumTapTargetSize;

  final ValueChanged<bool>? onChanged;

  final bool enabled;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final bool excludeSemantics;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext _) {
    return RemixSwitch(
      style: heroUiSwitchStyle(size: size, invalid: invalid, style: style),
      selected: selected,
      label: label,
      semanticLabel: semanticLabel,
      minimumTapTargetSize: minimumTapTargetSize,
      onChanged: onChanged,
      enabled: enabled,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      excludeSemantics: excludeSemantics,
      mouseCursor: mouseCursor,
    );
  }
}
