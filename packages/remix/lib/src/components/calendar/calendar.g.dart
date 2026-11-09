// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$CalendarSpec implements Spec<CalendarSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get weekday;
  StyleSpec<CalendarDaySpec> get day;
  double? get rowSpacing;
  double? get headerSpacing;
  double? get weekdaySpacing;

  @override
  Type get type => CalendarSpec;

  @override
  CalendarSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? weekday,
    StyleSpec<CalendarDaySpec>? day,
    double? rowSpacing,
    double? headerSpacing,
    double? weekdaySpacing,
  }) {
    return CalendarSpec(
      container: container ?? this.container,
      weekday: weekday ?? this.weekday,
      day: day ?? this.day,
      rowSpacing: rowSpacing ?? this.rowSpacing,
      headerSpacing: headerSpacing ?? this.headerSpacing,
      weekdaySpacing: weekdaySpacing ?? this.weekdaySpacing,
    );
  }

  @override
  CalendarSpec lerp(CalendarSpec? other, double t) {
    return CalendarSpec(
      container: container.lerp(other?.container, t),
      weekday: weekday.lerp(other?.weekday, t),
      day: day.lerp(other?.day, t),
      rowSpacing: MixOps.lerp(rowSpacing, other?.rowSpacing, t),
      headerSpacing: MixOps.lerp(headerSpacing, other?.headerSpacing, t),
      weekdaySpacing: MixOps.lerp(weekdaySpacing, other?.weekdaySpacing, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    weekday,
    day,
    rowSpacing,
    headerSpacing,
    weekdaySpacing,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CalendarSpec &&
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
      ..add(DiagnosticsProperty('weekday', weekday))
      ..add(DiagnosticsProperty('day', day))
      ..add(DoubleProperty('rowSpacing', rowSpacing))
      ..add(DoubleProperty('headerSpacing', headerSpacing))
      ..add(DoubleProperty('weekdaySpacing', weekdaySpacing));
  }
}

@Deprecated(
  'Rename to `_\$CalendarSpec` and migrate the class declaration to `class CalendarSpec with _\$CalendarSpec`. The `_\$CalendarSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$CalendarSpecMethods = _$CalendarSpec; // ignore: unused_element

mixin _$CalendarDaySpec implements Spec<CalendarDaySpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get label;
  RemixBoxEffectsSpec? get containerEffects;

  @override
  Type get type => CalendarDaySpec;

  @override
  CalendarDaySpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
    RemixBoxEffectsSpec? containerEffects,
  }) {
    return CalendarDaySpec(
      container: container ?? this.container,
      label: label ?? this.label,
      containerEffects: containerEffects ?? this.containerEffects,
    );
  }

  @override
  CalendarDaySpec lerp(CalendarDaySpec? other, double t) {
    return CalendarDaySpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      containerEffects: MixOps.lerpSnap(
        containerEffects,
        other?.containerEffects,
        t,
      ),
    );
  }

  @override
  List<Object?> get props => [container, label, containerEffects];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CalendarDaySpec &&
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
      ..add(DiagnosticsProperty('containerEffects', containerEffects));
  }
}

