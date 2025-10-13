import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('SpinnerStyleMixin Tests', () {
    test('spinnerIndicatorColor method works', () {
      const testColor = Colors.red;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerIndicatorColor(testColor);

      expect(modifiedStyle, isNotNull);
      expect(modifiedStyle, isNot(same(originalStyle)));
    });

    test('spinnerTrackColor method works', () {
      const testColor = Colors.blue;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerTrackColor(testColor);

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

    test('spinnerTrackStrokeWidth method works', () {
      const testWidth = 2.5;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerTrackStrokeWidth(testWidth);

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

    test('convenience duration methods work', () {
      final originalStyle = RemixButtonStyle();

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
          .spinnerIndicatorColor(Colors.blue)
          .spinnerTrackColor(Colors.blue.withValues(alpha: 0.2))
          .spinnerSize(28.0)
          .spinnerStrokeWidth(2.5)
          .spinnerFast();

      expect(chainedStyle, isNotNull);
      expect(chainedStyle, isNot(same(originalStyle)));
    });

    test('spinner helpers can be chained with other mixins', () {
      final combinedStyle = RemixButtonStyle()
          .labelColor(Colors.white)
          .iconColor(Colors.white)
          .spinnerIndicatorColor(Colors.white)
          .textColor(Colors.blue);

      expect(combinedStyle, isNotNull);
    });

    test('all spinner helper methods execute without errors', () {
      final style = RemixButtonStyle();

      expect(() => style.spinnerIndicatorColor(Colors.red), returnsNormally);
      expect(
        () => style.spinnerTrackColor(Colors.red.withValues(alpha: 0.2)),
        returnsNormally,
      );
      expect(() => style.spinnerSize(24.0), returnsNormally);
      expect(() => style.spinnerStrokeWidth(2.0), returnsNormally);
      expect(() => style.spinnerTrackStrokeWidth(1.5), returnsNormally);
      expect(
        () => style.spinnerDuration(const Duration(seconds: 1)),
        returnsNormally,
      );
      expect(() => style.spinnerFast(), returnsNormally);
      expect(() => style.spinnerNormal(), returnsNormally);
      expect(() => style.spinnerSlow(), returnsNormally);
    });
  });
}
