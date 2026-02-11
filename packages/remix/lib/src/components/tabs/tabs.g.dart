// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tabs.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixTabBarSpecMethods on Spec<RemixTabBarSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;

  @override
  RemixTabBarSpec copyWith({StyleSpec<FlexBoxSpec>? container}) {
    return RemixTabBarSpec(container: container ?? this.container);
  }

  @override
  RemixTabBarSpec lerp(RemixTabBarSpec? other, double t) {
    return RemixTabBarSpec(container: container.lerp(other?.container, t));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}

mixin _$RemixTabSpecMethods on Spec<RemixTabSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('icon', icon));
  }

  @override
  List<Object?> get props => [container, label, icon];
}

mixin _$RemixTabViewSpecMethods on Spec<RemixTabViewSpec>, Diagnosticable {
  StyleSpec<BoxSpec> get container;

  @override
  RemixTabViewSpec copyWith({StyleSpec<BoxSpec>? container}) {
    return RemixTabViewSpec(container: container ?? this.container);
  }

  @override
  RemixTabViewSpec lerp(RemixTabViewSpec? other, double t) {
    return RemixTabViewSpec(container: container.lerp(other?.container, t));
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties..add(DiagnosticsProperty('container', container));
  }

  @override
  List<Object?> get props => [container];
}

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

  /// Resolves to [StyleSpec<RemixTabBarSpec>] using context.
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
    properties..add(DiagnosticsProperty('container', $container));
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

  /// Resolves to [StyleSpec<RemixTabViewSpec>] using context.
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
    properties..add(DiagnosticsProperty('container', $container));
  }

  @override
  List<Object?> get props => [$container, $animation, $modifier, $variants];
}

mixin _$RemixTabStyleMixin on Style<RemixTabSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<TextSpec>>? get $label;

  /// Sets the container.
  RemixTabStyle container(FlexBoxStyler value) {
    return merge(RemixTabStyle(container: value));
  }

  /// Sets the icon.
  RemixTabStyle icon(IconStyler value) {
    return merge(RemixTabStyle(icon: value));
  }

  /// Sets the label.
  RemixTabStyle label(TextStyler value) {
    return merge(RemixTabStyle(label: value));
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

  /// Merges with another [RemixTabStyle].
  @override
  RemixTabStyle merge(RemixTabStyle? other) {
    return RemixTabStyle.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      label: MixOps.merge($label, other?.$label),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixTabSpec>] using context.
  @override
  StyleSpec<RemixTabSpec> resolve(BuildContext context) {
    final spec = RemixTabSpec(
      container: MixOps.resolve(context, $container),
      icon: MixOps.resolve(context, $icon),
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
      ..add(DiagnosticsProperty('icon', $icon))
      ..add(DiagnosticsProperty('label', $label));
  }

  @override
  List<Object?> get props => [
    $container,
    $icon,
    $label,
    $animation,
    $modifier,
    $variants,
  ];
}
