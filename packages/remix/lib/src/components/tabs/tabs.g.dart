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
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed preset for [RemixTabBar].
class FortalTabBar extends StatelessWidget {
  const FortalTabBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return fortalTabBarStyler().call(key: this.key, child: this.child);
  }
}

/// Fortal-themed preset for [RemixTabView].
class FortalTabView extends StatelessWidget {
  const FortalTabView({super.key, required this.tabId, required this.child});

  final String tabId;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return fortalTabViewStyler().call(
      key: this.key,
      tabId: this.tabId,
      child: this.child,
    );
  }
}

/// Fortal-themed preset for [RemixTab].
class FortalTab extends StatelessWidget {
  const FortalTab({
    super.key,
    required this.tabId,
    this.child,
    this.label,
    this.icon,
    this.enabled = true,
    this.mouseCursor = SystemMouseCursors.click,
    this.enableFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.onFocusChange,
    this.onHoverChange,
    this.onPressChange,
    this.builder,
    this.semanticLabel,
  });

  final String tabId;

  final Widget? child;

  final String? label;

  final IconData? icon;

  final bool enabled;

  final MouseCursor mouseCursor;

  final bool enableFeedback;

  final FocusNode? focusNode;

  final bool autofocus;

  final ValueChanged<bool>? onFocusChange;

  final ValueChanged<bool>? onHoverChange;

  final ValueChanged<bool>? onPressChange;

  final ValueWidgetBuilder<NakedTabState>? builder;

  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return fortalTabStyler().call(
      key: this.key,
      tabId: this.tabId,
      child: this.child,
      label: this.label,
      icon: this.icon,
      enabled: this.enabled,
      mouseCursor: this.mouseCursor,
      enableFeedback: this.enableFeedback,
      focusNode: this.focusNode,
      autofocus: this.autofocus,
      onFocusChange: this.onFocusChange,
      onHoverChange: this.onHoverChange,
      onPressChange: this.onPressChange,
      builder: this.builder,
      semanticLabel: this.semanticLabel,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixTabBarStylerMixin on Style<RemixTabBarSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;

  /// Sets the container.
  RemixTabBarStyler container(FlexBoxStyler value) {
    return merge(RemixTabBarStyler(container: value));
  }

  /// Sets the animation configuration.
  RemixTabBarStyler animate(AnimationConfig value) {
    return merge(RemixTabBarStyler(animation: value));
  }

  /// Sets the style variants.
  RemixTabBarStyler variants(List<VariantStyle<RemixTabBarSpec>> value) {
    return merge(RemixTabBarStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTabBarStyler wrap(WidgetModifierConfig value) {
    return merge(RemixTabBarStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixTabBarStyler modifier(WidgetModifierConfig value) {
    return merge(RemixTabBarStyler(modifier: value));
  }

  /// Merges with another [RemixTabBarStyler].
  @override
  RemixTabBarStyler merge(RemixTabBarStyler? other) {
    return RemixTabBarStyler.create(
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

mixin _$RemixTabViewStylerMixin on Style<RemixTabViewSpec>, Diagnosticable {
  Prop<StyleSpec<BoxSpec>>? get $container;

  /// Sets the container.
  RemixTabViewStyler container(BoxStyler value) {
    return merge(RemixTabViewStyler(container: value));
  }

  /// Sets the animation configuration.
  RemixTabViewStyler animate(AnimationConfig value) {
    return merge(RemixTabViewStyler(animation: value));
  }

  /// Sets the style variants.
  RemixTabViewStyler variants(List<VariantStyle<RemixTabViewSpec>> value) {
    return merge(RemixTabViewStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTabViewStyler wrap(WidgetModifierConfig value) {
    return merge(RemixTabViewStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixTabViewStyler modifier(WidgetModifierConfig value) {
    return merge(RemixTabViewStyler(modifier: value));
  }

  /// Merges with another [RemixTabViewStyler].
  @override
  RemixTabViewStyler merge(RemixTabViewStyler? other) {
    return RemixTabViewStyler.create(
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

mixin _$RemixTabStylerMixin on Style<RemixTabSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $icon;

  /// Sets the container.
  RemixTabStyler container(FlexBoxStyler value) {
    return merge(RemixTabStyler(container: value));
  }

  /// Sets the label.
  RemixTabStyler label(TextStyler value) {
    return merge(RemixTabStyler(label: value));
  }

  /// Sets the icon.
  RemixTabStyler icon(IconStyler value) {
    return merge(RemixTabStyler(icon: value));
  }

  /// Sets the animation configuration.
  RemixTabStyler animate(AnimationConfig value) {
    return merge(RemixTabStyler(animation: value));
  }

  /// Sets the style variants.
  RemixTabStyler variants(List<VariantStyle<RemixTabSpec>> value) {
    return merge(RemixTabStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixTabStyler wrap(WidgetModifierConfig value) {
    return merge(RemixTabStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixTabStyler modifier(WidgetModifierConfig value) {
    return merge(RemixTabStyler(modifier: value));
  }

  /// Merges with another [RemixTabStyler].
  @override
  RemixTabStyler merge(RemixTabStyler? other) {
    return RemixTabStyler.create(
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
