// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slider.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixSliderSpec implements Spec<RemixSliderSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get thumb;
  Color get trackColor;
  double get trackWidth;
  Color get rangeColor;
  double get rangeWidth;

  @override
  Type get type => RemixSliderSpec;

  @override
  RemixSliderSpec copyWith({
    StyleSpec<BoxSpec>? thumb,
    Color? trackColor,
    double? trackWidth,
    Color? rangeColor,
    double? rangeWidth,
  }) {
    return RemixSliderSpec(
      thumb: thumb ?? this.thumb,
      trackColor: trackColor ?? this.trackColor,
      trackWidth: trackWidth ?? this.trackWidth,
      rangeColor: rangeColor ?? this.rangeColor,
      rangeWidth: rangeWidth ?? this.rangeWidth,
    );
  }

  @override
  RemixSliderSpec lerp(RemixSliderSpec? other, double t) {
    return RemixSliderSpec(
      thumb: thumb.lerp(other?.thumb, t),
      trackColor: MixOps.lerp(trackColor, other?.trackColor, t),
      trackWidth: MixOps.lerp(trackWidth, other?.trackWidth, t),
      rangeColor: MixOps.lerp(rangeColor, other?.rangeColor, t),
      rangeWidth: MixOps.lerp(rangeWidth, other?.rangeWidth, t),
    );
  }

  @override
  List<Object?> get props => [
    thumb,
    trackColor,
    trackWidth,
    rangeColor,
    rangeWidth,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixSliderSpec &&
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
      ..add(DiagnosticsProperty('thumb', thumb))
      ..add(ColorProperty('trackColor', trackColor))
      ..add(DoubleProperty('trackWidth', trackWidth))
      ..add(ColorProperty('rangeColor', rangeColor))
      ..add(DoubleProperty('rangeWidth', rangeWidth));
  }
}

