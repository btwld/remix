import 'dart:ui' show ColorSpace;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'color.dart';
import 'effects.dart';
import 'tokens.dart';

enum HeroUiThemeMode { system, light, dark }

/// The HeroUI web theme for one brightness.
///
/// As with HeroUI's CSS variables, any color can be overridden in [colors],
/// and the colors derived from it follow: overriding
/// [HeroUiTokens.accent] also changes its hover and soft shades.
@immutable
class HeroUiThemeData {
  const HeroUiThemeData({
    required this.brightness,
    this.colors = const {},
    this.radius = 8,
    this.fontFamily,
  });

  const HeroUiThemeData.light({
    this.colors = const {},
    this.radius = 8,
    this.fontFamily,
  }) : brightness = Brightness.light;

  const HeroUiThemeData.dark({
    this.colors = const {},
    this.radius = 8,
    this.fontFamily,
  }) : brightness = Brightness.dark;

  final Brightness brightness;

  /// Color overrides, keyed by the token they replace.
  final Map<ColorToken, Color> colors;

  /// The base radius (`--radius`); the radius scale is derived from it.
  final double radius;

  /// The font family; null uses the platform default, like the web theme.
  final String? fontFamily;

  /// The resolved color for [token], in extended sRGB.
  Color color(ColorToken token) => _resolve(token, {});

