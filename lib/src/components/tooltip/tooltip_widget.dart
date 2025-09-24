part of 'tooltip.dart';

class RemixTooltip extends StyleWidget<TooltipSpec> {
  const RemixTooltip({
    super.style = const RemixTooltipStyle.create(),
    super.styleSpec,
    super.key,
    required this.tooltipChild,
    required this.child,
    this.showDuration = const Duration(seconds: 1),
    this.waitDuration = Duration.zero,
    this.tooltipSemantics,
  });

  /// The widget to display in the tooltip.
  final Widget tooltipChild;

  /// The child widget that will trigger the tooltip.
  final Widget child;

  /// The duration for which the tooltip is shown.
  final Duration showDuration;

  /// The duration to wait before showing the tooltip.
  final Duration waitDuration;

  /// The semantic label for the tooltip.
  final String? tooltipSemantics;

  @override
  Widget build(BuildContext context, TooltipSpec spec) {
    final tooltip = NakedTooltip(
      overlayBuilder: (context) => Box(styleSpec: spec.container, child: tooltipChild),
      showDuration: showDuration,
      waitDuration: waitDuration,
      child: child,
    );

    return tooltipSemantics != null
        ? Semantics(tooltip: tooltipSemantics, child: tooltip)
        : tooltip;
  }
}
