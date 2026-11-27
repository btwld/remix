// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RatingSpec implements Spec<RatingSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<FlexBoxSpec> get controlRow;
  StyleSpec<FlexBoxSpec> get stars;
  StyleSpec<RatingStarSpec> get star;
  StyleSpec<TextSpec> get label;
  StyleSpec<TextSpec> get valueText;
  StyleSpec<TextSpec> get description;
  AnimationConfig? get fillMotion;
  Duration? get fillStagger;
  AnimationConfig? get keptMotion;

  @override
  Type get type => RatingSpec;

  @override
  RatingSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<FlexBoxSpec>? controlRow,
    StyleSpec<FlexBoxSpec>? stars,
    StyleSpec<RatingStarSpec>? star,
    StyleSpec<TextSpec>? label,
    StyleSpec<TextSpec>? valueText,
    StyleSpec<TextSpec>? description,
    AnimationConfig? fillMotion,
    Duration? fillStagger,
    AnimationConfig? keptMotion,
  }) {
    return RatingSpec(
      container: container ?? this.container,
      controlRow: controlRow ?? this.controlRow,
      stars: stars ?? this.stars,
      star: star ?? this.star,
      label: label ?? this.label,
      valueText: valueText ?? this.valueText,
      description: description ?? this.description,
      fillMotion: fillMotion ?? this.fillMotion,
      fillStagger: fillStagger ?? this.fillStagger,
      keptMotion: keptMotion ?? this.keptMotion,
    );
  }

  @override
  RatingSpec lerp(RatingSpec? other, double t) {
    return RatingSpec(
      container: container.lerp(other?.container, t),
      controlRow: controlRow.lerp(other?.controlRow, t),
      stars: stars.lerp(other?.stars, t),
      star: star.lerp(other?.star, t),
      label: label.lerp(other?.label, t),
      valueText: valueText.lerp(other?.valueText, t),
      description: description.lerp(other?.description, t),
      fillMotion: MixOps.lerpSnap(fillMotion, other?.fillMotion, t),
      fillStagger: MixOps.lerpSnap(fillStagger, other?.fillStagger, t),
      keptMotion: MixOps.lerpSnap(keptMotion, other?.keptMotion, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    controlRow,
    stars,
    star,
    label,
    valueText,
    description,
    fillMotion,
    fillStagger,
    keptMotion,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RatingSpec &&
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
      ..add(DiagnosticsProperty('controlRow', controlRow))
      ..add(DiagnosticsProperty('stars', stars))
      ..add(DiagnosticsProperty('star', star))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('valueText', valueText))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('fillMotion', fillMotion))
      ..add(DiagnosticsProperty('fillStagger', fillStagger))
      ..add(DiagnosticsProperty('keptMotion', keptMotion));
  }
}

