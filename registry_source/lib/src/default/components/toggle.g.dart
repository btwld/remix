// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Toggle recipe.
///
/// A button that stays pressed. Remix owns the on/off semantics. A toggle that
/// is on sits on `accent` in `accentForeground`; a ghost toggle under the
/// pointer sits on `muted`. In the shipped themes those are the same gray, so
/// "on" is told from "pointed at" by its full-strength content, and a toggle
/// that is on stays on under the pointer. An outline toggle hovers onto `accent`
/// and keeps its outline in every state.
class VanillaToggle extends StatelessWidget {
  const VanillaToggle({
    super.key,
    this.variant = .ghost,
    this.size = .medium,
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

  /// No fill and no border until the toggle is hovered or on.
  const VanillaToggle.ghost({
    super.key,
    this.size = .medium,
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
  }) : variant = VanillaToggleVariant.ghost;

  /// An `input` outline, so the control is visible while off.
  const VanillaToggle.outline({
    super.key,
    this.size = .medium,
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
  }) : variant = VanillaToggleVariant.outline;

  final VanillaToggleVariant variant;

  final VanillaToggleSize size;

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
      style: vanillaToggleStyle(variant: variant, size: size, style: style),
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
