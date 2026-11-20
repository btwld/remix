import 'dart:ui' show ColorSpace;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'color.dart';
import 'effects.dart';
import 'tokens.dart';

enum UiThemeMode { system, light, dark }

/// The HeroUI web theme for one brightness.
///
/// As with HeroUI's CSS variables, any color can be overridden in [colors],
/// and the colors derived from it follow: overriding
/// [UiTokens.accent] also changes its hover and soft shades.
@immutable
class UiThemeData {
  const UiThemeData({
    required this.brightness,
    this.colors = const {},
    this.radius = 8,
    this.fontFamily,
  });

  const UiThemeData.light({
    this.colors = const {},
    this.radius = 8,
    this.fontFamily,
  }) : brightness = Brightness.light;

  const UiThemeData.dark({
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
            final _Mix mix => uiMixOklab(
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

  /// The formula of [uiAlpha], on a resolved color.
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
        token: uiPaintColor(_resolve(token, resolved)),
      uiSurfaceShadow: uiShadows(brightness),
      uiOverlayShadow: uiShadows(brightness, overlay: true),
      UiTokens.radiusXs: Radius.circular(radius * 0.25),
      UiTokens.radiusSm: Radius.circular(radius * 0.5),
      UiTokens.radiusMd: Radius.circular(radius * 0.75),
      UiTokens.radiusLg: Radius.circular(radius),
      UiTokens.radiusXl: Radius.circular(radius * 1.5),
      UiTokens.radius2xl: Radius.circular(radius * 2),
      UiTokens.radius3xl: Radius.circular(radius * 3),
      UiTokens.radius4xl: Radius.circular(radius * 4),
      UiTokens.radiusField: Radius.circular(radius * 1.5),
      UiTokens.radiusPanel: Radius.circular((radius * 3).clamp(0, 32)),
      UiTokens.textXs: _text(12, 16),
      UiTokens.textSm: _text(14, 20),
      UiTokens.textBase: _text(16, 24),
    });
  }

