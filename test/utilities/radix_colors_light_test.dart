import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:remix/src/radix/colors/colors.dart';

int parseRefHexToArgb(String cssHex) {
  final hex = cssHex.replaceAll('#', '').toLowerCase();
  if (hex.length == 6) {
    final rgb = int.parse(hex, radix: 16);
    return 0xff000000 | rgb;
  }
  if (hex.length == 8) {
    final rr = int.parse(hex.substring(0, 2), radix: 16);
    final gg = int.parse(hex.substring(2, 4), radix: 16);
    final bb = int.parse(hex.substring(4, 6), radix: 16);
    final aa = int.parse(hex.substring(6, 8), radix: 16);
    return (aa << 24) | (rr << 16) | (gg << 8) | bb;
  }
  throw ArgumentError('Unexpected hex: $cssHex');
}

void main() {
  test('light palettes match light_ref.json', () {
    final file = File('lib/src/radix/colors/light_ref.json');
    expect(file.existsSync(), isTrue, reason: 'Missing light_ref.json');
    final jsonMap =
        json.decode(file.readAsStringSync()) as Map<String, dynamic>;

    final palettes = <String, RadixColors>{
      'amber': RadixColors.amber,
      'blue': RadixColors.blue,
      'bronze': RadixColors.bronze,
      'brown': RadixColors.brown,
      'crimson': RadixColors.crimson,
      'cyan': RadixColors.cyan,
      'gold': RadixColors.gold,
      'grass': RadixColors.grass,
      'gray': RadixColors.gray,
      'green': RadixColors.green,
      'indigo': RadixColors.indigo,
      'iris': RadixColors.iris,
      'jade': RadixColors.jade,
      'lime': RadixColors.lime,
      'mauve': RadixColors.mauve,
      'mint': RadixColors.mint,
      'olive': RadixColors.olive,
      'orange': RadixColors.orange,
      'pink': RadixColors.pink,
      'plum': RadixColors.plum,
      'purple': RadixColors.purple,
      'red': RadixColors.red,
      'ruby': RadixColors.ruby,
      'sage': RadixColors.sage,
      'sand': RadixColors.sand,
      'sky': RadixColors.sky,
      'slate': RadixColors.slate,
      'teal': RadixColors.teal,
      'tomato': RadixColors.tomato,
      'violet': RadixColors.violet,
      'yellow': RadixColors.yellow,
    };

    for (final entry in jsonMap.entries) {
      final paletteKey = entry.key; // e.g., gray or grayA
      final tokens =
          (entry.value as Map<String, dynamic>).cast<String, String>();

      final isAlpha = paletteKey.endsWith('A');
      final base =
          isAlpha ? paletteKey.substring(0, paletteKey.length - 1) : paletteKey;

      final radix = palettes[base];
      expect(radix, isNotNull, reason: 'Unknown palette: $paletteKey');
      final swatch = isAlpha ? radix!.alphaSwatch : radix!.swatch;

      // tokens are like gray1..gray12
      for (var i = 1; i <= 12; i++) {
        final tokenName = '$paletteKey$i';
        final refHex = tokens[tokenName];
        expect(refHex, isNotNull, reason: 'Missing $tokenName in JSON');
        final refArgb = parseRefHexToArgb(refHex!);
        final dartColor = swatch[i];
        expect(dartColor, isNotNull,
            reason: 'Missing index $i in $paletteKey swatch');
        expect(dartColor!.toARGB32(), refArgb, reason: '$paletteKey[$i] mismatch');
      }

      // default equals 9
      expect(swatch.toARGB32(), swatch[9]!.toARGB32(),
          reason: '$paletteKey default should equal index 9');
    }
  });
}
