part of 'tabs.dart';

class RemixTabsSpec extends Spec<RemixTabsSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<RemixTabSpec> tab;
  final StyleSpec<BoxSpec> tabView;

  const RemixTabsSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<RemixTabSpec>? tab,
    StyleSpec<BoxSpec>? tabView,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        tab = tab ?? const StyleSpec(spec: RemixTabSpec()),
        tabView = tabView ?? const StyleSpec(spec: BoxSpec());

  RemixTabsSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<RemixTabSpec>? tab,
    StyleSpec<BoxSpec>? tabView,
  }) {
    return RemixTabsSpec(
      container: container ?? this.container,
      tab: tab ?? this.tab,
      tabView: tabView ?? this.tabView,
    );
  }

  RemixTabsSpec lerp(RemixTabsSpec? other, double t) {
    if (other == null) return this;

    return RemixTabsSpec(
      container: MixOps.lerp(container, other.container, t)!,
      tab: MixOps.lerp(tab, other.tab, t)!,
      tabView: MixOps.lerp(tabView, other.tabView, t)!,
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('container', container))
      ..add(DiagnosticsProperty('tab', tab))
      ..add(DiagnosticsProperty('tabView', tabView));
  }

  @override
  List<Object?> get props => [container, tab, tabView];
}

class RemixTabSpec extends Spec<RemixTabSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> icon;

  const RemixTabSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

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

  RemixTabSpec lerp(RemixTabSpec? other, double t) {
    if (other == null) return this;

    return RemixTabSpec(
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
