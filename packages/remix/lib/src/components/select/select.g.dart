// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'select.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSelectSpec implements Spec<RemixSelectSpec>, Diagnosticable {
  StyleSpec<RemixSelectTriggerSpec> get trigger;
  StyleSpec<FlexBoxSpec> get menuContainer;
  StyleSpec<RemixSelectMenuItemSpec> get item;

  @override
  Type get type => RemixSelectSpec;

  @override
  RemixSelectSpec copyWith({
    StyleSpec<RemixSelectTriggerSpec>? trigger,
    StyleSpec<FlexBoxSpec>? menuContainer,
    StyleSpec<RemixSelectMenuItemSpec>? item,
  }) {
    return RemixSelectSpec(
      trigger: trigger ?? this.trigger,
      menuContainer: menuContainer ?? this.menuContainer,
      item: item ?? this.item,
    );
  }

  @override
  RemixSelectSpec lerp(RemixSelectSpec? other, double t) {
    return RemixSelectSpec(
      trigger: trigger.lerp(other?.trigger, t),
      menuContainer: menuContainer.lerp(other?.menuContainer, t),
      item: item.lerp(other?.item, t),
    );
  }

  @override
  List<Object?> get props => [trigger, menuContainer, item];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSelectSpec &&
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
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('menuContainer', menuContainer))
      ..add(DiagnosticsProperty('item', item));
  }
}

@Deprecated(
  'Rename to `_\$RemixSelectSpec` and migrate the class declaration to `class RemixSelectSpec with _\$RemixSelectSpec`. The `_\$RemixSelectSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSelectSpecMethods = _$RemixSelectSpec; // ignore: unused_element

mixin _$RemixSelectTriggerSpec
    implements Spec<RemixSelectTriggerSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixSelectTriggerSpec;

  @override
  RemixSelectTriggerSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixSelectTriggerSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  @override
  RemixSelectTriggerSpec lerp(RemixSelectTriggerSpec? other, double t) {
    return RemixSelectTriggerSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      icon: icon.lerp(other?.icon, t),
    );
  }

  @override
  List<Object?> get props => [container, label, icon];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSelectTriggerSpec &&
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
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }
}

@Deprecated(
  'Rename to `_\$RemixSelectTriggerSpec` and migrate the class declaration to `class RemixSelectTriggerSpec with _\$RemixSelectTriggerSpec`. The `_\$RemixSelectTriggerSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSelectTriggerSpecMethods = _$RemixSelectTriggerSpec; // ignore: unused_element

mixin _$RemixSelectMenuItemSpec
    implements Spec<RemixSelectMenuItemSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get text;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixSelectMenuItemSpec;

  @override
  RemixSelectMenuItemSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixSelectMenuItemSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  @override
  RemixSelectMenuItemSpec lerp(RemixSelectMenuItemSpec? other, double t) {
    return RemixSelectMenuItemSpec(
      container: container.lerp(other?.container, t),
      text: text.lerp(other?.text, t),
      icon: icon.lerp(other?.icon, t),
    );
  }

  @override
  List<Object?> get props => [container, text, icon];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSelectMenuItemSpec &&
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
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('icon', icon));
  }
}

