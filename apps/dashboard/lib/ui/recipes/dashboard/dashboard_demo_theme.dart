import 'package:flutter/widgets.dart';

import '../../theme/theme.dart';

/// Immutable theme configuration controlled by the dashboard demo.
@immutable
class UiThemeSettings {
  const UiThemeSettings({
    this.appearance = .system,
    this.accentColor = .orla,
    this.panelBackground = .solid,
    this.radius = .medium,
    this.scaling = .percent100,
  });

  /// Light, dark or system appearance.
  final UiThemeMode appearance;

  /// The accent color.
  final UiAccentColor accentColor;

  /// Whether panels are solid or translucent.
  final UiPanelBackground panelBackground;

  /// The corner radius scale.
  final UiRadius radius;

  /// The size scale applied to the whole interface.
  final UiScaling scaling;

  UiThemeSettings copyWith({
    UiThemeMode? appearance,
    UiAccentColor? accentColor,
    UiPanelBackground? panelBackground,
    UiRadius? radius,
    UiScaling? scaling,
  }) => UiThemeSettings(
    appearance: appearance ?? this.appearance,
    accentColor: accentColor ?? this.accentColor,
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
          other.panelBackground == panelBackground &&
          other.radius == radius &&
          other.scaling == scaling;

  @override
  int get hashCode =>
      Object.hash(appearance, accentColor, panelBackground, radius, scaling);
}

/// Provides live [UiThemeSettings] to the dashboard demo subtree.
class UiDashboardThemeScope extends InheritedWidget {
  const UiDashboardThemeScope({
    super.key,
    required this.settings,
    required this.onChanged,
    required super.child,
  });

  /// The current theme settings.
  final UiThemeSettings settings;

  /// Called with the new settings when the user changes one.
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

/// Applies a local accent without painting a background surface.
class UiAccentScope extends StatelessWidget {
  const UiAccentScope({
    super.key,
    required UiAccentColor this.accent,
    required this.child,
  });

  /// Applies the dedicated error red to destructive or negative content.
  /// Error is a semantic palette, not a selectable accent.
  const UiAccentScope.error({super.key, required this.child}) : accent = null;

  /// The local accent, or null for the error palette.
  final UiAccentColor? accent;

  /// The subtree that uses the accent.
  final Widget child;

  @override
  Widget build(BuildContext context) => UiTheme(
    accent: accent,
    accentPalette: accent == null ? uiError : null,
    hasBackground: false,
    child: child,
  );
}
