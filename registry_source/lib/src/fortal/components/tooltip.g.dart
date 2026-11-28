// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The Fortal Tooltip recipe: 13px text in the page color on an ink bubble
/// with 14px corners, inverted from the page, that appears 8px above its
/// trigger after a 250ms wait.
///
/// It fades in over 150ms while it rises 3px from its trigger and grows from
/// 97%, and fades out in 100ms to 98%. Under reduced motion it only fades.
class FortalTooltip extends StatelessWidget {
  const FortalTooltip({
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
      style: fortalTooltipStyle(style: style),
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
