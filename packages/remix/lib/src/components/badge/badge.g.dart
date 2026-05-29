// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'badge.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixBadgeSpec implements Spec<RemixBadgeSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;
  StyleSpec<TextSpec> get text;

  @override
  Type get type => RemixBadgeSpec;

  @override
  RemixBadgeSpec copyWith({
    StyleSpec<BoxSpec>? container,
    StyleSpec<TextSpec>? text,
  }) {
    return RemixBadgeSpec(
      container: container ?? this.container,
      text: text ?? this.text,
    );
  }

  @override
  RemixBadgeSpec lerp(RemixBadgeSpec? other, double t) {
    return RemixBadgeSpec(
      container: container.lerp(other?.container, t),
      text: text.lerp(other?.text, t),
    );
  }

  @override
  List<Object?> get props => [container, text];

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
      ..add(DiagnosticsProperty('text', text));
  }
}

@Deprecated(
  'Rename to `_\$RemixBadgeSpec` and migrate the class declaration to `class RemixBadgeSpec with _\$RemixBadgeSpec`. The `_\$RemixBadgeSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixBadgeSpecMethods = _$RemixBadgeSpec; // ignore: unused_element

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixBadgeStyleMixin on Style<RemixBadgeSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $text;

  /// Sets the container.
  RemixBadgeStyle container(BoxStyler value) {
    return merge(RemixBadgeStyle(container: value));
  }

  /// Sets the text.
  RemixBadgeStyle text(TextStyler value) {
    return merge(RemixBadgeStyle(text: value));
  }

  /// Sets the animation configuration.
  RemixBadgeStyle animate(AnimationConfig value) {
    return merge(RemixBadgeStyle(animation: value));
  }

  /// Sets the style variants.
  RemixBadgeStyle variants(List<VariantStyle<RemixBadgeSpec>> value) {
    return merge(RemixBadgeStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixBadgeStyle wrap(WidgetModifierConfig value) {
    return merge(RemixBadgeStyle(modifier: value));
  }

  /// Sets the widget modifier.
  RemixBadgeStyle modifier(WidgetModifierConfig value) {
    return merge(RemixBadgeStyle(modifier: value));
  }

  /// Merges with another [RemixBadgeStyle].
  @override
  RemixBadgeStyle merge(RemixBadgeStyle? other) {
    return RemixBadgeStyle.create(
      container: MixOps.merge($container, other?.$container),
      text: MixOps.merge($text, other?.$text),
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
      text: MixOps.resolve(context, $text),
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
      ..add(DiagnosticsProperty('text', $text));
  }

  @override
  List<Object?> get props => [
    $container,
    $text,
    $animation,
    $modifier,
    $variants,
  ];
}
