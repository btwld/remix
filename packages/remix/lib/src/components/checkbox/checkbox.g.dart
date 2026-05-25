// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkbox.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixCheckboxSpec implements Spec<RemixCheckboxSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<IconSpec> get indicator;

  @override
  Type get type => RemixCheckboxSpec;

  @override
  RemixCheckboxSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<IconSpec>? indicator,
  }) {
    return RemixCheckboxSpec(
      container: container ?? this.container,
      indicator: indicator ?? this.indicator,
    );
  }

  @override
  RemixCheckboxSpec lerp(RemixCheckboxSpec? other, double t) {
    return RemixCheckboxSpec(
      container: container.lerp(other?.container, t),
      indicator: indicator.lerp(other?.indicator, t),
    );
  }

  @override
  List<Object?> get props => [container, indicator];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixCheckboxSpec &&
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
      ..add(DiagnosticsProperty('indicator', indicator));
  }
}

@Deprecated(
  'Rename to `_\$RemixCheckboxSpec` and migrate the class declaration to `class RemixCheckboxSpec with _\$RemixCheckboxSpec`. The `_\$RemixCheckboxSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixCheckboxSpecMethods = _$RemixCheckboxSpec; // ignore: unused_element

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixCheckboxStyleMixin on Style<RemixCheckboxSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $indicator;

  /// Sets the container.
  RemixCheckboxStyle container(BoxStyler value) {
    return merge(RemixCheckboxStyle(container: value));
  }

  /// Sets the indicator.
  RemixCheckboxStyle indicator(IconStyler value) {
    return merge(RemixCheckboxStyle(indicator: value));
  }

  /// Sets the animation configuration.
  RemixCheckboxStyle animate(AnimationConfig value) {
    return merge(RemixCheckboxStyle(animation: value));
  }

  /// Sets the style variants.
  RemixCheckboxStyle variants(List<VariantStyle<RemixCheckboxSpec>> value) {
    return merge(RemixCheckboxStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixCheckboxStyle wrap(WidgetModifierConfig value) {
    return merge(RemixCheckboxStyle(modifier: value));
  }

  /// Merges with another [RemixCheckboxStyle].
  @override
  RemixCheckboxStyle merge(RemixCheckboxStyle? other) {
    return RemixCheckboxStyle.create(
      container: MixOps.merge($container, other?.$container),
      indicator: MixOps.merge($indicator, other?.$indicator),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixCheckboxSpec>] using context.
  @override
  StyleSpec<RemixCheckboxSpec> resolve(BuildContext context) {
    final spec = RemixCheckboxSpec(
      container: MixOps.resolve(context, $container),
      indicator: MixOps.resolve(context, $indicator),
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
      ..add(DiagnosticsProperty('indicator', $indicator));
  }

  @override
  List<Object?> get props => [
    $container,
    $indicator,
    $animation,
    $modifier,
    $variants,
  ];
}
