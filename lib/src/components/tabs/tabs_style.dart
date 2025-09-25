part of 'tabs.dart';

class RemixTabsStyle extends RemixStyle<TabsSpec, RemixTabsStyle> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TabSpec>>? $tab;
  final Prop<StyleSpec<BoxSpec>>? $tabView;

  const RemixTabsStyle.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TabSpec>>? tab,
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
    List<VariantStyle<TabsSpec>>? variants,
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

  @override
  StyleSpec<TabsSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: TabsSpec(
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
  RemixTabsStyle variants(List<VariantStyle<TabsSpec>> value) {
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

class RemixTabStyle extends RemixFlexContainerStyle<TabSpec, RemixTabStyle>
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
    List<VariantStyle<TabSpec>>? variants,
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
  StyleSpec<TabSpec> resolve(BuildContext context) {
    return StyleSpec(
      spec: TabSpec(
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
  RemixTabStyle variants(List<VariantStyle<TabSpec>> value) {
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
      container: FlexBoxStyler(alignment: alignment, transform: value),
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
    return merge(RemixTabStyle(
      container: FlexBoxStyler(constraints: value),
    ));
  }

  @override
  RemixTabStyle decoration(DecorationMix value) {
    return merge(RemixTabStyle(
      container: FlexBoxStyler(decoration: value),
    ));
  }

  @override
  RemixTabStyle margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTabStyle(
      container: FlexBoxStyler(margin: value),
    ));
  }

  @override
  RemixTabStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTabStyle(
      container: FlexBoxStyler(padding: value),
    ));
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