@Deprecated(
  'Rename to `_\$RemixSelectMenuItemSpec` and migrate the class declaration to `class RemixSelectMenuItemSpec with _\$RemixSelectMenuItemSpec`. The `_\$RemixSelectMenuItemSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSelectMenuItemSpecMethods = _$RemixSelectMenuItemSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class RemixSelectStyler extends MixStyler<RemixSelectStyler, RemixSelectSpec>
    with RemixBoxStylerMixin<RemixSelectStyler> {
  final Prop<StyleSpec<RemixSelectTriggerSpec>>? $trigger;
  final Prop<StyleSpec<FlexBoxSpec>>? $menuContainer;
  final Prop<StyleSpec<RemixSelectMenuItemSpec>>? $item;

  const RemixSelectStyler.create({
    Prop<StyleSpec<RemixSelectTriggerSpec>>? trigger,
    Prop<StyleSpec<FlexBoxSpec>>? menuContainer,
    Prop<StyleSpec<RemixSelectMenuItemSpec>>? item,
    super.variants,
    super.modifier,
    super.animation,
  }) : $trigger = trigger,
       $menuContainer = menuContainer,
       $item = item;

  RemixSelectStyler({
    RemixSelectTriggerStyler? trigger,
    FlexBoxStyler? menuContainer,
    RemixSelectMenuItemStyler? item,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<RemixSelectSpec>>? variants,
  }) : this.create(
         trigger: Prop.maybeMix(trigger),
         menuContainer: Prop.maybeMix(menuContainer),
         item: Prop.maybeMix(item),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory RemixSelectStyler.trigger(RemixSelectTriggerStyler value) =>
      RemixSelectStyler().trigger(value);
  factory RemixSelectStyler.menuContainer(FlexBoxStyler value) =>
      RemixSelectStyler().menuContainer(value);
  factory RemixSelectStyler.item(RemixSelectMenuItemStyler value) =>
      RemixSelectStyler().item(value);
  factory RemixSelectStyler.alignment(AlignmentGeometry value) =>
      RemixSelectStyler().alignment(value);
  factory RemixSelectStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixSelectStyler().padding(value);
  factory RemixSelectStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixSelectStyler().margin(value);
  factory RemixSelectStyler.constraints(BoxConstraintsMix value) =>
      RemixSelectStyler().constraints(value);
  factory RemixSelectStyler.decoration(DecorationMix value) =>
      RemixSelectStyler().decoration(value);
  factory RemixSelectStyler.foregroundDecoration(DecorationMix value) =>
      RemixSelectStyler().foregroundDecoration(value);
  factory RemixSelectStyler.clipBehavior(Clip value) =>
      RemixSelectStyler().clipBehavior(value);
  factory RemixSelectStyler.color(Color value) =>
      RemixSelectStyler().color(value);
  factory RemixSelectStyler.gradient(GradientMix value) =>
      RemixSelectStyler().gradient(value);
  factory RemixSelectStyler.border(BoxBorderMix value) =>
      RemixSelectStyler().border(value);
  factory RemixSelectStyler.borderRadius(BorderRadiusGeometryMix value) =>
      RemixSelectStyler().borderRadius(value);
  factory RemixSelectStyler.elevation(ElevationShadow value) =>
      RemixSelectStyler().elevation(value);
  factory RemixSelectStyler.shadow(BoxShadowMix value) =>
      RemixSelectStyler().shadow(value);
  factory RemixSelectStyler.shadows(List<BoxShadowMix> value) =>
      RemixSelectStyler().shadows(value);
  factory RemixSelectStyler.width(double value) =>
      RemixSelectStyler().width(value);
  factory RemixSelectStyler.height(double value) =>
      RemixSelectStyler().height(value);
  factory RemixSelectStyler.size(double width, double height) =>
      RemixSelectStyler().size(width, height);
  factory RemixSelectStyler.minWidth(double value) =>
      RemixSelectStyler().minWidth(value);
  factory RemixSelectStyler.maxWidth(double value) =>
      RemixSelectStyler().maxWidth(value);
  factory RemixSelectStyler.minHeight(double value) =>
      RemixSelectStyler().minHeight(value);
  factory RemixSelectStyler.maxHeight(double value) =>
      RemixSelectStyler().maxHeight(value);
  factory RemixSelectStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => RemixSelectStyler().scale(scale, alignment: alignment);
  factory RemixSelectStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => RemixSelectStyler().rotate(radians, alignment: alignment);
  factory RemixSelectStyler.translate(double x, double y, [double z = 0.0]) =>
      RemixSelectStyler().translate(x, y, z);
  factory RemixSelectStyler.skew(double skewX, double skewY) =>
      RemixSelectStyler().skew(skewX, skewY);
  factory RemixSelectStyler.textStyle(TextStyler value) =>
      RemixSelectStyler().textStyle(value);
  factory RemixSelectStyler.image(DecorationImageMix value) =>
      RemixSelectStyler().image(value);
  factory RemixSelectStyler.shape(ShapeBorderMix value) =>
      RemixSelectStyler().shape(value);
  factory RemixSelectStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSelectStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSelectStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSelectStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSelectStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSelectStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSelectStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => RemixSelectStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory RemixSelectStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => RemixSelectStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory RemixSelectStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => RemixSelectStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory RemixSelectStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => RemixSelectStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory RemixSelectStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => RemixSelectStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory RemixSelectStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => RemixSelectStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory RemixSelectStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => RemixSelectStyler().transform(value, alignment: alignment);

  RemixSelectStyler alignment(AlignmentGeometry value) {
    return menuContainer(FlexBoxStyler().alignment(value));
  }

  RemixSelectStyler padding(EdgeInsetsGeometryMix value) {
    return menuContainer(FlexBoxStyler().padding(value));
  }

  RemixSelectStyler margin(EdgeInsetsGeometryMix value) {
    return menuContainer(FlexBoxStyler().margin(value));
  }

  RemixSelectStyler constraints(BoxConstraintsMix value) {
    return menuContainer(FlexBoxStyler().constraints(value));
  }

  RemixSelectStyler decoration(DecorationMix value) {
    return menuContainer(FlexBoxStyler().decoration(value));
  }

  RemixSelectStyler foregroundDecoration(DecorationMix value) {
    return menuContainer(FlexBoxStyler().foregroundDecoration(value));
  }

  RemixSelectStyler clipBehavior(Clip value) {
    return menuContainer(FlexBoxStyler().clipBehavior(value));
  }

  RemixSelectStyler color(Color value) {
    return menuContainer(FlexBoxStyler().color(value));
  }

  RemixSelectStyler gradient(GradientMix value) {
    return menuContainer(FlexBoxStyler().gradient(value));
  }

  RemixSelectStyler border(BoxBorderMix value) {
    return menuContainer(FlexBoxStyler().border(value));
  }

  RemixSelectStyler borderRadius(BorderRadiusGeometryMix value) {
    return menuContainer(FlexBoxStyler().borderRadius(value));
  }

  RemixSelectStyler elevation(ElevationShadow value) {
    return menuContainer(FlexBoxStyler().elevation(value));
  }

  RemixSelectStyler shadow(BoxShadowMix value) {
    return menuContainer(FlexBoxStyler().shadow(value));
  }

  RemixSelectStyler shadows(List<BoxShadowMix> value) {
    return menuContainer(FlexBoxStyler().shadows(value));
  }

  RemixSelectStyler width(double value) {
    return menuContainer(FlexBoxStyler().width(value));
  }

  RemixSelectStyler height(double value) {
    return menuContainer(FlexBoxStyler().height(value));
  }

  RemixSelectStyler size(double width, double height) {
    return menuContainer(FlexBoxStyler().size(width, height));
  }

  RemixSelectStyler minWidth(double value) {
    return menuContainer(FlexBoxStyler().minWidth(value));
  }

  RemixSelectStyler maxWidth(double value) {
    return menuContainer(FlexBoxStyler().maxWidth(value));
  }

  RemixSelectStyler minHeight(double value) {
    return menuContainer(FlexBoxStyler().minHeight(value));
  }

  RemixSelectStyler maxHeight(double value) {
    return menuContainer(FlexBoxStyler().maxHeight(value));
  }

  RemixSelectStyler scale(double scale, {Alignment alignment = .center}) {
    return menuContainer(FlexBoxStyler().scale(scale, alignment: alignment));
  }

  RemixSelectStyler rotate(double radians, {Alignment alignment = .center}) {
    return menuContainer(FlexBoxStyler().rotate(radians, alignment: alignment));
  }

  RemixSelectStyler translate(double x, double y, [double z = 0.0]) {
    return menuContainer(FlexBoxStyler().translate(x, y, z));
  }

  RemixSelectStyler skew(double skewX, double skewY) {
    return menuContainer(FlexBoxStyler().skew(skewX, skewY));
  }

  RemixSelectStyler textStyle(TextStyler value) {
    return menuContainer(FlexBoxStyler().textStyle(value));
  }

  RemixSelectStyler image(DecorationImageMix value) {
    return menuContainer(FlexBoxStyler().image(value));
  }

  RemixSelectStyler shape(ShapeBorderMix value) {
    return menuContainer(FlexBoxStyler().shape(value));
  }

  RemixSelectStyler backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return menuContainer(
      FlexBoxStyler().backgroundImage(
        image,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSelectStyler backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return menuContainer(
      FlexBoxStyler().backgroundImageUrl(
        url,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSelectStyler backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return menuContainer(
      FlexBoxStyler().backgroundImageAsset(
        path,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSelectStyler linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return menuContainer(
      FlexBoxStyler().linearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectStyler radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return menuContainer(
      FlexBoxStyler().radialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectStyler sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return menuContainer(
      FlexBoxStyler().sweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectStyler foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return menuContainer(
      FlexBoxStyler().foregroundLinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectStyler foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return menuContainer(
      FlexBoxStyler().foregroundRadialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectStyler foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return menuContainer(
      FlexBoxStyler().foregroundSweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return menuContainer(
      FlexBoxStyler().transform(value, alignment: alignment),
    );
  }

  /// Sets the trigger.
  RemixSelectStyler trigger(RemixSelectTriggerStyler value) {
    return merge(RemixSelectStyler(trigger: value));
  }

  /// Sets the menuContainer.
  RemixSelectStyler menuContainer(FlexBoxStyler value) {
    return merge(RemixSelectStyler(menuContainer: value));
  }

  /// Sets the item.
  RemixSelectStyler item(RemixSelectMenuItemStyler value) {
    return merge(RemixSelectStyler(item: value));
  }

  /// Sets the animation configuration.
  @override
  RemixSelectStyler animate(AnimationConfig value) {
    return merge(RemixSelectStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  RemixSelectStyler variants(List<VariantStyle<RemixSelectSpec>> value) {
    return merge(RemixSelectStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  RemixSelectStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSelectStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSelectStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSelectStyler(modifier: value));
  }

  /// Merges with another [RemixSelectStyler].
  @override
  RemixSelectStyler merge(RemixSelectStyler? other) {
    return RemixSelectStyler.create(
      trigger: MixOps.merge($trigger, other?.$trigger),
      menuContainer: MixOps.merge($menuContainer, other?.$menuContainer),
      item: MixOps.merge($item, other?.$item),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSelectSpec>] using [context].
  @override
  StyleSpec<RemixSelectSpec> resolve(BuildContext context) {
    final spec = RemixSelectSpec(
      trigger: MixOps.resolve(context, $trigger),
      menuContainer: MixOps.resolve(context, $menuContainer),
      item: MixOps.resolve(context, $item),
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
      ..add(DiagnosticsProperty('trigger', $trigger))
      ..add(DiagnosticsProperty('menuContainer', $menuContainer))
      ..add(DiagnosticsProperty('item', $item));
  }

  @override
  List<Object?> get props => [
    $trigger,
    $menuContainer,
    $item,
    $animation,
    $modifier,
    $variants,
  ];
}

class RemixSelectTriggerStyler
    extends MixStyler<RemixSelectTriggerStyler, RemixSelectTriggerSpec>
    with
        RemixBoxStylerMixin<RemixSelectTriggerStyler>,
        LabelStyleMixin<RemixSelectTriggerStyler>,
        IconStyleMixin<RemixSelectTriggerStyler> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixSelectTriggerStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $label = label,
       $icon = icon;

  RemixSelectTriggerStyler({
    FlexBoxStyler? container,
    TextStyler? label,
    IconStyler? icon,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<RemixSelectTriggerSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         icon: Prop.maybeMix(icon),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory RemixSelectTriggerStyler.container(FlexBoxStyler value) =>
      RemixSelectTriggerStyler().container(value);
  factory RemixSelectTriggerStyler.label(TextStyler value) =>
      RemixSelectTriggerStyler().label(value);
  factory RemixSelectTriggerStyler.icon(IconStyler value) =>
      RemixSelectTriggerStyler().icon(value);
  factory RemixSelectTriggerStyler.color(Color value) =>
      RemixSelectTriggerStyler().color(value);
  factory RemixSelectTriggerStyler.gradient(GradientMix value) =>
      RemixSelectTriggerStyler().gradient(value);
  factory RemixSelectTriggerStyler.border(BoxBorderMix value) =>
      RemixSelectTriggerStyler().border(value);
  factory RemixSelectTriggerStyler.borderRadius(
    BorderRadiusGeometryMix value,
  ) => RemixSelectTriggerStyler().borderRadius(value);
  factory RemixSelectTriggerStyler.elevation(ElevationShadow value) =>
      RemixSelectTriggerStyler().elevation(value);
  factory RemixSelectTriggerStyler.shadow(BoxShadowMix value) =>
      RemixSelectTriggerStyler().shadow(value);
  factory RemixSelectTriggerStyler.shadows(List<BoxShadowMix> value) =>
      RemixSelectTriggerStyler().shadows(value);
  factory RemixSelectTriggerStyler.width(double value) =>
      RemixSelectTriggerStyler().width(value);
  factory RemixSelectTriggerStyler.height(double value) =>
      RemixSelectTriggerStyler().height(value);
  factory RemixSelectTriggerStyler.size(double width, double height) =>
      RemixSelectTriggerStyler().size(width, height);
  factory RemixSelectTriggerStyler.minWidth(double value) =>
      RemixSelectTriggerStyler().minWidth(value);
  factory RemixSelectTriggerStyler.maxWidth(double value) =>
      RemixSelectTriggerStyler().maxWidth(value);
  factory RemixSelectTriggerStyler.minHeight(double value) =>
      RemixSelectTriggerStyler().minHeight(value);
  factory RemixSelectTriggerStyler.maxHeight(double value) =>
      RemixSelectTriggerStyler().maxHeight(value);
  factory RemixSelectTriggerStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => RemixSelectTriggerStyler().scale(scale, alignment: alignment);
  factory RemixSelectTriggerStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => RemixSelectTriggerStyler().rotate(radians, alignment: alignment);
  factory RemixSelectTriggerStyler.translate(
    double x,
    double y, [
    double z = 0.0,
  ]) => RemixSelectTriggerStyler().translate(x, y, z);
  factory RemixSelectTriggerStyler.skew(double skewX, double skewY) =>
      RemixSelectTriggerStyler().skew(skewX, skewY);
  factory RemixSelectTriggerStyler.textStyle(TextStyler value) =>
      RemixSelectTriggerStyler().textStyle(value);
  factory RemixSelectTriggerStyler.image(DecorationImageMix value) =>
      RemixSelectTriggerStyler().image(value);
  factory RemixSelectTriggerStyler.shape(ShapeBorderMix value) =>
      RemixSelectTriggerStyler().shape(value);
  factory RemixSelectTriggerStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSelectTriggerStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSelectTriggerStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSelectTriggerStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSelectTriggerStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSelectTriggerStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSelectTriggerStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => RemixSelectTriggerStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory RemixSelectTriggerStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => RemixSelectTriggerStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory RemixSelectTriggerStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => RemixSelectTriggerStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory RemixSelectTriggerStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => RemixSelectTriggerStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory RemixSelectTriggerStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => RemixSelectTriggerStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory RemixSelectTriggerStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => RemixSelectTriggerStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory RemixSelectTriggerStyler.row() => RemixSelectTriggerStyler().row();
  factory RemixSelectTriggerStyler.column() =>
      RemixSelectTriggerStyler().column();
  factory RemixSelectTriggerStyler.alignment(AlignmentGeometry value) =>
      RemixSelectTriggerStyler().alignment(value);
  factory RemixSelectTriggerStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixSelectTriggerStyler().padding(value);
  factory RemixSelectTriggerStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixSelectTriggerStyler().margin(value);
  factory RemixSelectTriggerStyler.constraints(BoxConstraintsMix value) =>
      RemixSelectTriggerStyler().constraints(value);
  factory RemixSelectTriggerStyler.decoration(DecorationMix value) =>
      RemixSelectTriggerStyler().decoration(value);
  factory RemixSelectTriggerStyler.foregroundDecoration(DecorationMix value) =>
      RemixSelectTriggerStyler().foregroundDecoration(value);
  factory RemixSelectTriggerStyler.clipBehavior(Clip value) =>
      RemixSelectTriggerStyler().clipBehavior(value);
  factory RemixSelectTriggerStyler.direction(Axis value) =>
      RemixSelectTriggerStyler().direction(value);
  factory RemixSelectTriggerStyler.mainAxisAlignment(MainAxisAlignment value) =>
      RemixSelectTriggerStyler().mainAxisAlignment(value);
  factory RemixSelectTriggerStyler.crossAxisAlignment(
    CrossAxisAlignment value,
  ) => RemixSelectTriggerStyler().crossAxisAlignment(value);
  factory RemixSelectTriggerStyler.mainAxisSize(MainAxisSize value) =>
      RemixSelectTriggerStyler().mainAxisSize(value);
  factory RemixSelectTriggerStyler.spacing(double value) =>
      RemixSelectTriggerStyler().spacing(value);
  factory RemixSelectTriggerStyler.verticalDirection(VerticalDirection value) =>
      RemixSelectTriggerStyler().verticalDirection(value);
  factory RemixSelectTriggerStyler.textDirection(TextDirection value) =>
      RemixSelectTriggerStyler().textDirection(value);
  factory RemixSelectTriggerStyler.textBaseline(TextBaseline value) =>
      RemixSelectTriggerStyler().textBaseline(value);
  factory RemixSelectTriggerStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => RemixSelectTriggerStyler().transform(value, alignment: alignment);

  RemixSelectTriggerStyler color(Color value) {
    return container(FlexBoxStyler().color(value));
  }

  RemixSelectTriggerStyler gradient(GradientMix value) {
    return container(FlexBoxStyler().gradient(value));
  }

  RemixSelectTriggerStyler border(BoxBorderMix value) {
    return container(FlexBoxStyler().border(value));
  }

  RemixSelectTriggerStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(FlexBoxStyler().borderRadius(value));
  }

  RemixSelectTriggerStyler elevation(ElevationShadow value) {
    return container(FlexBoxStyler().elevation(value));
  }

  RemixSelectTriggerStyler shadow(BoxShadowMix value) {
    return container(FlexBoxStyler().shadow(value));
  }

  RemixSelectTriggerStyler shadows(List<BoxShadowMix> value) {
    return container(FlexBoxStyler().shadows(value));
  }

  RemixSelectTriggerStyler width(double value) {
    return container(FlexBoxStyler().width(value));
  }

  RemixSelectTriggerStyler height(double value) {
    return container(FlexBoxStyler().height(value));
  }

  RemixSelectTriggerStyler size(double width, double height) {
    return container(FlexBoxStyler().size(width, height));
  }

  RemixSelectTriggerStyler minWidth(double value) {
    return container(FlexBoxStyler().minWidth(value));
  }

  RemixSelectTriggerStyler maxWidth(double value) {
    return container(FlexBoxStyler().maxWidth(value));
  }

  RemixSelectTriggerStyler minHeight(double value) {
    return container(FlexBoxStyler().minHeight(value));
  }

  RemixSelectTriggerStyler maxHeight(double value) {
    return container(FlexBoxStyler().maxHeight(value));
  }

  RemixSelectTriggerStyler scale(
    double scale, {
    Alignment alignment = .center,
  }) {
    return container(FlexBoxStyler().scale(scale, alignment: alignment));
  }

  RemixSelectTriggerStyler rotate(
    double radians, {
    Alignment alignment = .center,
  }) {
    return container(FlexBoxStyler().rotate(radians, alignment: alignment));
  }

  RemixSelectTriggerStyler translate(double x, double y, [double z = 0.0]) {
    return container(FlexBoxStyler().translate(x, y, z));
  }

  RemixSelectTriggerStyler skew(double skewX, double skewY) {
    return container(FlexBoxStyler().skew(skewX, skewY));
  }

  RemixSelectTriggerStyler textStyle(TextStyler value) {
    return container(FlexBoxStyler().textStyle(value));
  }

  RemixSelectTriggerStyler image(DecorationImageMix value) {
    return container(FlexBoxStyler().image(value));
  }

  RemixSelectTriggerStyler shape(ShapeBorderMix value) {
    return container(FlexBoxStyler().shape(value));
  }

  RemixSelectTriggerStyler backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      FlexBoxStyler().backgroundImage(
        image,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSelectTriggerStyler backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      FlexBoxStyler().backgroundImageUrl(
        url,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSelectTriggerStyler backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      FlexBoxStyler().backgroundImageAsset(
        path,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSelectTriggerStyler linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().linearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectTriggerStyler radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().radialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectTriggerStyler sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().sweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectTriggerStyler foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().foregroundLinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectTriggerStyler foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().foregroundRadialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectTriggerStyler foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().foregroundSweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectTriggerStyler row() {
    return container(FlexBoxStyler().row());
  }

  RemixSelectTriggerStyler column() {
    return container(FlexBoxStyler().column());
  }

  RemixSelectTriggerStyler alignment(AlignmentGeometry value) {
    return container(FlexBoxStyler().alignment(value));
  }

  RemixSelectTriggerStyler padding(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler().padding(value));
  }

  RemixSelectTriggerStyler margin(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler().margin(value));
  }

  RemixSelectTriggerStyler constraints(BoxConstraintsMix value) {
    return container(FlexBoxStyler().constraints(value));
  }

  RemixSelectTriggerStyler decoration(DecorationMix value) {
    return container(FlexBoxStyler().decoration(value));
  }

  RemixSelectTriggerStyler foregroundDecoration(DecorationMix value) {
    return container(FlexBoxStyler().foregroundDecoration(value));
  }

  RemixSelectTriggerStyler clipBehavior(Clip value) {
    return container(FlexBoxStyler().clipBehavior(value));
  }

  RemixSelectTriggerStyler direction(Axis value) {
    return container(FlexBoxStyler().direction(value));
  }

  RemixSelectTriggerStyler mainAxisAlignment(MainAxisAlignment value) {
    return container(FlexBoxStyler().mainAxisAlignment(value));
  }

  RemixSelectTriggerStyler crossAxisAlignment(CrossAxisAlignment value) {
    return container(FlexBoxStyler().crossAxisAlignment(value));
  }

  RemixSelectTriggerStyler mainAxisSize(MainAxisSize value) {
    return container(FlexBoxStyler().mainAxisSize(value));
  }

  RemixSelectTriggerStyler spacing(double value) {
    return container(FlexBoxStyler().spacing(value));
  }

  RemixSelectTriggerStyler verticalDirection(VerticalDirection value) {
    return container(FlexBoxStyler().verticalDirection(value));
  }

  RemixSelectTriggerStyler textDirection(TextDirection value) {
    return container(FlexBoxStyler().textDirection(value));
  }

  RemixSelectTriggerStyler textBaseline(TextBaseline value) {
    return container(FlexBoxStyler().textBaseline(value));
  }

  RemixSelectTriggerStyler transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) {
    return container(FlexBoxStyler().transform(value, alignment: alignment));
  }

  /// Sets the container.
  RemixSelectTriggerStyler container(FlexBoxStyler value) {
    return merge(RemixSelectTriggerStyler(container: value));
  }

  /// Sets the label.
  @override
  RemixSelectTriggerStyler label(TextStyler value) {
    return merge(RemixSelectTriggerStyler(label: value));
  }

  /// Sets the icon.
  @override
  RemixSelectTriggerStyler icon(IconStyler value) {
    return merge(RemixSelectTriggerStyler(icon: value));
  }

  /// Sets the animation configuration.
  @override
  RemixSelectTriggerStyler animate(AnimationConfig value) {
    return merge(RemixSelectTriggerStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  RemixSelectTriggerStyler variants(
    List<VariantStyle<RemixSelectTriggerSpec>> value,
  ) {
    return merge(RemixSelectTriggerStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  RemixSelectTriggerStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSelectTriggerStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSelectTriggerStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSelectTriggerStyler(modifier: value));
  }

  /// Merges with another [RemixSelectTriggerStyler].
  @override
  RemixSelectTriggerStyler merge(RemixSelectTriggerStyler? other) {
    return RemixSelectTriggerStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSelectTriggerSpec>] using [context].
  @override
  StyleSpec<RemixSelectTriggerSpec> resolve(BuildContext context) {
    final spec = RemixSelectTriggerSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
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
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}

class RemixSelectMenuItemStyler
    extends MixStyler<RemixSelectMenuItemStyler, RemixSelectMenuItemSpec>
    with
        RemixBoxStylerMixin<RemixSelectMenuItemStyler>,
        IconStyleMixin<RemixSelectMenuItemStyler> {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<IconSpec>>? $icon;

  const RemixSelectMenuItemStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<IconSpec>>? icon,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $text = text,
       $icon = icon;

  RemixSelectMenuItemStyler({
    FlexBoxStyler? container,
    TextStyler? text,
    IconStyler? icon,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<RemixSelectMenuItemSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         text: Prop.maybeMix(text),
         icon: Prop.maybeMix(icon),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory RemixSelectMenuItemStyler.container(FlexBoxStyler value) =>
      RemixSelectMenuItemStyler().container(value);
  factory RemixSelectMenuItemStyler.text(TextStyler value) =>
      RemixSelectMenuItemStyler().text(value);
  factory RemixSelectMenuItemStyler.icon(IconStyler value) =>
      RemixSelectMenuItemStyler().icon(value);
  factory RemixSelectMenuItemStyler.color(Color value) =>
      RemixSelectMenuItemStyler().color(value);
  factory RemixSelectMenuItemStyler.gradient(GradientMix value) =>
      RemixSelectMenuItemStyler().gradient(value);
  factory RemixSelectMenuItemStyler.border(BoxBorderMix value) =>
      RemixSelectMenuItemStyler().border(value);
  factory RemixSelectMenuItemStyler.borderRadius(
    BorderRadiusGeometryMix value,
  ) => RemixSelectMenuItemStyler().borderRadius(value);
  factory RemixSelectMenuItemStyler.elevation(ElevationShadow value) =>
      RemixSelectMenuItemStyler().elevation(value);
  factory RemixSelectMenuItemStyler.shadow(BoxShadowMix value) =>
      RemixSelectMenuItemStyler().shadow(value);
  factory RemixSelectMenuItemStyler.shadows(List<BoxShadowMix> value) =>
      RemixSelectMenuItemStyler().shadows(value);
  factory RemixSelectMenuItemStyler.width(double value) =>
      RemixSelectMenuItemStyler().width(value);
  factory RemixSelectMenuItemStyler.height(double value) =>
      RemixSelectMenuItemStyler().height(value);
  factory RemixSelectMenuItemStyler.size(double width, double height) =>
      RemixSelectMenuItemStyler().size(width, height);
  factory RemixSelectMenuItemStyler.minWidth(double value) =>
      RemixSelectMenuItemStyler().minWidth(value);
  factory RemixSelectMenuItemStyler.maxWidth(double value) =>
      RemixSelectMenuItemStyler().maxWidth(value);
  factory RemixSelectMenuItemStyler.minHeight(double value) =>
      RemixSelectMenuItemStyler().minHeight(value);
  factory RemixSelectMenuItemStyler.maxHeight(double value) =>
      RemixSelectMenuItemStyler().maxHeight(value);
  factory RemixSelectMenuItemStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => RemixSelectMenuItemStyler().scale(scale, alignment: alignment);
  factory RemixSelectMenuItemStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => RemixSelectMenuItemStyler().rotate(radians, alignment: alignment);
  factory RemixSelectMenuItemStyler.translate(
    double x,
    double y, [
    double z = 0.0,
  ]) => RemixSelectMenuItemStyler().translate(x, y, z);
  factory RemixSelectMenuItemStyler.skew(double skewX, double skewY) =>
      RemixSelectMenuItemStyler().skew(skewX, skewY);
  factory RemixSelectMenuItemStyler.textStyle(TextStyler value) =>
      RemixSelectMenuItemStyler().textStyle(value);
  factory RemixSelectMenuItemStyler.image(DecorationImageMix value) =>
      RemixSelectMenuItemStyler().image(value);
  factory RemixSelectMenuItemStyler.shape(ShapeBorderMix value) =>
      RemixSelectMenuItemStyler().shape(value);
  factory RemixSelectMenuItemStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSelectMenuItemStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSelectMenuItemStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSelectMenuItemStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSelectMenuItemStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSelectMenuItemStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSelectMenuItemStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => RemixSelectMenuItemStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory RemixSelectMenuItemStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => RemixSelectMenuItemStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory RemixSelectMenuItemStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => RemixSelectMenuItemStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory RemixSelectMenuItemStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => RemixSelectMenuItemStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory RemixSelectMenuItemStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => RemixSelectMenuItemStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory RemixSelectMenuItemStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => RemixSelectMenuItemStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory RemixSelectMenuItemStyler.row() => RemixSelectMenuItemStyler().row();
  factory RemixSelectMenuItemStyler.column() =>
      RemixSelectMenuItemStyler().column();
  factory RemixSelectMenuItemStyler.alignment(AlignmentGeometry value) =>
      RemixSelectMenuItemStyler().alignment(value);
  factory RemixSelectMenuItemStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixSelectMenuItemStyler().padding(value);
  factory RemixSelectMenuItemStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixSelectMenuItemStyler().margin(value);
  factory RemixSelectMenuItemStyler.constraints(BoxConstraintsMix value) =>
      RemixSelectMenuItemStyler().constraints(value);
  factory RemixSelectMenuItemStyler.decoration(DecorationMix value) =>
      RemixSelectMenuItemStyler().decoration(value);
  factory RemixSelectMenuItemStyler.foregroundDecoration(DecorationMix value) =>
      RemixSelectMenuItemStyler().foregroundDecoration(value);
  factory RemixSelectMenuItemStyler.clipBehavior(Clip value) =>
      RemixSelectMenuItemStyler().clipBehavior(value);
  factory RemixSelectMenuItemStyler.direction(Axis value) =>
      RemixSelectMenuItemStyler().direction(value);
  factory RemixSelectMenuItemStyler.mainAxisAlignment(
    MainAxisAlignment value,
  ) => RemixSelectMenuItemStyler().mainAxisAlignment(value);
  factory RemixSelectMenuItemStyler.crossAxisAlignment(
    CrossAxisAlignment value,
  ) => RemixSelectMenuItemStyler().crossAxisAlignment(value);
  factory RemixSelectMenuItemStyler.mainAxisSize(MainAxisSize value) =>
      RemixSelectMenuItemStyler().mainAxisSize(value);
  factory RemixSelectMenuItemStyler.spacing(double value) =>
      RemixSelectMenuItemStyler().spacing(value);
  factory RemixSelectMenuItemStyler.verticalDirection(
    VerticalDirection value,
  ) => RemixSelectMenuItemStyler().verticalDirection(value);
  factory RemixSelectMenuItemStyler.textDirection(TextDirection value) =>
      RemixSelectMenuItemStyler().textDirection(value);
  factory RemixSelectMenuItemStyler.textBaseline(TextBaseline value) =>
      RemixSelectMenuItemStyler().textBaseline(value);
  factory RemixSelectMenuItemStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => RemixSelectMenuItemStyler().transform(value, alignment: alignment);

  RemixSelectMenuItemStyler color(Color value) {
    return container(FlexBoxStyler().color(value));
  }

  RemixSelectMenuItemStyler gradient(GradientMix value) {
    return container(FlexBoxStyler().gradient(value));
  }

  RemixSelectMenuItemStyler border(BoxBorderMix value) {
    return container(FlexBoxStyler().border(value));
  }

  RemixSelectMenuItemStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(FlexBoxStyler().borderRadius(value));
  }

  RemixSelectMenuItemStyler elevation(ElevationShadow value) {
    return container(FlexBoxStyler().elevation(value));
  }

  RemixSelectMenuItemStyler shadow(BoxShadowMix value) {
    return container(FlexBoxStyler().shadow(value));
  }

  RemixSelectMenuItemStyler shadows(List<BoxShadowMix> value) {
    return container(FlexBoxStyler().shadows(value));
  }

  RemixSelectMenuItemStyler width(double value) {
    return container(FlexBoxStyler().width(value));
  }

  RemixSelectMenuItemStyler height(double value) {
    return container(FlexBoxStyler().height(value));
  }

  RemixSelectMenuItemStyler size(double width, double height) {
    return container(FlexBoxStyler().size(width, height));
  }

  RemixSelectMenuItemStyler minWidth(double value) {
    return container(FlexBoxStyler().minWidth(value));
  }

  RemixSelectMenuItemStyler maxWidth(double value) {
    return container(FlexBoxStyler().maxWidth(value));
  }

  RemixSelectMenuItemStyler minHeight(double value) {
    return container(FlexBoxStyler().minHeight(value));
  }

  RemixSelectMenuItemStyler maxHeight(double value) {
    return container(FlexBoxStyler().maxHeight(value));
  }

  RemixSelectMenuItemStyler scale(
    double scale, {
    Alignment alignment = .center,
  }) {
    return container(FlexBoxStyler().scale(scale, alignment: alignment));
  }

  RemixSelectMenuItemStyler rotate(
    double radians, {
    Alignment alignment = .center,
  }) {
    return container(FlexBoxStyler().rotate(radians, alignment: alignment));
  }

  RemixSelectMenuItemStyler translate(double x, double y, [double z = 0.0]) {
    return container(FlexBoxStyler().translate(x, y, z));
  }

  RemixSelectMenuItemStyler skew(double skewX, double skewY) {
    return container(FlexBoxStyler().skew(skewX, skewY));
  }

  RemixSelectMenuItemStyler textStyle(TextStyler value) {
    return container(FlexBoxStyler().textStyle(value));
  }

  RemixSelectMenuItemStyler image(DecorationImageMix value) {
    return container(FlexBoxStyler().image(value));
  }

  RemixSelectMenuItemStyler shape(ShapeBorderMix value) {
    return container(FlexBoxStyler().shape(value));
  }

  RemixSelectMenuItemStyler backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      FlexBoxStyler().backgroundImage(
        image,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSelectMenuItemStyler backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      FlexBoxStyler().backgroundImageUrl(
        url,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSelectMenuItemStyler backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return container(
      FlexBoxStyler().backgroundImageAsset(
        path,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSelectMenuItemStyler linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().linearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectMenuItemStyler radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().radialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectMenuItemStyler sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().sweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectMenuItemStyler foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().foregroundLinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectMenuItemStyler foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().foregroundRadialGradient(
        colors: colors,
        stops: stops,
        center: center,
        radius: radius,
        focal: focal,
        focalRadius: focalRadius,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectMenuItemStyler foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return container(
      FlexBoxStyler().foregroundSweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }

  RemixSelectMenuItemStyler row() {
    return container(FlexBoxStyler().row());
  }

  RemixSelectMenuItemStyler column() {
    return container(FlexBoxStyler().column());
  }

  RemixSelectMenuItemStyler alignment(AlignmentGeometry value) {
    return container(FlexBoxStyler().alignment(value));
  }

  RemixSelectMenuItemStyler padding(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler().padding(value));
  }

  RemixSelectMenuItemStyler margin(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler().margin(value));
  }

  RemixSelectMenuItemStyler constraints(BoxConstraintsMix value) {
    return container(FlexBoxStyler().constraints(value));
  }

  RemixSelectMenuItemStyler decoration(DecorationMix value) {
    return container(FlexBoxStyler().decoration(value));
  }

  RemixSelectMenuItemStyler foregroundDecoration(DecorationMix value) {
    return container(FlexBoxStyler().foregroundDecoration(value));
  }

  RemixSelectMenuItemStyler clipBehavior(Clip value) {
    return container(FlexBoxStyler().clipBehavior(value));
  }

  RemixSelectMenuItemStyler direction(Axis value) {
    return container(FlexBoxStyler().direction(value));
  }

  RemixSelectMenuItemStyler mainAxisAlignment(MainAxisAlignment value) {
    return container(FlexBoxStyler().mainAxisAlignment(value));
  }

  RemixSelectMenuItemStyler crossAxisAlignment(CrossAxisAlignment value) {
    return container(FlexBoxStyler().crossAxisAlignment(value));
  }

  RemixSelectMenuItemStyler mainAxisSize(MainAxisSize value) {
    return container(FlexBoxStyler().mainAxisSize(value));
  }

  RemixSelectMenuItemStyler spacing(double value) {
    return container(FlexBoxStyler().spacing(value));
  }

  RemixSelectMenuItemStyler verticalDirection(VerticalDirection value) {
    return container(FlexBoxStyler().verticalDirection(value));
  }

  RemixSelectMenuItemStyler textDirection(TextDirection value) {
    return container(FlexBoxStyler().textDirection(value));
  }

  RemixSelectMenuItemStyler textBaseline(TextBaseline value) {
    return container(FlexBoxStyler().textBaseline(value));
  }

  RemixSelectMenuItemStyler transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) {
    return container(FlexBoxStyler().transform(value, alignment: alignment));
  }

  /// Sets the container.
  RemixSelectMenuItemStyler container(FlexBoxStyler value) {
    return merge(RemixSelectMenuItemStyler(container: value));
  }

  /// Sets the text.
  RemixSelectMenuItemStyler text(TextStyler value) {
    return merge(RemixSelectMenuItemStyler(text: value));
  }

  /// Sets the icon.
  @override
  RemixSelectMenuItemStyler icon(IconStyler value) {
    return merge(RemixSelectMenuItemStyler(icon: value));
  }

  /// Sets the animation configuration.
  @override
  RemixSelectMenuItemStyler animate(AnimationConfig value) {
    return merge(RemixSelectMenuItemStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  RemixSelectMenuItemStyler variants(
    List<VariantStyle<RemixSelectMenuItemSpec>> value,
  ) {
    return merge(RemixSelectMenuItemStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  RemixSelectMenuItemStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSelectMenuItemStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSelectMenuItemStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSelectMenuItemStyler(modifier: value));
  }

  /// Merges with another [RemixSelectMenuItemStyler].
  @override
  RemixSelectMenuItemStyler merge(RemixSelectMenuItemStyler? other) {
    return RemixSelectMenuItemStyler.create(
      container: MixOps.merge($container, other?.$container),
      text: MixOps.merge($text, other?.$text),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSelectMenuItemSpec>] using [context].
  @override
  StyleSpec<RemixSelectMenuItemSpec> resolve(BuildContext context) {
    final spec = RemixSelectMenuItemSpec(
      container: MixOps.resolve(context, $container),
      text: MixOps.resolve(context, $text),
      icon: MixOps.resolve(context, $icon),
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
      ..add(DiagnosticsProperty('text', $text))
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  List<Object?> get props => [
    $container,
    $text,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}
