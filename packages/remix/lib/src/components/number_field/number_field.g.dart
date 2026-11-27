// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'number_field.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$NumberFieldSpec implements Spec<NumberFieldSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  RemixBoxEffectsSpec? get containerEffects;
  double? get spacing;
  StyleSpec<FlexBoxSpec> get layout;
  StyleSpec<TextFieldSpec> get field;
  StyleSpec<NumberFieldStepSpec> get step;
  StyleSpec<TextSpec> get label;
  StyleSpec<TextSpec> get helperText;

  @override
  Type get type => NumberFieldSpec;

  @override
  NumberFieldSpec copyWith({
    StyleSpec<BoxSpec>? container,
    RemixBoxEffectsSpec? containerEffects,
    double? spacing,
    StyleSpec<FlexBoxSpec>? layout,
    StyleSpec<TextFieldSpec>? field,
    StyleSpec<NumberFieldStepSpec>? step,
    StyleSpec<TextSpec>? label,
    StyleSpec<TextSpec>? helperText,
  }) {
    return NumberFieldSpec(
      container: container ?? this.container,
      containerEffects: containerEffects ?? this.containerEffects,
      spacing: spacing ?? this.spacing,
      layout: layout ?? this.layout,
      field: field ?? this.field,
      step: step ?? this.step,
      label: label ?? this.label,
      helperText: helperText ?? this.helperText,
    );
  }

  @override
  NumberFieldSpec lerp(NumberFieldSpec? other, double t) {
    return NumberFieldSpec(
      container: container.lerp(other?.container, t),
      containerEffects: MixOps.lerpSnap(
        containerEffects,
        other?.containerEffects,
        t,
      ),
      spacing: MixOps.lerp(spacing, other?.spacing, t),
      layout: layout.lerp(other?.layout, t),
      field: field.lerp(other?.field, t),
      step: step.lerp(other?.step, t),
      label: label.lerp(other?.label, t),
      helperText: helperText.lerp(other?.helperText, t),
    );
  }

  @override
  List<Object?> get props => [
    container,
    containerEffects,
    spacing,
    layout,
    field,
    step,
    label,
    helperText,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NumberFieldSpec &&
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
      ..add(DiagnosticsProperty('layout', layout))
      ..add(DiagnosticsProperty('field', field))
      ..add(DiagnosticsProperty('step', step))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('helperText', helperText));
  }
}

@Deprecated(
  'Rename to `_\$NumberFieldSpec` and migrate the class declaration to `class NumberFieldSpec with _\$NumberFieldSpec`. The `_\$NumberFieldSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$NumberFieldSpecMethods = _$NumberFieldSpec; // ignore: unused_element

mixin _$NumberFieldStepSpec
    implements Spec<NumberFieldStepSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  RemixBoxEffectsSpec? get containerEffects;
  StyleSpec<IconSpec> get icon;
  double? get iconScale;

  @override
  Type get type => NumberFieldStepSpec;

  @override
  NumberFieldStepSpec copyWith({
    StyleSpec<BoxSpec>? container,
    RemixBoxEffectsSpec? containerEffects,
    StyleSpec<IconSpec>? icon,
    double? iconScale,
  }) {
    return NumberFieldStepSpec(
      container: container ?? this.container,
      containerEffects: containerEffects ?? this.containerEffects,
      icon: icon ?? this.icon,
      iconScale: iconScale ?? this.iconScale,
    );
  }

  @override
  NumberFieldStepSpec lerp(NumberFieldStepSpec? other, double t) {
    return NumberFieldStepSpec(
      container: container.lerp(other?.container, t),
      containerEffects: MixOps.lerpSnap(
        containerEffects,
        other?.containerEffects,
        t,
      ),
      icon: icon.lerp(other?.icon, t),
      iconScale: MixOps.lerp(iconScale, other?.iconScale, t),
    );
  }

  @override
  List<Object?> get props => [container, containerEffects, icon, iconScale];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NumberFieldStepSpec &&
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
      ..add(DiagnosticsProperty('icon', icon))
      ..add(DoubleProperty('iconScale', iconScale));
  }
}

