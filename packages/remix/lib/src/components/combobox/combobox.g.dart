// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combobox.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ComboboxSpec implements Spec<ComboboxSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextFieldSpec> get field;
  StyleSpec<ComboboxPanelSpec> get panel;
  StyleSpec<ComboboxOptionSpec> get option;

  @override
  Type get type => ComboboxSpec;

  @override
  ComboboxSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextFieldSpec>? field,
    StyleSpec<ComboboxPanelSpec>? panel,
    StyleSpec<ComboboxOptionSpec>? option,
  }) {
    return ComboboxSpec(
      container: container ?? this.container,
      field: field ?? this.field,
      panel: panel ?? this.panel,
      option: option ?? this.option,
    );
  }

  @override
  ComboboxSpec lerp(ComboboxSpec? other, double t) {
    return ComboboxSpec(
      container: container.lerp(other?.container, t),
      field: field.lerp(other?.field, t),
      panel: panel.lerp(other?.panel, t),
      option: option.lerp(other?.option, t),
    );
  }

  @override
  List<Object?> get props => [container, field, panel, option];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ComboboxSpec &&
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
      ..add(DiagnosticsProperty('field', field))
      ..add(DiagnosticsProperty('panel', panel))
      ..add(DiagnosticsProperty('option', option));
  }
}

@Deprecated(
  'Rename to `_\$ComboboxSpec` and migrate the class declaration to `class ComboboxSpec with _\$ComboboxSpec`. The `_\$ComboboxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ComboboxSpecMethods = _$ComboboxSpec; // ignore: unused_element

mixin _$ComboboxOptionSpec implements Spec<ComboboxOptionSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get label;

  @override
  Type get type => ComboboxOptionSpec;

  @override
  ComboboxOptionSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
  }) {
    return ComboboxOptionSpec(
      container: container ?? this.container,
      label: label ?? this.label,
    );
  }

  @override
  ComboboxOptionSpec lerp(ComboboxOptionSpec? other, double t) {
    return ComboboxOptionSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
    );
  }

  @override
  List<Object?> get props => [container, label];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ComboboxOptionSpec &&
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
      ..add(DiagnosticsProperty('label', label));
  }
}

@Deprecated(
  'Rename to `_\$ComboboxOptionSpec` and migrate the class declaration to `class ComboboxOptionSpec with _\$ComboboxOptionSpec`. The `_\$ComboboxOptionSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ComboboxOptionSpecMethods = _$ComboboxOptionSpec; // ignore: unused_element

mixin _$ComboboxPanelSpec implements Spec<ComboboxPanelSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  RemixBoxEffectsSpec? get containerEffects;
  Color? get scrollbarColor;
  double? get scrollbarThickness;

  @override
  Type get type => ComboboxPanelSpec;

  @override
  ComboboxPanelSpec copyWith({
    StyleSpec<BoxSpec>? container,
    RemixBoxEffectsSpec? containerEffects,
    Color? scrollbarColor,
    double? scrollbarThickness,
  }) {
    return ComboboxPanelSpec(
      container: container ?? this.container,
      containerEffects: containerEffects ?? this.containerEffects,
      scrollbarColor: scrollbarColor ?? this.scrollbarColor,
      scrollbarThickness: scrollbarThickness ?? this.scrollbarThickness,
    );
  }

  @override
  ComboboxPanelSpec lerp(ComboboxPanelSpec? other, double t) {
    return ComboboxPanelSpec(
      container: container.lerp(other?.container, t),
      containerEffects: MixOps.lerpSnap(
        containerEffects,
        other?.containerEffects,
        t,
      ),
      scrollbarColor: MixOps.lerp(scrollbarColor, other?.scrollbarColor, t),
      scrollbarThickness: MixOps.lerp(
        scrollbarThickness,
        other?.scrollbarThickness,
        t,
      ),
    );
  }

  @override
  List<Object?> get props => [
    container,
    containerEffects,
    scrollbarColor,
    scrollbarThickness,
  ];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is ComboboxPanelSpec &&
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
      ..add(ColorProperty('scrollbarColor', scrollbarColor))
      ..add(DoubleProperty('scrollbarThickness', scrollbarThickness));
  }
}

