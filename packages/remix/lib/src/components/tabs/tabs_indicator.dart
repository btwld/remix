part of 'tabs.dart';

/// The motion of a [RemixTabBar] indicator that sets no `indicatorMotion`:
/// 250 ms along `Curves.easeOutCubic`.
const _defaultIndicatorMotion = CurveAnimationConfig(
  duration: Duration(milliseconds: 250),
  curve: Curves.easeOutCubic,
);

/// Lets tabs hand their render boxes to the indicator of the bar above them.
final class _TabIndicatorRegistry {
  final Map<String, _RenderTabAnchor> _tabs = {};
  _RenderTabIndicatorBar? _bar;

  void anchorChanged(String tabId) => _bar?.anchorChanged(tabId);

  /// The mounted tab [tabId] that has been laid out, or `null`.
  _RenderTabAnchor? laidOut(String? tabId) {
    final tab = _tabs[tabId];
    return tab != null && tab.attached && tab.laidOutSize != null ? tab : null;
  }
}

/// Keeps the anchors mounted even if the bar's style toggles the indicator.
final class _TabIndicatorScope extends InheritedWidget {
  const _TabIndicatorScope({required this.registry, required super.child});

  final _TabIndicatorRegistry registry;

  static _TabIndicatorRegistry? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_TabIndicatorScope>()
      ?.registry;

  @override
  bool updateShouldNotify(_TabIndicatorScope oldWidget) =>
      registry != oldWidget.registry;
}

/// Wraps one tab so the bar can find it without remounting its content.
class _TabIndicatorAnchor extends SingleChildRenderObjectWidget {
  const _TabIndicatorAnchor({
    required this.registry,
    required this.tabId,
    required super.child,
  });

  final _TabIndicatorRegistry registry;
  final String tabId;

  @override
  _RenderTabAnchor createRenderObject(BuildContext context) =>
      _RenderTabAnchor(registry, tabId);

  @override
  void updateRenderObject(BuildContext context, _RenderTabAnchor renderObject) {
    renderObject.update(registry, tabId);
  }
}

/// A box that is exactly its tab, and keeps the size it laid out to. Only a
/// parent may read its child's size during layout, so the bar reads it here.
class _RenderTabAnchor extends RenderProxyBox {
  _RenderTabAnchor(this._registry, this._tabId);

  _TabIndicatorRegistry _registry;
  String _tabId;

  /// The size of the last layout, or `null` before the first one.
  Size? laidOutSize;

  void update(_TabIndicatorRegistry registry, String tabId) {
    if (_registry == registry && _tabId == tabId) return;
    if (attached) _unregister();
    _registry = registry;
    _tabId = tabId;
    if (attached) _register();
  }

  void _register() {
    _registry._tabs[_tabId] = this;
    _registry.anchorChanged(_tabId);
  }

  void _unregister() {
    if (_registry._tabs[_tabId] != this) return;
    _registry._tabs.remove(_tabId);
    _registry.anchorChanged(_tabId);
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _register();
  }

  @override
  void detach() {
    _unregister();
    super.detach();
  }

  @override
  void performLayout() {
    super.performLayout();
    if (laidOutSize == size) return;
    laidOutSize = size;
    _registry.anchorChanged(_tabId);
  }
}

/// Runs the indicator's move from where it was to the selected tab.
///
/// Each glide starts from the last painted bounds, not from a tab that may
/// already have moved. Once started, it tracks the current target.
final class _TabIndicatorMotion {
  _TabIndicatorMotion(TickerProvider vsync)
    : controller = AnimationController.unbounded(vsync: vsync, value: 1);

  final AnimationController controller;

  Rect? lastPaintedRect;
  Rect? _fromRect;
  Offset? _delta;
  String? fromTabId;
  int _runId = 0;

  bool get gliding => _fromRect != null;

  void cancel() {
    if (!gliding) return;
    _runId++;
    controller.stop();
    _fromRect = null;
    _delta = null;
    fromTabId = null;
  }

  void settle() {
    if (!gliding) return;
    cancel();
    controller.value = 1;
  }

  void begin(String from, AnimationConfig config) {
    cancel();
    final rect = lastPaintedRect;
    if (rect == null) return;
    _fromRect = rect;
    fromTabId = from;
    controller.value = 0;
    final runId = ++_runId;

    void complete(VoidCallback? onEnd) {
      if (runId != _runId) return;
      cancel();
      onEnd?.call();
    }

    if (config is SpringAnimationConfig) {
      controller
          .animateWith(
            SpringSimulation(config.spring, 0, 1, 0, snapToEnd: true),
          )
          .then((_) => complete(config.onEnd));
    } else {
      final curveConfig = config as CurveAnimationConfig;
      final delay = curveConfig.delay;
      final total = curveConfig.totalDuration;
      controller
          .animateTo(
            1,
            duration: total,
            curve: delay > Duration.zero
                ? Interval(
                    delay.inMicroseconds / total.inMicroseconds,
                    1,
                    curve: curveConfig.curve,
                  )
                : curveConfig.curve,
          )
          .then((_) => complete(curveConfig.onEnd));
    }
  }

