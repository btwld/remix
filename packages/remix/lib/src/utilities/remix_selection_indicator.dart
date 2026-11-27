import 'dart:math' as math;

import 'package:flutter/foundation.dart' show internal;
import 'package:flutter/physics.dart' show SpringSimulation;
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../rendering/remix_box_effects.dart';
import 'remix_reduced_motion.dart';

/// The motion of an indicator that sets no `indicatorMotion`: 250 ms along
/// `Curves.easeOutCubic`.
const _defaultIndicatorMotion = CurveAnimationConfig(
  duration: Duration(milliseconds: 250),
  curve: Curves.easeOutCubic,
);

/// Lets anchors hand their render boxes to the indicator of the host above
/// them.
final class _IndicatorRegistry {
  final Map<Object, _RenderIndicatorAnchor> _anchors = {};
  _RenderIndicatorLayer? _bar;

  void anchorChanged(Object id) => _bar?.anchorChanged(id);

  /// The mounted anchor [id] that has been laid out, or `null`.
  _RenderIndicatorAnchor? laidOut(Object? id) {
    final anchor = _anchors[id];
    return anchor != null && anchor.attached && anchor.laidOutSize != null
        ? anchor
        : null;
  }
}

/// Keeps the anchors mounted even if the host's style toggles the indicator.
final class _IndicatorScope extends InheritedWidget {
  const _IndicatorScope({required this.registry, required super.child});

  final _IndicatorRegistry registry;

  static _IndicatorRegistry? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_IndicatorScope>()?.registry;

  @override
  bool updateShouldNotify(_IndicatorScope oldWidget) =>
      registry != oldWidget.registry;
}

/// Throws [ArgumentError] unless [motion] is `null`, a
/// [CurveAnimationConfig], or a [SpringAnimationConfig].
@internal
void remixCheckIndicatorMotion(AnimationConfig? motion) {
  if (motion == null ||
      motion is CurveAnimationConfig ||
      motion is SpringAnimationConfig) {
    return;
  }
  throw ArgumentError.value(
    motion,
    'indicatorMotion',
    'Expected CurveAnimationConfig or SpringAnimationConfig',
  );
}

/// Marks [child] as the item [id] of the nearest
/// [RemixSelectionIndicatorHost], so the indicator can sit on it when it is
/// selected. Without a host it returns [child] unchanged.
@internal
class RemixSelectionIndicatorAnchor extends StatelessWidget {
  const RemixSelectionIndicatorAnchor({
    super.key,
    required this.id,
    required this.child,
  });

  final Object id;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final registry = _IndicatorScope.maybeOf(context);
    if (registry == null) return child;
    return _IndicatorAnchor(registry: registry, id: id, child: child);
  }
}

/// Wraps one item so the host can find it without remounting its content.
class _IndicatorAnchor extends SingleChildRenderObjectWidget {
  const _IndicatorAnchor({
    required this.registry,
    required this.id,
    required super.child,
  });

  final _IndicatorRegistry registry;
  final Object id;

  @override
  _RenderIndicatorAnchor createRenderObject(BuildContext context) =>
      _RenderIndicatorAnchor(registry, id);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderIndicatorAnchor renderObject,
  ) {
    renderObject.update(registry, id);
  }
}

/// A box that is exactly its item, and keeps the size it laid out to. Only a
/// parent may read its child's size during layout, so the host reads it here.
class _RenderIndicatorAnchor extends RenderProxyBox {
  _RenderIndicatorAnchor(this._registry, this._id);

  _IndicatorRegistry _registry;
  Object _id;

  /// The size of the last layout, or `null` before the first one.
  Size? laidOutSize;

  void update(_IndicatorRegistry registry, Object id) {
    if (_registry == registry && _id == id) return;
    if (attached) _unregister();
    _registry = registry;
    _id = id;
    if (attached) _register();
  }

  void _register() {
    _registry._anchors[_id] = this;
    _registry.anchorChanged(_id);
  }

  void _unregister() {
    if (_registry._anchors[_id] != this) return;
    _registry._anchors.remove(_id);
    _registry.anchorChanged(_id);
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
    _registry.anchorChanged(_id);
  }
}

/// Runs the indicator's move from where it was to the selected anchor.
///
/// Each glide starts from the last painted bounds, not from an anchor that may
/// already have moved. Once started, it tracks the current target.
final class _IndicatorMotion {
  _IndicatorMotion(TickerProvider vsync)
    : controller = AnimationController.unbounded(vsync: vsync, value: 1);

  final AnimationController controller;

  Rect? lastPaintedRect;
  Rect? _fromRect;
  Offset? _delta;
  Object? fromId;
  int _runId = 0;

  bool get gliding => _fromRect != null;

  void cancel() {
    if (!gliding) return;
    _runId++;
    controller.stop();
    _fromRect = null;
    _delta = null;
    fromId = null;
  }

  void settle() {
    if (!gliding) return;
    cancel();
    controller.value = 1;
  }

