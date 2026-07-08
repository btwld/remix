part of 'tooltip.dart';

/// Style builder for [RemixTooltip].
///
/// Use this class to style tooltip container, label, wait duration, and show
/// duration.
@MixableStyler()
class RemixTooltipStyler
    extends RemixContainerStyler<RemixTooltipSpec, RemixTooltipStyler>
    with Diagnosticable, _$RemixTooltipStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField()
  final Prop<Duration>? $waitDuration;
  @MixableField()
  final Prop<Duration>? $showDuration;
  @MixableField()
  final Prop<Duration>? $dismissDuration;

  const RemixTooltipStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<Duration>? waitDuration,
    Prop<Duration>? showDuration,
    Prop<Duration>? dismissDuration,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $waitDuration = waitDuration,
       $showDuration = showDuration,
       $dismissDuration = dismissDuration;

  RemixTooltipStyler({
    BoxStyler? container,
    TextStyler? label,
    Duration? waitDuration,
    Duration? showDuration,
    Duration? dismissDuration,
    AnimationConfig? animation,
    List<VariantStyle<RemixTooltipSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         waitDuration: Prop.maybe(waitDuration),
         showDuration: Prop.maybe(showDuration),
         dismissDuration: Prop.maybe(dismissDuration),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container alignment
  RemixTooltipStyler alignment(Alignment value) {
    return merge(RemixTooltipStyler(container: BoxStyler(alignment: value)));
  }

  /// Sets container padding
  @override
  RemixTooltipStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTooltipStyler(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  @override
  RemixTooltipStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTooltipStyler(container: BoxStyler(margin: value)));
  }

  /// Sets container background color
  @override
  RemixTooltipStyler color(Color value) {
    return merge(
      RemixTooltipStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets tooltip container background color.
  RemixTooltipStyler backgroundColor(Color value) => color(value);

  /// Sets container border radius
  @override
  RemixTooltipStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixTooltipStyler(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets container decoration
  @override
  RemixTooltipStyler decoration(DecorationMix value) {
    return merge(RemixTooltipStyler(container: BoxStyler(decoration: value)));
  }

  /// Creates a [RemixTooltip] widget with this style applied.
  RemixTooltip call({
    Key? key,
    required Widget tooltipChild,
    required Widget child,
    String? tooltipSemantics,
    OverlayPositionConfig positioning = const OverlayPositionConfig(),
  }) {
    return RemixTooltip(
      key: key,
      tooltipChild: tooltipChild,
      child: child,
      tooltipSemantics: tooltipSemantics,
      positioning: positioning,
      style: this,
    );
  }

  // Abstract method implementations for mixins

  @override
  RemixTooltipStyler constraints(BoxConstraintsMix value) {
    return merge(RemixTooltipStyler(container: BoxStyler(constraints: value)));
  }

  @override
  RemixTooltipStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTooltipStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTooltipStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTooltipStyler(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
