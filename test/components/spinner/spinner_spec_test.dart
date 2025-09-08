import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('SpinnerSpec', () {
    test('creates with default values', () {
      const spec = SpinnerSpec();

      expect(spec.size, isNull);
      expect(spec.strokeWidth, isNull);
      expect(spec.color, isNull);
      expect(spec.duration, isNull);
      expect(spec.style, isNull);
    });

    test('creates with specified values', () {
      final spec = SpinnerSpec(
        size: 24,
        strokeWidth: 2,
        color: MixColors.red,
        duration: Duration(milliseconds: 500),
        style: SpinnerType.dotted,
      );

      expect(spec.size, 24);
      expect(spec.strokeWidth, 2);
      expect(spec.color, MixColors.red);
      expect(spec.duration, const Duration(milliseconds: 500));
      expect(spec.style, SpinnerType.dotted);
    });

    test('copyWith updates only provided fields', () {
      final original = SpinnerSpec(
        size: 24,
        strokeWidth: 2,
        color: MixColors.red,
        duration: Duration(milliseconds: 500),
        style: SpinnerType.solid,
      );

      final modified = original.copyWith(
        size: 32,
        color: MixColors.blue,
      );

      expect(modified.size, 32);
      expect(modified.strokeWidth, 2); // preserved
      expect(modified.color, MixColors.blue);
      expect(modified.duration, const Duration(milliseconds: 500)); // preserved
      expect(modified.style, SpinnerType.solid); // preserved
    });

    test('copyWith with no args returns equivalent spec', () {
      final original = SpinnerSpec(
        size: 16,
        strokeWidth: 1.5,
        color: MixColors.green,
        duration: Duration(seconds: 1),
        style: SpinnerType.dotted,
      );

      final same = original.copyWith();

      expect(same.size, original.size);
      expect(same.strokeWidth, original.strokeWidth);
      expect(same.color, original.color);
      expect(same.duration, original.duration);
      expect(same.style, original.style);
    });

    test('lerp with null other returns original', () {
      final spec = SpinnerSpec(size: 10, strokeWidth: 1);
      final result = spec.lerp(null, 0.5);
      expect(result.size, 10);
      expect(result.strokeWidth, 1);
    });

    test('lerp at t=0 returns this; t=1 returns other', () {
      final a = SpinnerSpec(
        size: 10,
        strokeWidth: 1,
        color: MixColors.red,
        duration: Duration(milliseconds: 500),
        style: SpinnerType.solid,
      );
      const b = SpinnerSpec(
        size: 30,
        strokeWidth: 3,
        color: MixColors.blue,
        duration: Duration(seconds: 1),
        style: SpinnerType.dotted,
      );

      final at0 = a.lerp(b, 0.0);
      expect(at0.size, a.size);
      expect(at0.strokeWidth, a.strokeWidth);
      expect(at0.color?.toARGB32(), a.color?.toARGB32());
      expect(at0.duration, a.duration);
      expect(at0.style, a.style);

      final at1 = a.lerp(b, 1.0);
      expect(at1.size, b.size);
      expect(at1.strokeWidth, b.strokeWidth);
      expect(at1.color?.toARGB32(), b.color?.toARGB32());
      expect(at1.duration, b.duration);
      expect(at1.style, b.style);
    });

    test('props equality works correctly', () {
      const s1 = SpinnerSpec(size: 24, strokeWidth: 2, color: MixColors.red);
      const s2 = SpinnerSpec(size: 24, strokeWidth: 2, color: MixColors.red);
      const s3 = SpinnerSpec(size: 32, strokeWidth: 2, color: MixColors.red);

      expect(s1.props, equals(s2.props));
      expect(s1.props, isNot(equals(s3.props)));
    });
  });
}
