import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

/// Distance from the end that still counts as being at it.
const double _atEnd = 0.5;

/// Keeps a scrollable at its live edge while output grows, and lets the
/// reader leave it.
///
/// The reader decides. Any scroll toward older content releases the edge at
/// once, whatever produced it: a wheel or trackpad, a drag, the keyboard, a
/// scrollbar or focus moving to an earlier message. A scroll that arrives at
/// the end, or moves toward it and stops within [threshold], follows again,
/// and so does content that shrinks while the reader is within [threshold] of
/// the end. While a hold is active ([hold]), the edge does not move the
/// content; it catches up when the last hold ends.
///
/// Holding is pointer-driven: [AgentLiveEdge] holds while a pointer is down
/// on the scrollable. Nothing here sees a text selection, so a host that
/// wants a selection to hold the edge calls [hold] when the selection starts
/// and [unhold] when it ends.
///
/// Wire a scrollable to it with [AgentLiveEdge], which reports the scrollable's
/// notifications and gives it [AgentLiveEdgeScrollPhysics].
class AgentLiveEdgeController extends ChangeNotifier {
  /// Creates a live edge that follows from the start.
  AgentLiveEdgeController({bool enabled = true, double threshold = 48})
    : _enabled = enabled,
      _threshold = threshold;

  bool _enabled;
  double _threshold;
  bool _following = true;
  bool _showLatest = false;
  int _holds = 0;
  bool _programmatic = false;
  bool _returning = false;
  bool _followScheduled = false;
  bool _disposed = false;
  double? _lastMaxScrollExtent;
  ScrollController? _scrollController;

