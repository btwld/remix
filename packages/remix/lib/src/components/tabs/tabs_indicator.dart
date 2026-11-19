part of 'tabs.dart';

/// How the shared indicator of a [RemixTabBar] moves to the selected tab.
///
/// ```dart
/// // A curve over a duration:
/// const RemixTabIndicatorMotion(
///   duration: Duration(milliseconds: 470),
///   curve: Curves.easeOutCubic,
/// );
///
/// // A spring, which may overshoot:
/// const RemixTabIndicatorMotion.spring(
///   SpringDescription(mass: 1, stiffness: 400, damping: 30),
/// );
/// ```
///
/// While the user asks to reduce motion the indicator jumps to the selected
/// tab.
@immutable
final class RemixTabIndicatorMotion {
  /// Moves along [curve] over [duration].
  const RemixTabIndicatorMotion({
    this.duration = const Duration(milliseconds: 250),
    this.curve = Curves.easeOutCubic,
  }) : spring = null;

  /// Moves under [spring], starting at rest. Its settling time sets the pace.
  const RemixTabIndicatorMotion.spring(SpringDescription this.spring)
    : duration = Duration.zero,
      curve = Curves.linear;

  /// How long a curve motion takes. Unused for a spring.
  final Duration duration;

  /// The easing of a curve motion. Unused for a spring.
  final Curve curve;

  /// The spring of a spring motion, or `null` for a curve motion.
  final SpringDescription? spring;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemixTabIndicatorMotion &&
          duration == other.duration &&
          curve == other.curve &&
          spring == other.spring;

  @override
  int get hashCode => Object.hash(duration, curve, spring);

  @override
  String toString() => spring == null
      ? 'RemixTabIndicatorMotion(duration: $duration, curve: $curve)'
      : 'RemixTabIndicatorMotion.spring($spring)';
}

/// Lets tabs hand their render boxes to the indicator that follows them.
final class _TabIndicatorRegistry {
  final Map<String, _RenderTabAnchor> _tabs = {};
}

final class _TabIndicatorScope extends InheritedWidget {
  const _TabIndicatorScope({required this.registry, required super.child});

  final _TabIndicatorRegistry registry;

  static _TabIndicatorRegistry? maybeOf(BuildContext context) =>
      context.getInheritedWidgetOfExactType<_TabIndicatorScope>()?.registry;

  @override
  bool updateShouldNotify(_TabIndicatorScope oldWidget) =>
      registry != oldWidget.registry;
}

/// Wraps one tab and tells the indicator of the bar above it, if there is
/// one, where the tab is.
class _TabIndicatorAnchor extends SingleChildRenderObjectWidget {
  const _TabIndicatorAnchor({required this.tabId, required super.child});

  final String tabId;

  @override
  _RenderTabAnchor createRenderObject(BuildContext context) =>
      _RenderTabAnchor(tabId, _TabIndicatorScope.maybeOf(context));

  @override
  void updateRenderObject(BuildContext context, _RenderTabAnchor renderObject) {
    renderObject.update(tabId, _TabIndicatorScope.maybeOf(context));
  }

  @override
  void didUnmountRenderObject(_RenderTabAnchor renderObject) {
    renderObject.update(renderObject.tabId, null);
  }
}

/// A box that is exactly its tab, and keeps the size it laid out to. Only the
/// parent may read a child's size during layout, so the bar reads it here.
class _RenderTabAnchor extends RenderProxyBox {
  _RenderTabAnchor(this.tabId, this._registry) {
    _registry?._tabs[tabId] = this;
  }

  String tabId;
  _TabIndicatorRegistry? _registry;

  /// The size of the last layout, or `null` before the first one.
  Size? laidOutSize;

  void update(String tabId, _TabIndicatorRegistry? registry) {
    if (_registry?._tabs[this.tabId] == this)
      _registry!._tabs.remove(this.tabId);
    this.tabId = tabId;
    _registry = registry;
    registry?._tabs[tabId] = this;
  }

  @override
  void performLayout() {
    super.performLayout();
    laidOutSize = size;
  }
}

/// Runs the indicator's move from where it was to the selected tab.
///
/// The destination is not stored: the bar measures the selected tab on every
/// layout, so the indicator also follows a tab that moves or resizes.
final class _TabIndicatorMotion {
  _TabIndicatorMotion(TickerProvider vsync)
    : controller = AnimationController.unbounded(vsync: vsync, value: 1);

  final AnimationController controller;

  Rect? _from;

  /// The rectangle last laid out, or `null` when no tab was selected.
  Rect? lastRect;

  /// Starts a glide from [lastRect] to wherever the selected tab is.
  void begin({required RemixTabIndicatorMotion motion, required bool reduce}) {
    final from = lastRect;
    if (from == null || reduce) {
      _from = null;
      controller.stop();
      controller.value = 1;
      return;
    }
    _from = from;
    controller.value = 0;
    final spring = motion.spring;
    if (spring != null) {
      controller.animateWith(SpringSimulation(spring, 0, 1, 0));
    } else {
      controller.animateTo(1, duration: motion.duration, curve: motion.curve);
    }
  }

  /// The rectangle to draw for a selected tab at [target].
  Rect? rectFor(Rect? target) {
    final from = _from;
    if (target == null || from == null) return target;
    return Rect.lerp(from, target, controller.value);
  }

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
  final RemixTabIndicatorMotion? motion;
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
    if (_selectedTabId != null && _selectedTabId != selectedTabId) {
      _motion.begin(
        motion: widget.motion ?? const RemixTabIndicatorMotion(),
        reduce: reduce,
      );
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

/// Sizes itself to its content, then lays the indicator over the selected tab
/// and paints it behind the content.
///
/// The indicator is laid out again on every animation tick, which costs one
/// layout of the indicator and not of the tabs.
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

  Rect? _laidOutTarget;

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

  /// The selected tab's bounds in this box's coordinates, or `null` when it
  /// is not mounted or not laid out.
  Rect? _measureSelected() {
    final tab = _registry._tabs[_selectedTabId];
    final size = tab?.laidOutSize;
    if (tab == null || size == null || !tab.attached) return null;
    return MatrixUtils.transformPoint(tab.getTransformTo(this), Offset.zero) &
        size;
  }

  @override
  void performLayout() {
    final content = _content!;
    content.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(content.size);

    _laidOutTarget = _measureSelected();
    final rect = _motion.rectFor(_laidOutTarget);
    _motion.lastRect = rect;
    final indicator = _indicator!;
    indicator.layout(BoxConstraints.tight(rect?.size ?? Size.zero));
    (indicator.parentData! as BoxParentData).offset = rect?.topLeft ?? .zero;
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final rect = _motion.lastRect;
    if (rect != null && !rect.isEmpty) {
      context.paintChild(
        _indicator!,
        offset + (_indicator!.parentData! as BoxParentData).offset,
      );
    }
    context.paintChild(_content!, offset);
    // A tab can move without this box being laid out again, when the change
    // stops at a relayout boundary below it. Catch up on the next frame.
    if (_measureSelected() != _laidOutTarget) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (attached) markNeedsLayout();
      });
    }
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
