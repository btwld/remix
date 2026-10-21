// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_bar.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AppBarSpec implements Spec<AppBarSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<BoxSpec> get toolbar;
  StyleSpec<TextSpec> get title;
  StyleSpec<FlexBoxSpec> get actions;
  StyleSpec<BoxSpec> get bottom;
  double? get toolbarHeight;
  double? get spacing;

  @override
  Type get type => AppBarSpec;

  @override
  AppBarSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? toolbar,
    StyleSpec<TextSpec>? title,
    StyleSpec<FlexBoxSpec>? actions,
    StyleSpec<BoxSpec>? bottom,
    double? toolbarHeight,
    double? spacing,
  }) {
    return AppBarSpec(
      container: container ?? this.container,
      toolbar: toolbar ?? this.toolbar,
      title: title ?? this.title,
      actions: actions ?? this.actions,
      bottom: bottom ?? this.bottom,
      toolbarHeight: toolbarHeight ?? this.toolbarHeight,
      spacing: spacing ?? this.spacing,
    );
  }

  @override
  AppBarSpec lerp(AppBarSpec? other, double t) {
    return AppBarSpec(
      container: container.lerp(other?.container, t),
      toolbar: toolbar.lerp(other?.toolbar, t),
      title: title.lerp(other?.title, t),
      actions: actions.lerp(other?.actions, t),
      bottom: bottom.lerp(other?.bottom, t),
      toolbarHeight: MixOps.lerp(toolbarHeight, other?.toolbarHeight, t),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    toolbar,
    title,
    actions,
    bottom,
    toolbarHeight,
    spacing,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppBarSpec &&
            runtimeType == other.runtimeType &&
            propsEquals(props, other.props);
  }

  @override
  int get hashCode => propsHash(runtimeType, props);

  @override
  bool get stringify => true;

  @override
  Map<String, String> getDiff(Equatable other) {
    if (this == other) return const {};

    return propsDiff(props, other.props);
  }

  @override
  String toStringShort() => '$runtimeType';

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) =>
      toDiagnosticsNode(
        style: DiagnosticsTreeStyle.singleLine,
      ).toString(minLevel: minLevel);

  @override
  DiagnosticsNode toDiagnosticsNode({
    String? name,
    DiagnosticsTreeStyle? style,
  }) =>
      DiagnosticableNode<Diagnosticable>(name: name, value: this, style: style);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('toolbar', toolbar))
      ..add(DiagnosticsProperty('title', title))
      ..add(DiagnosticsProperty('actions', actions))
      ..add(DiagnosticsProperty('bottom', bottom))
      ..add(DoubleProperty('toolbarHeight', toolbarHeight))
      ..add(DoubleProperty('spacing', spacing));
  }
}

