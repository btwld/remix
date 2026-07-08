// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixMenuTriggerSpec
    implements Spec<RemixMenuTriggerSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

  @override
  Type get type => RemixMenuTriggerSpec;

  @override
  RemixMenuTriggerSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return RemixMenuTriggerSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  @override
  RemixMenuTriggerSpec lerp(RemixMenuTriggerSpec? other, double t) {
    return RemixMenuTriggerSpec(
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
        other is RemixMenuTriggerSpec &&
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
  'Rename to `_\$RemixMenuTriggerSpec` and migrate the class declaration to `class RemixMenuTriggerSpec with _\$RemixMenuTriggerSpec`. The `_\$RemixMenuTriggerSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixMenuTriggerSpecMethods = _$RemixMenuTriggerSpec; // ignore: unused_element

mixin _$RemixMenuSpec implements Spec<RemixMenuSpec>, Diagnosticable {
  StyleSpec<RemixMenuTriggerSpec> get trigger;
  StyleSpec<FlexBoxSpec> get overlay;
  StyleSpec<RemixMenuItemSpec> get item;
  StyleSpec<RemixDividerSpec> get divider;

  @override
  Type get type => RemixMenuSpec;

  @override
  RemixMenuSpec copyWith({
    StyleSpec<RemixMenuTriggerSpec>? trigger,
    StyleSpec<FlexBoxSpec>? overlay,
    StyleSpec<RemixMenuItemSpec>? item,
    StyleSpec<RemixDividerSpec>? divider,
  }) {
    return RemixMenuSpec(
      trigger: trigger ?? this.trigger,
      overlay: overlay ?? this.overlay,
      item: item ?? this.item,
      divider: divider ?? this.divider,
    );
  }

  @override
  RemixMenuSpec lerp(RemixMenuSpec? other, double t) {
    return RemixMenuSpec(
      trigger: trigger.lerp(other?.trigger, t),
      overlay: overlay.lerp(other?.overlay, t),
      item: item.lerp(other?.item, t),
      divider: divider.lerp(other?.divider, t),
    );
  }

  @override
  List<Object?> get props => [trigger, overlay, item, divider];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixMenuSpec &&
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
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('overlay', overlay))
      ..add(DiagnosticsProperty('item', item))
      ..add(DiagnosticsProperty('divider', divider));
  }
}

@Deprecated(
  'Rename to `_\$RemixMenuSpec` and migrate the class declaration to `class RemixMenuSpec with _\$RemixMenuSpec`. The `_\$RemixMenuSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixMenuSpecMethods = _$RemixMenuSpec; // ignore: unused_element

mixin _$RemixMenuItemSpec implements Spec<RemixMenuItemSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get leadingIcon;
  StyleSpec<IconSpec> get trailingIcon;

  @override
  Type get type => RemixMenuItemSpec;

  @override
  RemixMenuItemSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<IconSpec>? trailingIcon,
  }) {
    return RemixMenuItemSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      leadingIcon: leadingIcon ?? this.leadingIcon,
      trailingIcon: trailingIcon ?? this.trailingIcon,
    );
  }

  @override
  RemixMenuItemSpec lerp(RemixMenuItemSpec? other, double t) {
    return RemixMenuItemSpec(
      container: container.lerp(other?.container, t),
      label: label.lerp(other?.label, t),
      leadingIcon: leadingIcon.lerp(other?.leadingIcon, t),
      trailingIcon: trailingIcon.lerp(other?.trailingIcon, t),
    );
  }

  @override
  List<Object?> get props => [container, label, leadingIcon, trailingIcon];

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is RemixMenuItemSpec &&
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
      ..add(DiagnosticsProperty('leadingIcon', leadingIcon))
      ..add(DiagnosticsProperty('trailingIcon', trailingIcon));
  }
}