  void begin(Object from, AnimationConfig config) {
    cancel();
    final rect = lastPaintedRect;
    if (rect == null) return;
    _fromRect = rect;
    fromId = from;
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

/// Draws one indicator behind [child], on the [RemixSelectionIndicatorAnchor]
/// whose id is [selectedId], and glides it there when the selection changes.
///
/// The indicator is placed from the anchor's position each time the host
/// paints, so keep the anchors directly in the host: a scrollable between them
/// is not supported.
@internal
class RemixSelectionIndicatorHost extends StatefulWidget {
  const RemixSelectionIndicatorHost({
    super.key,
    required this.selectedId,
    required this.indicator,
    required this.indicatorEffects,
    required this.motion,
    required this.child,
  });

  /// The id of the selected anchor, or `null` for no indicator.
  final Object? selectedId;
  final StyleSpec<BoxSpec>? indicator;
  final RemixBoxEffectsSpec? indicatorEffects;
  final AnimationConfig? motion;
  final Widget child;

  @override
  State<RemixSelectionIndicatorHost> createState() =>
      _RemixSelectionIndicatorHostState();
}

class _RemixSelectionIndicatorHostState
    extends State<RemixSelectionIndicatorHost>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final _registry = _IndicatorRegistry();
  late final _motion = _IndicatorMotion(this);
  Object? _selectedId;

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
    final selectedId = indicator == null ? null : widget.selectedId;
    final previous = _selectedId;
    if (selectedId == null || remixReducedMotionOf(context)) {
      _motion.settle();
    } else if (previous != null && previous != selectedId) {
      _motion.begin(previous, widget.motion ?? _defaultIndicatorMotion);
    }
    _selectedId = selectedId;

    return _IndicatorScope(
      registry: _registry,
      child: _IndicatorLayer(
        registry: _registry,
        motion: _motion,
        selectedId: selectedId,
        indicator: indicator == null
            ? null
            : ExcludeSemantics(
                child: IgnorePointer(
                  child: RemixBoxAdapter(
                    key: const ValueKey('remix-selection-indicator'),
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

enum _IndicatorSlot { indicator, content }

class _IndicatorLayer
    extends SlottedMultiChildRenderObjectWidget<_IndicatorSlot, RenderBox> {
  const _IndicatorLayer({
    required this.registry,
    required this.motion,
    required this.selectedId,
    required this.indicator,
    required this.content,
  });

  final _IndicatorRegistry registry;
  final _IndicatorMotion motion;
  final Object? selectedId;
  final Widget? indicator;
  final Widget content;

  @override
  Iterable<_IndicatorSlot> get slots => _IndicatorSlot.values;

  @override
  Widget? childForSlot(_IndicatorSlot slot) => switch (slot) {
    _IndicatorSlot.indicator => indicator,
    _IndicatorSlot.content => content,
  };

  @override
  _RenderIndicatorLayer createRenderObject(BuildContext context) =>
      _RenderIndicatorLayer(
        registry: registry,
        motion: motion,
        selectedId: selectedId,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderIndicatorLayer renderObject,
  ) {
    renderObject
      ..registry = registry
      ..motion = motion
      ..selectedId = selectedId;
  }
}

/// Sizes itself to its content, then sizes the indicator to the selected
/// anchor and paints it on that anchor, behind the content.
///
/// The indicator is laid out again on every animation tick, which costs one
/// layout of the indicator and not of the items. Paint never marks anything
/// dirty: it reads where the selected anchor is and draws the indicator there.
class _RenderIndicatorLayer extends RenderBox
    with SlottedContainerRenderObjectMixin<_IndicatorSlot, RenderBox> {
  _RenderIndicatorLayer({
    required _IndicatorRegistry registry,
    required _IndicatorMotion motion,
    required Object? selectedId,
  }) : _registry = registry,
       _motion = motion,
       _selectedId = selectedId;

  _IndicatorRegistry _registry;
  set registry(_IndicatorRegistry value) {
    if (_registry == value) return;
    if (attached) _registry._bar = null;
    _registry = value;
    if (attached) _registry._bar = this;
    markNeedsLayout();
  }

  _IndicatorMotion _motion;
  set motion(_IndicatorMotion value) {
    if (_motion == value) return;
    if (attached) _motion.controller.removeListener(markNeedsLayout);
    _motion = value;
    if (attached) _motion.controller.addListener(markNeedsLayout);
    markNeedsLayout();
  }

  Object? _selectedId;
  set selectedId(Object? value) {
    if (_selectedId == value) return;
    _selectedId = value;
    markNeedsLayout();
  }

  RenderBox? get _indicator => childForSlot(_IndicatorSlot.indicator);
  RenderBox? get _content => childForSlot(_IndicatorSlot.content);
  Size? _laidOutTargetSize;
  Size _laidOutIndicatorSize = Size.zero;
  bool _anchorRelayoutPending = false;

  /// A selected anchor can relayout below a tight constraint without laying
  /// out this host. Catch up after layout; the current paint still uses its
  /// new bounds. Most changes are already handled by [performLayout].
  void anchorChanged(Object id) {
    if (id != _selectedId || _indicator == null || _anchorRelayoutPending) {
      return;
    }
    _anchorRelayoutPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _anchorRelayoutPending = false;
      if (attached &&
          _indicator != null &&
          _registry.laidOut(_selectedId)?.laidOutSize != _laidOutTargetSize) {
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

  Rect _boundsOf(_RenderIndicatorAnchor anchor) {
    final size = anchor.laidOutSize!;
    final transform = anchor.getTransformTo(this);
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
    final selected = _registry.laidOut(_selectedId);
    if (motion.gliding &&
        (selected == null || _registry.laidOut(motion.fromId) == null)) {
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
    final selected = indicator == null ? null : _registry.laidOut(_selectedId);
    _motion.lastPaintedRect = indicator != null && selected != null
        ? _paintIndicator(context, offset, indicator, selected)
        : null;
    context.paintChild(_content!, offset);
  }

  Rect? _paintIndicator(
    PaintingContext context,
    Offset offset,
    RenderBox indicator,
    _RenderIndicatorAnchor selected,
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