  Size sizeFor(Size target) {
    final from = _fromRect?.size;
    if (from == null) return target;
    final t = controller.value;
    return Size(
      math.max(0, from.width + (target.width - from.width) * t),
      math.max(0, from.height + (target.height - from.height) * t),
    );
  }

  Rect rectFor(Rect target) {
    final from = _fromRect;
    if (from == null) return target;
    final delta = _delta ??= from.topLeft - target.topLeft;
    return (target.topLeft + delta * (1 - controller.value)) &
        sizeFor(target.size);
  }

  void dispose() {
    cancel();
    controller.dispose();
  }
}

/// Draws the shared indicator behind [child] and glides it to the selected
/// tab.
class _TabIndicatorHost extends StatefulWidget {
  const _TabIndicatorHost({
    required this.indicator,
    required this.indicatorEffects,
    required this.motion,
    required this.child,
  });

  final StyleSpec<BoxSpec>? indicator;
  final RemixBoxEffectsSpec? indicatorEffects;
  final AnimationConfig? motion;
  final Widget child;

  @override
  State<_TabIndicatorHost> createState() => _TabIndicatorHostState();
}

class _TabIndicatorHostState extends State<_TabIndicatorHost>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _registry = _TabIndicatorRegistry();
  late final _motion = _TabIndicatorMotion(this);
  String? _selectedTabId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAccessibilityFeatures() {
    if (_motion.gliding && remixReducedMotionOf(context)) _motion.settle();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicator = widget.indicator;
    final selectedTabId = indicator == null
        ? null
        : NakedTabsScope.of(context).selectedTabId;
    final previous = _selectedTabId;
    if (selectedTabId == null || remixReducedMotionOf(context)) {
      _motion.settle();
    } else if (previous != null && previous != selectedTabId) {
      _motion.begin(previous, widget.motion ?? _defaultIndicatorMotion);
    }
    _selectedTabId = selectedTabId;

    return _TabIndicatorScope(
      registry: _registry,
      child: _TabIndicatorBar(
        registry: _registry,
        motion: _motion,
        selectedTabId: selectedTabId,
        indicator: indicator == null
            ? null
            : ExcludeSemantics(
                child: IgnorePointer(
                  child: RemixBoxAdapter(
                    key: const ValueKey('remix-tab-indicator'),
                    styleSpec: indicator,
                    containerEffects: widget.indicatorEffects,
                  ),
                ),
              ),
        content: widget.child,
      ),
    );
  }
}

enum _TabIndicatorSlot { indicator, content }

class _TabIndicatorBar
    extends SlottedMultiChildRenderObjectWidget<_TabIndicatorSlot, RenderBox> {
  const _TabIndicatorBar({
    required this.registry,
    required this.motion,
    required this.selectedTabId,
    required this.indicator,
    required this.content,
  });

  final _TabIndicatorRegistry registry;
  final _TabIndicatorMotion motion;
  final String? selectedTabId;
  final Widget? indicator;
  final Widget content;

  @override
  Iterable<_TabIndicatorSlot> get slots => _TabIndicatorSlot.values;

  @override
  Widget? childForSlot(_TabIndicatorSlot slot) => switch (slot) {
    _TabIndicatorSlot.indicator => indicator,
    _TabIndicatorSlot.content => content,
  };

  @override
  _RenderTabIndicatorBar createRenderObject(BuildContext context) =>
      _RenderTabIndicatorBar(
        registry: registry,
        motion: motion,
        selectedTabId: selectedTabId,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderTabIndicatorBar renderObject,
  ) {
    renderObject
      ..registry = registry
      ..motion = motion
      ..selectedTabId = selectedTabId;
  }
}

