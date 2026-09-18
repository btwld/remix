// Adapted from remix_carbon at commit 606bfbb36 and from design tokens in the
// IBM Carbon Design System. Copyright 2026 the Remix authors; IBM Carbon
// Design System copyright IBM Corp. and the Carbon authors. Apache-2.0.
// SPDX-License-Identifier: Apache-2.0

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'tokens.dart';

/// The IBM Carbon themes supported by the initial registry slice.
///
/// Gray 90 and Gray 100 join these themes with the generated token foundation
/// in the next rollout wave.
enum CarbideTheme {
  white,
  g10;

  Brightness get brightness => Brightness.light;

  bool get isDark => false;
}

/// Optional typed overrides applied after a Carbon theme's pinned values.
@immutable
class CarbideThemeOverrides {
  const CarbideThemeOverrides({this.colors = const {}, this.fontFamily});

  final Map<ColorToken, Color> colors;
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
      colors.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
  );
}

Map<MixToken<Object?>, Object> _baseTokenMap(CarbideTheme theme) {
  // White and Gray 10 resolve to the same official values for the token subset
  // consumed by Button. Keep the theme switch explicit so Wave 2 can replace
  // each branch with its complete generated map without changing this API.
  final colors = switch (theme) {
    .white || .g10 => <ColorToken, Color>{
      CarbideTokens.backgroundActive: const Color(0x808D8D8D),
      CarbideTokens.backgroundHover: const Color(0x1F8D8D8D),
      CarbideTokens.borderDisabled: const Color(0xFFC6C6C6),
      CarbideTokens.focus: const Color(0xFF0F62FE),
      CarbideTokens.focusInset: const Color(0xFFFFFFFF),
      CarbideTokens.linkPrimary: const Color(0xFF0F62FE),
      CarbideTokens.linkPrimaryHover: const Color(0xFF0043CE),
      CarbideTokens.textDisabled: const Color(0x40161616),
      CarbideTokens.textInverse: const Color(0xFFFFFFFF),
      CarbideTokens.textOnColor: const Color(0xFFFFFFFF),
      CarbideTokens.textOnColorDisabled: const Color(0xFF8D8D8D),
      CarbideComponentTokens.buttonDangerActive: const Color(0xFF750E13),
      CarbideComponentTokens.buttonDangerHover: const Color(0xFFB81921),
      CarbideComponentTokens.buttonDangerPrimary: const Color(0xFFDA1E28),
      CarbideComponentTokens.buttonDangerSecondary: const Color(0xFFDA1E28),
      CarbideComponentTokens.buttonDisabled: const Color(0xFFC6C6C6),
      CarbideComponentTokens.buttonPrimary: const Color(0xFF0F62FE),
      CarbideComponentTokens.buttonPrimaryActive: const Color(0xFF002D9C),
      CarbideComponentTokens.buttonPrimaryHover: const Color(0xFF0050E6),
      CarbideComponentTokens.buttonSecondary: const Color(0xFF393939),
      CarbideComponentTokens.buttonSecondaryActive: const Color(0xFF6F6F6F),
      CarbideComponentTokens.buttonSecondaryHover: const Color(0xFF474747),
      CarbideComponentTokens.buttonTertiary: const Color(0xFF0F62FE),
      CarbideComponentTokens.buttonTertiaryActive: const Color(0xFF002D9C),
      CarbideComponentTokens.buttonTertiaryHover: const Color(0xFF0050E6),
    },
  };

  return Map<MixToken<Object?>, Object>.unmodifiable({
    ...colors,
    CarbideTokens.spacing03: 8.0,
    CarbideTokens.spacing05: 16.0,
    CarbideTokens.spacing07: 32.0,
    CarbideTokens.iconSize01: 16.0,
    CarbideTokens.bodyCompact01: const TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      height: 1.2857,
      letterSpacing: 0.16,
    ),
  });
}

final Map<CarbideTheme, Map<MixToken<Object?>, Object>> _baseTokenMaps = {};

/// Builds the complete token map needed by the initial Carbon Button slice.
Map<MixToken<Object?>, Object> buildCarbideTokenMap(
  CarbideTheme theme, {
  CarbideThemeOverrides overrides = const CarbideThemeOverrides(),
}) {
  final base = _baseTokenMaps.putIfAbsent(theme, () => _baseTokenMap(theme));
  final fontFamily = overrides.fontFamily;
  if (fontFamily == null && overrides.colors.isEmpty) return base;

  return Map<MixToken<Object?>, Object>.unmodifiable({
    ...base,
    if (fontFamily != null)
      CarbideTokens.bodyCompact01:
          (base[CarbideTokens.bodyCompact01]! as TextStyle).copyWith(
            fontFamily: fontFamily,
          ),
    ...overrides.colors,
  });
}
