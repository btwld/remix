// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combobox.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$ComboboxSpec implements Spec<ComboboxSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextFieldSpec> get field;
  StyleSpec<BoxSpec> get panel;
  StyleSpec<BoxSpec> get option;
  StyleSpec<TextSpec> get optionLabel;

  @override
  Type get type => ComboboxSpec;

  @override
  ComboboxSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextFieldSpec>? field,
    StyleSpec<BoxSpec>? panel,
    StyleSpec<BoxSpec>? option,
    StyleSpec<TextSpec>? optionLabel,
  }) {
    return ComboboxSpec(
      container: container ?? this.container,
      field: field ?? this.field,
      panel: panel ?? this.panel,
      option: option ?? this.option,
      optionLabel: optionLabel ?? this.optionLabel,
    );
  }

  @override
  ComboboxSpec lerp(ComboboxSpec? other, double t) {
    return ComboboxSpec(
      container: container.lerp(other?.container, t),
      field: field.lerp(other?.field, t),
      panel: panel.lerp(other?.panel, t),
      option: option.lerp(other?.option, t),
      optionLabel: optionLabel.lerp(other?.optionLabel, t),
    );
  }

  @override
  List<Object?> get props => [container, field, panel, option, optionLabel];

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
      ..add(DiagnosticsProperty('option', option))
      ..add(DiagnosticsProperty('optionLabel', optionLabel));
  }
}

@Deprecated(
  'Rename to `_\$ComboboxSpec` and migrate the class declaration to `class ComboboxSpec with _\$ComboboxSpec`. The `_\$ComboboxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$ComboboxSpecMethods = _$ComboboxSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class ComboboxStyler extends MixStyler<ComboboxStyler, ComboboxSpec>
    with RemixBoxStylerMixin<ComboboxStyler>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<TextFieldSpec>>? $field;
  final Prop<StyleSpec<BoxSpec>>? $panel;
  final Prop<StyleSpec<BoxSpec>>? $option;
  final Prop<StyleSpec<TextSpec>>? $optionLabel;

  const ComboboxStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<TextFieldSpec>>? field,
    Prop<StyleSpec<BoxSpec>>? panel,
    Prop<StyleSpec<BoxSpec>>? option,
    Prop<StyleSpec<TextSpec>>? optionLabel,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $field = field,
       $panel = panel,
       $option = option,
       $optionLabel = optionLabel;

  ComboboxStyler({
    BoxStyler? container,
    TextFieldStyler? field,
    BoxStyler? panel,
    BoxStyler? option,
    TextStyler? optionLabel,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<ComboboxSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         field: Prop.maybeMix(field),
         panel: Prop.maybeMix(panel),
         option: Prop.maybeMix(option),
         optionLabel: Prop.maybeMix(optionLabel),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory ComboboxStyler.container(BoxStyler value) =>
      ComboboxStyler().container(value);
  factory ComboboxStyler.field(TextFieldStyler value) =>
      ComboboxStyler().field(value);
  factory ComboboxStyler.panel(BoxStyler value) =>
      ComboboxStyler().panel(value);
  factory ComboboxStyler.option(BoxStyler value) =>
      ComboboxStyler().option(value);
  factory ComboboxStyler.optionLabel(TextStyler value) =>
      ComboboxStyler().optionLabel(value);
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
    'optionLabel',
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
  ComboboxStyler panel(BoxStyler value) {
    return merge(ComboboxStyler(panel: value));
  }

  /// Sets the option.
  ComboboxStyler option(BoxStyler value) {
    return merge(ComboboxStyler(option: value));
  }

  /// Sets the optionLabel.
  ComboboxStyler optionLabel(TextStyler value) {
    return merge(ComboboxStyler(optionLabel: value));
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
      optionLabel: MixOps.merge($optionLabel, other?.$optionLabel),
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
      optionLabel: MixOps.resolve(context, $optionLabel),
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
      ..add(DiagnosticsProperty('option', $option))
      ..add(DiagnosticsProperty('optionLabel', $optionLabel));
  }

  @override
  List<Object?> get props => [
    $container,
    $field,
    $panel,
    $option,
    $optionLabel,
    $animation,
    $modifier,
    $variants,
  ];
}
