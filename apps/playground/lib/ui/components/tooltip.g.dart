// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tooltip.dart';

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// The application's Tooltip recipe.
///
/// `textXs` on a `foreground` bubble with `radiusMd` corners, shown the moment
/// the pointer arrives. It is the one floating surface that is not `popover`:
/// inverted (`foreground` fill, `background` text), so a transient label reads
/// differently from a panel a reader can act in.
class PlaygroundTooltip extends StatelessWidget {
  const PlaygroundTooltip({
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
      style: playgroundTooltipStyle(style: this.style),
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
