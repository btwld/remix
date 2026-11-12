// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'switch.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Switch recipe.
///
/// It reads top to bottom: the track, thumb and focus ring, then the variant's
/// colors for on, pressed and disabled, then the touch target.
///
/// [highContrast] moves the on state to accent step 12.
class FortalSwitch extends StatelessWidget {
  const FortalSwitch({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.highContrast = false,
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

  /// A neutral track with a 1px frame, filled with the accent when on.
  const FortalSwitch.surface({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = FortalSwitchVariant.surface;

  /// A neutral tint, accent-tinted when on, with no frame.
  const FortalSwitch.soft({
    super.key,
    this.size = .size2,
    this.highContrast = false,
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
  }) : variant = FortalSwitchVariant.soft;

  final FortalSwitchVariant variant;

  final FortalSwitchSize size;

  final bool highContrast;

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
      style: fortalSwitchStyle(
        variant: this.variant,
        size: this.size,
        highContrast: this.highContrast,
        style: this.style,
      ),
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
