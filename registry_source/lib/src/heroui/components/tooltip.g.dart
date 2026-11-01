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
  });

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
      style: heroUiTooltipStyle(style: this.style),
      tooltipChild: this.tooltipChild,
      child: this.child,
      tooltipKey: this.tooltipKey,
      onOpenChanged: this.onOpenChanged,
      tooltipSemantics: this.tooltipSemantics,
      positioning: this.positioning,
    );
  }
}
