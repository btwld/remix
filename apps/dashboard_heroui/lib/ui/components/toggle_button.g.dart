// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_button.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixToggle].
///
/// Sizes are mobile-first, as in the CSS: heights step down at the `md`
/// breakpoint and icons at `sm`. [iconOnly] makes the button square, for a
/// toggle with an icon and no label.
///
/// The pressed scale shares the 100ms fill motion; upstream eases `transform`
/// over 250ms.
class UiToggleButton extends StatelessWidget {
  const UiToggleButton({
    super.key,
    this.variant = .defaultToggle,
    this.size = .md,
    this.iconOnly = false,
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

  /// The `default` fill.
  const UiToggleButton.defaultToggle({
    super.key,
    this.size = .md,
    this.iconOnly = false,
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
  }) : variant = UiToggleButtonVariant.defaultToggle;

  /// Transparent until hovered.
  const UiToggleButton.ghost({
    super.key,
    this.size = .md,
    this.iconOnly = false,
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
  }) : variant = UiToggleButtonVariant.ghost;

  final UiToggleButtonVariant variant;

  final UiToggleButtonSize size;

  final bool iconOnly;

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
      style: uiToggleButtonStyle(
        variant: variant,
        size: size,
        iconOnly: iconOnly,
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
