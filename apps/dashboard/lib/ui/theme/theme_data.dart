import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'computed.dart';
import 'fortal_colors.dart' as colors;
import 'palette.dart';
import 'theme_scope.dart' show UiTheme;
import 'tokens.dart';

/// Ui palettes, named for the landscapes and coastal materials.
enum UiAccentColor { calcadao, mar, ceu, mangue, sol, duna, caju }

/// The neutral palette. The enum leaves room for future neutral families.
enum UiGrayColor { calcadao }

/// Theme-level radius multipliers.
enum UiRadius { none, small, medium, large, full }

/// Background treatment used by floating panels.
enum UiPanelBackground { solid, translucent }

/// Discrete theme scaling values supported by Ui.
enum UiScaling {
  percent90(0.9),
  percent95(0.95),
  percent100(1.0),
  percent105(1.05),
  percent110(1.1);

  const UiScaling(this.factor);

  /// Numeric multiplier represented by this preset.
  final double factor;
}

/// Appearance selection for a Ui scope. A root defaults to system;
/// a nested scope inherits its parent's selection when mode is omitted.
enum UiThemeMode { system, light, dark }

/// Partial theme values applied by a [UiTheme].
@immutable
class UiThemeConfig {
  const UiThemeConfig({
    this.accent,
    this.accentPalette,
    this.gray,
    this.brightness,
    this.panelBackground,
    this.radius,
    this.scaling,
    this.hasBackground,
  });

  final UiAccentColor? accent;

  /// Optional seed-generated brand palette, overriding the named accent.
  final UiColorTheme? accentPalette;
  final UiGrayColor? gray;
  final Brightness? brightness;
  final UiPanelBackground? panelBackground;
  final UiRadius? radius;
  final UiScaling? scaling;
  final bool? hasBackground;

  bool get isDark => brightness == .dark;

  UiThemeConfig copyWith({
    UiAccentColor? accent,
    UiColorTheme? accentPalette,
    UiGrayColor? gray,
    Brightness? brightness,
    UiPanelBackground? panelBackground,
    UiRadius? radius,
    UiScaling? scaling,
    bool? hasBackground,
  }) => UiThemeConfig(
    accent: accent ?? this.accent,
    accentPalette:
        accentPalette ?? (accent == null ? this.accentPalette : null),
    gray: gray ?? this.gray,
    brightness: brightness ?? this.brightness,
    panelBackground: panelBackground ?? this.panelBackground,
    radius: radius ?? this.radius,
    scaling: scaling ?? this.scaling,
    hasBackground: hasBackground ?? this.hasBackground,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UiThemeConfig &&
          accent == other.accent &&
          accentPalette == other.accentPalette &&
          gray == other.gray &&
          brightness == other.brightness &&
          panelBackground == other.panelBackground &&
          radius == other.radius &&
          scaling == other.scaling &&
          hasBackground == other.hasBackground;

  @override
  int get hashCode => Object.hash(
    accent,
    accentPalette,
    gray,
    brightness,
    panelBackground,
    radius,
    scaling,
    hasBackground,
  );
}

/// Fully resolved theme values inherited by a Ui subtree.
@immutable
class UiThemeData extends UiThemeConfig {
  const UiThemeData({
    required UiAccentColor super.accent,
    super.accentPalette,
    required UiGrayColor super.gray,
    required Brightness super.brightness,
    required UiPanelBackground super.panelBackground,
    required UiRadius super.radius,
    required UiScaling super.scaling,
    required bool super.hasBackground,
  });

  /// The preset's light appearance, with editable design options.
  const UiThemeData.light({
    UiAccentColor accent = UiAccentColor.calcadao,
    UiColorTheme? accentPalette,
    UiGrayColor gray = UiGrayColor.calcadao,
    UiPanelBackground panelBackground = UiPanelBackground.solid,
    UiRadius radius = UiRadius.medium,
    UiScaling scaling = UiScaling.percent100,
    bool hasBackground = true,
  }) : this(
         accent: accent,
         accentPalette: accentPalette,
         gray: gray,
         brightness: Brightness.light,
         panelBackground: panelBackground,
         radius: radius,
         scaling: scaling,
         hasBackground: hasBackground,
       );

