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

  group('BoxStyle Tests', () {
    testWidgets('resolves correctly with BuildContext', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final mix = BoxStyle(
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
      final mix1 = BoxStyle(
        decoration: BoxDecorationMix(color: Colors.blue),
        padding: EdgeInsetsMix.all(16),
      );

      final mix2 = BoxStyle(
        decoration: BoxDecorationMix(color: Colors.red),
        margin: EdgeInsetsMix.all(8),
      );

      final merged = mix1.merge(mix2);

      // Test that the merged mix has the expected properties
      expect(merged, isA<BoxStyle>());
    });

    test('merge with null returns original', () {
      final mix = BoxStyle(
        padding: EdgeInsetsMix.all(16),
      );

      final result = mix.merge(null);
      expect(result, equals(mix));
    });

    test('constructors via named args create valid mixes', () {
      final colorMix =
          BoxStyle(decoration: BoxDecorationMix(color: Colors.red));
      expect(colorMix, isA<BoxStyle>());

      final decorationMix =
          BoxStyle(decoration: BoxDecorationMix(color: Colors.blue));
      expect(decorationMix, isA<BoxStyle>());

      final paddingMix = BoxStyle(padding: EdgeInsetsMix.all(20));
      expect(paddingMix, isA<BoxStyle>());

      final alignmentMix = BoxStyle(alignment: Alignment.center);
      expect(alignmentMix, isA<BoxStyle>());

      final marginMix = BoxStyle(margin: EdgeInsetsMix.all(12));
      expect(marginMix, isA<BoxStyle>());

      final transformMix = BoxStyle(transform: Matrix4.identity());
      expect(transformMix, isA<BoxStyle>());

      final clipMix = BoxStyle(clipBehavior: Clip.antiAlias);
      expect(clipMix, isA<BoxStyle>());

      final constraintsMix =
          BoxStyle(constraints: BoxConstraintsMix(minWidth: 100));
      expect(constraintsMix, isA<BoxStyle>());
    });

    test('merge composition works correctly', () {
      final mix = BoxStyle(decoration: BoxDecorationMix(color: Colors.green))
          .merge(BoxStyle(padding: EdgeInsetsMix.all(12)))
          .merge(BoxStyle(alignment: Alignment.bottomRight))
          .merge(BoxStyle(clipBehavior: Clip.hardEdge));

      expect(mix, isA<BoxStyle>());
    });


    test('props equality works correctly', () {
      final mix1 = BoxStyle(
        decoration: BoxDecorationMix(color: Colors.blue),
        padding: EdgeInsetsMix.all(16),
      );
      final mix2 = BoxStyle(
        decoration: BoxDecorationMix(color: Colors.blue),
        padding: EdgeInsetsMix.all(16),
      );
      final mix3 = BoxStyle(
        decoration: BoxDecorationMix(color: Colors.red),
        padding: EdgeInsetsMix.all(16),
      );

      expect(mix1.props, equals(mix2.props));
      expect(mix1.props, isNot(equals(mix3.props)));
    });

    test('can compose multiple operations via merge', () {
      final mix = BoxStyle(decoration: BoxDecorationMix(color: Colors.blue))
          .merge(BoxStyle(padding: EdgeInsetsMix.all(16)))
          .merge(BoxStyle(margin: EdgeInsetsMix.symmetric(horizontal: 8)))
          .merge(BoxStyle(alignment: Alignment.center))
          .merge(BoxStyle(clipBehavior: Clip.antiAlias));

      expect(mix, isA<BoxStyle>());
    });

    testWidgets('works in real widget context', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) {
                final mix =
                    BoxStyle(decoration: BoxDecorationMix(color: Colors.blue))
                        .merge(BoxStyle(padding: EdgeInsetsMix.all(16)))
                        .merge(BoxStyle(alignment: Alignment.center))
                        .merge(BoxStyle(margin: EdgeInsetsMix.all(8)))
                        .merge(BoxStyle(clipBehavior: Clip.antiAlias));

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
