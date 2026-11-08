import 'package:flutter/widgets.dart';

/// A [FocusNode] that counts the [requestFocus] calls it receives.
///
/// Asserting on [primaryFocus] alone cannot tell a deliberate focus restore
/// from focus that happened to land on the node, so tests compare
/// [requestCount] before and after a close.
class FocusRequestCounter extends FocusNode {
  /// Creates a counting focus node.
  FocusRequestCounter({super.debugLabel});

  /// How many times [requestFocus] has been called.
  int requestCount = 0;

  @override
  void requestFocus([FocusNode? node]) {
    requestCount++;
    super.requestFocus(node);
  }
}
