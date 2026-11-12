import 'package:flutter/widgets.dart';

/// Shared private-package live-edge state machine.
///
/// The reader decides. Any scroll that moves toward older content releases
/// the edge at once, whatever produced it: a wheel or trackpad, a drag, the
/// keyboard, a scrollbar, or focus moving to an earlier message. A scroll that
/// arrives at the end, or moves toward it and stops within [threshold], follows
/// again. The decision reads each [ScrollUpdateNotification] after the scroll
/// has moved, so input that announces its direction before it moves (the mouse
/// wheel does) cannot be mistaken for a reader still at the end.
class UiLiveEdgeEngine {
  UiLiveEdgeEngine({
    required this._enabled,
    required this.threshold,
    this.onChanged,
  });

  bool _enabled;

  /// Whether following is on at all; the host's `followOutput`.
  bool get enabled => _enabled;

  set enabled(bool value) {
    // An explicit false-to-true transition is the host's resume action.
    // Ordinary rebuilds with follow enabled must preserve a reader's release.
    if (value && !_enabled) _following = true;
    _enabled = value;
  }

  /// Distance from the end, in logical pixels, that still counts as near it.
  double threshold;

  /// Called when the reader releases or regains the live edge.
  ValueChanged<bool>? onChanged;

  bool _following = true;

  /// True while [jumpToEnd] moves the position, so it is not read as a scroll.
  bool _programmatic = false;

  /// Whether the reader is at, or has returned to, the end.
  bool get following => _following;

  /// Whether growing output should keep the end in view.
  bool get sticks => _enabled && _following;

  /// Whether [metrics] left a following scrollable short of its end.
  ///
  /// The physics keep the end during layout, except on the first layout of a
  /// recreated [ScrollPosition]: a Scrollable rebuilds its position when its
  /// dependencies change (scroll behavior, gesture settings), and that layout
  /// does not consult [ScrollPhysics.adjustPositionForNewDimensions].
  bool needsFollow(ScrollMetrics metrics) =>
      sticks && metrics.maxScrollExtent - metrics.pixels > _atEnd;

  /// Updates following from a scroll at the scrollable's own depth.
  void handleScroll(ScrollNotification notification) {
    if (_programmatic || notification is! ScrollUpdateNotification) return;
    final delta = notification.scrollDelta ?? 0;
    final metrics = notification.metrics;
    final distance = metrics.maxScrollExtent - metrics.pixels;
    if (distance <= _atEnd) {
      _setFollowing(true);
    } else if (delta < 0) {
      _setFollowing(false);
    } else if (delta > 0 && distance <= threshold) {
      _setFollowing(true);
    }
  }

  /// The reader asked for the newest output: follow again.
  void resume() => _setFollowing(true);

  /// Jumps to the end when following is enabled and the reader is following.
  void follow(ScrollController controller) {
    if (!enabled || !following) return;
    jumpToEnd(controller);
  }

  /// Moves to the end without reading the jump as a reader scroll.
  void jumpToEnd(ScrollController controller) {
    if (!controller.hasClients) return;
    final position = controller.position;
    if (!position.hasContentDimensions) return;
    _programmatic = true;
    position.jumpTo(position.maxScrollExtent);
    _programmatic = false;
  }

  void _setFollowing(bool next) {
    if (following == next) return;
    _following = next;
    onChanged?.call(next);
  }
}

/// Distance from the end that still counts as being at it.
const double _atEnd = 0.5;

/// Keeps a following scrollable at its end during the layout that grew it.
///
/// [ScrollPhysics.adjustPositionForNewDimensions] runs inside the viewport's
/// layout whenever its extents change, so the end stays in view in the frame
/// that painted the new output. A post-frame jump instead paints one frame
/// with the newest line below the fold and schedules a second frame for every
/// streamed token. Nothing moves while the reader is scrolling.
class UiLiveEdgeScrollPhysics extends ScrollPhysics {
  const UiLiveEdgeScrollPhysics({required this.liveEdge, super.parent});

  /// The engine that decides whether the end stays in view.
  final UiLiveEdgeEngine liveEdge;

  @override
  UiLiveEdgeScrollPhysics applyTo(ScrollPhysics? ancestor) =>
      UiLiveEdgeScrollPhysics(
        liveEdge: liveEdge,
        parent: buildParent(ancestor),
      );

  @override
  double adjustPositionForNewDimensions({
    required ScrollMetrics oldPosition,
    required ScrollMetrics newPosition,
    required bool isScrolling,
    required double velocity,
  }) {
    if (liveEdge.sticks && !isScrolling) return newPosition.maxScrollExtent;
    return super.adjustPositionForNewDimensions(
      oldPosition: oldPosition,
      newPosition: newPosition,
      isScrolling: isScrolling,
      velocity: velocity,
    );
  }
}

/// Small non-lazy scroll view used by plan and activity ledgers.
class UiLiveEdgeScrollView extends StatefulWidget {
  const UiLiveEdgeScrollView({
    super.key,
    required this.child,
    this.followOutput = true,
    this.followThreshold = 48,
    this.onFollowChanged,
  });

  /// The content to scroll.
  final Widget child;

  /// Whether growing content keeps the end in view.
  final bool followOutput;

  /// Distance from the end, in logical pixels, that still counts as near it.
  final double followThreshold;

  /// Called when the reader leaves or returns to the end.
  final ValueChanged<bool>? onFollowChanged;

  @override
  State<UiLiveEdgeScrollView> createState() => _UiLiveEdgeScrollViewState();
}

class _UiLiveEdgeScrollViewState extends State<UiLiveEdgeScrollView> {
  late final ScrollController _controller;
  late final UiLiveEdgeEngine _liveEdge;
  late final UiLiveEdgeScrollPhysics _physics;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _liveEdge = UiLiveEdgeEngine(
      enabled: widget.followOutput,
      threshold: widget.followThreshold,
      onChanged: widget.onFollowChanged,
    );
    _physics = UiLiveEdgeScrollPhysics(liveEdge: _liveEdge);
    // Growth follows in layout; only the first extents need a jump.
    _scheduleFollow();
  }

  @override
  void didUpdateWidget(UiLiveEdgeScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _liveEdge
      ..enabled = widget.followOutput
      ..threshold = widget.followThreshold
      ..onChanged = widget.onFollowChanged;
    if (!oldWidget.followOutput && widget.followOutput) _scheduleFollow();
  }

  void _scheduleFollow() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _liveEdge.follow(_controller);
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollMetricsNotification>(
      onNotification: (notification) {
        if (notification.depth == 0 &&
            _liveEdge.needsFollow(notification.metrics)) {
          _scheduleFollow();
        }
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0) _liveEdge.handleScroll(notification);
          return false;
        },
        child: SingleChildScrollView(
          controller: _controller,
          physics: _physics,
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
