part of 'menu.dart';

// ============================================================================
// TRIGGER SPEC - Menu trigger content specification
// ============================================================================

class RemixMenuTriggerSpec extends Spec<RemixMenuTriggerSpec>
    with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> icon;

  const RemixMenuTriggerSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

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

  RemixMenuTriggerSpec lerp(RemixMenuTriggerSpec? other, double t) {
    if (other == null) return this;

    return RemixMenuTriggerSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      icon: MixOps.lerp(icon, other.icon, t)!,
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

// ============================================================================
// MENU SPEC - Main menu specification
// ============================================================================

class RemixMenuSpec extends Spec<RemixMenuSpec> with Diagnosticable {
  final StyleSpec<RemixMenuTriggerSpec> trigger;
  final StyleSpec<FlexBoxSpec> overlay;
  final StyleSpec<RemixMenuItemSpec> item;
  final StyleSpec<RemixDividerSpec> divider;

  const RemixMenuSpec({
    StyleSpec<RemixMenuTriggerSpec>? trigger,
    StyleSpec<FlexBoxSpec>? overlay,
    StyleSpec<RemixMenuItemSpec>? item,
    StyleSpec<RemixDividerSpec>? divider,
  })  : trigger = trigger ?? const StyleSpec(spec: RemixMenuTriggerSpec()),
        overlay = overlay ?? const StyleSpec(spec: FlexBoxSpec()),
        item = item ?? const StyleSpec(spec: RemixMenuItemSpec()),
        divider = divider ?? const StyleSpec(spec: RemixDividerSpec());

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

  RemixMenuSpec lerp(RemixMenuSpec? other, double t) {
    if (other == null) return this;

    return RemixMenuSpec(
      trigger: MixOps.lerp(trigger, other.trigger, t)!,
      overlay: MixOps.lerp(overlay, other.overlay, t)!,
      item: MixOps.lerp(item, other.item, t)!,
      divider: MixOps.lerp(divider, other.divider, t)!,
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

// ============================================================================
// MENU ITEM SPEC
// ============================================================================

class RemixMenuItemSpec extends Spec<RemixMenuItemSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> leadingIcon;
  final StyleSpec<IconSpec> trailingIcon;

  const RemixMenuItemSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? leadingIcon,
    StyleSpec<IconSpec>? trailingIcon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        leadingIcon = leadingIcon ?? const StyleSpec(spec: IconSpec()),
        trailingIcon = trailingIcon ?? const StyleSpec(spec: IconSpec());

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

  RemixMenuItemSpec lerp(RemixMenuItemSpec? other, double t) {
    if (other == null) return this;

    return RemixMenuItemSpec(
      container: MixOps.lerp(container, other.container, t)!,
      label: MixOps.lerp(label, other.label, t)!,
      leadingIcon: MixOps.lerp(leadingIcon, other.leadingIcon, t)!,
      trailingIcon: MixOps.lerp(trailingIcon, other.trailingIcon, t)!,
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
