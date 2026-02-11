part of 'tooltip.dart';

@MixableStyler()
class RemixTooltipStyle
    extends RemixContainerStyle<RemixTooltipSpec, RemixTooltipStyle>
    with Diagnosticable, _$RemixTooltipStyleMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField()
  final Prop<Duration>? $waitDuration;
  @MixableField()
  final Prop<Duration>? $showDuration;

  const RemixTooltipStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<Duration>? waitDuration,
    Prop<Duration>? showDuration,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $waitDuration = waitDuration,
       $showDuration = showDuration;

  RemixTooltipStyle({
    BoxStyler? container,
    TextStyler? label,
    Duration? waitDuration,
    Duration? showDuration,
    AnimationConfig? animation,
    List<VariantStyle<RemixTooltipSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         waitDuration: Prop.maybe(waitDuration),
         showDuration: Prop.maybe(showDuration),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container padding
  @override
  RemixTooltipStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  @override
  RemixTooltipStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixTooltipStyle alignment(Alignment value) {
    return merge(RemixTooltipStyle(container: BoxStyler(alignment: value)));
  }

  /// Sets container background color
  @override
  RemixTooltipStyle color(Color value) {
    return merge(
      RemixTooltipStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets container border radius
  @override
  RemixTooltipStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixTooltipStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets container decoration
  @override
  RemixTooltipStyle decoration(DecorationMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(decoration: value)));
  }

  // Abstract method implementations for mixins

  @override
  RemixTooltipStyle constraints(BoxConstraintsMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixTooltipStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTooltipStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTooltipStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTooltipStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }
}
