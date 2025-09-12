import 'package:flutter/painting.dart';

/// Parses CSS-style hex color strings into a Flutter [Color].
///
/// Supported inputs (case-insensitive; surrounding whitespace ignored; underscores allowed):
/// • #RGB              (CSS shorthand, opaque)
/// • #RGBA             (CSS shorthand, alpha last)
/// • #RRGGBB           (opaque)
/// • #RRGGBBAA         (CSS, alpha last)
/// • RRGGBB / RRGGBBAA (same as above, without '#')
/// • 0xAARRGGBB        (Dart/Flutter ARGB literal, alpha first; underscores allowed)
///
/// Notes:
/// • `0x` literals must have exactly 8 hex digits after removing underscores.
/// • Inputs like "#0xAABBCCDD" are rejected (mixed notations).
/// • Throws [FormatException] for invalid strings.
class HexColor extends Color {
  // ---- Implementation -------------------------------------------------------

  static final RegExp _hexChars = RegExp(r'^[0-9a-fA-F_]+$');

  HexColor(String hex) : super(_parseToArgb32(hex));

  /// Convenience factory returning a [Color] from [hex].
  static Color from(String hex) => HexColor(hex);

  /// Parses [hex] and returns 32-bit ARGB (0xAARRGGBB).
  static int toArgb32(String hex) => _parseToArgb32(hex);

  /// Non-throwing variants.
  static Color? tryFrom(String hex) {
    try {
      return HexColor(hex);
    } on FormatException {
      return null;
    }
  }

  static int? tryToArgb32(String hex) {
    try {
      return _parseToArgb32(hex);
    } on FormatException {
      return null;
    }
  }

  static int _parseToArgb32(String hex) {
    if (hex.isEmpty || hex.trim().isEmpty) {
      throw const FormatException('Empty hex color string');
    }

    final s = hex.trim();

    // Use a switch-expression with a guard for 0x, otherwise treat as CSS-style.
    return switch (s) {
      // 0xAARRGGBB or 0XAARRGGBB (underscores allowed)
      var v when v.startsWith('0x') || v.startsWith('0X') => () {
          final body = v.substring(2).replaceAll('_', '');
          _ensureOnlyHex(body, original: hex);
          if (body.length != 8) {
            throw FormatException(
              '0x color literal must be 8 hex digits (AARRGGBB); got ${body.length} in "$hex".',
            );
          }
          return int.parse(body, radix: 16);
        }(),

      // CSS-style hex: optional '#', supports 3/4/6/8 digits (underscores allowed)
      _ => () {
          final t = s.startsWith('#') ? s.substring(1) : s;
          final body = t.replaceAll('_', '');
          _ensureOnlyHex(body, original: hex);

          return switch (body.length) {
            // #RGB -> #RRGGBB
            3 => _argb(0xFF, _dup(body[0]), _dup(body[1]), _dup(body[2])),
            // #RGBA -> #RRGGBBAA (alpha last)
            4 => _argb(_dup(body[3]), _dup(body[0]), _dup(body[1]), _dup(body[2])),
            // #RRGGBB
            6 => _argb(0xFF, _h2(body, 0), _h2(body, 2), _h2(body, 4)),
            // #RRGGBBAA (alpha last)
            8 => _argb(_h2(body, 6), _h2(body, 0), _h2(body, 2), _h2(body, 4)),
            _ => throw FormatException(
                'Unsupported hex length ${body.length} for "$hex". '
                'Expected 3, 4, 6, or 8 hex digits (or 0x + 8 digits).',
              ),
          };
        }(),
    };
  }

  static void _ensureOnlyHex(String s, {required String original}) {
    if (s.isEmpty || !_hexChars.hasMatch(s)) {
      throw FormatException('Invalid hex digits in "$original".');
    }
  }

  static int _h2(String s, int start) =>
      int.parse(s.substring(start, start + 2), radix: 16);

  static int _dup(String c) => int.parse('$c$c', radix: 16);

  static int _argb(int a, int r, int g, int b) =>
      ((a & 0xFF) << 24) | ((r & 0xFF) << 16) | ((g & 0xFF) << 8) | (b & 0xFF);
}
