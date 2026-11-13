part of 'tooltip.dart';

/// A trigger widget that displays styled content in a tooltip overlay.
///
/// Renders [tooltipChild] inside the overlay. Users hover, focus by keyboard,
/// or long-press [child] to reveal the tooltip.
///
/// The styled surface fades in and out by default. Set [animationStyle] to
/// change the show and hide durations and curves, and [transitionBuilder] to
/// replace the fade.
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
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Widget child,
    )?
    transitionBuilder,
    this.animationStyle = const AnimationStyle(),
    this.style = const TooltipStyler.create(),
    this.styleSpec,
  }) : transitionBuilder = transitionBuilder ?? defaultTooltipTransitionBuilder;

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

  /// Wraps the styled tooltip surface in a transition.
  ///
  /// `animation` runs from `0.0` to `1.0` while the tooltip shows and back
  /// while it hides, paced by [animationStyle]. `child` is the whole styled
  /// surface. `context` is inside the overlay, so
  /// [OverlayPlacement.of] gives the side the tooltip was placed on.
  ///
  /// Defaults to [defaultTooltipTransitionBuilder], a fade.
  final Widget Function(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  )
  transitionBuilder;

  /// The show and hide durations and curves, passed to
  /// [NakedTooltip.animationStyle].
  ///
  /// Unset fields keep Naked UI's defaults: 150ms to show, 75ms to hide, on
  /// [Curves.fastOutSlowIn]. While the user asks to reduce motion, the tooltip
  /// shows and hides at once whatever the durations.
  final AnimationStyle animationStyle;

  /// The style factory for [RemixTooltip].
  static final styleFrom = TooltipStyler.new;

  /// The default [transitionBuilder]: fades [child] with [animation].
  static Widget defaultTooltipTransitionBuilder(
    BuildContext context,
    Animation<double> animation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }

  @override
  Widget build(BuildContext context) {
    return RemixStyleSpecBuilder<TooltipSpec>(
      style: style,
      styleSpec: styleSpec,
      builder: (context, spec) {
        return NakedTooltip(
          tooltipKey: tooltipKey,
          onOpenChanged: onOpenChanged,
          // Keyboard focus shows the tooltip; focus a closing menu or dialog
          // returns after a click does not (WAI-ARIA tooltip pattern).
          isFocusVisible: () => FocusVisibility.isVisible,
          overlayBuilder: (context, animation) => transitionBuilder(
            context,
            animation,
            Box(
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
          ),
          hoverDelay: spec.waitDuration ?? const Duration(milliseconds: 300),
          // showDuration is touch long-press wait (Material-aligned touchDelay).
          touchDelay: spec.showDuration ?? const Duration(milliseconds: 1500),
          // dismissDuration is hover-exit grace before the tooltip closes.
          dismissDelay:
              spec.dismissDuration ?? const Duration(milliseconds: 100),
          // How long after a tooltip closes hover still skips waitDuration.
          skipDelayDuration:
              spec.skipDelayDuration ?? const Duration(milliseconds: 300),
          animationStyle: animationStyle,
          positioning: positioning,
          semanticLabel: tooltipSemantics,
          child: child,
        );
      },
    );
  }
}
