import 'package:flutter/widgets.dart';

/// Focuses [node] and scrolls every ancestor [Scrollable] just far enough to
/// show it, through the node's traversal policy.
///
/// `keepVisibleAtEnd` only scrolls forward and `keepVisibleAtStart` only
/// backward, so running both reveals the node from either side, in either
/// reading direction, and leaves an already visible node where it is.
void requestFocusInView(FocusNode node) {
  final requestFocus =
      FocusTraversalGroup.maybeOfNode(node)?.requestFocusCallback ??
      FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
  requestFocus(
    node,
    alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
  );
  requestFocus(
    node,
    alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtStart,
  );
}
