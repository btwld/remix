import 'dart:math' as math;

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
    this.constrainToAvailableSpace = false,
    this.closeOnTapOutside = true,
    this.initialFocusNode,
    this.avoidViewInsets = false,
    this.useRootOverlay = false,
    required this.child,
  });

  /// The info passed to [RawMenuAnchor.overlayBuilder].
  final RawMenuOverlayInfo info;

  /// Where [child] sits relative to [RawMenuOverlayInfo.anchorRect].
  final OverlayPositionConfig positioning;

  /// Whether to fit [child] into the space its placement can use. Top and
  /// bottom placements cap height beside the trigger; collision avoidance
  /// also caps width inside the padded overlay. Content must handle scrolling.
  ///
  /// See [OverlayPositioner.constrainToAvailableSpace].
  final bool constrainToAvailableSpace;

  /// Whether a tap outside the menu's tap region closes the overlay.
  final bool closeOnTapOutside;

  /// The item that takes focus once the overlay is built, in place of the
  /// container.
  ///
  /// When this node is not attached to an item or cannot take focus, the first
  /// item that can take focus does. The item is revealed in the scrollables
  /// that contain it. Focus stays put when something inside the overlay already
  /// holds it, and on the container when no item can take it.
  final FocusNode? initialFocusNode;

  /// Avoids the target view's safe area and keyboard exclusions on both axes.
  /// Fixed-size content larger than the cap overflows unless it adapts or
  /// scrolls. The open panel re-fits when these insets change. Nested anchored
  /// overlays inherit this preference from the open panel.
  final bool avoidViewInsets;

  /// Whether the anchor renders its panel in the root Overlay.
  final bool useRootOverlay;

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
    required this.avoidViewInsets,
    required super.child,
  });

  final FocusNode containerFocusNode;
  final bool avoidViewInsets;

  @override
  bool updateShouldNotify(_AnchoredOverlayScope oldWidget) =>
      containerFocusNode != oldWidget.containerFocusNode ||
      avoidViewInsets != oldWidget.avoidViewInsets;
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

  OverlayPositionConfig _positioning(
    BuildContext context,
    bool avoidViewInsets,
  ) {
    final config = widget.positioning;
    if (!avoidViewInsets) return config;
    // RawMenuAnchor inherits the outermost anchor's flag, stopping at a
    // RawMenuAnchorGroup. Follow that logical ancestry, not paint ancestry:
    // an OverlayPortal can paint in a different Overlay from its widget tree.
    var useRootOverlay = widget.useRootOverlay;
    context.visitAncestorElements((element) {
      final ancestor = element.widget;
      if (ancestor is RawMenuAnchorGroup) return false;
      if (ancestor is RawMenuAnchor) useRootOverlay = ancestor.useRootOverlay;
      return true;
    });
    // In nearest-overlay mode an intermediary Overlay changes the target.
    final overlayState = Overlay.maybeOf(context, rootOverlay: useRootOverlay);
    final overlay = overlayState?.context.findRenderObject();
    // The anchor can be inside SafeArea, whose MediaQuery has consumed padding.
    // The panel is placed in Overlay coordinates, so use that Overlay's media.
    final mediaElement = overlayState?.context
        .getElementForInheritedWidgetOfExactType<MediaQuery>();
    // Listen from this panel, not the Overlay context: SafeArea can consume
    // an inset update without otherwise rebuilding the open panel.
    final media = mediaElement == null
        ? null
        : (context.dependOnInheritedElement(mediaElement) as MediaQuery).data;
    if (media == null || overlay is! RenderBox) return config;
    // Keyboard and safe areas overlap, rather than occupying adjacent bands.
    final left = math.max(media.viewPadding.left, media.viewInsets.left);
    final top = math.max(media.viewPadding.top, media.viewInsets.top);
    final right = math.max(media.viewPadding.right, media.viewInsets.right);
    final bottom = math.max(media.viewPadding.bottom, media.viewInsets.bottom);
    // Use Flutter's coordinate conversion so scaled nested overlays receive
    // exclusions in their own logical pixels, not untranslated view distances.
    final safeBounds = Rect.fromPoints(
      overlay.globalToLocal(Offset(left, top)),
      overlay.globalToLocal(
        Offset(media.size.width - right, media.size.height - bottom),
      ),
    );
    return OverlayPositionConfig(
      side: config.side,
      alignment: config.alignment,
      sideOffset: config.sideOffset,
      alignmentOffset: config.alignmentOffset,
      avoidCollisions: config.avoidCollisions,
      minimumAvailableHeight: config.minimumAvailableHeight,
      collisionPadding:
          config.collisionPadding +
          EdgeInsets.fromLTRB(
            math.max(0, safeBounds.left),
            math.max(0, safeBounds.top),
            math.max(0, widget.info.overlaySize.width - safeBounds.right),
            math.max(0, widget.info.overlaySize.height - safeBounds.bottom),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = MenuController.maybeOf(context);
    assert(controller != null, 'AnchoredOverlay requires a RawMenuAnchor.');
    void close() => controller?.close();

    final avoidViewInsets =
        widget.avoidViewInsets ||
        (context
                .dependOnInheritedWidgetOfExactType<_AnchoredOverlayScope>()
                ?.avoidViewInsets ??
            false);
    final positioning = _positioning(context, avoidViewInsets);
    // View safety caps both axes even for lateral placement. Keep the legacy
    // unconstrained Popover and lateral-height defaults when this is not opted
    // in; the ordinary positioner still chooses the side and collision shift.
    final panel = avoidViewInsets
        ? ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: math.max(
                0,
                widget.info.overlaySize.width -
                    positioning.collisionPadding.horizontal,
              ),
              maxHeight: math.max(
                0,
                widget.info.overlaySize.height -
                    positioning.collisionPadding.vertical,
              ),
            ),
            child: widget.child,
          )
        : widget.child;
    return OverlayPositioner(
      targetRect: widget.info.anchorRect,
      positioning: positioning,
      constrainToAvailableSpace: widget.constrainToAvailableSpace,
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
                    avoidViewInsets: avoidViewInsets,
                    child: panel,
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
