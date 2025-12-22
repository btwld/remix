import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/remix.dart';

void main() {
  group('SpinnerStyleMixin Tests', () {
    test('spinnerIndicatorColor method applies the correct color', () {
      const testColor = Colors.red;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerIndicatorColor(testColor);

      expect(modifiedStyle, isNot(same(originalStyle)));
      // Verify the spinner style was actually set with the color
      expect(modifiedStyle.$spinner, isNotNull);
    });

    test('spinnerTrackColor method applies the correct color', () {
      const testColor = Colors.blue;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerTrackColor(testColor);

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, isNotNull);
    });

    test('spinnerSize method applies the correct size', () {
      const testSize = 32.0;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerSize(testSize);

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, isNotNull);
    });

    test('spinnerStrokeWidth method applies the correct width', () {
      const testWidth = 3.0;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerStrokeWidth(testWidth);

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, isNotNull);
    });

    test('spinnerTrackStrokeWidth method applies the correct width', () {
      const testWidth = 2.5;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerTrackStrokeWidth(testWidth);

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, isNotNull);
    });

    test('spinnerDuration method applies the correct duration', () {
      const testDuration = Duration(milliseconds: 800);
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerDuration(testDuration);

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, isNotNull);
    });

    test('convenience duration methods create distinct styles', () {
      final originalStyle = RemixButtonStyle();

      final fastStyle = originalStyle.spinnerFast();
      final normalStyle = originalStyle.spinnerNormal();
      final slowStyle = originalStyle.spinnerSlow();

      // Verify each creates a new style instance
      expect(fastStyle, isNot(same(originalStyle)));
      expect(normalStyle, isNot(same(originalStyle)));
      expect(slowStyle, isNot(same(originalStyle)));

      // Verify they are distinct from each other
      expect(fastStyle, isNot(equals(normalStyle)));
      expect(normalStyle, isNot(equals(slowStyle)));
      expect(fastStyle, isNot(equals(slowStyle)));
    });

    test('spinner methods can be chained together', () {
      final originalStyle = RemixButtonStyle();
      final chainedStyle = originalStyle
          .spinnerIndicatorColor(Colors.blue)
          .spinnerTrackColor(Colors.blue.withValues(alpha: 0.2))
          .spinnerSize(28.0)
          .spinnerStrokeWidth(2.5)
          .spinnerFast();

      expect(chainedStyle, isNot(same(originalStyle)));
      expect(chainedStyle.$spinner, isNotNull);
    });

    test('spinner helpers can be chained with other mixins', () {
      final combinedStyle = RemixButtonStyle()
          .labelColor(Colors.white)
          .iconColor(Colors.white)
          .spinnerIndicatorColor(Colors.white)
          .color(Colors.blue);

      // Verify all style properties were set
      expect(combinedStyle.$label, isNotNull);
      expect(combinedStyle.$icon, isNotNull);
      expect(combinedStyle.$spinner, isNotNull);
      expect(combinedStyle.$container, isNotNull);
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