@Deprecated(
  'Rename to `_\$AppBarSpec` and migrate the class declaration to `class AppBarSpec with _\$AppBarSpec`. The `_\$AppBarSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AppBarSpecMethods = _$AppBarSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AppBarStyler extends MixStyler<AppBarStyler, AppBarSpec>
    with RemixBoxStylerMixin<AppBarStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $toolbar;
  final Prop<StyleSpec<TextSpec>>? $title;
  final Prop<StyleSpec<FlexBoxSpec>>? $actions;
  final Prop<StyleSpec<BoxSpec>>? $bottom;
  final Prop<double>? $toolbarHeight;
  final Prop<double>? $spacing;

  const AppBarStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? toolbar,
    Prop<StyleSpec<TextSpec>>? title,
    Prop<StyleSpec<FlexBoxSpec>>? actions,
    Prop<StyleSpec<BoxSpec>>? bottom,
    Prop<double>? toolbarHeight,
    Prop<double>? spacing,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $toolbar = toolbar,
       $title = title,
       $actions = actions,
       $bottom = bottom,
       $toolbarHeight = toolbarHeight,
       $spacing = spacing;

  AppBarStyler({
    BoxStyler? container,
    BoxStyler? toolbar,
    TextStyler? title,
    FlexBoxStyler? actions,
    BoxStyler? bottom,
    double? toolbarHeight,
    double? spacing,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AppBarSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         toolbar: Prop.maybeMix(toolbar),
         title: Prop.maybeMix(title),
         actions: Prop.maybeMix(actions),
         bottom: Prop.maybeMix(bottom),
         toolbarHeight: Prop.maybe(toolbarHeight),
         spacing: Prop.maybe(spacing),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AppBarStyler.container(BoxStyler value) =>
      AppBarStyler().container(value);
  factory AppBarStyler.toolbar(BoxStyler value) =>
      AppBarStyler().toolbar(value);
  factory AppBarStyler.title(TextStyler value) => AppBarStyler().title(value);
  factory AppBarStyler.actions(FlexBoxStyler value) =>
      AppBarStyler().actions(value);
  factory AppBarStyler.bottom(BoxStyler value) => AppBarStyler().bottom(value);
  factory AppBarStyler.toolbarHeight(double value) =>
      AppBarStyler().toolbarHeight(value);
  factory AppBarStyler.spacing(double value) => AppBarStyler().spacing(value);
  factory AppBarStyler.alignment(AlignmentGeometry value) =>
      AppBarStyler().alignment(value);
  factory AppBarStyler.padding(EdgeInsetsGeometryMix value) =>
      AppBarStyler().padding(value);
  factory AppBarStyler.margin(EdgeInsetsGeometryMix value) =>
      AppBarStyler().margin(value);
  factory AppBarStyler.constraints(BoxConstraintsMix value) =>
      AppBarStyler().constraints(value);
  factory AppBarStyler.decoration(DecorationMix value) =>
      AppBarStyler().decoration(value);
  factory AppBarStyler.foregroundDecoration(DecorationMix value) =>
      AppBarStyler().foregroundDecoration(value);
  factory AppBarStyler.clipBehavior(Clip value) =>
      AppBarStyler().clipBehavior(value);
  factory AppBarStyler.color(Color value) => AppBarStyler().color(value);
  factory AppBarStyler.gradient(GradientMix value) =>
      AppBarStyler().gradient(value);
  factory AppBarStyler.border(BoxBorderMix value) =>
      AppBarStyler().border(value);
  factory AppBarStyler.borderRadius(BorderRadiusGeometryMix value) =>
      AppBarStyler().borderRadius(value);
  factory AppBarStyler.elevation(ElevationShadow value) =>
      AppBarStyler().elevation(value);
  factory AppBarStyler.shadow(BoxShadowMix value) =>
      AppBarStyler().shadow(value);
  factory AppBarStyler.shadows(List<BoxShadowMix> value) =>
      AppBarStyler().shadows(value);
  factory AppBarStyler.width(double value) => AppBarStyler().width(value);
  factory AppBarStyler.height(double value) => AppBarStyler().height(value);
  factory AppBarStyler.size(double width, double height) =>
      AppBarStyler().size(width, height);
  factory AppBarStyler.minWidth(double value) => AppBarStyler().minWidth(value);
  factory AppBarStyler.maxWidth(double value) => AppBarStyler().maxWidth(value);
  factory AppBarStyler.minHeight(double value) =>
      AppBarStyler().minHeight(value);
  factory AppBarStyler.maxHeight(double value) =>
      AppBarStyler().maxHeight(value);
  factory AppBarStyler.scale(double scale, {Alignment alignment = .center}) =>
      AppBarStyler().scale(scale, alignment: alignment);
  factory AppBarStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => AppBarStyler().rotate(radians, alignment: alignment);
  factory AppBarStyler.translate(double x, double y, [double z = 0.0]) =>
      AppBarStyler().translate(x, y, z);
  factory AppBarStyler.skew(double skewX, double skewY) =>
      AppBarStyler().skew(skewX, skewY);
  factory AppBarStyler.textStyle(TextStyler value) =>
      AppBarStyler().textStyle(value);
  factory AppBarStyler.image(DecorationImageMix value) =>
      AppBarStyler().image(value);
  factory AppBarStyler.shape(ShapeBorderMix value) =>
      AppBarStyler().shape(value);
  factory AppBarStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => AppBarStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory AppBarStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => AppBarStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory AppBarStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => AppBarStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory AppBarStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => AppBarStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory AppBarStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => AppBarStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory AppBarStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => AppBarStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory AppBarStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => AppBarStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory AppBarStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => AppBarStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory AppBarStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => AppBarStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory AppBarStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => AppBarStyler().transform(value, alignment: alignment);

  AppBarStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  AppBarStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  AppBarStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  AppBarStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  AppBarStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  AppBarStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  AppBarStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  AppBarStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  AppBarStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  AppBarStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  AppBarStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  AppBarStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  AppBarStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  AppBarStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  AppBarStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  AppBarStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  AppBarStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  AppBarStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  AppBarStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  AppBarStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  AppBarStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  AppBarStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  AppBarStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  AppBarStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  AppBarStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  AppBarStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  AppBarStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  AppBarStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  AppBarStyler backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      BoxStyler().backgroundImage(
        image,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  AppBarStyler backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      BoxStyler().backgroundImageUrl(
        url,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  AppBarStyler backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      BoxStyler().backgroundImageAsset(
        path,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  AppBarStyler linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      BoxStyler().linearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  AppBarStyler radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      BoxStyler().radialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  AppBarStyler sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      BoxStyler().sweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  AppBarStyler foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      BoxStyler().foregroundLinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  AppBarStyler foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      BoxStyler().foregroundRadialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  AppBarStyler foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      BoxStyler().foregroundSweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  AppBarStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'toolbar',
    'title',
    'actions',
    'bottom',
    'toolbarHeight',
    'spacing',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  AppBarStyler container(BoxStyler value) {
    return merge(AppBarStyler(container: value));
  }

  /// Sets the toolbar.
  AppBarStyler toolbar(BoxStyler value) {
    return merge(AppBarStyler(toolbar: value));
  }

  /// Sets the title.
  AppBarStyler title(TextStyler value) {
    return merge(AppBarStyler(title: value));
  }

  /// Sets the actions.
  AppBarStyler actions(FlexBoxStyler value) {
    return merge(AppBarStyler(actions: value));
  }

  /// Sets the bottom.
  AppBarStyler bottom(BoxStyler value) {
    return merge(AppBarStyler(bottom: value));
  }

  /// Sets the toolbarHeight.
  AppBarStyler toolbarHeight(double value) {
    return merge(AppBarStyler(toolbarHeight: value));
  }

  /// Sets the spacing.
  AppBarStyler spacing(double value) {
    return merge(AppBarStyler(spacing: value));
  }

  /// Sets the animation configuration.
  @override
  AppBarStyler animate(AnimationConfig value) {
    return merge(AppBarStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AppBarStyler variants(List<VariantStyle<AppBarSpec>> value) {
    return merge(AppBarStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AppBarStyler wrap(WidgetModifierConfig value) {
    return merge(AppBarStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AppBarStyler modifier(WidgetModifierConfig value) {
    return merge(AppBarStyler(modifier: value));
  }

  RemixAppBar call({
    Key? key,
    Widget? leading,
    String? title,
    Widget? titleChild,
    List<Widget> actions = const [],
    Widget? bottom,
    bool centerTitle = false,
    bool safeArea = true,
    bool? namesRoute,
    int? headingLevel,
  }) {
    return RemixAppBar(
      key: key,
      style: this,
      leading: leading,
      title: title,
      titleChild: titleChild,
      actions: actions,
      bottom: bottom,
      centerTitle: centerTitle,
      safeArea: safeArea,
      namesRoute: namesRoute,
      headingLevel: headingLevel,
    );
  }

  /// Merges with another [AppBarStyler].
  @override
  AppBarStyler merge(AppBarStyler? other) {
    return AppBarStyler.create(
      container: MixOps.merge($container, other?.$container),
      toolbar: MixOps.merge($toolbar, other?.$toolbar),
      title: MixOps.merge($title, other?.$title),
      actions: MixOps.merge($actions, other?.$actions),
      bottom: MixOps.merge($bottom, other?.$bottom),
      toolbarHeight: MixOps.merge($toolbarHeight, other?.$toolbarHeight),
      spacing: MixOps.merge($spacing, other?.$spacing),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AppBarSpec>] using [context].
  @override
  StyleSpec<AppBarSpec> resolve(BuildContext context) {
    final spec = AppBarSpec(
      container: MixOps.resolve(context, $container),
      toolbar: MixOps.resolve(context, $toolbar),
      title: MixOps.resolve(context, $title),
      actions: MixOps.resolve(context, $actions),
      bottom: MixOps.resolve(context, $bottom),
      toolbarHeight: MixOps.resolve(context, $toolbarHeight),
      spacing: MixOps.resolve(context, $spacing),
    );

    return StyleSpec(
      spec: spec,
      animation: $animation,
      widgetModifiers: $modifier?.resolve(context),
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', $container))
      ..add(DiagnosticsProperty('toolbar', $toolbar))
      ..add(DiagnosticsProperty('title', $title))
      ..add(DiagnosticsProperty('actions', $actions))
      ..add(DiagnosticsProperty('bottom', $bottom))
      ..add(DiagnosticsProperty('toolbarHeight', $toolbarHeight))
      ..add(DiagnosticsProperty('spacing', $spacing));
  }

  @override
  List<Object?> get props => [
    $container,
    $toolbar,
    $title,
    $actions,
    $bottom,
    $toolbarHeight,
    $spacing,
    $animation,
    $modifier,
    $variants,
  ];
}
