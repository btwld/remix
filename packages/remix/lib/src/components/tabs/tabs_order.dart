part of 'tabs.dart';

/// Where the tabs of one [RemixTabs] sit, so a tab view can tell which way
/// the selection moved.
final class _TabOrder {
  final Map<String, RenderBox> _tabs = {};
  String? _selectedTabId;
  int _direction = 0;

  /// The physical direction along [axis] from the previously selected tab to
  /// [selectedTabId]: 1, -1, or 0 when either tab is not laid out.
  ///
  /// Every view asks during the build that follows a selection change, so the
  /// first ask computes the direction and the rest reuse it.
  int directionTo(String selectedTabId, Axis axis) {
    if (selectedTabId == _selectedTabId) return _direction;
    final from = _tabs[_selectedTabId];
    final to = _tabs[selectedTabId];
    _selectedTabId = selectedTabId;
    _direction = 0;
    if (from == null || to == null || !from.hasSize || !to.hasSize) return 0;
    final delta =
        to.localToGlobal(Offset.zero) - from.localToGlobal(Offset.zero);
    _direction = switch (axis) {
      Axis.horizontal => delta.dx.sign.toInt(),
      Axis.vertical => delta.dy.sign.toInt(),
    };

    return _direction;
  }
}

final class _TabOrderHost extends StatefulWidget {
  const _TabOrderHost({required this.child});

  final Widget child;

  @override
  State<_TabOrderHost> createState() => _TabOrderHostState();
}

final class _TabOrderHostState extends State<_TabOrderHost> {
  final _order = _TabOrder();

  @override
  Widget build(BuildContext context) =>
      _TabOrderScope(order: _order, child: widget.child);
}

final class _TabOrderScope extends InheritedWidget {
  const _TabOrderScope({required this.order, required super.child});

  final _TabOrder order;

  static _TabOrder? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TabOrderScope>()?.order;

  @override
  bool updateShouldNotify(_TabOrderScope oldWidget) => order != oldWidget.order;
}

/// Records one tab's render box in its [_TabOrder] while it is attached.
final class _TabOrderAnchor extends SingleChildRenderObjectWidget {
  const _TabOrderAnchor({
    required this.order,
    required this.tabId,
    required super.child,
  });

  final _TabOrder order;
  final String tabId;

  @override
  _RenderTabOrderAnchor createRenderObject(BuildContext context) =>
      _RenderTabOrderAnchor(order, tabId);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTabOrderAnchor renderObject,
  ) {
    renderObject.update(order, tabId);
  }
}

final class _RenderTabOrderAnchor extends RenderProxyBox {
  _RenderTabOrderAnchor(this._order, this._tabId);

  _TabOrder _order;
  String _tabId;

  void update(_TabOrder order, String tabId) {
    if (_order == order && _tabId == tabId) return;
    if (attached) _unregister();
    _order = order;
    _tabId = tabId;
    if (attached) _order._tabs[_tabId] = this;
  }

  void _unregister() {
    if (_order._tabs[_tabId] == this) _order._tabs.remove(_tabId);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _order._tabs[_tabId] = this;
  }

  @override
  void detach() {
    _unregister();
    super.detach();
  }
}
