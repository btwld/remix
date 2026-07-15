// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toggle_group.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixToggleGroupSpec
    implements Spec<RemixToggleGroupSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<RemixToggleGroupItemSpec> get item;

  @override
  Type get type => RemixToggleGroupSpec;

  @override
  RemixToggleGroupSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<RemixToggleGroupItemSpec>? item,
  }) {
    return RemixToggleGroupSpec(
      container: container ?? this.container,
      item: item ?? this.item,
    );
  }

  @override
  RemixToggleGroupSpec lerp(RemixToggleGroupSpec? other, double t) {
    return RemixToggleGroupSpec(
      container: container.lerp(other?.container, t),
      item: item.lerp(other?.item, t),
    );
  }

  @override
  List<Object?> get props => [container, item];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixToggleGroupSpec &&
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
      ..add(DiagnosticsProperty('item', item));
  }
}

@Deprecated(
  'Rename to `_\$RemixToggleGroupSpec` and migrate the class declaration to `class RemixToggleGroupSpec with _\$RemixToggleGroupSpec`. The `_\$RemixToggleGroupSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixToggleGroupSpecMethods = _$RemixToggleGroupSpec; // ignore: unused_element

mixin _$RemixToggleGroupItemSpec
    implements Spec<RemixToggleGroupItemSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixToggleGroupItemSpec;

  @override
  RemixToggleGroupItemSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixToggleGroupItemSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  @override
  RemixToggleGroupItemSpec lerp(RemixToggleGroupItemSpec? other, double t) {
    return RemixToggleGroupItemSpec(
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
        other is RemixToggleGroupItemSpec &&
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
  'Rename to `_\$RemixToggleGroupItemSpec` and migrate the class declaration to `class RemixToggleGroupItemSpec with _\$RemixToggleGroupItemSpec`. The `_\$RemixToggleGroupItemSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixToggleGroupItemSpecMethods = _$RemixToggleGroupItemSpec; // ignore: unused_element

// **************************************************************************
// MixWidgetGenerator
// **************************************************************************

/// Fortal-themed segmented-control preset for [RemixToggleGroup].
class FortalToggleGroup<T> extends StatelessWidget {
  const FortalToggleGroup({
    super.key,
    this.variant = .soft,
    this.size = .size2,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  });

  const FortalToggleGroup.soft({
    super.key,
    this.size = .size2,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = FortalToggleGroupVariant.soft;

  const FortalToggleGroup.surface({
    super.key,
    this.size = .size2,
    required this.items,
    required this.selectedValue,
    this.onChanged,
    this.enabled = true,
    this.orientation = .horizontal,
    this.loop = true,
    this.semanticLabel,
    this.excludeSemantics = false,
  }) : variant = FortalToggleGroupVariant.surface;

  final FortalToggleGroupVariant variant;

  final FortalToggleGroupSize size;

  final List<RemixToggleGroupItem<T>> items;

  final T? selectedValue;

  final ValueChanged<T?>? onChanged;

  final bool enabled;

  final Axis orientation;

  final bool loop;

  final String? semanticLabel;

  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return fortalToggleGroupStyler(
      variant: this.variant,
      size: this.size,
    ).call<T>(
      key: this.key,
      items: this.items,
      selectedValue: this.selectedValue,
      onChanged: this.onChanged,
      enabled: this.enabled,
      orientation: this.orientation,
      loop: this.loop,
      semanticLabel: this.semanticLabel,
      excludeSemantics: this.excludeSemantics,
    );
  }
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixToggleGroupStylerMixin
    on Style<RemixToggleGroupSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<RemixToggleGroupItemSpec>>? get $item;

  /// Sets the container.
  RemixToggleGroupStyler container(FlexBoxStyler value) {
    return merge(RemixToggleGroupStyler(container: value));
  }

  /// Sets the item.
  RemixToggleGroupStyler item(RemixToggleGroupItemStyler value) {
    return merge(RemixToggleGroupStyler(item: value));
  }

  /// Sets the animation configuration.
  RemixToggleGroupStyler animate(AnimationConfig value) {
    return merge(RemixToggleGroupStyler(animation: value));
  }

  /// Sets the style variants.
  RemixToggleGroupStyler variants(
    List<VariantStyle<RemixToggleGroupSpec>> value,
  ) {
    return merge(RemixToggleGroupStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixToggleGroupStyler wrap(WidgetModifierConfig value) {
    return merge(RemixToggleGroupStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixToggleGroupStyler modifier(WidgetModifierConfig value) {
    return merge(RemixToggleGroupStyler(modifier: value));
  }

  /// Merges with another [RemixToggleGroupStyler].
  @override
  RemixToggleGroupStyler merge(RemixToggleGroupStyler? other) {
    return RemixToggleGroupStyler.create(
      container: MixOps.merge($container, other?.$container),
      item: MixOps.merge($item, other?.$item),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixToggleGroupSpec>] using [context].
  @override
  StyleSpec<RemixToggleGroupSpec> resolve(BuildContext context) {
    final spec = RemixToggleGroupSpec(
      container: MixOps.resolve(context, $container),
      item: MixOps.resolve(context, $item),
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
      ..add(DiagnosticsProperty('item', $item));
  }

  @override
  List<Object?> get props => [
    $container,
    $item,
    $animation,
    $modifier,
    $variants,
  ];
}

mixin _$RemixToggleGroupItemStylerMixin
    on Style<RemixToggleGroupItemSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $icon;

  /// Sets the container.
  RemixToggleGroupItemStyler container(FlexBoxStyler value) {
    return merge(RemixToggleGroupItemStyler(container: value));
  }

  /// Sets the label.
  RemixToggleGroupItemStyler label(TextStyler value) {
    return merge(RemixToggleGroupItemStyler(label: value));
  }

  /// Sets the icon.
  RemixToggleGroupItemStyler icon(IconStyler value) {
    return merge(RemixToggleGroupItemStyler(icon: value));
  }

  /// Sets the animation configuration.
  RemixToggleGroupItemStyler animate(AnimationConfig value) {
    return merge(RemixToggleGroupItemStyler(animation: value));
  }

  /// Sets the style variants.
  RemixToggleGroupItemStyler variants(
    List<VariantStyle<RemixToggleGroupItemSpec>> value,
  ) {
    return merge(RemixToggleGroupItemStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixToggleGroupItemStyler wrap(WidgetModifierConfig value) {
    return merge(RemixToggleGroupItemStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixToggleGroupItemStyler modifier(WidgetModifierConfig value) {
    return merge(RemixToggleGroupItemStyler(modifier: value));
  }

  /// Merges with another [RemixToggleGroupItemStyler].
  @override
  RemixToggleGroupItemStyler merge(RemixToggleGroupItemStyler? other) {
    return RemixToggleGroupItemStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixToggleGroupItemSpec>] using [context].
  @override
  StyleSpec<RemixToggleGroupItemSpec> resolve(BuildContext context) {
    final spec = RemixToggleGroupItemSpec(
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
