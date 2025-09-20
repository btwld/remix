part of 'tooltip.dart';

class RemixTooltip extends StatelessWidget {
  const RemixTooltip({
    super.key,
    required this.tooltipChild,
    required this.child,
    this.showDuration = const Duration(seconds: 1),
    this.waitDuration = Duration.zero,
    this.tooltipSemantics,
    this.style = const RemixTooltipStyle.create(),
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

  /// The style for the tooltip.
  final RemixTooltipStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleProvider<TooltipSpec>(
      style: style,
      child: StyleBuilder<TooltipSpec>(
        style: style,
        builder: (context, spec) {
          final containerBuilder = spec.container.createWidget;

          final tooltip = NakedTooltip(
            tooltipBuilder: (context) => containerBuilder(child: tooltipChild),
            showDuration: showDuration,
            waitDuration: waitDuration,
            child: child,
          );

          return tooltipSemantics != null
              ? Semantics(tooltip: tooltipSemantics, child: tooltip)
              : tooltip;
        },
      ),
    );
  }
}
