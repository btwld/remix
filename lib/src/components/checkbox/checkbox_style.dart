part of 'checkbox.dart';

class RemixCheckboxStyle
    extends RemixContainerStyle<RemixCheckboxSpec, RemixCheckboxStyle>
    with IconStyleMixin<RemixCheckboxStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<IconSpec>>? $indicator;

  const RemixCheckboxStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<IconSpec>>? indicator,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $indicator = indicator;

  RemixCheckboxStyle({
    BoxStyler? container,
    IconStyler? indicator,
    AnimationConfig? animation,
    List<VariantStyle<RemixCheckboxSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          indicator: Prop.maybeMix(indicator),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  /// Sets checkbox size by constraining the container.
  RemixCheckboxStyle checkboxSize(double value) {
    return merge(
      RemixCheckboxStyle(
        container: BoxStyler(
          constraints: BoxConstraintsMix(
            minWidth: value,
            maxWidth: value,
            minHeight: value,
            maxHeight: value,
          ),
        ),
      ),
    );
  }

  /// Sets checkbox border radius on the container.
  RemixCheckboxStyle checkboxBorderRadius(double radius) {
    return merge(
      RemixCheckboxStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(
            borderRadius: BorderRadiusMix.circular(radius),
          ),
        ),
      ),
    );
  }

  /// Sets checkbox border on the container.
  RemixCheckboxStyle border(BoxBorderMix value) {
    return merge(
      RemixCheckboxStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(border: value),
        ),
      ),
    );
  }

  /// Sets indicator color.
  RemixCheckboxStyle indicatorColor(Color value) {
    return merge(RemixCheckboxStyle(indicator: IconStyler(color: value)));
  }

  /// Sets the container styling.
  RemixCheckboxStyle container(BoxStyler value) {
    return merge(RemixCheckboxStyle(container: value));
  }

  /// Sets container alignment.
  RemixCheckboxStyle alignment(Alignment value) {
    return merge(RemixCheckboxStyle(container: BoxStyler(alignment: value)));
  }

  @override
  RemixCheckboxStyle icon(IconStyler value) {
    return merge(RemixCheckboxStyle(indicator: value));
  }

  /// Sets container padding.
  @override
  RemixCheckboxStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixCheckboxStyle(container: BoxStyler(padding: value)));
  }

  /// Sets checkbox background color on the container.
  @override
  RemixCheckboxStyle color(Color value) {
    return merge(
      RemixCheckboxStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(color: value),
        ),
      ),
    );
  }

  /// Sets checkbox size with separate width and height.
  @override
  RemixCheckboxStyle size(double width, double height) {
    return merge(
      RemixCheckboxStyle(
        container: BoxStyler(
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
  RemixCheckboxStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixCheckboxStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  /// Sets animation configuration.
  @override
  RemixCheckboxStyle animate(AnimationConfig animation) {
    return merge(RemixCheckboxStyle(animation: animation));
  }

  @override
  RemixCheckboxStyle variants(List<VariantStyle<RemixCheckboxSpec>> value) {
    return merge(RemixCheckboxStyle(variants: value));
  }

  @override
  RemixCheckboxStyle wrap(WidgetModifierConfig value) {
    return merge(RemixCheckboxStyle(modifier: value));
  }

  @override
  RemixCheckboxStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixCheckboxStyle(container: BoxStyler(constraints: value)),
    );
  }

  @override
  RemixCheckboxStyle decoration(DecorationMix value) {
    return merge(
      RemixCheckboxStyle(container: BoxStyler(decoration: value)),
    );
  }

  @override
  RemixCheckboxStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixCheckboxStyle(container: BoxStyler(margin: value)));
  }

  @override
  RemixCheckboxStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixCheckboxStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixCheckboxStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixCheckboxStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  @override
  StyleSpec<RemixCheckboxSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixCheckboxSpec(
        container: MixOps.resolve(context, $container),
        indicator: MixOps.resolve(context, $indicator),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixCheckboxStyle merge(RemixCheckboxStyle? other) {
    if (other == null) return this;

    return RemixCheckboxStyle.create(
      container: MixOps.merge($container, other.$container),
      indicator: MixOps.merge($indicator, other.$indicator),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  List<Object?> get props => [
        $container,
        $indicator,
        $variants,
        $animation,
        $modifier,
      ];
}