  /// Whether the edge follows output at all.
  ///
  /// Turning it off leaves the reader where they are. Turning it back on is
  /// the host's resume action: the edge follows again and moves to the end.
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (value == _enabled) return;
    _enabled = value;
    if (value) {
      _following = true;
      if (!_returning) _scheduleFollow();
    }
    _refreshLatest(null);
    _notify();
  }

  /// How far from the end, in logical pixels, a scroll toward the end
  /// follows again and the way back to the latest stays hidden.
  double get threshold => _threshold;

  set threshold(double value) {
    if (value == _threshold) return;
    _threshold = value;
    _refreshLatest(null);
  }

  /// Whether the reader is at the live edge rather than reading older output.
  bool get following => _following;

  /// Whether a hold keeps the content still.
  bool get holding => _holds > 0;

  /// Whether growing output keeps the end in view right now.
  bool get keepsEnd => _enabled && _following && _holds == 0;

  /// Whether the reader is away from the end without being followed, so a
  /// way back to the latest output should be offered.
  bool get showLatest => _showLatest;

  /// Connects the scroll controller of the scrollable this edge drives.
  ///
  /// [AgentLiveEdge] calls this; call it directly only when wiring a
  /// scrollable by hand.
  void attach(ScrollController controller) {
    _scrollController = controller;
    _lastMaxScrollExtent = null;
    _scheduleFollow();
  }

  /// Disconnects [controller] if it is the attached one.
  void detach(ScrollController controller) {
    if (identical(_scrollController, controller)) _scrollController = null;
  }

  /// Stops following, as if the reader had scrolled back.
  void release() => _setFollowing(false);

  /// Follows again; the end comes into view on the next frame.
  void resume() {
    _setFollowing(true);
    _scheduleFollow();
  }

  /// Keeps the content still until a matching [unhold].
  ///
  /// [AgentLiveEdge] calls it for a pointer that is down on the scrollable.
  /// Call it yourself to hold for anything else, such as a text selection.
  ///
  /// Holds nest: the edge catches up when the last one ends.
  void hold() {
    _holds++;
    if (_holds == 1) _notify();
  }

  /// Ends one [hold], and catches up with the end when it was the last.
  void unhold() {
    assert(_holds > 0, 'unhold() called without a matching hold().');
    if (_holds == 0) return;
    _holds--;
    if (_holds > 0) return;
    _scheduleFollow();
    _notify();
  }

  /// Returns to the end and follows again.
  ///
  /// Animates unless [animate] is false; pass false under reduced motion.
  /// Output that grows while the animation runs is followed when it ends.
  Future<void> scrollToEnd({
    bool animate = true,
    Duration duration = const Duration(milliseconds: 180),
    Curve curve = Curves.easeOut,
  }) async {
    _setFollowing(true);
    final position = _position;
    if (position == null) return;
    if (!animate) {
      _jumpToEnd();
      return;
    }
    _returning = true;
    try {
      await position.animateTo(
        position.maxScrollExtent,
        duration: duration,
        curve: curve,
      );
    } finally {
      _returning = false;
      if (!_disposed && keepsEnd) _jumpToEnd();
    }
  }

  /// Reads a scroll notification from the attached scrollable.
  ///
  /// The decision reads each [ScrollUpdateNotification] after the scroll has
  /// moved, so input that announces its direction before it moves (the mouse
  /// wheel does) cannot be mistaken for a reader still at the end. Moves made
  /// by this edge are ignored.
  void handleScrollNotification(ScrollNotification notification) {
    if (!_programmatic && notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      final distance = _distanceToEnd(notification.metrics);
      if (distance <= _atEnd) {
        _setFollowing(true);
      } else if (delta < 0) {
        _setFollowing(false);
      } else if (delta > 0 && distance <= _threshold) {
        _setFollowing(true);
      }
    }
    _lastMaxScrollExtent = notification.metrics.maxScrollExtent;
    _refreshLatest(notification.metrics);
  }

  /// Reads new extents from the attached scrollable.
  ///
  /// Content that shrank while the reader was within [threshold] of the end
  /// follows again. A following scrollable left short of its end (a recreated
  /// scroll position skips the physics on its first layout) moves to it after
  /// the frame.
  void handleScrollMetrics(ScrollMetrics metrics) {
    final previous = _lastMaxScrollExtent;
    _lastMaxScrollExtent = metrics.maxScrollExtent;
    if (!_following &&
        _enabled &&
        previous != null &&
        metrics.maxScrollExtent < previous - _atEnd &&
        _distanceToEnd(metrics) <= _threshold) {
      _setFollowing(true);
    }
    if (keepsEnd && !_returning && _distanceToEnd(metrics) > _atEnd) {
      _scheduleFollow();
    }
    _refreshLatest(metrics);
  }

  ScrollPosition? get _position {
    final controller = _scrollController;
    if (controller == null || !controller.hasClients) return null;
    final position = controller.position;
    return position.hasContentDimensions ? position : null;
  }

  double _distanceToEnd(ScrollMetrics metrics) =>
      metrics.maxScrollExtent - metrics.pixels;

  void _setFollowing(bool next) {
    if (_following == next) return;
    _following = next;
    _refreshLatest(null);
    _notify();
  }

  void _refreshLatest(ScrollMetrics? metrics) {
    final current = metrics ?? _position;
    final next =
        !(_enabled && _following) &&
        current != null &&
        _distanceToEnd(current) > _threshold;
    if (next == _showLatest) return;
    _showLatest = next;
    _notify();
  }

  void _scheduleFollow() {
    if (_followScheduled || _disposed) return;
    _followScheduled = true;
    SchedulerBinding.instance
      ..addPostFrameCallback((_) {
        _followScheduled = false;
        // A return in progress lands on the end itself.
        if (!_disposed && keepsEnd && !_returning) _jumpToEnd();
      })
      ..ensureVisualUpdate();
  }

  void _jumpToEnd() {
    final position = _position;
    if (position == null) return;
    _programmatic = true;
    try {
      position.jumpTo(position.maxScrollExtent);
    } finally {
      _programmatic = false;
    }
  }

  /// Notifies listeners, after the frame when called during layout.
  ///
  /// Scroll notifications can arrive while the viewport lays out, where a
  /// listener's `setState` is not allowed.
  void _notify() {
    if (_disposed) return;
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        if (!_disposed) notifyListeners();
      });
      return;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _scrollController = null;
    super.dispose();
  }
}

/// Keeps a following scrollable at its end during the layout that grew it.
///
/// [ScrollPhysics.adjustPositionForNewDimensions] runs inside the viewport's
/// layout whenever its extents change, so the end stays in view in the frame
/// that painted the new output. A post-frame jump instead paints one frame
/// with the newest line below the fold and schedules a second frame for every
/// streamed token. Nothing moves while the reader is scrolling.
class AgentLiveEdgeScrollPhysics extends ScrollPhysics {
  /// Creates physics that read [liveEdge].
  AgentLiveEdgeScrollPhysics({
    required AgentLiveEdgeController liveEdge,
    super.parent,
  }) : _liveEdge = (() => liveEdge);

