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
class PlaygroundToggle extends StatelessWidget {
  const PlaygroundToggle({
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
  const PlaygroundToggle.ghost({
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
  }) : variant = PlaygroundToggleVariant.ghost;

  /// An `input` outline, so the control is visible while off.
  const PlaygroundToggle.outline({
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
  }) : variant = PlaygroundToggleVariant.outline;

  final PlaygroundToggleVariant variant;

  final PlaygroundToggleSize size;

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
      style: playgroundToggleStyle(
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
