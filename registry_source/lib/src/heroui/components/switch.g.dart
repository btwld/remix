// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixSwitch], the bare control.
///
/// Labels and descriptions are the app's composition; see `HeroUiSwitchGroup`.
class HeroUiSwitch extends StatelessWidget {
  const HeroUiSwitch({
    super.key,
    this.size = .md,
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
      style: heroUiSwitchStyle(size: this.size, style: this.style),
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
