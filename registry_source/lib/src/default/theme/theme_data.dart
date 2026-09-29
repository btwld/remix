import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';

import 'tokens.dart';

/// Appearance selection for an application-owned theme.
enum VanillaThemeMode { system, light, dark }

/// The concrete values behind [VanillaTokens] for one brightness.
///
/// This is application-owned data: change a hex value, add a field, or drop
/// one, and only this layer moves. `VanillaThemeScope` turns an instance into the
/// `MixScope` token map that every recipe resolves against.
///
/// The shipped values are a neutral grayscale theme set in Geist and Geist
/// Mono from `remix_ui_fonts`. Two kinds of token are derived rather than
/// stored: the four radius steps come from [radius], and the text steps from
/// [fontFamily] and [monoFontFamily], so one edit here moves a whole scale.
@immutable
class VanillaThemeData {
  /// Creates a theme with an explicit value for every color and the radius.
  ///
  /// [fontFamily] and [monoFontFamily] may be null, which leaves the family to
  /// whatever the platform text stack picks. [VanillaThemeData.light] and
  /// [VanillaThemeData.dark] set them to Geist and Geist Mono.
  const VanillaThemeData({
    this.brightness = Brightness.light,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.chart1,
    required this.chart2,
    required this.chart3,
    required this.chart4,
    required this.chart5,
    required this.sidebar,
    required this.sidebarForeground,
    required this.sidebarPrimary,
    required this.sidebarPrimaryForeground,
    required this.sidebarAccent,
    required this.sidebarAccentForeground,
    required this.sidebarBorder,
    required this.sidebarRing,
    required this.radius,
    this.fontFamily,
    this.monoFontFamily,
  });

  /// The neutral light theme.
  const VanillaThemeData.light()
    : brightness = Brightness.light,
      background = const Color(0xFFFFFFFF),
      foreground = const Color(0xFF0A0A0A),
      card = const Color(0xFFFFFFFF),
      cardForeground = const Color(0xFF0A0A0A),
      popover = const Color(0xFFFFFFFF),
      popoverForeground = const Color(0xFF0A0A0A),
      primary = const Color(0xFF171717),
      primaryForeground = const Color(0xFFFAFAFA),
      secondary = const Color(0xFFF5F5F5),
      secondaryForeground = const Color(0xFF171717),
      muted = const Color(0xFFF5F5F5),
      mutedForeground = const Color(0xFF707070),
      accent = const Color(0xFFF5F5F5),
      accentForeground = const Color(0xFF171717),
      destructive = const Color(0xFFE7000B),
      destructiveForeground = const Color(0xFFFFFFFF),
      border = const Color(0xFFE5E5E5),
      input = const Color(0xFFE5E5E5),
      ring = const Color(0xFFA1A1A1),
      chart1 = const Color(0xFFD4D4D4),
      chart2 = const Color(0xFF737373),
      chart3 = const Color(0xFF525252),
      chart4 = const Color(0xFF404040),
      chart5 = const Color(0xFF262626),
      sidebar = const Color(0xFFFAFAFA),
      sidebarForeground = const Color(0xFF0A0A0A),
      sidebarPrimary = const Color(0xFF171717),
      sidebarPrimaryForeground = const Color(0xFFFAFAFA),
      sidebarAccent = const Color(0xFFF5F5F5),
      sidebarAccentForeground = const Color(0xFF171717),
      sidebarBorder = const Color(0xFFE5E5E5),
      sidebarRing = const Color(0xFFA1A1A1),
      radius = const Radius.circular(10),
      fontFamily = RemixFonts.geist,
      monoFontFamily = RemixFonts.geistMono;

