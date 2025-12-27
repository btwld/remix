import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/remix.dart';

void main() {
  group('SpinnerStyleMixin Tests', () {
    test('spinnerIndicatorColor method works', () {
      const testColor = Colors.red;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerIndicatorColor(testColor);

      final expectedSpinner = Prop.maybeMix(
        RemixSpinnerStyle(indicatorColor: testColor),
      );

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, equals(expectedSpinner));
    });

    test('spinnerTrackColor method works', () {
      const testColor = Colors.blue;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerTrackColor(testColor);

      final expectedSpinner = Prop.maybeMix(
        RemixSpinnerStyle(trackColor: testColor),
      );

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, equals(expectedSpinner));
    });

    test('spinnerSize method works', () {
      const testSize = 32.0;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerSize(testSize);

      final expectedSpinner = Prop.maybeMix(RemixSpinnerStyle(size: testSize));

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, equals(expectedSpinner));
    });

    test('spinnerStrokeWidth method works', () {
      const testWidth = 3.0;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerStrokeWidth(testWidth);

      final expectedSpinner = Prop.maybeMix(
        RemixSpinnerStyle(strokeWidth: testWidth),
      );

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, equals(expectedSpinner));
    });

    test('spinnerTrackStrokeWidth method works', () {
      const testWidth = 2.5;
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerTrackStrokeWidth(testWidth);

      final expectedSpinner = Prop.maybeMix(
        RemixSpinnerStyle(trackStrokeWidth: testWidth),
      );

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, equals(expectedSpinner));
    });

    test('spinnerDuration method works', () {
      const testDuration = Duration(milliseconds: 800);
      final originalStyle = RemixButtonStyle();
      final modifiedStyle = originalStyle.spinnerDuration(testDuration);

      final expectedSpinner = Prop.maybeMix(
        RemixSpinnerStyle(duration: testDuration),
      );

      expect(modifiedStyle, isNot(same(originalStyle)));
      expect(modifiedStyle.$spinner, equals(expectedSpinner));
    });

    test('convenience duration methods work', () {
      final originalStyle = RemixButtonStyle();

      // Test convenience duration methods
      final fastStyle = originalStyle.spinnerFast();
      final normalStyle = originalStyle.spinnerNormal();
      final slowStyle = originalStyle.spinnerSlow();

      expect(
        fastStyle.$spinner,
        equals(
          Prop.maybeMix(
            RemixSpinnerStyle(duration: const Duration(milliseconds: 500)),
          ),
        ),
      );
      expect(
        normalStyle.$spinner,
        equals(
          Prop.maybeMix(
            RemixSpinnerStyle(duration: const Duration(milliseconds: 1000)),
          ),
        ),
      );
      expect(
        slowStyle.$spinner,
        equals(
          Prop.maybeMix(
            RemixSpinnerStyle(duration: const Duration(milliseconds: 1500)),
          ),
        ),
      );
    });

    testWidgets('spinner methods can be chained together', (tester) async {
      final originalStyle = RemixButtonStyle();
      final chainedStyle = originalStyle
          .spinnerIndicatorColor(Colors.blue)
          .spinnerTrackColor(Colors.blue.withValues(alpha: 0.2))
          .spinnerSize(28.0)
          .spinnerStrokeWidth(2.5)
          .spinnerFast();

      expect(chainedStyle, isNot(same(originalStyle)));

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final spec = chainedStyle.resolve(context).spec.spinner.spec;

              expect(spec.indicatorColor, equals(Colors.blue));
              expect(
                spec.trackColor,
                equals(Colors.blue.withValues(alpha: 0.2)),
              );
              expect(spec.size, equals(28.0));
              expect(spec.strokeWidth, equals(2.5));
              expect(
                spec.duration,
                equals(const Duration(milliseconds: 500)),
              );

              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    test('spinner helpers can be chained with other mixins', () {
      final combinedStyle = RemixButtonStyle()
          .labelColor(Colors.white)
          .iconColor(Colors.white)
          .spinnerIndicatorColor(Colors.white)
          .color(Colors.blue);

      expect(
        combinedStyle.$spinner,
        equals(
          Prop.maybeMix(RemixSpinnerStyle(indicatorColor: Colors.white)),
        ),
      );
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
