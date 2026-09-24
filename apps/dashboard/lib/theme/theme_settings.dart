import 'package:flutter/widgets.dart';
import '../ui/ui.dart';

@immutable
class ThemeSettings {
  const ThemeSettings({
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

  // The scope resolves system appearance; the dashboard owns the preference.
  ThemeSettings copyWith({
    UiThemeMode? appearance,
    UiAccentColor? accentColor,
    UiGrayColor? grayColor,
    UiPanelBackground? panelBackground,
    UiRadius? radius,
    UiScaling? scaling,
  }) {
    return ThemeSettings(
      appearance: appearance ?? this.appearance,
      accentColor: accentColor ?? this.accentColor,
      grayColor: grayColor ?? this.grayColor,
      panelBackground: panelBackground ?? this.panelBackground,
      radius: radius ?? this.radius,
      scaling: scaling ?? this.scaling,
    );
  }
}
