import 'package:flutter/widgets.dart';

import '../mixins/naked_mixins.dart';

/// A focus boundary with optional hover detection, actions, and shortcuts.
///
/// Always wraps [child] in [Focus]. Adds a [MouseRegion] when [onHoverChange]
/// is provided, and [Actions] and [Shortcuts] when their maps are non-empty
/// and [enabled] is true.
///
/// Disabling this widget suppresses hover callbacks and omits its actions and
/// shortcuts. It does not suppress [onFocusChange] or [onKeyEvent]. In
/// directional navigation mode, focus requests still follow [canRequestFocus].
class NakedFocusableDetector extends StatefulWidget {
  /// Creates an interaction detector around [child].
  const NakedFocusableDetector({
    super.key,
    required this.child,
    this.enabled = true,
    this.autofocus = false,
    this.canRequestFocus = true,
    this.descendantsAreFocusable = true,
    this.descendantsAreTraversable = true,
    this.skipTraversal = false,
    this.includeSemantics = true,
    this.onFocusChange,
    this.onHoverChange,
    this.onEnableChange,
    this.onKeyEvent,

    this.focusNode,
    this.mouseCursor,
    this.shortcuts,
    this.actions,
    this.debugLabel,
  });

  /// The widget to wrap with interaction detection.
  final Widget child;

  /// Whether this widget is enabled for interaction.
  final bool enabled;

  /// Whether to autofocus when first built.
  final bool autofocus;

  /// Whether this node can request focus.
  final bool canRequestFocus;

  /// Whether descendants can receive focus.
  final bool descendantsAreFocusable;

  /// Whether descendants participate in focus traversal.
  final bool descendantsAreTraversable;

  /// Whether focus traversal skips this widget's focus node.
  final bool skipTraversal;

  /// Whether to include focus semantics.
  final bool includeSemantics;

  /// Called when the focus state changes.
  final ValueChanged<bool>? onFocusChange;

  /// Called when the hover state changes while [enabled] is true.
  ///
  /// Providing this callback adds a [MouseRegion].
  final ValueChanged<bool>? onHoverChange;

  /// Called when the enabled state changes.
  final ValueChanged<bool>? onEnableChange;

  /// The handler for key events received by the focus node.
  final FocusOnKeyEventCallback? onKeyEvent;

  /// The externally managed focus node, if provided.
  final FocusNode? focusNode;

  /// The cursor shown by the optional hover region.
  ///
  /// Used only when [onHoverChange] is provided.
  final MouseCursor? mouseCursor;

  /// The keyboard shortcuts available while [enabled] is true.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// The intent actions available while [enabled] is true.
  final Map<Type, Action<Intent>>? actions;

  /// The debug label for the internally managed focus node.
  final String? debugLabel;

  @override
  State<NakedFocusableDetector> createState() => _NakedFocusableDetectorState();
}

class _NakedFocusableDetectorState extends State<NakedFocusableDetector>
    with FocusNodeMixin<NakedFocusableDetector> {
  bool _wasEnabled = true;

  @override
  FocusNode? get widgetProvidedNode => widget.focusNode;

  @override
  String get focusNodeDebugLabel =>
      widget.debugLabel ?? 'NakedFocusableDetector';

  @override
  void initState() {
    super.initState();
    _wasEnabled = widget.enabled;
  }

  void _handleEnabledChange() {
    if (widget.onEnableChange != null && widget.enabled != _wasEnabled) {
      widget.onEnableChange!(widget.enabled);
    }
    _wasEnabled = widget.enabled;
  }

  @override
  void didUpdateWidget(NakedFocusableDetector oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.enabled != oldWidget.enabled) {
      _handleEnabledChange();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navigationMode =
        MediaQuery.maybeNavigationModeOf(context) ?? NavigationMode.traditional;
    // Preserve directional focus navigation when interaction is disabled.
    final effectiveCanRequestFocus =
        navigationMode == NavigationMode.directional
        ? widget.canRequestFocus
        : widget.enabled && widget.canRequestFocus;

    Widget result = Focus(
      focusNode: effectiveFocusNode,
      autofocus: widget.autofocus,
      onFocusChange: widget.onFocusChange,
      onKeyEvent: widget.onKeyEvent,

      canRequestFocus: effectiveCanRequestFocus,
      skipTraversal: widget.skipTraversal,
      descendantsAreFocusable: widget.descendantsAreFocusable,
      descendantsAreTraversable: widget.descendantsAreTraversable,
      includeSemantics: widget.includeSemantics,
      child: widget.child,
    );

    // Keep the hover region and cursor when disabled, but suppress callbacks.
    if (widget.onHoverChange != null) {
      result = MouseRegion(
        onEnter: widget.enabled ? (_) => widget.onHoverChange!(true) : null,
        onExit: widget.enabled ? (_) => widget.onHoverChange!(false) : null,
        cursor: widget.mouseCursor ?? MouseCursor.defer,
        child: result,
      );
    }

    if (widget.enabled &&
        widget.actions != null &&
        widget.actions!.isNotEmpty) {
      result = Actions(actions: widget.actions!, child: result);
    }

    if (widget.enabled &&
        widget.shortcuts != null &&
        widget.shortcuts!.isNotEmpty) {
      result = Shortcuts(shortcuts: widget.shortcuts!, child: result);
    }

    return result;
  }
}
