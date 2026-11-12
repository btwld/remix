// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composer.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AgentComposerSpec implements Spec<AgentComposerSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<BoxSpec> get field;
  double? get fieldMaxHeight;
  StyleSpec<FlexBoxSpec> get toolbar;

  @override
  Type get type => AgentComposerSpec;

  @override
  AgentComposerSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<BoxSpec>? field,
    double? fieldMaxHeight,
    StyleSpec<FlexBoxSpec>? toolbar,
  }) {
    return AgentComposerSpec(
      container: container ?? this.container,
      field: field ?? this.field,
      fieldMaxHeight: fieldMaxHeight ?? this.fieldMaxHeight,
      toolbar: toolbar ?? this.toolbar,
    );
  }

  @override
  AgentComposerSpec lerp(AgentComposerSpec? other, double t) {
    return AgentComposerSpec(
      container: container.lerp(other?.container, t),
      field: field.lerp(other?.field, t),
      fieldMaxHeight: MixOps.lerp(fieldMaxHeight, other?.fieldMaxHeight, t),
      toolbar: toolbar.lerp(other?.toolbar, t),
    );
  }

  @override
  List<Object?> get props => [container, field, fieldMaxHeight, toolbar];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentComposerSpec &&
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
      ..add(DoubleProperty('fieldMaxHeight', fieldMaxHeight))
      ..add(DiagnosticsProperty('toolbar', toolbar));
  }
}

@Deprecated(
  'Rename to `_\$AgentComposerSpec` and migrate the class declaration to `class AgentComposerSpec with _\$AgentComposerSpec`. The `_\$AgentComposerSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentComposerSpecMethods = _$AgentComposerSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AgentComposerStyler
    extends MixStyler<AgentComposerStyler, AgentComposerSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<BoxSpec>>? $container;
  final Prop<StyleSpec<BoxSpec>>? $field;
  final Prop<double>? $fieldMaxHeight;
  final Prop<StyleSpec<FlexBoxSpec>>? $toolbar;

  const AgentComposerStyler.create({
    Prop<StyleSpec<BoxSpec>>? container,
    Prop<StyleSpec<BoxSpec>>? field,
    Prop<double>? fieldMaxHeight,
    Prop<StyleSpec<FlexBoxSpec>>? toolbar,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container,
       $field = field,
       $fieldMaxHeight = fieldMaxHeight,
       $toolbar = toolbar;

  AgentComposerStyler({
    BoxStyler? container,
    BoxStyler? field,
    double? fieldMaxHeight,
    FlexBoxStyler? toolbar,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentComposerSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         field: Prop.maybeMix(field),
         fieldMaxHeight: Prop.maybe(fieldMaxHeight),
         toolbar: Prop.maybeMix(toolbar),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentComposerStyler.container(BoxStyler value) =>
      AgentComposerStyler().container(value);
  factory AgentComposerStyler.field(BoxStyler value) =>
      AgentComposerStyler().field(value);
  factory AgentComposerStyler.fieldMaxHeight(double value) =>
      AgentComposerStyler().fieldMaxHeight(value);
  factory AgentComposerStyler.toolbar(FlexBoxStyler value) =>
      AgentComposerStyler().toolbar(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'field',
    'fieldMaxHeight',
    'toolbar',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  AgentComposerStyler container(BoxStyler value) {
    return merge(AgentComposerStyler(container: value));
  }

  /// Sets the field.
  AgentComposerStyler field(BoxStyler value) {
    return merge(AgentComposerStyler(field: value));
  }

  /// Sets the fieldMaxHeight.
  AgentComposerStyler fieldMaxHeight(double value) {
    return merge(AgentComposerStyler(fieldMaxHeight: value));
  }

  /// Sets the toolbar.
  AgentComposerStyler toolbar(FlexBoxStyler value) {
    return merge(AgentComposerStyler(toolbar: value));
  }

  /// Sets the animation configuration.
  @override
  AgentComposerStyler animate(AnimationConfig value) {
    return merge(AgentComposerStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentComposerStyler variants(List<VariantStyle<AgentComposerSpec>> value) {
    return merge(AgentComposerStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentComposerStyler wrap(WidgetModifierConfig value) {
    return merge(AgentComposerStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentComposerStyler modifier(WidgetModifierConfig value) {
    return merge(AgentComposerStyler(modifier: value));
  }

  /// Merges with another [AgentComposerStyler].
  @override
  AgentComposerStyler merge(AgentComposerStyler? other) {
    return AgentComposerStyler.create(
      container: MixOps.merge($container, other?.$container),
      field: MixOps.merge($field, other?.$field),
      fieldMaxHeight: MixOps.merge($fieldMaxHeight, other?.$fieldMaxHeight),
      toolbar: MixOps.merge($toolbar, other?.$toolbar),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentComposerSpec>] using [context].
  @override
  StyleSpec<AgentComposerSpec> resolve(BuildContext context) {
    final spec = AgentComposerSpec(
      container: MixOps.resolve(context, $container),
      field: MixOps.resolve(context, $field),
      fieldMaxHeight: MixOps.resolve(context, $fieldMaxHeight),
      toolbar: MixOps.resolve(context, $toolbar),
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
      ..add(DiagnosticsProperty('fieldMaxHeight', $fieldMaxHeight))
      ..add(DiagnosticsProperty('toolbar', $toolbar));
  }

  @override
  List<Object?> get props => [
    $container,
    $field,
    $fieldMaxHeight,
    $toolbar,
    $animation,
    $modifier,
    $variants,
  ];
}
