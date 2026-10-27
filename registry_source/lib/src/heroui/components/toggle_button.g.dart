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
/// A transparent ring-width border is always present so keyboard focus
/// recolors it without moving the label; upstream draws the ring outside,
/// which the toggle styler cannot. The pressed scale shares the 100ms fill
/// motion; upstream eases `transform` over 250ms.
class HeroUiToggleButton extends StatelessWidget {
  const HeroUiToggleButton({
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

  const HeroUiToggleButton.defaultToggle({
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
  }) : variant = HeroUiToggleButtonVariant.defaultToggle;

  const HeroUiToggleButton.ghost({
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
  }) : variant = HeroUiToggleButtonVariant.ghost;

  final HeroUiToggleButtonVariant variant;

  final HeroUiToggleButtonSize size;

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
  Widget build(BuildContext context) {
    return RemixToggle(
      key: this.key,
      style: heroUiToggleButtonStyle(
        variant: this.variant,
        size: this.size,
        iconOnly: this.iconOnly,
        style: this.style,
      ),
      selected: this.selected,
      onChanged: this.onChanged,
      enabled: this.enabled,
      label: this.label,
      icon: this.icon,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
      mouseCursor: this.mouseCursor,
    );
  }
}
