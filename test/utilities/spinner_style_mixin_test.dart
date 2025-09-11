import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('SpinnerStyleMixin Tests', () {
    test('spinnerColor method works', () {
      const testColor = Colors.red;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerColor(testColor);
      
      expect(modifiedStyle, isNotNull);
      expect(modifiedStyle, isNot(same(originalStyle)));
    });

    test('spinnerSize method works', () {
      const testSize = 32.0;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerSize(testSize);
      
      expect(modifiedStyle, isNotNull);
      expect(modifiedStyle, isNot(same(originalStyle)));
    });

    test('spinnerStrokeWidth method works', () {
      const testWidth = 3.0;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerStrokeWidth(testWidth);
      
      expect(modifiedStyle, isNotNull);
      expect(modifiedStyle, isNot(same(originalStyle)));
    });

    test('spinnerDuration method works', () {
      const testDuration = Duration(milliseconds: 800);
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerDuration(testDuration);
      
      expect(modifiedStyle, isNotNull);
      expect(modifiedStyle, isNot(same(originalStyle)));
    });

    test('spinnerType method works', () {
      const testType = SpinnerType.dotted;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerType(testType);
      
      expect(modifiedStyle, isNotNull);
      expect(modifiedStyle, isNot(same(originalStyle)));
    });

    test('convenience methods work', () {
      final originalStyle = RemixButtonStyle();
      
      // Test convenience type methods
      final solidStyle = originalStyle.spinnerSolid();
      final dottedStyle = originalStyle.spinnerDotted();
      
      expect(solidStyle, isNotNull);
      expect(dottedStyle, isNotNull);
      
      // Test convenience duration methods
      final fastStyle = originalStyle.spinnerFast();
      final normalStyle = originalStyle.spinnerNormal();
      final slowStyle = originalStyle.spinnerSlow();
      
      expect(fastStyle, isNotNull);
      expect(normalStyle, isNotNull);
      expect(slowStyle, isNotNull);
    });

    test('spinner methods can be chained together', () {
      final originalStyle = RemixButtonStyle();
      final chainedStyle = originalStyle
          .spinnerColor(Colors.blue)
          .spinnerSize(28.0)
          .spinnerStrokeWidth(2.5)
          .spinnerFast()
          .spinnerSolid();
      
      expect(chainedStyle, isNotNull);
      expect(chainedStyle, isNot(same(originalStyle)));
    });

    test('spinner helpers can be chained with other mixins', () {
      final combinedStyle = RemixButtonStyle()
          .labelColor(Colors.white)
          .iconColor(Colors.white)
          .spinnerColor(Colors.white)
          .color(Colors.blue);
      
      expect(combinedStyle, isNotNull);
    });

    test('all spinner helper methods execute without errors', () {
      final style = RemixButtonStyle();
      
      expect(() => style.spinnerColor(Colors.red), returnsNormally);
      expect(() => style.spinnerSize(24.0), returnsNormally);
      expect(() => style.spinnerStrokeWidth(2.0), returnsNormally);
      expect(() => style.spinnerDuration(const Duration(seconds: 1)), returnsNormally);
      expect(() => style.spinnerType(SpinnerType.solid), returnsNormally);
      expect(() => style.spinnerSolid(), returnsNormally);
      expect(() => style.spinnerDotted(), returnsNormally);
      expect(() => style.spinnerFast(), returnsNormally);
      expect(() => style.spinnerNormal(), returnsNormally);
      expect(() => style.spinnerSlow(), returnsNormally);
    });
  });
}