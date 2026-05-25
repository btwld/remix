// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'callout.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixCalloutSpec implements Spec<RemixCalloutSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get text;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixCalloutSpec;

  @override
  RemixCalloutSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? text,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixCalloutSpec(
      container: container ?? this.container,
      text: text ?? this.text,
      icon: icon ?? this.icon,
    );
  }

  @override
  RemixCalloutSpec lerp(RemixCalloutSpec? other, double t) {
    return RemixCalloutSpec(
      container: container.lerp(other?.container, t),
      text: text.lerp(other?.text, t),
      icon: icon.lerp(other?.icon, t),
    );
  }

  @override
  List<Object?> get props => [container, text, icon];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixCalloutSpec &&
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
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('icon', icon));
  }
}

@Deprecated(
  'Rename to `_\$RemixCalloutSpec` and migrate the class declaration to `class RemixCalloutSpec with _\$RemixCalloutSpec`. The `_\$RemixCalloutSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixCalloutSpecMethods = _$RemixCalloutSpec; // ignore: unused_element

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixCalloutStyleMixin on Style<RemixCalloutSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<TextSpec>>? get $text;

  /// Sets the container.
  RemixCalloutStyle container(FlexBoxStyler value) {
    return merge(RemixCalloutStyle(container: value));
  }

  /// Sets the icon.
  RemixCalloutStyle icon(IconStyler value) {
    return merge(RemixCalloutStyle(icon: value));
  }

  /// Sets the text.
  RemixCalloutStyle text(TextStyler value) {
    return merge(RemixCalloutStyle(text: value));
  }

  /// Sets the animation configuration.
  RemixCalloutStyle animate(AnimationConfig value) {
    return merge(RemixCalloutStyle(animation: value));
  }

  /// Sets the style variants.
  RemixCalloutStyle variants(List<VariantStyle<RemixCalloutSpec>> value) {
    return merge(RemixCalloutStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixCalloutStyle wrap(WidgetModifierConfig value) {
    return merge(RemixCalloutStyle(modifier: value));
  }

  /// Merges with another [RemixCalloutStyle].
  @override
  RemixCalloutStyle merge(RemixCalloutStyle? other) {
    return RemixCalloutStyle.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      text: MixOps.merge($text, other?.$text),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixCalloutSpec>] using context.
  @override
  StyleSpec<RemixCalloutSpec> resolve(BuildContext context) {
    final spec = RemixCalloutSpec(
      container: MixOps.resolve(context, $container),
      icon: MixOps.resolve(context, $icon),
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
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('text', $text));
  }

  @override
  List<Object?> get props => [
    $container,
    $icon,
    $text,
    $animation,
    $modifier,
    $variants,
  ];
}
