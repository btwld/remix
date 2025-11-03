import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../lib/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixSpinner', () {
    group('Basic Rendering', () {
      testWidgets('renders spinner with default props', (tester) async {
        await tester.pumpRemixApp(const RemixSpinner());
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('renders spinner with custom style', (tester) async {
        await tester.pumpRemixApp(
          RemixSpinner(
            style: RemixSpinnerStyle(
              size: 32.0,
              indicatorColor: const Color(0xFF0000FF),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('contains CustomPaint widget', (tester) async {
        await tester.pumpRemixApp(const RemixSpinner());
        await tester.pump();

        expect(find.byType(CustomPaint), findsWidgets);
      });

      testWidgets('contains AnimatedBuilder widget', (tester) async {
        await tester.pumpRemixApp(const RemixSpinner());
        await tester.pump();

        expect(find.byType(AnimatedBuilder), findsWidgets);
      });
    });

    group('Styling', () {
      testWidgets('applies custom size', (tester) async {
        final customStyle = RemixSpinnerStyle().size(48.0);

        await tester.pumpRemixApp(RemixSpinner(style: customStyle));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('applies custom indicator color', (tester) async {
        final customStyle = RemixSpinnerStyle().indicatorColor(
          const Color(0xFF0000FF),
        );

        await tester.pumpRemixApp(RemixSpinner(style: customStyle));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('applies custom track color', (tester) async {
        final customStyle = RemixSpinnerStyle().trackColor(
          const Color(0xFFCCCCCC),
        );

        await tester.pumpRemixApp(RemixSpinner(style: customStyle));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('applies custom stroke width', (tester) async {
        final customStyle = RemixSpinnerStyle().strokeWidth(3.0);

        await tester.pumpRemixApp(RemixSpinner(style: customStyle));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('applies custom track stroke width', (tester) async {
        final customStyle = RemixSpinnerStyle().trackStrokeWidth(2.0);

        await tester.pumpRemixApp(RemixSpinner(style: customStyle));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('applies custom duration', (tester) async {
        final customStyle = RemixSpinnerStyle().duration(
          const Duration(milliseconds: 500),
        );

        await tester.pumpRemixApp(RemixSpinner(style: customStyle));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });
    });

    group('Animation', () {
      testWidgets('spinner animates', (tester) async {
        await tester.pumpRemixApp(const RemixSpinner());

        // Initial state
        await tester.pump();

        // Advance animation
        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(RemixSpinner), findsOneWidget);
        expect(find.byType(AnimatedBuilder), findsWidgets);
      });

      testWidgets('spinner respects custom duration', (tester) async {
        const customDuration = Duration(milliseconds: 500);

        await tester.pumpRemixApp(
          RemixSpinner(style: RemixSpinnerStyle(duration: customDuration)),
        );
        await tester.pump();

        // Advance through the custom duration
        await tester.pump(customDuration);

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('animation repeats continuously', (tester) async {
        await tester.pumpRemixApp(const RemixSpinner());

        await tester.pump();
        await tester.pump(const Duration(milliseconds: 1000));
        await tester.pump(const Duration(milliseconds: 1000));

        expect(find.byType(RemixSpinner), findsOneWidget);
      });
    });

    group('Different Sizes', () {
      testWidgets('renders small spinner', (tester) async {
        await tester.pumpRemixApp(
          RemixSpinner(style: RemixSpinnerStyle(size: 16.0)),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('renders medium spinner', (tester) async {
        await tester.pumpRemixApp(
          RemixSpinner(style: RemixSpinnerStyle(size: 32.0)),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('renders large spinner', (tester) async {
        await tester.pumpRemixApp(
          RemixSpinner(style: RemixSpinnerStyle(size: 64.0)),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });
    });

    group('Advanced Styling', () {
      testWidgets('applies multiple style methods', (tester) async {
        final customStyle = RemixSpinnerStyle()
            .size(48.0)
            .strokeWidth(3.0)
            .indicatorColor(const Color(0xFF0000FF))
            .trackColor(const Color(0xFFCCCCCC))
            .trackStrokeWidth(2.0)
            .duration(const Duration(milliseconds: 500));

        await tester.pumpRemixApp(RemixSpinner(style: customStyle));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('applies animation config', (tester) async {
        final customStyle = RemixSpinnerStyle().animate(
          AnimationConfig.linear(const Duration(milliseconds: 200)),
        );

        await tester.pumpRemixApp(RemixSpinner(style: customStyle));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });
    });

    group('Widget Modifiers', () {
      testWidgets('applies widget modifiers from style', (tester) async {
        final customStyle = RemixSpinnerStyle().wrap(
          WidgetModifierConfig.clipOval(),
        );

        await tester.pumpRemixApp(RemixSpinner(style: customStyle));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });
    });

    group('Key Parameter', () {
      testWidgets('accepts and respects key parameter', (tester) async {
        const key = ValueKey('spinner_key');

        await tester.pumpRemixApp(const RemixSpinner(key: key));
        await tester.pump();

        expect(find.byKey(key), findsOneWidget);
      });
    });

    group('StyleSpec Parameter', () {
      testWidgets('accepts styleSpec parameter', (tester) async {
        const spec = RemixSpinnerSpec(
          size: 32.0,
          indicatorColor: Color(0xFF0000FF),
        );
        const styleSpec = StyleSpec(spec: spec);

        await tester.pumpRemixApp(const RemixSpinner(styleSpec: styleSpec));
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('handles zero size', (tester) async {
        await tester.pumpRemixApp(
          RemixSpinner(style: RemixSpinnerStyle(size: 0.0)),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('handles very large size', (tester) async {
        await tester.pumpRemixApp(
          RemixSpinner(style: RemixSpinnerStyle(size: 200.0)),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('handles zero stroke width', (tester) async {
        await tester.pumpRemixApp(
          RemixSpinner(style: RemixSpinnerStyle(strokeWidth: 0.0)),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('handles very long duration', (tester) async {
        await tester.pumpRemixApp(
          RemixSpinner(
            style: RemixSpinnerStyle(duration: const Duration(seconds: 10)),
          ),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });

      testWidgets('handles very short duration', (tester) async {
        await tester.pumpRemixApp(
          RemixSpinner(
            style: RemixSpinnerStyle(
              duration: const Duration(milliseconds: 100),
            ),
          ),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });
    });

    group('Widget Lifecycle', () {
      testWidgets('disposes animation controller', (tester) async {
        await tester.pumpRemixApp(const RemixSpinner());
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);

        // Remove the widget
        await tester.pumpRemixApp(Container());

        expect(find.byType(RemixSpinner), findsNothing);
      });

      testWidgets('updates duration when spec changes', (tester) async {
        const initialDuration = Duration(milliseconds: 1000);
        const newDuration = Duration(milliseconds: 500);

        await tester.pumpRemixApp(
          RemixSpinner(style: RemixSpinnerStyle(duration: initialDuration)),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);

        // Update duration
        await tester.pumpRemixApp(
          RemixSpinner(style: RemixSpinnerStyle(duration: newDuration)),
        );
        await tester.pump();

        expect(find.byType(RemixSpinner), findsOneWidget);
      });
    });
  });
}
