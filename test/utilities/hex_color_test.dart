import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/src/utilities/hex_color.dart';

void main() {
  group('HexColor happy paths', () {
    test('#RRGGBB -> opaque ARGB', () {
      expect(HexColor('#112233').toARGB32(), equals(0xFF112233));
      expect(HexColor('AABBCC').toARGB32(), equals(0xFFAABBCC));
      expect(HexColor('  #a1b2c3  ').toARGB32(), equals(0xFFA1B2C3));
    });

    test('#RGB shorthand -> expanded, opaque', () {
      // #abc -> #aabbcc
      expect(HexColor('#abc').toARGB32(), equals(0xFFAABBCC));
      expect(HexColor('F0A').toARGB32(), equals(0xFFFF00AA));
    });

    test('#RRGGBBAA (alpha last)', () {
      // #11223344 -> 0x44112233
      expect(HexColor('#11223344').toARGB32(), equals(0x44112233));
      expect(HexColor('AABBCC80').toARGB32(), equals(0x80AABBCC));
    });

    test('#RGBA shorthand (alpha last)', () {
      // #1234 -> rr=11 gg=22 bb=33 aa=44 => 0x44112233
      expect(HexColor('#1234').toARGB32(), equals(0x44112233));
      expect(HexColor('F0A8').toARGB32(), equals(0x88FF00AA));
    });

    test('0xAARRGGBB (underscores allowed)', () {
      expect(HexColor('0xFF112233').toARGB32(), equals(0xFF112233));
      expect(HexColor('0X7F_aB_CD_EF').toARGB32(), equals(0x7FABCDEF));
    });

    test('underscores in CSS-style hex', () {
      expect(HexColor('#AA_BB_CC').toARGB32(), equals(0xFFAABBCC));
      expect(HexColor('11_22_33_44').toARGB32(), equals(0x44112233));
    });

    test('from/to helpers', () {
      expect(HexColor.from('#3498db').toARGB32(), equals(0xFF3498DB));
      expect(HexColor.toArgb32('#3498db'), equals(0xFF3498DB));
    });

    test('tryFrom/tryToArgb32 (non-throwing)', () {
      expect(HexColor.tryFrom('#FFFFFF')!.toARGB32(), equals(0xFFFFFFFF));
      expect(HexColor.tryFrom('nope'), isNull);
      expect(HexColor.tryToArgb32('0xFF000000'), equals(0xFF000000));
      expect(HexColor.tryToArgb32('bogus'), isNull);
    });

    test('Color equality semantics', () {
      // Compare underlying ARGB values to avoid runtimeType differences
      // between Color and the HexColor subclass in equality checks.
      expect(HexColor('#000000').toARGB32(), equals(const Color(0xFF000000).toARGB32()));
      expect(HexColor('FFFFFF').toARGB32(), equals(const Color(0xFFFFFFFF).toARGB32()));
    });
  });

  group('HexColor invalid inputs', () {
    test('empty or whitespace', () {
      expect(() => HexColor(''), throwsFormatException);
      expect(() => HexColor('   '), throwsFormatException);
    });

    test('unsupported length', () {
      expect(() => HexColor('12345'), throwsFormatException); // 5 digits
      expect(() => HexColor('#123456789'), throwsFormatException); // 9 digits
    });

    test('non-hex characters', () {
      expect(() => HexColor('#12G45Z'), throwsFormatException);
      expect(() => HexColor('#__FF__'), throwsFormatException);
      expect(() => HexColor('#0xAABBCCDD'),
          throwsFormatException); // mixed notation
    });

    test('0x must be exactly 8 digits after underscores', () {
      expect(() => HexColor('0x123456'), throwsFormatException); // too short
      expect(() => HexColor('0x1234567890'), throwsFormatException); // too long
      expect(() => HexColor('0xZZ112233'), throwsFormatException); // non-hex
    });
  });
}