  /// The preset's dark appearance, with editable design options.
  const UiThemeData.dark({
    UiAccentColor accent = UiAccentColor.calcadao,
    UiColorTheme? accentPalette,
    UiGrayColor gray = UiGrayColor.calcadao,
    UiPanelBackground panelBackground = UiPanelBackground.solid,
    UiRadius radius = UiRadius.medium,
    UiScaling scaling = UiScaling.percent100,
    bool hasBackground = true,
  }) : this(
         accent: accent,
         accentPalette: accentPalette,
         gray: gray,
         brightness: Brightness.dark,
         panelBackground: panelBackground,
         radius: radius,
         scaling: scaling,
         hasBackground: hasBackground,
       );

  @override
  UiAccentColor get accent => super.accent!;
  @override
  UiGrayColor get gray => super.gray!;
  @override
  Brightness get brightness => super.brightness!;
  @override
  UiPanelBackground get panelBackground => super.panelBackground!;
  @override
  UiRadius get radius => super.radius!;
  @override
  UiScaling get scaling => super.scaling!;
  @override
  bool get hasBackground => super.hasBackground!;

  @override
  bool get isDark => brightness == .dark;

  @override
  UiThemeData copyWith({
    UiAccentColor? accent,
    UiColorTheme? accentPalette,
    UiGrayColor? gray,
    Brightness? brightness,
    UiPanelBackground? panelBackground,
    UiRadius? radius,
    UiScaling? scaling,
    bool? hasBackground,
  }) => UiThemeData(
    accent: accent ?? this.accent,
    accentPalette:
        accentPalette ?? (accent == null ? this.accentPalette : null),
    gray: gray ?? this.gray,
    brightness: brightness ?? this.brightness,
    panelBackground: panelBackground ?? this.panelBackground,
    radius: radius ?? this.radius,
    scaling: scaling ?? this.scaling,
    hasBackground: hasBackground ?? this.hasBackground,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UiThemeData &&
          accent == other.accent &&
          accentPalette == other.accentPalette &&
          gray == other.gray &&
          brightness == other.brightness &&
          panelBackground == other.panelBackground &&
          radius == other.radius &&
          scaling == other.scaling &&
          hasBackground == other.hasBackground;

  @override
  int get hashCode => Object.hash(
    accent,
    accentPalette,
    gray,
    brightness,
    panelBackground,
    radius,
    scaling,
    hasBackground,
  );
}

/// Builds the token map for a Ui scope. Used by [UiTheme].
Map<MixToken<Object?>, Object> buildUiScopeTokens(UiThemeData theme) {
  final tokens = resolveUiTokens(theme);
  final scaling = theme.scaling.factor;
  final shadows = buildUiShadows(isDark: theme.isDark, colors: tokens);

  final colorTokens = {
    // Role and functional tokens
    UiTokens.colorBackground: tokens.colorBackground,
    UiTokens.colorSurface: tokens.colorSurface,
    UiTokens.segmentedControlIndicatorBackground: theme.isDark
        ? tokens.gray.scale.alphaStep(3)
        : tokens.colorBackground,
    UiTokens.colorPanelSolid: tokens.colorPanelSolid,
    UiTokens.colorPanelTranslucent: tokens.colorPanelTranslucent,
    UiTokens.colorPanel: theme.panelBackground == .solid
        ? tokens.colorPanelSolid
        : tokens.colorPanelTranslucent,
    UiTokens.colorOverlay: tokens.colorOverlay,
    UiTokens.sliderHighContrastOverlay: theme.isDark
        ? const Color(0x00000000)
        : tokens.blackAlpha[8]!,
    UiTokens.error3: (theme.isDark ? colors.caju.dark : colors.caju.light).scale
        .step(3),
    UiTokens.error7: (theme.isDark ? colors.caju.dark : colors.caju.light).scale
        .step(7),
    UiTokens.error8: (theme.isDark ? colors.caju.dark : colors.caju.light).scale
        .step(8),
    UiTokens.error9: (theme.isDark ? colors.caju.dark : colors.caju.light).scale
        .step(9),
    UiTokens.error11: (theme.isDark ? colors.caju.dark : colors.caju.light)
        .scale
        .step(11),
    UiTokens.error12: (theme.isDark ? colors.caju.dark : colors.caju.light)
        .scale
        .step(12),
    UiTokens.errorA7: (theme.isDark ? colors.caju.dark : colors.caju.light)
        .scale
        .alphaStep(7),
    ..._accentColorTokens(tokens),
    // Gray steps
    UiTokens.gray1: tokens.gray.scale.step(1),
    UiTokens.gray2: tokens.gray.scale.step(2),
    UiTokens.gray3: tokens.gray.scale.step(3),
    UiTokens.gray4: tokens.gray.scale.step(4),
    UiTokens.gray5: tokens.gray.scale.step(5),
    UiTokens.gray6: tokens.gray.scale.step(6),
    UiTokens.gray7: tokens.gray.scale.step(7),
    UiTokens.gray8: tokens.gray.scale.step(8),
    UiTokens.gray9: tokens.gray.scale.step(9),
    UiTokens.gray10: tokens.gray.scale.step(10),
    UiTokens.gray11: tokens.gray.scale.step(11),
    UiTokens.gray12: tokens.gray.scale.step(12),
    // Gray role tokens (from resolved colors)
    UiTokens.graySurface: tokens.gray.surface,
    UiTokens.grayIndicator: tokens.gray.indicator,
    UiTokens.grayTrack: tokens.gray.track,
    UiTokens.grayContrast: tokens.gray.contrast,
    // Gray alpha a1..a12
    UiTokens.grayA1: tokens.gray.scale.alphaStep(1),
    UiTokens.grayA2: tokens.gray.scale.alphaStep(2),
    UiTokens.grayA3: tokens.gray.scale.alphaStep(3),
    UiTokens.grayA4: tokens.gray.scale.alphaStep(4),
    UiTokens.grayA5: tokens.gray.scale.alphaStep(5),
    UiTokens.grayA6: tokens.gray.scale.alphaStep(6),
    UiTokens.grayA7: tokens.gray.scale.alphaStep(7),
    UiTokens.grayA8: tokens.gray.scale.alphaStep(8),
    UiTokens.grayA9: tokens.gray.scale.alphaStep(9),
    UiTokens.grayA10: tokens.gray.scale.alphaStep(10),
    UiTokens.grayA11: tokens.gray.scale.alphaStep(11),
    UiTokens.grayA12: tokens.gray.scale.alphaStep(12),
    // Neutral helpers derived from primitives
    UiTokens.blackA1: tokens.blackAlpha[1]!,
    UiTokens.blackA2: tokens.blackAlpha[2]!,
    UiTokens.blackA3: tokens.blackAlpha[3]!,
    UiTokens.blackA4: tokens.blackAlpha[4]!,
    UiTokens.blackA5: tokens.blackAlpha[5]!,
    UiTokens.blackA6: tokens.blackAlpha[6]!,
    UiTokens.blackA7: tokens.blackAlpha[7]!,
    UiTokens.blackA8: tokens.blackAlpha[8]!,
    UiTokens.blackA9: tokens.blackAlpha[9]!,
    UiTokens.blackA10: tokens.blackAlpha[10]!,
    UiTokens.blackA11: tokens.blackAlpha[11]!,
    UiTokens.blackA12: tokens.blackAlpha[12]!,
    UiTokens.whiteA1: tokens.whiteAlpha[1]!,
    UiTokens.whiteA2: tokens.whiteAlpha[2]!,
    UiTokens.whiteA3: tokens.whiteAlpha[3]!,
    UiTokens.whiteA4: tokens.whiteAlpha[4]!,
    UiTokens.whiteA5: tokens.whiteAlpha[5]!,
    UiTokens.whiteA6: tokens.whiteAlpha[6]!,
    UiTokens.whiteA7: tokens.whiteAlpha[7]!,
    UiTokens.whiteA8: tokens.whiteAlpha[8]!,
    UiTokens.whiteA9: tokens.whiteAlpha[9]!,
    UiTokens.whiteA10: tokens.whiteAlpha[10]!,
    UiTokens.whiteA11: tokens.whiteAlpha[11]!,
    UiTokens.whiteA12: tokens.whiteAlpha[12]!,
    UiTokens.shadowStroke: tokens.shadowStroke,
    UiTokens.grayStroke3: mixOklabPremultiplied(
      tokens.gray.scale.alphaStep(3),
      tokens.gray.scale.step(3),
      0.25,
    ),
    UiTokens.grayStroke4: mixOklabPremultiplied(
      tokens.gray.scale.alphaStep(4),
      tokens.gray.scale.step(4),
      0.25,
    ),
    UiTokens.grayStroke5: mixOklabPremultiplied(
      tokens.gray.scale.alphaStep(5),
      tokens.gray.scale.step(5),
      0.25,
    ),
    UiTokens.grayStroke6: mixOklabPremultiplied(
      tokens.gray.scale.alphaStep(6),
      tokens.gray.scale.step(6),
      0.25,
    ),
    UiTokens.grayStroke7: mixOklabPremultiplied(
      tokens.gray.scale.alphaStep(7),
      tokens.gray.scale.step(7),
      0.25,
    ),
    UiTokens.dataTableBorder: mixOklabPremultiplied(
      tokens.gray.scale.alphaStep(5),
      tokens.gray.scale.step(6),
      0.5,
    ),
  };
  final allTokens = <MixToken<Object?>, Object>{
    ...colorTokens,
    UiTokens.panelBlur: theme.panelBackground == UiPanelBackground.translucent
        ? 64.0
        : 0.0,
    UiTokens.activityMaxHeight: 200.0 * scaling,
    UiTokens.dataTableSortIconSize1: 14.0 * scaling,
    UiTokens.dataTableSortIconSize3: 18.0 * scaling,
    UiTokens.planMaxHeight: 220.0 * scaling,
    UiTokens.messageAvatarSize: 28.0 * scaling,
    UiTokens.messageContentMaxWidth: 640.0 * scaling,
    UiTokens.messageCollapsedHeight: 72.0 * scaling,
    UiTokens.composerFieldMinHeight: 56.0 * scaling,
    UiTokens.touchTargetMin: 40.0 * math.max(1.0, scaling),
    UiTokens.sidebarDestinationMinHeight: 48.0 * math.max(1.0, scaling),
    UiTokens.popoverMaxWidth: 480.0 * scaling,
    UiTokens.dialogMaxWidth: 600.0 * scaling,
    UiTokens.toastMaxWidth: 360.0 * scaling,
    UiTokens.space1: 4.0 * scaling,
    UiTokens.space2: 8.0 * scaling,
    UiTokens.space3: 12.0 * scaling,
    UiTokens.space4: 16.0 * scaling,
    UiTokens.space5: 24.0 * scaling,
    UiTokens.space6: 32.0 * scaling,
    UiTokens.space7: 40.0 * scaling,
    UiTokens.space8: 48.0 * scaling,
    UiTokens.space9: 64.0 * scaling,
    UiTokens.spinnerSize3: 20.0 * scaling,
    UiTokens.avatarSize6: 80.0 * scaling,
    UiTokens.avatarSize7: 96.0 * scaling,
    UiTokens.avatarSize8: 128.0 * scaling,
    UiTokens.avatarSize9: 160.0 * scaling,
    UiTokens.avatarIconSize3: 20.0 * scaling,
    UiTokens.avatarIconSize9: 80.0 * scaling,
    UiTokens.badgePaddingY1: 2.0 * scaling,
    UiTokens.checkboxSize1: 14.0 * scaling,
    UiTokens.checkboxSize3: 20.0 * scaling,
    UiTokens.checkboxIndicatorSize1: 9.0 * scaling,
    UiTokens.checkboxIndicatorSize2: 10.0 * scaling,
    UiTokens.radioIndicatorSize1: 5.6 * scaling,
    UiTokens.radioIndicatorSize2: 6.4 * scaling,
    UiTokens.checkboxRadius1: _scaledRadiusToken(
      theme.radius,
      scaling,
      3.0 * 0.875,
    ),
    UiTokens.checkboxRadius3: _scaledRadiusToken(
      theme.radius,
      scaling,
      3.0 * 1.25,
    ),
    UiTokens.switchHeight2: 20.0 * scaling,
    UiTokens.switchWidth1: 28.0 * scaling,
    UiTokens.switchWidth2: 36.0 * scaling,
    UiTokens.switchWidth3: 44.0 * scaling,
    UiTokens.switchThumbSize1: 16.0 * scaling - 2.0,
    UiTokens.switchThumbSize2: 20.0 * scaling - 2.0,
    UiTokens.switchThumbSize3: 24.0 * scaling - 2.0,
    UiTokens.progressHeight2: 6.0 * scaling,
    UiTokens.sliderTrackSize1: 6.0 * scaling,
    UiTokens.sliderTrackSize3: 10.0 * scaling,
    UiTokens.sliderThumbSize1: 13.0 * scaling,
    UiTokens.sliderThumbSize3: 19.0 * scaling,
    UiTokens.textAreaMinHeight3: 80.0,
    UiTokens.dataListRowGap3: 20.0 * scaling,
    UiTokens.dataListLabelMinWidth: 120.0,
    UiTokens.tabInnerPaddingY1: 2.0 * scaling,
    UiTokens.tabActiveLetterSpacing1: -0.12 * scaling,
    UiTokens.tabActiveLetterSpacing2: -0.14 * scaling,
    UiTokens.selectIndicatorWidth1: 20.0 * scaling,
    UiTokens.selectIndicatorSize2: 10.0 * scaling,
    UiTokens.selectGhostMarginX12: -8.0 * scaling,
    UiTokens.selectGhostMarginY12: -4.0 * scaling,
    UiTokens.selectGhostMarginX3: -12.0 * scaling,
    UiTokens.selectGhostMarginY3: -6.0 * scaling,
    ..._radiusTokensFor(theme.radius, scaling),

    ...shadows,
    UiTokens.baseButtonGhostMarginX12: -8.0 * scaling,
    UiTokens.baseButtonGhostMarginY12: -4.0 * scaling,
    UiTokens.baseButtonGhostMarginX3: -12.0 * scaling,
    UiTokens.baseButtonGhostMarginY3: -8.0 * scaling,
    UiTokens.baseButtonGhostMarginX4: -16.0 * scaling,
    UiTokens.baseButtonGhostMarginY4: -8.0 * scaling,
    UiTokens.iconButtonGhostMargin1: -4.0 * scaling,
    UiTokens.iconButtonGhostMargin2: -8.0 * scaling,
    UiTokens.iconButtonGhostMargin3: -8.0 * scaling,
    UiTokens.iconButtonGhostMargin4: -12.0 * scaling,
    UiTokens.cardGhostMargin1: -12.0 * scaling,
    UiTokens.cardGhostMargin2: -16.0 * scaling,
    UiTokens.cardGhostMargin3: -24.0 * scaling,
    UiTokens.cardGhostMargin4: -32.0 * scaling,
    UiTokens.cardGhostMargin5: -48.0 * scaling,
    UiTokens.borderWidth1: 1.0,
    UiTokens.borderWidth2: 2.0,
    UiTokens.focusRingWidth: 2.0,
    UiTokens.focusRingOffset: 2.0,
    UiTokens.text1: TextStyle(
      fontSize: 12.0 * scaling,
      letterSpacing: 0.0025 * 12.0 * scaling,
      height: 16.0 / 12.0,
    ),
    UiTokens.text2: TextStyle(
      fontSize: 14.0 * scaling,
      letterSpacing: 0.0,
      height: 20.0 / 14.0,
    ),
    UiTokens.text3: TextStyle(
      fontSize: 16.0 * scaling,
      letterSpacing: 0.0,
      height: 24.0 / 16.0,
    ),
    UiTokens.text4: TextStyle(
      fontSize: 18.0 * scaling,
      letterSpacing: -0.0025 * 18.0 * scaling,
      height: 26.0 / 18.0,
    ),
    UiTokens.text5: TextStyle(
      fontSize: 20.0 * scaling,
      letterSpacing: -0.005 * 20.0 * scaling,
      height: 28.0 / 20.0,
    ),
    UiTokens.text6: TextStyle(
      fontSize: 24.0 * scaling,
      letterSpacing: -0.00625 * 24.0 * scaling,
      height: 30.0 / 24.0,
    ),
    UiTokens.text7: TextStyle(
      fontSize: 28.0 * scaling,
      letterSpacing: -0.0075 * 28.0 * scaling,
      height: 36.0 / 28.0,
    ),
    UiTokens.text8: TextStyle(
      fontSize: 36.0 * scaling,
      letterSpacing: -0.01 * 36.0 * scaling,
      height: 40.0 / 36.0,
    ),
    UiTokens.text9: TextStyle(
      fontSize: 60.0 * scaling,
      letterSpacing: -0.025 * 60.0 * scaling,
      height: 1.0,
    ),
    UiTokens.avatarFallback1One: _avatarFallbackText(
      fontSize: 14,
      letterSpacing: 0.0025 * 12,
      scaling: scaling,
    ),
    UiTokens.avatarFallback1Two: _avatarFallbackText(
      fontSize: 12,
      letterSpacing: 0.0025 * 12,
      scaling: scaling,
    ),
    UiTokens.avatarFallback2One: _avatarFallbackText(
      fontSize: 16,
      letterSpacing: 0,
      scaling: scaling,
    ),
    UiTokens.avatarFallback2Two: _avatarFallbackText(
      fontSize: 14,
      letterSpacing: 0,
      scaling: scaling,
    ),
    UiTokens.avatarFallback3One: _avatarFallbackText(
      fontSize: 18,
      letterSpacing: 0,
      scaling: scaling,
    ),
    UiTokens.avatarFallback3Two: _avatarFallbackText(
      fontSize: 16,
      letterSpacing: 0,
      scaling: scaling,
    ),
    UiTokens.avatarFallback4One: _avatarFallbackText(
      fontSize: 20,
      letterSpacing: -0.0025 * 18,
      scaling: scaling,
    ),
    UiTokens.avatarFallback4Two: _avatarFallbackText(
      fontSize: 18,
      letterSpacing: -0.0025 * 18,
      scaling: scaling,
    ),
    UiTokens.avatarFallback5: _avatarFallbackText(
      fontSize: 24,
      letterSpacing: -0.00625 * 24,
      scaling: scaling,
    ),
    UiTokens.avatarFallback6: _avatarFallbackText(
      fontSize: 28,
      letterSpacing: -0.0075 * 28,
      scaling: scaling,
    ),
    UiTokens.avatarFallback7: _avatarFallbackText(
      fontSize: 28,
      letterSpacing: -0.0075 * 28,
      scaling: scaling,
    ),
    UiTokens.avatarFallback8: _avatarFallbackText(
      fontSize: 36,
      letterSpacing: -0.01 * 36,
      scaling: scaling,
    ),
    UiTokens.avatarFallback9: _avatarFallbackText(
      fontSize: 60,
      letterSpacing: -0.025 * 60,
      scaling: scaling,
    ),

    // Font weights (token values)
    UiTokens.fontWeightLight: FontWeight.w300,
    UiTokens.fontWeightRegular: FontWeight.w400,
    UiTokens.fontWeightSemibold: FontWeight.w600,
    UiTokens.fontWeightMedium: FontWeight.w500,
    // Match Ui font weights (bold = 700)
    UiTokens.fontWeightBold: FontWeight.w700,

    // Durations (token values)
    UiTokens.transitionFast: const Duration(milliseconds: 100),
    UiTokens.transitionSlow: const Duration(milliseconds: 300),
    UiTokens.skeletonPulseDuration: const Duration(milliseconds: 1000),
  };

  return allTokens;
}

TextStyle _avatarFallbackText({
  required double fontSize,
  required double letterSpacing,
  required double scaling,
}) => TextStyle(
  fontSize: fontSize * scaling,
  letterSpacing: letterSpacing * scaling,
  height: 1,
);

Map<RadiusToken, Radius> _radiusTokensFor(UiRadius radius, double scaling) {
  final factor = _radiusFactor(radius);
  final thumb = switch (radius) {
    .none || .small => const Radius.circular(0.5),
    .medium || .large || .full => const Radius.circular(9999.0),
  };
  Radius scaled(double base) => Radius.circular(base * factor * scaling);
  Radius larger(Radius first, Radius second) => Radius.elliptical(
    first.x > second.x ? first.x : second.x,
    first.y > second.y ? first.y : second.y,
  );
  final radius1 = scaled(3.0);
  final radius2 = scaled(4.0);
  final radius3 = scaled(6.0);
  final radius4 = scaled(8.0);
  final radius5 = scaled(12.0);
  final radius6 = scaled(16.0);
  final full = radius == .full ? const Radius.circular(9999.0) : Radius.zero;
  Radius progressRadius(double height) {
    final thumbBase = switch (radius) {
      .none || .small => 0.5,
      .medium || .large || .full => 9999.0,
    };
    return Radius.circular(math.max(factor * height / 3, factor * thumbBase));
  }

  return {
    UiTokens.radius1: radius1,
    UiTokens.radius2: radius2,
    UiTokens.radius3: radius3,
    UiTokens.radius4: radius4,
    UiTokens.radius5: radius5,
    UiTokens.radius6: radius6,
    UiTokens.radiusFull: full,
    UiTokens.radiusThumb: thumb,
    UiTokens.radiusCircle: const Radius.circular(9999.0),
    UiTokens.radius1OrFull: larger(radius1, full),
    UiTokens.radius2OrFull: larger(radius2, full),
    UiTokens.radius3OrFull: larger(radius3, full),
    UiTokens.radius4OrFull: larger(radius4, full),
    UiTokens.radius5OrFull: larger(radius5, full),
    UiTokens.radius6OrFull: larger(radius6, full),
    UiTokens.radius1OrThumb: larger(radius1, thumb),
    UiTokens.radius2OrThumb: larger(radius2, thumb),
    UiTokens.progressRadius1: progressRadius(4.0 * scaling),
    UiTokens.progressRadius2: progressRadius(6.0 * scaling),
    UiTokens.progressRadius3: progressRadius(8.0 * scaling),
    UiTokens.sliderTrackRadius1: progressRadius(6.0 * scaling),
    UiTokens.sliderTrackRadius2: progressRadius(8.0 * scaling),
    UiTokens.sliderTrackRadius3: progressRadius(10.0 * scaling),
  };
}

double _radiusFactor(UiRadius radius) => switch (radius) {
  .none => 0.0,
  .small => 0.75,
  .medium => 1.0,
  .large || .full => 1.5,
};

Radius _scaledRadiusToken(UiRadius radius, double scaling, double base) =>
    Radius.circular(base * scaling * _radiusFactor(radius));

Map<ColorToken, Color> _accentColorTokens(UiThemeColors tokens) {
  final scale = tokens.accent.scale;

  return {
    UiTokens.accentSurface: tokens.accent.surface,
    UiTokens.accentIndicator: tokens.accent.indicator,
    UiTokens.accentTrack: tokens.accent.track,
    UiTokens.accentContrast: tokens.accent.contrast,
    UiTokens.focus8: tokens.focus8,
    UiTokens.focusA5: tokens.focusA5,
    UiTokens.focusA8: tokens.focusA8,
    UiTokens.accent1: scale.step(1),
    UiTokens.accent2: scale.step(2),
    UiTokens.accent3: scale.step(3),
    UiTokens.accent4: scale.step(4),
    UiTokens.accent5: scale.step(5),
    UiTokens.accent6: scale.step(6),
    UiTokens.accent7: scale.step(7),
    UiTokens.accent8: scale.step(8),
    UiTokens.accent9: scale.step(9),
    UiTokens.accent10: scale.step(10),
    UiTokens.accent11: scale.step(11),
    UiTokens.accent12: scale.step(12),
    UiTokens.accentA1: scale.alphaStep(1),
    UiTokens.accentA2: scale.alphaStep(2),
    UiTokens.accentA3: scale.alphaStep(3),
    UiTokens.accentA4: scale.alphaStep(4),
    UiTokens.accentA5: scale.alphaStep(5),
    UiTokens.accentA6: scale.alphaStep(6),
    UiTokens.accentA7: scale.alphaStep(7),
    UiTokens.accentA8: scale.alphaStep(8),
    UiTokens.accentA9: scale.alphaStep(9),
    UiTokens.accentA10: scale.alphaStep(10),
    UiTokens.accentA11: scale.alphaStep(11),
    UiTokens.accentA12: scale.alphaStep(12),
  };
}
