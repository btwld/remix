// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestions.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$AgentSuggestionsSpec
    implements Spec<AgentSuggestionsSpec>, Diagnosticable {
  StyleSpec<WrapBoxSpec> get container;

  @override
  Type get type => AgentSuggestionsSpec;

  @override
  AgentSuggestionsSpec copyWith({StyleSpec<WrapBoxSpec>? container}) {
    return AgentSuggestionsSpec(container: container ?? this.container);
  }

  @override
  AgentSuggestionsSpec lerp(AgentSuggestionsSpec? other, double t) {
    return AgentSuggestionsSpec(container: container.lerp(other?.container, t));
  }

  @override
  List<Object?> get props => [container];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AgentSuggestionsSpec &&
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
    properties.add(DiagnosticsProperty('container', container));
  }
}

@Deprecated(
  'Rename to `_\$AgentSuggestionsSpec` and migrate the class declaration to `class AgentSuggestionsSpec with _\$AgentSuggestionsSpec`. The `_\$AgentSuggestionsSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$AgentSuggestionsSpecMethods = _$AgentSuggestionsSpec; // ignore: unused_element

// **************************************************************************
// SpecStylerGenerator
// **************************************************************************

class AgentSuggestionsStyler
    extends MixStyler<AgentSuggestionsStyler, AgentSuggestionsSpec>
    implements StylerFieldMetadata {
  final Prop<StyleSpec<WrapBoxSpec>>? $container;

  const AgentSuggestionsStyler.create({
    Prop<StyleSpec<WrapBoxSpec>>? container,
    super.variants,
    super.modifier,
    super.animation,
  }) : $container = container;

  AgentSuggestionsStyler({
    WrapBoxStyler? container,
    AnimationConfig? animation,
    WidgetModifierConfig? modifier,
    List<VariantStyle<AgentSuggestionsSpec>>? variants,
  }) : this.create(
         container: Prop.maybeMix(container),
         variants: variants,
         modifier: modifier,
         animation: animation,
       );

  factory AgentSuggestionsStyler.container(WrapBoxStyler value) =>
      AgentSuggestionsStyler().container(value);

  @override
  Set<String> get $stylerFieldNames => const {
    'container',
    'animation',
    'modifier',
    'variants',
  };

  /// Sets the container.
  AgentSuggestionsStyler container(WrapBoxStyler value) {
    return merge(AgentSuggestionsStyler(container: value));
  }

  /// Sets the animation configuration.
  @override
  AgentSuggestionsStyler animate(AnimationConfig value) {
    return merge(AgentSuggestionsStyler(animation: value));
  }

  /// Sets the style variants.
  @override
  AgentSuggestionsStyler variants(
    List<VariantStyle<AgentSuggestionsSpec>> value,
  ) {
    return merge(AgentSuggestionsStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  @override
  AgentSuggestionsStyler wrap(WidgetModifierConfig value) {
    return merge(AgentSuggestionsStyler(modifier: value));
  }

  /// Sets the widget modifier.
  AgentSuggestionsStyler modifier(WidgetModifierConfig value) {
    return merge(AgentSuggestionsStyler(modifier: value));
  }

  /// Merges with another [AgentSuggestionsStyler].
  @override
  AgentSuggestionsStyler merge(AgentSuggestionsStyler? other) {
    return AgentSuggestionsStyler.create(
      container: MixOps.merge($container, other?.$container),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<AgentSuggestionsSpec>] using [context].
  @override
  StyleSpec<AgentSuggestionsSpec> resolve(BuildContext context) {
    final spec = AgentSuggestionsSpec(
      container: MixOps.resolve(context, $container),
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
    properties.add(DiagnosticsProperty('container', $container));
  }

  @override
  List<Object?> get props => [$container, $animation, $modifier, $variants];
}