  /// Physics that read whichever live edge [liveEdge] returns when asked.
  ///
  /// A [Scrollable] keeps its position, and the physics it was built with,
  /// when only the physics instance changes; [AgentLiveEdge] uses this so a
  /// replaced controller takes effect.
  const AgentLiveEdgeScrollPhysics._resolving(this._liveEdge, {super.parent});

  final AgentLiveEdgeController Function() _liveEdge;

  /// The live edge that decides whether growth keeps the end in view.
  AgentLiveEdgeController get liveEdge => _liveEdge();

  @override
  AgentLiveEdgeScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      AgentLiveEdgeScrollPhysics._resolving(
        _liveEdge,
        parent: buildParent(ancestor),
      );

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (liveEdge.keepsEnd && !isScrolling) return newPosition.maxScrollExtent;
    return super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );
  }
}

/// Builds the scrollable an [AgentLiveEdge] drives.
///
/// Give the scrollable [scrollController] and [physics].
typedef AgentLiveEdgeBuilder =
    Widget Function(
      BuildContext context,
      ScrollController scrollController,
      ScrollPhysics physics,
    );

/// Connects the scrollable that [builder] returns to a live edge.
///
/// It reports the scrollable's own notifications (not those of nested
/// scrollables) to [controller], holds the edge while a pointer is down on the
/// scrollable (and only then: a text selection does not hold, see
/// [AgentLiveEdgeController.hold]), and supplies the scroll controller and
/// physics. It paints nothing of its own.
class AgentLiveEdge extends StatefulWidget {
  /// Creates a live-edge connection.
  const AgentLiveEdge({
    super.key,
    required this.controller,
    this.scrollController,
    required this.builder,
  });

  /// The live edge that follows the scrollable.
  final AgentLiveEdgeController controller;

  /// The scroll controller to drive; when null, the widget owns one.
  final ScrollController? scrollController;

  /// Builds the scrollable.
  final AgentLiveEdgeBuilder builder;

  @override
  State<AgentLiveEdge> createState() => _AgentLiveEdgeState();
}

class _AgentLiveEdgeState extends State<AgentLiveEdge> {
  ScrollController? _ownedController;
  late ScrollController _scrollController;
  late final _physics = AgentLiveEdgeScrollPhysics._resolving(
    () => widget.controller,
  );
  final Set<int> _pointers = {};

  @override
  void initState() {
    super.initState();
    _scrollController =
        widget.scrollController ?? (_ownedController = ScrollController());
    widget.controller.attach(_scrollController);
  }

  @override
  void didUpdateWidget(AgentLiveEdge oldWidget) {
    super.didUpdateWidget(oldWidget);
    final controllerChanged = !identical(
      oldWidget.controller,
      widget.controller,
    );
    final scrollChanged = !identical(
      oldWidget.scrollController,
      widget.scrollController,
    );
    if (!controllerChanged && !scrollChanged) return;

    _releasePointers(oldWidget.controller);
    oldWidget.controller.detach(_scrollController);
    if (scrollChanged) {
      final offset = _scrollController.hasClients
          ? _scrollController.offset
          : 0.0;
      final superseded = _ownedController;
      _ownedController = null;
      _scrollController =
          widget.scrollController ??
          (_ownedController = ScrollController(initialScrollOffset: offset));
      // The scrollable still holds the old controller until this frame's
      // rebuild detaches it, and detaching touches a disposed object.
      if (superseded != null) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => superseded.dispose(),
        );
      }
    }
    widget.controller.attach(_scrollController);
  }

  void _releasePointers(AgentLiveEdgeController controller) {
    for (final _ in _pointers) {
      controller.unhold();
    }
    _pointers.clear();
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (_pointers.add(event.pointer)) widget.controller.hold();
  }

  void _handlePointerEnd(PointerEvent event) {
    if (_pointers.remove(event.pointer)) widget.controller.unhold();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _handlePointerDown,
      onPointerUp: _handlePointerEnd,
      onPointerCancel: _handlePointerEnd,
      child: NotificationListener<ScrollMetricsNotification>(
        onNotification: (notification) {
          if (notification.depth == 0) {
            widget.controller.handleScrollMetrics(notification.metrics);
          }
          return false;
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification.depth == 0) {
              widget.controller.handleScrollNotification(notification);
            }
            return false;
          },
          child: widget.builder(context, _scrollController, _physics),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _releasePointers(widget.controller);
    widget.controller.detach(_scrollController);
    _ownedController?.dispose();
    super.dispose();
  }
}
