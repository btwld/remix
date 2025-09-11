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
  test('dark palettes match dark_ref.json', () {
    final file = File('lib/src/radix/colors/dark_ref.json');
    expect(file.existsSync(), isTrue, reason: 'Missing dark_ref.json');
    final jsonMap =
        json.decode(file.readAsStringSync()) as Map<String, dynamic>;

    final palettes = <String, RadixColors>{
      'amberDark': RadixColors.amberDark,
      'blueDark': RadixColors.blueDark,
      'bronzeDark': RadixColors.bronzeDark,
      'brownDark': RadixColors.brownDark,
      'crimsonDark': RadixColors.crimsonDark,
      'cyanDark': RadixColors.cyanDark,
      'goldDark': RadixColors.goldDark,
      'grassDark': RadixColors.grassDark,
      'grayDark': RadixColors.grayDark,
      'greenDark': RadixColors.greenDark,
      'indigoDark': RadixColors.indigoDark,
      'irisDark': RadixColors.irisDark,
      'jadeDark': RadixColors.jadeDark,
      'limeDark': RadixColors.limeDark,
      'mauveDark': RadixColors.mauveDark,
      'mintDark': RadixColors.mintDark,
      'oliveDark': RadixColors.oliveDark,
      'orangeDark': RadixColors.orangeDark,
      'pinkDark': RadixColors.pinkDark,
      'plumDark': RadixColors.plumDark,
      'purpleDark': RadixColors.purpleDark,
      'redDark': RadixColors.redDark,
      'rubyDark': RadixColors.rubyDark,
      'sageDark': RadixColors.sageDark,
      'sandDark': RadixColors.sandDark,
      'skyDark': RadixColors.skyDark,
      'slateDark': RadixColors.slateDark,
      'tealDark': RadixColors.tealDark,
      'tomatoDark': RadixColors.tomatoDark,
      'violetDark': RadixColors.violetDark,
      'yellowDark': RadixColors.yellowDark,
    };

    for (final entry in jsonMap.entries) {
      final paletteKey = entry.key; // e.g., grayDark or grayDarkA
      final tokens =
          (entry.value as Map<String, dynamic>).cast<String, String>();

      final isAlpha = paletteKey.endsWith('A');
      final base =
          isAlpha ? paletteKey.substring(0, paletteKey.length - 1) : paletteKey;

      final radix = palettes[base];
      expect(radix, isNotNull, reason: 'Unknown palette: $paletteKey');
      final swatch = isAlpha ? radix!.alphaSwatch : radix!.swatch;

      for (var i = 1; i <= 12; i++) {
        // In dark refs, token keys omit the "Dark" suffix (e.g., gray1.. or grayA1..)
        final tokenPrefix = paletteKey.replaceFirst('Dark', '');
        final tokenName = '$tokenPrefix$i';
        final refHex = tokens[tokenName];
        expect(refHex, isNotNull, reason: 'Missing $tokenName in JSON');
        final refArgb = parseRefHexToArgb(refHex!);
        final dartColor = swatch[i];
        expect(dartColor, isNotNull,
            reason: 'Missing index $i in $paletteKey swatch');
        expect(dartColor!.toARGB32(), refArgb, reason: '$paletteKey[$i] mismatch');
      }

      expect(swatch.toARGB32(), swatch[9]!.toARGB32(),
          reason: '$paletteKey default should equal index 9');
    }
  });
}
