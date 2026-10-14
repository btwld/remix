part of 'tooltip.dart';

/// A trigger widget that displays styled content in a tooltip overlay.
///
/// Renders [tooltipChild] inside the overlay. Users hover, focus, or
/// long-press [child] to reveal the tooltip.
class RemixTooltip extends StatelessWidget {
  /// Creates a [RemixTooltip].
  const RemixTooltip({
    super.key,
    required this.tooltipChild,
    required this.child,
    this.tooltipKey,
    this.onOpenChanged,
    this.tooltipSemantics,
    this.positioning = const OverlayPositionConfig(),
    this.style = const TooltipStyler.create(),
    this.styleSpec,
  });

  /// The style configuration for the tooltip.
  final TooltipStyler style;

  /// The style spec for the tooltip.
  final TooltipSpec? styleSpec;

  /// The widget to display in the tooltip.
  final Widget tooltipChild;

  /// The child widget that triggers the tooltip.
  final Widget child;

  /// A key for imperative control via [RawTooltipState.ensureTooltipVisible].
  final GlobalKey<RawTooltipState>? tooltipKey;

  /// A callback invoked when the tooltip visible state changes.
  final ValueChanged<bool>? onOpenChanged;

  /// The semantic label for the tooltip.
  final String? tooltipSemantics;

  /// The overlay positioning configuration.
  final OverlayPositionConfig positioning;

  /// The style factory for [RemixTooltip].
  static final styleFrom = TooltipStyler.new;

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<TooltipSpec>(
      style: style,
      styleSpec: styleSpec,
      builder: (context, spec) {
        return NakedTooltip(
          tooltipKey: tooltipKey,
          onOpenChanged: onOpenChanged,
          overlayBuilder: (context, _) => Box(
            styleSpec: spec.container,
            child: StyleSpecBuilder(
              styleSpec: spec.label,
              builder: (context, labelSpec) => DefaultTextStyle.merge(
                style: labelSpec.style,
                textAlign: labelSpec.textAlign,
                softWrap: labelSpec.softWrap,
                overflow: labelSpec.overflow,
                maxLines: labelSpec.maxLines,
                textWidthBasis: labelSpec.textWidthBasis,
                textHeightBehavior: labelSpec.textHeightBehavior,
                child: tooltipChild,
              ),
            ),
          ),
          hoverDelay: spec.waitDuration ?? const Duration(milliseconds: 300),
          // showDuration is touch long-press wait (Material-aligned touchDelay).
          touchDelay: spec.showDuration ?? const Duration(milliseconds: 1500),
          // dismissDuration is hover-exit grace before the tooltip closes.
          dismissDelay:
              spec.dismissDuration ?? const Duration(milliseconds: 100),
          positioning: positioning,
          semanticLabel: tooltipSemantics,
          child: child,
        );
      },
    );
  }
}
