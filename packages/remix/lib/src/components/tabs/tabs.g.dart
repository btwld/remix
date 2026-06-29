// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixTabBarSpec implements Spec<RemixTabBarSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;

  @override
  Type get type => RemixTabBarSpec;

  @override
  RemixTabBarSpec copyWith({StyleSpec<FlexBoxSpec>? container}) {
    return RemixTabBarSpec(container: container ?? this.container);
  }

  @override
  RemixTabBarSpec lerp(RemixTabBarSpec? other, double t) {
    return RemixTabBarSpec(container: container.lerp(other?.container, t));
  }

  @override
  List<Object?> get props => [container];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixTabBarSpec &&
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
  'Rename to `_\$RemixTabBarSpec` and migrate the class declaration to `class RemixTabBarSpec with _\$RemixTabBarSpec`. The `_\$RemixTabBarSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixTabBarSpecMethods = _$RemixTabBarSpec; // ignore: unused_element

mixin _$RemixTabSpec implements Spec<RemixTabSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixTabSpec;

  @override
  RemixTabSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixTabSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  @override
  RemixTabSpec lerp(RemixTabSpec? other, double t) {
    return RemixTabSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      icon: icon.lerp(other?.icon, t),
    );
  }

  @override
  List<Object?> get props => [container, label, icon];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixTabSpec &&
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
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }
}

@Deprecated(
  'Rename to `_\$RemixTabSpec` and migrate the class declaration to `class RemixTabSpec with _\$RemixTabSpec`. The `_\$RemixTabSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixTabSpecMethods = _$RemixTabSpec; // ignore: unused_element

mixin _$RemixTabViewSpec implements Spec<RemixTabViewSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;

  @override
  Type get type => RemixTabViewSpec;

  @override
  RemixTabViewSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixTabViewSpec(container: container ?? this.container);
  }

  @override
  RemixTabViewSpec lerp(RemixTabViewSpec? other, double t) {
    return RemixTabViewSpec(container: container.lerp(other?.container, t));
  }

  @override
  List<Object?> get props => [container];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixTabViewSpec &&
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
  'Rename to `_\$RemixTabViewSpec` and migrate the class declaration to `class RemixTabViewSpec with _\$RemixTabViewSpec`. The `_\$RemixTabViewSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixTabViewSpecMethods = _$RemixTabViewSpec; // ignore: unused_element

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixTabBarStyleMixin on Style<RemixTabBarSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;

  /// Sets the container.
  RemixTabBarStyle container(FlexBoxStyler value) {
    return merge(RemixTabBarStyle(container: value));
  }

  /// Sets the animation configuration.
  RemixTabBarStyle animate(AnimationConfig value) {
    return merge(RemixTabBarStyle(animation: value));
  }

  /// Sets the style variants.
  RemixTabBarStyle variants(List<VariantStyle<RemixTabBarSpec>> value) {
    return merge(RemixTabBarStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTabBarStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTabBarStyle(modifier: value));
  }

  /// Sets the widget modifier.
  RemixTabBarStyle modifier(WidgetModifierConfig value) {
    return merge(RemixTabBarStyle(modifier: value));
  }

  /// Merges with another [RemixTabBarStyle].
  @override
  RemixTabBarStyle merge(RemixTabBarStyle? other) {
    return RemixTabBarStyle.create(
      container: MixOps.merge($container, other?.$container),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixTabBarSpec>] using [context].
  @override
  StyleSpec<RemixTabBarSpec> resolve(BuildContext context) {
    final spec = RemixTabBarSpec(
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

mixin _$RemixTabViewStyleMixin on Style<RemixTabViewSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;

  /// Sets the container.
  RemixTabViewStyle container(BoxStyler value) {
    return merge(RemixTabViewStyle(container: value));
  }

  /// Sets the animation configuration.
  RemixTabViewStyle animate(AnimationConfig value) {
    return merge(RemixTabViewStyle(animation: value));
  }

  /// Sets the style variants.
  RemixTabViewStyle variants(List<VariantStyle<RemixTabViewSpec>> value) {
    return merge(RemixTabViewStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTabViewStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTabViewStyle(modifier: value));
  }

  /// Sets the widget modifier.
  RemixTabViewStyle modifier(WidgetModifierConfig value) {
    return merge(RemixTabViewStyle(modifier: value));
  }

  /// Merges with another [RemixTabViewStyle].
  @override
  RemixTabViewStyle merge(RemixTabViewStyle? other) {
    return RemixTabViewStyle.create(
      container: MixOps.merge($container, other?.$container),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixTabViewSpec>] using [context].
  @override
  StyleSpec<RemixTabViewSpec> resolve(BuildContext context) {
    final spec = RemixTabViewSpec(
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

mixin _$RemixTabStyleMixin on Style<RemixTabSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $icon;

  /// Sets the container.
  RemixTabStyle container(FlexBoxStyler value) {
    return merge(RemixTabStyle(container: value));
  }

  /// Sets the label.
  RemixTabStyle label(TextStyler value) {
    return merge(RemixTabStyle(label: value));
  }

  /// Sets the icon.
  RemixTabStyle icon(IconStyler value) {
    return merge(RemixTabStyle(icon: value));
  }

  /// Sets the animation configuration.
  RemixTabStyle animate(AnimationConfig value) {
    return merge(RemixTabStyle(animation: value));
  }

  /// Sets the style variants.
  RemixTabStyle variants(List<VariantStyle<RemixTabSpec>> value) {
    return merge(RemixTabStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTabStyle wrap(WidgetModifierConfig value) {
    return merge(RemixTabStyle(modifier: value));
  }

  /// Sets the widget modifier.
  RemixTabStyle modifier(WidgetModifierConfig value) {
    return merge(RemixTabStyle(modifier: value));
  }

  /// Merges with another [RemixTabStyle].
  @override
  RemixTabStyle merge(RemixTabStyle? other) {
    return RemixTabStyle.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixTabSpec>] using [context].
  @override
  StyleSpec<RemixTabSpec> resolve(BuildContext context) {
    final spec = RemixTabSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      icon: MixOps.resolve(context, $icon),
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
      ..add(DiagnosticsProperty('label', $label))
      ..add(DiagnosticsProperty('icon', $icon));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $icon,
    $animation,
    $modifier,
    $variants,
  ];
}
