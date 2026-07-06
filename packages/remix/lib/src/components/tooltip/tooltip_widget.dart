part of 'tooltip.dart';

/// A trigger widget that shows styled overlay content in a tooltip.
///
/// [tooltipChild] is rendered inside the tooltip overlay. [child] is the
/// widget users hover, focus, or long-press to reveal the tooltip.
class RemixTooltip extends StatelessWidget {
  const RemixTooltip({
    super.key,
    required this.tooltipChild,
    required this.child,
    this.tooltipSemantics,
    this.positioning = const OverlayPositionConfig(),
    this.style = const RemixTooltipStyle.create(),
    this.styleSpec,
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

  /// Overlay positioning configuration.
  final OverlayPositionConfig positioning;

  static final styleFrom = RemixTooltipStyle.new;

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<RemixTooltipSpec>(
      style: style,
      styleSpec: styleSpec,
      builder: (context, spec) {
        return NakedTooltip(
          overlayBuilder: (context, info) =>
              Box(styleSpec: spec.container, child: tooltipChild),
          touchDelay: spec.showDuration ?? const Duration(milliseconds: 1500),
          hoverDelay: spec.waitDuration ?? const Duration(milliseconds: 300),
          positioning: positioning,
          semanticLabel: tooltipSemantics,
          child: child,
        );
      },
    );
  }
}
