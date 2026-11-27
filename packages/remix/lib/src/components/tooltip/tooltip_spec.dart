part of 'tooltip.dart';

/// Wraps a tooltip's styled surface in a transition; see
/// [RemixTooltip.transitionBuilder].
typedef RemixTooltipTransitionBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Widget child,
    );

/// Resolved visual values for a [RemixTooltip].
///
/// [transitionBuilder], [animationStyle], and [positioning] let a style set
/// what the widget parameters of the same names set. A widget argument wins;
/// one left at its default lets the style decide.
@MixableSpec(target: RemixTooltip.new, extraStylerMixins: [RemixBoxStylerMixin])
class TooltipSpec with _$TooltipSpec {
  @override
  @MixableField(forwardStyler: true)
  final StyleSpec<BoxSpec> container;
  @override
  final StyleSpec<TextSpec> label;
  @override
  final Duration? waitDuration;
  @override
  final Duration? showDuration;
  @override
  final Duration? dismissDuration;
  @override
  final Duration? skipDelayDuration;

  /// The transition around the styled surface. `null` fades it.
  @override
  final RemixTooltipTransitionBuilder? transitionBuilder;

  /// The show and hide durations and curves.
  ///
  /// Each field of [RemixTooltip.animationStyle] that is set overrides the
  /// same field here.
  @override
  final AnimationStyle? animationStyle;

  /// Where the tooltip sits relative to its trigger.
  ///
  /// Used while [RemixTooltip.positioning] keeps its default.
  @override
  final OverlayPositionConfig? positioning;

  const TooltipSpec({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    this.waitDuration = const Duration(milliseconds: 300),
    this.showDuration = const Duration(milliseconds: 1500),
    this.dismissDuration = const Duration(milliseconds: 100),
    this.skipDelayDuration = const Duration(milliseconds: 300),
    this.transitionBuilder,
    this.animationStyle,
    this.positioning,
  }) : container = container ?? const StyleSpec(spec: BoxSpec()),
       label = label ?? const StyleSpec(spec: TextSpec());
}

/// Backward-compatible name for [TooltipSpec].
///
/// The generated style API is based on [TooltipSpec], so resolved values use
/// `TooltipSpec` as their runtime type.
typedef RemixTooltipSpec = TooltipSpec;
