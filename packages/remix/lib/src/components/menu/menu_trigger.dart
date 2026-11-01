part of 'menu.dart';

/// Builds the control of a [RemixMenuTrigger.control] trigger.
typedef RemixMenuControlBuilder =
    Widget Function(BuildContext context, RemixMenuTriggerHandle menu);

/// Menu state and focus node passed to [RemixMenuTrigger.control].
final class RemixMenuTriggerHandle {
  const RemixMenuTriggerHandle._({
    required this.isOpen,
    required this.controller,
    required this.focusNode,
  });

  /// Whether the menu is open.
  final bool isOpen;

  /// The controller that opens and closes the menu.
  final MenuController controller;

  /// Pass this to the control so focus returns to it when the menu closes.
  /// Uses [RemixMenu.triggerFocusNode] when supplied; otherwise the menu
  /// owns the node.
  final FocusNode focusNode;

  /// Toggles the menu. Pass this to the control as its `onPressed`.
  void toggle() => controller.isOpen ? controller.close() : controller.open();
}

/// Configuration for a [RemixMenu] trigger.
///
/// This is a configuration object, not a widget. The same object is the trigger
/// for Fortal menus; there is no separate Fortal trigger type.
///
/// Use the unnamed constructor for the standard label/icon trigger. Use
/// [RemixMenuTrigger.builder] when the trigger needs richer visual content.
/// Builder output must be non-interactive visual content — not a nested
/// button. [NakedMenu] continues to own tapping, focus, keyboard behavior,
/// expanded semantics, and overlay state.
///
/// Use [RemixMenuTrigger.control] for a caller-owned button, such as a
/// styled [RemixButton]. The control owns its look, label, enabled state, and
/// activation; the menu keeps the overlay, Escape, outside taps, focus return,
/// and expanded semantics.
class RemixMenuTrigger {
  /// Creates a standard label/icon trigger.
  const RemixMenuTrigger({required String this.label, this.icon})
    : builder = null,
      control = null;

  /// Creates a trigger that supplies custom visual content.
  ///
  /// The builder receives the current [NakedMenuState] and the already styled
  /// default label/icon trigger as its child. It may wrap that child or
  /// replace it entirely. Returned content must not add a second interactive
  /// control.
  const RemixMenuTrigger.builder({
    required String this.label,
    this.icon,
    required this.builder,
  }) : control = null;

  /// Creates a trigger backed by a caller-owned button.
  ///
  /// Wire the button to the supplied focus node and toggle callback:
  ///
  /// ```dart
  /// RemixMenuTrigger.control(
  ///   builder: (context, menu) => RemixButton(
  ///     label: 'Actions',
  ///     focusNode: menu.focusNode,
  ///     onPressed: menu.toggle,
  ///   ),
  /// )
  /// ```
  ///
  /// Return one control: the menu merges its expanded state into that
  /// control's semantics. [MenuStyler.trigger] and [RemixMenu.semanticLabel]
  /// do not apply; the control owns its style and accessible name.
  const RemixMenuTrigger.control({required RemixMenuControlBuilder builder})
    : control = builder,
      label = null,
      icon = null,
      builder = null;

  /// The visible default label and the accessible fallback for a
  /// builder-backed trigger. Null for a [RemixMenuTrigger.control], which has
  /// its own label.
  final String? label;

  /// Optional icon shown before [label] in the default trigger.
  final IconData? icon;

  /// Optional custom trigger content. Null for the standard trigger.
  final ValueWidgetBuilder<NakedMenuState>? builder;

  /// The builder of the caller's own button. Null unless built with
  /// [RemixMenuTrigger.control].
  final RemixMenuControlBuilder? control;
}
