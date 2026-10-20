import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/src/rendering/remix_box_effects.dart'
    show RemixBoxAdapter;

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixSlider', () {
    group('Basic Rendering', () {
      testWidgets('renders slider with minimal props', (tester) async {
        await tester.pumpRemixApp(const RemixSlider(value: 0.5));
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('renders slider with custom range', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 50.0, min: 0.0, max: 100.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('renders slider at minimum value', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 0.0, min: 0.0, max: 1.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('renders slider at maximum value', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 1.0, min: 0.0, max: 1.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });
    });

    group('Value Validation', () {
      test('accepts value at lower boundary (min)', () {
        expect(
          () => RemixSlider(
            value: 0.0,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
          ),
          returnsNormally,
        );
      });

      test('accepts value at upper boundary (max)', () {
        expect(
          () => RemixSlider(
            value: 1.0,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
          ),
          returnsNormally,
        );
      });

      test('accepts value in middle range', () {
        expect(
          () => RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
          ),
          returnsNormally,
        );
      });

      test('throws assertion error when value is less than min', () {
        expect(
          () => RemixSlider(
            value: -0.1,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertion error when value is greater than max', () {
        expect(
          () => RemixSlider(
            value: 1.1,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertion error when min is greater than max', () {
        expect(
          () => RemixSlider(
            value: 0.5,
            min: 1.0,
            max: 0.0,
            onChanged: (value) {},
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertion error when min equals max', () {
        expect(
          () => RemixSlider(
            value: 0.0,
            min: 1.0,
            max: 1.0,
            onChanged: (value) {},
          ),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertion error when snapDivisions is zero', () {
        expect(
          () =>
              RemixSlider(value: 0.5, snapDivisions: 0, onChanged: (value) {}),
          throwsA(isA<AssertionError>()),
        );
      });

      test('throws assertion error when snapDivisions is negative', () {
        expect(
          () =>
              RemixSlider(value: 0.5, snapDivisions: -2, onChanged: (value) {}),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('Styling', () {
      testWidgets('applies custom style', (tester) async {
        final customStyle = SliderStyler().trackColor(Colors.blue);

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
        expect(
          tester
              .widgetList<Box>(find.byType(Box))
              .map((box) => box.styleSpec?.spec.decoration),
          contains(const BoxDecoration(color: Colors.blue)),
        );
      });

      testWidgets('applies thumb color styling', (tester) async {
        final customStyle = SliderStyler().thumbColor(Colors.red);

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
        expect(
          tester
              .widgetList<Box>(find.byType(Box))
              .map((box) => box.styleSpec?.spec.decoration),
          contains(const BoxDecoration(color: Colors.red)),
        );
      });

      testWidgets('applies range color styling', (tester) async {
        final customStyle = SliderStyler().rangeColor(Colors.green);

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
        expect(
          tester
              .widgetList<Box>(find.byType(Box))
              .map((box) => box.styleSpec?.spec.decoration),
          contains(const BoxDecoration(color: Colors.green)),
        );
      });

      testWidgets('applies thumb size styling', (tester) async {
        final customStyle = SliderStyler().thumbSize(const Size(24, 24));

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
        final thumb = tester
            .widgetList<RemixBoxAdapter>(find.byType(RemixBoxAdapter))
            .last;
        expect(tester.getSize(find.byWidget(thumb)), const Size(24, 24));
      });

      testWidgets('applies thickness styling', (tester) async {
        final customStyle = SliderStyler().thickness(12.0);

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
        final rails = tester
            .widgetList<RemixBoxAdapter>(find.byType(RemixBoxAdapter))
            .toList();
        expect(tester.getSize(find.byWidget(rails[0])).height, 12);
        expect(tester.getSize(find.byWidget(rails[1])).height, 12);
      });

      testWidgets('applies track thickness styling', (tester) async {
        final customStyle = SliderStyler().trackThickness(10.0);

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
        final rails = tester
            .widgetList<RemixBoxAdapter>(find.byType(RemixBoxAdapter))
            .toList();
        expect(tester.getSize(find.byWidget(rails[0])).height, 10);
        expect(tester.getSize(find.byWidget(rails[1])).height, 8);
      });

      testWidgets('applies range thickness styling', (tester) async {
        final customStyle = SliderStyler().rangeThickness(6.0);

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
        final rails = tester
            .widgetList<RemixBoxAdapter>(find.byType(RemixBoxAdapter))
            .toList();
        expect(tester.getSize(find.byWidget(rails[0])).height, 8);
        expect(tester.getSize(find.byWidget(rails[1])).height, 6);
      });
    });

    group('Different Values', () {
      testWidgets('renders slider at 0% (empty)', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 0.0, min: 0.0, max: 1.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('renders slider at 25%', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 0.25, min: 0.0, max: 1.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('renders slider at 50%', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 0.5, min: 0.0, max: 1.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('renders slider at 75%', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 0.75, min: 0.0, max: 1.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('renders slider at 100% (full)', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 1.0, min: 0.0, max: 1.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });
    });

    group('Snap Divisions', () {
      testWidgets('accepts snapDivisions parameter', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            snapDivisions: 10,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('handles null snapDivisions', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            snapDivisions: null,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });
    });

    group('Feedback', () {
      testWidgets('accepts enableFeedback parameter', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            enableFeedback: true,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('handles disabled feedback', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            enableFeedback: false,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles very small value', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 0.01, min: 0.0, max: 1.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('handles very large value', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 0.99, min: 0.0, max: 1.0, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('handles negative range', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(
            value: -50.0,
            min: -100.0,
            max: 0.0,
            onChanged: (value) {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('handles large range', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(
            value: 500.0,
            min: 0.0,
            max: 1000.0,
            onChanged: (value) {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('handles very small range', (tester) async {
        await tester.pumpRemixApp(
          RemixSlider(value: 0.005, min: 0.0, max: 0.01, onChanged: (value) {}),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });
    });

    group('Key Parameter', () {
      testWidgets('accepts and respects key parameter', (tester) async {
        const key = ValueKey('slider_key');

        await tester.pumpRemixApp(
          RemixSlider(
            key: key,
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byKey(key), findsOneWidget);
      });
    });

    group('Advanced Styling', () {
      testWidgets('applies multiple style methods', (tester) async {
        final customStyle = SliderStyler()
            .trackColor(Colors.blue)
            .rangeColor(Colors.red)
            .thumbColor(Colors.green)
            .thickness(12.0);

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('applies thumb styling with decoration', (tester) async {
        final customStyle = SliderStyler().thumb(
          BoxStyler(
            decoration: BoxDecorationMix(
              color: Colors.blue,
              borderRadius: BorderRadiusMix.circular(8.0),
            ),
          ),
        );

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });

      testWidgets('applies border radius styling', (tester) async {
        final customStyle = SliderStyler().borderRadius(
          BorderRadiusMix.circular(16.0),
        );

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });
    });

    group('Widget Modifiers', () {
      testWidgets('applies widget modifiers from style', (tester) async {
        final customStyle = SliderStyler().wrap(.clipOval());

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            style: customStyle,
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(RemixSlider), findsOneWidget);
      });
    });

    group('StyleSpec Parameter', () {
      testWidgets('applies raw styleSpec when provided', (tester) async {
        final spec = SliderSpec(
          thumb: const StyleSpec(
            spec: BoxSpec(decoration: BoxDecoration(color: Colors.red)),
          ),
        );

        await tester.pumpRemixApp(
          RemixSlider(
            value: 0.5,
            min: 0.0,
            max: 1.0,
            onChanged: (value) {},
            styleSpec: spec,
          ),
        );
        await tester.pumpAndSettle();

        final decorations = tester
            .widgetList<Box>(find.byType(Box))
            .map((box) => box.styleSpec?.spec.decoration);

        expect(
          decorations,
          contains(equals(const BoxDecoration(color: Colors.red))),
        );
      });
    });
  });
}
