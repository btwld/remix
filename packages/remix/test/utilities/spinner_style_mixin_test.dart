import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../lib/remix.dart';

void main() {
  group('SpinnerStyleMixin Tests', () {
    group('Individual property methods', () {
      test('spinnerIndicatorColor applies the specified color', () {
        const testColor = Colors.red;
        final originalStyle = RemixButtonStyle();
        final modifiedStyle = originalStyle.spinnerIndicatorColor(testColor);

        expect(modifiedStyle, isNot(same(originalStyle)));
        expect(modifiedStyle.$spinner, isNotNull);

        // Verify the color is correctly set by comparing with expected value
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(indicatorColor: testColor),
        );
        expect(modifiedStyle.$spinner, equals(expectedSpinner));
      });

      test('spinnerTrackColor applies the specified color', () {
        const testColor = Colors.blue;
        final originalStyle = RemixButtonStyle();
        final modifiedStyle = originalStyle.spinnerTrackColor(testColor);

        expect(modifiedStyle, isNot(same(originalStyle)));
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(trackColor: testColor),
        );
        expect(modifiedStyle.$spinner, equals(expectedSpinner));
      });

      test('spinnerSize applies the specified size', () {
        const testSize = 32.0;
        final originalStyle = RemixButtonStyle();
        final modifiedStyle = originalStyle.spinnerSize(testSize);

        expect(modifiedStyle, isNot(same(originalStyle)));
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(size: testSize),
        );
        expect(modifiedStyle.$spinner, equals(expectedSpinner));
      });

      test('spinnerStrokeWidth applies the specified width', () {
        const testWidth = 3.0;
        final originalStyle = RemixButtonStyle();
        final modifiedStyle = originalStyle.spinnerStrokeWidth(testWidth);

        expect(modifiedStyle, isNot(same(originalStyle)));
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(strokeWidth: testWidth),
        );
        expect(modifiedStyle.$spinner, equals(expectedSpinner));
      });

      test('spinnerTrackStrokeWidth applies the specified width', () {
        const testWidth = 2.5;
        final originalStyle = RemixButtonStyle();
        final modifiedStyle = originalStyle.spinnerTrackStrokeWidth(testWidth);

        expect(modifiedStyle, isNot(same(originalStyle)));
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(trackStrokeWidth: testWidth),
        );
        expect(modifiedStyle.$spinner, equals(expectedSpinner));
      });

      test('spinnerDuration applies the specified duration', () {
        const testDuration = Duration(milliseconds: 800);
        final originalStyle = RemixButtonStyle();
        final modifiedStyle = originalStyle.spinnerDuration(testDuration);

        expect(modifiedStyle, isNot(same(originalStyle)));
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(duration: testDuration),
        );
        expect(modifiedStyle.$spinner, equals(expectedSpinner));
      });
    });

    group('Convenience duration methods', () {
      test('spinnerFast sets duration to 500ms', () {
        final style = RemixButtonStyle().spinnerFast();
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(duration: const Duration(milliseconds: 500)),
        );
        expect(style.$spinner, equals(expectedSpinner));
      });

      test('spinnerNormal sets duration to 1000ms', () {
        final style = RemixButtonStyle().spinnerNormal();
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(duration: const Duration(milliseconds: 1000)),
        );
        expect(style.$spinner, equals(expectedSpinner));
      });

      test('spinnerSlow sets duration to 1500ms', () {
        final style = RemixButtonStyle().spinnerSlow();
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(duration: const Duration(milliseconds: 1500)),
        );
        expect(style.$spinner, equals(expectedSpinner));
      });

      test('convenience methods create distinct duration values', () {
        final originalStyle = RemixButtonStyle();
        final fastStyle = originalStyle.spinnerFast();
        final normalStyle = originalStyle.spinnerNormal();
        final slowStyle = originalStyle.spinnerSlow();

        // Verify each creates a new style instance
        expect(fastStyle, isNot(same(originalStyle)));
        expect(normalStyle, isNot(same(originalStyle)));
        expect(slowStyle, isNot(same(originalStyle)));

        // Verify they are distinct from each other (different durations)
        expect(fastStyle.$spinner, isNot(equals(normalStyle.$spinner)));
        expect(normalStyle.$spinner, isNot(equals(slowStyle.$spinner)));
        expect(fastStyle.$spinner, isNot(equals(slowStyle.$spinner)));
      });
    });

    group('Method chaining', () {
      test('spinner methods can be chained together', () {
        final originalStyle = RemixButtonStyle();
        final chainedStyle = originalStyle
            .spinnerIndicatorColor(Colors.blue)
            .spinnerTrackColor(Colors.blue.withValues(alpha: 0.2))
            .spinnerSize(28.0)
            .spinnerStrokeWidth(2.5)
            .spinnerDuration(const Duration(milliseconds: 500));

        expect(chainedStyle, isNot(same(originalStyle)));
        expect(chainedStyle.$spinner, isNotNull);
      });

      test('spinner methods can be chained with other style mixins', () {
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

        // Verify specific values
        final expectedSpinner = Prop.maybeMix(
          RemixSpinnerStyle(indicatorColor: Colors.white),
        );
        expect(combinedStyle.$spinner, equals(expectedSpinner));
      });
    });

    group('Error handling', () {
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
  });
}
