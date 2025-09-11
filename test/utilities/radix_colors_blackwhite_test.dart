import 'dart:convert';
import 'dart:io';

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/src/utilities/radix_colors/radix_colors.dart';

void main() {
  test('black/white alpha palettes match blackwhite_ref.json', () {
    final file = File('lib/src/utilities/radix_colors/blackwhite_ref.json');
    expect(file.existsSync(), isTrue, reason: 'Missing blackwhite_ref.json');
    final jsonMap =
        json.decode(file.readAsStringSync()) as Map<String, dynamic>;

    // Map of ref key -> RadixColors instance
    final palettes = <String, RadixColors>{
      'blackA': RadixColors.blackAlpha,
      'whiteA': RadixColors.whiteAlpha,
    };

    for (final entry in palettes.entries) {
      final refKey = entry.key; // 'blackA' | 'whiteA'
      final radix = entry.value;
      final swatch = radix.alphaSwatch; // same as swatch for these

      final tokens =
          (jsonMap[refKey] as Map<String, dynamic>).cast<String, dynamic>();

      for (var i = 1; i <= 12; i++) {
        final tokenName = '${refKey}${i}';
        final rgba = tokens[tokenName] as Map<String, dynamic>;
        final r = rgba['r'] as int;
        final g = rgba['g'] as int;
        final b = rgba['b'] as int;
        final a = (rgba['a'] as num).toDouble();
        final expected = Color.fromRGBO(r, g, b, a);
        final actual = swatch[i];
        expect(actual, isNotNull, reason: '$refKey missing index $i');
        expect(actual!.toARGB32(), expected.toARGB32(),
            reason: '$refKey[$i] mismatch');
      }

      // default equals 9
      expect(swatch.toARGB32(), swatch[9]!.toARGB32(),
          reason: '$refKey default should equal index 9');
    }
  });
}
