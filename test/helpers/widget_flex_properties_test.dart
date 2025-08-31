import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('FlexSpec Tests', () {
    test('creates with default values', () {
      const spec = FlexSpec();

      expect(spec.direction, isNull);
      expect(spec.mainAxisAlignment, isNull);
      expect(spec.spacing, isNull);
    });

    test('creates with all values', () {
      const direction = Axis.horizontal;
      const mainAxisAlignment = MainAxisAlignment.center;
      const crossAxisAlignment = CrossAxisAlignment.center;
      const spacing = 8.0;

      const spec = FlexSpec(
        direction: direction,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        spacing: spacing,
      );

      expect(spec.direction, equals(direction));
      expect(spec.mainAxisAlignment, equals(mainAxisAlignment));
      expect(spec.crossAxisAlignment, equals(crossAxisAlignment));
      expect(spec.spacing, equals(spacing));
    });

    test('copyWith works correctly', () {
      const originalSpec = FlexSpec(
        direction: Axis.vertical,
        spacing: 4.0,
      );

      final newSpec = originalSpec.copyWith(
        direction: Axis.horizontal,
      );

      expect(newSpec.direction, equals(Axis.horizontal)); // updated
      expect(newSpec.spacing, equals(4.0)); // preserved
    });

    test('lerp interpolates correctly', () {
      const spec1 = FlexSpec(
        spacing: 5.0,
        direction: Axis.horizontal,
      );
      const spec2 = FlexSpec(
        spacing: 15.0,
        direction: Axis.vertical,
      );

      final result = spec1.lerp(spec2, 0.5);

      expect(result.spacing, equals(10.0));
      expect(
          result.direction, equals(Axis.vertical)); // t = 0.5, so spec2 value
    });

    test('props equality works correctly', () {
      const spec1 = FlexSpec(
        direction: Axis.horizontal,
        spacing: 8.0,
      );
      const spec2 = FlexSpec(
        direction: Axis.horizontal,
        spacing: 8.0,
      );
      const spec3 = FlexSpec(
        direction: Axis.horizontal,
        spacing: 10.0,
      );

      expect(spec1.props, equals(spec2.props));
      expect(spec1.props, isNot(equals(spec3.props)));
    });
  });

  group('FlexStyler Tests', () {
    testWidgets('resolves correctly with BuildContext', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final mix = FlexStyler(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8.0,
              );

              final resolved = mix.resolve(context);
              final spec = resolved.spec;

              expect(spec.direction, equals(Axis.horizontal));
              expect(spec.mainAxisAlignment, equals(MainAxisAlignment.center));
              expect(spec.spacing, equals(8.0));

              return Container();
            },
          ),
        ),
      );
    });

    test('merge works correctly', () {
      final mix1 = FlexStyler(
        direction: Axis.horizontal,
        spacing: 4.0,
      );

      final mix2 = FlexStyler(
        mainAxisAlignment: MainAxisAlignment.center,
      );

      final merged = mix1.merge(mix2);

      expect(merged, isA<FlexStyler>());
    });

    // Removed deprecated factory constructors; FlexStyler focuses on flex props only

    test('construct with props works correctly', () {
      final mix = FlexStyler(
        direction: Axis.vertical,
        spacing: 10.0,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      );

      expect(mix, isA<FlexStyler>());
    });
  });
}
