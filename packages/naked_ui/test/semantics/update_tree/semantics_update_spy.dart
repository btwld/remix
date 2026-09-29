import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';

/// A test binding that mirrors every semantics update the framework sends to
/// the platform and records nodes the platform could not place in its tree.
///
/// Platform accessibility bridges (for example the macOS `AXTree`) reject an
/// update that contains a node which is not reachable from the root through
/// `childrenInTraversalOrder`, and the macOS bridge can crash on a later
/// update. Widget tests never run that bridge, so this binding checks the
/// same invariant on the serialized updates, the way Flutter's own
/// `semantics_update_test.dart` observes them.
///
/// The binding must be the first binding created in the test isolate, so it
/// is installed by this directory's `flutter_test_config.dart`.
class SemanticsUpdateSpyBinding extends AutomatedTestWidgetsFlutterBinding {
  SemanticsUpdateSpyBinding();

  static SemanticsUpdateSpyBinding get instance =>
      TestWidgetsFlutterBinding.instance as SemanticsUpdateSpyBinding;

  final Map<int, List<int>> _tree = {};
  final List<String> _detachedNodes = [];

  /// Nodes sent in an update that were not reachable from the root node once
  /// that update was applied, described as `#id "label" in update N`.
  List<String> get detachedNodes => List.unmodifiable(_detachedNodes);

  int _updateCount = 0;

  /// Forgets the mirrored tree and every recorded detached node.
  void resetSemanticsUpdates() {
    _tree.clear();
    _detachedNodes.clear();
    _updateCount = 0;
  }

  void _applyUpdate(Map<int, _NodeUpdate> update) {
    _updateCount += 1;
    for (final MapEntry(:key, :value) in update.entries) {
      _tree[key] = value.childrenInTraversalOrder;
    }

    final reachable = <int>{};
    final pending = <int>[0];
    while (pending.isNotEmpty) {
      final id = pending.removeLast();
      if (!reachable.add(id)) continue;
      pending.addAll(_tree[id] ?? const <int>[]);
    }

    for (final MapEntry(:key, :value) in update.entries) {
      if (!reachable.contains(key)) {
        _detachedNodes.add('#$key "${value.label}" in update $_updateCount');
      }
    }
    _tree.removeWhere((id, _) => !reachable.contains(id));
  }

  @override
  ui.SemanticsUpdateBuilder createSemanticsUpdateBuilder() {
    return _SemanticsUpdateBuilderSpy(_applyUpdate);
  }
}

class _NodeUpdate {
  const _NodeUpdate(this.label, this.childrenInTraversalOrder);

  final String label;
  final List<int> childrenInTraversalOrder;
}

/// Records `updateNode` calls without depending on their full parameter list,
/// which grows between Flutter releases.
class _SemanticsUpdateBuilderSpy extends Fake
    implements ui.SemanticsUpdateBuilder {
  _SemanticsUpdateBuilderSpy(this._onBuild);

  final void Function(Map<int, _NodeUpdate> update) _onBuild;
  final Map<int, _NodeUpdate> _update = {};

  @override
  ui.SemanticsUpdate build() {
    _onBuild(_update);

    return ui.SemanticsUpdateBuilder().build();
  }

  @override
  Object? noSuchMethod(Invocation invocation) {
    if (invocation.memberName == #updateNode) {
      final arguments = invocation.namedArguments;
      _update[arguments[#id]! as int] = _NodeUpdate(
        arguments[#label]! as String,
        List.of(arguments[#childrenInTraversalOrder]! as List<int>),
      );

      return null;
    }
    if (invocation.memberName == #updateCustomAction) return null;

    return super.noSuchMethod(invocation);
  }
}
