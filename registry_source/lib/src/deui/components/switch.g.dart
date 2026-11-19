// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixSwitch]: a 40 by 24 pill whose track is `muted` at
/// 60% off and `accent` on, with a 16px `background` thumb that presses in.
///
/// [invalid] colours the label `danger`. Remix keeps the keyboard, semantics
/// and selection; the thumb travel and its press are Remix's. [style] merges
/// last.
class DeuiSwitch extends StatelessWidget {
  const DeuiSwitch({
    super.key,
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
  Widget build(BuildContext context) {
    return RemixSwitch(
      key: this.key,
      style: deuiSwitchStyle(invalid: this.invalid, style: this.style),
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
