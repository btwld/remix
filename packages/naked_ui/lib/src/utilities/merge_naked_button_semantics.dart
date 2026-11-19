import 'package:flutter/widgets.dart';

/// Lets an enclosing trigger own the semantics of nested buttons and triggers.
class MergeNakedButtonSemantics extends InheritedWidget {
  /// Creates a merge scope for the trigger subtree.
  const MergeNakedButtonSemantics({required super.child, this.enabled = true});

  /// Whether descendants defer their boundary to the enclosing trigger.
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
