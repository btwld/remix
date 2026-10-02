import 'package:flutter/widgets.dart';

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
/// 3. Focus and keys: the overlay is a focus scope that takes focus on open
///    and handles Escape, Arrow Up/Down, Home, and End.
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
class AnchoredOverlay extends StatelessWidget {
  /// Creates the overlay content for the [RawMenuAnchor] described by [info].
  const AnchoredOverlay({
    super.key,
    required this.info,
    this.positioning = const OverlayPositionConfig(),
    this.closeOnTapOutside = true,
    required this.child,
  });

  /// The info passed to [RawMenuAnchor.overlayBuilder].
  final RawMenuOverlayInfo info;

  /// Where [child] sits relative to [RawMenuOverlayInfo.anchorRect].
  final OverlayPositionConfig positioning;

  /// Whether a tap outside the menu's tap region closes the overlay.
  final bool closeOnTapOutside;

  /// The overlay panel.
  final Widget child;

  void _focusBoundary({required bool last}) {
    final current = FocusManager.instance.primaryFocus;
    if (current == null) return;
    final policy = FocusTraversalGroup.maybeOfNode(current);
    if (policy == null) return;
    final target = last
        ? policy.findLastFocus(current, ignoreCurrentFocus: true)
        : policy.findFirstFocus(current, ignoreCurrentFocus: true);
    target?.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final controller = MenuController.maybeOf(context);
    assert(controller != null, 'AnchoredOverlay requires a RawMenuAnchor.');
    void close() => controller?.close();

    return OverlayPositioner(
      targetRect: info.anchorRect,
      positioning: positioning,
      child: TapRegion(
        onTapOutside: closeOnTapOutside ? (_) => close() : null,
        groupId: info.tapRegionGroupId,
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
                  autofocus: true,
                  canRequestFocus: true,
                  skipTraversal: true,
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
