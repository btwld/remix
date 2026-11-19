// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixTooltip]: a small `overlay` chip with a hairline
/// border and a 12px medium label.
///
/// Hover, focus, and long-press behavior stay with Remix.
class DeuiTooltip extends StatelessWidget {
  const DeuiTooltip({
    super.key,
    this.style = const TooltipStyler.create(),
    required this.tooltipChild,
    required this.child,
    this.tooltipKey,
    this.onOpenChanged,
    this.tooltipSemantics,
    this.positioning = const OverlayPositionConfig(),
    this.transitionBuilder,
    this.animationStyle = const AnimationStyle(),
  });

  final TooltipStyler style;

  final Widget tooltipChild;

  final Widget child;

  final GlobalKey<RawTooltipState>? tooltipKey;

  final ValueChanged<bool>? onOpenChanged;

  final String? tooltipSemantics;

  final OverlayPositionConfig positioning;

  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  )?
  transitionBuilder;

  final AnimationStyle animationStyle;

  @override
  Widget build(BuildContext context) {
    return RemixTooltip(
      key: this.key,
      style: deuiTooltipStyle(style: this.style),
      tooltipChild: this.tooltipChild,
      child: this.child,
      tooltipKey: this.tooltipKey,
      onOpenChanged: this.onOpenChanged,
      tooltipSemantics: this.tooltipSemantics,
      positioning: this.positioning,
      transitionBuilder: this.transitionBuilder,
      animationStyle: this.animationStyle,
    );
  }
}