  /// The neutral dark theme.
  const VanillaThemeData.dark()
    : brightness = Brightness.dark,
      background = const Color(0xFF0A0A0A),
      foreground = const Color(0xFFFAFAFA),
      card = const Color(0xFF171717),
      cardForeground = const Color(0xFFFAFAFA),
      popover = const Color(0xFF171717),
      popoverForeground = const Color(0xFFFAFAFA),
      primary = const Color(0xFFE5E5E5),
      primaryForeground = const Color(0xFF171717),
      secondary = const Color(0xFF262626),
      secondaryForeground = const Color(0xFFFAFAFA),
      muted = const Color(0xFF262626),
      mutedForeground = const Color(0xFFA1A1A1),
      accent = const Color(0xFF262626),
      accentForeground = const Color(0xFFFAFAFA),
      destructive = const Color(0xFFFF6467),
      destructiveForeground = const Color(0xFFFFFFFF),
      border = const Color(0x1AFFFFFF),
      input = const Color(0x26FFFFFF),
      ring = const Color(0xFF737373),
      chart1 = const Color(0xFFD4D4D4),
      chart2 = const Color(0xFF737373),
      chart3 = const Color(0xFF525252),
      chart4 = const Color(0xFF404040),
      chart5 = const Color(0xFF262626),
      sidebar = const Color(0xFF171717),
      sidebarForeground = const Color(0xFFFAFAFA),
      sidebarPrimary = const Color(0xFF1447E6),
      sidebarPrimaryForeground = const Color(0xFFFAFAFA),
      sidebarAccent = const Color(0xFF262626),
      sidebarAccentForeground = const Color(0xFFFAFAFA),
      sidebarBorder = const Color(0x1AFFFFFF),
      sidebarRing = const Color(0xFF737373),
      radius = const Radius.circular(10),
      fontFamily = RemixFonts.geist,
      monoFontFamily = RemixFonts.geistMono;

  /// Brightness of these concrete values, independent of the selection mode.
  final Brightness brightness;

  /// Value for [VanillaTokens.background].
  final Color background;

  /// Value for [VanillaTokens.foreground].
  final Color foreground;

  /// Value for [VanillaTokens.card].
  final Color card;

  /// Value for [VanillaTokens.cardForeground].
  final Color cardForeground;

  /// Value for [VanillaTokens.popover].
  final Color popover;

  /// Value for [VanillaTokens.popoverForeground].
  final Color popoverForeground;

  /// Value for [VanillaTokens.primary].
  final Color primary;

  /// Value for [VanillaTokens.primaryForeground].
  final Color primaryForeground;

  /// Value for [VanillaTokens.secondary].
  final Color secondary;

  /// Value for [VanillaTokens.secondaryForeground].
  final Color secondaryForeground;

  /// Value for [VanillaTokens.muted].
  final Color muted;

  /// Value for [VanillaTokens.mutedForeground].
  final Color mutedForeground;

  /// Value for [VanillaTokens.accent].
  final Color accent;

  /// Value for [VanillaTokens.accentForeground].
  final Color accentForeground;

  /// Value for [VanillaTokens.destructive].
  final Color destructive;

  /// Value for [VanillaTokens.destructiveForeground].
  final Color destructiveForeground;

  /// Value for [VanillaTokens.border].
  final Color border;

  /// Value for [VanillaTokens.input].
  final Color input;

  /// Value for [VanillaTokens.ring].
  final Color ring;

  /// Value for [VanillaTokens.chart1].
  final Color chart1;

  /// Value for [VanillaTokens.chart2].
  final Color chart2;

  /// Value for [VanillaTokens.chart3].
  final Color chart3;

  /// Value for [VanillaTokens.chart4].
  final Color chart4;

  /// Value for [VanillaTokens.chart5].
  final Color chart5;

  /// Value for [VanillaTokens.sidebar].
  final Color sidebar;

  /// Value for [VanillaTokens.sidebarForeground].
  final Color sidebarForeground;

  /// Value for [VanillaTokens.sidebarPrimary].
  final Color sidebarPrimary;

  /// Value for [VanillaTokens.sidebarPrimaryForeground].
  final Color sidebarPrimaryForeground;

  /// Value for [VanillaTokens.sidebarAccent].
  final Color sidebarAccent;

  /// Value for [VanillaTokens.sidebarAccentForeground].
  final Color sidebarAccentForeground;

  /// Value for [VanillaTokens.sidebarBorder].
  final Color sidebarBorder;

  /// Value for [VanillaTokens.sidebarRing].
  final Color sidebarRing;

