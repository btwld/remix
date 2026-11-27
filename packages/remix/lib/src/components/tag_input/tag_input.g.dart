// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_input.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$TagInputSpec implements Spec<TagInputSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  RemixBoxEffectsSpec? get containerEffects;
  double? get spacing;
  double? get runSpacing;
  double? get editorMinWidth;
  StyleSpec<TextSpec> get text;
  StyleSpec<TextSpec> get hintText;
  Color? get cursorColor;
  double? get cursorWidth;
  double? get cursorHeight;
  StyleSpec<FlexBoxSpec> get layout;
  StyleSpec<TextSpec> get label;
  StyleSpec<TextSpec> get helperText;
  Style<TagInputTagSpec>? get tag;

  @override
  Type get type => TagInputSpec;

  @override
  TagInputSpec copyWith({
    StyleSpec<BoxSpec>? container,
    RemixBoxEffectsSpec? containerEffects,
    double? spacing,
    double? runSpacing,
    double? editorMinWidth,
    StyleSpec<TextSpec>? text,
    StyleSpec<TextSpec>? hintText,
    Color? cursorColor,
    double? cursorWidth,
    double? cursorHeight,
    StyleSpec<FlexBoxSpec>? layout,
    StyleSpec<TextSpec>? label,
    StyleSpec<TextSpec>? helperText,
    Style<TagInputTagSpec>? tag,
  }) {
    return TagInputSpec(
      container: container ?? this.container,
      containerEffects: containerEffects ?? this.containerEffects,
      spacing: spacing ?? this.spacing,
      runSpacing: runSpacing ?? this.runSpacing,
      editorMinWidth: editorMinWidth ?? this.editorMinWidth,
      text: text ?? this.text,
      hintText: hintText ?? this.hintText,
      cursorColor: cursorColor ?? this.cursorColor,
      cursorWidth: cursorWidth ?? this.cursorWidth,
      cursorHeight: cursorHeight ?? this.cursorHeight,
      layout: layout ?? this.layout,
      label: label ?? this.label,
      helperText: helperText ?? this.helperText,
      tag: tag ?? this.tag,
    );
  }

  @override
  TagInputSpec lerp(TagInputSpec? other, double t) {
    return TagInputSpec(
      container: container.lerp(other?.container, t),
      containerEffects: MixOps.lerpSnap(
        containerEffects,
        other?.containerEffects,
        t,
      ),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
      runSpacing: MixOps.lerp(runSpacing, other?.runSpacing, t),
      editorMinWidth: MixOps.lerp(editorMinWidth, other?.editorMinWidth, t),
      text: text.lerp(other?.text, t),
      hintText: hintText.lerp(other?.hintText, t),
      cursorColor: MixOps.lerp(cursorColor, other?.cursorColor, t),
      cursorWidth: MixOps.lerp(cursorWidth, other?.cursorWidth, t),
      cursorHeight: MixOps.lerp(cursorHeight, other?.cursorHeight, t),
      layout: layout.lerp(other?.layout, t),
      label: label.lerp(other?.label, t),
      helperText: helperText.lerp(other?.helperText, t),
      tag: MixOps.lerpSnap(tag, other?.tag, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    containerEffects,
    spacing,
    runSpacing,
    editorMinWidth,
    text,
    hintText,
    cursorColor,
    cursorWidth,
    cursorHeight,
    layout,
    label,
    helperText,
    tag,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TagInputSpec &&
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
      ..add(DiagnosticsProperty('containerEffects', containerEffects))
      ..add(DoubleProperty('spacing', spacing))
      ..add(DoubleProperty('runSpacing', runSpacing))
      ..add(DoubleProperty('editorMinWidth', editorMinWidth))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('hintText', hintText))
      ..add(ColorProperty('cursorColor', cursorColor))
      ..add(DoubleProperty('cursorWidth', cursorWidth))
      ..add(DoubleProperty('cursorHeight', cursorHeight))
      ..add(DiagnosticsProperty('layout', layout))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('helperText', helperText))
      ..add(DiagnosticsProperty('tag', tag));
  }
}

