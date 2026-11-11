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
class AgentLiveEdgeEngine {
  AgentLiveEdgeEngine({
    required this._enabled,
    required this.threshold,
    this.onChanged,
  });

  bool _enabled;
  bool get enabled => _enabled;

  set enabled(bool value) {
    // An explicit false-to-true transition is the host's resume action.
    // Ordinary rebuilds with follow enabled must preserve a reader's release.
    if (value && !_enabled) _following = true;
    _enabled = value;
  }

  double threshold;
  ValueChanged<bool>? onChanged;
  bool _following = true;
  bool _programmatic = false;

  bool get following => _following;

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

  void follow(ScrollController controller) {
    if (!enabled || !following || !controller.hasClients) return;
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

/// Small non-lazy scroll view used by plan and activity ledgers.
class AgentLiveEdgeScrollView extends StatefulWidget {
  const AgentLiveEdgeScrollView({
    super.key,
    required this.child,
    this.followOutput = true,
    this.followThreshold = 48,
    this.onFollowChanged,
  });

  final Widget child;
  final bool followOutput;
  final double followThreshold;
  final ValueChanged<bool>? onFollowChanged;

  @override
  State<AgentLiveEdgeScrollView> createState() =>
      _AgentLiveEdgeScrollViewState();
}

class _AgentLiveEdgeScrollViewState extends State<AgentLiveEdgeScrollView> {
  late final ScrollController _controller;
  late final AgentLiveEdgeEngine _liveEdge;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _liveEdge = AgentLiveEdgeEngine(
      enabled: widget.followOutput,
      threshold: widget.followThreshold,
      onChanged: widget.onFollowChanged,
    );
    _scheduleFollow();
  }

  @override
  void didUpdateWidget(AgentLiveEdgeScrollView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _liveEdge
      ..enabled = widget.followOutput
      ..threshold = widget.followThreshold
      ..onChanged = widget.onFollowChanged;
    _scheduleFollow();
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
        if (notification.depth == 0 && _liveEdge.following) _scheduleFollow();
        return false;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.depth == 0) _liveEdge.handleScroll(notification);
          return false;
        },
        child: SingleChildScrollView(
          controller: _controller,
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
