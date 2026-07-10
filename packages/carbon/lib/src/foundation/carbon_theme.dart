import 'package:flutter/widgets.dart';
import 'package:mix/mix.dart';

import '../tokens/generated/carbon_component_tokens.g.dart';
import '../tokens/generated/carbon_themes.g.dart';
import '../tokens/generated/carbon_layout.g.dart';
import '../tokens/generated/carbon_motion.g.dart';
import '../tokens/generated/carbon_type.g.dart';

/// The four official IBM Carbon themes.
///
/// White and Gray 10 are light; Gray 90 and Gray 100 are dark. The names mirror
/// Carbon's own theme identifiers so documentation and design hand-offs line up.
enum CarbonTheme {
  /// White theme (lightest).
  white,

  /// Gray 10 theme (light).
  g10,

  /// Gray 90 theme (dark).
  g90,

  /// Gray 100 theme (darkest).
  g100;

  /// The Flutter [Brightness] that matches this theme.
  Brightness get brightness => switch (this) {
        CarbonTheme.white || CarbonTheme.g10 => Brightness.light,
        CarbonTheme.g90 || CarbonTheme.g100 => Brightness.dark,
      };

  /// Whether this is one of Carbon's dark themes.
  bool get isDark => brightness == Brightness.dark;
}

/// Optional, typed overrides applied on top of a theme's generated maps.
///
/// Overrides are merged when the scope's token map is built; the generated
/// theme maps themselves are never mutated.
@immutable
class CarbonThemeOverrides {
  const CarbonThemeOverrides({
    this.colors = const {},
    this.fontFamily,
  });

  /// Role or component color tokens to override.
  final Map<ColorToken, Color> colors;

  /// Font family applied to every text style token (e.g. an `IBM Plex Sans`
  /// family the app has bundled). When null the platform default font is used.
  final String? fontFamily;
}

/// Builds the full `MixScope` token map for [theme].
///
/// Combines theme-dependent role and component colors with theme-independent
/// spacing, type, motion and font-weight values, then applies [overrides].
Map<MixToken, Object> buildCarbonTokenMap(
  CarbonTheme theme, {
  CarbonThemeOverrides overrides = const CarbonThemeOverrides(),
}) {
  final roleColors = switch (theme) {
    CarbonTheme.white => carbonRoleColorsWhite(),
    CarbonTheme.g10 => carbonRoleColorsG10(),
    CarbonTheme.g90 => carbonRoleColorsG90(),
    CarbonTheme.g100 => carbonRoleColorsG100(),
  };
  final componentColors = switch (theme) {
    CarbonTheme.white => carbonComponentColorsWhite(),
    CarbonTheme.g10 => carbonComponentColorsG10(),
    CarbonTheme.g90 => carbonComponentColorsG90(),
    CarbonTheme.g100 => carbonComponentColorsG100(),
  };

  final fontFamily = overrides.fontFamily;
  final textStyles = carbonTextStyleTokens();
  final resolvedText = fontFamily == null
      ? textStyles
      : textStyles.map((k, v) => MapEntry(k, v.copyWith(fontFamily: fontFamily)));

  return <MixToken, Object>{
    ...roleColors,
    ...componentColors,
    ...carbonSpacingValues(),
    ...resolvedText,
    ...carbonDurationValues(),
    ...carbonFontWeightValues(),
    // Overrides win over generated values.
    ...overrides.colors,
  };
}
