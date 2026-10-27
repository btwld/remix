import 'package:flutter/widgets.dart';

/// Focuses [node], then scrolls the scrollables that contain it just far
/// enough to show it with [revealInView].
void requestFocusInView(FocusNode node) {
  node.requestFocus();
  final context = node.context;
  if (context != null && context.mounted) revealInView(context);
}

/// Scrolls the [Scrollable]s that contain [context]'s render object just far
/// enough to show it, leaving it where it is when it is already visible.
///
/// `keepVisibleAtEnd` only scrolls forward and `keepVisibleAtStart` only
/// backward, so running both reveals the object from either side and in either
/// reading direction.
///
/// A [Scrollable] is found through the widget tree, but its position picks the
/// viewport through the render tree. Overlay content is built under its
/// anchor's scrollables yet rendered in the [Overlay], so a scrollable that
/// does not render the object ends the walk.
void revealInView(BuildContext context) {
  final target = context.findRenderObject();
  if (target == null || !target.attached) return;

  var revealed = target;
  var scrollable = Scrollable.maybeOf(context);
  while (scrollable != null && _renders(scrollable, target)) {
    scrollable.position.ensureVisible(
      revealed,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
      targetRenderObject: target,
    );
    scrollable.position.ensureVisible(
      revealed,
      alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
      targetRenderObject: target,
    );
    revealed = scrollable.context.findRenderObject()!;
    scrollable = Scrollable.maybeOf(scrollable.context);
  }
}

bool _renders(ScrollableState scrollable, RenderObject object) {
  final viewport = scrollable.context.findRenderObject();
  for (RenderObject? node = object.parent; node != null; node = node.parent) {
    if (identical(node, viewport)) return true;
  }
  return false;
}