  /// The base corner radius, which is [VanillaTokens.radiusLg].
  ///
  /// The other steps sit a fixed distance from it: `sm` is four pixels tighter,
  /// `md` two, and `xl` four pixels rounder. A step never goes below zero, so
  /// `Radius.zero` squares every control.
  final Radius radius;

  /// Family for every text step except [VanillaTokens.textMono].
  ///
  /// The shipped themes use [RemixFonts.geist]. Null leaves the family to the
  /// platform text stack.
  final String? fontFamily;

  /// Family for [VanillaTokens.textMono].
  ///
  /// The shipped themes use [RemixFonts.geistMono]. Null leaves the family to
  /// the platform text stack.
  final String? monoFontFamily;

  /// This theme's values keyed by the token that resolves them.
  ///
  /// Returned unmodifiable so a caller cannot mutate a theme that widgets
  /// already read from; use [copyWith] to derive a changed theme instead.
  Map<MixToken<Object?>, Object> get tokens =>
      Map<MixToken<Object?>, Object>.unmodifiable(<MixToken<Object?>, Object>{
        VanillaTokens.background: background,
        VanillaTokens.foreground: foreground,
        VanillaTokens.card: card,
        VanillaTokens.cardForeground: cardForeground,
        VanillaTokens.popover: popover,
        VanillaTokens.popoverForeground: popoverForeground,
        VanillaTokens.primary: primary,
        VanillaTokens.primaryForeground: primaryForeground,
        VanillaTokens.secondary: secondary,
        VanillaTokens.secondaryForeground: secondaryForeground,
        VanillaTokens.muted: muted,
        VanillaTokens.mutedForeground: mutedForeground,
        VanillaTokens.accent: accent,
        VanillaTokens.accentForeground: accentForeground,
        VanillaTokens.destructive: destructive,
        VanillaTokens.destructiveForeground: destructiveForeground,
        VanillaTokens.border: border,
        VanillaTokens.input: input,
        VanillaTokens.ring: ring,
        VanillaTokens.chart1: chart1,
        VanillaTokens.chart2: chart2,
        VanillaTokens.chart3: chart3,
        VanillaTokens.chart4: chart4,
        VanillaTokens.chart5: chart5,
        VanillaTokens.sidebar: sidebar,
        VanillaTokens.sidebarForeground: sidebarForeground,
        VanillaTokens.sidebarPrimary: sidebarPrimary,
        VanillaTokens.sidebarPrimaryForeground: sidebarPrimaryForeground,
        VanillaTokens.sidebarAccent: sidebarAccent,
        VanillaTokens.sidebarAccentForeground: sidebarAccentForeground,
        VanillaTokens.sidebarBorder: sidebarBorder,
        VanillaTokens.sidebarRing: sidebarRing,
        VanillaTokens.radiusSm: _radiusStep(-4),
        VanillaTokens.radiusMd: _radiusStep(-2),
        VanillaTokens.radiusLg: radius,
        VanillaTokens.radiusXl: _radiusStep(4),
        VanillaTokens.textXs: _text(12, 16),
        VanillaTokens.textSm: _text(14, 20),
        VanillaTokens.textBase: _text(16, 24),
        VanillaTokens.textLg: _text(18, 28),
        VanillaTokens.textXl: _text(20, 28),
        VanillaTokens.text2xl: _text(24, 32),
        VanillaTokens.text3xl: _text(30, 36),
        VanillaTokens.textMono: _text(14, 20, family: monoFontFamily),
      });

  /// [radius] moved by [delta] on both axes, never below zero.
  Radius _radiusStep(double delta) => Radius.elliptical(
    math.max(0, radius.x + delta),
    math.max(0, radius.y + delta),
  );

  /// One text step: a size on a fixed line height, and the family.
  ///
  /// Leading is split evenly above and below the glyphs, which is how CSS
  /// places text in its line box. Flutter's default puts it all according to
  /// the font's own metrics instead, which sits a label visibly off-centre in
  /// a control sized to the line height.
  TextStyle _text(double size, double lineHeight, {String? family}) =>
      TextStyle(
        fontFamily: family ?? fontFamily,
        fontSize: size,
        height: lineHeight / size,
        leadingDistribution: TextLeadingDistribution.even,
      );

