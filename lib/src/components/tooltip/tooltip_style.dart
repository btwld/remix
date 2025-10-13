part of 'tooltip.dart';

class RemixTooltipStyle
    extends RemixContainerStyle<RemixTooltipSpec, RemixTooltipStyle>
    with LabelStyleMixin<RemixTooltipStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<Duration>? $waitDuration;
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
         waitDuration: waitDuration != null ? Prop.value(waitDuration) : null,
         showDuration: showDuration != null ? Prop.value(showDuration) : null,
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container padding
  RemixTooltipStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(padding: value)));
  }

  /// Sets container margin
  RemixTooltipStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(margin: value)));
  }

  /// Sets container alignment
  RemixTooltipStyle alignment(Alignment value) {
    return merge(RemixTooltipStyle(container: BoxStyler(alignment: value)));
  }

  /// Sets container background color
  RemixTooltipStyle textColor(Color value) {
    return merge(
      RemixTooltipStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  /// Sets container border radius
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
  RemixTooltipStyle decoration(DecorationMix value) {
    return merge(RemixTooltipStyle(container: BoxStyler(decoration: value)));
  }

  /// Sets the wait duration before showing tooltip
  RemixTooltipStyle waitDuration(Duration value) {
    return merge(RemixTooltipStyle(waitDuration: value));
  }

  /// Sets the show duration before hiding tooltip
  RemixTooltipStyle showDuration(Duration value) {
    return merge(RemixTooltipStyle(showDuration: value));
  }

  @override
  RemixTooltipStyle label(TextStyler value) {
    return merge(RemixTooltipStyle(label: value));
  }

  @override
  StyleSpec<RemixTooltipSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixTooltipSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        waitDuration:
            MixOps.resolve(context, $waitDuration) ??
            const Duration(milliseconds: 300),
        showDuration:
            MixOps.resolve(context, $showDuration) ??
            const Duration(milliseconds: 1500),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixTooltipStyle merge(RemixTooltipStyle? other) {
    if (other == null) return this;

    return RemixTooltipStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      waitDuration: other.$waitDuration ?? $waitDuration,
      showDuration: other.$showDuration ?? $showDuration,
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixTooltipStyle variants(List<VariantStyle<RemixTooltipSpec>> value) {
    return merge(RemixTooltipStyle(variants: value));
  }

  @override
  RemixTooltipStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTooltipStyle(modifier: value));
  }

  // Abstract method implementations for mixins

  @override
  RemixTooltipStyle animate(AnimationConfig config) {
    return merge(RemixTooltipStyle(animation: config));
  }

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

  @override
  List<Object?> get props => [
    $container,
    $label,
    $waitDuration,
    $showDuration,
    $variants,
    $animation,
    $modifier,
  ];
}
