import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'tokens.dart';

/// Appearance selection for an application-owned theme.
enum PlaygroundThemeMode { system, light, dark }

/// The concrete values behind [PlaygroundTokens] for one brightness.
///
/// This is application-owned data: change a hex value, add a field, or drop
/// one, and only this layer moves. `PlaygroundThemeScope` turns an instance into the
/// `MixScope` token map that every recipe resolves against.
///
/// The shipped values are a neutral grayscale theme. Two kinds of token are
/// derived rather than stored: the four radius steps come from [radius], and
/// the text steps from [fontFamily] and [monoFontFamily], so one edit here
/// moves a whole scale.
@immutable
class PlaygroundThemeData {
  /// Creates a theme with an explicit value for every color and the radius.
  ///
  /// [fontFamily] and [monoFontFamily] may be null, which leaves the family to
  /// whatever the platform text stack picks.
  const PlaygroundThemeData({
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
  const PlaygroundThemeData.light()
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
      fontFamily = null,
      monoFontFamily = null;

  /// The neutral dark theme.
  const PlaygroundThemeData.dark()
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
      fontFamily = null,
      monoFontFamily = null;

  /// Brightness of these concrete values, independent of the selection mode.
  final Brightness brightness;

  /// Value for [PlaygroundTokens.background].
  final Color background;

  /// Value for [PlaygroundTokens.foreground].
  final Color foreground;

  /// Value for [PlaygroundTokens.card].
  final Color card;

  /// Value for [PlaygroundTokens.cardForeground].
  final Color cardForeground;

  /// Value for [PlaygroundTokens.popover].
  final Color popover;

  /// Value for [PlaygroundTokens.popoverForeground].
  final Color popoverForeground;

  /// Value for [PlaygroundTokens.primary].
  final Color primary;

  /// Value for [PlaygroundTokens.primaryForeground].
  final Color primaryForeground;

  /// Value for [PlaygroundTokens.secondary].
  final Color secondary;

  /// Value for [PlaygroundTokens.secondaryForeground].
  final Color secondaryForeground;

  /// Value for [PlaygroundTokens.muted].
  final Color muted;

  /// Value for [PlaygroundTokens.mutedForeground].
  final Color mutedForeground;

  /// Value for [PlaygroundTokens.accent].
  final Color accent;

  /// Value for [PlaygroundTokens.accentForeground].
  final Color accentForeground;

  /// Value for [PlaygroundTokens.destructive].
  final Color destructive;

  /// Value for [PlaygroundTokens.destructiveForeground].
  final Color destructiveForeground;

  /// Value for [PlaygroundTokens.border].
  final Color border;

  /// Value for [PlaygroundTokens.input].
  final Color input;

  /// Value for [PlaygroundTokens.ring].
  final Color ring;

  /// Value for [PlaygroundTokens.chart1].
  final Color chart1;

  /// Value for [PlaygroundTokens.chart2].
  final Color chart2;

  /// Value for [PlaygroundTokens.chart3].
  final Color chart3;

  /// Value for [PlaygroundTokens.chart4].
  final Color chart4;

  /// Value for [PlaygroundTokens.chart5].
  final Color chart5;

  /// Value for [PlaygroundTokens.sidebar].
  final Color sidebar;

  /// Value for [PlaygroundTokens.sidebarForeground].
  final Color sidebarForeground;

  /// Value for [PlaygroundTokens.sidebarPrimary].
  final Color sidebarPrimary;

  /// Value for [PlaygroundTokens.sidebarPrimaryForeground].
  final Color sidebarPrimaryForeground;

  /// Value for [PlaygroundTokens.sidebarAccent].
  final Color sidebarAccent;

  /// Value for [PlaygroundTokens.sidebarAccentForeground].
  final Color sidebarAccentForeground;

  /// Value for [PlaygroundTokens.sidebarBorder].
  final Color sidebarBorder;

  /// Value for [PlaygroundTokens.sidebarRing].
  final Color sidebarRing;

  /// The base corner radius, which is [PlaygroundTokens.radiusLg].
  ///
  /// The other steps sit a fixed distance from it: `sm` is four pixels tighter,
  /// `md` two, and `xl` four pixels rounder. A step never goes below zero, so
  /// `Radius.zero` squares every control.
  final Radius radius;

  /// Family for every text step except [PlaygroundTokens.textMono].
  final String? fontFamily;

  /// Family for [PlaygroundTokens.textMono].
  final String? monoFontFamily;

  /// This theme's values keyed by the token that resolves them.
  ///
  /// Returned unmodifiable so a caller cannot mutate a theme that widgets
  /// already read from; use [copyWith] to derive a changed theme instead.
  Map<MixToken<Object?>, Object> get tokens =>
      Map<MixToken<Object?>, Object>.unmodifiable(<MixToken<Object?>, Object>{
        PlaygroundTokens.background: background,
        PlaygroundTokens.foreground: foreground,
        PlaygroundTokens.card: card,
        PlaygroundTokens.cardForeground: cardForeground,
        PlaygroundTokens.popover: popover,
        PlaygroundTokens.popoverForeground: popoverForeground,
        PlaygroundTokens.primary: primary,
        PlaygroundTokens.primaryForeground: primaryForeground,
        PlaygroundTokens.secondary: secondary,
        PlaygroundTokens.secondaryForeground: secondaryForeground,
        PlaygroundTokens.muted: muted,
        PlaygroundTokens.mutedForeground: mutedForeground,
        PlaygroundTokens.accent: accent,
        PlaygroundTokens.accentForeground: accentForeground,
        PlaygroundTokens.destructive: destructive,
        PlaygroundTokens.destructiveForeground: destructiveForeground,
        PlaygroundTokens.border: border,
        PlaygroundTokens.input: input,
        PlaygroundTokens.ring: ring,
        PlaygroundTokens.chart1: chart1,
        PlaygroundTokens.chart2: chart2,
        PlaygroundTokens.chart3: chart3,
        PlaygroundTokens.chart4: chart4,
        PlaygroundTokens.chart5: chart5,
        PlaygroundTokens.sidebar: sidebar,
        PlaygroundTokens.sidebarForeground: sidebarForeground,
        PlaygroundTokens.sidebarPrimary: sidebarPrimary,
        PlaygroundTokens.sidebarPrimaryForeground: sidebarPrimaryForeground,
        PlaygroundTokens.sidebarAccent: sidebarAccent,
        PlaygroundTokens.sidebarAccentForeground: sidebarAccentForeground,
        PlaygroundTokens.sidebarBorder: sidebarBorder,
        PlaygroundTokens.sidebarRing: sidebarRing,
        PlaygroundTokens.radiusSm: _radiusStep(-4),
        PlaygroundTokens.radiusMd: _radiusStep(-2),
        PlaygroundTokens.radiusLg: radius,
        PlaygroundTokens.radiusXl: _radiusStep(4),
        PlaygroundTokens.textXs: _text(12, 16),
        PlaygroundTokens.textSm: _text(14, 20),
        PlaygroundTokens.textBase: _text(16, 24),
        PlaygroundTokens.textLg: _text(18, 28),
        PlaygroundTokens.textXl: _text(20, 28),
        PlaygroundTokens.text2xl: _text(24, 32),
        PlaygroundTokens.text3xl: _text(30, 36),
        PlaygroundTokens.textMono: _text(14, 20, family: monoFontFamily),
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
  PlaygroundThemeData copyWith({
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
  }) => PlaygroundThemeData(
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
      other is PlaygroundThemeData && listEquals(other._fields, _fields);

  @override
  int get hashCode => Object.hashAll(_fields);

  @override
  String toString() =>
      'PlaygroundThemeData(background: $background, radius: $radius)';
}
