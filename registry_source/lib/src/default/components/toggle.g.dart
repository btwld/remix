// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Toggle recipe.
///
/// A toggle is a button that stays pressed. Remix owns the rendering, the
/// pointer and keyboard behavior, and the on/off semantics; this recipe owns
/// the geometry and the off/hover/on/focus/disabled fragments.
///
/// A toggle that is on sits on `accent` in `accentForeground`; a ghost toggle
/// under the pointer sits on `muted` in `mutedForeground`. In the shipped
/// themes the two surfaces are the same gray, so "on" is told from "pointed at"
/// by its full-strength content, and a toggle that is on stays on when hovered.
/// An outline toggle hovers onto `accent` instead, and keeps its outline in
/// every state.
///
/// [style] is merged **last**, so a single call site can override any part of
/// the resolved recipe without forking it. Because [variant] is a non-nullable
/// enum, the generator also emits one named constructor per enum value.
///
/// State fragments merge by state, not by depth: an override that must beat
/// the recipe's on fill has to be declared as a selected fragment too
/// (`ToggleStyler().onSelected(...)`).
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
  Widget build(BuildContext context) {
    return RemixToggle(
      key: this.key,
      style: vanillaToggleStyle(
        variant: this.variant,
        size: this.size,
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
