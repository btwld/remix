import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';

void main() {
  group('BoxSpec Tests', () {
    test('creates with default values', () {
      const spec = BoxSpec();

      expect(spec.decoration, isNull);
      expect(spec.foregroundDecoration, isNull);
      expect(spec.padding, isNull);
      expect(spec.margin, isNull);
      expect(spec.alignment, isNull);
      expect(spec.constraints, isNull);
      expect(spec.transform, isNull);
      expect(spec.transformAlignment, isNull);
      expect(spec.clipBehavior, isNull);
    });

    test('creates with specified values', () {
      const decoration = BoxDecoration(color: Colors.blue);
      const padding = EdgeInsets.all(16);
      const alignment = Alignment.center;
      const clipBehavior = Clip.antiAlias;

      const spec = BoxSpec(
        decoration: decoration,
        padding: padding,
        alignment: alignment,
        clipBehavior: clipBehavior,
      );

      expect(spec.decoration, equals(decoration));
      expect(spec.padding, equals(padding));
      expect(spec.alignment, equals(alignment));
      expect(spec.clipBehavior, equals(clipBehavior));
    });

    test('copyWith works correctly', () {
      const originalSpec = BoxSpec(
        decoration: BoxDecoration(color: Colors.blue),
        padding: EdgeInsets.all(16),
      );

      final modifiedSpec = originalSpec.copyWith(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(24),
      );

      expect(modifiedSpec.decoration, equals(originalSpec.decoration));
      expect(modifiedSpec.padding, equals(const EdgeInsets.all(24)));
      expect(modifiedSpec.alignment, equals(Alignment.topLeft));
    });

    test('copyWith with null values preserves original', () {
      const originalSpec = BoxSpec(
        decoration: BoxDecoration(color: Colors.blue),
        padding: EdgeInsets.all(16),
      );

      final modifiedSpec = originalSpec.copyWith();

      expect(modifiedSpec.decoration, equals(originalSpec.decoration));
      expect(modifiedSpec.padding, equals(originalSpec.padding));
    });

    test('lerp interpolates correctly', () {
      const spec1 = BoxSpec(
        padding: EdgeInsets.all(10),
        alignment: Alignment.topLeft,
        margin: EdgeInsets.all(5),
      );
      const spec2 = BoxSpec(
        padding: EdgeInsets.all(20),
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.all(15),
      );

      final lerpedSpec = spec1.lerp(spec2, 0.5);

      expect(lerpedSpec.padding, equals(const EdgeInsets.all(15)));
      expect(lerpedSpec.alignment, equals(Alignment.center));
      expect(lerpedSpec.margin, equals(const EdgeInsets.all(10)));
    });

    test('lerp with null other interpolates toward defaults', () {
      const spec = BoxSpec(padding: EdgeInsets.all(16));
      final result = spec.lerp(null, 0.5);
      expect(result.padding, equals(const EdgeInsets.all(8)));
    });

    test('props equality works correctly', () {
      const spec1 = BoxSpec(
        decoration: BoxDecoration(color: Colors.blue),
        padding: EdgeInsets.all(16),
      );
      const spec2 = BoxSpec(
        decoration: BoxDecoration(color: Colors.blue),
        padding: EdgeInsets.all(16),
      );
      const spec3 = BoxSpec(
        decoration: BoxDecoration(color: Colors.red),
        padding: EdgeInsets.all(16),
      );

      expect(spec1.props, equals(spec2.props));
      expect(spec1.props, isNot(equals(spec3.props)));
    });
  });

  group('BoxStyler Tests', () {
    testWidgets('resolves correctly with BuildContext', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final mix = BoxStyler(
                decoration: BoxDecorationMix(color: Colors.blue),
                padding: EdgeInsetsMix.all(16),
                alignment: Alignment.center,
                margin: EdgeInsetsMix.symmetric(horizontal: 8),
                clipBehavior: Clip.antiAlias,
              );

              final resolved = mix.resolve(context);

              final spec = resolved.spec;

              // Check actual resolved values
              expect(spec.decoration, isA<BoxDecoration>());
              expect((spec.decoration as BoxDecoration).color,
                  equals(Colors.blue));
              expect(spec.padding, equals(const EdgeInsets.all(16)));
              expect(spec.alignment, equals(Alignment.center));
              expect(spec.margin,
                  equals(const EdgeInsets.symmetric(horizontal: 8)));
              expect(spec.clipBehavior, equals(Clip.antiAlias));

              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('merge works correctly', () {
      final mix1 = BoxStyler(
        decoration: BoxDecorationMix(color: Colors.blue),
        padding: EdgeInsetsMix.all(16),
      );

      final mix2 = BoxStyler(
        decoration: BoxDecorationMix(color: Colors.red),
        margin: EdgeInsetsMix.all(8),
      );

      final merged = mix1.merge(mix2);

      // Test that the merged mix has the expected properties
      expect(merged, isA<BoxStyler>());
    });

    test('merge with null returns original', () {
      final mix = BoxStyler(
        padding: EdgeInsetsMix.all(16),
      );

      final result = mix.merge(null);
      expect(result, equals(mix));
    });

    test('constructors via named args create valid mixes', () {
      final colorMix =
          BoxStyler(decoration: BoxDecorationMix(color: Colors.red));
      expect(colorMix, isA<BoxStyler>());

      final decorationMix =
          BoxStyler(decoration: BoxDecorationMix(color: Colors.blue));
      expect(decorationMix, isA<BoxStyler>());

      final paddingMix = BoxStyler(padding: EdgeInsetsMix.all(20));
      expect(paddingMix, isA<BoxStyler>());

      final alignmentMix = BoxStyler(alignment: Alignment.center);
      expect(alignmentMix, isA<BoxStyler>());

      final marginMix = BoxStyler(margin: EdgeInsetsMix.all(12));
      expect(marginMix, isA<BoxStyler>());

      final transformMix = BoxStyler(transform: Matrix4.identity());
      expect(transformMix, isA<BoxStyler>());

      final clipMix = BoxStyler(clipBehavior: Clip.antiAlias);
      expect(clipMix, isA<BoxStyler>());

      final constraintsMix =
          BoxStyler(constraints: BoxConstraintsMix(minWidth: 100));
      expect(constraintsMix, isA<BoxStyler>());
    });

    test('merge composition works correctly', () {
      final mix = BoxStyler(decoration: BoxDecorationMix(color: Colors.green))
          .merge(BoxStyler(padding: EdgeInsetsMix.all(12)))
          .merge(BoxStyler(alignment: Alignment.bottomRight))
          .merge(BoxStyler(clipBehavior: Clip.hardEdge));

      expect(mix, isA<BoxStyler>());
    });

    test('props equality works correctly', () {
      final mix1 = BoxStyler(
        decoration: BoxDecorationMix(color: Colors.blue),
        padding: EdgeInsetsMix.all(16),
      );
      final mix2 = BoxStyler(
        decoration: BoxDecorationMix(color: Colors.blue),
        padding: EdgeInsetsMix.all(16),
      );
      final mix3 = BoxStyler(
        decoration: BoxDecorationMix(color: Colors.red),
        padding: EdgeInsetsMix.all(16),
      );

      expect(mix1.props, equals(mix2.props));
      expect(mix1.props, isNot(equals(mix3.props)));
    });

    test('can compose multiple operations via merge', () {
      final mix = BoxStyler(decoration: BoxDecorationMix(color: Colors.blue))
          .merge(BoxStyler(padding: EdgeInsetsMix.all(16)))
          .merge(BoxStyler(margin: EdgeInsetsMix.symmetric(horizontal: 8)))
          .merge(BoxStyler(alignment: Alignment.center))
          .merge(BoxStyler(clipBehavior: Clip.antiAlias));

      expect(mix, isA<BoxStyler>());
    });

    testWidgets('works in real widget context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final mix =
                    BoxStyler(decoration: BoxDecorationMix(color: Colors.blue))
                        .merge(BoxStyler(padding: EdgeInsetsMix.all(16)))
                        .merge(BoxStyler(alignment: Alignment.center))
                        .merge(BoxStyler(margin: EdgeInsetsMix.all(8)))
                        .merge(BoxStyler(clipBehavior: Clip.antiAlias));

                final resolvedSpec = mix.resolve(context);
                final spec = resolvedSpec.spec;

                // Verify resolved values before using in widget
                expect(spec.decoration, isA<BoxDecoration>());
                expect((spec.decoration as BoxDecoration).color,
                    equals(Colors.blue));
                expect(spec.padding, equals(const EdgeInsets.all(16)));
                expect(spec.alignment, equals(Alignment.center));
                expect(spec.margin, equals(const EdgeInsets.all(8)));
                expect(spec.clipBehavior, equals(Clip.antiAlias));

                return Container(
                  decoration: spec.decoration,
                  padding: spec.padding,
                  alignment: spec.alignment,
                  margin: spec.margin,
                  clipBehavior: spec.clipBehavior ?? Clip.none,
                  child: const Text('Test'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Test'), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
    });
  });
}