  Color _resolve(ColorToken token, Map<ColorToken, Color> resolved) =>
      resolved[token] ??=
          colors[token] ??
          switch (_definition(token)) {
            final _Value value => value.color,
            _Alias(:final source) => _resolve(source, resolved),
            final _Mix mix => heroUiMixOklab(
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

  /// The formula of [heroUiAlpha], on a resolved color.
  static Color _faded(Color color, double amount) =>
      color.withValues(alpha: color.a * amount);

  Map<ColorToken, _Color> get _modeColors =>
      brightness == Brightness.dark ? _dark : _light;

  _Color _definition(ColorToken token) =>
      _modeColors[token] ??
      _shared[token] ??
      (throw ArgumentError.value(token, 'token', 'Not a HeroUI color token'));

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
        token: heroUiPaintColor(_resolve(token, resolved)),
      heroUiSurfaceShadow: heroUiShadows(brightness),
      heroUiOverlayShadow: heroUiShadows(brightness, overlay: true),
      HeroUiTokens.radiusXs: Radius.circular(radius * 0.25),
      HeroUiTokens.radiusSm: Radius.circular(radius * 0.5),
      HeroUiTokens.radiusMd: Radius.circular(radius * 0.75),
      HeroUiTokens.radiusLg: Radius.circular(radius),
      HeroUiTokens.radiusXl: Radius.circular(radius * 1.5),
      HeroUiTokens.radius2xl: Radius.circular(radius * 2),
      HeroUiTokens.radius3xl: Radius.circular(radius * 3),
      HeroUiTokens.radius4xl: Radius.circular(radius * 4),
      HeroUiTokens.radiusField: Radius.circular(radius * 1.5),
      HeroUiTokens.radiusPanel: Radius.circular((radius * 3).clamp(0, 32)),
      HeroUiTokens.textXs: _text(12, 16),
      HeroUiTokens.textSm: _text(14, 20),
      HeroUiTokens.textBase: _text(16, 24),
    });
  }

  /// A copy with the given fields; [colors] are merged into the existing
  /// overrides.
  HeroUiThemeData copyWith({
    Brightness? brightness,
    Map<ColorToken, Color>? colors,
    double? radius,
    String? fontFamily,
  }) => HeroUiThemeData(
    brightness: brightness ?? this.brightness,
    colors: colors == null ? this.colors : {...this.colors, ...colors},
    radius: radius ?? this.radius,
    fontFamily: fontFamily ?? this.fontFamily,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeroUiThemeData &&
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

// The pinned light and dark values. Entries both modes share are in [_shared].

final _shared = <ColorToken, _Color>{
  HeroUiTokens.white: const _Value(1, 1, 1),
  HeroUiTokens.black: const _Value(0, 0, 0),
  HeroUiTokens.snow: const _Value(0.98827621144, 0.98827621144, 0.98827621144),
  HeroUiTokens.eclipse: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  HeroUiTokens.accent: const _Value(
    0.016599386401,
    0.521575639857,
    0.968539356408,
  ),
  HeroUiTokens.accentForeground: const _Alias(HeroUiTokens.snow),
  HeroUiTokens.success: const _Value(
    0.089664996069,
    0.788191649728,
    0.391964351272,
  ),
  HeroUiTokens.successForeground: const _Alias(HeroUiTokens.eclipse),
  HeroUiTokens.fieldBorder: const _Value(0, 0, 0, 0),
  HeroUiTokens.surfaceForeground: const _Alias(HeroUiTokens.foreground),
  HeroUiTokens.surfaceSecondaryForeground: const _Alias(
    HeroUiTokens.foreground,
  ),
  HeroUiTokens.surfaceTertiaryForeground: const _Alias(HeroUiTokens.foreground),
  HeroUiTokens.overlayForeground: const _Alias(HeroUiTokens.foreground),
  HeroUiTokens.fieldPlaceholder: const _Alias(HeroUiTokens.muted),
  HeroUiTokens.warningForeground: const _Alias(HeroUiTokens.eclipse),
  HeroUiTokens.dangerForeground: const _Alias(HeroUiTokens.snow),
  HeroUiTokens.focus: const _Alias(HeroUiTokens.accent),
  HeroUiTokens.link: const _Alias(HeroUiTokens.foreground),
  HeroUiTokens.surfaceHover: const _Mix(
    HeroUiTokens.surface,
    0.92,
    HeroUiTokens.surfaceForeground,
    0.08,
  ),
  HeroUiTokens.backgroundSecondary: const _Mix(
    HeroUiTokens.background,
    0.96,
    HeroUiTokens.foreground,
    0.04,
  ),
  HeroUiTokens.backgroundTertiary: const _Mix(
    HeroUiTokens.background,
    0.92,
    HeroUiTokens.foreground,
    0.08,
  ),
  HeroUiTokens.backgroundInverse: const _Alias(HeroUiTokens.foreground),
  HeroUiTokens.defaultHover: const _Mix(
    HeroUiTokens.defaultColor,
    0.96,
    HeroUiTokens.defaultForeground,
    0.04,
  ),
  HeroUiTokens.accentHover: const _Mix(
    HeroUiTokens.accent,
    0.9,
    HeroUiTokens.accentForeground,
    0.1,
  ),
  HeroUiTokens.successHover: const _Mix(
    HeroUiTokens.success,
    0.9,
    HeroUiTokens.successForeground,
    0.1,
  ),
  HeroUiTokens.warningHover: const _Mix(
    HeroUiTokens.warning,
    0.9,
    HeroUiTokens.warningForeground,
    0.1,
  ),
  HeroUiTokens.dangerHover: const _Mix(
    HeroUiTokens.danger,
    0.9,
    HeroUiTokens.dangerForeground,
    0.1,
  ),
  HeroUiTokens.fieldHover: const _Mix(
    HeroUiTokens.fieldBackground,
    0.9,
    HeroUiTokens.fieldForeground,
    0.02,
  ),
  HeroUiTokens.fieldFocus: const _Alias(HeroUiTokens.fieldBackground),
  HeroUiTokens.fieldBorderHover: const _Mix(
    HeroUiTokens.fieldBorder,
    0.88,
    HeroUiTokens.fieldForeground,
    0.1,
  ),
  HeroUiTokens.fieldBorderFocus: const _Mix(
    HeroUiTokens.fieldBorder,
    0.74,
    HeroUiTokens.fieldForeground,
    0.22,
  ),
  HeroUiTokens.defaultSoft: const _Fade(HeroUiTokens.defaultColor, 0.5),
  HeroUiTokens.defaultSoftForeground: const _Alias(
    HeroUiTokens.defaultForeground,
  ),
  HeroUiTokens.defaultSoftHover: const _Fade(HeroUiTokens.defaultColor, 0.6),
  HeroUiTokens.dangerSoft: const _Fade(HeroUiTokens.danger, 0.15),
  HeroUiTokens.dangerSoftHover: const _Fade(HeroUiTokens.danger, 0.2),
  HeroUiTokens.separatorSecondary: const _Mix(
    HeroUiTokens.surface,
    0.85,
    HeroUiTokens.surfaceForeground,
    0.15,
  ),
  HeroUiTokens.separatorTertiary: const _Mix(
    HeroUiTokens.surface,
    0.81,
    HeroUiTokens.surfaceForeground,
    0.19,
  ),
  HeroUiTokens.borderSecondary: const _Mix(
    HeroUiTokens.surface,
    0.78,
    HeroUiTokens.surfaceForeground,
    0.22,
  ),
  HeroUiTokens.borderTertiary: const _Mix(
    HeroUiTokens.surface,
    0.66,
    HeroUiTokens.surfaceForeground,
    0.34,
  ),
};

final _light = <ColorToken, _Color>{
  HeroUiTokens.background: const _Value(
    0.960848742889,
    0.960848742889,
    0.960848742889,
  ),
  HeroUiTokens.foreground: const _Alias(HeroUiTokens.eclipse),
  HeroUiTokens.surface: const _Alias(HeroUiTokens.white),
  HeroUiTokens.surfaceSecondary: const _Value(
    0.937246270389,
    0.937246677125,
    0.941076636306,
  ),
  HeroUiTokens.surfaceTertiary: const _Value(
    0.917615049746,
    0.917615421946,
    0.921430086967,
  ),
  HeroUiTokens.overlay: const _Alias(HeroUiTokens.white),
  HeroUiTokens.muted: const _Value(
    0.443180480717,
    0.443179510042,
    0.478454780564,
  ),
  HeroUiTokens.defaultColor: const _Value(
    0.921202232145,
    0.921202572913,
    0.924139298588,
  ),
  HeroUiTokens.defaultForeground: const _Alias(HeroUiTokens.eclipse),
  HeroUiTokens.fieldBackground: const _Alias(HeroUiTokens.white),
  HeroUiTokens.fieldForeground: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  HeroUiTokens.warning: const _Value(
    0.960862691028,
    0.647060340432,
    0.140737468328,
  ),
  HeroUiTokens.danger: const _Value(
    0.999971088218,
    0.219686825893,
    0.235328592909,
  ),
  HeroUiTokens.segment: const _Alias(HeroUiTokens.white),
  HeroUiTokens.segmentForeground: const _Alias(HeroUiTokens.eclipse),
  HeroUiTokens.border: const _Value(
    0.868722602176,
    0.868722346034,
    0.88033180369,
  ),
  HeroUiTokens.separator: const _Value(
    0.894476722055,
    0.894476909435,
    0.906150621742,
  ),
  HeroUiTokens.backdrop: const _Value(0, 0, 0, 0.5),
  HeroUiTokens.accentSoft: const _Fade(HeroUiTokens.accent, 0.15),
  HeroUiTokens.accentSoftForeground: const _Mix(
    HeroUiTokens.accent,
    0.7,
    HeroUiTokens.foreground,
    0.3,
  ),
  HeroUiTokens.accentSoftHover: const _Fade(HeroUiTokens.accent, 0.2),
  HeroUiTokens.dangerSoftForeground: const _Mix(
    HeroUiTokens.danger,
    0.7,
    HeroUiTokens.foreground,
    0.4,
  ),
  HeroUiTokens.warningSoft: const _Fade(HeroUiTokens.warning, 0.15),
  HeroUiTokens.warningSoftForeground: const _Mix(
    HeroUiTokens.warning,
    0.8,
    HeroUiTokens.foreground,
    0.7,
  ),
  HeroUiTokens.warningSoftHover: const _Fade(HeroUiTokens.warning, 0.2),
  HeroUiTokens.successSoft: const _Fade(HeroUiTokens.success, 0.15),
  HeroUiTokens.successSoftForeground: const _Mix(
    HeroUiTokens.success,
    0.8,
    HeroUiTokens.foreground,
    0.6,
  ),
  HeroUiTokens.successSoftHover: const _Fade(HeroUiTokens.success, 0.2),
};

final _dark = <ColorToken, _Color>{
  HeroUiTokens.background: const _Value(
    0.021721668644,
    0.021694641315,
    0.028367428378,
  ),
  HeroUiTokens.foreground: const _Alias(HeroUiTokens.snow),
  HeroUiTokens.surface: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  HeroUiTokens.surfaceSecondary: const _Value(
    0.137298776397,
    0.137298175769,
    0.145129288645,
  ),
  HeroUiTokens.surfaceTertiary: const _Value(
    0.148958220597,
    0.152957908125,
    0.156957042474,
  ),
  HeroUiTokens.overlay: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  HeroUiTokens.muted: const _Value(
    0.622613326062,
    0.622561559954,
    0.663359592742,
  ),
  HeroUiTokens.defaultColor: const _Value(
    0.152896916541,
    0.152886847966,
    0.165770247859,
  ),
  HeroUiTokens.defaultForeground: const _Alias(HeroUiTokens.snow),
  HeroUiTokens.fieldBackground: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  HeroUiTokens.fieldForeground: const _Alias(HeroUiTokens.foreground),
  HeroUiTokens.warning: const _Value(
    0.96853134062,
    0.717603534283,
    0.313834331729,
  ),
  HeroUiTokens.danger: const _Value(
    0.858874269843,
    0.23142924586,
    0.243164089044,
  ),
  HeroUiTokens.segment: const _Value(
    0.274530316512,
    0.27453274061,
    0.298065873958,
  ),
  HeroUiTokens.segmentForeground: const _Alias(HeroUiTokens.foreground),
  HeroUiTokens.border: const _Value(
    0.158629492281,
    0.158621840467,
    0.171576396427,
  ),
  HeroUiTokens.separator: const _Value(
    0.130286883764,
    0.130266259359,
    0.142852661978,
  ),
  HeroUiTokens.backdrop: const _Value(0, 0, 0, 0.6),
  HeroUiTokens.accentSoft: const _Fade(HeroUiTokens.accent, 0.12),
  HeroUiTokens.accentSoftForeground: const _Mix(
    HeroUiTokens.accent,
    0.8,
    HeroUiTokens.foreground,
    0.3,
  ),
  HeroUiTokens.accentSoftHover: const _Fade(HeroUiTokens.accent, 0.16),
  HeroUiTokens.dangerSoftForeground: const _Mix(
    HeroUiTokens.danger,
    0.8,
    HeroUiTokens.foreground,
    0.3,
  ),
  HeroUiTokens.warningSoft: const _Fade(HeroUiTokens.warning, 0.12),
  HeroUiTokens.warningSoftForeground: const _Mix(
    HeroUiTokens.warning,
    0.8,
    HeroUiTokens.foreground,
    0.3,
  ),
  HeroUiTokens.warningSoftHover: const _Fade(HeroUiTokens.warning, 0.16),
  HeroUiTokens.successSoft: const _Fade(HeroUiTokens.success, 0.12),
  HeroUiTokens.successSoftForeground: const _Mix(
    HeroUiTokens.success,
    0.8,
    HeroUiTokens.foreground,
    0.3,
  ),
  HeroUiTokens.successSoftHover: const _Fade(HeroUiTokens.success, 0.16),
};
