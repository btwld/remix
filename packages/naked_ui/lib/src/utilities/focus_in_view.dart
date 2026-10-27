import 'package:flutter/widgets.dart';

/// `keepVisibleAtEnd` only scrolls forward and `keepVisibleAtStart` only
/// backward, so running both reveals a target from either side, in either
/// reading direction, and leaves an already visible target where it is.
const _revealPolicies = [
  ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
  ScrollPositionAlignmentPolicy.keepVisibleAtStart,
];

/// Focuses [node] and scrolls every ancestor [Scrollable] just far enough to
/// show it, through the node's traversal policy.
void requestFocusInView(FocusNode node) {
  final requestFocus =
      FocusTraversalGroup.maybeOfNode(node)?.requestFocusCallback ??
      FocusTraversalPolicy.defaultTraversalRequestFocusCallback;
  for (final policy in _revealPolicies) {
    requestFocus(node, alignmentPolicy: policy);
  }
}

/// Scrolls every ancestor [Scrollable] of [context] just far enough to show
/// it, without moving focus.
void revealInView(BuildContext context) {
  for (final policy in _revealPolicies) {
    Scrollable.ensureVisible(context, alignmentPolicy: policy);
  }
}