@Deprecated(
  'Rename to `_\$TagInputSpec` and migrate the class declaration to `class TagInputSpec with _\$TagInputSpec`. The `_\$TagInputSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$TagInputSpecMethods = _$TagInputSpec; // ignore: unused_element

mixin _$TagInputTagSpec implements Spec<TagInputTagSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  Style<IconButtonSpec>? get removeButton;

  @override
  Type get type => TagInputTagSpec;

  @override
  TagInputTagSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    Style<IconButtonSpec>? removeButton,
  }) {
    return TagInputTagSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      removeButton: removeButton ?? this.removeButton,
    );
  }

  @override
  TagInputTagSpec lerp(TagInputTagSpec? other, double t) {
    return TagInputTagSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      removeButton: MixOps.lerpSnap(removeButton, other?.removeButton, t),
    );
  }

  @override
  List<Object?> get props => [container, label, removeButton];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is TagInputTagSpec &&
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
      ..add(DiagnosticsProperty('removeButton', removeButton));
  }
}

@Deprecated(
  'Rename to `_\$TagInputTagSpec` and migrate the class declaration to `class TagInputTagSpec with _\$TagInputTagSpec`. The `_\$TagInputTagSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$TagInputTagSpecMethods = _$TagInputTagSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class TagInputStyler extends MixStyler<TagInputStyler, TagInputSpec>
    with RemixBoxStylerMixin<TagInputStyler>, LabelStyleMixin<TagInputStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<RemixBoxEffectsSpec>? $containerEffects;
  final Prop<double>? $spacing;
  final Prop<double>? $runSpacing;
  final Prop<double>? $editorMinWidth;
  final Prop<StyleSpec<TextSpec>>? $text;
  final Prop<StyleSpec<TextSpec>>? $hintText;
  final Prop<Color>? $cursorColor;
  final Prop<double>? $cursorWidth;
  final Prop<double>? $cursorHeight;
  final Prop<StyleSpec<FlexBoxSpec>>? $layout;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<TextSpec>>? $helperText;
  final Prop<Style<TagInputTagSpec>>? $tag;

  const TagInputStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<RemixBoxEffectsSpec>? containerEffects,
    Prop<double>? spacing,
    Prop<double>? runSpacing,
    Prop<double>? editorMinWidth,
    Prop<StyleSpec<TextSpec>>? text,
    Prop<StyleSpec<TextSpec>>? hintText,
    Prop<Color>? cursorColor,
    Prop<double>? cursorWidth,
    Prop<double>? cursorHeight,
    Prop<StyleSpec<FlexBoxSpec>>? layout,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<TextSpec>>? helperText,
    Prop<Style<TagInputTagSpec>>? tag,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $containerEffects = containerEffects,
       $spacing = spacing,
       $runSpacing = runSpacing,
       $editorMinWidth = editorMinWidth,
       $text = text,
       $hintText = hintText,
       $cursorColor = cursorColor,
       $cursorWidth = cursorWidth,
       $cursorHeight = cursorHeight,
       $layout = layout,
       $label = label,
       $helperText = helperText,
       $tag = tag;

  TagInputStyler({
    BoxStyler? container,
    RemixBoxEffectsMix? containerEffects,
    double? spacing,
    double? runSpacing,
    double? editorMinWidth,
    TextStyler? text,
    TextStyler? hintText,
    Color? cursorColor,
    double? cursorWidth,
    double? cursorHeight,
    FlexBoxStyler? layout,
    TextStyler? label,
    TextStyler? helperText,
    Style<TagInputTagSpec>? tag,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<TagInputSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         containerEffects: Prop.maybeMix(containerEffects),
         spacing: Prop.maybe(spacing),
         runSpacing: Prop.maybe(runSpacing),
         editorMinWidth: Prop.maybe(editorMinWidth),
         text: Prop.maybeMix(text),
         hintText: Prop.maybeMix(hintText),
         cursorColor: Prop.maybe(cursorColor),
         cursorWidth: Prop.maybe(cursorWidth),
         cursorHeight: Prop.maybe(cursorHeight),
         layout: Prop.maybeMix(layout),
         label: Prop.maybeMix(label),
         helperText: Prop.maybeMix(helperText),
         tag: Prop.maybe(tag),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory TagInputStyler.container(BoxStyler value) =>
      TagInputStyler().container(value);
  factory TagInputStyler.containerEffects(RemixBoxEffectsMix value) =>
      TagInputStyler().containerEffects(value);
  factory TagInputStyler.spacing(double value) =>
      TagInputStyler().spacing(value);
  factory TagInputStyler.runSpacing(double value) =>
      TagInputStyler().runSpacing(value);
  factory TagInputStyler.editorMinWidth(double value) =>
      TagInputStyler().editorMinWidth(value);
  factory TagInputStyler.text(TextStyler value) => TagInputStyler().text(value);
  factory TagInputStyler.hintText(TextStyler value) =>
      TagInputStyler().hintText(value);
  factory TagInputStyler.cursorColor(Color value) =>
      TagInputStyler().cursorColor(value);
  factory TagInputStyler.cursorWidth(double value) =>
      TagInputStyler().cursorWidth(value);
  factory TagInputStyler.cursorHeight(double value) =>
      TagInputStyler().cursorHeight(value);
  factory TagInputStyler.layout(FlexBoxStyler value) =>
      TagInputStyler().layout(value);
  factory TagInputStyler.label(TextStyler value) =>
      TagInputStyler().label(value);
  factory TagInputStyler.helperText(TextStyler value) =>
      TagInputStyler().helperText(value);
  factory TagInputStyler.tag(Style<TagInputTagSpec> value) =>
      TagInputStyler().tag(value);
  factory TagInputStyler.alignment(AlignmentGeometry value) =>
      TagInputStyler().alignment(value);
  factory TagInputStyler.padding(EdgeInsetsGeometryMix value) =>
      TagInputStyler().padding(value);
  factory TagInputStyler.margin(EdgeInsetsGeometryMix value) =>
      TagInputStyler().margin(value);
  factory TagInputStyler.constraints(BoxConstraintsMix value) =>
      TagInputStyler().constraints(value);
  factory TagInputStyler.decoration(DecorationMix value) =>
      TagInputStyler().decoration(value);
  factory TagInputStyler.foregroundDecoration(DecorationMix value) =>
      TagInputStyler().foregroundDecoration(value);
  factory TagInputStyler.clipBehavior(Clip value) =>
      TagInputStyler().clipBehavior(value);
  factory TagInputStyler.color(Color value) => TagInputStyler().color(value);
  factory TagInputStyler.gradient(GradientMix value) =>
      TagInputStyler().gradient(value);
  factory TagInputStyler.border(BoxBorderMix value) =>
      TagInputStyler().border(value);
  factory TagInputStyler.borderRadius(BorderRadiusGeometryMix value) =>
      TagInputStyler().borderRadius(value);
  factory TagInputStyler.elevation(ElevationShadow value) =>
      TagInputStyler().elevation(value);
  factory TagInputStyler.shadow(BoxShadowMix value) =>
      TagInputStyler().shadow(value);
  factory TagInputStyler.shadows(List<BoxShadowMix> value) =>
      TagInputStyler().shadows(value);
  factory TagInputStyler.width(double value) => TagInputStyler().width(value);
  factory TagInputStyler.height(double value) => TagInputStyler().height(value);
  factory TagInputStyler.size(double width, double height) =>
      TagInputStyler().size(width, height);
  factory TagInputStyler.minWidth(double value) =>
      TagInputStyler().minWidth(value);
  factory TagInputStyler.maxWidth(double value) =>
      TagInputStyler().maxWidth(value);
  factory TagInputStyler.minHeight(double value) =>
      TagInputStyler().minHeight(value);
  factory TagInputStyler.maxHeight(double value) =>
      TagInputStyler().maxHeight(value);
  factory TagInputStyler.scale(double scale, {Alignment alignment = .center}) =>
      TagInputStyler().scale(scale, alignment: alignment);
  factory TagInputStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => TagInputStyler().rotate(radians, alignment: alignment);
  factory TagInputStyler.translate(double x, double y, [double z = 0.0]) =>
      TagInputStyler().translate(x, y, z);
  factory TagInputStyler.skew(double skewX, double skewY) =>
      TagInputStyler().skew(skewX, skewY);
  factory TagInputStyler.textStyle(TextStyler value) =>
      TagInputStyler().textStyle(value);
  factory TagInputStyler.image(DecorationImageMix value) =>
      TagInputStyler().image(value);
  factory TagInputStyler.shape(ShapeBorderMix value) =>
      TagInputStyler().shape(value);
  factory TagInputStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => TagInputStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory TagInputStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => TagInputStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory TagInputStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => TagInputStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory TagInputStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => TagInputStyler().transform(value, alignment: alignment);
  factory TagInputStyler.wrap(WidgetModifierConfig value) =>
      TagInputStyler().wrap(value);

  TagInputStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  TagInputStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  TagInputStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  TagInputStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  TagInputStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  TagInputStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  TagInputStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  TagInputStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  TagInputStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  TagInputStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  TagInputStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  TagInputStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  TagInputStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  TagInputStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  TagInputStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  TagInputStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  TagInputStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  TagInputStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  TagInputStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  TagInputStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  TagInputStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  TagInputStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  TagInputStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  TagInputStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  TagInputStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  TagInputStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  TagInputStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  TagInputStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  TagInputStyler backgroundImage(
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

  TagInputStyler backgroundImageUrl(
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

  TagInputStyler backgroundImageAsset(
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

  TagInputStyler linearGradient({
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

  TagInputStyler radialGradient({
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

  TagInputStyler sweepGradient({
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

  TagInputStyler foregroundLinearGradient({
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

  TagInputStyler foregroundRadialGradient({
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

  TagInputStyler foregroundSweepGradient({
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

  TagInputStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'containerEffects',
    'spacing',
    'runSpacing',
    'editorMinWidth',
    'text',
    'hintText',
    'cursorColor',
    'cursorWidth',
    'cursorHeight',
    'layout',
    'label',
    'helperText',
    'tag',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  TagInputStyler container(BoxStyler value) {
    return merge(TagInputStyler(container: value));
  }

  /// Sets the containerEffects.
  TagInputStyler containerEffects(RemixBoxEffectsMix value) {
    return merge(TagInputStyler(containerEffects: value));
  }

  /// Sets the spacing.
  TagInputStyler spacing(double value) {
    return merge(TagInputStyler(spacing: value));
  }

  /// Sets the runSpacing.
  TagInputStyler runSpacing(double value) {
    return merge(TagInputStyler(runSpacing: value));
  }

  /// Sets the editorMinWidth.
  TagInputStyler editorMinWidth(double value) {
    return merge(TagInputStyler(editorMinWidth: value));
  }

  /// Sets the text.
  TagInputStyler text(TextStyler value) {
    return merge(TagInputStyler(text: value));
  }

  /// Sets the hintText.
  TagInputStyler hintText(TextStyler value) {
    return merge(TagInputStyler(hintText: value));
  }

  /// Sets the cursorColor.
  TagInputStyler cursorColor(Color value) {
    return merge(TagInputStyler(cursorColor: value));
  }

  /// Sets the cursorWidth.
  TagInputStyler cursorWidth(double value) {
    return merge(TagInputStyler(cursorWidth: value));
  }

  /// Sets the cursorHeight.
  TagInputStyler cursorHeight(double value) {
    return merge(TagInputStyler(cursorHeight: value));
  }

  /// Sets the layout.
  TagInputStyler layout(FlexBoxStyler value) {
    return merge(TagInputStyler(layout: value));
  }

  /// Sets the label.
  @override
  TagInputStyler label(TextStyler value) {
    return merge(TagInputStyler(label: value));
  }

  /// Sets the helperText.
  TagInputStyler helperText(TextStyler value) {
    return merge(TagInputStyler(helperText: value));
  }

  /// Sets the tag.
  TagInputStyler tag(Style<TagInputTagSpec> value) {
    return merge(TagInputStyler(tag: value));
  }

  /// Sets the animation configuration.
  @override
  TagInputStyler animate(AnimationConfig value) {
    return merge(TagInputStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  TagInputStyler variants(List<VariantStyle<TagInputSpec>> value) {
    return merge(TagInputStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  TagInputStyler wrap(WidgetModifierConfig value) {
    return merge(TagInputStyler(modifier: value));
  }

  /// Sets the widget modifier.
  TagInputStyler modifier(WidgetModifierConfig value) {
    return merge(TagInputStyler(modifier: value));
  }

  RemixTagInput call({
    Key? key,
    required List<String> value,
    ValueChanged<List<String>>? onChanged,
    ValueChanged<int>? onDuplicate,
    TextEditingController? controller,
    FocusNode? focusNode,
    String? label,
    String? hintText,
    String? helperText,
    bool error = false,
    List<String> separators = const [','],
    NakedTagInputDuplicates duplicates =
        NakedTagInputDuplicates.rejectIgnoringCase,
    int? maxTags,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = false,
    TextInputAction? textInputAction,
    String? semanticLabel,
    NakedTagInputMessages messages = const NakedTagInputMessages(),
    String Function(String tag) removeLabelBuilder = _defaultRemoveLabel,
  }) {
    return RemixTagInput(
      key: key,
      style: this,
      value: value,
      onChanged: onChanged,
      onDuplicate: onDuplicate,
      controller: controller,
      focusNode: focusNode,
      label: label,
      hintText: hintText,
      helperText: helperText,
      error: error,
      separators: separators,
      duplicates: duplicates,
      maxTags: maxTags,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      textInputAction: textInputAction,
      semanticLabel: semanticLabel,
      messages: messages,
      removeLabelBuilder: removeLabelBuilder,
    );
  }

  /// Merges with another [TagInputStyler].
  @override
  TagInputStyler merge(TagInputStyler? other) {
    return TagInputStyler.create(
      container: MixOps.merge($container, other?.$container),
      containerEffects: MixOps.merge(
        $containerEffects,
        other?.$containerEffects,
      ),
      spacing: MixOps.merge($spacing, other?.$spacing),
      runSpacing: MixOps.merge($runSpacing, other?.$runSpacing),
      editorMinWidth: MixOps.merge($editorMinWidth, other?.$editorMinWidth),
      text: MixOps.merge($text, other?.$text),
      hintText: MixOps.merge($hintText, other?.$hintText),
      cursorColor: MixOps.merge($cursorColor, other?.$cursorColor),
      cursorWidth: MixOps.merge($cursorWidth, other?.$cursorWidth),
      cursorHeight: MixOps.merge($cursorHeight, other?.$cursorHeight),
      layout: MixOps.merge($layout, other?.$layout),
      label: MixOps.merge($label, other?.$label),
      helperText: MixOps.merge($helperText, other?.$helperText),
      tag: MixOps.merge($tag, other?.$tag),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<TagInputSpec>] using [context].
  @override
  StyleSpec<TagInputSpec> resolve(BuildContext context) {
    final spec = TagInputSpec(
      container: MixOps.resolve(context, $container),
      containerEffects: MixOps.resolve(context, $containerEffects),
      spacing: MixOps.resolve(context, $spacing),
      runSpacing: MixOps.resolve(context, $runSpacing),
      editorMinWidth: MixOps.resolve(context, $editorMinWidth),
      text: MixOps.resolve(context, $text),
      hintText: MixOps.resolve(context, $hintText),
      cursorColor: MixOps.resolve(context, $cursorColor),
      cursorWidth: MixOps.resolve(context, $cursorWidth),
      cursorHeight: MixOps.resolve(context, $cursorHeight),
      layout: MixOps.resolve(context, $layout),
      label: MixOps.resolve(context, $label),
      helperText: MixOps.resolve(context, $helperText),
      tag: MixOps.resolve(context, $tag),
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
      ..add(DiagnosticsProperty('containerEffects', $containerEffects))
      ..add(DiagnosticsProperty('spacing', $spacing))
      ..add(DiagnosticsProperty('runSpacing', $runSpacing))
      ..add(DiagnosticsProperty('editorMinWidth', $editorMinWidth))
      ..add(DiagnosticsProperty('text', $text))
      ..add(DiagnosticsProperty('hintText', $hintText))
      ..add(DiagnosticsProperty('cursorColor', $cursorColor))
      ..add(DiagnosticsProperty('cursorWidth', $cursorWidth))
      ..add(DiagnosticsProperty('cursorHeight', $cursorHeight))
      ..add(DiagnosticsProperty('layout', $layout))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('helperText', $helperText))
      ..add(DiagnosticsProperty('tag', $tag));
  }

  @override
  List<Object?> get props => [
    $container,
    $containerEffects,
    $spacing,
    $runSpacing,
    $editorMinWidth,
    $text,
    $hintText,
    $cursorColor,
    $cursorWidth,
    $cursorHeight,
    $layout,
    $label,
    $helperText,
    $tag,
    $animation,
    $modifier,
    $variants,
  ];
}

class TagInputTagStyler extends MixStyler<TagInputTagStyler, TagInputTagSpec>
    with
        RemixBoxStylerMixin<TagInputTagStyler>,
        LabelStyleMixin<TagInputTagStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<Style<IconButtonSpec>>? $removeButton;

  const TagInputTagStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<Style<IconButtonSpec>>? removeButton,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $label = label,
       $removeButton = removeButton;

  TagInputTagStyler({
    FlexBoxStyler? container,
    TextStyler? label,
    Style<IconButtonSpec>? removeButton,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<TagInputTagSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         removeButton: Prop.maybe(removeButton),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory TagInputTagStyler.container(FlexBoxStyler value) =>
      TagInputTagStyler().container(value);
  factory TagInputTagStyler.label(TextStyler value) =>
      TagInputTagStyler().label(value);
  factory TagInputTagStyler.removeButton(Style<IconButtonSpec> value) =>
      TagInputTagStyler().removeButton(value);
  factory TagInputTagStyler.color(Color value) =>
      TagInputTagStyler().color(value);
  factory TagInputTagStyler.gradient(GradientMix value) =>
      TagInputTagStyler().gradient(value);
  factory TagInputTagStyler.border(BoxBorderMix value) =>
      TagInputTagStyler().border(value);
  factory TagInputTagStyler.borderRadius(BorderRadiusGeometryMix value) =>
      TagInputTagStyler().borderRadius(value);
  factory TagInputTagStyler.elevation(ElevationShadow value) =>
      TagInputTagStyler().elevation(value);
  factory TagInputTagStyler.shadow(BoxShadowMix value) =>
      TagInputTagStyler().shadow(value);
  factory TagInputTagStyler.shadows(List<BoxShadowMix> value) =>
      TagInputTagStyler().shadows(value);
  factory TagInputTagStyler.width(double value) =>
      TagInputTagStyler().width(value);
  factory TagInputTagStyler.height(double value) =>
      TagInputTagStyler().height(value);
  factory TagInputTagStyler.size(double width, double height) =>
      TagInputTagStyler().size(width, height);
  factory TagInputTagStyler.minWidth(double value) =>
      TagInputTagStyler().minWidth(value);
  factory TagInputTagStyler.maxWidth(double value) =>
      TagInputTagStyler().maxWidth(value);
  factory TagInputTagStyler.minHeight(double value) =>
      TagInputTagStyler().minHeight(value);
  factory TagInputTagStyler.maxHeight(double value) =>
      TagInputTagStyler().maxHeight(value);
  factory TagInputTagStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => TagInputTagStyler().scale(scale, alignment: alignment);
  factory TagInputTagStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => TagInputTagStyler().rotate(radians, alignment: alignment);
  factory TagInputTagStyler.translate(double x, double y, [double z = 0.0]) =>
      TagInputTagStyler().translate(x, y, z);
  factory TagInputTagStyler.skew(double skewX, double skewY) =>
      TagInputTagStyler().skew(skewX, skewY);
  factory TagInputTagStyler.textStyle(TextStyler value) =>
      TagInputTagStyler().textStyle(value);
  factory TagInputTagStyler.image(DecorationImageMix value) =>
      TagInputTagStyler().image(value);
  factory TagInputTagStyler.shape(ShapeBorderMix value) =>
      TagInputTagStyler().shape(value);
  factory TagInputTagStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => TagInputTagStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory TagInputTagStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => TagInputTagStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory TagInputTagStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => TagInputTagStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory TagInputTagStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputTagStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputTagStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputTagStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputTagStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputTagStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputTagStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputTagStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputTagStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputTagStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputTagStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => TagInputTagStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory TagInputTagStyler.row() => TagInputTagStyler().row();
  factory TagInputTagStyler.column() => TagInputTagStyler().column();
  factory TagInputTagStyler.alignment(AlignmentGeometry value) =>
      TagInputTagStyler().alignment(value);
  factory TagInputTagStyler.padding(EdgeInsetsGeometryMix value) =>
      TagInputTagStyler().padding(value);
  factory TagInputTagStyler.margin(EdgeInsetsGeometryMix value) =>
      TagInputTagStyler().margin(value);
  factory TagInputTagStyler.constraints(BoxConstraintsMix value) =>
      TagInputTagStyler().constraints(value);
  factory TagInputTagStyler.decoration(DecorationMix value) =>
      TagInputTagStyler().decoration(value);
  factory TagInputTagStyler.foregroundDecoration(DecorationMix value) =>
      TagInputTagStyler().foregroundDecoration(value);
  factory TagInputTagStyler.clipBehavior(Clip value) =>
      TagInputTagStyler().clipBehavior(value);
  factory TagInputTagStyler.direction(Axis value) =>
      TagInputTagStyler().direction(value);
  factory TagInputTagStyler.mainAxisAlignment(MainAxisAlignment value) =>
      TagInputTagStyler().mainAxisAlignment(value);
  factory TagInputTagStyler.crossAxisAlignment(CrossAxisAlignment value) =>
      TagInputTagStyler().crossAxisAlignment(value);
  factory TagInputTagStyler.mainAxisSize(MainAxisSize value) =>
      TagInputTagStyler().mainAxisSize(value);
  factory TagInputTagStyler.spacing(double value) =>
      TagInputTagStyler().spacing(value);
  factory TagInputTagStyler.verticalDirection(VerticalDirection value) =>
      TagInputTagStyler().verticalDirection(value);
  factory TagInputTagStyler.textDirection(TextDirection value) =>
      TagInputTagStyler().textDirection(value);
  factory TagInputTagStyler.textBaseline(TextBaseline value) =>
      TagInputTagStyler().textBaseline(value);
  factory TagInputTagStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => TagInputTagStyler().transform(value, alignment: alignment);
  factory TagInputTagStyler.wrap(WidgetModifierConfig value) =>
      TagInputTagStyler().wrap(value);

  TagInputTagStyler color(Color value) {
    return container(FlexBoxStyler().color(value));
  }

  TagInputTagStyler gradient(GradientMix value) {
    return container(FlexBoxStyler().gradient(value));
  }

  TagInputTagStyler border(BoxBorderMix value) {
    return container(FlexBoxStyler().border(value));
  }

  TagInputTagStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(FlexBoxStyler().borderRadius(value));
  }

  TagInputTagStyler elevation(ElevationShadow value) {
    return container(FlexBoxStyler().elevation(value));
  }

  TagInputTagStyler shadow(BoxShadowMix value) {
    return container(FlexBoxStyler().shadow(value));
  }

  TagInputTagStyler shadows(List<BoxShadowMix> value) {
    return container(FlexBoxStyler().shadows(value));
  }

  TagInputTagStyler width(double value) {
    return container(FlexBoxStyler().width(value));
  }

  TagInputTagStyler height(double value) {
    return container(FlexBoxStyler().height(value));
  }

  TagInputTagStyler size(double width, double height) {
    return container(FlexBoxStyler().size(width, height));
  }

  TagInputTagStyler minWidth(double value) {
    return container(FlexBoxStyler().minWidth(value));
  }

  TagInputTagStyler maxWidth(double value) {
    return container(FlexBoxStyler().maxWidth(value));
  }

  TagInputTagStyler minHeight(double value) {
    return container(FlexBoxStyler().minHeight(value));
  }

  TagInputTagStyler maxHeight(double value) {
    return container(FlexBoxStyler().maxHeight(value));
  }

  TagInputTagStyler scale(double scale, {Alignment alignment = .center}) {
    return container(FlexBoxStyler().scale(scale, alignment: alignment));
  }

  TagInputTagStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(FlexBoxStyler().rotate(radians, alignment: alignment));
  }

  TagInputTagStyler translate(double x, double y, [double z = 0.0]) {
    return container(FlexBoxStyler().translate(x, y, z));
  }

  TagInputTagStyler skew(double skewX, double skewY) {
    return container(FlexBoxStyler().skew(skewX, skewY));
  }

  TagInputTagStyler textStyle(TextStyler value) {
    return container(FlexBoxStyler().textStyle(value));
  }

  TagInputTagStyler image(DecorationImageMix value) {
    return container(FlexBoxStyler().image(value));
  }

  TagInputTagStyler shape(ShapeBorderMix value) {
    return container(FlexBoxStyler().shape(value));
  }

  TagInputTagStyler backgroundImage(
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

  TagInputTagStyler backgroundImageUrl(
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

  TagInputTagStyler backgroundImageAsset(
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

  TagInputTagStyler linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      FlexBoxStyler().linearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  TagInputTagStyler radialGradient({
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
      FlexBoxStyler().radialGradient(
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

  TagInputTagStyler sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      FlexBoxStyler().sweepGradient(
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

  TagInputTagStyler foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      FlexBoxStyler().foregroundLinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
        transform: transform,
      ),
    );
  }

  TagInputTagStyler foregroundRadialGradient({
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
      FlexBoxStyler().foregroundRadialGradient(
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

  TagInputTagStyler foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) {
    return container(
      FlexBoxStyler().foregroundSweepGradient(
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

  TagInputTagStyler row() {
    return container(FlexBoxStyler().row());
  }

  TagInputTagStyler column() {
    return container(FlexBoxStyler().column());
  }

  TagInputTagStyler alignment(AlignmentGeometry value) {
    return container(FlexBoxStyler().alignment(value));
  }

  TagInputTagStyler padding(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler().padding(value));
  }

  TagInputTagStyler margin(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler().margin(value));
  }

  TagInputTagStyler constraints(BoxConstraintsMix value) {
    return container(FlexBoxStyler().constraints(value));
  }

  TagInputTagStyler decoration(DecorationMix value) {
    return container(FlexBoxStyler().decoration(value));
  }

  TagInputTagStyler foregroundDecoration(DecorationMix value) {
    return container(FlexBoxStyler().foregroundDecoration(value));
  }

  TagInputTagStyler clipBehavior(Clip value) {
    return container(FlexBoxStyler().clipBehavior(value));
  }

  TagInputTagStyler direction(Axis value) {
    return container(FlexBoxStyler().direction(value));
  }

  TagInputTagStyler mainAxisAlignment(MainAxisAlignment value) {
    return container(FlexBoxStyler().mainAxisAlignment(value));
  }

  TagInputTagStyler crossAxisAlignment(CrossAxisAlignment value) {
    return container(FlexBoxStyler().crossAxisAlignment(value));
  }

  TagInputTagStyler mainAxisSize(MainAxisSize value) {
    return container(FlexBoxStyler().mainAxisSize(value));
  }

  TagInputTagStyler spacing(double value) {
    return container(FlexBoxStyler().spacing(value));
  }

  TagInputTagStyler verticalDirection(VerticalDirection value) {
    return container(FlexBoxStyler().verticalDirection(value));
  }

  TagInputTagStyler textDirection(TextDirection value) {
    return container(FlexBoxStyler().textDirection(value));
  }

  TagInputTagStyler textBaseline(TextBaseline value) {
    return container(FlexBoxStyler().textBaseline(value));
  }

  TagInputTagStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return container(FlexBoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'label',
    'removeButton',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  TagInputTagStyler container(FlexBoxStyler value) {
    return merge(TagInputTagStyler(container: value));
  }

  /// Sets the label.
  @override
  TagInputTagStyler label(TextStyler value) {
    return merge(TagInputTagStyler(label: value));
  }

  /// Sets the removeButton.
  TagInputTagStyler removeButton(Style<IconButtonSpec> value) {
    return merge(TagInputTagStyler(removeButton: value));
  }

  /// Sets the animation configuration.
  @override
  TagInputTagStyler animate(AnimationConfig value) {
    return merge(TagInputTagStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  TagInputTagStyler variants(List<VariantStyle<TagInputTagSpec>> value) {
    return merge(TagInputTagStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  TagInputTagStyler wrap(WidgetModifierConfig value) {
    return merge(TagInputTagStyler(modifier: value));
  }

  /// Sets the widget modifier.
  TagInputTagStyler modifier(WidgetModifierConfig value) {
    return merge(TagInputTagStyler(modifier: value));
  }

  /// Merges with another [TagInputTagStyler].
  @override
  TagInputTagStyler merge(TagInputTagStyler? other) {
    return TagInputTagStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      removeButton: MixOps.merge($removeButton, other?.$removeButton),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<TagInputTagSpec>] using [context].
  @override
  StyleSpec<TagInputTagSpec> resolve(BuildContext context) {
    final spec = TagInputTagSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      removeButton: MixOps.resolve(context, $removeButton),
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
      ..add(DiagnosticsProperty('removeButton', $removeButton));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $removeButton,
    $animation,
    $modifier,
    $variants,
  ];
}
