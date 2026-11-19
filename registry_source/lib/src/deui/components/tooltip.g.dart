// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Deui recipe for [RemixTooltip]: a small `overlay` chip with a hairline
/// border and a 12px medium label.
///
/// Hover, focus, and long-press behavior stay with Remix. [animationStyle] is
/// Deui's 180 ms in and 120 ms out on an ease-out, and [transitionBuilder]
/// fades and scales the chip from .94 about the edge that faces its trigger;
/// both are Remix's own hooks, so a call can replace either.
class DeuiTooltip extends StatelessWidget {
  const DeuiTooltip({
    super.key,
    this.animationStyle = const AnimationStyle(
      curve: _easeOut,
      duration: _showDuration,
      reverseDuration: _hideDuration,
    ),
    this.transitionBuilder = deuiTooltipTransition,
    this.style = const TooltipStyler.create(),
    required this.tooltipChild,
    required this.child,
    this.tooltipKey,
    this.onOpenChanged,
    this.tooltipSemantics,
    this.positioning = const OverlayPositionConfig(),
  });

  final AnimationStyle animationStyle;

  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  )?
  transitionBuilder;

  final TooltipStyler style;

  final Widget tooltipChild;

  final Widget child;

  final GlobalKey<RawTooltipState>? tooltipKey;

  final ValueChanged<bool>? onOpenChanged;

  final String? tooltipSemantics;

  final OverlayPositionConfig positioning;

  @override
  Widget build(BuildContext context) {
    return RemixTooltip(
      key: this.key,
      style: deuiTooltipStyle(
        animationStyle: this.animationStyle,
        transitionBuilder: this.transitionBuilder,
        style: this.style,
      ),
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
