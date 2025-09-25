part of 'radio.dart';

class RemixRadioStyle extends RemixContainerStyle<RemixRadioSpec, RemixRadioStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $indicatorContainer;
  final Prop<StyleSpec<BoxSpec>>? $indicator;

  const RemixRadioStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? indicatorContainer,
    Prop<StyleSpec<BoxSpec>>? indicator,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $indicatorContainer = indicatorContainer,
        $indicator = indicator;

  RemixRadioStyle({
    BoxStyler? container,
    BoxStyler? indicatorContainer,
    BoxStyler? indicator,
    AnimationConfig? animation,
    List<VariantStyle<RemixRadioSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          indicatorContainer: Prop.maybeMix(indicatorContainer),
          indicator: Prop.maybeMix(indicator),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets outer container styling.
  RemixRadioStyle container(BoxStyler value) {
    return merge(RemixRadioStyle(container: value));
  }

  /// Sets indicator container styling (outer ring).
  RemixRadioStyle indicatorContainer(BoxStyler value) {
    return merge(RemixRadioStyle(indicatorContainer: value));
  }

  /// Sets indicator styling (selected fill).
  RemixRadioStyle indicator(BoxStyler value) {
    return merge(RemixRadioStyle(indicator: value));
  }

  /// Convenience for applying padding around the control.
  @override
  RemixRadioStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixRadioStyle(container: BoxStyler(padding: value)));
  }

  /// Convenience for applying margin around the control.
  @override
  RemixRadioStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixRadioStyle(container: BoxStyler(margin: value)));
  }

  /// Sets background color on the indicator container.
  @override
  RemixRadioStyle color(Color value) {
    return merge(
      RemixRadioStyle(
        indicatorContainer: BoxStyler(
          decoration: BoxDecorationMix(color: value),
        ),
      ),
    );
  }

  /// Sets indicator size using explicit constraints.
  @override
  RemixRadioStyle size(double width, double height) {
    return merge(
      RemixRadioStyle(
        indicatorContainer: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: width,
            maxWidth: width,
            minHeight: height,
            maxHeight: height,
          ),
        ),
      ),
    );
  }

  /// Sets border radius on the outer container.
  @override
  RemixRadioStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixRadioStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets animation configuration.
  @override
  RemixRadioStyle animate(AnimationConfig animation) {
    return merge(RemixRadioStyle(animation: animation));
  }

  @override
  RemixRadioStyle variants(List<VariantStyle<RemixRadioSpec>> value) {
    return merge(RemixRadioStyle(variants: value));
  }

  @override
  RemixRadioStyle wrap(WidgetModifierConfig value) {
    return merge(RemixRadioStyle(modifier: value));
  }

  @override
  RemixRadioStyle constraints(BoxConstraintsMix value) {
    return merge(RemixRadioStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixRadioStyle decoration(DecorationMix value) {
    return merge(RemixRadioStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixRadioStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixRadioStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixRadioStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixRadioStyle(
        container: BoxStyler(alignment: alignment, transform: value),
      ),
    );
  }

  @override
  StyleSpec<RemixRadioSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixRadioSpec(
        container: MixOps.resolve(context, $container),
        indicatorContainer: MixOps.resolve(context, $indicatorContainer),
        indicator: MixOps.resolve(context, $indicator),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixRadioStyle merge(RemixRadioStyle? other) {
    if (other == null) return this;

    return RemixRadioStyle.create(
      container: MixOps.merge($container, other.$container),
      indicatorContainer:
          MixOps.merge($indicatorContainer, other.$indicatorContainer),
      indicator: MixOps.merge($indicator, other.$indicator),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $indicatorContainer,
        $indicator,
        $variants,
        $animation,
        $modifier,
      ];
}