@Deprecated(
  'Rename to `_\$RatingSpec` and migrate the class declaration to `class RatingSpec with _\$RatingSpec`. The `_\$RatingSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RatingSpecMethods = _$RatingSpec; // ignore: unused_element

mixin _$RatingStarSpec implements Spec<RatingStarSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  RemixBoxEffectsSpec? get containerEffects;
  double? get glyphSize;
  double? get strokeWidth;
  double? get glyphScale;
  Color? get emptyColor;
  Color? get outlineColor;
  Color? get keptColor;
  Color? get fillColor;

  @override
  Type get type => RatingStarSpec;

  @override
  RatingStarSpec copyWith({
    StyleSpec<BoxSpec>? container,
    RemixBoxEffectsSpec? containerEffects,
    double? glyphSize,
    double? strokeWidth,
    double? glyphScale,
    Color? emptyColor,
    Color? outlineColor,
    Color? keptColor,
    Color? fillColor,
  }) {
    return RatingStarSpec(
      container: container ?? this.container,
      containerEffects: containerEffects ?? this.containerEffects,
      glyphSize: glyphSize ?? this.glyphSize,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      glyphScale: glyphScale ?? this.glyphScale,
      emptyColor: emptyColor ?? this.emptyColor,
      outlineColor: outlineColor ?? this.outlineColor,
      keptColor: keptColor ?? this.keptColor,
      fillColor: fillColor ?? this.fillColor,
    );
  }

  @override
  RatingStarSpec lerp(RatingStarSpec? other, double t) {
    return RatingStarSpec(
      container: container.lerp(other?.container, t),
      containerEffects: MixOps.lerpSnap(
        containerEffects,
        other?.containerEffects,
        t,
      ),
      glyphSize: MixOps.lerp(glyphSize, other?.glyphSize, t),
      strokeWidth: MixOps.lerp(strokeWidth, other?.strokeWidth, t),
      glyphScale: MixOps.lerp(glyphScale, other?.glyphScale, t),
      emptyColor: MixOps.lerp(emptyColor, other?.emptyColor, t),
      outlineColor: MixOps.lerp(outlineColor, other?.outlineColor, t),
      keptColor: MixOps.lerp(keptColor, other?.keptColor, t),
      fillColor: MixOps.lerp(fillColor, other?.fillColor, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    containerEffects,
    glyphSize,
    strokeWidth,
    glyphScale,
    emptyColor,
    outlineColor,
    keptColor,
    fillColor,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RatingStarSpec &&
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
      ..add(DoubleProperty('glyphSize', glyphSize))
      ..add(DoubleProperty('strokeWidth', strokeWidth))
      ..add(DoubleProperty('glyphScale', glyphScale))
      ..add(ColorProperty('emptyColor', emptyColor))
      ..add(ColorProperty('outlineColor', outlineColor))
      ..add(ColorProperty('keptColor', keptColor))
      ..add(ColorProperty('fillColor', fillColor));
  }
}

@Deprecated(
  'Rename to `_\$RatingStarSpec` and migrate the class declaration to `class RatingStarSpec with _\$RatingStarSpec`. The `_\$RatingStarSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RatingStarSpecMethods = _$RatingStarSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class RatingStyler extends MixStyler<RatingStyler, RatingSpec>
    with RemixBoxStylerMixin<RatingStyler>, LabelStyleMixin<RatingStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<FlexBoxSpec>>? $container;
  final Prop<StyleSpec<FlexBoxSpec>>? $controlRow;
  final Prop<StyleSpec<FlexBoxSpec>>? $stars;
  final Prop<StyleSpec<RatingStarSpec>>? $star;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<TextSpec>>? $valueText;
  final Prop<StyleSpec<TextSpec>>? $description;
  final Prop<AnimationConfig>? $fillMotion;
  final Prop<Duration>? $fillStagger;
  final Prop<AnimationConfig>? $keptMotion;

  const RatingStyler.create({
    Prop<StyleSpec<FlexBoxSpec>>? container,
    Prop<StyleSpec<FlexBoxSpec>>? controlRow,
    Prop<StyleSpec<FlexBoxSpec>>? stars,
    Prop<StyleSpec<RatingStarSpec>>? star,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<TextSpec>>? valueText,
    Prop<StyleSpec<TextSpec>>? description,
    Prop<AnimationConfig>? fillMotion,
    Prop<Duration>? fillStagger,
    Prop<AnimationConfig>? keptMotion,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $controlRow = controlRow,
       $stars = stars,
       $star = star,
       $label = label,
       $valueText = valueText,
       $description = description,
       $fillMotion = fillMotion,
       $fillStagger = fillStagger,
       $keptMotion = keptMotion;

  RatingStyler({
    FlexBoxStyler? container,
    FlexBoxStyler? controlRow,
    FlexBoxStyler? stars,
    RatingStarStyler? star,
    TextStyler? label,
    TextStyler? valueText,
    TextStyler? description,
    AnimationConfig? fillMotion,
    Duration? fillStagger,
    AnimationConfig? keptMotion,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<RatingSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         controlRow: Prop.maybeMix(controlRow),
         stars: Prop.maybeMix(stars),
         star: Prop.maybeMix(star),
         label: Prop.maybeMix(label),
         valueText: Prop.maybeMix(valueText),
         description: Prop.maybeMix(description),
         fillMotion: Prop.maybe(fillMotion),
         fillStagger: Prop.maybe(fillStagger),
         keptMotion: Prop.maybe(keptMotion),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory RatingStyler.container(FlexBoxStyler value) =>
      RatingStyler().container(value);
  factory RatingStyler.controlRow(FlexBoxStyler value) =>
      RatingStyler().controlRow(value);
  factory RatingStyler.stars(FlexBoxStyler value) =>
      RatingStyler().stars(value);
  factory RatingStyler.star(RatingStarStyler value) =>
      RatingStyler().star(value);
  factory RatingStyler.label(TextStyler value) => RatingStyler().label(value);
  factory RatingStyler.valueText(TextStyler value) =>
      RatingStyler().valueText(value);
  factory RatingStyler.description(TextStyler value) =>
      RatingStyler().description(value);
  factory RatingStyler.fillMotion(AnimationConfig value) =>
      RatingStyler().fillMotion(value);
  factory RatingStyler.fillStagger(Duration value) =>
      RatingStyler().fillStagger(value);
  factory RatingStyler.keptMotion(AnimationConfig value) =>
      RatingStyler().keptMotion(value);
  factory RatingStyler.color(Color value) => RatingStyler().color(value);
  factory RatingStyler.gradient(GradientMix value) =>
      RatingStyler().gradient(value);
  factory RatingStyler.border(BoxBorderMix value) =>
      RatingStyler().border(value);
  factory RatingStyler.borderRadius(BorderRadiusGeometryMix value) =>
      RatingStyler().borderRadius(value);
  factory RatingStyler.elevation(ElevationShadow value) =>
      RatingStyler().elevation(value);
  factory RatingStyler.shadow(BoxShadowMix value) =>
      RatingStyler().shadow(value);
  factory RatingStyler.shadows(List<BoxShadowMix> value) =>
      RatingStyler().shadows(value);
  factory RatingStyler.width(double value) => RatingStyler().width(value);
  factory RatingStyler.height(double value) => RatingStyler().height(value);
  factory RatingStyler.size(double width, double height) =>
      RatingStyler().size(width, height);
  factory RatingStyler.minWidth(double value) => RatingStyler().minWidth(value);
  factory RatingStyler.maxWidth(double value) => RatingStyler().maxWidth(value);
  factory RatingStyler.minHeight(double value) =>
      RatingStyler().minHeight(value);
  factory RatingStyler.maxHeight(double value) =>
      RatingStyler().maxHeight(value);
  factory RatingStyler.scale(double scale, {Alignment alignment = .center}) =>
      RatingStyler().scale(scale, alignment: alignment);
  factory RatingStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => RatingStyler().rotate(radians, alignment: alignment);
  factory RatingStyler.translate(double x, double y, [double z = 0.0]) =>
      RatingStyler().translate(x, y, z);
  factory RatingStyler.skew(double skewX, double skewY) =>
      RatingStyler().skew(skewX, skewY);
  factory RatingStyler.textStyle(TextStyler value) =>
      RatingStyler().textStyle(value);
  factory RatingStyler.image(DecorationImageMix value) =>
      RatingStyler().image(value);
  factory RatingStyler.shape(ShapeBorderMix value) =>
      RatingStyler().shape(value);
  factory RatingStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RatingStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RatingStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RatingStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RatingStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RatingStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RatingStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStyler.row() => RatingStyler().row();
  factory RatingStyler.column() => RatingStyler().column();
  factory RatingStyler.alignment(AlignmentGeometry value) =>
      RatingStyler().alignment(value);
  factory RatingStyler.padding(EdgeInsetsGeometryMix value) =>
      RatingStyler().padding(value);
  factory RatingStyler.margin(EdgeInsetsGeometryMix value) =>
      RatingStyler().margin(value);
  factory RatingStyler.constraints(BoxConstraintsMix value) =>
      RatingStyler().constraints(value);
  factory RatingStyler.decoration(DecorationMix value) =>
      RatingStyler().decoration(value);
  factory RatingStyler.foregroundDecoration(DecorationMix value) =>
      RatingStyler().foregroundDecoration(value);
  factory RatingStyler.clipBehavior(Clip value) =>
      RatingStyler().clipBehavior(value);
  factory RatingStyler.direction(Axis value) => RatingStyler().direction(value);
  factory RatingStyler.mainAxisAlignment(MainAxisAlignment value) =>
      RatingStyler().mainAxisAlignment(value);
  factory RatingStyler.crossAxisAlignment(CrossAxisAlignment value) =>
      RatingStyler().crossAxisAlignment(value);
  factory RatingStyler.mainAxisSize(MainAxisSize value) =>
      RatingStyler().mainAxisSize(value);
  factory RatingStyler.spacing(double value) => RatingStyler().spacing(value);
  factory RatingStyler.verticalDirection(VerticalDirection value) =>
      RatingStyler().verticalDirection(value);
  factory RatingStyler.textDirection(TextDirection value) =>
      RatingStyler().textDirection(value);
  factory RatingStyler.textBaseline(TextBaseline value) =>
      RatingStyler().textBaseline(value);
  factory RatingStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => RatingStyler().transform(value, alignment: alignment);
  factory RatingStyler.wrap(WidgetModifierConfig value) =>
      RatingStyler().wrap(value);

  RatingStyler color(Color value) {
    return container(FlexBoxStyler().color(value));
  }

  RatingStyler gradient(GradientMix value) {
    return container(FlexBoxStyler().gradient(value));
  }

  RatingStyler border(BoxBorderMix value) {
    return container(FlexBoxStyler().border(value));
  }

  RatingStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(FlexBoxStyler().borderRadius(value));
  }

  RatingStyler elevation(ElevationShadow value) {
    return container(FlexBoxStyler().elevation(value));
  }

  RatingStyler shadow(BoxShadowMix value) {
    return container(FlexBoxStyler().shadow(value));
  }

  RatingStyler shadows(List<BoxShadowMix> value) {
    return container(FlexBoxStyler().shadows(value));
  }

  RatingStyler width(double value) {
    return container(FlexBoxStyler().width(value));
  }

  RatingStyler height(double value) {
    return container(FlexBoxStyler().height(value));
  }

  RatingStyler size(double width, double height) {
    return container(FlexBoxStyler().size(width, height));
  }

  RatingStyler minWidth(double value) {
    return container(FlexBoxStyler().minWidth(value));
  }

  RatingStyler maxWidth(double value) {
    return container(FlexBoxStyler().maxWidth(value));
  }

  RatingStyler minHeight(double value) {
    return container(FlexBoxStyler().minHeight(value));
  }

  RatingStyler maxHeight(double value) {
    return container(FlexBoxStyler().maxHeight(value));
  }

  RatingStyler scale(double scale, {Alignment alignment = .center}) {
    return container(FlexBoxStyler().scale(scale, alignment: alignment));
  }

  RatingStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(FlexBoxStyler().rotate(radians, alignment: alignment));
  }

  RatingStyler translate(double x, double y, [double z = 0.0]) {
    return container(FlexBoxStyler().translate(x, y, z));
  }

  RatingStyler skew(double skewX, double skewY) {
    return container(FlexBoxStyler().skew(skewX, skewY));
  }

  RatingStyler textStyle(TextStyler value) {
    return container(FlexBoxStyler().textStyle(value));
  }

  RatingStyler image(DecorationImageMix value) {
    return container(FlexBoxStyler().image(value));
  }

  RatingStyler shape(ShapeBorderMix value) {
    return container(FlexBoxStyler().shape(value));
  }

  RatingStyler backgroundImage(
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

  RatingStyler backgroundImageUrl(
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

  RatingStyler backgroundImageAsset(
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

  RatingStyler linearGradient({
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

  RatingStyler radialGradient({
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

  RatingStyler sweepGradient({
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

  RatingStyler foregroundLinearGradient({
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

  RatingStyler foregroundRadialGradient({
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

  RatingStyler foregroundSweepGradient({
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

  RatingStyler row() {
    return container(FlexBoxStyler().row());
  }

  RatingStyler column() {
    return container(FlexBoxStyler().column());
  }

  RatingStyler alignment(AlignmentGeometry value) {
    return container(FlexBoxStyler().alignment(value));
  }

  RatingStyler padding(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler().padding(value));
  }

  RatingStyler margin(EdgeInsetsGeometryMix value) {
    return container(FlexBoxStyler().margin(value));
  }

  RatingStyler constraints(BoxConstraintsMix value) {
    return container(FlexBoxStyler().constraints(value));
  }

  RatingStyler decoration(DecorationMix value) {
    return container(FlexBoxStyler().decoration(value));
  }

  RatingStyler foregroundDecoration(DecorationMix value) {
    return container(FlexBoxStyler().foregroundDecoration(value));
  }

  RatingStyler clipBehavior(Clip value) {
    return container(FlexBoxStyler().clipBehavior(value));
  }

  RatingStyler direction(Axis value) {
    return container(FlexBoxStyler().direction(value));
  }

  RatingStyler mainAxisAlignment(MainAxisAlignment value) {
    return container(FlexBoxStyler().mainAxisAlignment(value));
  }

  RatingStyler crossAxisAlignment(CrossAxisAlignment value) {
    return container(FlexBoxStyler().crossAxisAlignment(value));
  }

  RatingStyler mainAxisSize(MainAxisSize value) {
    return container(FlexBoxStyler().mainAxisSize(value));
  }

  RatingStyler spacing(double value) {
    return container(FlexBoxStyler().spacing(value));
  }

  RatingStyler verticalDirection(VerticalDirection value) {
    return container(FlexBoxStyler().verticalDirection(value));
  }

  RatingStyler textDirection(TextDirection value) {
    return container(FlexBoxStyler().textDirection(value));
  }

  RatingStyler textBaseline(TextBaseline value) {
    return container(FlexBoxStyler().textBaseline(value));
  }

  RatingStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return container(FlexBoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'controlRow',
    'stars',
    'star',
    'label',
    'valueText',
    'description',
    'fillMotion',
    'fillStagger',
    'keptMotion',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  RatingStyler container(FlexBoxStyler value) {
    return merge(RatingStyler(container: value));
  }

  /// Sets the controlRow.
  RatingStyler controlRow(FlexBoxStyler value) {
    return merge(RatingStyler(controlRow: value));
  }

  /// Sets the stars.
  RatingStyler stars(FlexBoxStyler value) {
    return merge(RatingStyler(stars: value));
  }

  /// Sets the star.
  RatingStyler star(RatingStarStyler value) {
    return merge(RatingStyler(star: value));
  }

  /// Sets the label.
  @override
  RatingStyler label(TextStyler value) {
    return merge(RatingStyler(label: value));
  }

  /// Sets the valueText.
  RatingStyler valueText(TextStyler value) {
    return merge(RatingStyler(valueText: value));
  }

  /// Sets the description.
  RatingStyler description(TextStyler value) {
    return merge(RatingStyler(description: value));
  }

  /// Sets the fillMotion.
  RatingStyler fillMotion(AnimationConfig value) {
    return merge(RatingStyler(fillMotion: value));
  }

  /// Sets the fillStagger.
  RatingStyler fillStagger(Duration value) {
    return merge(RatingStyler(fillStagger: value));
  }

  /// Sets the keptMotion.
  RatingStyler keptMotion(AnimationConfig value) {
    return merge(RatingStyler(keptMotion: value));
  }

  /// Sets the animation configuration.
  @override
  RatingStyler animate(AnimationConfig value) {
    return merge(RatingStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  RatingStyler variants(List<VariantStyle<RatingSpec>> value) {
    return merge(RatingStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  RatingStyler wrap(WidgetModifierConfig value) {
    return merge(RatingStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RatingStyler modifier(WidgetModifierConfig value) {
    return merge(RatingStyler(modifier: value));
  }

  RemixRating call({
    Key? key,
    required int? value,
    ValueChanged<int?>? onChanged,
    int max = 5,
    bool allowClear = true,
    bool enabled = true,
    String? label,
    String? description,
    String? semanticLabel,
    RemixRatingValueLabelBuilder? valueLabelBuilder =
        RemixRating.defaultValueLabel,
    RemixRatingStarLabelBuilder starSemanticLabelBuilder =
        RemixRating.defaultStarSemanticLabel,
  }) {
    return RemixRating(
      key: key,
      style: this,
      value: value,
      onChanged: onChanged,
      max: max,
      allowClear: allowClear,
      enabled: enabled,
      label: label,
      description: description,
      semanticLabel: semanticLabel,
      valueLabelBuilder: valueLabelBuilder,
      starSemanticLabelBuilder: starSemanticLabelBuilder,
    );
  }

  /// Merges with another [RatingStyler].
  @override
  RatingStyler merge(RatingStyler? other) {
    return RatingStyler.create(
      container: MixOps.merge($container, other?.$container),
      controlRow: MixOps.merge($controlRow, other?.$controlRow),
      stars: MixOps.merge($stars, other?.$stars),
      star: MixOps.merge($star, other?.$star),
      label: MixOps.merge($label, other?.$label),
      valueText: MixOps.merge($valueText, other?.$valueText),
      description: MixOps.merge($description, other?.$description),
      fillMotion: MixOps.merge($fillMotion, other?.$fillMotion),
      fillStagger: MixOps.merge($fillStagger, other?.$fillStagger),
      keptMotion: MixOps.merge($keptMotion, other?.$keptMotion),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RatingSpec>] using [context].
  @override
  StyleSpec<RatingSpec> resolve(BuildContext context) {
    final spec = RatingSpec(
      container: MixOps.resolve(context, $container),
      controlRow: MixOps.resolve(context, $controlRow),
      stars: MixOps.resolve(context, $stars),
      star: MixOps.resolve(context, $star),
      label: MixOps.resolve(context, $label),
      valueText: MixOps.resolve(context, $valueText),
      description: MixOps.resolve(context, $description),
      fillMotion: MixOps.resolve(context, $fillMotion),
      fillStagger: MixOps.resolve(context, $fillStagger),
      keptMotion: MixOps.resolve(context, $keptMotion),
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
      ..add(DiagnosticsProperty('controlRow', $controlRow))
      ..add(DiagnosticsProperty('stars', $stars))
      ..add(DiagnosticsProperty('star', $star))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('valueText', $valueText))
      ..add(DiagnosticsProperty('description', $description))
      ..add(DiagnosticsProperty('fillMotion', $fillMotion))
      ..add(DiagnosticsProperty('fillStagger', $fillStagger))
      ..add(DiagnosticsProperty('keptMotion', $keptMotion));
  }

  @override
  List<Object?> get props => [
    $container,
    $controlRow,
    $stars,
    $star,
    $label,
    $valueText,
    $description,
    $fillMotion,
    $fillStagger,
    $keptMotion,
    $animation,
    $modifier,
    $variants,
  ];
}

class RatingStarStyler extends MixStyler<RatingStarStyler, RatingStarSpec>
    with RemixBoxStylerMixin<RatingStarStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<RemixBoxEffectsSpec>? $containerEffects;
  final Prop<double>? $glyphSize;
  final Prop<double>? $strokeWidth;
  final Prop<double>? $glyphScale;
  final Prop<Color>? $emptyColor;
  final Prop<Color>? $outlineColor;
  final Prop<Color>? $keptColor;
  final Prop<Color>? $fillColor;

  const RatingStarStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<RemixBoxEffectsSpec>? containerEffects,
    Prop<double>? glyphSize,
    Prop<double>? strokeWidth,
    Prop<double>? glyphScale,
    Prop<Color>? emptyColor,
    Prop<Color>? outlineColor,
    Prop<Color>? keptColor,
    Prop<Color>? fillColor,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $containerEffects = containerEffects,
       $glyphSize = glyphSize,
       $strokeWidth = strokeWidth,
       $glyphScale = glyphScale,
       $emptyColor = emptyColor,
       $outlineColor = outlineColor,
       $keptColor = keptColor,
       $fillColor = fillColor;

  RatingStarStyler({
    BoxStyler? container,
    RemixBoxEffectsMix? containerEffects,
    double? glyphSize,
    double? strokeWidth,
    double? glyphScale,
    Color? emptyColor,
    Color? outlineColor,
    Color? keptColor,
    Color? fillColor,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<RatingStarSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         containerEffects: Prop.maybeMix(containerEffects),
         glyphSize: Prop.maybe(glyphSize),
         strokeWidth: Prop.maybe(strokeWidth),
         glyphScale: Prop.maybe(glyphScale),
         emptyColor: Prop.maybe(emptyColor),
         outlineColor: Prop.maybe(outlineColor),
         keptColor: Prop.maybe(keptColor),
         fillColor: Prop.maybe(fillColor),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory RatingStarStyler.container(BoxStyler value) =>
      RatingStarStyler().container(value);
  factory RatingStarStyler.containerEffects(RemixBoxEffectsMix value) =>
      RatingStarStyler().containerEffects(value);
  factory RatingStarStyler.glyphSize(double value) =>
      RatingStarStyler().glyphSize(value);
  factory RatingStarStyler.strokeWidth(double value) =>
      RatingStarStyler().strokeWidth(value);
  factory RatingStarStyler.glyphScale(double value) =>
      RatingStarStyler().glyphScale(value);
  factory RatingStarStyler.emptyColor(Color value) =>
      RatingStarStyler().emptyColor(value);
  factory RatingStarStyler.outlineColor(Color value) =>
      RatingStarStyler().outlineColor(value);
  factory RatingStarStyler.keptColor(Color value) =>
      RatingStarStyler().keptColor(value);
  factory RatingStarStyler.fillColor(Color value) =>
      RatingStarStyler().fillColor(value);
  factory RatingStarStyler.alignment(AlignmentGeometry value) =>
      RatingStarStyler().alignment(value);
  factory RatingStarStyler.padding(EdgeInsetsGeometryMix value) =>
      RatingStarStyler().padding(value);
  factory RatingStarStyler.margin(EdgeInsetsGeometryMix value) =>
      RatingStarStyler().margin(value);
  factory RatingStarStyler.constraints(BoxConstraintsMix value) =>
      RatingStarStyler().constraints(value);
  factory RatingStarStyler.decoration(DecorationMix value) =>
      RatingStarStyler().decoration(value);
  factory RatingStarStyler.foregroundDecoration(DecorationMix value) =>
      RatingStarStyler().foregroundDecoration(value);
  factory RatingStarStyler.clipBehavior(Clip value) =>
      RatingStarStyler().clipBehavior(value);
  factory RatingStarStyler.color(Color value) =>
      RatingStarStyler().color(value);
  factory RatingStarStyler.gradient(GradientMix value) =>
      RatingStarStyler().gradient(value);
  factory RatingStarStyler.border(BoxBorderMix value) =>
      RatingStarStyler().border(value);
  factory RatingStarStyler.borderRadius(BorderRadiusGeometryMix value) =>
      RatingStarStyler().borderRadius(value);
  factory RatingStarStyler.elevation(ElevationShadow value) =>
      RatingStarStyler().elevation(value);
  factory RatingStarStyler.shadow(BoxShadowMix value) =>
      RatingStarStyler().shadow(value);
  factory RatingStarStyler.shadows(List<BoxShadowMix> value) =>
      RatingStarStyler().shadows(value);
  factory RatingStarStyler.width(double value) =>
      RatingStarStyler().width(value);
  factory RatingStarStyler.height(double value) =>
      RatingStarStyler().height(value);
  factory RatingStarStyler.size(double width, double height) =>
      RatingStarStyler().size(width, height);
  factory RatingStarStyler.minWidth(double value) =>
      RatingStarStyler().minWidth(value);
  factory RatingStarStyler.maxWidth(double value) =>
      RatingStarStyler().maxWidth(value);
  factory RatingStarStyler.minHeight(double value) =>
      RatingStarStyler().minHeight(value);
  factory RatingStarStyler.maxHeight(double value) =>
      RatingStarStyler().maxHeight(value);
  factory RatingStarStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => RatingStarStyler().scale(scale, alignment: alignment);
  factory RatingStarStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => RatingStarStyler().rotate(radians, alignment: alignment);
  factory RatingStarStyler.translate(double x, double y, [double z = 0.0]) =>
      RatingStarStyler().translate(x, y, z);
  factory RatingStarStyler.skew(double skewX, double skewY) =>
      RatingStarStyler().skew(skewX, skewY);
  factory RatingStarStyler.textStyle(TextStyler value) =>
      RatingStarStyler().textStyle(value);
  factory RatingStarStyler.image(DecorationImageMix value) =>
      RatingStarStyler().image(value);
  factory RatingStarStyler.shape(ShapeBorderMix value) =>
      RatingStarStyler().shape(value);
  factory RatingStarStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RatingStarStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RatingStarStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RatingStarStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RatingStarStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RatingStarStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RatingStarStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStarStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStarStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStarStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStarStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStarStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStarStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStarStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStarStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStarStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStarStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => RatingStarStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory RatingStarStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => RatingStarStyler().transform(value, alignment: alignment);
  factory RatingStarStyler.wrap(WidgetModifierConfig value) =>
      RatingStarStyler().wrap(value);

  RatingStarStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  RatingStarStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  RatingStarStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  RatingStarStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  RatingStarStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  RatingStarStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  RatingStarStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  RatingStarStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  RatingStarStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  RatingStarStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  RatingStarStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  RatingStarStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  RatingStarStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  RatingStarStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  RatingStarStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  RatingStarStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  RatingStarStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  RatingStarStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  RatingStarStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  RatingStarStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  RatingStarStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  RatingStarStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  RatingStarStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  RatingStarStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  RatingStarStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  RatingStarStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  RatingStarStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  RatingStarStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  RatingStarStyler backgroundImage(
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

  RatingStarStyler backgroundImageUrl(
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

  RatingStarStyler backgroundImageAsset(
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

  RatingStarStyler linearGradient({
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

  RatingStarStyler radialGradient({
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

  RatingStarStyler sweepGradient({
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

  RatingStarStyler foregroundLinearGradient({
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

  RatingStarStyler foregroundRadialGradient({
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

  RatingStarStyler foregroundSweepGradient({
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

  RatingStarStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'containerEffects',
    'glyphSize',
    'strokeWidth',
    'glyphScale',
    'emptyColor',
    'outlineColor',
    'keptColor',
    'fillColor',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  RatingStarStyler container(BoxStyler value) {
    return merge(RatingStarStyler(container: value));
  }

  /// Sets the containerEffects.
  RatingStarStyler containerEffects(RemixBoxEffectsMix value) {
    return merge(RatingStarStyler(containerEffects: value));
  }

  /// Sets the glyphSize.
  RatingStarStyler glyphSize(double value) {
    return merge(RatingStarStyler(glyphSize: value));
  }

  /// Sets the strokeWidth.
  RatingStarStyler strokeWidth(double value) {
    return merge(RatingStarStyler(strokeWidth: value));
  }

  /// Sets the glyphScale.
  RatingStarStyler glyphScale(double value) {
    return merge(RatingStarStyler(glyphScale: value));
  }

  /// Sets the emptyColor.
  RatingStarStyler emptyColor(Color value) {
    return merge(RatingStarStyler(emptyColor: value));
  }

  /// Sets the outlineColor.
  RatingStarStyler outlineColor(Color value) {
    return merge(RatingStarStyler(outlineColor: value));
  }

  /// Sets the keptColor.
  RatingStarStyler keptColor(Color value) {
    return merge(RatingStarStyler(keptColor: value));
  }

  /// Sets the fillColor.
  RatingStarStyler fillColor(Color value) {
    return merge(RatingStarStyler(fillColor: value));
  }

  /// Sets the animation configuration.
  @override
  RatingStarStyler animate(AnimationConfig value) {
    return merge(RatingStarStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  RatingStarStyler variants(List<VariantStyle<RatingStarSpec>> value) {
    return merge(RatingStarStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  RatingStarStyler wrap(WidgetModifierConfig value) {
    return merge(RatingStarStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RatingStarStyler modifier(WidgetModifierConfig value) {
    return merge(RatingStarStyler(modifier: value));
  }

  /// Merges with another [RatingStarStyler].
  @override
  RatingStarStyler merge(RatingStarStyler? other) {
    return RatingStarStyler.create(
      container: MixOps.merge($container, other?.$container),
      containerEffects: MixOps.merge(
        $containerEffects,
        other?.$containerEffects,
      ),
      glyphSize: MixOps.merge($glyphSize, other?.$glyphSize),
      strokeWidth: MixOps.merge($strokeWidth, other?.$strokeWidth),
      glyphScale: MixOps.merge($glyphScale, other?.$glyphScale),
      emptyColor: MixOps.merge($emptyColor, other?.$emptyColor),
      outlineColor: MixOps.merge($outlineColor, other?.$outlineColor),
      keptColor: MixOps.merge($keptColor, other?.$keptColor),
      fillColor: MixOps.merge($fillColor, other?.$fillColor),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RatingStarSpec>] using [context].
  @override
  StyleSpec<RatingStarSpec> resolve(BuildContext context) {
    final spec = RatingStarSpec(
      container: MixOps.resolve(context, $container),
      containerEffects: MixOps.resolve(context, $containerEffects),
      glyphSize: MixOps.resolve(context, $glyphSize),
      strokeWidth: MixOps.resolve(context, $strokeWidth),
      glyphScale: MixOps.resolve(context, $glyphScale),
      emptyColor: MixOps.resolve(context, $emptyColor),
      outlineColor: MixOps.resolve(context, $outlineColor),
      keptColor: MixOps.resolve(context, $keptColor),
      fillColor: MixOps.resolve(context, $fillColor),
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
      ..add(DiagnosticsProperty('glyphSize', $glyphSize))
      ..add(DiagnosticsProperty('strokeWidth', $strokeWidth))
      ..add(DiagnosticsProperty('glyphScale', $glyphScale))
      ..add(DiagnosticsProperty('emptyColor', $emptyColor))
      ..add(DiagnosticsProperty('outlineColor', $outlineColor))
      ..add(DiagnosticsProperty('keptColor', $keptColor))
      ..add(DiagnosticsProperty('fillColor', $fillColor));
  }

  @override
  List<Object?> get props => [
    $container,
    $containerEffects,
    $glyphSize,
    $strokeWidth,
    $glyphScale,
    $emptyColor,
    $outlineColor,
    $keptColor,
    $fillColor,
    $animation,
    $modifier,
    $variants,
  ];
}
