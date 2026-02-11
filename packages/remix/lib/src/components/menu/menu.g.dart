// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu.dart';

// **************************************************************************
// SpecGenerator
// **************************************************************************

mixin _$RemixMenuTriggerSpecMethods
    on Spec<RemixMenuTriggerSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get icon;

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

mixin _$RemixMenuSpecMethods on Spec<RemixMenuSpec>, Diagnosticable {
  StyleSpec<RemixMenuTriggerSpec> get trigger;
  StyleSpec<FlexBoxSpec> get overlay;
  StyleSpec<RemixMenuItemSpec> get item;
  StyleSpec<RemixDividerSpec> get divider;

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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('trigger', trigger))
      ..add(DiagnosticsProperty('overlay', overlay))
      ..add(DiagnosticsProperty('item', item))
      ..add(DiagnosticsProperty('divider', divider));
  }

  @override
  List<Object?> get props => [trigger, overlay, item, divider];
}

mixin _$RemixMenuItemSpecMethods on Spec<RemixMenuItemSpec>, Diagnosticable {
  StyleSpec<FlexBoxSpec> get container;
  StyleSpec<TextSpec> get label;
  StyleSpec<IconSpec> get leadingIcon;
  StyleSpec<IconSpec> get trailingIcon;

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
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('label', label))
      ..add(DiagnosticsProperty('leadingIcon', leadingIcon))
      ..add(DiagnosticsProperty('trailingIcon', trailingIcon));
  }

  @override
  List<Object?> get props => [container, label, leadingIcon, trailingIcon];
}

// **************************************************************************
// StylerGenerator
// **************************************************************************

