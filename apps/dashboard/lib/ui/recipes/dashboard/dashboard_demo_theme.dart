import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';

/// Immutable Ui theme configuration controlled by the dashboard demo.
@immutable
class UiThemeSettings {
  const UiThemeSettings({
    this.appearance = .system,
    this.accentColor = .indigo,
    this.grayColor = .slate,
    this.panelBackground = .solid,
    this.radius = .medium,
    this.scaling = .percent100,
  });

  final UiThemeMode appearance;
  final UiAccentColor accentColor;
  final UiGrayColor grayColor;
  final UiPanelBackground panelBackground;
  final UiRadius radius;
  final UiScaling scaling;

  UiThemeSettings copyWith({
    UiThemeMode? appearance,
    UiAccentColor? accentColor,
    UiGrayColor? grayColor,
    UiPanelBackground? panelBackground,
    UiRadius? radius,
    UiScaling? scaling,
  }) => UiThemeSettings(
    appearance: appearance ?? this.appearance,
    accentColor: accentColor ?? this.accentColor,
    grayColor: grayColor ?? this.grayColor,
    panelBackground: panelBackground ?? this.panelBackground,
    radius: radius ?? this.radius,
    scaling: scaling ?? this.scaling,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UiThemeSettings &&
          other.appearance == appearance &&
          other.accentColor == accentColor &&
          other.grayColor == grayColor &&
          other.panelBackground == panelBackground &&
          other.radius == radius &&
          other.scaling == scaling;

  @override
  int get hashCode => Object.hash(
    appearance,
    accentColor,
    grayColor,
    panelBackground,
    radius,
    scaling,
  );
}

/// Provides live [UiThemeSettings] to the dashboard demo subtree.
class UiDashboardThemeScope extends InheritedWidget {
  const UiDashboardThemeScope({
    super.key,
    required this.settings,
    required this.onChanged,
    required super.child,
  });

  final UiThemeSettings settings;
  final ValueChanged<UiThemeSettings> onChanged;

  static UiDashboardThemeScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UiDashboardThemeScope>();

  static UiDashboardThemeScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(
      scope != null,
      'UiDashboardThemeScope is missing above this context.',
    );
    return scope!;
  }

  @override
  bool updateShouldNotify(UiDashboardThemeScope oldWidget) =>
      settings != oldWidget.settings || onChanged != oldWidget.onChanged;
}

/// Applies a local Ui accent without painting a background surface.
class UiAccentScope extends StatelessWidget {
  const UiAccentScope({super.key, required this.accent, required this.child});

  final UiAccentColor accent;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      UiTheme(accent: accent, hasBackground: false, child: child);
}
