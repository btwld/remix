part of 'tabs.dart';

class RemixTabsStyle
    extends RemixFlexContainerStyle<RemixTabsSpec, RemixTabsStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<RemixTabSpec>>? $tab;
  final Prop<StyleSpec<BoxSpec>>? $tabView;

  const RemixTabsStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<RemixTabSpec>>? tab,
    Prop<StyleSpec<BoxSpec>>? tabView,
    super.variants,
    super.animation,
    super.modifier,
  })  : $container = container,
        $tab = tab,
        $tabView = tabView;

  RemixTabsStyle({
    FlexBoxStyler? container,
    RemixTabStyle? tab,
    BoxStyler? tabView,
    AnimationConfig? animation,
    List<VariantStyle<RemixTabsSpec>>? variants,
    WidgetModifierConfig? modifier,
  }) : this.create(
          container: Prop.maybeMix(container),
          tab: Prop.maybeMix(tab),
          tabView: Prop.maybeMix(tabView),
          variants: variants,
          animation: animation,
          modifier: modifier,
        );

  RemixTabsStyle container(FlexBoxStyler value) {
    return merge(RemixTabsStyle(container: value));
  }

  RemixTabsStyle tab(RemixTabStyle value) {
    return merge(RemixTabsStyle(tab: value));
  }

  RemixTabsStyle tabView(BoxStyler value) {
    return merge(RemixTabsStyle(tabView: value));
  }

  // RemixFlexContainerStyle mixin implementations
  @override
  RemixTabsStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTabsStyle(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixTabsStyle color(Color value) {
    return merge(RemixTabsStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
  }

  @override
  RemixTabsStyle size(double width, double height) {
    return merge(RemixTabsStyle(
      container: FlexBoxStyler(
        constraints: BoxConstraintsMix(
          minWidth: width,
          maxWidth: width,
          minHeight: height,
          maxHeight: height,
        ),
      ),
    ));
  }

  @override
  RemixTabsStyle borderRadius(BorderRadiusGeometryMix radius) {
    return merge(RemixTabsStyle(
      container:
          FlexBoxStyler(decoration: BoxDecorationMix(borderRadius: radius)),
    ));
  }

  @override
  RemixTabsStyle constraints(BoxConstraintsMix value) {
    return merge(RemixTabsStyle(container: FlexBoxStyler(constraints: value)));
  }

  @override
  RemixTabsStyle decoration(DecorationMix value) {
    return merge(RemixTabsStyle(container: FlexBoxStyler(decoration: value)));
  }

  @override
  RemixTabsStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTabsStyle(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixTabsStyle foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTabsStyle(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTabsStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixTabsStyle(
      container: FlexBoxStyler(transform: value, transformAlignment: alignment),
    ));
  }

  @override
  RemixTabsStyle flex(FlexStyler value) {
    return merge(RemixTabsStyle(container: FlexBoxStyler()));
  }

  @override
  StyleSpec<RemixTabsSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: RemixTabsSpec(
        container: MixOps.resolve(context, $container),
        tab: MixOps.resolve(context, $tab),
        tabView: MixOps.resolve(context, $tabView),
      ),
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  RemixTabsStyle merge(RemixTabsStyle? other) {
    if (other == null) return this;

    return RemixTabsStyle.create(
      container: MixOps.merge($container, other.$container),
      tab: MixOps.merge($tab, other.$tab),
      tabView: MixOps.merge($tabView, other.$tabView),
      variants: MixOps.mergeVariants($variants, other.$variants),
      animation: MixOps.mergeAnimation($animation, other.$animation),
      modifier: MixOps.mergeModifier($modifier, other.$modifier),
    );
  }

  @override
  RemixTabsStyle variants(List<VariantStyle<RemixTabsSpec>> value) {
    return merge(RemixTabsStyle(variants: value));
  }

  @override
  RemixTabsStyle animate(AnimationConfig animation) {
    return merge(RemixTabsStyle(animation: animation));
  }

  @override
  RemixTabsStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTabsStyle(modifier: value));
  }

  @override
  List<Object?> get props => [
        $container,
        $tab,
        $tabView,
        $variants,
        $animation,
        $modifier,
      ];
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
  })  : $container = container,
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

  RemixTabStyle container(FlexBoxStyler value) {
    return merge(RemixTabStyle(container: value));
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
    return merge(RemixTabStyle(
      container: FlexBoxStyler(foregroundDecoration: value),
    ));
  }

  @override
  RemixTabStyle transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(RemixTabStyle(
      container: FlexBoxStyler(transform: value, transformAlignment: alignment),
    ));
  }

  @override
  RemixTabStyle color(Color value) {
    return merge(RemixTabStyle(
      container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
    ));
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
