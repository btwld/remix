part of 'tabs.dart';

/// Style builder for [RemixTabBar].
///
/// Use this class to style the flex container that lays out tab triggers.
@MixableStyler()
class RemixTabBarStyle
    extends RemixFlexContainerStyle<RemixTabBarSpec, RemixTabBarStyle>
    with Diagnosticable, _$RemixTabBarStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
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

  /// Sets container alignment
  RemixTabBarStyle alignment(Alignment value) {
    return merge(RemixTabBarStyle(container: FlexBoxStyler(alignment: value)));
  }

  @override
  RemixTabBarStyle padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTabBarStyle(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixTabBarStyle color(Color value) {
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
    return merge(RemixTabBarStyle(container: FlexBoxStyler().flex(value)));
  }

  /// Creates a [RemixTabBar] widget with this style applied.
  RemixTabBar call({Key? key, required Widget child}) {
    return RemixTabBar(key: key, child: child, style: this);
  }
}

/// Style builder for [RemixTabView].
///
/// Use this class to style the content container associated with a selected
/// tab.
@MixableStyler()
class RemixTabViewStyle
    extends RemixContainerStyle<RemixTabViewSpec, RemixTabViewStyle>
    with
        SelectedWidgetStateVariantMixin<RemixTabViewSpec, RemixTabViewStyle>,
        Diagnosticable,
        _$RemixTabViewStyleMixin {
  @MixableField(setterType: BoxStyler)
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
  RemixTabViewStyle color(Color value) {
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

  /// Creates a [RemixTabView] widget with this style applied.
  RemixTabView call({Key? key, required String tabId, required Widget child}) {
    return RemixTabView(key: key, tabId: tabId, child: child, style: this);
  }
}

/// Style builder for [RemixTab].
///
/// Use this class to style an individual tab trigger, including its container,
/// label, icon, and selected state.
@MixableStyler()
class RemixTabStyle extends RemixFlexContainerStyle<RemixTabSpec, RemixTabStyle>
    with
        LabelStyleMixin<RemixTabStyle>,
        IconStyleMixin<RemixTabStyle>,
        SelectedWidgetStateVariantMixin<RemixTabSpec, RemixTabStyle>,
        Diagnosticable,
        _$RemixTabStyleMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
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

  // Mixin implementations - delegate to container
  @override
  RemixTabStyle flex(FlexStyler value) {
    return merge(RemixTabStyle(container: FlexBoxStyler().flex(value)));
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
  RemixTabStyle color(Color value) {
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

  /// Creates a [RemixTab] widget with this style applied.
  RemixTab call({
    Key? key,
    required String tabId,
    Widget? child,
    String? label,
    IconData? icon,
    bool enabled = true,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    bool enableFeedback = true,
    FocusNode? focusNode,
    bool autofocus = false,
    ValueChanged<bool>? onFocusChange,
    ValueChanged<bool>? onHoverChange,
    ValueChanged<bool>? onPressChange,
    ValueWidgetBuilder<NakedTabState>? builder,
    String? semanticLabel,
  }) {
    return RemixTab(
      key: key,
      tabId: tabId,
      child: child,
      label: label,
      icon: icon,
      enabled: enabled,
      mouseCursor: mouseCursor,
      enableFeedback: enableFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      onFocusChange: onFocusChange,
      onHoverChange: onHoverChange,
      onPressChange: onPressChange,
      builder: builder,
      semanticLabel: semanticLabel,
      style: this,
    );
  }
}
