part of 'tooltip.dart';

class RemixTooltip extends StatelessWidget {
  const RemixTooltip({
    super.key,
    required this.tooltipChild,
    required this.child,
    this.showDuration = const Duration(seconds: 1),
    this.waitDuration = Duration.zero,
    this.tooltipSemantics,
    this.style = const TooltipStyle.create(),
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
  final TooltipStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: DefaultTooltipStyle.merge(style),
      builder: (context, spec) {
        return NakedTooltip(
          tooltipBuilder: (context) => spec.container(
            child: DefaultTextStyle(
              style: TextStyle(
                color: spec.text.style?.color,
                fontSize: spec.text.style?.fontSize,
                fontWeight: spec.text.style?.fontWeight,
              ),
              child: tooltipChild,
            ),
          ),
          showDuration: showDuration,
          waitDuration: waitDuration,
          tooltipSemantics: tooltipSemantics,
          removalDelay: const Duration(milliseconds: 100),
          child: child,
        );
      },
    );
  }
}