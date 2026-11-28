part of 'menu.dart';

/// A styled menu that opens at a point on [child], its target.
///
/// A secondary click opens it at the pointer, a touch long press at the
/// press, and the ContextMenu key or Shift+F10 at the target's bottom-left
/// corner. [NakedContextMenu] owns those inputs, focus, and semantics.
///
/// The panel and rows are [RemixMenu]'s: [items] takes the same entries and
/// [style] the same [MenuStyler]. The trigger styles do not apply. A
/// [MenuStyler.panelTransition] receives the open point as
/// [RemixPanelTransitionInfo.openPosition], and replays when the menu moves
/// to a new point.
///
/// ```dart
/// RemixContextMenu<String>(
///   items: [
///     RemixMenuItem(value: 'copy', label: 'Copy'),
///     RemixMenuItem(value: 'delete', label: 'Delete'),
///   ],
///   onSelected: (value) => debugPrint(value),
///   child: const SizedBox(width: 240, height: 160, child: Text('Photo')),
/// )
/// ```
class RemixContextMenu<T> extends StatefulWidget {
  const RemixContextMenu({
    super.key,
    required this.child,
    required this.items,
    this.controller,
    this.onSelected,
    this.onOpen,
    this.onClose,
    this.onCanceled,
    this.onOpenRequested,
    this.onCloseRequested,
    this.enabled = true,
    this.focusNode,
    this.useRootOverlay = false,
    this.positioning,
    this.style = const MenuStyler.create(),
    this.styleSpec,
  });

  /// The target: the region the menu belongs to.
  final Widget child;

  /// The declarative ordinary, compound, submenu, section, and divider data.
  final List<RemixMenuItemData<T>> items;

  /// Optional controller. `open(position: offset)` opens the menu at
  /// `offset` from the target's top-left corner. Without one the menu owns
  /// a controller.
  final MenuController? controller;

  /// Called when an item is selected.
  final ValueChanged<T>? onSelected;

  /// Called when the menu opens, including when it moves to a new point.
  final VoidCallback? onOpen;

  /// Called when the menu closes, including before it moves to a new point.
  final VoidCallback? onClose;

  /// Called when the menu closes without a selection.
  final VoidCallback? onCanceled;

  /// Intercepts open requests. See [RemixMenu.onOpenRequested].
  final RawMenuAnchorOpenRequestedCallback? onOpenRequested;

  /// Intercepts close requests. See [RemixMenu.onOpenRequested].
  final RawMenuAnchorCloseRequestedCallback? onCloseRequested;

  /// Whether the target opens the menu. See [NakedContextMenu.enabled].
  final bool enabled;

  /// The target's focus node. Focus returns here when the menu closes.
  final FocusNode? focusNode;

  /// Whether to target the root overlay instead of the nearest ancestor.
  final bool useRootOverlay;

  /// Where the panel sits relative to the open point.
  ///
  /// When null, the style's [MenuSpec.positioning] applies, and without one
  /// the panel's top-left corner sits at the point.
  final OverlayPositionConfig? positioning;

  /// The style configuration for the panel and rows.
  final MenuStyler style;

  /// Optional raw style spec that bypasses fluent style resolution.
  final MenuSpec? styleSpec;

  @override
  State<RemixContextMenu<T>> createState() => _RemixContextMenuState<T>();
}

class _RemixContextMenuState<T> extends State<RemixContextMenu<T>>
    with SingleTickerProviderStateMixin {
  final _internalController = MenuController();
  late final _panelTransition = RemixPanelTransitionHandle(vsync: this);

  MenuController get _controller => widget.controller ?? _internalController;

  @override
  void dispose() {
    _panelTransition.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = MenuStyler().overlay(_menuPanelBaseStyle).merge(widget.style);

    return _panelTransition.wrapAnchor(
      NakedContextMenu<T>(
        controller: _controller,
        overlayBuilder: (context, info) => _RemixMenuPanel<T>(
          info: info,
          style: style,
          styleSpec: widget.styleSpec,
          transition: _panelTransition,
          items: widget.items,
          hasRootSelectionCallback: widget.onSelected != null,
        ),
        onSelected: widget.onSelected,
        onOpen: widget.onOpen,
        onClose: widget.onClose,
        onCanceled: widget.onCanceled,
        onOpenRequested: (position, showOverlay) =>
            _panelTransition.openRequested(
              position,
              showOverlay,
              widget.onOpenRequested,
              isOpen: () => _controller.isOpen,
              replayOnMove: true,
            ),
        onCloseRequested: (hideOverlay) => _panelTransition.closeRequested(
          hideOverlay,
          widget.onCloseRequested,
        ),
        enabled: widget.enabled,
        focusNode: widget.focusNode,
        useRootOverlay: widget.useRootOverlay,
        positioning:
            widget.positioning ??
            _styledMenuPositioning(context, style, widget.styleSpec) ??
            const OverlayPositionConfig(),
        constrainToAvailableSpace: true,
        child: widget.child,
      ),
    );
  }
}
