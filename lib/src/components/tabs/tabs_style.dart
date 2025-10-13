part of 'tabs.dart';

class RemixTabBarStyle
    extends RemixFlexContainerStyle<RemixTabBarSpec, RemixTabBarStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;

  const RemixTabBarStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixTabBarStyle({
    FlexBoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<RemixTabBarSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  RemixTabBarStyle container(FlexBoxStyler value) {
    return merge(RemixTabBarStyle(container: value));
  }

  /// Sets container alignment
  RemixTabBarStyle alignment(Alignment value) {
    return merge(RemixTabBarStyle(container: FlexBoxStyler(alignment: value)));
  }

  @override
  RemixTabBarStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTabBarStyle(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixTabBarStyle textColor(Color value) {
    return merge(
      RemixTabBarStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixTabBarStyle size(double width, double height) {
    return merge(
      RemixTabBarStyle(
        container: FlexBoxStyler(
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

  @override
  RemixTabBarStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixTabBarStyle(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixTabBarStyle constraints(BoxConstraintsMix value) {
    return merge(
      RemixTabBarStyle(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixTabBarStyle decoration(DecorationMix value) {
    return merge(RemixTabBarStyle(container: FlexBoxStyler(decoration: value)));
  }

  @override
  RemixTabBarStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTabBarStyle(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixTabBarStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTabBarStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTabBarStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTabBarStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixTabBarStyle flex(FlexStyler value) {
    return merge(RemixTabBarStyle(container: FlexBoxStyler()));
  }

  @override
  StyleSpec<RemixTabBarSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixTabBarSpec(container: MixOps.resolve(context, $container)),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixTabBarStyle merge(RemixTabBarStyle? other) {
    if (other == null) return this;

    return RemixTabBarStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixTabBarStyle variants(List<VariantStyle<RemixTabBarSpec>> value) {
    return merge(RemixTabBarStyle(variants: value));
  }

  @override
  RemixTabBarStyle animate(AnimationConfig animation) {
    return merge(RemixTabBarStyle(animation: animation));
  }

  @override
  RemixTabBarStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTabBarStyle(modifier: value));
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}

class RemixTabViewStyle
    extends RemixContainerStyle<RemixTabViewSpec, RemixTabViewStyle> {
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixTabViewStyle.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixTabViewStyle({
    BoxStyler? container,
    AnimationConfig? animation,
    List<VariantStyle<RemixTabViewSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container alignment
  RemixTabViewStyle alignment(Alignment value) {
    return merge(RemixTabViewStyle(container: BoxStyler(alignment: value)));
  }

  @override
  RemixTabViewStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTabViewStyle(container: BoxStyler(padding: value)));
  }

  @override
  RemixTabViewStyle textColor(Color value) {
    return merge(
      RemixTabViewStyle(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixTabViewStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixTabViewStyle(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixTabViewStyle constraints(BoxConstraintsMix value) {
    return merge(RemixTabViewStyle(container: BoxStyler(constraints: value)));
  }

  @override
  RemixTabViewStyle decoration(DecorationMix value) {
    return merge(RemixTabViewStyle(container: BoxStyler(decoration: value)));
  }

  @override
  RemixTabViewStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTabViewStyle(container: BoxStyler(margin: value)));
  }

  @override
  RemixTabViewStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTabViewStyle(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTabViewStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTabViewStyle(
        container: BoxStyler(transform: value, transformAlignment: alignment),
      ),
    );
  }

  @override
  StyleSpec<RemixTabViewSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixTabViewSpec(container: MixOps.resolve(context, $container)),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixTabViewStyle merge(RemixTabViewStyle? other) {
    if (other == null) return this;

    return RemixTabViewStyle.create(
      container: MixOps.merge($container, other.$container),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixTabViewStyle variants(List<VariantStyle<RemixTabViewSpec>> value) {
    return merge(RemixTabViewStyle(variants: value));
  }

  @override
  RemixTabViewStyle animate(AnimationConfig animation) {
    return merge(RemixTabViewStyle(animation: animation));
  }

  @override
  RemixTabViewStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTabViewStyle(modifier: value));
  }

  @override
  List<Object?> get props => [$container, $variants, $animation, $modifier];
}

class RemixTabStyle extends RemixFlexContainerStyle<RemixTabSpec, RemixTabStyle>
    with LabelStyleMixin<RemixTabStyle>, IconStyleMixin<RemixTabStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixTabStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixTabStyle({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    List<VariantStyle<RemixTabSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         variants: variants,
         animation: animation,
         modifier: modifier,
       );

  /// Sets container alignment
  RemixTabStyle alignment(Alignment value) {
    return merge(RemixTabStyle(container: FlexBoxStyler(alignment: value)));
  }

  @override
  RemixTabStyle label(TextStyler value) {
    return merge(RemixTabStyle(label: value));
  }

  @override
  RemixTabStyle icon(IconStyler value) {
    return merge(RemixTabStyle(icon: value));
  }

  @override
  StyleSpec<RemixTabSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixTabSpec(
        container: MixOps.resolve(context, $container),
        label: MixOps.resolve(context, $label),
        icon: MixOps.resolve(context, $icon),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixTabStyle merge(RemixTabStyle? other) {
    if (other == null) return this;

    return RemixTabStyle.create(
      container: MixOps.merge($container, other.$container),
      label: MixOps.merge($label, other.$label),
      icon: MixOps.merge($icon, other.$icon),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixTabStyle animate(AnimationConfig animation) {
    return merge(RemixTabStyle(animation: animation));
  }

  @override
  RemixTabStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTabStyle(modifier: value));
  }

  @override
  RemixTabStyle variants(List<VariantStyle<RemixTabSpec>> value) {
    return merge(RemixTabStyle(variants: value));
  }

  // Mixin implementations - delegate to container
  @override
  RemixTabStyle flex(FlexStyler value) {
    return merge(RemixTabStyle(container: FlexBoxStyler()));
  }

  @override
  RemixTabStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTabStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTabStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTabStyle(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixTabStyle textColor(Color value) {
    return merge(
      RemixTabStyle(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixTabStyle constraints(BoxConstraintsMix value) {
    return merge(RemixTabStyle(container: FlexBoxStyler(constraints: value)));
  }

  @override
  RemixTabStyle decoration(DecorationMix value) {
    return merge(RemixTabStyle(container: FlexBoxStyler(decoration: value)));
  }

  @override
  RemixTabStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTabStyle(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixTabStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTabStyle(container: FlexBoxStyler(padding: value)));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $icon,
    $variants,
    $animation,
    $modifier,
  ];
}
