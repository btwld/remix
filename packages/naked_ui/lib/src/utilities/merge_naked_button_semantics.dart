import 'package:flutter/widgets.dart';

/// Allows a composite trigger to own the semantics of its buttons.
class MergeNakedButtonSemantics extends InheritedWidget {
  /// Creates a merge scope for the trigger subtree.
  const MergeNakedButtonSemantics({required super.child, this.enabled = true});

  /// Whether descendant buttons defer their boundary to the trigger.
  final bool enabled;

  /// Whether the nearest trigger scope requests merging.
  static bool isRequested(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<MergeNakedButtonSemantics>()
          ?.enabled ??
      false;

  @override
  bool updateShouldNotify(MergeNakedButtonSemantics oldWidget) =>
      enabled != oldWidget.enabled;
}
