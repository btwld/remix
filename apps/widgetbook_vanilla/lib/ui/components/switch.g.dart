// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Switch recipe.
///
/// Remix owns the rendering, the toggle behavior, the switch accessibility
/// role, and — importantly — the thumb's travel: it aligns the thumb to the
/// leading edge when off and the trailing edge when on. This recipe supplies
/// only the two boxes' geometry and their colors.
///
/// A switch takes a `label`, drawn beside the track inside the switch's own
/// tap, focus, and semantics target, as a form label: `textSm` at medium
/// weight, 8px from the track. A switch without one needs a `semanticLabel`.
class VanillaSwitch extends StatelessWidget {
  const VanillaSwitch({
    super.key,
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
  Widget build(BuildContext context) {
    return RemixSwitch(
      key: this.key,
      style: vanillaSwitchStyle(style: this.style),
      selected: this.selected,
      label: this.label,
      semanticLabel: this.semanticLabel,
      minimumTapTargetSize: this.minimumTapTargetSize,
      onChanged: this.onChanged,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      excludeSemantics: this.excludeSemantics,
      mouseCursor: this.mouseCursor,
    );
  }
}