@Deprecated(
  'Rename to `_\$NumberFieldStepSpec` and migrate the class declaration to `class NumberFieldStepSpec with _\$NumberFieldStepSpec`. The `_\$NumberFieldStepSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$NumberFieldStepSpecMethods = _$NumberFieldStepSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class NumberFieldStyler extends MixStyler<NumberFieldStyler, NumberFieldSpec>
    with
        RemixBoxStylerMixin<NumberFieldStyler>,
        LabelStyleMixin<NumberFieldStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<RemixBoxEffectsSpec>? $containerEffects;
  final Prop<double>? $spacing;
  final Prop<StyleSpec<FlexBoxSpec>>? $layout;
  final Prop<StyleSpec<TextFieldSpec>>? $field;
  final Prop<StyleSpec<NumberFieldStepSpec>>? $step;
  final Prop<StyleSpec<TextSpec>>? $label;
  final Prop<StyleSpec<TextSpec>>? $helperText;

  const NumberFieldStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<RemixBoxEffectsSpec>? containerEffects,
    Prop<double>? spacing,
    Prop<StyleSpec<FlexBoxSpec>>? layout,
    Prop<StyleSpec<TextFieldSpec>>? field,
    Prop<StyleSpec<NumberFieldStepSpec>>? step,
    Prop<StyleSpec<TextSpec>>? label,
    Prop<StyleSpec<TextSpec>>? helperText,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $containerEffects = containerEffects,
       $spacing = spacing,
       $layout = layout,
       $field = field,
       $step = step,
       $label = label,
       $helperText = helperText;

  NumberFieldStyler({
    BoxStyler? container,
    RemixBoxEffectsMix? containerEffects,
    double? spacing,
    FlexBoxStyler? layout,
    TextFieldStyler? field,
    NumberFieldStepStyler? step,
    TextStyler? label,
    TextStyler? helperText,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<NumberFieldSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         containerEffects: Prop.maybeMix(containerEffects),
         spacing: Prop.maybe(spacing),
         layout: Prop.maybeMix(layout),
         field: Prop.maybeMix(field),
         step: Prop.maybeMix(step),
         label: Prop.maybeMix(label),
         helperText: Prop.maybeMix(helperText),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory NumberFieldStyler.container(BoxStyler value) =>
      NumberFieldStyler().container(value);
  factory NumberFieldStyler.containerEffects(RemixBoxEffectsMix value) =>
      NumberFieldStyler().containerEffects(value);
  factory NumberFieldStyler.spacing(double value) =>
      NumberFieldStyler().spacing(value);
  factory NumberFieldStyler.layout(FlexBoxStyler value) =>
      NumberFieldStyler().layout(value);
  factory NumberFieldStyler.field(TextFieldStyler value) =>
      NumberFieldStyler().field(value);
  factory NumberFieldStyler.step(NumberFieldStepStyler value) =>
      NumberFieldStyler().step(value);
  factory NumberFieldStyler.label(TextStyler value) =>
      NumberFieldStyler().label(value);
  factory NumberFieldStyler.helperText(TextStyler value) =>
      NumberFieldStyler().helperText(value);
  factory NumberFieldStyler.alignment(AlignmentGeometry value) =>
      NumberFieldStyler().alignment(value);
  factory NumberFieldStyler.padding(EdgeInsetsGeometryMix value) =>
      NumberFieldStyler().padding(value);
  factory NumberFieldStyler.margin(EdgeInsetsGeometryMix value) =>
      NumberFieldStyler().margin(value);
  factory NumberFieldStyler.constraints(BoxConstraintsMix value) =>
      NumberFieldStyler().constraints(value);
  factory NumberFieldStyler.decoration(DecorationMix value) =>
      NumberFieldStyler().decoration(value);
  factory NumberFieldStyler.foregroundDecoration(DecorationMix value) =>
      NumberFieldStyler().foregroundDecoration(value);
  factory NumberFieldStyler.clipBehavior(Clip value) =>
      NumberFieldStyler().clipBehavior(value);
  factory NumberFieldStyler.color(Color value) =>
      NumberFieldStyler().color(value);
  factory NumberFieldStyler.gradient(GradientMix value) =>
      NumberFieldStyler().gradient(value);
  factory NumberFieldStyler.border(BoxBorderMix value) =>
      NumberFieldStyler().border(value);
  factory NumberFieldStyler.borderRadius(BorderRadiusGeometryMix value) =>
      NumberFieldStyler().borderRadius(value);
  factory NumberFieldStyler.elevation(ElevationShadow value) =>
      NumberFieldStyler().elevation(value);
  factory NumberFieldStyler.shadow(BoxShadowMix value) =>
      NumberFieldStyler().shadow(value);
  factory NumberFieldStyler.shadows(List<BoxShadowMix> value) =>
      NumberFieldStyler().shadows(value);
  factory NumberFieldStyler.width(double value) =>
      NumberFieldStyler().width(value);
  factory NumberFieldStyler.height(double value) =>
      NumberFieldStyler().height(value);
  factory NumberFieldStyler.size(double width, double height) =>
      NumberFieldStyler().size(width, height);
  factory NumberFieldStyler.minWidth(double value) =>
      NumberFieldStyler().minWidth(value);
  factory NumberFieldStyler.maxWidth(double value) =>
      NumberFieldStyler().maxWidth(value);
  factory NumberFieldStyler.minHeight(double value) =>
      NumberFieldStyler().minHeight(value);
  factory NumberFieldStyler.maxHeight(double value) =>
      NumberFieldStyler().maxHeight(value);
  factory NumberFieldStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => NumberFieldStyler().scale(scale, alignment: alignment);
  factory NumberFieldStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => NumberFieldStyler().rotate(radians, alignment: alignment);
  factory NumberFieldStyler.translate(double x, double y, [double z = 0.0]) =>
      NumberFieldStyler().translate(x, y, z);
  factory NumberFieldStyler.skew(double skewX, double skewY) =>
      NumberFieldStyler().skew(skewX, skewY);
  factory NumberFieldStyler.textStyle(TextStyler value) =>
      NumberFieldStyler().textStyle(value);
  factory NumberFieldStyler.image(DecorationImageMix value) =>
      NumberFieldStyler().image(value);
  factory NumberFieldStyler.shape(ShapeBorderMix value) =>
      NumberFieldStyler().shape(value);
  factory NumberFieldStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => NumberFieldStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory NumberFieldStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => NumberFieldStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory NumberFieldStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => NumberFieldStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory NumberFieldStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => NumberFieldStyler().transform(value, alignment: alignment);
  factory NumberFieldStyler.wrap(WidgetModifierConfig value) =>
      NumberFieldStyler().wrap(value);

  NumberFieldStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  NumberFieldStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  NumberFieldStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  NumberFieldStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  NumberFieldStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  NumberFieldStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  NumberFieldStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  NumberFieldStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  NumberFieldStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  NumberFieldStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  NumberFieldStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  NumberFieldStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  NumberFieldStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  NumberFieldStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  NumberFieldStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  NumberFieldStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  NumberFieldStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  NumberFieldStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  NumberFieldStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  NumberFieldStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  NumberFieldStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  NumberFieldStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  NumberFieldStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  NumberFieldStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  NumberFieldStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  NumberFieldStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  NumberFieldStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  NumberFieldStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  NumberFieldStyler backgroundImage(
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

  NumberFieldStyler backgroundImageUrl(
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

  NumberFieldStyler backgroundImageAsset(
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

  NumberFieldStyler linearGradient({
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

  NumberFieldStyler radialGradient({
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

  NumberFieldStyler sweepGradient({
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

  NumberFieldStyler foregroundLinearGradient({
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

  NumberFieldStyler foregroundRadialGradient({
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

  NumberFieldStyler foregroundSweepGradient({
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

  NumberFieldStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'containerEffects',
    'spacing',
    'layout',
    'field',
    'step',
    'label',
    'helperText',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  NumberFieldStyler container(BoxStyler value) {
    return merge(NumberFieldStyler(container: value));
  }

  /// Sets the containerEffects.
  NumberFieldStyler containerEffects(RemixBoxEffectsMix value) {
    return merge(NumberFieldStyler(containerEffects: value));
  }

  /// Sets the spacing.
  NumberFieldStyler spacing(double value) {
    return merge(NumberFieldStyler(spacing: value));
  }

  /// Sets the layout.
  NumberFieldStyler layout(FlexBoxStyler value) {
    return merge(NumberFieldStyler(layout: value));
  }

  /// Sets the field.
  NumberFieldStyler field(TextFieldStyler value) {
    return merge(NumberFieldStyler(field: value));
  }

  /// Sets the step.
  NumberFieldStyler step(NumberFieldStepStyler value) {
    return merge(NumberFieldStyler(step: value));
  }

  /// Sets the label.
  @override
  NumberFieldStyler label(TextStyler value) {
    return merge(NumberFieldStyler(label: value));
  }

  /// Sets the helperText.
  NumberFieldStyler helperText(TextStyler value) {
    return merge(NumberFieldStyler(helperText: value));
  }

  /// Sets the animation configuration.
  @override
  NumberFieldStyler animate(AnimationConfig value) {
    return merge(NumberFieldStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  NumberFieldStyler variants(List<VariantStyle<NumberFieldSpec>> value) {
    return merge(NumberFieldStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  NumberFieldStyler wrap(WidgetModifierConfig value) {
    return merge(NumberFieldStyler(modifier: value));
  }

  /// Sets the widget modifier.
  NumberFieldStyler modifier(WidgetModifierConfig value) {
    return merge(NumberFieldStyler(modifier: value));
  }

  RemixNumberField call({
    Key? key,
    required double? value,
    ValueChanged<double?>? onChanged,
    double min = double.negativeInfinity,
    double max = double.infinity,
    double step = 1,
    double? largeStep,
    String Function(double value)? format,
    double? Function(String text)? parse,
    TextEditingController? controller,
    FocusNode? focusNode,
    bool enabled = true,
    bool readOnly = false,
    bool autofocus = false,
    bool error = false,
    String? label,
    String? hintText,
    String? helperText,
    String? semanticLabel,
    String? semanticHint,
    String incrementSemanticLabel = 'Increase',
    String decrementSemanticLabel = 'Decrease',
    IconData? incrementIcon,
    IconData? decrementIcon,
    TextInputAction textInputAction = TextInputAction.done,
  }) {
    return RemixNumberField(
      key: key,
      style: this,
      value: value,
      onChanged: onChanged,
      min: min,
      max: max,
      step: step,
      largeStep: largeStep,
      format: format,
      parse: parse,
      controller: controller,
      focusNode: focusNode,
      enabled: enabled,
      readOnly: readOnly,
      autofocus: autofocus,
      error: error,
      label: label,
      hintText: hintText,
      helperText: helperText,
      semanticLabel: semanticLabel,
      semanticHint: semanticHint,
      incrementSemanticLabel: incrementSemanticLabel,
      decrementSemanticLabel: decrementSemanticLabel,
      incrementIcon: incrementIcon,
      decrementIcon: decrementIcon,
      textInputAction: textInputAction,
    );
  }

  /// Merges with another [NumberFieldStyler].
  @override
  NumberFieldStyler merge(NumberFieldStyler? other) {
    return NumberFieldStyler.create(
      container: MixOps.merge($container, other?.$container),
      containerEffects: MixOps.merge(
        $containerEffects,
        other?.$containerEffects,
      ),
      spacing: MixOps.merge($spacing, other?.$spacing),
      layout: MixOps.merge($layout, other?.$layout),
      field: MixOps.merge($field, other?.$field),
      step: MixOps.merge($step, other?.$step),
      label: MixOps.merge($label, other?.$label),
      helperText: MixOps.merge($helperText, other?.$helperText),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<NumberFieldSpec>] using [context].
  @override
  StyleSpec<NumberFieldSpec> resolve(BuildContext context) {
    final spec = NumberFieldSpec(
      container: MixOps.resolve(context, $container),
      containerEffects: MixOps.resolve(context, $containerEffects),
      spacing: MixOps.resolve(context, $spacing),
      layout: MixOps.resolve(context, $layout),
      field: MixOps.resolve(context, $field),
      step: MixOps.resolve(context, $step),
      label: MixOps.resolve(context, $label),
      helperText: MixOps.resolve(context, $helperText),
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
      ..add(DiagnosticsProperty('layout', $layout))
      ..add(DiagnosticsProperty('field', $field))
      ..add(DiagnosticsProperty('step', $step))
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('helperText', $helperText));
  }

  @override
  List<Object?> get props => [
    $container,
    $containerEffects,
    $spacing,
    $layout,
    $field,
    $step,
    $label,
    $helperText,
    $animation,
    $modifier,
    $variants,
  ];
}

class NumberFieldStepStyler
    extends MixStyler<NumberFieldStepStyler, NumberFieldStepSpec>
    with RemixBoxStylerMixin<NumberFieldStepStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<RemixBoxEffectsSpec>? $containerEffects;
  final Prop<StyleSpec<IconSpec>>? $icon;
  final Prop<double>? $iconScale;

  const NumberFieldStepStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<RemixBoxEffectsSpec>? containerEffects,
    Prop<StyleSpec<IconSpec>>? icon,
    Prop<double>? iconScale,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $containerEffects = containerEffects,
       $icon = icon,
       $iconScale = iconScale;

  NumberFieldStepStyler({
    BoxStyler? container,
    RemixBoxEffectsMix? containerEffects,
    IconStyler? icon,
    double? iconScale,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<NumberFieldStepSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         containerEffects: Prop.maybeMix(containerEffects),
         icon: Prop.maybeMix(icon),
         iconScale: Prop.maybe(iconScale),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory NumberFieldStepStyler.container(BoxStyler value) =>
      NumberFieldStepStyler().container(value);
  factory NumberFieldStepStyler.containerEffects(RemixBoxEffectsMix value) =>
      NumberFieldStepStyler().containerEffects(value);
  factory NumberFieldStepStyler.icon(IconStyler value) =>
      NumberFieldStepStyler().icon(value);
  factory NumberFieldStepStyler.iconScale(double value) =>
      NumberFieldStepStyler().iconScale(value);
  factory NumberFieldStepStyler.alignment(AlignmentGeometry value) =>
      NumberFieldStepStyler().alignment(value);
  factory NumberFieldStepStyler.padding(EdgeInsetsGeometryMix value) =>
      NumberFieldStepStyler().padding(value);
  factory NumberFieldStepStyler.margin(EdgeInsetsGeometryMix value) =>
      NumberFieldStepStyler().margin(value);
  factory NumberFieldStepStyler.constraints(BoxConstraintsMix value) =>
      NumberFieldStepStyler().constraints(value);
  factory NumberFieldStepStyler.decoration(DecorationMix value) =>
      NumberFieldStepStyler().decoration(value);
  factory NumberFieldStepStyler.foregroundDecoration(DecorationMix value) =>
      NumberFieldStepStyler().foregroundDecoration(value);
  factory NumberFieldStepStyler.clipBehavior(Clip value) =>
      NumberFieldStepStyler().clipBehavior(value);
  factory NumberFieldStepStyler.color(Color value) =>
      NumberFieldStepStyler().color(value);
  factory NumberFieldStepStyler.gradient(GradientMix value) =>
      NumberFieldStepStyler().gradient(value);
  factory NumberFieldStepStyler.border(BoxBorderMix value) =>
      NumberFieldStepStyler().border(value);
  factory NumberFieldStepStyler.borderRadius(BorderRadiusGeometryMix value) =>
      NumberFieldStepStyler().borderRadius(value);
  factory NumberFieldStepStyler.elevation(ElevationShadow value) =>
      NumberFieldStepStyler().elevation(value);
  factory NumberFieldStepStyler.shadow(BoxShadowMix value) =>
      NumberFieldStepStyler().shadow(value);
  factory NumberFieldStepStyler.shadows(List<BoxShadowMix> value) =>
      NumberFieldStepStyler().shadows(value);
  factory NumberFieldStepStyler.width(double value) =>
      NumberFieldStepStyler().width(value);
  factory NumberFieldStepStyler.height(double value) =>
      NumberFieldStepStyler().height(value);
  factory NumberFieldStepStyler.size(double width, double height) =>
      NumberFieldStepStyler().size(width, height);
  factory NumberFieldStepStyler.minWidth(double value) =>
      NumberFieldStepStyler().minWidth(value);
  factory NumberFieldStepStyler.maxWidth(double value) =>
      NumberFieldStepStyler().maxWidth(value);
  factory NumberFieldStepStyler.minHeight(double value) =>
      NumberFieldStepStyler().minHeight(value);
  factory NumberFieldStepStyler.maxHeight(double value) =>
      NumberFieldStepStyler().maxHeight(value);
  factory NumberFieldStepStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => NumberFieldStepStyler().scale(scale, alignment: alignment);
  factory NumberFieldStepStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => NumberFieldStepStyler().rotate(radians, alignment: alignment);
  factory NumberFieldStepStyler.translate(
    double x,
    double y, [
    double z = 0.0,
  ]) => NumberFieldStepStyler().translate(x, y, z);
  factory NumberFieldStepStyler.skew(double skewX, double skewY) =>
      NumberFieldStepStyler().skew(skewX, skewY);
  factory NumberFieldStepStyler.textStyle(TextStyler value) =>
      NumberFieldStepStyler().textStyle(value);
  factory NumberFieldStepStyler.image(DecorationImageMix value) =>
      NumberFieldStepStyler().image(value);
  factory NumberFieldStepStyler.shape(ShapeBorderMix value) =>
      NumberFieldStepStyler().shape(value);
  factory NumberFieldStepStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => NumberFieldStepStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory NumberFieldStepStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => NumberFieldStepStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory NumberFieldStepStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => NumberFieldStepStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory NumberFieldStepStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStepStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStepStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStepStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStepStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStepStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStepStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStepStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStepStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStepStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStepStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => NumberFieldStepStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory NumberFieldStepStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => NumberFieldStepStyler().transform(value, alignment: alignment);
  factory NumberFieldStepStyler.wrap(WidgetModifierConfig value) =>
      NumberFieldStepStyler().wrap(value);

  NumberFieldStepStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  NumberFieldStepStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  NumberFieldStepStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  NumberFieldStepStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  NumberFieldStepStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  NumberFieldStepStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  NumberFieldStepStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  NumberFieldStepStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  NumberFieldStepStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  NumberFieldStepStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  NumberFieldStepStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  NumberFieldStepStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  NumberFieldStepStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  NumberFieldStepStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  NumberFieldStepStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  NumberFieldStepStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  NumberFieldStepStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  NumberFieldStepStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  NumberFieldStepStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  NumberFieldStepStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  NumberFieldStepStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  NumberFieldStepStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  NumberFieldStepStyler rotate(
    double radians, {
    Alignment alignment = .center,
  }) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  NumberFieldStepStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  NumberFieldStepStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  NumberFieldStepStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  NumberFieldStepStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  NumberFieldStepStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  NumberFieldStepStyler backgroundImage(
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

  NumberFieldStepStyler backgroundImageUrl(
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

  NumberFieldStepStyler backgroundImageAsset(
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

  NumberFieldStepStyler linearGradient({
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

  NumberFieldStepStyler radialGradient({
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

  NumberFieldStepStyler sweepGradient({
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

  NumberFieldStepStyler foregroundLinearGradient({
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

  NumberFieldStepStyler foregroundRadialGradient({
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

  NumberFieldStepStyler foregroundSweepGradient({
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

  NumberFieldStepStyler transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'containerEffects',
    'icon',
    'iconScale',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  NumberFieldStepStyler container(BoxStyler value) {
    return merge(NumberFieldStepStyler(container: value));
  }

  /// Sets the containerEffects.
  NumberFieldStepStyler containerEffects(RemixBoxEffectsMix value) {
    return merge(NumberFieldStepStyler(containerEffects: value));
  }

  /// Sets the icon.
  NumberFieldStepStyler icon(IconStyler value) {
    return merge(NumberFieldStepStyler(icon: value));
  }

  /// Sets the iconScale.
  NumberFieldStepStyler iconScale(double value) {
    return merge(NumberFieldStepStyler(iconScale: value));
  }

  /// Sets the animation configuration.
  @override
  NumberFieldStepStyler animate(AnimationConfig value) {
    return merge(NumberFieldStepStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  NumberFieldStepStyler variants(
    List<VariantStyle<NumberFieldStepSpec>> value,
  ) {
    return merge(NumberFieldStepStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  NumberFieldStepStyler wrap(WidgetModifierConfig value) {
    return merge(NumberFieldStepStyler(modifier: value));
  }

  /// Sets the widget modifier.
  NumberFieldStepStyler modifier(WidgetModifierConfig value) {
    return merge(NumberFieldStepStyler(modifier: value));
  }

  /// Merges with another [NumberFieldStepStyler].
  @override
  NumberFieldStepStyler merge(NumberFieldStepStyler? other) {
    return NumberFieldStepStyler.create(
      container: MixOps.merge($container, other?.$container),
      containerEffects: MixOps.merge(
        $containerEffects,
        other?.$containerEffects,
      ),
      icon: MixOps.merge($icon, other?.$icon),
      iconScale: MixOps.merge($iconScale, other?.$iconScale),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<NumberFieldStepSpec>] using [context].
  @override
  StyleSpec<NumberFieldStepSpec> resolve(BuildContext context) {
    final spec = NumberFieldStepSpec(
      container: MixOps.resolve(context, $container),
      containerEffects: MixOps.resolve(context, $containerEffects),
      icon: MixOps.resolve(context, $icon),
      iconScale: MixOps.resolve(context, $iconScale),
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
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('iconScale', $iconScale));
  }

  @override
  List<Object?> get props => [
    $container,
    $containerEffects,
    $icon,
    $iconScale,
    $animation,
    $modifier,
    $variants,
  ];
}
