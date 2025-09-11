import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';


void main() {
  group('RemixButtonStyle Helper Methods', () {
    test('labelColor method exists and returns non-null style', () {
      const testColor = Colors.red;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.labelColor(testColor);
      
      // Should return a new instance
      expect(modifiedStyle, isNotNull);
      expect(modifiedStyle, isNot(same(originalStyle)));
    });

    test('iconColor method exists and returns non-null style', () {
      const testColor = Colors.blue;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.iconColor(testColor);
      
      // Should return a new instance
      expect(modifiedStyle, isNotNull);
      expect(modifiedStyle, isNot(same(originalStyle)));
    });

    test('helper methods can be chained together', () {
      const testColor = Colors.green;
      const testFontSize = 18.0;
      
      final originalStyle = RemixButtonStyle();
      final chainedStyle = originalStyle
          .labelColor(testColor)
          .labelFontSize(testFontSize);
      
      // Should return a new instance
      expect(chainedStyle, isNotNull);
      expect(chainedStyle, isNot(same(originalStyle)));
    });

    test('labelTextStyle method works with TextStyleMix', () {
      final style = RemixButtonStyle();
      final textStyleMix = TextStyleMix(
        color: Colors.purple,
        fontSize: 18.0,
        fontWeight: FontWeight.w600,
      );
      
      final modifiedStyle = style.labelTextStyle(textStyleMix);
      
      // Should return a new instance
      expect(modifiedStyle, isNotNull);
      expect(modifiedStyle, isNot(same(style)));
    });

    test('all essential helper methods exist', () {
      final style = RemixButtonStyle();
      
      // Test that all expected label methods exist
      expect(() => style.labelColor(Colors.red), returnsNormally);
      expect(() => style.labelFontSize(16.0), returnsNormally);
      expect(() => style.labelFontWeight(FontWeight.bold), returnsNormally);
      expect(() => style.labelFontStyle(FontStyle.italic), returnsNormally);
      expect(() => style.labelTextStyle(TextStyleMix(color: Colors.green)), returnsNormally);
      
      // Test that all expected icon methods exist
      expect(() => style.iconColor(Colors.blue), returnsNormally);
      expect(() => style.iconSize(24.0), returnsNormally);
      expect(() => style.iconOpacity(0.8), returnsNormally);
    });
  });
}