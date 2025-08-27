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

    test('lerp with null other returns original', () {
      const spec = BoxSpec(padding: EdgeInsets.all(16));
      final result = spec.lerp(null, 0.5);
      expect(result, equals(spec));
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

  group('BoxMix Tests', () {
    testWidgets('resolves correctly with BuildContext', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final mix = BoxMix(
                decoration: BoxDecorationMix(color: Colors.blue),
                padding: EdgeInsetsMix.all(16),
                alignment: Alignment.center,
                margin: EdgeInsetsMix.symmetric(horizontal: 8),
                clipBehavior: Clip.antiAlias,
              );

              final resolved = mix.resolve(context);

              // Check actual resolved values
              expect(resolved.decoration, isA<BoxDecoration>());
              expect((resolved.decoration as BoxDecoration).color,
                  equals(Colors.blue));
              expect(resolved.padding, equals(const EdgeInsets.all(16)));
              expect(resolved.alignment, equals(Alignment.center));
              expect(resolved.margin,
                  equals(const EdgeInsets.symmetric(horizontal: 8)));
              expect(resolved.clipBehavior, equals(Clip.antiAlias));

              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('merge works correctly', () {
      final mix1 = BoxMix(
        decoration: BoxDecorationMix(color: Colors.blue),
        padding: EdgeInsetsMix.all(16),
      );

      final mix2 = BoxMix(
        decoration: BoxDecorationMix(color: Colors.red),
        margin: EdgeInsetsMix.all(8),
      );

      final merged = mix1.merge(mix2);

      // Test that the merged mix has the expected properties
      expect(merged, isA<BoxMix>());
    });

    test('merge with null returns original', () {
      final mix = BoxMix(
        padding: EdgeInsetsMix.all(16),
      );

      final result = mix.merge(null);
      expect(result, equals(mix));
    });

    test('constructors via named args create valid mixes', () {
      final colorMix = BoxMix(decoration: BoxDecorationMix(color: Colors.red));
      expect(colorMix, isA<BoxMix>());

      final decorationMix =
          BoxMix(decoration: BoxDecorationMix(color: Colors.blue));
      expect(decorationMix, isA<BoxMix>());

      final paddingMix = BoxMix(padding: EdgeInsetsMix.all(20));
      expect(paddingMix, isA<BoxMix>());

      final alignmentMix = BoxMix(alignment: Alignment.center);
      expect(alignmentMix, isA<BoxMix>());

      final marginMix = BoxMix(margin: EdgeInsetsMix.all(12));
      expect(marginMix, isA<BoxMix>());

      final transformMix = BoxMix(transform: Matrix4.identity());
      expect(transformMix, isA<BoxMix>());

      final clipMix = BoxMix(clipBehavior: Clip.antiAlias);
      expect(clipMix, isA<BoxMix>());

      final constraintsMix =
          BoxMix(constraints: BoxConstraintsMix(minWidth: 100));
      expect(constraintsMix, isA<BoxMix>());
    });

    test('merge composition works correctly', () {
      final mix = BoxMix(decoration: BoxDecorationMix(color: Colors.green))
          .merge(BoxMix(padding: EdgeInsetsMix.all(12)))
          .merge(BoxMix(alignment: Alignment.bottomRight))
          .merge(BoxMix(clipBehavior: Clip.hardEdge));

      expect(mix, isA<BoxMix>());
    });

    testWidgets('value constructor works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              const spec = BoxSpec(
                decoration: BoxDecoration(color: Colors.blue),
                padding: EdgeInsets.all(16),
                alignment: Alignment.center,
                margin: EdgeInsets.all(8),
                clipBehavior: Clip.hardEdge,
              );

              final mix = BoxMix.value(spec);
              final resolved = mix.resolve(context);

              // Check that all values are preserved correctly
              expect(resolved.decoration, equals(spec.decoration));
              expect(resolved.padding, equals(spec.padding));
              expect(resolved.alignment, equals(spec.alignment));
              expect(resolved.margin, equals(spec.margin));
              expect(resolved.clipBehavior, equals(spec.clipBehavior));

              return const SizedBox();
            },
          ),
        ),
      );
    });

    test('maybeValue handles null correctly', () {
      final result = BoxMix.maybeValue(null);
      expect(result, isNull);

      const spec = BoxSpec(padding: EdgeInsets.all(16));
      final nonNullResult = BoxMix.maybeValue(spec);
      expect(nonNullResult, isNotNull);
    });

    test('props equality works correctly', () {
      final mix1 = BoxMix(
        decoration: BoxDecorationMix(color: Colors.blue),
        padding: EdgeInsetsMix.all(16),
      );
      final mix2 = BoxMix(
        decoration: BoxDecorationMix(color: Colors.blue),
        padding: EdgeInsetsMix.all(16),
      );
      final mix3 = BoxMix(
        decoration: BoxDecorationMix(color: Colors.red),
        padding: EdgeInsetsMix.all(16),
      );

      expect(mix1.props, equals(mix2.props));
      expect(mix1.props, isNot(equals(mix3.props)));
    });

    test('can compose multiple operations via merge', () {
      final mix = BoxMix(decoration: BoxDecorationMix(color: Colors.blue))
          .merge(BoxMix(padding: EdgeInsetsMix.all(16)))
          .merge(BoxMix(margin: EdgeInsetsMix.symmetric(horizontal: 8)))
          .merge(BoxMix(alignment: Alignment.center))
          .merge(BoxMix(clipBehavior: Clip.antiAlias));

      expect(mix, isA<BoxMix>());
    });

    testWidgets('works in real widget context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final mix =
                    BoxMix(decoration: BoxDecorationMix(color: Colors.blue))
                        .merge(BoxMix(padding: EdgeInsetsMix.all(16)))
                        .merge(BoxMix(alignment: Alignment.center))
                        .merge(BoxMix(margin: EdgeInsetsMix.all(8)))
                        .merge(BoxMix(clipBehavior: Clip.antiAlias));

                final spec = mix.resolve(context);

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
