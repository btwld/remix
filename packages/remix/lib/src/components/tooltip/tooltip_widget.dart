part of 'tooltip.dart';

class RemixTooltip extends StatelessWidget {
  const RemixTooltip({
    super.key,
    this.style = const RemixTooltipStyle.create(),
    this.styleSpec,
    required this.tooltipChild,
    required this.child,
    this.tooltipSemantics,
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

  static final styleFrom = RemixTooltipStyle.new;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: style,
      builder: (context, spec) {
        return NakedTooltip(
          overlayBuilder: (context, info) => Box(
            styleSpec: spec.container,
            child: tooltipChild,
          ),
          showDuration: spec.showDuration,
          waitDuration: spec.waitDuration,
          semanticsLabel: tooltipSemantics,
          child: child,
        );
      },
    );
  }
}
