import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';

/// Immutable theme configuration controlled by the dashboard demo.
@immutable
class FortalThemeSettings {
  const FortalThemeSettings({
    this.appearance = .system,
    this.accentColor = .orla,
    this.panelBackground = .solid,
    this.radius = .medium,
    this.scaling = .percent100,
  });

  /// Light, dark or system appearance.
  final FortalThemeMode appearance;

  /// The accent color.
  final FortalAccentColor accentColor;

  /// Whether panels are solid or translucent.
  final FortalPanelBackground panelBackground;

  /// The corner radius scale.
  final FortalRadius radius;

  /// The size scale applied to the whole interface.
  final FortalScaling scaling;

  FortalThemeSettings copyWith({
    FortalThemeMode? appearance,
    FortalAccentColor? accentColor,
    FortalPanelBackground? panelBackground,
    FortalRadius? radius,
    FortalScaling? scaling,
  }) => FortalThemeSettings(
    appearance: appearance ?? this.appearance,
    accentColor: accentColor ?? this.accentColor,
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
          other.panelBackground == panelBackground &&
          other.radius == radius &&
          other.scaling == scaling;

  @override
  int get hashCode =>
      Object.hash(appearance, accentColor, panelBackground, radius, scaling);
}

/// Provides live [FortalThemeSettings] to the dashboard demo subtree.
class FortalDashboardThemeScope extends InheritedWidget {
  const FortalDashboardThemeScope({
    super.key,
    required this.settings,
    required this.onChanged,
    required super.child,
  });

  /// The current theme settings.
  final FortalThemeSettings settings;

  /// Called with the new settings when the user changes one.
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

/// Applies a local accent without painting a background surface.
class FortalAccentScope extends StatelessWidget {
  const FortalAccentScope({
    super.key,
    required FortalAccentColor this.accent,
    required this.child,
  });

  /// Applies the dedicated error red to destructive or negative content.
  /// Error is a semantic palette, not a selectable accent.
  const FortalAccentScope.error({super.key, required this.child})
    : accent = null;

  /// The local accent, or null for the error palette.
  final FortalAccentColor? accent;

  /// The subtree that uses the accent.
  final Widget child;

  @override
  Widget build(BuildContext context) => FortalTheme(
    accent: accent,
    accentPalette: accent == null ? fortalError : null,
    hasBackground: false,
    child: child,
  );
}
