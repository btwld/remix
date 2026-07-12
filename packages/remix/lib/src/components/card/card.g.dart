// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixCardSpec implements Spec<RemixCardSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;

  @override
  Type get type => RemixCardSpec;

  @override
  RemixCardSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixCardSpec(container: container ?? this.container);
  }

  @override
  RemixCardSpec lerp(RemixCardSpec? other, double t) {
    return RemixCardSpec(container: container.lerp(other?.container, t));
  }

  @override
  List<Object?> get props => [container];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixCardSpec &&
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
  'Rename to `_\$RemixCardSpec` and migrate the class declaration to `class RemixCardSpec with _\$RemixCardSpec`. The `_\$RemixCardSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixCardSpecMethods = _$RemixCardSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed preset for [RemixCard].
class FortalCard extends StatelessWidget {
  const FortalCard({
    super.key,
    this.variant = .surface,
    this.size = .size2,
    this.child,
  });

  const FortalCard.surface({super.key, this.size = .size2, this.child})
    : variant = FortalCardVariant.surface;

  const FortalCard.classic({super.key, this.size = .size2, this.child})
    : variant = FortalCardVariant.classic;

  const FortalCard.ghost({super.key, this.size = .size2, this.child})
    : variant = FortalCardVariant.ghost;

  final FortalCardVariant variant;

  final FortalCardSize size;

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return fortalCardStyler(
      variant: this.variant,
      size: this.size,
    ).call(key: this.key, child: this.child);
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixCardStylerMixin on Style<RemixCardSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;

  /// Sets the container.
  RemixCardStyler container(BoxStyler value) {
    return merge(RemixCardStyler(container: value));
  }

  /// Sets the animation configuration.
  RemixCardStyler animate(AnimationConfig value) {
    return merge(RemixCardStyler(animation: value));
  }

  /// Sets the style variants.
  RemixCardStyler variants(List<VariantStyle<RemixCardSpec>> value) {
    return merge(RemixCardStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixCardStyler wrap(WidgetModifierConfig value) {
    return merge(RemixCardStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixCardStyler modifier(WidgetModifierConfig value) {
    return merge(RemixCardStyler(modifier: value));
  }

  /// Merges with another [RemixCardStyler].
  @override
  RemixCardStyler merge(RemixCardStyler? other) {
    return RemixCardStyler.create(
      container: MixOps.merge($container, other?.$container),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixCardSpec>] using [context].
  @override
  StyleSpec<RemixCardSpec> resolve(BuildContext context) {
    final spec = RemixCardSpec(container: MixOps.resolve(context, $container));

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
