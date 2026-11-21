// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Toggle recipe.
///
/// It reads top to bottom: what every toggle shares, then the size, then the
/// variant's colors for rest, hover, press, on, focus and disabled.
///
/// [highContrast] moves the label and icon of the on state to accent step 12.
class FortalToggle extends StatelessWidget {
  const FortalToggle({
    super.key,
    this.variant = .ghost,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ToggleStyler.create(),
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.label,
    this.icon,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  });

  /// No fill or frame until hovered; an accent tint when on.
  const FortalToggle.ghost({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ToggleStyler.create(),
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.label,
    this.icon,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalToggleVariant.ghost;

  /// A 1px gray frame; an accent tint and frame when on.
  const FortalToggle.outline({
    super.key,
    this.size = .size2,
    this.highContrast = false,
    this.style = const ToggleStyler.create(),
    required this.selected,
    this.onChanged,
    this.enabled = true,
    this.label,
    this.icon,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.excludeSemantics = false,
    this.mouseCursor = SystemMouseCursors.click,
  }) : variant = FortalToggleVariant.outline;

  final FortalToggleVariant variant;

  final FortalToggleSize size;

  final bool highContrast;

  final ToggleStyler style;

  final bool selected;

  final ValueChanged<bool>? onChanged;

  final bool enabled;

  final String? label;

  final IconData? icon;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final String? semanticLabel;

  final bool excludeSemantics;

  final MouseCursor mouseCursor;

  @override
  Widget build(BuildContext _) {
    return RemixToggle(
      style: fortalToggleStyle(
        variant: variant,
        size: size,
        highContrast: highContrast,
        style: style,
      ),
      selected: selected,
      onChanged: onChanged,
      enabled: enabled,
      label: label,
      icon: icon,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      excludeSemantics: excludeSemantics,
      mouseCursor: mouseCursor,
    );
  }
}
