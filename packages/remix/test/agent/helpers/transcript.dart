import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';

/// Finds the harness's way back to the latest output.
const latestKey = ValueKey('test-transcript-latest');

/// A transcript built only from the live-edge behavior: a lazy list, the
/// edge's notifications and physics, and a plain way back to the latest
/// output while the edge offers one. It stands in for the conversation widget,
/// which wires the same pieces.
class TestTranscript extends StatefulWidget {
  const TestTranscript({
    super.key,
    required this.itemCount,
    this.itemExtent = 24,
    this.label = 'Line',
    this.liveEdge,
    this.scrollController,
    this.followOutput = true,
    this.onFollowChanged,
  });

  final int itemCount;
  final double itemExtent;
  final String label;
  final AgentLiveEdgeController? liveEdge;
  final ScrollController? scrollController;
  final bool followOutput;
  final ValueChanged<bool>? onFollowChanged;

  @override
  State<TestTranscript> createState() => _TestTranscriptState();
}

class _TestTranscriptState extends State<TestTranscript> {
  AgentLiveEdgeController? _owned;
  late AgentLiveEdgeController _liveEdge;
  late bool _following;
  late bool _showLatest;

  /// Whether the host's own configuration is being applied; the changes it
  /// causes are not echoed back through `onFollowChanged`.
  bool _configuring = false;

  @override
  void initState() {
    super.initState();
    _liveEdge =
        widget.liveEdge ??
        (_owned = AgentLiveEdgeController(enabled: widget.followOutput));
    _adopt();
  }

  void _adopt() {
    _following = _liveEdge.following;
    _showLatest = _liveEdge.showLatest;
    _liveEdge.addListener(_handleChange);
  }

  @override
  void didUpdateWidget(TestTranscript oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(oldWidget.liveEdge, widget.liveEdge)) {
      _liveEdge.removeListener(_handleChange);
      _owned?.dispose();
      _owned = null;
      _liveEdge =
          widget.liveEdge ??
          (_owned = AgentLiveEdgeController(enabled: widget.followOutput));
      _adopt();
    }
    _configuring = true;
    _liveEdge.enabled = widget.followOutput;
    _configuring = false;
    _following = _liveEdge.following;
  }

  void _handleChange() {
    if (!_configuring && _liveEdge.following != _following) {
      _following = _liveEdge.following;
      widget.onFollowChanged?.call(_following);
    }
    if (_liveEdge.showLatest != _showLatest) {
      setState(() => _showLatest = _liveEdge.showLatest);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        AgentLiveEdge(
          controller: _liveEdge,
          scrollController: widget.scrollController,
          builder: (context, scrollController, physics) => ListView.builder(
            controller: scrollController,
            physics: physics,
            itemCount: widget.itemCount,
            itemBuilder: (context, index) => SizedBox(
              height: widget.itemExtent,
              child: Text('${widget.label} $index'),
            ),
          ),
        ),
        if (_showLatest)
          GestureDetector(
            key: latestKey,
            onTap: () => _liveEdge.scrollToEnd(
              animate: !(MediaQuery.maybeDisableAnimationsOf(context) ?? false),
            ),
            child: const Text('Latest'),
          ),
      ],
    );
  }

  @override
  void dispose() {
    _liveEdge.removeListener(_handleChange);
    _owned?.dispose();
    super.dispose();
  }
}

/// A transcript whose output grows on demand, recording follow changes.
class GrowingTranscript extends StatefulWidget {
  const GrowingTranscript({
    super.key,
    this.initialCount = 24,
    this.liveEdge,
    this.scrollController,
    this.mirrorFollow = false,
  });

  final int initialCount;
  final AgentLiveEdgeController? liveEdge;
  final ScrollController? scrollController;

  /// Whether the host feeds each follow change back as `followOutput`, as an
  /// application that shows its own "following" state does.
  final bool mirrorFollow;

  @override
  State<GrowingTranscript> createState() => GrowingTranscriptState();
}

class GrowingTranscriptState extends State<GrowingTranscript> {
  late var count = widget.initialCount;
  var following = true;
  final changes = <bool>[];

  void grow([int by = 6]) => setState(() => count += by);

  void shrink(int by) => setState(() => count -= by);

  @override
  Widget build(BuildContext context) => TestTranscript(
    itemCount: count,
    liveEdge: widget.liveEdge,
    scrollController: widget.scrollController,
    followOutput: widget.mirrorFollow ? following : true,
    onFollowChanged: (value) {
      changes.add(value);
      if (widget.mirrorFollow) setState(() => following = value);
    },
  );
}
