import 'dart:ui' show ColorSpace;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import 'color.dart';
import 'effects.dart';
import 'tokens.dart';

enum DeuiThemeMode { system, light, dark }

/// The Deui web theme for one brightness.
///
/// As with Deui's CSS variables, any color can be overridden in [colors],
/// and the colors derived from it follow: overriding
/// [DeuiTokens.accent] also changes its hover and soft shades.
@immutable
class DeuiThemeData {
  const DeuiThemeData({
    required this.brightness,
    this.colors = const {},
    this.radius = 12,
    this.fontFamily = RemixFonts.geist,
  });

  const DeuiThemeData.light({
    this.colors = const {},
    this.radius = 12,
    this.fontFamily = RemixFonts.geist,
  }) : brightness = Brightness.light;

  const DeuiThemeData.dark({
    this.colors = const {},
    this.radius = 12,
    this.fontFamily = RemixFonts.geist,
  }) : brightness = Brightness.dark;

  final Brightness brightness;

  /// Color overrides, keyed by the token they replace.
  final Map<ColorToken, Color> colors;

  /// The base radius; the radius scale is derived from it. Deui uses 12.
  final double radius;

  /// The font family: Geist, which `remix_ui_fonts` bundles.
  final String? fontFamily;

  /// The resolved color for [token], in extended sRGB.
  Color color(ColorToken token) => _resolve(token, {});

  Color _resolve(ColorToken token, Map<ColorToken, Color> resolved) =>
      resolved[token] ??=
          colors[token] ??
          switch (_definition(token)) {
            final _Value value => value.color,
            _Alias(:final source) => _resolve(source, resolved),
            final _Mix mix => deuiMixOklab(
              _resolve(mix.first, resolved),
              _resolve(mix.second, resolved),
              mix.firstAmount,
              mix.secondAmount,
            ),
            _Fade(:final source, :final amount) => _faded(
              _resolve(source, resolved),
              amount,
            ),
          };

  /// The formula of [deuiAlpha], on a resolved color.
  static Color _faded(Color color, double amount) =>
      color.withValues(alpha: color.a * amount);

  Map<ColorToken, _Color> get _modeColors =>
      brightness == Brightness.dark ? _dark : _light;

  _Color _definition(ColorToken token) =>
      _modeColors[token] ??
      _shared[token] ??
      (throw ArgumentError.value(token, 'token', 'Not a Deui color token'));

  TextStyle _text(double size, double lineHeight) => TextStyle(
    fontFamily: fontFamily,
    fontSize: size,
    height: lineHeight / size,
    leadingDistribution: TextLeadingDistribution.even,
  );

  Map<MixToken<Object?>, Object> get tokens {
    final resolved = <ColorToken, Color>{};
    return Map<MixToken<Object?>, Object>.unmodifiable({
      for (final token in [..._shared.keys, ..._modeColors.keys])
        token: deuiPaintColor(_resolve(token, resolved)),
      deuiSurfaceShadow: deuiShadows(brightness),
      deuiOverlayShadow: deuiShadows(brightness, overlay: true),
      DeuiTokens.radiusXs: Radius.circular(radius * 0.25),
      DeuiTokens.radiusSm: Radius.circular(radius * 0.5),
      DeuiTokens.radiusMd: Radius.circular(radius * 0.75),
      DeuiTokens.radiusLg: Radius.circular(radius),
      DeuiTokens.radiusXl: Radius.circular(radius * 1.5),
      DeuiTokens.radius2xl: Radius.circular(radius * 2),
      DeuiTokens.radius3xl: Radius.circular(radius * 3),
      DeuiTokens.radius4xl: Radius.circular(radius * 4),
      DeuiTokens.radiusField: Radius.circular(radius * 1.5),
      DeuiTokens.radiusPanel: Radius.circular(radius * 4 / 3),
      DeuiTokens.textXs: _text(12, 16),
      DeuiTokens.textSm: _text(14, 20),
      DeuiTokens.textBase: _text(16, 24),
    });
  }

  /// A copy with the given fields; [colors] are merged into the existing
  /// overrides.
  DeuiThemeData copyWith({
    Brightness? brightness,
    Map<ColorToken, Color>? colors,
    double? radius,
    String? fontFamily,
  }) => DeuiThemeData(
    brightness: brightness ?? this.brightness,
    colors: colors == null ? this.colors : {...this.colors, ...colors},
    radius: radius ?? this.radius,
    fontFamily: fontFamily ?? this.fontFamily,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeuiThemeData &&
          brightness == other.brightness &&
          radius == other.radius &&
          fontFamily == other.fontFamily &&
          mapEquals(colors, other.colors);

  @override
  int get hashCode => Object.hash(
    brightness,
    radius,
    fontFamily,
    Object.hashAllUnordered(
      colors.entries.map((entry) => Object.hash(entry.key, entry.value)),
    ),
  );
}

/// How the pinned theme defines one color variable.
sealed class _Color {
  const _Color();
}

/// A literal value, in extended sRGB.
final class _Value extends _Color {
  const _Value(this.red, this.green, this.blue, [this.alpha = 1]);
  final double red, green, blue, alpha;