@Deprecated(
  'Rename to `_\$ComboboxPanelSpec` and migrate the class declaration to `class ComboboxPanelSpec with _\$ComboboxPanelSpec`. The `_\$ComboboxPanelSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ComboboxPanelSpecMethods = _$ComboboxPanelSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ComboboxStyler extends MixStyler<ComboboxStyler, ComboboxSpec>
    with RemixBoxStylerMixin<ComboboxStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextFieldSpec>>? $field;
  final Prop<StyleSpec<ComboboxPanelSpec>>? $panel;
  final Prop<StyleSpec<ComboboxOptionSpec>>? $option;

  const ComboboxStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextFieldSpec>>? field,
    Prop<StyleSpec<ComboboxPanelSpec>>? panel,
    Prop<StyleSpec<ComboboxOptionSpec>>? option,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $field = field,
       $panel = panel,
       $option = option;

  ComboboxStyler({
    BoxStyler? container,
    TextFieldStyler? field,
    ComboboxPanelStyler? panel,
    ComboboxOptionStyler? option,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ComboboxSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         field: Prop.maybeMix(field),
         panel: Prop.maybeMix(panel),
         option: Prop.maybeMix(option),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ComboboxStyler.container(BoxStyler value) =>
      ComboboxStyler().container(value);
  factory ComboboxStyler.field(TextFieldStyler value) =>
      ComboboxStyler().field(value);
  factory ComboboxStyler.panel(ComboboxPanelStyler value) =>
      ComboboxStyler().panel(value);
  factory ComboboxStyler.option(ComboboxOptionStyler value) =>
      ComboboxStyler().option(value);
  factory ComboboxStyler.alignment(AlignmentGeometry value) =>
      ComboboxStyler().alignment(value);
  factory ComboboxStyler.padding(EdgeInsetsGeometryMix value) =>
      ComboboxStyler().padding(value);
  factory ComboboxStyler.margin(EdgeInsetsGeometryMix value) =>
      ComboboxStyler().margin(value);
  factory ComboboxStyler.constraints(BoxConstraintsMix value) =>
      ComboboxStyler().constraints(value);
  factory ComboboxStyler.decoration(DecorationMix value) =>
      ComboboxStyler().decoration(value);
  factory ComboboxStyler.foregroundDecoration(DecorationMix value) =>
      ComboboxStyler().foregroundDecoration(value);
  factory ComboboxStyler.clipBehavior(Clip value) =>
      ComboboxStyler().clipBehavior(value);
  factory ComboboxStyler.color(Color value) => ComboboxStyler().color(value);
  factory ComboboxStyler.gradient(GradientMix value) =>
      ComboboxStyler().gradient(value);
  factory ComboboxStyler.border(BoxBorderMix value) =>
      ComboboxStyler().border(value);
  factory ComboboxStyler.borderRadius(BorderRadiusGeometryMix value) =>
      ComboboxStyler().borderRadius(value);
  factory ComboboxStyler.elevation(ElevationShadow value) =>
      ComboboxStyler().elevation(value);
  factory ComboboxStyler.shadow(BoxShadowMix value) =>
      ComboboxStyler().shadow(value);
  factory ComboboxStyler.shadows(List<BoxShadowMix> value) =>
      ComboboxStyler().shadows(value);
  factory ComboboxStyler.width(double value) => ComboboxStyler().width(value);
  factory ComboboxStyler.height(double value) => ComboboxStyler().height(value);
  factory ComboboxStyler.size(double width, double height) =>
      ComboboxStyler().size(width, height);
  factory ComboboxStyler.minWidth(double value) =>
      ComboboxStyler().minWidth(value);
  factory ComboboxStyler.maxWidth(double value) =>
      ComboboxStyler().maxWidth(value);
  factory ComboboxStyler.minHeight(double value) =>
      ComboboxStyler().minHeight(value);
  factory ComboboxStyler.maxHeight(double value) =>
      ComboboxStyler().maxHeight(value);
  factory ComboboxStyler.scale(double scale, {Alignment alignment = .center}) =>
      ComboboxStyler().scale(scale, alignment: alignment);
  factory ComboboxStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => ComboboxStyler().rotate(radians, alignment: alignment);
  factory ComboboxStyler.translate(double x, double y, [double z = 0.0]) =>
      ComboboxStyler().translate(x, y, z);
  factory ComboboxStyler.skew(double skewX, double skewY) =>
      ComboboxStyler().skew(skewX, skewY);
  factory ComboboxStyler.textStyle(TextStyler value) =>
      ComboboxStyler().textStyle(value);
  factory ComboboxStyler.image(DecorationImageMix value) =>
      ComboboxStyler().image(value);
  factory ComboboxStyler.shape(ShapeBorderMix value) =>
      ComboboxStyler().shape(value);
  factory ComboboxStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => ComboboxStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory ComboboxStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => ComboboxStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory ComboboxStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => ComboboxStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory ComboboxStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => ComboboxStyler().transform(value, alignment: alignment);

  ComboboxStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  ComboboxStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  ComboboxStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  ComboboxStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  ComboboxStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  ComboboxStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  ComboboxStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  ComboboxStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  ComboboxStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  ComboboxStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  ComboboxStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  ComboboxStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  ComboboxStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  ComboboxStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  ComboboxStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  ComboboxStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  ComboboxStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  ComboboxStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  ComboboxStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  ComboboxStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  ComboboxStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  ComboboxStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  ComboboxStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  ComboboxStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  ComboboxStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  ComboboxStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  ComboboxStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  ComboboxStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  ComboboxStyler backgroundImage(
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

  ComboboxStyler backgroundImageUrl(
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

  ComboboxStyler backgroundImageAsset(
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

  ComboboxStyler linearGradient({
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

  ComboboxStyler radialGradient({
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

  ComboboxStyler sweepGradient({
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

  ComboboxStyler foregroundLinearGradient({
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

  ComboboxStyler foregroundRadialGradient({
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

  ComboboxStyler foregroundSweepGradient({
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

  ComboboxStyler transform(Matrix4 value, {Alignment alignment = .center}) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'field',
    'panel',
    'option',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  ComboboxStyler container(BoxStyler value) {
    return merge(ComboboxStyler(container: value));
  }

  /// Sets the field.
  ComboboxStyler field(TextFieldStyler value) {
    return merge(ComboboxStyler(field: value));
  }

  /// Sets the panel.
  ComboboxStyler panel(ComboboxPanelStyler value) {
    return merge(ComboboxStyler(panel: value));
  }

  /// Sets the option.
  ComboboxStyler option(ComboboxOptionStyler value) {
    return merge(ComboboxStyler(option: value));
  }

  /// Sets the animation configuration.
  @override
  ComboboxStyler animate(AnimationConfig value) {
    return merge(ComboboxStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ComboboxStyler variants(List<VariantStyle<ComboboxSpec>> value) {
    return merge(ComboboxStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ComboboxStyler wrap(WidgetModifierConfig value) {
    return merge(ComboboxStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ComboboxStyler modifier(WidgetModifierConfig value) {
    return merge(ComboboxStyler(modifier: value));
  }

  RemixCombobox<T> call<T extends Object>({
    Key? key,
    required AutocompleteOptionsBuilder<T> optionsBuilder,
    ValueChanged<T>? onSelected,
    AutocompleteOptionToString<T> displayStringForOption =
        RawAutocomplete.defaultStringForOption,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextEditingValue? initialValue,
    String? label,
    String? hintText,
    bool enabled = true,
    bool autofocus = false,
    String? semanticLabel,
    NakedComboboxFieldBuilder<T>? fieldBuilder,
    Widget Function(BuildContext context, T option)? optionBuilder,
    OptionsViewOpenDirection optionsViewOpenDirection =
        OptionsViewOpenDirection.down,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    bool excludeSemantics = false,
  }) {
    return RemixCombobox<T>(
      key: key,
      style: this,
      optionsBuilder: optionsBuilder,
      onSelected: onSelected,
      displayStringForOption: displayStringForOption,
      controller: controller,
      focusNode: focusNode,
      initialValue: initialValue,
      label: label,
      hintText: hintText,
      enabled: enabled,
      autofocus: autofocus,
      semanticLabel: semanticLabel,
      fieldBuilder: fieldBuilder,
      optionBuilder: optionBuilder,
      optionsViewOpenDirection: optionsViewOpenDirection,
      onOpen: onOpen,
      onClose: onClose,
      excludeSemantics: excludeSemantics,
    );
  }

  /// Merges with another [ComboboxStyler].
  @override
  ComboboxStyler merge(ComboboxStyler? other) {
    return ComboboxStyler.create(
      container: MixOps.merge($container, other?.$container),
      field: MixOps.merge($field, other?.$field),
      panel: MixOps.merge($panel, other?.$panel),
      option: MixOps.merge($option, other?.$option),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ComboboxSpec>] using [context].
  @override
  StyleSpec<ComboboxSpec> resolve(BuildContext context) {
    final spec = ComboboxSpec(
      container: MixOps.resolve(context, $container),
      field: MixOps.resolve(context, $field),
      panel: MixOps.resolve(context, $panel),
      option: MixOps.resolve(context, $option),
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
      ..add(DiagnosticsProperty('field', $field))
      ..add(DiagnosticsProperty('panel', $panel))
      ..add(DiagnosticsProperty('option', $option));
  }

  @override
  List<Object?> get props => [
    $container,
    $field,
    $panel,
    $option,
    $animation,
    $modifier,
    $variants,
  ];
}

class ComboboxOptionStyler
    extends MixStyler<ComboboxOptionStyler, ComboboxOptionSpec>
    with
        RemixBoxStylerMixin<ComboboxOptionStyler>,
        LabelStyleMixin<ComboboxOptionStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextSpec>>? $label;

  const ComboboxOptionStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextSpec>>? label,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $label = label;

  ComboboxOptionStyler({
    BoxStyler? container,
    TextStyler? label,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ComboboxOptionSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         label: Prop.maybeMix(label),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ComboboxOptionStyler.container(BoxStyler value) =>
      ComboboxOptionStyler().container(value);
  factory ComboboxOptionStyler.label(TextStyler value) =>
      ComboboxOptionStyler().label(value);
  factory ComboboxOptionStyler.alignment(AlignmentGeometry value) =>
      ComboboxOptionStyler().alignment(value);
  factory ComboboxOptionStyler.padding(EdgeInsetsGeometryMix value) =>
      ComboboxOptionStyler().padding(value);
  factory ComboboxOptionStyler.margin(EdgeInsetsGeometryMix value) =>
      ComboboxOptionStyler().margin(value);
  factory ComboboxOptionStyler.constraints(BoxConstraintsMix value) =>
      ComboboxOptionStyler().constraints(value);
  factory ComboboxOptionStyler.decoration(DecorationMix value) =>
      ComboboxOptionStyler().decoration(value);
  factory ComboboxOptionStyler.foregroundDecoration(DecorationMix value) =>
      ComboboxOptionStyler().foregroundDecoration(value);
  factory ComboboxOptionStyler.clipBehavior(Clip value) =>
      ComboboxOptionStyler().clipBehavior(value);
  factory ComboboxOptionStyler.color(Color value) =>
      ComboboxOptionStyler().color(value);
  factory ComboboxOptionStyler.gradient(GradientMix value) =>
      ComboboxOptionStyler().gradient(value);
  factory ComboboxOptionStyler.border(BoxBorderMix value) =>
      ComboboxOptionStyler().border(value);
  factory ComboboxOptionStyler.borderRadius(BorderRadiusGeometryMix value) =>
      ComboboxOptionStyler().borderRadius(value);
  factory ComboboxOptionStyler.elevation(ElevationShadow value) =>
      ComboboxOptionStyler().elevation(value);
  factory ComboboxOptionStyler.shadow(BoxShadowMix value) =>
      ComboboxOptionStyler().shadow(value);
  factory ComboboxOptionStyler.shadows(List<BoxShadowMix> value) =>
      ComboboxOptionStyler().shadows(value);
  factory ComboboxOptionStyler.width(double value) =>
      ComboboxOptionStyler().width(value);
  factory ComboboxOptionStyler.height(double value) =>
      ComboboxOptionStyler().height(value);
  factory ComboboxOptionStyler.size(double width, double height) =>
      ComboboxOptionStyler().size(width, height);
  factory ComboboxOptionStyler.minWidth(double value) =>
      ComboboxOptionStyler().minWidth(value);
  factory ComboboxOptionStyler.maxWidth(double value) =>
      ComboboxOptionStyler().maxWidth(value);
  factory ComboboxOptionStyler.minHeight(double value) =>
      ComboboxOptionStyler().minHeight(value);
  factory ComboboxOptionStyler.maxHeight(double value) =>
      ComboboxOptionStyler().maxHeight(value);
  factory ComboboxOptionStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => ComboboxOptionStyler().scale(scale, alignment: alignment);
  factory ComboboxOptionStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => ComboboxOptionStyler().rotate(radians, alignment: alignment);
  factory ComboboxOptionStyler.translate(
    double x,
    double y, [
    double z = 0.0,
  ]) => ComboboxOptionStyler().translate(x, y, z);
  factory ComboboxOptionStyler.skew(double skewX, double skewY) =>
      ComboboxOptionStyler().skew(skewX, skewY);
  factory ComboboxOptionStyler.textStyle(TextStyler value) =>
      ComboboxOptionStyler().textStyle(value);
  factory ComboboxOptionStyler.image(DecorationImageMix value) =>
      ComboboxOptionStyler().image(value);
  factory ComboboxOptionStyler.shape(ShapeBorderMix value) =>
      ComboboxOptionStyler().shape(value);
  factory ComboboxOptionStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => ComboboxOptionStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory ComboboxOptionStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => ComboboxOptionStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory ComboboxOptionStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => ComboboxOptionStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory ComboboxOptionStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxOptionStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxOptionStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxOptionStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxOptionStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxOptionStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxOptionStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxOptionStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxOptionStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxOptionStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxOptionStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxOptionStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxOptionStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => ComboboxOptionStyler().transform(value, alignment: alignment);

  ComboboxOptionStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  ComboboxOptionStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  ComboboxOptionStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  ComboboxOptionStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  ComboboxOptionStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  ComboboxOptionStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  ComboboxOptionStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  ComboboxOptionStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  ComboboxOptionStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  ComboboxOptionStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  ComboboxOptionStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  ComboboxOptionStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  ComboboxOptionStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  ComboboxOptionStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  ComboboxOptionStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  ComboboxOptionStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  ComboboxOptionStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  ComboboxOptionStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  ComboboxOptionStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  ComboboxOptionStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  ComboboxOptionStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  ComboboxOptionStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  ComboboxOptionStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  ComboboxOptionStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  ComboboxOptionStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  ComboboxOptionStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  ComboboxOptionStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  ComboboxOptionStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  ComboboxOptionStyler backgroundImage(
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

  ComboboxOptionStyler backgroundImageUrl(
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

  ComboboxOptionStyler backgroundImageAsset(
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

  ComboboxOptionStyler linearGradient({
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

  ComboboxOptionStyler radialGradient({
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

  ComboboxOptionStyler sweepGradient({
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

  ComboboxOptionStyler foregroundLinearGradient({
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

  ComboboxOptionStyler foregroundRadialGradient({
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

  ComboboxOptionStyler foregroundSweepGradient({
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

  ComboboxOptionStyler transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'label',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  ComboboxOptionStyler container(BoxStyler value) {
    return merge(ComboboxOptionStyler(container: value));
  }

  /// Sets the label.
  @override
  ComboboxOptionStyler label(TextStyler value) {
    return merge(ComboboxOptionStyler(label: value));
  }

  /// Sets the animation configuration.
  @override
  ComboboxOptionStyler animate(AnimationConfig value) {
    return merge(ComboboxOptionStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ComboboxOptionStyler variants(List<VariantStyle<ComboboxOptionSpec>> value) {
    return merge(ComboboxOptionStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ComboboxOptionStyler wrap(WidgetModifierConfig value) {
    return merge(ComboboxOptionStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ComboboxOptionStyler modifier(WidgetModifierConfig value) {
    return merge(ComboboxOptionStyler(modifier: value));
  }

  /// Merges with another [ComboboxOptionStyler].
  @override
  ComboboxOptionStyler merge(ComboboxOptionStyler? other) {
    return ComboboxOptionStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ComboboxOptionSpec>] using [context].
  @override
  StyleSpec<ComboboxOptionSpec> resolve(BuildContext context) {
    final spec = ComboboxOptionSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
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
      ..add(DiagnosticsProperty('label', $label));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $animation,
    $modifier,
    $variants,
  ];
}

class ComboboxPanelStyler
    extends MixStyler<ComboboxPanelStyler, ComboboxPanelSpec>
    with RemixBoxStylerMixin<ComboboxPanelStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<RemixBoxEffectsSpec>? $containerEffects;
  final Prop<Color>? $scrollbarColor;
  final Prop<double>? $scrollbarThickness;

  const ComboboxPanelStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<RemixBoxEffectsSpec>? containerEffects,
    Prop<Color>? scrollbarColor,
    Prop<double>? scrollbarThickness,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $containerEffects = containerEffects,
       $scrollbarColor = scrollbarColor,
       $scrollbarThickness = scrollbarThickness;

  ComboboxPanelStyler({
    BoxStyler? container,
    RemixBoxEffectsMix? containerEffects,
    Color? scrollbarColor,
    double? scrollbarThickness,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ComboboxPanelSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         containerEffects: Prop.maybeMix(containerEffects),
         scrollbarColor: Prop.maybe(scrollbarColor),
         scrollbarThickness: Prop.maybe(scrollbarThickness),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ComboboxPanelStyler.container(BoxStyler value) =>
      ComboboxPanelStyler().container(value);
  factory ComboboxPanelStyler.containerEffects(RemixBoxEffectsMix value) =>
      ComboboxPanelStyler().containerEffects(value);
  factory ComboboxPanelStyler.scrollbarColor(Color value) =>
      ComboboxPanelStyler().scrollbarColor(value);
  factory ComboboxPanelStyler.scrollbarThickness(double value) =>
      ComboboxPanelStyler().scrollbarThickness(value);
  factory ComboboxPanelStyler.alignment(AlignmentGeometry value) =>
      ComboboxPanelStyler().alignment(value);
  factory ComboboxPanelStyler.padding(EdgeInsetsGeometryMix value) =>
      ComboboxPanelStyler().padding(value);
  factory ComboboxPanelStyler.margin(EdgeInsetsGeometryMix value) =>
      ComboboxPanelStyler().margin(value);
  factory ComboboxPanelStyler.constraints(BoxConstraintsMix value) =>
      ComboboxPanelStyler().constraints(value);
  factory ComboboxPanelStyler.decoration(DecorationMix value) =>
      ComboboxPanelStyler().decoration(value);
  factory ComboboxPanelStyler.foregroundDecoration(DecorationMix value) =>
      ComboboxPanelStyler().foregroundDecoration(value);
  factory ComboboxPanelStyler.clipBehavior(Clip value) =>
      ComboboxPanelStyler().clipBehavior(value);
  factory ComboboxPanelStyler.color(Color value) =>
      ComboboxPanelStyler().color(value);
  factory ComboboxPanelStyler.gradient(GradientMix value) =>
      ComboboxPanelStyler().gradient(value);
  factory ComboboxPanelStyler.border(BoxBorderMix value) =>
      ComboboxPanelStyler().border(value);
  factory ComboboxPanelStyler.borderRadius(BorderRadiusGeometryMix value) =>
      ComboboxPanelStyler().borderRadius(value);
  factory ComboboxPanelStyler.elevation(ElevationShadow value) =>
      ComboboxPanelStyler().elevation(value);
  factory ComboboxPanelStyler.shadow(BoxShadowMix value) =>
      ComboboxPanelStyler().shadow(value);
  factory ComboboxPanelStyler.shadows(List<BoxShadowMix> value) =>
      ComboboxPanelStyler().shadows(value);
  factory ComboboxPanelStyler.width(double value) =>
      ComboboxPanelStyler().width(value);
  factory ComboboxPanelStyler.height(double value) =>
      ComboboxPanelStyler().height(value);
  factory ComboboxPanelStyler.size(double width, double height) =>
      ComboboxPanelStyler().size(width, height);
  factory ComboboxPanelStyler.minWidth(double value) =>
      ComboboxPanelStyler().minWidth(value);
  factory ComboboxPanelStyler.maxWidth(double value) =>
      ComboboxPanelStyler().maxWidth(value);
  factory ComboboxPanelStyler.minHeight(double value) =>
      ComboboxPanelStyler().minHeight(value);
  factory ComboboxPanelStyler.maxHeight(double value) =>
      ComboboxPanelStyler().maxHeight(value);
  factory ComboboxPanelStyler.scale(
    double scale, {
    Alignment alignment = .center,
  }) => ComboboxPanelStyler().scale(scale, alignment: alignment);
  factory ComboboxPanelStyler.rotate(
    double radians, {
    Alignment alignment = .center,
  }) => ComboboxPanelStyler().rotate(radians, alignment: alignment);
  factory ComboboxPanelStyler.translate(double x, double y, [double z = 0.0]) =>
      ComboboxPanelStyler().translate(x, y, z);
  factory ComboboxPanelStyler.skew(double skewX, double skewY) =>
      ComboboxPanelStyler().skew(skewX, skewY);
  factory ComboboxPanelStyler.textStyle(TextStyler value) =>
      ComboboxPanelStyler().textStyle(value);
  factory ComboboxPanelStyler.image(DecorationImageMix value) =>
      ComboboxPanelStyler().image(value);
  factory ComboboxPanelStyler.shape(ShapeBorderMix value) =>
      ComboboxPanelStyler().shape(value);
  factory ComboboxPanelStyler.backgroundImage(
    ImageProvider image, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => ComboboxPanelStyler().backgroundImage(
    image,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory ComboboxPanelStyler.backgroundImageUrl(
    String url, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => ComboboxPanelStyler().backgroundImageUrl(
    url,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory ComboboxPanelStyler.backgroundImageAsset(
    String path, {
    BoxFit? fit,
    AlignmentGeometry? alignment,
    ImageRepeat repeat = .noRepeat,
  }) => ComboboxPanelStyler().backgroundImageAsset(
    path,
    fit: fit,
    alignment: alignment,
    repeat: repeat,
  );
  factory ComboboxPanelStyler.linearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxPanelStyler().linearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxPanelStyler.radialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxPanelStyler().radialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxPanelStyler.sweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxPanelStyler().sweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxPanelStyler.foregroundLinearGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? begin,
    AlignmentGeometry? end,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxPanelStyler().foregroundLinearGradient(
    colors: colors,
    stops: stops,
    begin: begin,
    end: end,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxPanelStyler.foregroundRadialGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? radius,
    AlignmentGeometry? focal,
    double? focalRadius,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxPanelStyler().foregroundRadialGradient(
    colors: colors,
    stops: stops,
    center: center,
    radius: radius,
    focal: focal,
    focalRadius: focalRadius,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxPanelStyler.foregroundSweepGradient({
    required List<Color> colors,
    List<double>? stops,
    AlignmentGeometry? center,
    double? startAngle,
    double? endAngle,
    TileMode? tileMode,
    GradientTransform? transform,
  }) => ComboboxPanelStyler().foregroundSweepGradient(
    colors: colors,
    stops: stops,
    center: center,
    startAngle: startAngle,
    endAngle: endAngle,
    tileMode: tileMode,
    transform: transform,
  );
  factory ComboboxPanelStyler.transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) => ComboboxPanelStyler().transform(value, alignment: alignment);

  ComboboxPanelStyler alignment(AlignmentGeometry value) {
    return container(BoxStyler().alignment(value));
  }

  ComboboxPanelStyler padding(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().padding(value));
  }

  ComboboxPanelStyler margin(EdgeInsetsGeometryMix value) {
    return container(BoxStyler().margin(value));
  }

  ComboboxPanelStyler constraints(BoxConstraintsMix value) {
    return container(BoxStyler().constraints(value));
  }

  ComboboxPanelStyler decoration(DecorationMix value) {
    return container(BoxStyler().decoration(value));
  }

  ComboboxPanelStyler foregroundDecoration(DecorationMix value) {
    return container(BoxStyler().foregroundDecoration(value));
  }

  ComboboxPanelStyler clipBehavior(Clip value) {
    return container(BoxStyler().clipBehavior(value));
  }

  ComboboxPanelStyler color(Color value) {
    return container(BoxStyler().color(value));
  }

  ComboboxPanelStyler gradient(GradientMix value) {
    return container(BoxStyler().gradient(value));
  }

  ComboboxPanelStyler border(BoxBorderMix value) {
    return container(BoxStyler().border(value));
  }

  ComboboxPanelStyler borderRadius(BorderRadiusGeometryMix value) {
    return container(BoxStyler().borderRadius(value));
  }

  ComboboxPanelStyler elevation(ElevationShadow value) {
    return container(BoxStyler().elevation(value));
  }

  ComboboxPanelStyler shadow(BoxShadowMix value) {
    return container(BoxStyler().shadow(value));
  }

  ComboboxPanelStyler shadows(List<BoxShadowMix> value) {
    return container(BoxStyler().shadows(value));
  }

  ComboboxPanelStyler width(double value) {
    return container(BoxStyler().width(value));
  }

  ComboboxPanelStyler height(double value) {
    return container(BoxStyler().height(value));
  }

  ComboboxPanelStyler size(double width, double height) {
    return container(BoxStyler().size(width, height));
  }

  ComboboxPanelStyler minWidth(double value) {
    return container(BoxStyler().minWidth(value));
  }

  ComboboxPanelStyler maxWidth(double value) {
    return container(BoxStyler().maxWidth(value));
  }

  ComboboxPanelStyler minHeight(double value) {
    return container(BoxStyler().minHeight(value));
  }

  ComboboxPanelStyler maxHeight(double value) {
    return container(BoxStyler().maxHeight(value));
  }

  ComboboxPanelStyler scale(double scale, {Alignment alignment = .center}) {
    return container(BoxStyler().scale(scale, alignment: alignment));
  }

  ComboboxPanelStyler rotate(double radians, {Alignment alignment = .center}) {
    return container(BoxStyler().rotate(radians, alignment: alignment));
  }

  ComboboxPanelStyler translate(double x, double y, [double z = 0.0]) {
    return container(BoxStyler().translate(x, y, z));
  }

  ComboboxPanelStyler skew(double skewX, double skewY) {
    return container(BoxStyler().skew(skewX, skewY));
  }

  ComboboxPanelStyler textStyle(TextStyler value) {
    return container(BoxStyler().textStyle(value));
  }

  ComboboxPanelStyler image(DecorationImageMix value) {
    return container(BoxStyler().image(value));
  }

  ComboboxPanelStyler shape(ShapeBorderMix value) {
    return container(BoxStyler().shape(value));
  }

  ComboboxPanelStyler backgroundImage(
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

  ComboboxPanelStyler backgroundImageUrl(
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

  ComboboxPanelStyler backgroundImageAsset(
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

  ComboboxPanelStyler linearGradient({
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

  ComboboxPanelStyler radialGradient({
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

  ComboboxPanelStyler sweepGradient({
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

  ComboboxPanelStyler foregroundLinearGradient({
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

  ComboboxPanelStyler foregroundRadialGradient({
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

  ComboboxPanelStyler foregroundSweepGradient({
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

  ComboboxPanelStyler transform(
    Matrix4 value, {
    Alignment alignment = .center,
  }) {
    return container(BoxStyler().transform(value, alignment: alignment));
  }

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'containerEffects',
    'scrollbarColor',
    'scrollbarThickness',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  ComboboxPanelStyler container(BoxStyler value) {
    return merge(ComboboxPanelStyler(container: value));
  }

  /// Sets the containerEffects.
  ComboboxPanelStyler containerEffects(RemixBoxEffectsMix value) {
    return merge(ComboboxPanelStyler(containerEffects: value));
  }

  /// Sets the scrollbarColor.
  ComboboxPanelStyler scrollbarColor(Color value) {
    return merge(ComboboxPanelStyler(scrollbarColor: value));
  }

  /// Sets the scrollbarThickness.
  ComboboxPanelStyler scrollbarThickness(double value) {
    return merge(ComboboxPanelStyler(scrollbarThickness: value));
  }

  /// Sets the animation configuration.
  @override
  ComboboxPanelStyler animate(AnimationConfig value) {
    return merge(ComboboxPanelStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  ComboboxPanelStyler variants(List<VariantStyle<ComboboxPanelSpec>> value) {
    return merge(ComboboxPanelStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  ComboboxPanelStyler wrap(WidgetModifierConfig value) {
    return merge(ComboboxPanelStyler(modifier: value));
  }

  /// Sets the widget modifier.
  ComboboxPanelStyler modifier(WidgetModifierConfig value) {
    return merge(ComboboxPanelStyler(modifier: value));
  }

  /// Merges with another [ComboboxPanelStyler].
  @override
  ComboboxPanelStyler merge(ComboboxPanelStyler? other) {
    return ComboboxPanelStyler.create(
      container: MixOps.merge($container, other?.$container),
      containerEffects: MixOps.merge(
        $containerEffects,
        other?.$containerEffects,
      ),
      scrollbarColor: MixOps.merge($scrollbarColor, other?.$scrollbarColor),
      scrollbarThickness: MixOps.merge(
        $scrollbarThickness,
        other?.$scrollbarThickness,
      ),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<ComboboxPanelSpec>] using [context].
  @override
  StyleSpec<ComboboxPanelSpec> resolve(BuildContext context) {
    final spec = ComboboxPanelSpec(
      container: MixOps.resolve(context, $container),
      containerEffects: MixOps.resolve(context, $containerEffects),
      scrollbarColor: MixOps.resolve(context, $scrollbarColor),
      scrollbarThickness: MixOps.resolve(context, $scrollbarThickness),
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
      ..add(DiagnosticsProperty('scrollbarColor', $scrollbarColor))
      ..add(DiagnosticsProperty('scrollbarThickness', $scrollbarThickness));
  }

  @override
  List<Object?> get props => [
    $container,
    $containerEffects,
    $scrollbarColor,
    $scrollbarThickness,
    $animation,
    $modifier,
    $variants,
  ];
}
