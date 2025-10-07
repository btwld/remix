import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('RemixSpinnerSpec', () {
    test('creates with default values', () {
      const spec = RemixSpinnerSpec();

      expect(spec.size, isNull);
      expect(spec.strokeWidth, isNull);
      expect(spec.indicatorColor, isNull);
      expect(spec.trackColor, isNull);
      expect(spec.trackStrokeWidth, isNull);
      expect(spec.duration, isNull);
    });

    test('creates with specified values', () {
      final spec = RemixSpinnerSpec(
        size: 24,
        strokeWidth: 2,
        indicatorColor: MixColors.red,
        trackColor: MixColors.red.withValues(alpha: 0.2),
        trackStrokeWidth: 1.5,
        duration: Duration(milliseconds: 500),
      );

      expect(spec.size, 24);
      expect(spec.strokeWidth, 2);
      expect(spec.indicatorColor, MixColors.red);
      expect(spec.trackColor, MixColors.red.withValues(alpha: 0.2));
      expect(spec.trackStrokeWidth, 1.5);
      expect(spec.duration, const Duration(milliseconds: 500));
    });

    test('copyWith updates only provided fields', () {
      final original = RemixSpinnerSpec(
        size: 24,
        strokeWidth: 2,
        indicatorColor: MixColors.red,
        trackColor: MixColors.red.withValues(alpha: 0.2),
        duration: Duration(milliseconds: 500),
      );

      final modified = original.copyWith(
        size: 32,
        indicatorColor: MixColors.blue,
      );

      expect(modified.size, 32);
      expect(modified.strokeWidth, 2); // preserved
      expect(modified.indicatorColor, MixColors.blue);
      expect(modified.trackColor, MixColors.red.withValues(alpha: 0.2)); // preserved
      expect(modified.duration, const Duration(milliseconds: 500)); // preserved
    });

    test('copyWith with no args returns equivalent spec', () {
      final original = RemixSpinnerSpec(
        size: 16,
        strokeWidth: 1.5,
        indicatorColor: MixColors.green,
        trackColor: MixColors.green.withValues(alpha: 0.3),
        duration: Duration(seconds: 1),
      );

      final same = original.copyWith();

      expect(same.size, original.size);
      expect(same.strokeWidth, original.strokeWidth);
      expect(same.indicatorColor, original.indicatorColor);
      expect(same.trackColor, original.trackColor);
      expect(same.duration, original.duration);
    });

    test('lerp with null other returns original', () {
      final spec = RemixSpinnerSpec(size: 10, strokeWidth: 1);
      final result = spec.lerp(null, 0.5);
      expect(result.size, 10);
      expect(result.strokeWidth, 1);
    });

    test('lerp at t=0 returns this; t=1 returns other', () {
      final a = RemixSpinnerSpec(
        size: 10,
        strokeWidth: 1,
        indicatorColor: MixColors.red,
        trackColor: MixColors.red.withValues(alpha: 0.2),
        trackStrokeWidth: 1.0,
        duration: Duration(milliseconds: 500),
      );
      final b = RemixSpinnerSpec(
        size: 30,
        strokeWidth: 3,
        indicatorColor: MixColors.blue,
        trackColor: MixColors.blue.withValues(alpha: 0.3),
        trackStrokeWidth: 2.0,
        duration: Duration(seconds: 1),
      );

      final at0 = a.lerp(b, 0.0);
      expect(at0.size, a.size);
      expect(at0.strokeWidth, a.strokeWidth);
      expect(at0.indicatorColor?.toARGB32(), a.indicatorColor?.toARGB32());
      expect(at0.trackStrokeWidth, a.trackStrokeWidth);
      expect(at0.duration, a.duration);

      final at1 = a.lerp(b, 1.0);
      expect(at1.size, b.size);
      expect(at1.strokeWidth, b.strokeWidth);
      expect(at1.indicatorColor?.toARGB32(), b.indicatorColor?.toARGB32());
      expect(at1.trackStrokeWidth, b.trackStrokeWidth);
      expect(at1.duration, b.duration);
    });

    test('props equality works correctly', () {
      const s1 = RemixSpinnerSpec(size: 24, strokeWidth: 2, indicatorColor: MixColors.red);
      const s2 = RemixSpinnerSpec(size: 24, strokeWidth: 2, indicatorColor: MixColors.red);
      const s3 = RemixSpinnerSpec(size: 32, strokeWidth: 2, indicatorColor: MixColors.red);

      expect(s1.props, equals(s2.props));
      expect(s1.props, isNot(equals(s3.props)));
    });
  });
}