  /// A literal from a `0xAARRGGBB` value, read as sRGB.
  const _Value.argb(int value)
    : red = ((value >> 16) & 0xFF) / 255,
      green = ((value >> 8) & 0xFF) / 255,
      blue = (value & 0xFF) / 255,
      alpha = ((value >> 24) & 0xFF) / 255;

  Color get color => Color.from(
    alpha: alpha,
    red: red,
    green: green,
    blue: blue,
    colorSpace: ColorSpace.extendedSRGB,
  );
}

/// `var(--source)`.
final class _Alias extends _Color {
  const _Alias(this.source);
  final ColorToken source;
}

/// `color-mix(in oklab, first firstAmount, second secondAmount)`.
final class _Mix extends _Color {
  const _Mix(this.first, this.firstAmount, this.second, this.secondAmount);
  final ColorToken first, second;
  final double firstAmount, secondAmount;
}

/// `color-mix(in oklab, source amount, transparent)`.
final class _Fade extends _Color {
  const _Fade(this.source, this.amount);
  final ColorToken source;
  final double amount;
}

// Deui's light and dark values. Entries both modes share are in [_shared].

final _shared = <ColorToken, _Color>{
  DeuiTokens.white: const _Value(1, 1, 1),
  DeuiTokens.black: const _Value(0, 0, 0),
  DeuiTokens.snow: const _Value.argb(0xFFF2F2F2),
  DeuiTokens.eclipse: const _Value.argb(0xFF0B0B0B),
  // Deui's `primary`: the blue that fills the main action and the selection.
  DeuiTokens.accent: const _Value.argb(0xFF0276DB),
  DeuiTokens.accentForeground: const _Value(1, 1, 1),
  DeuiTokens.success: const _Value.argb(0xFF00BD6C),
  DeuiTokens.successForeground: const _Alias(DeuiTokens.eclipse),
  DeuiTokens.warning: const _Value.argb(0xFFF5A500),
  DeuiTokens.warningForeground: const _Alias(DeuiTokens.eclipse),
  DeuiTokens.danger: const _Value.argb(0xFFEE343B),
  DeuiTokens.dangerForeground: const _Value(1, 1, 1),
  DeuiTokens.surfaceForeground: const _Alias(DeuiTokens.foreground),
  DeuiTokens.surfaceSecondaryForeground: const _Alias(DeuiTokens.foreground),
  DeuiTokens.surfaceTertiaryForeground: const _Alias(DeuiTokens.foreground),
  DeuiTokens.overlayForeground: const _Alias(DeuiTokens.foreground),
  DeuiTokens.fieldBackground: const _Value(0, 0, 0, 0),
  DeuiTokens.fieldForeground: const _Alias(DeuiTokens.foreground),
  DeuiTokens.fieldPlaceholder: const _Fade(DeuiTokens.muted, 0.6),
  DeuiTokens.focus: const _Alias(DeuiTokens.accent),
  DeuiTokens.link: const _Alias(DeuiTokens.foreground),
  DeuiTokens.defaultForeground: const _Alias(DeuiTokens.foreground),
  DeuiTokens.separator: const _Alias(DeuiTokens.border),
  DeuiTokens.backgroundInverse: const _Alias(DeuiTokens.foreground),
  DeuiTokens.surfaceHover: const _Fade(DeuiTokens.surfaceSecondary, 0.6),
  DeuiTokens.backgroundSecondary: const _Alias(DeuiTokens.surfaceSecondary),
  DeuiTokens.backgroundTertiary: const _Alias(DeuiTokens.surfaceSecondary),
  // Hovered fills: deui's primary at 90%, a quiet surface at 60%.
  DeuiTokens.defaultHover: const _Fade(DeuiTokens.defaultColor, 0.6),
  DeuiTokens.accentHover: const _Fade(DeuiTokens.accent, 0.9),
  DeuiTokens.successHover: const _Fade(DeuiTokens.success, 0.9),
  DeuiTokens.warningHover: const _Fade(DeuiTokens.warning, 0.9),
  DeuiTokens.dangerHover: const _Fade(DeuiTokens.danger, 0.9),
  DeuiTokens.fieldHover: const _Fade(DeuiTokens.surfaceSecondary, 0.6),
  DeuiTokens.fieldFocus: const _Value(0, 0, 0, 0),
  // Deui's field edge: the 1px `border`, then `text` at 40% while focused.
  DeuiTokens.fieldBorderHover: const _Alias(DeuiTokens.fieldBorder),
  DeuiTokens.fieldBorderFocus: const _Fade(DeuiTokens.foreground, 0.4),
  // Soft fills are deui's 10 to 12% tints of the status color.
  DeuiTokens.defaultSoft: const _Alias(DeuiTokens.defaultColor),
  DeuiTokens.defaultSoftForeground: const _Alias(DeuiTokens.foreground),
  DeuiTokens.defaultSoftHover: const _Fade(DeuiTokens.defaultColor, 0.6),
  DeuiTokens.accentSoft: const _Fade(DeuiTokens.accent, 0.12),
  DeuiTokens.accentSoftForeground: const _Alias(DeuiTokens.accent),
  DeuiTokens.accentSoftHover: const _Fade(DeuiTokens.accent, 0.16),
  DeuiTokens.dangerSoft: const _Fade(DeuiTokens.danger, 0.12),
  DeuiTokens.dangerSoftForeground: const _Alias(DeuiTokens.danger),
  DeuiTokens.dangerSoftHover: const _Fade(DeuiTokens.danger, 0.16),
  DeuiTokens.warningSoft: const _Fade(DeuiTokens.warning, 0.12),
  DeuiTokens.warningSoftHover: const _Fade(DeuiTokens.warning, 0.16),
  DeuiTokens.successSoft: const _Fade(DeuiTokens.success, 0.12),
  DeuiTokens.successSoftHover: const _Fade(DeuiTokens.success, 0.16),
  DeuiTokens.separatorSecondary: const _Alias(DeuiTokens.fieldBorder),
  DeuiTokens.separatorTertiary: const _Alias(DeuiTokens.fieldBorder),
  DeuiTokens.borderSecondary: const _Alias(DeuiTokens.fieldBorder),
  DeuiTokens.borderTertiary: const _Alias(DeuiTokens.fieldBorder),
  // The segmented selection is the primary pill.
  DeuiTokens.segment: const _Alias(DeuiTokens.accent),
  DeuiTokens.segmentForeground: const _Alias(DeuiTokens.accentForeground),
  // Deui's teal `accent`.
  DeuiTokens.highlightForeground: const _Alias(DeuiTokens.eclipse),
};

final _light = <ColorToken, _Color>{
  DeuiTokens.background: const _Value.argb(0xFFFCFCFC),
  DeuiTokens.foreground: const _Alias(DeuiTokens.eclipse),
  DeuiTokens.surface: const _Value.argb(0xFFFCFCFC),
  DeuiTokens.surfaceSecondary: const _Value.argb(0xFFF5F5F5),
  DeuiTokens.surfaceTertiary: const _Value.argb(0xFFF5F5F5),
  DeuiTokens.overlay: const _Value.argb(0xFFF5F5F5),
  DeuiTokens.muted: const _Value.argb(0xFF636363),
  DeuiTokens.defaultColor: const _Value.argb(0xFFF5F5F5),
  DeuiTokens.border: const _Value.argb(0x0F0B0B0B),
  DeuiTokens.fieldBorder: const _Value.argb(0x1F0B0B0B),
  DeuiTokens.backdrop: const _Value.argb(0x1A0B0B0B),
  DeuiTokens.highlight: const _Value.argb(0xFF00BEBF),
  DeuiTokens.warningSoftForeground: const _Value.argb(0xFFAF4C00),
  DeuiTokens.successSoftForeground: const _Value.argb(0xFF007452),
};

final _dark = <ColorToken, _Color>{
  DeuiTokens.background: const _Value.argb(0xFF151515),
  DeuiTokens.foreground: const _Alias(DeuiTokens.snow),
  DeuiTokens.surface: const _Value.argb(0xFF151515),
  DeuiTokens.surfaceSecondary: const _Value.argb(0xFF1C1C1C),
  DeuiTokens.surfaceTertiary: const _Value.argb(0xFF1C1C1C),
  DeuiTokens.overlay: const _Value.argb(0xFF1C1C1C),
  DeuiTokens.muted: const _Value.argb(0xFF868686),
  DeuiTokens.defaultColor: const _Value.argb(0xFF1C1C1C),
  DeuiTokens.border: const _Value.argb(0x0DFFFFFF),
  DeuiTokens.fieldBorder: const _Value.argb(0x1AFFFFFF),
  DeuiTokens.backdrop: const _Value.argb(0x1AF2F2F2),
  DeuiTokens.highlight: const _Value.argb(0xFF00DADB),
  DeuiTokens.warningSoftForeground: const _Value.argb(0xFFFFD236),
  DeuiTokens.successSoftForeground: const _Value.argb(0xFF5EE9B5),
};
