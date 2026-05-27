// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divider.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixDividerSpec implements Spec<RemixDividerSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;

  @override
  Type get type => RemixDividerSpec;

  @override
  RemixDividerSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixDividerSpec(container: container ?? this.container);
  }

  @override
  RemixDividerSpec lerp(RemixDividerSpec? other, double t) {
    return RemixDividerSpec(container: container.lerp(other?.container, t));
  }

  @override
  List<Object?> get props => [container];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixDividerSpec &&
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
    properties..add(DiagnosticsProperty('container', container));
  }
}

@Deprecated(
  'Rename to `_\$RemixDividerSpec` and migrate the class declaration to `class RemixDividerSpec with _\$RemixDividerSpec`. The `_\$RemixDividerSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixDividerSpecMethods = _$RemixDividerSpec; // ignore: unused_element

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixDividerStyleMixin on Style<RemixDividerSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;

  /// Sets the container.
  RemixDividerStyle container(BoxStyler value) {
    return merge(RemixDividerStyle(container: value));
  }

  /// Sets the animation configuration.
  RemixDividerStyle animate(AnimationConfig value) {
    return merge(RemixDividerStyle(animation: value));
  }

  /// Sets the style variants.
  RemixDividerStyle variants(List<VariantStyle<RemixDividerSpec>> value) {
    return merge(RemixDividerStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixDividerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixDividerStyle(modifier: value));
  }

  /// Merges with another [RemixDividerStyle].
  @override
  RemixDividerStyle merge(RemixDividerStyle? other) {
    return RemixDividerStyle.create(
      container: MixOps.merge($container, other?.$container),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixDividerSpec>] using [context].
  @override
  StyleSpec<RemixDividerSpec> resolve(BuildContext context) {
    final spec = RemixDividerSpec(
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
    properties..add(DiagnosticsProperty('container', $container));
  }

  @override
  List<Object?> get props => [$container, $animation, $modifier, $variants];
}