  /// A copy with the given fields; [colors] are merged into the existing
  /// overrides.
  UiThemeData copyWith({
    Brightness? brightness,
    Map<ColorToken, Color>? colors,
    double? radius,
    String? fontFamily,
  }) => UiThemeData(
    brightness: brightness ?? this.brightness,
    colors: colors == null ? this.colors : {...this.colors, ...colors},
    radius: radius ?? this.radius,
    fontFamily: fontFamily ?? this.fontFamily,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UiThemeData &&
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
  UiTokens.white: const _Value(1, 1, 1),
  UiTokens.black: const _Value(0, 0, 0),
  UiTokens.snow: const _Value(0.98827621144, 0.98827621144, 0.98827621144),
  UiTokens.eclipse: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  UiTokens.accent: const _Value(0.016599386401, 0.521575639857, 0.968539356408),
  UiTokens.accentForeground: const _Alias(UiTokens.snow),
  UiTokens.success: const _Value(
    0.089664996069,
    0.788191649728,
    0.391964351272,
  ),
  UiTokens.successForeground: const _Alias(UiTokens.eclipse),
  UiTokens.fieldBorder: const _Value(0, 0, 0, 0),
  UiTokens.surfaceForeground: const _Alias(UiTokens.foreground),
  UiTokens.surfaceSecondaryForeground: const _Alias(UiTokens.foreground),
  UiTokens.surfaceTertiaryForeground: const _Alias(UiTokens.foreground),
  UiTokens.overlayForeground: const _Alias(UiTokens.foreground),
  UiTokens.fieldPlaceholder: const _Alias(UiTokens.muted),
  UiTokens.warningForeground: const _Alias(UiTokens.eclipse),
  UiTokens.dangerForeground: const _Alias(UiTokens.snow),
  UiTokens.focus: const _Alias(UiTokens.accent),
  UiTokens.link: const _Alias(UiTokens.foreground),
  UiTokens.surfaceHover: const _Mix(
    UiTokens.surface,
    0.92,
    UiTokens.surfaceForeground,
    0.08,
  ),
  UiTokens.backgroundSecondary: const _Mix(
    UiTokens.background,
    0.96,
    UiTokens.foreground,
    0.04,
  ),
  UiTokens.backgroundTertiary: const _Mix(
    UiTokens.background,
    0.92,
    UiTokens.foreground,
    0.08,
  ),
  UiTokens.backgroundInverse: const _Alias(UiTokens.foreground),
  UiTokens.defaultHover: const _Mix(
    UiTokens.defaultColor,
    0.96,
    UiTokens.defaultForeground,
    0.04,
  ),
  UiTokens.accentHover: const _Mix(
    UiTokens.accent,
    0.9,
    UiTokens.accentForeground,
    0.1,
  ),
  UiTokens.successHover: const _Mix(
    UiTokens.success,
    0.9,
    UiTokens.successForeground,
    0.1,
  ),
  UiTokens.warningHover: const _Mix(
    UiTokens.warning,
    0.9,
    UiTokens.warningForeground,
    0.1,
  ),
  UiTokens.dangerHover: const _Mix(
    UiTokens.danger,
    0.9,
    UiTokens.dangerForeground,
    0.1,
  ),
  UiTokens.fieldHover: const _Mix(
    UiTokens.fieldBackground,
    0.9,
    UiTokens.fieldForeground,
    0.02,
  ),
  UiTokens.fieldFocus: const _Alias(UiTokens.fieldBackground),
  UiTokens.fieldBorderHover: const _Mix(
    UiTokens.fieldBorder,
    0.88,
    UiTokens.fieldForeground,
    0.1,
  ),
  UiTokens.fieldBorderFocus: const _Mix(
    UiTokens.fieldBorder,
    0.74,
    UiTokens.fieldForeground,
    0.22,
  ),
  UiTokens.defaultSoft: const _Fade(UiTokens.defaultColor, 0.5),
  UiTokens.defaultSoftForeground: const _Alias(UiTokens.defaultForeground),
  UiTokens.defaultSoftHover: const _Fade(UiTokens.defaultColor, 0.6),
  UiTokens.dangerSoft: const _Fade(UiTokens.danger, 0.15),
  UiTokens.dangerSoftHover: const _Fade(UiTokens.danger, 0.2),
  UiTokens.separatorSecondary: const _Mix(
    UiTokens.surface,
    0.85,
    UiTokens.surfaceForeground,
    0.15,
  ),
  UiTokens.separatorTertiary: const _Mix(
    UiTokens.surface,
    0.81,
    UiTokens.surfaceForeground,
    0.19,
  ),
  UiTokens.borderSecondary: const _Mix(
    UiTokens.surface,
    0.78,
    UiTokens.surfaceForeground,
    0.22,
  ),
  UiTokens.borderTertiary: const _Mix(
    UiTokens.surface,
    0.66,
    UiTokens.surfaceForeground,
    0.34,
  ),
};

final _light = <ColorToken, _Color>{
  UiTokens.background: const _Value(
    0.960848742889,
    0.960848742889,
    0.960848742889,
  ),
  UiTokens.foreground: const _Alias(UiTokens.eclipse),
  UiTokens.surface: const _Alias(UiTokens.white),
  UiTokens.surfaceSecondary: const _Value(
    0.937246270389,
    0.937246677125,
    0.941076636306,
  ),
  UiTokens.surfaceTertiary: const _Value(
    0.917615049746,
    0.917615421946,
    0.921430086967,
  ),
  UiTokens.overlay: const _Alias(UiTokens.white),
  UiTokens.muted: const _Value(0.443180480717, 0.443179510042, 0.478454780564),
  UiTokens.defaultColor: const _Value(
    0.921202232145,
    0.921202572913,
    0.924139298588,
  ),
  UiTokens.defaultForeground: const _Alias(UiTokens.eclipse),
  UiTokens.fieldBackground: const _Alias(UiTokens.white),
  UiTokens.fieldForeground: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  UiTokens.warning: const _Value(
    0.960862691028,
    0.647060340432,
    0.140737468328,
  ),
  UiTokens.danger: const _Value(0.999971088218, 0.219686825893, 0.235328592909),
  UiTokens.segment: const _Alias(UiTokens.white),
  UiTokens.segmentForeground: const _Alias(UiTokens.eclipse),
  UiTokens.border: const _Value(0.868722602176, 0.868722346034, 0.88033180369),
  UiTokens.separator: const _Value(
    0.894476722055,
    0.894476909435,
    0.906150621742,
  ),
  UiTokens.backdrop: const _Value(0, 0, 0, 0.5),
  UiTokens.accentSoft: const _Fade(UiTokens.accent, 0.15),
  UiTokens.accentSoftForeground: const _Mix(
    UiTokens.accent,
    0.7,
    UiTokens.foreground,
    0.3,
  ),
  UiTokens.accentSoftHover: const _Fade(UiTokens.accent, 0.2),
  UiTokens.dangerSoftForeground: const _Mix(
    UiTokens.danger,
    0.7,
    UiTokens.foreground,
    0.4,
  ),
  UiTokens.warningSoft: const _Fade(UiTokens.warning, 0.15),
  UiTokens.warningSoftForeground: const _Mix(
    UiTokens.warning,
    0.8,
    UiTokens.foreground,
    0.7,
  ),
  UiTokens.warningSoftHover: const _Fade(UiTokens.warning, 0.2),
  UiTokens.successSoft: const _Fade(UiTokens.success, 0.15),
  UiTokens.successSoftForeground: const _Mix(
    UiTokens.success,
    0.8,
    UiTokens.foreground,
    0.6,
  ),
  UiTokens.successSoftHover: const _Fade(UiTokens.success, 0.2),
};

final _dark = <ColorToken, _Color>{
  UiTokens.background: const _Value(
    0.021721668644,
    0.021694641315,
    0.028367428378,
  ),
  UiTokens.foreground: const _Alias(UiTokens.snow),
  UiTokens.surface: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  UiTokens.surfaceSecondary: const _Value(
    0.137298776397,
    0.137298175769,
    0.145129288645,
  ),
  UiTokens.surfaceTertiary: const _Value(
    0.148958220597,
    0.152957908125,
    0.156957042474,
  ),
  UiTokens.overlay: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  UiTokens.muted: const _Value(0.622613326062, 0.622561559954, 0.663359592742),
  UiTokens.defaultColor: const _Value(
    0.152896916541,
    0.152886847966,
    0.165770247859,
  ),
  UiTokens.defaultForeground: const _Alias(UiTokens.snow),
  UiTokens.fieldBackground: const _Value(
    0.094083545223,
    0.094081351464,
    0.105924775656,
  ),
  UiTokens.fieldForeground: const _Alias(UiTokens.foreground),
  UiTokens.warning: const _Value(0.96853134062, 0.717603534283, 0.313834331729),
  UiTokens.danger: const _Value(0.858874269843, 0.23142924586, 0.243164089044),
  UiTokens.segment: const _Value(0.274530316512, 0.27453274061, 0.298065873958),
  UiTokens.segmentForeground: const _Alias(UiTokens.foreground),
  UiTokens.border: const _Value(0.158629492281, 0.158621840467, 0.171576396427),
  UiTokens.separator: const _Value(
    0.130286883764,
    0.130266259359,
    0.142852661978,
  ),
  UiTokens.backdrop: const _Value(0, 0, 0, 0.6),
  UiTokens.accentSoft: const _Fade(UiTokens.accent, 0.12),
  UiTokens.accentSoftForeground: const _Mix(
    UiTokens.accent,
    0.8,
    UiTokens.foreground,
    0.3,
  ),
  UiTokens.accentSoftHover: const _Fade(UiTokens.accent, 0.16),
  UiTokens.dangerSoftForeground: const _Mix(
    UiTokens.danger,
    0.8,
    UiTokens.foreground,
    0.3,
  ),
  UiTokens.warningSoft: const _Fade(UiTokens.warning, 0.12),
  UiTokens.warningSoftForeground: const _Mix(
    UiTokens.warning,
    0.8,
    UiTokens.foreground,
    0.3,
  ),
  UiTokens.warningSoftHover: const _Fade(UiTokens.warning, 0.16),
  UiTokens.successSoft: const _Fade(UiTokens.success, 0.12),
  UiTokens.successSoftForeground: const _Mix(
    UiTokens.success,
    0.8,
    UiTokens.foreground,
    0.3,
  ),
  UiTokens.successSoftHover: const _Fade(UiTokens.success, 0.16),
};