  /// Returns a copy of this theme with the given values replaced.
  VanillaThemeData copyWith({
    Brightness? brightness,
    Color? background,
    Color? foreground,
    Color? card,
    Color? cardForeground,
    Color? popover,
    Color? popoverForeground,
    Color? primary,
    Color? primaryForeground,
    Color? secondary,
    Color? secondaryForeground,
    Color? muted,
    Color? mutedForeground,
    Color? accent,
    Color? accentForeground,
    Color? destructive,
    Color? destructiveForeground,
    Color? border,
    Color? input,
    Color? ring,
    Color? chart1,
    Color? chart2,
    Color? chart3,
    Color? chart4,
    Color? chart5,
    Color? sidebar,
    Color? sidebarForeground,
    Color? sidebarPrimary,
    Color? sidebarPrimaryForeground,
    Color? sidebarAccent,
    Color? sidebarAccentForeground,
    Color? sidebarBorder,
    Color? sidebarRing,
    Radius? radius,
    String? fontFamily,
    String? monoFontFamily,
  }) => VanillaThemeData(
    brightness: brightness ?? this.brightness,
    background: background ?? this.background,
    foreground: foreground ?? this.foreground,
    card: card ?? this.card,
    cardForeground: cardForeground ?? this.cardForeground,
    popover: popover ?? this.popover,
    popoverForeground: popoverForeground ?? this.popoverForeground,
    primary: primary ?? this.primary,
    primaryForeground: primaryForeground ?? this.primaryForeground,
    secondary: secondary ?? this.secondary,
    secondaryForeground: secondaryForeground ?? this.secondaryForeground,
    muted: muted ?? this.muted,
    mutedForeground: mutedForeground ?? this.mutedForeground,
    accent: accent ?? this.accent,
    accentForeground: accentForeground ?? this.accentForeground,
    destructive: destructive ?? this.destructive,
    destructiveForeground: destructiveForeground ?? this.destructiveForeground,
    border: border ?? this.border,
    input: input ?? this.input,
    ring: ring ?? this.ring,
    chart1: chart1 ?? this.chart1,
    chart2: chart2 ?? this.chart2,
    chart3: chart3 ?? this.chart3,
    chart4: chart4 ?? this.chart4,
    chart5: chart5 ?? this.chart5,
    sidebar: sidebar ?? this.sidebar,
    sidebarForeground: sidebarForeground ?? this.sidebarForeground,
    sidebarPrimary: sidebarPrimary ?? this.sidebarPrimary,
    sidebarPrimaryForeground:
        sidebarPrimaryForeground ?? this.sidebarPrimaryForeground,
    sidebarAccent: sidebarAccent ?? this.sidebarAccent,
    sidebarAccentForeground:
        sidebarAccentForeground ?? this.sidebarAccentForeground,
    sidebarBorder: sidebarBorder ?? this.sidebarBorder,
    sidebarRing: sidebarRing ?? this.sidebarRing,
    radius: radius ?? this.radius,
    fontFamily: fontFamily ?? this.fontFamily,
    monoFontFamily: monoFontFamily ?? this.monoFontFamily,
  );

  List<Object?> get _fields => [
    brightness,
    background,
    foreground,
    card,
    cardForeground,
    popover,
    popoverForeground,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    muted,
    mutedForeground,
    accent,
    accentForeground,
    destructive,
    destructiveForeground,
    border,
    input,
    ring,
    chart1,
    chart2,
    chart3,
    chart4,
    chart5,
    sidebar,
    sidebarForeground,
    sidebarPrimary,
    sidebarPrimaryForeground,
    sidebarAccent,
    sidebarAccentForeground,
    sidebarBorder,
    sidebarRing,
    radius,
    fontFamily,
    monoFontFamily,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VanillaThemeData && listEquals(other._fields, _fields);

  @override
  int get hashCode => Object.hashAll(_fields);

  @override
  String toString() =>
      'VanillaThemeData(background: $background, radius: $radius)';
}
