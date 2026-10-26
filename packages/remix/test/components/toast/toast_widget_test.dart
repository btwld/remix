import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixToast', () {
    testWidgets('renders title, description, and icon', (tester) async {
      await tester.pumpRemixApp(
        const RemixToast(
          title: 'Draft saved',
          description: 'Stored on this device.',
          icon: Icons.check,
        ),
      );

      expect(find.text('Draft saved'), findsOneWidget);
      expect(find.text('Stored on this device.'), findsOneWidget);
      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byType(RemixButton), findsNothing);
      expect(find.byType(RemixIconButton), findsNothing);
    });

    testWidgets('composes the action and close button', (tester) async {
      var undone = 0;
      var dismissed = 0;
      await tester.pumpRemixApp(
        RemixToast(
          title: 'Draft saved',
          action: RemixToastAction(label: 'Undo', onPressed: () => undone++),
          onDismiss: () => dismissed++,
          dismissLabel: 'Dismiss notification',
        ),
      );

      await tester.tap(find.widgetWithText(RemixButton, 'Undo'));
      await tester.tap(find.byType(RemixIconButton));

      expect(undone, 1);
      expect(dismissed, 1);
      expect(
        tester
            .widget<RemixIconButton>(find.byType(RemixIconButton))
            .semanticLabel,
        'Dismiss notification',
      );
    });

    testWidgets('keeps a short message at its intrinsic width', (tester) async {
      await tester.pumpRemixApp(const RemixToast(title: 'Saved'));

      expect(
        tester.getSize(find.byType(RemixToast)).width,
        lessThan(tester.getSize(find.byType(Scaffold)).width),
      );
    });

    testWidgets('announces its text unless message semantics are excluded', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpRemixApp(const RemixToast(title: 'Draft saved'));
      expect(find.semantics.byLabel('Draft saved'), findsOne);

      await tester.pumpRemixApp(
        const RemixToast(title: 'Draft saved', excludeMessageSemantics: true),
      );
      expect(find.semantics.byLabel('Draft saved'), findsNothing);
      semantics.dispose();
    });

    testWidgets('passes composed control styles through StyleProvider', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixToast(
          title: 'Draft saved',
          action: RemixToastAction(label: 'Undo', onPressed: () {}),
          style: ToastStyler().action(ButtonStyler().height(44)),
        ),
      );

      expect(tester.getSize(find.byType(RemixButton)).height, 44);
    });

    group('narrow layout', () {
      const message = 'Stored on this device.';

      Future<void> pumpToast(
        WidgetTester tester, {
        required double availableWidth,
        double textScale = 1,
        TextDirection textDirection = TextDirection.ltr,
        ToastStyler? style,
        VoidCallback? onUndo,
        VoidCallback? onDismiss,
      }) {
        return tester.pumpRemixApp(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: availableWidth),
                child: RemixToast(
                  title: 'Draft saved',
                  description: message,
                  icon: Icons.check,
                  action: RemixToastAction(
                    label: 'Undo',
                    onPressed: onUndo ?? () {},
                  ),
                  onDismiss: onDismiss ?? () {},
                  dismissLabel: 'Dismiss notification',
                  style: ToastStyler()
                      .padding(.all(16))
                      .spacing(12)
                      .merge(style ?? ToastStyler()),
                ),
              ),
            ),
          ),
          textDirection: textDirection,
        );
      }

      Rect action(WidgetTester t) => t.getRect(find.byType(RemixButton));
      Rect close(WidgetTester t) => t.getRect(find.byType(RemixIconButton));
      Rect description(WidgetTester t) => t.getRect(find.text(message));
      Rect toast(WidgetTester t) => t.getRect(find.byType(RemixToast));

      /// Whether the controls sit beside the message rather than below it.
      bool controlsInline(WidgetTester t) =>
          action(t).top < description(t).bottom;

      testWidgets('keeps the controls beside the message when wide', (
        tester,
      ) async {
        await pumpToast(tester, availableWidth: 800);

        expect(tester.takeException(), isNull);
        expect(controlsInline(tester), isTrue);
        expect(close(tester).top, lessThan(description(tester).bottom));
        expect(action(tester).left, greaterThan(description(tester).left));
      });

      testWidgets('moves the controls below the message when narrow', (
        tester,
      ) async {
        var undone = 0;
        var dismissed = 0;
        await pumpToast(
          tester,
          availableWidth: 200,
          onUndo: () => undone++,
          onDismiss: () => dismissed++,
        );

        expect(tester.takeException(), isNull);
        expect(
          action(tester).top,
          greaterThanOrEqualTo(description(tester).bottom),
        );
        expect(
          close(tester).top,
          greaterThanOrEqualTo(description(tester).bottom),
        );
        // The controls share one row, and the message keeps the full width
        // beside the icon instead of what the controls leave over.
        expect(action(tester).center.dy, close(tester).center.dy);
        expect(description(tester).right, greaterThan(action(tester).left));
        expect(toast(tester).width, 200);

        await tester.tap(find.widgetWithText(RemixButton, 'Undo'));
        await tester.tap(find.byType(RemixIconButton));
        expect(undone, 1);
        expect(dismissed, 1);
      });

      testWidgets('measures the width left by the style max width', (
        tester,
      ) async {
        await pumpToast(
          tester,
          availableWidth: 800,
          style: ToastStyler().maxWidth(360),
        );
        expect(controlsInline(tester), isTrue);
        expect(toast(tester).width, lessThanOrEqualTo(360));

        await pumpToast(
          tester,
          availableWidth: 800,
          style: ToastStyler().maxWidth(200),
        );
        expect(controlsInline(tester), isFalse);
        expect(toast(tester).width, 200);
      });

      testWidgets('wraps at a width that fits at normal text size only', (
        tester,
      ) async {
        await pumpToast(tester, availableWidth: 400);
        expect(controlsInline(tester), isTrue);

        await pumpToast(tester, availableWidth: 400, textScale: 2);
        expect(tester.takeException(), isNull);
        expect(
          action(tester).top,
          greaterThanOrEqualTo(description(tester).bottom),
        );
      });

      for (final direction in TextDirection.values) {
        testWidgets('anchors the wrapped controls at the end in $direction', (
          tester,
        ) async {
          await pumpToast(
            tester,
            availableWidth: 200,
            textDirection: direction,
          );

          final bounds = toast(tester);
          final ltr = direction == TextDirection.ltr;
          expect(tester.takeException(), isNull);
          expect(
            action(tester).top,
            greaterThanOrEqualTo(description(tester).bottom),
          );
          // The icon leads, and the controls trail with the action before
          // the close button in reading order.
          final icon = tester.getRect(find.byIcon(Icons.check));
          expect(ltr ? icon.left - bounds.left : bounds.right - icon.right, 16);
          expect(
            ltr
                ? bounds.right - close(tester).right
                : close(tester).left - bounds.left,
            16,
          );
          expect(
            ltr
                ? action(tester).right <= close(tester).left
                : close(tester).right <= action(tester).left,
            isTrue,
          );
        });
      }

      testWidgets('does not stack a toast without controls', (tester) async {
        await tester.pumpRemixApp(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: const RemixToast(title: 'Saved'),
          ),
        );

        expect(tester.getSize(find.byType(RemixToast)).width, lessThan(200));
      });

      for (final (name, width, scale) in [
        ('wide', 800.0, 1.0),
        ('narrow', 200.0, 1.0),
        ('large text', 400.0, 2.0),
      ]) {
        testWidgets('keeps the semantics in reading order when $name', (
          tester,
        ) async {
          final handle = tester.ensureSemantics();
          await pumpToast(tester, availableWidth: width, textScale: scale);

          final labels = <String>[];
          void collect(SemanticsNode node) {
            if (node.label.isNotEmpty) labels.add(node.label);
            node
                .debugListChildrenInOrder(
                  DebugSemanticsDumpOrder.traversalOrder,
                )
                .forEach(collect);
          }

          collect(tester.getSemantics(find.byType(RemixToast)));
          expect(labels, [
            'Draft saved',
            'Stored on this device.',
            'Undo',
            'Dismiss notification',
          ]);
          handle.dispose();
        });
      }

      testWidgets('exposes each node once when narrow in rtl', (tester) async {
        final handle = tester.ensureSemantics();
        await pumpToast(
          tester,
          availableWidth: 200,
          textDirection: TextDirection.rtl,
        );

        expect(find.semantics.byLabel('Draft saved'), findsOne);
        expect(find.semantics.byLabel('Stored on this device.'), findsOne);
        expect(find.semantics.byLabel('Undo'), findsOne);
        expect(find.semantics.byLabel('Dismiss notification'), findsOne);
        handle.dispose();
      });
    });

    test('requires a dismiss label with onDismiss', () {
      expect(
        () => RemixToast(title: 'Saved', onDismiss: () {}),
        throwsAssertionError,
      );
    });
  });
}