@Deprecated(
  'Rename to `_\$RemixMenuItemSpec` and migrate the class declaration to `class RemixMenuItemSpec with _\$RemixMenuItemSpec`. The `_\$RemixMenuItemSpecMethods` alias will be removed in mix_generator 3.0.',
)
typedef _$RemixMenuItemSpecMethods = _$RemixMenuItemSpec; // ignore: unused_element

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixMenuTriggerStylerMixin
    on Style<RemixMenuTriggerSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $icon;

  /// Sets the container.
  RemixMenuTriggerStyler container(FlexBoxStyler value) {
    return merge(RemixMenuTriggerStyler(container: value));
  }

  /// Sets the label.
  RemixMenuTriggerStyler label(TextStyler value) {
    return merge(RemixMenuTriggerStyler(label: value));
  }

  /// Sets the icon.
  RemixMenuTriggerStyler icon(IconStyler value) {
    return merge(RemixMenuTriggerStyler(icon: value));
  }

  /// Sets the animation configuration.
  RemixMenuTriggerStyler animate(AnimationConfig value) {
    return merge(RemixMenuTriggerStyler(animation: value));
  }

  /// Sets the style variants.
  RemixMenuTriggerStyler variants(
    List<VariantStyle<RemixMenuTriggerSpec>> value,
  ) {
    return merge(RemixMenuTriggerStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixMenuTriggerStyler wrap(WidgetModifierConfig value) {
    return merge(RemixMenuTriggerStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixMenuTriggerStyler modifier(WidgetModifierConfig value) {
    return merge(RemixMenuTriggerStyler(modifier: value));
  }

  /// Merges with another [RemixMenuTriggerStyler].
  @override
  RemixMenuTriggerStyler merge(RemixMenuTriggerStyler? other) {
    return RemixMenuTriggerStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      icon: MixOps.merge($icon, other?.$icon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixMenuTriggerSpec>] using [context].
  @override
  StyleSpec<RemixMenuTriggerSpec> resolve(BuildContext context) {
    final spec = RemixMenuTriggerSpec(
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

mixin _$RemixMenuStylerMixin on Style<RemixMenuSpec>, Diagnosticable {
  Prop<StyleSpec<RemixMenuTriggerSpec>>? get $trigger;
  Prop<StyleSpec<FlexBoxSpec>>? get $overlay;
  Prop<StyleSpec<RemixMenuItemSpec>>? get $item;
  Prop<StyleSpec<RemixDividerSpec>>? get $divider;

  /// Sets the trigger.
  RemixMenuStyler trigger(RemixMenuTriggerStyler value) {
    return merge(RemixMenuStyler(trigger: value));
  }

  /// Sets the overlay.
  RemixMenuStyler overlay(FlexBoxStyler value) {
    return merge(RemixMenuStyler(overlay: value));
  }

  /// Sets the item.
  RemixMenuStyler item(RemixMenuItemStyler value) {
    return merge(RemixMenuStyler(item: value));
  }

  /// Sets the divider.
  RemixMenuStyler divider(RemixDividerStyler value) {
    return merge(RemixMenuStyler(divider: value));
  }

  /// Sets the animation configuration.
  RemixMenuStyler animate(AnimationConfig value) {
    return merge(RemixMenuStyler(animation: value));
  }

  /// Sets the style variants.
  RemixMenuStyler variants(List<VariantStyle<RemixMenuSpec>> value) {
    return merge(RemixMenuStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixMenuStyler wrap(WidgetModifierConfig value) {
    return merge(RemixMenuStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixMenuStyler modifier(WidgetModifierConfig value) {
    return merge(RemixMenuStyler(modifier: value));
  }

  /// Merges with another [RemixMenuStyler].
  @override
  RemixMenuStyler merge(RemixMenuStyler? other) {
    return RemixMenuStyler.create(
      trigger: MixOps.merge($trigger, other?.$trigger),
      overlay: MixOps.merge($overlay, other?.$overlay),
      item: MixOps.merge($item, other?.$item),
      divider: MixOps.merge($divider, other?.$divider),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixMenuSpec>] using [context].
  @override
  StyleSpec<RemixMenuSpec> resolve(BuildContext context) {
    final spec = RemixMenuSpec(
      trigger: MixOps.resolve(context, $trigger),
      overlay: MixOps.resolve(context, $overlay),
      item: MixOps.resolve(context, $item),
      divider: MixOps.resolve(context, $divider),
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
      ..add(DiagnosticsProperty('trigger', $trigger))
      ..add(DiagnosticsProperty('overlay', $overlay))
      ..add(DiagnosticsProperty('item', $item))
      ..add(DiagnosticsProperty('divider', $divider));
  }

  @override
  List<Object?> get props => [
    $trigger,
    $overlay,
    $item,
    $divider,
    $animation,
    $modifier,
    $variants,
  ];
}

mixin _$RemixMenuItemStylerMixin on Style<RemixMenuItemSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $leadingIcon;
  Prop<StyleSpec<IconSpec>>? get $trailingIcon;

  /// Sets the container.
  RemixMenuItemStyler container(FlexBoxStyler value) {
    return merge(RemixMenuItemStyler(container: value));
  }

  /// Sets the label.
  RemixMenuItemStyler label(TextStyler value) {
    return merge(RemixMenuItemStyler(label: value));
  }

  /// Sets the leadingIcon.
  RemixMenuItemStyler leadingIcon(IconStyler value) {
    return merge(RemixMenuItemStyler(leadingIcon: value));
  }

  /// Sets the trailingIcon.
  RemixMenuItemStyler trailingIcon(IconStyler value) {
    return merge(RemixMenuItemStyler(trailingIcon: value));
  }

  /// Sets the animation configuration.
  RemixMenuItemStyler animate(AnimationConfig value) {
    return merge(RemixMenuItemStyler(animation: value));
  }

  /// Sets the style variants.
  RemixMenuItemStyler variants(List<VariantStyle<RemixMenuItemSpec>> value) {
    return merge(RemixMenuItemStyler(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixMenuItemStyler wrap(WidgetModifierConfig value) {
    return merge(RemixMenuItemStyler(modifier: value));
  }

  /// Sets the widget modifier.
  RemixMenuItemStyler modifier(WidgetModifierConfig value) {
    return merge(RemixMenuItemStyler(modifier: value));
  }

  /// Merges with another [RemixMenuItemStyler].
  @override
  RemixMenuItemStyler merge(RemixMenuItemStyler? other) {
    return RemixMenuItemStyler.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      leadingIcon: MixOps.merge($leadingIcon, other?.$leadingIcon),
      trailingIcon: MixOps.merge($trailingIcon, other?.$trailingIcon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixMenuItemSpec>] using [context].
  @override
  StyleSpec<RemixMenuItemSpec> resolve(BuildContext context) {
    final spec = RemixMenuItemSpec(
      container: MixOps.resolve(context, $container),
      label: MixOps.resolve(context, $label),
      leadingIcon: MixOps.resolve(context, $leadingIcon),
      trailingIcon: MixOps.resolve(context, $trailingIcon),
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
      ..add(DiagnosticsProperty('leadingIcon', $leadingIcon))
      ..add(DiagnosticsProperty('trailingIcon', $trailingIcon));
  }

  @override
  List<Object?> get props => [
    $container,
    $label,
    $leadingIcon,
    $trailingIcon,
    $animation,
    $modifier,
    $variants,
  ];
}
