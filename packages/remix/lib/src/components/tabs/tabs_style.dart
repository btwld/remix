part of 'tabs.dart';

/// Style builder for [RemixTabBar].
///
/// Use this class to style the flex container that lays out tab triggers.
@MixableStyler()
class RemixTabBarStyler
    extends RemixFlexContainerStyler<RemixTabBarSpec, RemixTabBarStyler>
    with Diagnosticable, _$RemixTabBarStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;

  const RemixTabBarStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixTabBarStyler({
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
  RemixTabBarStyler alignment(Alignment value) {
    return merge(RemixTabBarStyler(container: FlexBoxStyler(alignment: value)));
  }

  @override
  RemixTabBarStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTabBarStyler(container: FlexBoxStyler(padding: value)));
  }

  @override
  RemixTabBarStyler color(Color value) {
    return merge(
      RemixTabBarStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixTabBarStyler size(double width, double height) {
    return merge(
      RemixTabBarStyler(
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
  RemixTabBarStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixTabBarStyler(
        container: FlexBoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixTabBarStyler constraints(BoxConstraintsMix value) {
    return merge(
      RemixTabBarStyler(container: FlexBoxStyler(constraints: value)),
    );
  }

  @override
  RemixTabBarStyler decoration(DecorationMix value) {
    return merge(
      RemixTabBarStyler(container: FlexBoxStyler(decoration: value)),
    );
  }

  @override
  RemixTabBarStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTabBarStyler(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixTabBarStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTabBarStyler(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTabBarStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTabBarStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixTabBarStyler flex(FlexStyler value) {
    return merge(RemixTabBarStyler(container: FlexBoxStyler().flex(value)));
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
class RemixTabViewStyler
    extends RemixContainerStyler<RemixTabViewSpec, RemixTabViewStyler>
    with
        SelectedWidgetStateVariantMixin<RemixTabViewSpec, RemixTabViewStyler>,
        Diagnosticable,
        _$RemixTabViewStylerMixin {
  @MixableField(setterType: BoxStyler)
  final Prop<StyleSpec<BoxSpec>>? $container;

  const RemixTabViewStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container;

  RemixTabViewStyler({
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
  RemixTabViewStyler alignment(Alignment value) {
    return merge(RemixTabViewStyler(container: BoxStyler(alignment: value)));
  }

  @override
  RemixTabViewStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTabViewStyler(container: BoxStyler(padding: value)));
  }

  @override
  RemixTabViewStyler color(Color value) {
    return merge(
      RemixTabViewStyler(
        container: BoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixTabViewStyler borderRadius(BorderRadiusGeometryMix radius) {
    return merge(
      RemixTabViewStyler(
        container: BoxStyler(
          decoration: BoxDecorationMix(borderRadius: radius),
        ),
      ),
    );
  }

  @override
  RemixTabViewStyler constraints(BoxConstraintsMix value) {
    return merge(RemixTabViewStyler(container: BoxStyler(constraints: value)));
  }

  @override
  RemixTabViewStyler decoration(DecorationMix value) {
    return merge(RemixTabViewStyler(container: BoxStyler(decoration: value)));
  }

  @override
  RemixTabViewStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTabViewStyler(container: BoxStyler(margin: value)));
  }

  @override
  RemixTabViewStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTabViewStyler(container: BoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTabViewStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTabViewStyler(
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
class RemixTabStyler
    extends RemixFlexContainerStyler<RemixTabSpec, RemixTabStyler>
    with
        LabelStyleMixin<RemixTabStyler>,
        IconStyleMixin<RemixTabStyler>,
        SelectedWidgetStateVariantMixin<RemixTabSpec, RemixTabStyler>,
        Diagnosticable,
        _$RemixTabStylerMixin {
  @MixableField(setterType: FlexBoxStyler)
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  @MixableField(setterType: TextStyler)
  final Prop<StyleSpec<TextSpec>>? $label;
  @MixableField(setterType: IconStyler)
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixTabStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.animation,
    super.modifier,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixTabStyler({
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
  RemixTabStyler alignment(Alignment value) {
    return merge(RemixTabStyler(container: FlexBoxStyler(alignment: value)));
  }

  // Mixin implementations - delegate to container
  @override
  RemixTabStyler flex(FlexStyler value) {
    return merge(RemixTabStyler(container: FlexBoxStyler().flex(value)));
  }

  @override
  RemixTabStyler foregroundDecoration(DecorationMix value) {
    return merge(
      RemixTabStyler(container: FlexBoxStyler(foregroundDecoration: value)),
    );
  }

  @override
  RemixTabStyler transform(
    Matrix4 value, {
    AlignmentGeometry alignment = Alignment.center,
  }) {
    return merge(
      RemixTabStyler(
        container: FlexBoxStyler(
          transform: value,
          transformAlignment: alignment,
        ),
      ),
    );
  }

  @override
  RemixTabStyler color(Color value) {
    return merge(
      RemixTabStyler(
        container: FlexBoxStyler(decoration: BoxDecorationMix(color: value)),
      ),
    );
  }

  @override
  RemixTabStyler constraints(BoxConstraintsMix value) {
    return merge(RemixTabStyler(container: FlexBoxStyler(constraints: value)));
  }

  @override
  RemixTabStyler decoration(DecorationMix value) {
    return merge(RemixTabStyler(container: FlexBoxStyler(decoration: value)));
  }

  @override
  RemixTabStyler margin(EdgeInsetsGeometryMix value) {
    return merge(RemixTabStyler(container: FlexBoxStyler(margin: value)));
  }

  @override
  RemixTabStyler padding(EdgeInsetsGeometryMix value) {
    return merge(RemixTabStyler(container: FlexBoxStyler(padding: value)));
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
