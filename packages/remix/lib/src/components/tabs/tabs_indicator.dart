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

  /// The mounted tab [tabId] that has been laid out, or `null`.
  _RenderTabAnchor? laidOut(String? tabId) {
    final tab = _tabs[tabId];
    return tab != null && tab.attached && tab.laidOutSize != null ? tab : null;
  }
}

/// Present below a [RemixTabBar] only when its style sets an indicator, so a
/// bar without one builds its tabs exactly as before.
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

/// Wraps one tab of a bar that has an indicator, so the bar can find it.
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

  void _register() => _registry._tabs[_tabId] = this;

  void _unregister() {
    if (_registry._tabs[_tabId] == this) _registry._tabs.remove(_tabId);
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
    laidOutSize = size;
  }
}

/// Runs the indicator's move from where it was to the selected tab.
///
/// Where the indicator rests is not stored: the bar reads the selected tab's
/// position every time it paints, so the indicator stays on a tab that moves
/// or resizes. A glide only adds an offset to that, from where the indicator
/// was drawn to the tab, which shrinks to nothing as the animation ends.
final class _TabIndicatorMotion {
  _TabIndicatorMotion(TickerProvider vsync)
    : controller = AnimationController.unbounded(vsync: vsync, value: 1);

  final AnimationController controller;

  /// Whether a glide is in flight or has finished with [delta] and
  /// [fromSize] set.
  bool gliding = false;

  /// Set by [begin] until the next paint measures the origin of the glide.
  bool pending = false;
  String? fromTabId;

  /// Where the indicator was drawn, relative to the tab it left, when the
  /// selection changed.
  Offset carried = Offset.zero;

  /// The indicator's offset from the selected tab at the start of the glide,
  /// in the bar's coordinates.
  Offset delta = Offset.zero;
  Size? fromSize;

  /// The size the indicator was laid out to, or `null` when none was drawn.
  Size? lastSize;

  /// The offset from the selected tab the indicator is drawn at now.
  Offset get linkedOffset =>
      gliding && !pending ? delta * (1 - controller.value) : Offset.zero;

  /// Starts a glide from the tab [from], where the indicator is, to
  /// whichever tab is selected by the next layout.
  void begin({
    required String from,
    required AnimationConfig? config,
    required bool reduce,
  }) {
    final size = lastSize;
    if (size == null || reduce) {
      gliding = false;
      pending = false;
      controller.stop();
      controller.value = 1;
      return;
    }
    carried = linkedOffset;
    fromSize = size;
    fromTabId = from;
    pending = true;
    gliding = true;
    controller.value = 0;
    _run(config ?? _defaultIndicatorMotion);
  }

  void _run(AnimationConfig config) {
    switch (config) {
      case SpringAnimationConfig(:final spring, :final onEnd):
        controller
            .animateWith(SpringSimulation(spring, 0, 1, 0))
            .then((_) => onEnd?.call());
      case CurveAnimationConfig(
        :final duration,
        :final curve,
        :final delay,
        :final onEnd,
      ):
        final total = delay + duration;
        controller
            .animateTo(
              1,
              duration: total,
              curve: delay > Duration.zero
                  ? Interval(
                      delay.inMicroseconds / total.inMicroseconds,
                      1,
                      curve: curve,
                    )
                  : curve,
            )
            .then((_) => onEnd?.call());
      default:
        assert(
          false,
          'TabBarStyler.indicatorMotion takes a curve or a spring '
          'AnimationConfig, not $config.',
        );
        _run(_defaultIndicatorMotion);
    }
  }

  /// The size to lay the indicator out to for a selected tab of [target].
  Size? sizeFor(Size? target) {
    final from = fromSize;
    if (target == null || !gliding || from == null) return target;
    final t = controller.value;
    return Size(
      math.max(0, from.width + (target.width - from.width) * t),
      math.max(0, from.height + (target.height - from.height) * t),
    );
  }

  bool get lastSizeIsEmpty => lastSize?.isEmpty ?? true;

  void dispose() => controller.dispose();
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

