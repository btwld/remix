// Radix theme: tokens + MixScope builder in one place.

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import 'types.dart' as radix;
import 'computed.dart' as radix_comp;

/// Radix UI design tokens using Mix token system.
class RadixTokens {
  // Background
  static const colorBackground = ColorToken('radix.color.background');
  static const colorSurface = ColorToken('radix.color.surface');
  static const colorPanelSolid = ColorToken('radix.color.panel.solid');
  static const colorPanelTranslucent = ColorToken('radix.color.panel.translucent');
  static const colorOverlay = ColorToken('radix.color.overlay');

  // Accent functional
  static const accentSurface = ColorToken('radix.accent.surface');
  static const accentIndicator = ColorToken('radix.accent.indicator');
  static const accentTrack = ColorToken('radix.accent.track');
  static const accentContrast = ColorToken('radix.accent.contrast');

  // Focus
  static const focus8 = ColorToken('radix.focus.8');
  static const focusA8 = ColorToken('radix.focus.a8');

  // Accent steps
  static const accent1 = ColorToken('radix.accent.1');
  static const accent2 = ColorToken('radix.accent.2');
  static const accent3 = ColorToken('radix.accent.3');
  static const accent4 = ColorToken('radix.accent.4');
  static const accent5 = ColorToken('radix.accent.5');
  static const accent6 = ColorToken('radix.accent.6');
  static const accent7 = ColorToken('radix.accent.7');
  static const accent8 = ColorToken('radix.accent.8');
  static const accent9 = ColorToken('radix.accent.9');
  static const accent10 = ColorToken('radix.accent.10');
  static const accent11 = ColorToken('radix.accent.11');
  static const accent12 = ColorToken('radix.accent.12');

  // Gray steps
  static const gray1 = ColorToken('radix.gray.1');
  static const gray2 = ColorToken('radix.gray.2');
  static const gray3 = ColorToken('radix.gray.3');
  static const gray4 = ColorToken('radix.gray.4');
  static const gray5 = ColorToken('radix.gray.5');
  static const gray6 = ColorToken('radix.gray.6');
  static const gray7 = ColorToken('radix.gray.7');
  static const gray8 = ColorToken('radix.gray.8');
  static const gray9 = ColorToken('radix.gray.9');
  static const gray10 = ColorToken('radix.gray.10');
  static const gray11 = ColorToken('radix.gray.11');
  static const gray12 = ColorToken('radix.gray.12');

  // Accent alpha commonly used
  static const accentA3 = ColorToken('radix.accent.a3');
  static const accentA4 = ColorToken('radix.accent.a4');
  static const accentA8 = ColorToken('radix.accent.a8');

  // Space
  static const space1 = SpaceToken('radix.space.1');
  static const space2 = SpaceToken('radix.space.2');
  static const space3 = SpaceToken('radix.space.3');
  static const space4 = SpaceToken('radix.space.4');
  static const space5 = SpaceToken('radix.space.5');
  static const space6 = SpaceToken('radix.space.6');
  static const space7 = SpaceToken('radix.space.7');
  static const space8 = SpaceToken('radix.space.8');
  static const space9 = SpaceToken('radix.space.9');

  // Radius
  static const radius1 = RadiusToken('radix.radius.1');
  static const radius2 = RadiusToken('radix.radius.2');
  static const radius3 = RadiusToken('radix.radius.3');
  static const radius4 = RadiusToken('radix.radius.4');
  static const radius5 = RadiusToken('radix.radius.5');
  static const radius6 = RadiusToken('radix.radius.6');
  static const radiusFull = RadiusToken('radix.radius.full');

  // Border widths
  static const borderWidth1 = SpaceToken('radix.border.width.1');
  static const borderWidth2 = SpaceToken('radix.border.width.2');
  static const focusRingWidth = SpaceToken('radix.focus.ring.width');
  static const focusRingOffset = SpaceToken('radix.focus.ring.offset');

  // Typography
  static const text1 = TextStyleToken('radix.text.1');
  static const text2 = TextStyleToken('radix.text.2');
  static const text3 = TextStyleToken('radix.text.3');
  static const text4 = TextStyleToken('radix.text.4');
  static const text5 = TextStyleToken('radix.text.5');
  static const text6 = TextStyleToken('radix.text.6');
  static const text7 = TextStyleToken('radix.text.7');
  static const text8 = TextStyleToken('radix.text.8');
  static const text9 = TextStyleToken('radix.text.9');

  // Simple runtime constants
  static FontWeight fontWeightRegular() => FontWeight.w400;
  static FontWeight fontWeightMedium() => FontWeight.w500;
  static FontWeight fontWeightBold() => FontWeight.w600;
  static Duration transitionFast() => const Duration(milliseconds: 100);
  static Duration transitionSlow() => const Duration(milliseconds: 300);
}