@Deprecated(
  'Rename to `_\$RemixSliderSpec` and migrate the class declaration to `class RemixSliderSpec with _\$RemixSliderSpec`. The `_\$RemixSliderSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixSliderSpecMethods = _$RemixSliderSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed preset for [RemixSlider].
class FortalSlider extends StatelessWidget {
  const FortalSlider({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.snapDivisions,
  });

  /// Neutral track with the active accent indicator.
  const FortalSlider.surface({
    super.key,
    this.size = .size2,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.snapDivisions,
  }) : variant = FortalSliderVariant.surface;

  /// Softer accent treatment for lower-emphasis controls.
  const FortalSlider.soft({
    super.key,
    this.size = .size2,
    required this.value,
    this.onChanged,
    this.onChangeStart,
    this.onChangeEnd,
    this.min = 0.0,
    this.max = 1.0,
    this.enabled = true,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.snapDivisions,
  }) : variant = FortalSliderVariant.soft;

  final FortalSliderVariant variant;

  final FortalSliderSize size;

  final double value;

  final ValueChanged<double>? onChanged;

  final ValueChanged<double>? onChangeStart;

  final ValueChanged<double>? onChangeEnd;

  final double min;

  final double max;

  final bool enabled;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final int? snapDivisions;

  @override
  Widget build(BuildContext context) {
    return RemixSlider(
      key: this.key,
      style: fortalSliderStyler(variant: this.variant, size: this.size),
      value: this.value,
      onChanged: this.onChanged,
      onChangeStart: this.onChangeStart,
      onChangeEnd: this.onChangeEnd,
      min: this.min,
      max: this.max,
      enabled: this.enabled,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      snapDivisions: this.snapDivisions,
    );
  }
}

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class RemixSliderStyler extends MixStyler<RemixSliderStyler, RemixSliderSpec>
    with RemixBoxStylerMixin<RemixSliderStyler> {
  final Prop<StyleSpec<BoxSpec>>? $thumb;
  final Prop<Color>? $trackColor;
  final Prop<double>? $trackWidth;
  final Prop<Color>? $rangeColor;
  final Prop<double>? $rangeWidth;

  const RemixSliderStyler.create({
    Prop<StyleSpec<BoxSpec>>? thumb,
    Prop<Color>? trackColor,
    Prop<double>? trackWidth,
    Prop<Color>? rangeColor,
    Prop<double>? rangeWidth,
    super.variants,
    super.modifier,
    super.animation,
  }) : $thumb = thumb,
       $trackColor = trackColor,
       $trackWidth = trackWidth,
       $rangeColor = rangeColor,
       $rangeWidth = rangeWidth;

  RemixSliderStyler({
    BoxStyler? thumb,
    Color? trackColor,
    double? trackWidth,
    Color? rangeColor,
    double? rangeWidth,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<RemixSliderSpec>>? variants,
  }) : this.create(
         thumb: Prop.maybeMix(thumb),
         trackColor: Prop.maybe(trackColor),
         trackWidth: Prop.maybe(trackWidth),
         rangeColor: Prop.maybe(rangeColor),
         rangeWidth: Prop.maybe(rangeWidth),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory RemixSliderStyler.thumb(BoxStyler value) =>
      RemixSliderStyler().thumb(value);
  factory RemixSliderStyler.trackColor(Color value) =>
      RemixSliderStyler().trackColor(value);
  factory RemixSliderStyler.trackWidth(double value) =>
      RemixSliderStyler().trackWidth(value);
  factory RemixSliderStyler.rangeColor(Color value) =>
      RemixSliderStyler().rangeColor(value);
  factory RemixSliderStyler.rangeWidth(double value) =>
      RemixSliderStyler().rangeWidth(value);
  factory RemixSliderStyler.alignment(AlignmentGeometry value) =>
      RemixSliderStyler().alignment(value);
  factory RemixSliderStyler.padding(EdgeInsetsGeometryMix value) =>
      RemixSliderStyler().padding(value);
  factory RemixSliderStyler.margin(EdgeInsetsGeometryMix value) =>
      RemixSliderStyler().margin(value);
  factory RemixSliderStyler.constraints(BoxConstraintsMix value) =>
      RemixSliderStyler().constraints(value);
  factory RemixSliderStyler.decoration(DecorationMix value) =>
      RemixSliderStyler().decoration(value);
  factory RemixSliderStyler.foregroundDecoration(DecorationMix value) =>
      RemixSliderStyler().foregroundDecoration(value);
  factory RemixSliderStyler.clipBehavior(Clip value) =>
      RemixSliderStyler().clipBehavior(value);
  factory RemixSliderStyler.color(Color value) =>
      RemixSliderStyler().color(value);
  factory RemixSliderStyler.gradient(GradientMix value) =>
      RemixSliderStyler().gradient(value);
  factory RemixSliderStyler.border(BoxBorderMix value) =>
      RemixSliderStyler().border(value);
  factory RemixSliderStyler.borderRadius(BorderRadiusGeometryMix value) =>
      RemixSliderStyler().borderRadius(value);
  factory RemixSliderStyler.elevation(ElevationShadow value) =>
      RemixSliderStyler().elevation(value);
  factory RemixSliderStyler.shadow(BoxShadowMix value) =>
      RemixSliderStyler().shadow(value);
  factory RemixSliderStyler.shadows(List<BoxShadowMix> value) =>
      RemixSliderStyler().shadows(value);
  factory RemixSliderStyler.width(double value) =>
      RemixSliderStyler().width(value);
  factory RemixSliderStyler.height(double value) =>
      RemixSliderStyler().height(value);
  factory RemixSliderStyler.size(double width, double height) =>
      RemixSliderStyler().size(width, height);
  factory RemixSliderStyler.minWidth(double value) =>
      RemixSliderStyler().minWidth(value);
  factory RemixSliderStyler.maxWidth(double value) =>
      RemixSliderStyler().maxWidth(value);
  factory RemixSliderStyler.minHeight(double value) =>
      RemixSliderStyler().minHeight(value);
  factory RemixSliderStyler.maxHeight(double value) =>
      RemixSliderStyler().maxHeight(value);
  factory RemixSliderStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => RemixSliderStyler().scale(scale, alignment: alignment);
  factory RemixSliderStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => RemixSliderStyler().rotate(radians, alignment: alignment);
  factory RemixSliderStyler.translate(double x, double y, [double z = 0.0]) =>
      RemixSliderStyler().translate(x, y, z);
  factory RemixSliderStyler.skew(double skewX, double skewY) =>
      RemixSliderStyler().skew(skewX, skewY);
  factory RemixSliderStyler.textStyle(TextStyler value) =>
      RemixSliderStyler().textStyle(value);
  factory RemixSliderStyler.image(DecorationImageMix value) =>
      RemixSliderStyler().image(value);
  factory RemixSliderStyler.shape(ShapeBorderMix value) =>
      RemixSliderStyler().shape(value);
  factory RemixSliderStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSliderStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSliderStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSliderStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSliderStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => RemixSliderStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory RemixSliderStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => RemixSliderStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory RemixSliderStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => RemixSliderStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory RemixSliderStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => RemixSliderStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory RemixSliderStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) => RemixSliderStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
  );
  factory RemixSliderStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) => RemixSliderStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
  );
  factory RemixSliderStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) => RemixSliderStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
  );
  factory RemixSliderStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => RemixSliderStyler().transform(value, alignment: alignment);

  RemixSliderStyler alignment(AlignmentGeometry value) {
    return thumb(BoxStyler().alignment(value));
  }

  RemixSliderStyler padding(EdgeInsetsGeometryMix value) {
    return thumb(BoxStyler().padding(value));
  }

  RemixSliderStyler margin(EdgeInsetsGeometryMix value) {
    return thumb(BoxStyler().margin(value));
  }

  RemixSliderStyler constraints(BoxConstraintsMix value) {
    return thumb(BoxStyler().constraints(value));
  }

  RemixSliderStyler decoration(DecorationMix value) {
    return thumb(BoxStyler().decoration(value));
  }

  RemixSliderStyler foregroundDecoration(DecorationMix value) {
    return thumb(BoxStyler().foregroundDecoration(value));
  }

  RemixSliderStyler clipBehavior(Clip value) {
    return thumb(BoxStyler().clipBehavior(value));
  }

  RemixSliderStyler color(Color value) {
    return thumb(BoxStyler().color(value));
  }

  RemixSliderStyler gradient(GradientMix value) {
    return thumb(BoxStyler().gradient(value));
  }

  RemixSliderStyler border(BoxBorderMix value) {
    return thumb(BoxStyler().border(value));
  }

  RemixSliderStyler borderRadius(BorderRadiusGeometryMix value) {
    return thumb(BoxStyler().borderRadius(value));
  }

  RemixSliderStyler elevation(ElevationShadow value) {
    return thumb(BoxStyler().elevation(value));
  }

  RemixSliderStyler shadow(BoxShadowMix value) {
    return thumb(BoxStyler().shadow(value));
  }

  RemixSliderStyler shadows(List<BoxShadowMix> value) {
    return thumb(BoxStyler().shadows(value));
  }

  RemixSliderStyler width(double value) {
    return thumb(BoxStyler().width(value));
  }

  RemixSliderStyler height(double value) {
    return thumb(BoxStyler().height(value));
  }

  RemixSliderStyler size(double width, double height) {
    return thumb(BoxStyler().size(width, height));
  }

  RemixSliderStyler minWidth(double value) {
    return thumb(BoxStyler().minWidth(value));
  }

  RemixSliderStyler maxWidth(double value) {
    return thumb(BoxStyler().maxWidth(value));
  }

  RemixSliderStyler minHeight(double value) {
    return thumb(BoxStyler().minHeight(value));
  }

  RemixSliderStyler maxHeight(double value) {
    return thumb(BoxStyler().maxHeight(value));
  }

  RemixSliderStyler scale(double scale, {Alignment alignment = .center}) {
    return thumb(BoxStyler().scale(scale, alignment: alignment));
  }

  RemixSliderStyler rotate(double radians, {Alignment alignment = .center}) {
    return thumb(BoxStyler().rotate(radians, alignment: alignment));
  }

  RemixSliderStyler translate(double x, double y, [double z = 0.0]) {
    return thumb(BoxStyler().translate(x, y, z));
  }

  RemixSliderStyler skew(double skewX, double skewY) {
    return thumb(BoxStyler().skew(skewX, skewY));
  }

  RemixSliderStyler textStyle(TextStyler value) {
    return thumb(BoxStyler().textStyle(value));
  }

  RemixSliderStyler image(DecorationImageMix value) {
    return thumb(BoxStyler().image(value));
  }

  RemixSliderStyler shape(ShapeBorderMix value) {
    return thumb(BoxStyler().shape(value));
  }

  RemixSliderStyler backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return thumb(
      BoxStyler().backgroundImage(
        image,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSliderStyler backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return thumb(
      BoxStyler().backgroundImageUrl(
        url,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSliderStyler backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) {
    return thumb(
      BoxStyler().backgroundImageAsset(
        path,
        fit: fit,
        alignment: alignment,
        repeat: repeat,
      ),
    );
  }

  RemixSliderStyler linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return thumb(
      BoxStyler().linearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixSliderStyler radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return thumb(
      BoxStyler().radialGradient(
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

  RemixSliderStyler sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return thumb(
      BoxStyler().sweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }

  RemixSliderStyler foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
  }) {
    return thumb(
      BoxStyler().foregroundLinearGradient(
        colors: colors,
        stops: stops,
        begin: begin,
        end: end,
        tileMode: tileMode,
      ),
    );
  }

  RemixSliderStyler foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
  }) {
    return thumb(
      BoxStyler().foregroundRadialGradient(
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

  RemixSliderStyler foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
  }) {
    return thumb(
      BoxStyler().foregroundSweepGradient(
        colors: colors,
        stops: stops,
        center: center,
        startAngle: startAngle,
        endAngle: endAngle,
        tileMode: tileMode,
      ),
    );
  }

  RemixSliderStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return thumb(BoxStyler().transform(value, alignment: alignment));
  }

  /// Sets the thumb.
  RemixSliderStyler thumb(BoxStyler value) {
    return merge(RemixSliderStyler(thumb: value));
  }

  /// Sets the trackColor.
  RemixSliderStyler trackColor(Color value) {
    return merge(RemixSliderStyler(trackColor: value));
  }

  /// Sets the trackWidth.
  RemixSliderStyler trackWidth(double value) {
    return merge(RemixSliderStyler(trackWidth: value));
  }

  /// Sets the rangeColor.
  RemixSliderStyler rangeColor(Color value) {
    return merge(RemixSliderStyler(rangeColor: value));
  }

  /// Sets the rangeWidth.
  RemixSliderStyler rangeWidth(double value) {
    return merge(RemixSliderStyler(rangeWidth: value));
  }

  /// Sets the animation configuration.
  @override
  RemixSliderStyler animate(AnimationConfig value) {
    return merge(RemixSliderStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  RemixSliderStyler variants(List<VariantStyle<RemixSliderSpec>> value) {
    return merge(RemixSliderStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  RemixSliderStyler wrap(WidgetModifierConfig value) {
    return merge(RemixSliderStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixSliderStyler modifier(WidgetModifierConfig value) {
    return merge(RemixSliderStyler(modifier: value));
  }

  /// Merges with another [RemixSliderStyler].
  @override
  RemixSliderStyler merge(RemixSliderStyler? other) {
    return RemixSliderStyler.create(
      thumb: MixOps.merge($thumb, other?.$thumb),
      trackColor: MixOps.merge($trackColor, other?.$trackColor),
      trackWidth: MixOps.merge($trackWidth, other?.$trackWidth),
      rangeColor: MixOps.merge($rangeColor, other?.$rangeColor),
      rangeWidth: MixOps.merge($rangeWidth, other?.$rangeWidth),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixSliderSpec>] using [context].
  @override
  StyleSpec<RemixSliderSpec> resolve(BuildContext context) {
    final spec = RemixSliderSpec(
      thumb: MixOps.resolve(context, $thumb),
      trackColor: MixOps.resolve(context, $trackColor),
      trackWidth: MixOps.resolve(context, $trackWidth),
      rangeColor: MixOps.resolve(context, $rangeColor),
      rangeWidth: MixOps.resolve(context, $rangeWidth),
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
      ..add(DiagnosticsProperty('thumb', $thumb))
      ..add(DiagnosticsProperty('trackColor', $trackColor))
      ..add(DiagnosticsProperty('trackWidth', $trackWidth))
      ..add(DiagnosticsProperty('rangeColor', $rangeColor))
      ..add(DiagnosticsProperty('rangeWidth', $rangeWidth));
  }

  @override
  List<Object?> get props => [
    $thumb,
    $trackColor,
    $trackWidth,
    $rangeColor,
    $rangeWidth,
    $animation,
    $modifier,
    $variants,
  ];
}
