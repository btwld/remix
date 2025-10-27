import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixProgress Basic Rendering', () {
    testWidgets('renders progress with minimal props', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.5));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('renders progress with value 0', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.0));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('renders progress with value 1', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 1.0));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('renders progress with custom style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.75,
          style: RemixProgressStyle()
              .height(20.0)
              .trackColor(Colors.grey)
              .indicatorColor(Colors.blue),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });
  });

  group('RemixProgress Value Validation', () {
    test('accepts value at lower boundary (0)', () {
      expect(() => const RemixProgress(value: 0.0), returnsNormally);
    });

    test('accepts value at upper boundary (1)', () {
      expect(() => const RemixProgress(value: 1.0), returnsNormally);
    });

    test('accepts value in middle range', () {
      expect(() => const RemixProgress(value: 0.5), returnsNormally);
    });

    test('throws assertion error when value is less than 0', () {
      expect(() => RemixProgress(value: -0.1), throwsA(isA<AssertionError>()));
    });

    test('throws assertion error when value is greater than 1', () {
      expect(() => RemixProgress(value: 1.1), throwsA(isA<AssertionError>()));
    });
  });

  group('RemixProgress Styling Tests', () {
    testWidgets('applies height style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(value: 0.5, style: RemixProgressStyle().height(30.0)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies width style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(value: 0.5, style: RemixProgressStyle().width(200.0)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies track color style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().trackColor(Colors.grey),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies indicator color style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().indicatorColor(Colors.blue),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies padding style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().padding(EdgeInsetsGeometryMix.all(16.0)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies margin style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().margin(EdgeInsetsGeometryMix.all(8.0)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies combined styles', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle()
              .height(20.0)
              .width(300.0)
              .trackColor(Colors.grey.shade300)
              .indicatorColor(Colors.blue)
              .padding(EdgeInsetsGeometryMix.all(8.0)),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });
  });

  group('RemixProgress Different Values', () {
    testWidgets('renders progress at 0% (empty)', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.0));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('renders progress at 25%', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.25));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('renders progress at 50%', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.5));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('renders progress at 75%', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.75));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('renders progress at 100% (full)', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 1.0));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });
  });

  group('RemixProgress Layout Tests', () {
    testWidgets('contains LayoutBuilder widget', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.5));
      await tester.pumpAndSettle();

      expect(find.byType(LayoutBuilder), findsOneWidget);
    });

    testWidgets('contains SizedBox widget', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.5));
      await tester.pumpAndSettle();

      expect(find.byType(SizedBox), findsWidgets);
    });
  });

  group('RemixProgress Edge Cases', () {
    testWidgets('handles very small progress value', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.01));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('handles very large progress value', (tester) async {
      await tester.pumpRemixApp(const RemixProgress(value: 0.99));
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('handles progress with styleSpec directly', (tester) async {
      await tester.pumpRemixApp(
        const RemixProgress(
          value: 0.5,
          styleSpec: StyleSpec(spec: RemixProgressSpec()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });
  });

  group('RemixProgress Advanced Styling', () {
    testWidgets('applies track styler', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().track(
            BoxStyler(
              decoration: BoxDecorationMix(
                color: Colors.grey,
                borderRadius: BorderRadiusMix.circular(8.0),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies indicator styler', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().indicator(
            BoxStyler(
              decoration: BoxDecorationMix(
                color: Colors.blue,
                borderRadius: BorderRadiusMix.circular(8.0),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies trackContainer styler', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().trackContainer(
            BoxStyler(
              decoration: BoxDecorationMix(
                border: BoxBorderMix.all(BorderSideMix(color: Colors.black)),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies alignment style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().alignment(Alignment.center),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies constraints style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().constraints(
            BoxConstraintsMix(minWidth: 200.0, maxWidth: 400.0),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies decoration style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().decoration(
            BoxDecorationMix(
              color: Colors.white,
              borderRadius: BorderRadiusMix.circular(12.0),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies foregroundDecoration style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().foregroundDecoration(
            BoxDecorationMix(
              border: BoxBorderMix.all(BorderSideMix(color: Colors.red)),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });

    testWidgets('applies transform style', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().transform(Matrix4.identity()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });
  });

  group('RemixProgress Widget Modifiers', () {
    testWidgets('applies wrap modifier', (tester) async {
      await tester.pumpRemixApp(
        RemixProgress(
          value: 0.5,
          style: RemixProgressStyle().wrap(WidgetModifierConfig.clipOval()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(RemixProgress), findsOneWidget);
    });
  });

  group('RemixProgress Key Tests', () {
    testWidgets('accepts key parameter', (tester) async {
      const key = ValueKey('progress_key');

      await tester.pumpRemixApp(const RemixProgress(key: key, value: 0.5));
      await tester.pumpAndSettle();

      expect(find.byKey(key), findsOneWidget);
    });
  });
}
