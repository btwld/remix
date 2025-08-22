import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix/mix.dart';
import 'package:remix/src/helpers/spec/widget_flex_properties.dart';
import 'package:remix/src/helpers/spec/widget_flex_properties_mix.dart';

void main() {
  group('WidgetFlexProperties Tests', () {
    test('creates with default values', () {
      const spec = WidgetFlexProperties();
      
      expect(spec.decoration, isNull);
      expect(spec.padding, isNull);
      expect(spec.direction, isNull);
      expect(spec.mainAxisAlignment, isNull);
      expect(spec.gap, isNull);
    });

    test('creates with all values', () {
      const decoration = BoxDecoration(color: Colors.red);
      const padding = EdgeInsets.all(8);
      const alignment = Alignment.center;
      const direction = Axis.horizontal;
      const mainAxisAlignment = MainAxisAlignment.center;
      const crossAxisAlignment = CrossAxisAlignment.center;
      const gap = 8.0;

      const spec = WidgetFlexProperties(
        decoration: decoration,
        padding: padding,
        alignment: alignment,
        direction: direction,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        gap: gap,
      );

      expect(spec.decoration, equals(decoration));
      expect(spec.padding, equals(padding));
      expect(spec.alignment, equals(alignment));
      expect(spec.direction, equals(direction));
      expect(spec.mainAxisAlignment, equals(mainAxisAlignment));
      expect(spec.crossAxisAlignment, equals(crossAxisAlignment));
      expect(spec.gap, equals(gap));
    });

    test('copyWith works correctly', () {
      const originalSpec = WidgetFlexProperties(
        decoration: BoxDecoration(color: Colors.blue),
        padding: EdgeInsets.all(16),
        direction: Axis.vertical,
        gap: 4.0,
      );

      final newSpec = originalSpec.copyWith(
        decoration: const BoxDecoration(color: Colors.red),
        direction: Axis.horizontal,
      );

      expect(newSpec.decoration, equals(const BoxDecoration(color: Colors.red)));
      expect(newSpec.padding, equals(const EdgeInsets.all(16))); // preserved
      expect(newSpec.direction, equals(Axis.horizontal)); // updated
      expect(newSpec.gap, equals(4.0)); // preserved
    });

    test('lerp interpolates correctly', () {
      const spec1 = WidgetFlexProperties(
        padding: EdgeInsets.all(10),
        gap: 5.0,
        direction: Axis.horizontal,
      );
      const spec2 = WidgetFlexProperties(
        padding: EdgeInsets.all(20),
        gap: 15.0,
        direction: Axis.vertical,
      );

      final result = spec1.lerp(spec2, 0.5);

      expect(result.padding, equals(const EdgeInsets.all(15)));
      expect(result.gap, equals(10.0));
      expect(result.direction, equals(Axis.horizontal)); // t < 0.5, so spec1 value
    });

    test('props equality works correctly', () {
      const spec1 = WidgetFlexProperties(
        decoration: BoxDecoration(color: Colors.blue),
        direction: Axis.horizontal,
        gap: 8.0,
      );
      const spec2 = WidgetFlexProperties(
        decoration: BoxDecoration(color: Colors.blue),
        direction: Axis.horizontal,
        gap: 8.0,
      );
      const spec3 = WidgetFlexProperties(
        decoration: BoxDecoration(color: Colors.red),
        direction: Axis.horizontal,
        gap: 8.0,
      );

      expect(spec1.props, equals(spec2.props));
      expect(spec1.props, isNot(equals(spec3.props)));
    });
  });

  group('WidgetFlexPropertiesMix Tests', () {
    testWidgets('resolves correctly with BuildContext', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              final mix = WidgetFlexPropertiesMix(
                decoration: BoxDecorationMix(color: Colors.blue),
                padding: EdgeInsetsGeometryMix.all(16),
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                gap: 8.0,
              );

              final resolved = mix.resolve(context);

              expect(resolved.decoration, isA<BoxDecoration>());
              expect(resolved.padding, equals(const EdgeInsets.all(16)));
              expect(resolved.direction, equals(Axis.horizontal));
              expect(resolved.mainAxisAlignment, equals(MainAxisAlignment.center));
              expect(resolved.gap, equals(8.0));

              return Container();
            },
          ),
        ),
      );
    });

    test('merge works correctly', () {
      final mix1 = WidgetFlexPropertiesMix(
        decoration: BoxDecorationMix(color: Colors.blue),
        direction: Axis.horizontal,
        gap: 4.0,
      );

      final mix2 = WidgetFlexPropertiesMix(
        decoration: BoxDecorationMix(color: Colors.red),
        mainAxisAlignment: MainAxisAlignment.center,
      );

      final merged = mix1.merge(mix2);

      expect(merged, isA<WidgetFlexPropertiesMix>());
    });

    test('factory constructors work correctly', () {
      final colorMix = WidgetFlexPropertiesMix.color(Colors.red);
      expect(colorMix, isA<WidgetFlexPropertiesMix>());

      final horizontalMix = WidgetFlexPropertiesMix.horizontal(
        mainAxisAlignment: MainAxisAlignment.center,
        gap: 8.0,
      );
      expect(horizontalMix, isA<WidgetFlexPropertiesMix>());

      final verticalMix = WidgetFlexPropertiesMix.vertical(
        crossAxisAlignment: CrossAxisAlignment.start,
      );
      expect(verticalMix, isA<WidgetFlexPropertiesMix>());

      final rowMix = WidgetFlexPropertiesMix.row(gap: 12.0);
      expect(rowMix, isA<WidgetFlexPropertiesMix>());

      final columnMix = WidgetFlexPropertiesMix.column(gap: 6.0);
      expect(columnMix, isA<WidgetFlexPropertiesMix>());
    });

    test('chainable methods work correctly', () {
      final mix = WidgetFlexPropertiesMix()
          .color(Colors.green)
          .direction(Axis.vertical)
          .gap(10.0)
          .mainAxisAlignment(MainAxisAlignment.spaceEvenly);

      expect(mix, isA<WidgetFlexPropertiesMix>());
    });

    test('maybeValue handles null correctly', () {
      final result = WidgetFlexPropertiesMix.maybeValue(null);
      expect(result, isNull);

      const spec = WidgetFlexProperties(
        direction: Axis.horizontal,
        gap: 8.0,
      );
      final nonNullResult = WidgetFlexPropertiesMix.maybeValue(spec);
      expect(nonNullResult, isNotNull);
    });
  });
}