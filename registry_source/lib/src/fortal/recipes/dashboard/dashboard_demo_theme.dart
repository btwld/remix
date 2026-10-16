import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';

/// Immutable Fortal theme configuration controlled by the dashboard demo.
@immutable
class FortalThemeSettings {
  const FortalThemeSettings({
    this.appearance = .system,
    this.accentColor = .indigo,
    this.grayColor = .slate,
    this.panelBackground = .solid,
    this.radius = .medium,
    this.scaling = .percent100,
  });

  final FortalThemeMode appearance;
  final FortalAccentColor accentColor;
  final FortalGrayColor grayColor;
  final FortalPanelBackground panelBackground;
  final FortalRadius radius;
  final FortalScaling scaling;

  FortalThemeSettings copyWith({
    FortalThemeMode? appearance,
    FortalAccentColor? accentColor,
    FortalGrayColor? grayColor,
    FortalPanelBackground? panelBackground,
    FortalRadius? radius,
    FortalScaling? scaling,
  }) => FortalThemeSettings(
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
      other is FortalThemeSettings &&
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

/// Provides live [FortalThemeSettings] to the dashboard demo subtree.
class FortalDashboardThemeScope extends InheritedWidget {
  const FortalDashboardThemeScope({
    super.key,
    required this.settings,
    required this.onChanged,
    required super.child,
  });

  final FortalThemeSettings settings;
  final ValueChanged<FortalThemeSettings> onChanged;

  static FortalDashboardThemeScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FortalDashboardThemeScope>();

  static FortalDashboardThemeScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(
      scope != null,
      'FortalDashboardThemeScope is missing above this context.',
    );
    return scope!;
  }

  @override
  bool updateShouldNotify(FortalDashboardThemeScope oldWidget) =>
      settings != oldWidget.settings || onChanged != oldWidget.onChanged;
}

/// Applies a local Fortal accent without painting a background surface.
class FortalAccentScope extends StatelessWidget {
  const FortalAccentScope({
    super.key,
    required this.accent,
    required this.child,
  });

  final FortalAccentColor accent;
  final Widget child;

  @override
  Widget build(BuildContext context) =>
      FortalTheme(accent: accent, hasBackground: false, child: child);
}
