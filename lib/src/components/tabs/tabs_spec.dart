part of 'tabs.dart';

class TabsSpec extends Spec<TabsSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TabSpec> tab;
  final StyleSpec<BoxSpec> tabView;

  const TabsSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TabSpec>? tab,
    StyleSpec<BoxSpec>? tabView,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        tab = tab ?? const StyleSpec(spec: TabSpec()),
        tabView = tabView ?? const StyleSpec(spec: BoxSpec());

  TabsSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TabSpec>? tab,
    StyleSpec<BoxSpec>? tabView,
  }) {
    return TabsSpec(
      container: container ?? this.container,
      tab: tab ?? this.tab,
      tabView: tabView ?? this.tabView,
    );
  }

  TabsSpec lerp(TabsSpec? other, double t) {
    if (other == null) return this;

    return TabsSpec(
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

class TabSpec extends Spec<TabSpec> with Diagnosticable {
  final StyleSpec<FlexBoxSpec> container;
  final StyleSpec<TextSpec> label;
  final StyleSpec<IconSpec> icon;

  const TabSpec({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  })  : container = container ?? const StyleSpec(spec: FlexBoxSpec()),
        label = label ?? const StyleSpec(spec: TextSpec()),
        icon = icon ?? const StyleSpec(spec: IconSpec());

  TabSpec copyWith({
    StyleSpec<FlexBoxSpec>? container,
    StyleSpec<TextSpec>? label,
    StyleSpec<IconSpec>? icon,
  }) {
    return TabSpec(
      container: container ?? this.container,
      label: label ?? this.label,
      icon: icon ?? this.icon,
    );
  }

  TabSpec lerp(TabSpec? other, double t) {
    if (other == null) return this;

    return TabSpec(
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