/// Sizes itself to its content, then sizes the indicator to the selected tab
/// and paints it on that tab, behind the content.
///
/// The indicator is laid out again on every animation tick, which costs one
/// layout of the indicator and not of the tabs. Paint never marks anything
/// dirty: it reads where the selected tab is and draws the indicator there.
class _RenderTabIndicatorBar extends RenderBox
    with SlottedContainerRenderObjectMixin<_TabIndicatorSlot, RenderBox> {
  _RenderTabIndicatorBar({
    required _TabIndicatorRegistry registry,
    required _TabIndicatorMotion motion,
    required String? selectedTabId,
  }) : _registry = registry,
       _motion = motion,
       _selectedTabId = selectedTabId;

  _TabIndicatorRegistry _registry;
  set registry(_TabIndicatorRegistry value) {
    if (_registry == value) return;
    if (attached) _registry._bar = null;
    _registry = value;
    if (attached) _registry._bar = this;
    markNeedsLayout();
  }

  _TabIndicatorMotion _motion;
  set motion(_TabIndicatorMotion value) {
    if (_motion == value) return;
    if (attached) _motion.controller.removeListener(markNeedsLayout);
    _motion = value;
    if (attached) _motion.controller.addListener(markNeedsLayout);
    markNeedsLayout();
  }

  String? _selectedTabId;
  set selectedTabId(String? value) {
    if (_selectedTabId == value) return;
    _selectedTabId = value;
    markNeedsLayout();
  }

  RenderBox? get _indicator => childForSlot(_TabIndicatorSlot.indicator);
  RenderBox? get _content => childForSlot(_TabIndicatorSlot.content);
  Size? _laidOutTargetSize;
  Size _laidOutIndicatorSize = Size.zero;
  bool _anchorRelayoutPending = false;

  /// A selected anchor can relayout below a tight constraint without laying
  /// out this bar. Catch up after layout; the current paint still uses its
  /// new bounds. Most changes are already handled by [performLayout].
  void anchorChanged(String tabId) {
    if (tabId != _selectedTabId ||
        _indicator == null ||
        _anchorRelayoutPending) {
      return;
    }
    _anchorRelayoutPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _anchorRelayoutPending = false;
      if (attached &&
          _indicator != null &&
          _registry.laidOut(_selectedTabId)?.laidOutSize !=
              _laidOutTargetSize) {
        markNeedsLayout();
      }
    });
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _registry._bar = this;
    _motion.controller.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _registry._bar = null;
    _motion.controller.removeListener(markNeedsLayout);
    super.detach();
  }

  Rect _boundsOf(_RenderTabAnchor tab) {
    final size = tab.laidOutSize!;
    final transform = tab.getTransformTo(this);
    final translation = MatrixUtils.getAsTranslation(transform);
    return translation != null
        ? translation & size
        : MatrixUtils.transformRect(transform, Offset.zero & size);
  }

  @override
  void performLayout() {
    final content = _content!;
    content.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(content.size);

    final indicator = _indicator;
    if (indicator == null) return;
    final motion = _motion;
    final selected = _registry.laidOut(_selectedTabId);
    if (motion.gliding &&
        (selected == null || _registry.laidOut(motion.fromTabId) == null)) {
      motion.cancel();
    }

    final targetSize = selected?.laidOutSize;
    _laidOutTargetSize = targetSize;
    _laidOutIndicatorSize = targetSize == null
        ? Size.zero
        : motion.sizeFor(targetSize);
    indicator.layout(BoxConstraints.tight(_laidOutIndicatorSize));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final indicator = _indicator;
    final selected = indicator == null
        ? null
        : _registry.laidOut(_selectedTabId);
    _motion.lastPaintedRect = indicator != null && selected != null
        ? _paintIndicator(context, offset, indicator, selected)
        : null;
    context.paintChild(_content!, offset);
  }

  Rect? _paintIndicator(
    PaintingContext context,
    Offset offset,
    RenderBox indicator,
    _RenderTabAnchor selected,
  ) {
    final laidOut = _laidOutIndicatorSize;
    if (laidOut.isEmpty) return null;
    final bounds = _boundsOf(selected);
    if (!bounds.isFinite || bounds.isEmpty) return null;
    final rect = _motion.rectFor(bounds);
    if (!rect.isFinite || rect.isEmpty) return null;
    final origin = offset + rect.topLeft;
    if (rect.size == laidOut) {
      context.paintChild(indicator, origin);
    } else {
      context.pushTransform(
        needsCompositing,
        origin,
        Matrix4.diagonal3Values(
          rect.width / laidOut.width,
          rect.height / laidOut.height,
          1,
        ),
        (context, offset) => context.paintChild(indicator, offset),
      );
    }
    return rect;
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      _content!.hitTest(result, position: position);

  @override
  double computeMinIntrinsicWidth(double height) =>
      _content!.getMinIntrinsicWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _content!.getMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) =>
      _content!.getMinIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _content!.getMaxIntrinsicHeight(width);

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      _content!.getDistanceToActualBaseline(baseline);

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) => _content!.getDryBaseline(constraints, baseline);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      constraints.constrain(_content!.getDryLayout(constraints));

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    // The indicator is decorative.
    visitor(_content!);
  }
}
