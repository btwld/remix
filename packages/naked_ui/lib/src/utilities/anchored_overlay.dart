import 'package:flutter/widgets.dart';

import 'focus_in_view.dart';
import 'intents.dart';
import 'positioning.dart';

/// The overlay half of a [RawMenuAnchor]: return it from
/// [RawMenuAnchor.overlayBuilder].
///
/// [RawMenuAnchor] owns the overlay entry, the [MenuController], the anchor
/// rect, and closing on ancestor scroll or view resize. It leaves three things
/// to the overlay, and this widget adds exactly those around [child]:
///
/// 1. Placement: [OverlayPositioner] puts [child] next to the anchor.
/// 2. Outside taps: a [TapRegion] in the menu's group closes the overlay.
/// 3. Focus and keys: the overlay is a focus scope that takes focus on open,
///    on its container unless [initialFocusNode] asks for an item, and
///    handles Escape, Arrow Up/Down, Home, and End.
///
/// Escape and outside taps close the nearest [MenuController], so they reach
/// [RawMenuAnchor.onCloseRequested] like the closes [RawMenuAnchor] starts
/// itself. [RawMenuAnchor] binds Escape around the anchor only, and that
/// binding closes the whole menu tree; Escape here closes one level.
///
/// ```dart
/// RawMenuAnchor(
///   controller: controller,
///   overlayBuilder: (context, info) => AnchoredOverlay(
///     info: info,
///     child: panel,
///   ),
///   child: trigger,
/// )
/// ```
class AnchoredOverlay extends StatefulWidget {
  /// Creates the overlay content for the [RawMenuAnchor] described by [info].
  const AnchoredOverlay({
    super.key,
    required this.info,
    this.positioning = const OverlayPositionConfig(),
    this.constrainToAvailableHeight = false,
    this.closeOnTapOutside = true,
    this.initialFocusNode,
    required this.child,
  });

  /// The info passed to [RawMenuAnchor.overlayBuilder].
  final RawMenuOverlayInfo info;

  /// Where [child] sits relative to [RawMenuOverlayInfo.anchorRect].
  final OverlayPositionConfig positioning;

  /// Whether to cap [child]'s height at the space beside the anchor.
  ///
  /// See [OverlayPositioner.constrainToAvailableHeight].
  final bool constrainToAvailableHeight;

  /// Whether a tap outside the menu's tap region closes the overlay.
  final bool closeOnTapOutside;

  /// The item that takes focus once the overlay is built, in place of the
  /// container.
  ///
  /// When this node is not attached to an item or cannot take focus, the first
  /// item that can take focus does. The item is revealed in every ancestor
  /// [Scrollable]. Focus stays put when something inside the overlay already
  /// holds it, and on the container when no item can take it.
  final FocusNode? initialFocusNode;

  /// The overlay panel.
  final Widget child;

  /// Moves focus back to the nearest [AnchoredOverlay] container if focus is
  /// currently on a descendant item within the same overlay [FocusScope].
  static void clearItemFocus(BuildContext context) {
    final containerNode = context
        .getInheritedWidgetOfExactType<_AnchoredOverlayScope>()
        ?.containerFocusNode;
    if (containerNode == null || containerNode.hasPrimaryFocus) return;
    final scope = containerNode.enclosingScope;
    if (scope != null && scope.hasFocus) {
      containerNode.requestFocus();
    }
  }

  /// Requests focus on the nearest [AnchoredOverlay] container node.
  static void focusContainer(BuildContext context) {
    final containerNode = context
        .getInheritedWidgetOfExactType<_AnchoredOverlayScope>()
        ?.containerFocusNode;
    containerNode?.requestFocus();
  }

  @override
  State<AnchoredOverlay> createState() => _AnchoredOverlayState();
}

class _AnchoredOverlayScope extends InheritedWidget {
  const _AnchoredOverlayScope({
    required this.containerFocusNode,
    required super.child,
  });

  final FocusNode containerFocusNode;

  @override
  bool updateShouldNotify(_AnchoredOverlayScope oldWidget) =>
      containerFocusNode != oldWidget.containerFocusNode;
}

class _AnchoredOverlayState extends State<AnchoredOverlay> {
  final FocusNode _containerFocusNode = FocusNode(
    debugLabel: 'AnchoredOverlay container',
    skipTraversal: true,
  );

  @override
  void initState() {
    super.initState();
    if (widget.initialFocusNode != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusInitial());
    }
  }

  @override
  void dispose() {
    _containerFocusNode.dispose();
    super.dispose();
  }

  FocusNode? _findBoundary(FocusNode from, {required bool last}) {
    final policy = FocusTraversalGroup.maybeOfNode(from);
    if (policy == null) return null;
    return last
        ? policy.findLastFocus(from, ignoreCurrentFocus: true)
        : policy.findFirstFocus(from, ignoreCurrentFocus: true);
  }

  void _focusInitial() {
    if (!mounted) return;
    final focused = _containerFocusNode.enclosingScope?.focusedChild;
    if (focused != null && focused != _containerFocusNode) return;
    final item = widget.initialFocusNode!;
    final target = item.context?.mounted == true && item.canRequestFocus
        ? item
        : _findBoundary(_containerFocusNode, last: false);
    if (target != null) requestFocusInView(target);
  }

  void _focusBoundary({required bool last}) {
    final current = FocusManager.instance.primaryFocus;
    if (current == null) return;
    final target = _findBoundary(current, last: last);
    if (target != null) requestFocusInView(target);
  }

  @override
  Widget build(BuildContext context) {
    final controller = MenuController.maybeOf(context);
    assert(controller != null, 'AnchoredOverlay requires a RawMenuAnchor.');
    void close() => controller?.close();

    return OverlayPositioner(
      targetRect: widget.info.anchorRect,
      positioning: widget.positioning,
      constrainToAvailableHeight: widget.constrainToAvailableHeight,
      child: TapRegion(
        onTapOutside: widget.closeOnTapOutside ? (_) => close() : null,
        groupId: widget.info.tapRegionGroupId,
        child: FocusScope(
          child: FocusTraversalGroup(
            child: Shortcuts(
              shortcuts: NakedIntentActions.menu.shortcuts,
              child: Actions(
                actions: NakedIntentActions.menu.actions(
                  onDismiss: close,
                  onFirstFocus: () => _focusBoundary(last: false),
                  onLastFocus: () => _focusBoundary(last: true),
                ),
                child: Focus(
                  focusNode: _containerFocusNode,
                  autofocus: true,
                  canRequestFocus: true,
                  skipTraversal: true,
                  includeSemantics: false,
                  child: _AnchoredOverlayScope(
                    containerFocusNode: _containerFocusNode,
                    child: widget.child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