mixin _$RemixMenuTriggerStyleMixin
    on Style<RemixMenuTriggerSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<IconSpec>>? get $icon;
  Prop<StyleSpec<TextSpec>>? get $label;

  /// Sets the container.
  RemixMenuTriggerStyle container(FlexBoxStyler value) {
    return merge(RemixMenuTriggerStyle(container: value));
  }

  /// Sets the icon.
  RemixMenuTriggerStyle icon(IconStyler value) {
    return merge(RemixMenuTriggerStyle(icon: value));
  }

  /// Sets the label.
  RemixMenuTriggerStyle label(TextStyler value) {
    return merge(RemixMenuTriggerStyle(label: value));
  }

  /// Sets the animation configuration.
  RemixMenuTriggerStyle animate(AnimationConfig value) {
    return merge(RemixMenuTriggerStyle(animation: value));
  }

  /// Sets the style variants.
  RemixMenuTriggerStyle variants(
    List<VariantStyle<RemixMenuTriggerSpec>> value,
  ) {
    return merge(RemixMenuTriggerStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixMenuTriggerStyle wrap(WidgetModifierConfig value) {
    return merge(RemixMenuTriggerStyle(modifier: value));
  }

  /// Merges with another [RemixMenuTriggerStyle].
  @override
  RemixMenuTriggerStyle merge(RemixMenuTriggerStyle? other) {
    return RemixMenuTriggerStyle.create(
      container: MixOps.merge($container, other?.$container),
      icon: MixOps.merge($icon, other?.$icon),
      label: MixOps.merge($label, other?.$label),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixMenuTriggerSpec>] using context.
  @override
  StyleSpec<RemixMenuTriggerSpec> resolve(BuildContext context) {
    final spec = RemixMenuTriggerSpec(
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

mixin _$RemixMenuStyleMixin on Style<RemixMenuSpec>, Diagnosticable {
  Prop<StyleSpec<RemixDividerSpec>>? get $divider;
  Prop<StyleSpec<RemixMenuItemSpec>>? get $item;
  Prop<StyleSpec<FlexBoxSpec>>? get $overlay;
  Prop<StyleSpec<RemixMenuTriggerSpec>>? get $trigger;

  /// Sets the divider.
  RemixMenuStyle divider(RemixDividerStyle value) {
    return merge(RemixMenuStyle(divider: value));
  }

  /// Sets the item.
  RemixMenuStyle item(RemixMenuItemStyle value) {
    return merge(RemixMenuStyle(item: value));
  }

  /// Sets the overlay.
  RemixMenuStyle overlay(FlexBoxStyler value) {
    return merge(RemixMenuStyle(overlay: value));
  }

  /// Sets the trigger.
  RemixMenuStyle trigger(RemixMenuTriggerStyle value) {
    return merge(RemixMenuStyle(trigger: value));
  }

  /// Sets the animation configuration.
  RemixMenuStyle animate(AnimationConfig value) {
    return merge(RemixMenuStyle(animation: value));
  }

  /// Sets the style variants.
  RemixMenuStyle variants(List<VariantStyle<RemixMenuSpec>> value) {
    return merge(RemixMenuStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixMenuStyle wrap(WidgetModifierConfig value) {
    return merge(RemixMenuStyle(modifier: value));
  }

  /// Merges with another [RemixMenuStyle].
  @override
  RemixMenuStyle merge(RemixMenuStyle? other) {
    return RemixMenuStyle.create(
      divider: MixOps.merge($divider, other?.$divider),
      item: MixOps.merge($item, other?.$item),
      overlay: MixOps.merge($overlay, other?.$overlay),
      trigger: MixOps.merge($trigger, other?.$trigger),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixMenuSpec>] using context.
  @override
  StyleSpec<RemixMenuSpec> resolve(BuildContext context) {
    final spec = RemixMenuSpec(
      divider: MixOps.resolve(context, $divider),
      item: MixOps.resolve(context, $item),
      overlay: MixOps.resolve(context, $overlay),
      trigger: MixOps.resolve(context, $trigger),
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
      ..add(DiagnosticsProperty('divider', $divider))
      ..add(DiagnosticsProperty('item', $item))
      ..add(DiagnosticsProperty('overlay', $overlay))
      ..add(DiagnosticsProperty('trigger', $trigger));
  }

  @override
  List<Object?> get props => [
    $divider,
    $item,
    $overlay,
    $trigger,
    $animation,
    $modifier,
    $variants,
  ];
}

mixin _$RemixMenuItemStyleMixin on Style<RemixMenuItemSpec>, Diagnosticable {
  Prop<StyleSpec<FlexBoxSpec>>? get $container;
  Prop<StyleSpec<TextSpec>>? get $label;
  Prop<StyleSpec<IconSpec>>? get $leadingIcon;
  Prop<StyleSpec<IconSpec>>? get $trailingIcon;

  /// Sets the container.
  RemixMenuItemStyle container(FlexBoxStyler value) {
    return merge(RemixMenuItemStyle(container: value));
  }

  /// Sets the label.
  RemixMenuItemStyle label(TextStyler value) {
    return merge(RemixMenuItemStyle(label: value));
  }

  /// Sets the leadingIcon.
  RemixMenuItemStyle leadingIcon(IconStyler value) {
    return merge(RemixMenuItemStyle(leadingIcon: value));
  }

  /// Sets the trailingIcon.
  RemixMenuItemStyle trailingIcon(IconStyler value) {
    return merge(RemixMenuItemStyle(trailingIcon: value));
  }

  /// Sets the animation configuration.
  RemixMenuItemStyle animate(AnimationConfig value) {
    return merge(RemixMenuItemStyle(animation: value));
  }

  /// Sets the style variants.
  RemixMenuItemStyle variants(List<VariantStyle<RemixMenuItemSpec>> value) {
    return merge(RemixMenuItemStyle(variants: value));
  }

  /// Wraps with a widget modifier.
  RemixMenuItemStyle wrap(WidgetModifierConfig value) {
    return merge(RemixMenuItemStyle(modifier: value));
  }

  /// Merges with another [RemixMenuItemStyle].
  @override
  RemixMenuItemStyle merge(RemixMenuItemStyle? other) {
    return RemixMenuItemStyle.create(
      container: MixOps.merge($container, other?.$container),
      label: MixOps.merge($label, other?.$label),
      leadingIcon: MixOps.merge($leadingIcon, other?.$leadingIcon),
      trailingIcon: MixOps.merge($trailingIcon, other?.$trailingIcon),
      variants: MixOps.mergeVariants($variants, other?.$variants),
      modifier: MixOps.mergeModifier($modifier, other?.$modifier),
      animation: MixOps.mergeAnimation($animation, other?.$animation),
    );
  }

  /// Resolves to [StyleSpec<RemixMenuItemSpec>] using context.
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
