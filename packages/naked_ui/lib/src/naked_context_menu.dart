part of 'naked_menu.dart';

/// A headless menu that opens at a point on [child], its target.
///
/// The menu opens where the user asks for it:
///
/// - A secondary click (right click) opens it at the pointer.
/// - A long press with touch or a stylus opens it at the press.
/// - The ContextMenu key or Shift+F10, while the target or a descendant has
///   focus, opens it at the target's bottom-left corner.
/// - The semantics long-press action opens it there too, so screen readers
///   can reach it.
///
/// A secondary click or long press while the menu is open moves it to the new
/// point. A primary press on the target closes it, as does a tap outside,
/// Escape, or an item that closes on activation. The tap that closes the menu
/// is not consumed, so it reaches whatever is under it.
///
/// The target is a focus stop and a semantics container. Its descendants keep
/// their own semantics, focus, and gestures. The overlay is a focus scope
/// with the menu role and the same keyboard map as [NakedMenu]: Arrow Up and
/// Arrow Down move between items, Home and End jump to the ends, Escape
/// closes. When the menu closes, focus returns to the target unless the user
/// moved it elsewhere.
///
/// On the web, disable the browser's own context menu with
/// `BrowserContextMenu.disableContextMenu()`, or it opens over this one.
///
/// ```dart
/// NakedContextMenu<String>(
///   controller: controller,
///   overlayBuilder: (context, info) => Column(
///     mainAxisSize: MainAxisSize.min,
///     children: [
///       NakedMenu.Item(value: 'copy', child: const Text('Copy')),
///       NakedMenu.Item(value: 'delete', child: const Text('Delete')),
///     ],
///   ),
///   onSelected: (value) => debugPrint(value),
///   child: const SizedBox(width: 240, height: 160, child: Text('Photo')),
/// )
/// ```
///
/// See also:
/// - [NakedMenu], for a menu opened from a trigger button.
class NakedContextMenu<T> extends StatefulWidget {
  /// Creates a context menu for [child], managed by [controller].
  const NakedContextMenu({
    super.key,
    required this.child,
    required this.overlayBuilder,
    required this.controller,
    this.onSelected,
    this.onOpen,
    this.onClose,
    this.onCanceled,
    this.onOpenRequested,
    this.onCloseRequested,
    this.enabled = true,
    this.focusNode,
    this.useRootOverlay = false,
    this.positioning = const OverlayPositionConfig(),
    this.constrainToAvailableSpace = false,
  });

  /// The target: the region the menu belongs to.
  final Widget child;

  /// Builds the overlay panel. [RawMenuOverlayInfo.position] is the point the
  /// menu opened at, relative to the target's top-left corner.
  final RawMenuAnchorOverlayBuilder overlayBuilder;

  /// Opens and closes the menu. `open(position: offset)` opens it at `offset`
  /// from the target's top-left corner; without a position it opens against
  /// the whole target, like [NakedMenu].
  final MenuController controller;

  /// Called when an item is selected.
  final ValueChanged<T>? onSelected;

  /// Called when the menu opens, including when it moves to a new point.
  final VoidCallback? onOpen;

  /// Called when the menu closes, including before it moves to a new point.
  final VoidCallback? onClose;

  /// Called when the menu closes without a selection.
  final VoidCallback? onCanceled;

  /// Intercepts open requests, for example to drive a transition. The
  /// position is the requested point; call `showOverlay` to open there.
  final RawMenuAnchorOpenRequestedCallback? onOpenRequested;

  /// Intercepts close requests so callers can coordinate custom transitions.
  final RawMenuAnchorCloseRequestedCallback? onCloseRequested;

  /// Whether the target opens the menu.
  ///
  /// When false, no gesture, key, or semantics action opens it, the target is
  /// not a focus stop, and an open menu closes. [child] stays interactive.
  final bool enabled;

  /// The target's focus node. Focus returns here when the menu closes.
  final FocusNode? focusNode;

  /// Whether to target the root overlay instead of the nearest ancestor.
  final bool useRootOverlay;