  final StyleSpec<BoxSpec> indicator;
  final RemixBoxEffectsSpec? indicatorEffects;
  final AnimationConfig? motion;
  final Widget child;

  @override
  State<_TabIndicatorHost> createState() => _TabIndicatorHostState();
}

class _TabIndicatorHostState extends State<_TabIndicatorHost>
    with SingleTickerProviderStateMixin {
  final _registry = _TabIndicatorRegistry();
  late final _motion = _TabIndicatorMotion(this);
  String? _selectedTabId;

  @override
  void dispose() {
    _motion.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedTabId = NakedTabsScope.of(context).selectedTabId;
    final reduce = remixReducedMotionOf(context);
    final previous = _selectedTabId;
    if (previous != null && previous != selectedTabId) {
      _motion.begin(from: previous, config: widget.motion, reduce: reduce);
    }
    _selectedTabId = selectedTabId;

    return _TabIndicatorScope(
      registry: _registry,
      child: _TabIndicatorBar(
        registry: _registry,
        motion: _motion,
        selectedTabId: selectedTabId,
        indicator: ExcludeSemantics(
          child: IgnorePointer(
            child: RemixBoxAdapter(
              key: const ValueKey('remix-tab-indicator'),
              styleSpec: widget.indicator,
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
  final String selectedTabId;
  final Widget indicator;
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
    required String selectedTabId,
  }) : _registry = registry,
       _motion = motion,
       _selectedTabId = selectedTabId;

  _TabIndicatorRegistry _registry;
  set registry(_TabIndicatorRegistry value) {
    if (_registry == value) return;
    _registry = value;
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

  String _selectedTabId;
  set selectedTabId(String value) {
    if (_selectedTabId == value) return;
    _selectedTabId = value;
    markNeedsLayout();
  }

  RenderBox? get _indicator => childForSlot(_TabIndicatorSlot.indicator);
  RenderBox? get _content => childForSlot(_TabIndicatorSlot.content);

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _motion.controller.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _motion.controller.removeListener(markNeedsLayout);
    super.detach();
  }

  /// The top left of [tab] in this box's coordinates, as laid out now.
  Offset _originOf(_RenderTabAnchor tab) =>
      MatrixUtils.transformPoint(tab.getTransformTo(this), Offset.zero);

  @override
  void performLayout() {
    final content = _content!;
    content.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(content.size);

    final motion = _motion;
    final selected = _registry.laidOut(_selectedTabId);
    if (motion.pending &&
        (selected == null || _registry.laidOut(motion.fromTabId) == null)) {
      // The tab it leaves or the one it reaches is not there: jump.
      motion.pending = false;
      motion.gliding = false;
    }

    final indicatorSize = motion.sizeFor(selected?.laidOutSize);
    motion.lastSize = indicatorSize;
    _indicator!.layout(BoxConstraints.tight(indicatorSize ?? Size.zero));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    // Where the tab is comes from the tree as laid out now, read here and not
    // in layout: a tab can move without this box being laid out again, such
    // as when a relayout boundary below it resizes a sibling or the content
    // is transformed. Nothing is marked dirty from here.
    final selected = _registry.laidOut(_selectedTabId);
    final indicatorSize = _motion.lastSize;
    if (selected != null && indicatorSize != null && !indicatorSize.isEmpty) {
      final origin = _originOf(selected);
      final motion = _motion;
      if (motion.pending) {
        // The one place the start of a glide is measured: where the indicator
        // was drawn, relative to the tab it now ends on.
        motion.pending = false;
        final from = _registry.laidOut(motion.fromTabId);
        if (from != null) {
          motion.delta = _originOf(from) + motion.carried - origin;
        } else {
          motion.gliding = false;
        }
      }
      context.paintChild(_indicator!, offset + origin + motion.linkedOffset);
    }
    context.paintChild(_content!, offset);
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
  Size computeDryLayout(BoxConstraints constraints) =>
      constraints.constrain(_content!.getDryLayout(constraints));

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    // The indicator is decorative.
    visitor(_content!);
  }
}
