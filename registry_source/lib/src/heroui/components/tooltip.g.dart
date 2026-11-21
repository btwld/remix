// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// HeroUI recipe for [RemixTooltip].
///
/// Hover, focus, and long-press behavior stay with Remix.
class HeroUiTooltip extends StatelessWidget {
  const HeroUiTooltip({
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
  Widget build(BuildContext _) {
    return RemixTooltip(
      style: heroUiTooltipStyle(style: style),
      tooltipChild: tooltipChild,
      tooltipKey: tooltipKey,
      onOpenChanged: onOpenChanged,
      tooltipSemantics: tooltipSemantics,
      positioning: positioning,
      transitionBuilder: transitionBuilder,
      animationStyle: animationStyle,
      child: child,
    );
  }
}
