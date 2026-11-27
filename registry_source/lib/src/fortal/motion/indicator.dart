import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'timing.dart';

/// Paints [indicator] behind the [FortalIndicatorAnchor] whose value equals
/// [selected], and springs it to the next anchor when [selected] changes.
///
/// For preset compositions without a Remix indicator slot (pagination, tree
/// rows, button groups). The spring keeps the indicator's velocity when the
/// selection changes again in mid-flight. A layout change under the same
/// selection moves the indicator at once, and so does every change under
/// reduced motion. With no matching anchor nothing is painted.
///
/// The indicator is decoration only: it takes no pointer input and adds no
/// semantics.
class FortalIndicatorTrack extends StatefulWidget {
  const FortalIndicatorTrack({
    super.key,
    required this.selected,
    required this.indicator,
    this.timing = FortalTiming.morph,
    required this.child,
  });

  final Object? selected;

  /// Sized to the selected anchor's box.
  final Widget indicator;

  /// Drives the indicator's position and size.
  final FortalTiming timing;

  /// Holds the anchors.
  final Widget child;

  @override
  State<FortalIndicatorTrack> createState() => _FortalIndicatorTrackState();
}

/// Marks [child] as a place a [FortalIndicatorTrack]'s indicator can travel
/// to.
class FortalIndicatorAnchor extends StatefulWidget {
  const FortalIndicatorAnchor({
    super.key,
    required this.value,
    required this.child,
  });

  final Object value;
  final Widget child;

  @override
  State<FortalIndicatorAnchor> createState() => _FortalIndicatorAnchorState();
}

final class _AnchorRegistry {
  final Map<Object, BuildContext> _contexts = {};

  RenderBox? boxFor(Object? value) {
    if (value == null) return null;
    final box = _contexts[value]?.findRenderObject();

    return box is RenderBox && box.attached && box.hasSize ? box : null;
  }
}

class _AnchorScope extends InheritedWidget {
  const _AnchorScope({required this.registry, required super.child});

  final _AnchorRegistry registry;

  @override
  bool updateShouldNotify(_AnchorScope oldWidget) =>
      registry != oldWidget.registry;
}

class _FortalIndicatorAnchorState extends State<FortalIndicatorAnchor> {
  _AnchorRegistry? _registry;
  Object? _value;

  void _register() {
    final registry = context
        .dependOnInheritedWidgetOfExactType<_AnchorScope>()
        ?.registry;
    if (registry == _registry && widget.value == _value) return;
    _unregister();
    _registry = registry?.._contexts[widget.value] = context;
    _value = widget.value;
  }

  void _unregister() {
    final registry = _registry;
    if (registry != null && registry._contexts[_value] == context) {
      registry._contexts.remove(_value);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _register();
  }

  @override
  void didUpdateWidget(FortalIndicatorAnchor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _register();
  }

  @override
  void dispose() {
    _unregister();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class _FortalIndicatorTrackState extends State<FortalIndicatorTrack>
    with SingleTickerProviderStateMixin {
  final _registry = _AnchorRegistry();

  @override
  Widget build(BuildContext context) {
    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) => _AnchorScope(
        registry: _registry,
        child: _IndicatorTrack(
          vsync: this,
          registry: _registry,
          selected: widget.selected,
          timing: widget.timing,
          reduceMotion: reduceMotion,
          children: [
            IgnorePointer(child: ExcludeSemantics(child: widget.indicator)),
            widget.child,
          ],
        ),
      ),
    );
  }
}

class _IndicatorTrack extends MultiChildRenderObjectWidget {
  const _IndicatorTrack({
    required this.vsync,
    required this.registry,
    required this.selected,
    required this.timing,
    required this.reduceMotion,
    required super.children,
  });

  final TickerProvider vsync;
  final _AnchorRegistry registry;
  final Object? selected;
  final FortalTiming timing;
  final bool reduceMotion;

  @override
  _RenderIndicatorTrack createRenderObject(BuildContext context) =>
      _RenderIndicatorTrack(
        vsync: vsync,
        registry: registry,
        selected: selected,
        timing: timing,
        reduceMotion: reduceMotion,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderIndicatorTrack renderObject,
  ) {
    renderObject
      ..selected = selected
      ..timing = timing
      ..reduceMotion = reduceMotion;
  }
}

class _TrackParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderIndicatorTrack extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TrackParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TrackParentData> {
  _RenderIndicatorTrack({
    required TickerProvider vsync,
    required this.registry,
    required Object? selected,
    required this.timing,
    required this.reduceMotion,
  }) : _selected = selected {
    _clock = FortalMotionClock(vsync, markNeedsLayout);
    _left = _clock.channel(0);
    _top = _clock.channel(0);
    _width = _clock.channel(0);
    _height = _clock.channel(0);
  }

  final _AnchorRegistry registry;
  late final FortalMotionClock _clock;
  late final FortalChannel _left;
  late final FortalChannel _top;
  late final FortalChannel _width;
  late final FortalChannel _height;
  FortalTiming timing;
  bool reduceMotion;

  Object? get selected => _selected;
  Object? _selected;
  set selected(Object? value) {
    if (value == _selected) return;
    _selected = value;
    markNeedsLayout();
  }

  Object? _placedFor;
  bool _placed = false;
  bool _visible = false;

  RenderBox get _indicator => firstChild!;
  RenderBox get _content => lastChild!;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TrackParentData) {
      child.parentData = _TrackParentData();
    }
  }

  @override
  void performLayout() {
    _content.layout(constraints, parentUsesSize: true);
    size = _content.size;
    final anchor = registry.boxFor(_selected);
    _visible = anchor != null;
    if (anchor != null) {
      final rect = MatrixUtils.transformRect(
        anchor.getTransformTo(this),
        Offset.zero & anchor.size,
      );
      final jump = reduceMotion || !_placed || _placedFor == _selected;
      _clock
        ..animate(_left, rect.left, timing, jump: jump)
        ..animate(_top, rect.top, timing, jump: jump)
        ..animate(_width, rect.width, timing, jump: jump)
        ..animate(_height, rect.height, timing, jump: jump);
      _placed = true;
      _placedFor = _selected;
    }
    _indicator.layout(
      BoxConstraints.tight(
        Size(
          _width.value < 0 ? 0 : _width.value,
          _height.value < 0 ? 0 : _height.value,
        ),
      ),
    );
    (_indicator.parentData! as _TrackParentData).offset = Offset(
      _left.value,
      _top.value,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_visible) {
      context.paintChild(
        _indicator,
        offset + (_indicator.parentData! as _TrackParentData).offset,
      );
    }
    context.paintChild(_content, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      _content.hitTest(result, position: position);

  @override
  double computeMinIntrinsicWidth(double height) =>
      _content.getMinIntrinsicWidth(height);

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _content.getMaxIntrinsicWidth(height);

  @override
  double computeMinIntrinsicHeight(double width) =>
      _content.getMinIntrinsicHeight(width);

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _content.getMaxIntrinsicHeight(width);

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) =>
      _content.getDistanceToActualBaseline(baseline);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _content.getDryLayout(constraints);

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }
}