@Deprecated(
  'Rename to `_\$CalendarDaySpec` and migrate the class declaration to `class CalendarDaySpec with _\$CalendarDaySpec`. The `_\$CalendarDaySpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$CalendarDaySpecMethods = _$CalendarDaySpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class CalendarStyler extends MixStyler<CalendarStyler, CalendarSpec>
    with RemixBoxStylerMixin<CalendarStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $weekday;
  final Prop<StyleSpec<CalendarDaySpec>>? $day;
  final Prop<double>? $rowSpacing;
  final Prop<double>? $headerSpacing;
  final Prop<double>? $weekdaySpacing;

  const CalendarStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? weekday,
    Prop<StyleSpec<CalendarDaySpec>>? day,
    Prop<double>? rowSpacing,
    Prop<double>? headerSpacing,
    Prop<double>? weekdaySpacing,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $weekday = weekday,
       $day = day,
       $rowSpacing = rowSpacing,
       $headerSpacing = headerSpacing,
       $weekdaySpacing = weekdaySpacing;

  CalendarStyler({
    BoxStyler? container,
    TextStyler? weekday,
    CalendarDayStyler? day,
    double? rowSpacing,
    double? headerSpacing,
    double? weekdaySpacing,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<CalendarSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         weekday: Prop.maybeMix(weekday),
         day: Prop.maybeMix(day),
         rowSpacing: Prop.maybe(rowSpacing),
         headerSpacing: Prop.maybe(headerSpacing),
         weekdaySpacing: Prop.maybe(weekdaySpacing),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory CalendarStyler.container(BoxStyler value) =>
      CalendarStyler().container(value);
  factory CalendarStyler.weekday(TextStyler value) =>
      CalendarStyler().weekday(value);
  factory CalendarStyler.day(CalendarDayStyler value) =>
      CalendarStyler().day(value);
  factory CalendarStyler.rowSpacing(double value) =>
      CalendarStyler().rowSpacing(value);
  factory CalendarStyler.headerSpacing(double value) =>
      CalendarStyler().headerSpacing(value);
  factory CalendarStyler.weekdaySpacing(double value) =>
      CalendarStyler().weekdaySpacing(value);
  factory CalendarStyler.alignment(AlignmentGeometry value) =>
      CalendarStyler().alignment(value);
  factory CalendarStyler.padding(EdgeInsetsGeometryMix value) =>
      CalendarStyler().padding(value);
  factory CalendarStyler.margin(EdgeInsetsGeometryMix value) =>
      CalendarStyler().margin(value);
  factory CalendarStyler.constraints(BoxConstraintsMix value) =>
      CalendarStyler().constraints(value);
  factory CalendarStyler.decoration(DecorationMix value) =>
      CalendarStyler().decoration(value);
  factory CalendarStyler.foregroundDecoration(DecorationMix value) =>
      CalendarStyler().foregroundDecoration(value);
  factory CalendarStyler.clipBehavior(Clip value) =>
      CalendarStyler().clipBehavior(value);
  factory CalendarStyler.color(Color value) => CalendarStyler().color(value);
  factory CalendarStyler.gradient(GradientMix value) =>
      CalendarStyler().gradient(value);
  factory CalendarStyler.border(BoxBorderMix value) =>
      CalendarStyler().border(value);
  factory CalendarStyler.borderRadius(BorderRadiusGeometryMix value) =>
      CalendarStyler().borderRadius(value);
  factory CalendarStyler.elevation(ElevationShadow value) =>
      CalendarStyler().elevation(value);
  factory CalendarStyler.shadow(BoxShadowMix value) =>
      CalendarStyler().shadow(value);
  factory CalendarStyler.shadows(List<BoxShadowMix> value) =>
      CalendarStyler().shadows(value);
  factory CalendarStyler.width(double value) => CalendarStyler().width(value);
  factory CalendarStyler.height(double value) => CalendarStyler().height(value);
  factory CalendarStyler.size(double width, double height) =>
      CalendarStyler().size(width, height);
  factory CalendarStyler.minWidth(double value) =>
      CalendarStyler().minWidth(value);
  factory CalendarStyler.maxWidth(double value) =>
      CalendarStyler().maxWidth(value);
  factory CalendarStyler.minHeight(double value) =>
      CalendarStyler().minHeight(value);
  factory CalendarStyler.maxHeight(double value) =>
      CalendarStyler().maxHeight(value);
  factory CalendarStyler.scale(double scale, {Alignment alignment = .center}) =>
      CalendarStyler().scale(scale, alignment: alignment);
  factory CalendarStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => CalendarStyler().rotate(radians, alignment: alignment);
  factory CalendarStyler.translate(double x, double y, [double z = 0.0]) =>
      CalendarStyler().translate(x, y, z);
  factory CalendarStyler.skew(double skewX, double skewY) =>
      CalendarStyler().skew(skewX, skewY);
  factory CalendarStyler.textStyle(TextStyler value) =>
      CalendarStyler().textStyle(value);
  factory CalendarStyler.image(DecorationImageMix value) =>
      CalendarStyler().image(value);
  factory CalendarStyler.shape(ShapeBorderMix value) =>
      CalendarStyler().shape(value);
  factory CalendarStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => CalendarStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory CalendarStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => CalendarStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory CalendarStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => CalendarStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory CalendarStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => CalendarStyler().transform(value, alignment: alignment);

  CalendarStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  CalendarStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  CalendarStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  CalendarStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  CalendarStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  CalendarStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  CalendarStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  CalendarStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  CalendarStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  CalendarStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  CalendarStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  CalendarStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  CalendarStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  CalendarStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  CalendarStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  CalendarStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  CalendarStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  CalendarStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  CalendarStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  CalendarStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  CalendarStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  CalendarStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  CalendarStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  CalendarStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  CalendarStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  CalendarStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  CalendarStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  CalendarStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  CalendarStyler backgroundImage(
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

  CalendarStyler backgroundImageUrl(
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

  CalendarStyler backgroundImageAsset(
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

  CalendarStyler linearGradient({
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

  CalendarStyler radialGradient({
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

  CalendarStyler sweepGradient({
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

  CalendarStyler foregroundLinearGradient({
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

  CalendarStyler foregroundRadialGradient({
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

  CalendarStyler foregroundSweepGradient({
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

  CalendarStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'weekday',
    'day',
    'rowSpacing',
    'headerSpacing',
    'weekdaySpacing',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  CalendarStyler container(BoxStyler value) {
    return merge(CalendarStyler(container: value));
  }

  /// Sets the weekday.
  CalendarStyler weekday(TextStyler value) {
    return merge(CalendarStyler(weekday: value));
  }

  /// Sets the day.
  CalendarStyler day(CalendarDayStyler value) {
    return merge(CalendarStyler(day: value));
  }

  /// Sets the rowSpacing.
  CalendarStyler rowSpacing(double value) {
    return merge(CalendarStyler(rowSpacing: value));
  }

  /// Sets the headerSpacing.
  CalendarStyler headerSpacing(double value) {
    return merge(CalendarStyler(headerSpacing: value));
  }

  /// Sets the weekdaySpacing.
  CalendarStyler weekdaySpacing(double value) {
    return merge(CalendarStyler(weekdaySpacing: value));
  }

  /// Sets the animation configuration.
  @override
  CalendarStyler animate(AnimationConfig value) {
    return merge(CalendarStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  CalendarStyler variants(List<VariantStyle<CalendarSpec>> value) {
    return merge(CalendarStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  CalendarStyler wrap(WidgetModifierConfig value) {
    return merge(CalendarStyler(modifier: value));
  }

  /// Sets the widget modifier.
  CalendarStyler modifier(WidgetModifierConfig value) {
    return merge(CalendarStyler(modifier: value));
  }

  /// Merges with another [CalendarStyler].
  @override
  CalendarStyler merge(CalendarStyler? other) {
    return CalendarStyler.create(
      container: MixOps.merge($container, other?.$container),
      weekday: MixOps.merge($weekday, other?.$weekday),
      day: MixOps.merge($day, other?.$day),
      rowSpacing: MixOps.merge($rowSpacing, other?.$rowSpacing),
      headerSpacing: MixOps.merge($headerSpacing, other?.$headerSpacing),
      weekdaySpacing: MixOps.merge($weekdaySpacing, other?.$weekdaySpacing),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<CalendarSpec>] using [context].
  @override
  StyleSpec<CalendarSpec> resolve(BuildContext context) {
    final spec = CalendarSpec(
      container: MixOps.resolve(context, $container),
      weekday: MixOps.resolve(context, $weekday),
      day: MixOps.resolve(context, $day),
      rowSpacing: MixOps.resolve(context, $rowSpacing),
      headerSpacing: MixOps.resolve(context, $headerSpacing),
      weekdaySpacing: MixOps.resolve(context, $weekdaySpacing),
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
      ..add(DiagnosticsProperty('weekday', $weekday))
      ..add(DiagnosticsProperty('day', $day))
      ..add(DiagnosticsProperty('rowSpacing', $rowSpacing))
      ..add(DiagnosticsProperty('headerSpacing', $headerSpacing))
      ..add(DiagnosticsProperty('weekdaySpacing', $weekdaySpacing));
  }

  @override
  List<Object?> get props => [
    $container,
    $weekday,
    $day,
    $rowSpacing,
    $headerSpacing,
    $weekdaySpacing,
    $animation,
    $modifier,
    $variants,
  ];
}

class CalendarDayStyler extends MixStyler<CalendarDayStyler, CalendarDaySpec>
    with RemixBoxStylerMixin<CalendarDayStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<RemixBoxEffectsSpec>? $containerEffects;

  const CalendarDayStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<RemixBoxEffectsSpec>? containerEffects,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $label = label,
       $containerEffects = containerEffects;

  CalendarDayStyler({
    BoxStyler? container,
    TextStyler? label,
    RemixBoxEffectsMix? containerEffects,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<CalendarDaySpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         containerEffects: Prop.maybeMix(containerEffects),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory CalendarDayStyler.container(BoxStyler value) =>
      CalendarDayStyler().container(value);
  factory CalendarDayStyler.label(TextStyler value) =>
      CalendarDayStyler().label(value);
  factory CalendarDayStyler.containerEffects(RemixBoxEffectsMix value) =>
      CalendarDayStyler().containerEffects(value);
  factory CalendarDayStyler.alignment(AlignmentGeometry value) =>
      CalendarDayStyler().alignment(value);
  factory CalendarDayStyler.padding(EdgeInsetsGeometryMix value) =>
      CalendarDayStyler().padding(value);
  factory CalendarDayStyler.margin(EdgeInsetsGeometryMix value) =>
      CalendarDayStyler().margin(value);
  factory CalendarDayStyler.constraints(BoxConstraintsMix value) =>
      CalendarDayStyler().constraints(value);
  factory CalendarDayStyler.decoration(DecorationMix value) =>
      CalendarDayStyler().decoration(value);
  factory CalendarDayStyler.foregroundDecoration(DecorationMix value) =>
      CalendarDayStyler().foregroundDecoration(value);
  factory CalendarDayStyler.clipBehavior(Clip value) =>
      CalendarDayStyler().clipBehavior(value);
  factory CalendarDayStyler.color(Color value) =>
      CalendarDayStyler().color(value);
  factory CalendarDayStyler.gradient(GradientMix value) =>
      CalendarDayStyler().gradient(value);
  factory CalendarDayStyler.border(BoxBorderMix value) =>
      CalendarDayStyler().border(value);
  factory CalendarDayStyler.borderRadius(BorderRadiusGeometryMix value) =>
      CalendarDayStyler().borderRadius(value);
  factory CalendarDayStyler.elevation(ElevationShadow value) =>
      CalendarDayStyler().elevation(value);
  factory CalendarDayStyler.shadow(BoxShadowMix value) =>
      CalendarDayStyler().shadow(value);
  factory CalendarDayStyler.shadows(List<BoxShadowMix> value) =>
      CalendarDayStyler().shadows(value);
  factory CalendarDayStyler.width(double value) =>
      CalendarDayStyler().width(value);
  factory CalendarDayStyler.height(double value) =>
      CalendarDayStyler().height(value);
  factory CalendarDayStyler.size(double width, double height) =>
      CalendarDayStyler().size(width, height);
  factory CalendarDayStyler.minWidth(double value) =>
      CalendarDayStyler().minWidth(value);
  factory CalendarDayStyler.maxWidth(double value) =>
      CalendarDayStyler().maxWidth(value);
  factory CalendarDayStyler.minHeight(double value) =>
      CalendarDayStyler().minHeight(value);
  factory CalendarDayStyler.maxHeight(double value) =>
      CalendarDayStyler().maxHeight(value);
  factory CalendarDayStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => CalendarDayStyler().scale(scale, alignment: alignment);
  factory CalendarDayStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => CalendarDayStyler().rotate(radians, alignment: alignment);
  factory CalendarDayStyler.translate(double x, double y, [double z = 0.0]) =>
      CalendarDayStyler().translate(x, y, z);
  factory CalendarDayStyler.skew(double skewX, double skewY) =>
      CalendarDayStyler().skew(skewX, skewY);
  factory CalendarDayStyler.textStyle(TextStyler value) =>
      CalendarDayStyler().textStyle(value);
  factory CalendarDayStyler.image(DecorationImageMix value) =>
      CalendarDayStyler().image(value);
  factory CalendarDayStyler.shape(ShapeBorderMix value) =>
      CalendarDayStyler().shape(value);
  factory CalendarDayStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => CalendarDayStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory CalendarDayStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => CalendarDayStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory CalendarDayStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => CalendarDayStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory CalendarDayStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarDayStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarDayStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarDayStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarDayStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarDayStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarDayStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarDayStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarDayStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarDayStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarDayStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => CalendarDayStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory CalendarDayStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => CalendarDayStyler().transform(value, alignment: alignment);

  CalendarDayStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  CalendarDayStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  CalendarDayStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  CalendarDayStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  CalendarDayStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  CalendarDayStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  CalendarDayStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  CalendarDayStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  CalendarDayStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  CalendarDayStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  CalendarDayStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  CalendarDayStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  CalendarDayStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  CalendarDayStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  CalendarDayStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  CalendarDayStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  CalendarDayStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  CalendarDayStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  CalendarDayStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  CalendarDayStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  CalendarDayStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  CalendarDayStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  CalendarDayStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  CalendarDayStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  CalendarDayStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  CalendarDayStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  CalendarDayStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  CalendarDayStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  CalendarDayStyler backgroundImage(
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

  CalendarDayStyler backgroundImageUrl(
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

  CalendarDayStyler backgroundImageAsset(
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

  CalendarDayStyler linearGradient({
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

  CalendarDayStyler radialGradient({
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

  CalendarDayStyler sweepGradient({
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

  CalendarDayStyler foregroundLinearGradient({
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

  CalendarDayStyler foregroundRadialGradient({
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

  CalendarDayStyler foregroundSweepGradient({
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

  CalendarDayStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'label',
    'containerEffects',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  CalendarDayStyler container(BoxStyler value) {
    return merge(CalendarDayStyler(container: value));
  }

  /// Sets the label.
  CalendarDayStyler label(TextStyler value) {
    return merge(CalendarDayStyler(label: value));
  }

  /// Sets the containerEffects.
  CalendarDayStyler containerEffects(RemixBoxEffectsMix value) {
    return merge(CalendarDayStyler(containerEffects: value));
  }

  /// Sets the animation configuration.
  @override
  CalendarDayStyler animate(AnimationConfig value) {
    return merge(CalendarDayStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  CalendarDayStyler variants(List<VariantStyle<CalendarDaySpec>> value) {
    return merge(CalendarDayStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  CalendarDayStyler wrap(WidgetModifierConfig value) {
    return merge(CalendarDayStyler(modifier: value));
  }

  /// Sets the widget modifier.
  CalendarDayStyler modifier(WidgetModifierConfig value) {
    return merge(CalendarDayStyler(modifier: value));
  }

  /// Merges with another [CalendarDayStyler].
  @override
  CalendarDayStyler merge(CalendarDayStyler? other) {
    return CalendarDayStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      containerEffects: MixOps.merge(
        $containerEffects,
        other?.$containerEffects,
      ),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<CalendarDaySpec>] using [context].
  @override
  StyleSpec<CalendarDaySpec> resolve(BuildContext context) {
    final spec = CalendarDaySpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      containerEffects: MixOps.resolve(context, $containerEffects),
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
      ..add(DiagnosticsProperty('containerEffects', $containerEffects));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $containerEffects,
    $animation,
    $modifier,
    $variants,
  ];
}
