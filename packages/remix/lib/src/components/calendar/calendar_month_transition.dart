part of 'calendar.dart';

/// Which way the displayed month moved.
enum RemixMonthDirection {
  /// To a later month.
  forward,

  /// To an earlier month.
  backward,
}

/// What a [RemixMonthTransitionBuilder] receives for one month grid.
@immutable
final class RemixMonthTransitionInfo {
  const RemixMonthTransitionInfo({
    required this.animation,
    required this.direction,
    required this.isIncoming,
  });

  /// Runs from `0.0` to `1.0` once per month change, paced by
  /// [RemixMonthTransition.duration]. Both grids receive the same animation.
  /// It is linear: apply a curve in the builder.
  ///
  /// It rests at `1.0` while no month change is running.
  final Animation<double> animation;

  /// Which way the displayed month moved in the latest change.
  final RemixMonthDirection direction;

  /// Whether this grid shows the displayed month. The outgoing grid is inert
  /// and is removed when [animation] completes.
  final bool isIncoming;
}

/// Wraps one month grid in a month change transition.
///
/// It is called once for the incoming grid and, while a change runs, once for
/// the outgoing grid. Both grids share one stack cell, with the incoming grid
/// on top, so a builder that slides them usually clips each one.
typedef RemixMonthTransitionBuilder =
    Widget Function(
      BuildContext context,
      RemixMonthTransitionInfo info,
      Widget grid,
    );

/// A motion for the weeks of a calendar when its displayed month changes.
///
/// Set it from a style, so a preset's recipe owns the motion:
///
/// ```dart
/// CalendarStyler().monthTransition(
///   RemixMonthTransition(
///     duration: const Duration(milliseconds: 300),
///     builder: (context, info, grid) {
///       final sign = info.direction == RemixMonthDirection.forward ? 1 : -1;
///       final t = Curves.easeOutCubic.transform(info.animation.value);
///       return ClipRect(
///         child: FractionalTranslation(
///           translation: Offset(
///             info.isIncoming ? sign * (1 - t) : -sign * t,
///             0,
///           ),
///           child: grid,
///         ),
///       );
///     },
///   ),
/// )
/// ```
///
/// The builder runs on every frame of the animation; the grid it wraps is
/// built once. While the user asks
/// to reduce motion the new month replaces the old one at once. Without a
/// transition the calendar swaps months at once.
@immutable
final class RemixMonthTransition {
  const RemixMonthTransition({
    required this.builder,
    this.duration = const Duration(milliseconds: 300),
  });

  /// Wraps each month grid.
  final RemixMonthTransitionBuilder builder;

  /// How long one month change takes.
  final Duration duration;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemixMonthTransition &&
          builder == other.builder &&
          duration == other.duration;

  @override
  int get hashCode => Object.hash(builder, duration);

  @override
  String toString() => 'RemixMonthTransition(duration: $duration)';
}

typedef _MonthGrid = ({List<List<DateTime?>> weeks, int generation});

class _MonthTransitionHost extends StatefulWidget {
  const _MonthTransitionHost({
    required this.month,
    required this.weeks,
    required this.transition,
    required this.gridBuilder,
  });

  final DateTime month;
  final List<List<DateTime?>> weeks;
  final RemixMonthTransition transition;
  final Widget Function(List<List<DateTime?>> weeks) gridBuilder;

  @override
  State<_MonthTransitionHost> createState() => _MonthTransitionHostState();
}

class _MonthTransitionHostState extends State<_MonthTransitionHost>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late final _controller = AnimationController(
    vsync: this,
    duration: widget.transition.duration,
    value: 1,
  )..addStatusListener(_onStatus);
  // Each navigation gets its own grid identity, so returning to the month
  // that is still sliding out builds a second grid instead of reusing it.
  var _generation = 0;
  _MonthGrid? _outgoing;
  var _direction = RemixMonthDirection.forward;

  static int _index(DateTime month) => month.year * 12 + month.month;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _settleIfReduced();
  }

  @override
  void didChangeAccessibilityFeatures() {
    if (remixReducedMotionOf(context)) setState(_settleIfReduced);
  }

  void _settleIfReduced() {
    if (!remixReducedMotionOf(context)) return;
    _outgoing = null;
    _controller.value = 1;
  }

  void _onStatus(AnimationStatus status) {
    if (status.isCompleted && _outgoing != null && mounted) {
      setState(() => _outgoing = null);
    }
  }

  @override
  void didUpdateWidget(_MonthTransitionHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.transition.duration;
    final from = _index(oldWidget.month);
    final to = _index(widget.month);
    if (from == to) return;
    _direction = to > from
        ? RemixMonthDirection.forward
        : RemixMonthDirection.backward;
    _outgoing = (weeks: oldWidget.weeks, generation: _generation++);
    if (remixReducedMotionOf(context)) {
      _settleIfReduced();
    } else {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  Widget _grid(_MonthGrid grid, {required bool incoming}) => KeyedSubtree(
    key: ValueKey(grid.generation),
    child: IgnorePointer(
      ignoring: !incoming,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, grid) => widget.transition.builder(
          context,
          RemixMonthTransitionInfo(
            animation: _controller.view,
            direction: _direction,
            isIncoming: incoming,
          ),
          grid!,
        ),
        child: widget.gridBuilder(grid.weeks),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final outgoing = _outgoing;
    return Stack(
      children: [
        if (outgoing != null) _grid(outgoing, incoming: false),
        _grid((weeks: widget.weeks, generation: _generation), incoming: true),
      ],
    );
  }
}
