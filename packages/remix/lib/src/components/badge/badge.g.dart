// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixBadgeSpec implements Spec<RemixBadgeSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get label;

  @override
  Type get type => RemixBadgeSpec;

  @override
  RemixBadgeSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? label,
  }) {
    return RemixBadgeSpec(
      container: container ?? this.container,
      label: label ?? this.label,
    );
  }

  @override
  RemixBadgeSpec lerp(RemixBadgeSpec? other, double t) {
    return RemixBadgeSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
    );
  }

  @override
  List<Object?> get props => [container, label];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixBadgeSpec &&
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
  'Rename to `_\$RemixBadgeSpec` and migrate the class declaration to `class RemixBadgeSpec with _\$RemixBadgeSpec`. The `_\$RemixBadgeSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixBadgeSpecMethods = _$RemixBadgeSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed preset for [RemixBadge].
class FortalBadge extends StatelessWidget {
  const FortalBadge({
    super.key,
    this.variant = .solid,
    this.size = .size2,
    this.label,
    this.child,
    this.labelBuilder,
  });

  const FortalBadge.solid({
    super.key,
    this.size = .size2,
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = FortalBadgeVariant.solid;

  const FortalBadge.soft({
    super.key,
    this.size = .size2,
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = FortalBadgeVariant.soft;

  const FortalBadge.surface({
    super.key,
    this.size = .size2,
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = FortalBadgeVariant.surface;

  const FortalBadge.outline({
    super.key,
    this.size = .size2,
    this.label,
    this.child,
    this.labelBuilder,
  }) : variant = FortalBadgeVariant.outline;

  final FortalBadgeVariant variant;

  final FortalBadgeSize size;

  final String? label;

  final Widget? child;

  final RemixBadgeLabelBuilder? labelBuilder;

  @override
  Widget build(BuildContext context) {
    return fortalBadgeStyler(variant: this.variant, size: this.size).call(
      key: this.key,
      label: this.label,
      child: this.child,
      labelBuilder: this.labelBuilder,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixBadgeStylerMixin on Style<RemixBadgeSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;

  /// Sets the container.
  RemixBadgeStyler container(BoxStyler value) {
    return merge(RemixBadgeStyler(container: value));
  }

  /// Sets the label.
  RemixBadgeStyler label(TextStyler value) {
    return merge(RemixBadgeStyler(label: value));
  }

  /// Sets the animation configuration.
  RemixBadgeStyler animate(AnimationConfig value) {
    return merge(RemixBadgeStyler(animation: value));
  }

  /// Sets the style variants.
  RemixBadgeStyler variants(List<VariantStyle<RemixBadgeSpec>> value) {
    return merge(RemixBadgeStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixBadgeStyler wrap(WidgetModifierConfig value) {
    return merge(RemixBadgeStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixBadgeStyler modifier(WidgetModifierConfig value) {
    return merge(RemixBadgeStyler(modifier: value));
  }

  /// Merges with another [RemixBadgeStyler].
  @override
  RemixBadgeStyler merge(RemixBadgeStyler? other) {
    return RemixBadgeStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixBadgeSpec>] using [context].
  @override
  StyleSpec<RemixBadgeSpec> resolve(BuildContext context) {
    final spec = RemixBadgeSpec(
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
