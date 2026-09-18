// Adapted from remix_carbon at commit 606bfbb36 and from design tokens in the
// IBM Carbon Design System. Copyright 2026 the Remix authors; IBM Carbon
// Design System copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'generated/carbon_component_tokens.dart';
import 'generated/carbon_themes.dart';
import 'generated/carbon_layout.dart';
import 'generated/carbon_motion.dart';
import 'generated/carbon_type.dart';

/// The four official IBM Carbon themes.
///
/// White and Gray 10 are light; Gray 90 and Gray 100 are dark. The names mirror
/// Carbon's own theme identifiers so documentation and design hand-offs line up.
enum CarbideTheme {
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
    .white || .g10 => .light,
    .g90 || .g100 => .dark,
  };

  /// Whether this is one of Carbon's dark themes.
  bool get isDark => brightness == .dark;
}

/// Optional, typed overrides applied on top of a theme's generated maps.
///
/// Overrides are merged when the scope's token map is built; the generated
/// theme maps themselves are never mutated.
@immutable
class CarbideThemeOverrides {
  const CarbideThemeOverrides({this.colors = const {}, this.fontFamily});

  /// Role or component color tokens to override.
  final Map<ColorToken, Color> colors;

  /// Font family applied to every text style token (e.g. an `IBM Plex Sans`
  /// family the app has bundled). When null the platform default font is used.
  final String? fontFamily;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CarbideThemeOverrides &&
          other.fontFamily == fontFamily &&
          mapEquals(other.colors, colors);

  @override
  int get hashCode => Object.hash(
    fontFamily,
    Object.hashAllUnordered(
      colors.entries.map((e) => Object.hash(e.key, e.value)),
    ),
  );
}

// Base token maps are pure functions of the theme, so they are built once per
// theme and shared. Returning the identical instance also lets MixScope's
// dependents short-circuit equality checks on rebuilds that change nothing.
final Map<CarbideTheme, Map<MixToken<Object?>, Object>> _baseTokenMaps = {};

Map<MixToken<Object?>, Object> _baseTokenMapFor(CarbideTheme theme) {
  return _baseTokenMaps.putIfAbsent(theme, () {
    final roleColors = switch (theme) {
      .white => carbideRoleColorsWhite,
      .g10 => carbideRoleColorsG10,
      .g90 => carbideRoleColorsG90,
      .g100 => carbideRoleColorsG100,
    };
    final componentColors = switch (theme) {
      .white => carbideComponentColorsWhite,
      .g10 => carbideComponentColorsG10,
      .g90 => carbideComponentColorsG90,
      .g100 => carbideComponentColorsG100,
    };

    return Map.unmodifiable(<MixToken<Object?>, Object>{
      ...roleColors,
      ...componentColors,
      ...carbideSpacingValues,
      ...carbideTextStyleTokens,
      ...carbideDurationValues,
      ...carbideFontWeightValues,
    });
  });
}

/// Builds the full `MixScope` token map for [theme].
///
/// Combines theme-dependent role and component colors with theme-independent
/// spacing, type, motion and font-weight values, then applies [overrides].
/// With no overrides this returns a cached, unmodifiable map, so repeated
/// scope rebuilds are allocation-free.
Map<MixToken<Object?>, Object> buildCarbideTokenMap(
  CarbideTheme theme, {
  CarbideThemeOverrides overrides = const CarbideThemeOverrides(),
}) {
  final base = _baseTokenMapFor(theme);
  final fontFamily = overrides.fontFamily;
  if (fontFamily == null && overrides.colors.isEmpty) return base;

  return {
    ...base,
    if (fontFamily != null)
      ...carbideTextStyleTokens.map(
        (k, v) => MapEntry(k, v.copyWith(fontFamily: fontFamily)),
      ),
    // Overrides win over generated values.
    ...overrides.colors,
  };
}