  /// Where the panel sits relative to the point it opens at.
  ///
  /// The point is a zero-size rect, so the default places the panel's
  /// top-left corner at the point and flips or shifts it to stay on screen.
  final OverlayPositionConfig positioning;

  /// Whether to lay the panel out within the space it can use. See
  /// [NakedMenu.constrainToAvailableSpace].
  final bool constrainToAvailableSpace;

  @override
  State<NakedContextMenu<T>> createState() => _NakedContextMenuState<T>();
}

class _NakedContextMenuState<T> extends State<NakedContextMenu<T>>
    with
        OverlayStateMixin<NakedContextMenu<T>>,
        FocusNodeMixin<NakedContextMenu<T>> {
  static const _touchDevices = {
    PointerDeviceKind.touch,
    PointerDeviceKind.stylus,
    PointerDeviceKind.invertedStylus,
  };

  @override
  FocusNode? get widgetProvidedNode => widget.focusNode;

  @override
  void didUpdateWidget(covariant NakedContextMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.enabled && widget.controller.isOpen) {
      widget.controller.close();
    }
  }

  void _openAt(Offset position) => widget.controller.open(position: position);

  void _openFromKeyboard() {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.hasSize) return;
    _openAt(Offset(0, box.size.height));
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (event.buttons == kPrimaryButton && widget.controller.isOpen) {
      widget.controller.close();
    }
  }

  void _handleOpen() {
    handleOpen(widget.onOpen);
    if (mounted) setState(() {});
  }

  void _handleClose() {
    handleClose(
      onClose: widget.onClose,
      onCanceled: widget.onCanceled,
      triggerFocusNode: effectiveFocusNode,
    );
    if (mounted) setState(() {});
  }

  void _handleSelection(T value) {
    markSelectionMade();
    widget.onSelected?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;
    // Opaque: the whole target opens the menu, including its empty areas.
    final target = Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: _handlePointerDown,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        excludeFromSemantics: true,
        onSecondaryTapUp: enabled
            ? (details) => _openAt(details.localPosition)
            : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          supportedDevices: _touchDevices,
          excludeFromSemantics: true,
          onLongPressStart: enabled
              ? (details) => _openAt(details.localPosition)
              : null,
          child: widget.child,
        ),
      ),
    );

    return RawMenuAnchor(
      controller: widget.controller,
      childFocusNode: effectiveFocusNode,
      consumeOutsideTaps: false,
      onOpen: _handleOpen,
      onClose: _handleClose,
      onOpenRequested:
          widget.onOpenRequested ?? (_, showOverlay) => showOverlay(),
      onCloseRequested: (hideOverlay) => handleCloseRequested(
        controller: widget.controller,
        onCloseRequested: widget.onCloseRequested,
        hideOverlay: hideOverlay,
      ),
      useRootOverlay: widget.useRootOverlay,
      overlayBuilder: (context, info) => AnchoredOverlay(
        info: info,
        useRootOverlay: widget.useRootOverlay,
        positioning: widget.positioning,
        constrainToAvailableSpace: widget.constrainToAvailableSpace,
        child: KeyedSubtree(
          key: overlayContentKey,
          child: _menuPanel<T>(
            onSelected: _handleSelection,
            controller: widget.controller,
            rootController: widget.controller,
            child: Builder(
              builder: (context) => widget.overlayBuilder(context, info),
            ),
          ),
        ),
      ),
      child: Semantics(
        container: true,
        onLongPress: enabled ? _openFromKeyboard : null,
        child: CallbackShortcuts(
          bindings: enabled
              ? {
                  const SingleActivator(LogicalKeyboardKey.contextMenu):
                      _openFromKeyboard,
                  const SingleActivator(LogicalKeyboardKey.f10, shift: true):
                      _openFromKeyboard,
                }
              : const {},
          child: Focus(
            focusNode: effectiveFocusNode,
            canRequestFocus: enabled,
            skipTraversal: !enabled,
            child: target,
          ),
        ),
      ),
    );
  }
}
