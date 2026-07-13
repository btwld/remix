part of 'tooltip.dart';

class RemixTooltip extends StatefulWidget {
  const RemixTooltip({
    super.key,
    this.style = const RemixTooltipStyle.create(),
    this.styleSpec,
    required this.tooltipChild,
    required this.child,
    this.tooltipSemantics,
    this.initiallyOpen = false,
  });

  /// The style configuration for the tooltip.
  final RemixTooltipStyle style;

  /// The style spec for the tooltip.
  final RemixTooltipSpec? styleSpec;

  /// The widget to display in the tooltip.
  final Widget tooltipChild;

  /// The child widget that will trigger the tooltip.
  final Widget child;

  /// The semantic label for the tooltip.
  final String? tooltipSemantics;

  /// Opens the real tooltip overlay after the first layout pass.
  final bool initiallyOpen;

  static final styleFrom = RemixTooltipStyle.new;

  @override
  State<RemixTooltip> createState() => _RemixTooltipState();
}

class _RemixTooltipState extends State<RemixTooltip> {
  final MenuController _controller = MenuController();
  Timer? _showTimer;
  Timer? _waitTimer;

  @override
  void initState() {
    super.initState();
    if (widget.initiallyOpen) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.open();
      });
    }
  }

  void _enter(Duration waitDuration) {
    _showTimer?.cancel();
    _waitTimer?.cancel();
    _waitTimer = Timer(waitDuration, _controller.open);
  }

  void _exit(Duration showDuration) {
    _showTimer?.cancel();
    _waitTimer?.cancel();
    _showTimer = Timer(showDuration, _controller.close);
  }

  @override
  void dispose() {
    _showTimer?.cancel();
    _waitTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleBuilder(
      style: widget.style,
      styleSpec: widget.styleSpec,
      builder: (context, spec) {
        final showDuration =
            spec.showDuration ?? const Duration(milliseconds: 1500);
        final waitDuration =
            spec.waitDuration ?? const Duration(milliseconds: 300);
        return RawMenuAnchor(
          consumeOutsideTaps: false,
          controller: _controller,
          overlayBuilder: (context, info) => OverlayPositioner(
            targetRect: info.anchorRect,
            positioning: const OverlayPositionConfig(
              targetAnchor: Alignment.topCenter,
              followerAnchor: Alignment.bottomCenter,
            ),
            child: Box(styleSpec: spec.container, child: widget.tooltipChild),
          ),
          child: Semantics(
            container: true,
            tooltip: widget.tooltipSemantics,
            child: MouseRegion(
              onEnter: (_) => _enter(waitDuration),
              onExit: (_) => _exit(showDuration),
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}