/// Creates a MixScope with Radix design tokens configured for the specified theme.
Widget createRadixScope({
  radix.RadixAccentColor accent = radix.RadixAccentColor.indigo,
  radix.RadixGrayColor gray = radix.RadixGrayColor.slate,
  Brightness brightness = Brightness.light,
  List<Type>? orderOfModifiers,
  required Widget child,
}) {
  final theme = radix.RadixTheme(
    accent: accent,
    gray: gray,
    isDark: brightness == Brightness.dark,
  );

  final tokens = radix_comp.resolveRadixTokens(theme);

  final colorTokens = {
    RadixTokens.colorBackground: tokens.colorBackground,
    RadixTokens.colorSurface: tokens.colorSurface,
    RadixTokens.colorPanelSolid: tokens.colorPanelSolid,
    RadixTokens.colorPanelTranslucent: tokens.colorPanelTranslucent,
    RadixTokens.colorOverlay: tokens.colorOverlay,
    RadixTokens.accentSurface: tokens.accentSurface,
    RadixTokens.accentIndicator: tokens.accentIndicator,
    RadixTokens.accentTrack: tokens.accentTrack,
    RadixTokens.accentContrast: tokens.accentContrast,
    RadixTokens.focus8: tokens.focus8,
    RadixTokens.focusA8: tokens.focusA8,
    RadixTokens.accent1: tokens.accent.step(1),
    RadixTokens.accent2: tokens.accent.step(2),
    RadixTokens.accent3: tokens.accent.step(3),
    RadixTokens.accent4: tokens.accent.step(4),
    RadixTokens.accent5: tokens.accent.step(5),
    RadixTokens.accent6: tokens.accent.step(6),
    RadixTokens.accent7: tokens.accent.step(7),
    RadixTokens.accent8: tokens.accent.step(8),
    RadixTokens.accent9: tokens.accent.step(9),
    RadixTokens.accent10: tokens.accent.step(10),
    RadixTokens.accent11: tokens.accent.step(11),
    RadixTokens.accent12: tokens.accent.step(12),
    RadixTokens.gray1: tokens.gray.step(1),
    RadixTokens.gray2: tokens.gray.step(2),
    RadixTokens.gray3: tokens.gray.step(3),
    RadixTokens.gray4: tokens.gray.step(4),
    RadixTokens.gray5: tokens.gray.step(5),
    RadixTokens.gray6: tokens.gray.step(6),
    RadixTokens.gray7: tokens.gray.step(7),
    RadixTokens.gray8: tokens.gray.step(8),
    RadixTokens.gray9: tokens.gray.step(9),
    RadixTokens.gray10: tokens.gray.step(10),
    RadixTokens.gray11: tokens.gray.step(11),
    RadixTokens.gray12: tokens.gray.step(12),
    RadixTokens.accentA3: tokens.accent.alphaStep(3),
    RadixTokens.accentA4: tokens.accent.alphaStep(4),
    RadixTokens.accentA8: tokens.accent.alphaStep(8),
  };

  final allTokens = <MixToken, Object>{
    ...colorTokens,
    RadixTokens.space1: 4.0,
    RadixTokens.space2: 8.0,
    RadixTokens.space3: 12.0,
    RadixTokens.space4: 16.0,
    RadixTokens.space5: 20.0,
    RadixTokens.space6: 24.0,
    RadixTokens.space7: 28.0,
    RadixTokens.space8: 32.0,
    RadixTokens.space9: 36.0,
    RadixTokens.radius1: const Radius.circular(3.0),
    RadixTokens.radius2: const Radius.circular(4.0),
    RadixTokens.radius3: const Radius.circular(6.0),
    RadixTokens.radius4: const Radius.circular(8.0),
    RadixTokens.radius5: const Radius.circular(12.0),
    RadixTokens.radius6: const Radius.circular(16.0),
    RadixTokens.radiusFull: const Radius.circular(9999.0),
    RadixTokens.borderWidth1: 1.0,
    RadixTokens.borderWidth2: 2.0,
    RadixTokens.focusRingWidth: 2.0,
    RadixTokens.text1: TextStyleMix(fontSize: 12.0, letterSpacing: 0.0025 * 12.0, height: 16.0 / 12.0),
    RadixTokens.text2: TextStyleMix(fontSize: 14.0, letterSpacing: 0.0, height: 20.0 / 14.0),
    RadixTokens.text3: TextStyleMix(fontSize: 16.0, letterSpacing: 0.0, height: 24.0 / 16.0),
    RadixTokens.text4: TextStyleMix(fontSize: 18.0, letterSpacing: -0.0025 * 18.0, height: 26.0 / 18.0),
    RadixTokens.text5: TextStyleMix(fontSize: 20.0, letterSpacing: -0.005 * 20.0, height: 28.0 / 20.0),
    RadixTokens.text6: TextStyleMix(fontSize: 24.0, letterSpacing: -0.00625 * 24.0, height: 30.0 / 24.0),
    RadixTokens.text7: TextStyleMix(fontSize: 28.0, letterSpacing: -0.0075 * 28.0, height: 36.0 / 28.0),
    RadixTokens.text8: TextStyleMix(fontSize: 35.0, letterSpacing: -0.01 * 35.0, height: 40.0 / 35.0),
    RadixTokens.text9: TextStyleMix(fontSize: 60.0, letterSpacing: -0.025 * 60.0, height: 1.0),
  };

  return MixScope(tokens: allTokens, orderOfModifiers: orderOfModifiers, child: child);
}

/// Convenience holder for Radix theme configuration.
@immutable
class RadixThemeConfig {
  final radix.RadixAccentColor accent;
  final radix.RadixGrayColor gray;
  final Brightness brightness;

  const RadixThemeConfig({
    this.accent = radix.RadixAccentColor.indigo,
    this.gray = radix.RadixGrayColor.slate,
    this.brightness = Brightness.light,
  });

  bool get isDark => brightness == Brightness.dark;

  RadixThemeConfig copyWith({
    radix.RadixAccentColor? accent,
    radix.RadixGrayColor? gray,
    Brightness? brightness,
  }) => RadixThemeConfig(
        accent: accent ?? this.accent,
        gray: gray ?? this.gray,
        brightness: brightness ?? this.brightness,
      );

  Widget createScope({List<Type>? orderOfModifiers, required Widget child}) =>
      createRadixScope(
        accent: accent,
        gray: gray,
        brightness: brightness,
        orderOfModifiers: orderOfModifiers,
        child: child,
      );
}
