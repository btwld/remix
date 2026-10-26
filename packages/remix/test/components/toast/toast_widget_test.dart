import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
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

    group('action placement', () {
      const message = 'Stored on this device.';
      const padding = 16.0;
      const gap = 12.0;
      final below = ToastStyler().actionPlacement(.below);

      Future<void> pumpToast(
        WidgetTester tester, {
        double availableWidth = 800,
        double textScale = 1,
        TextDirection textDirection = TextDirection.ltr,
        ToastStyler? style,
        bool withAction = true,
        VoidCallback? onUndo,
        VoidCallback? onDismiss,
      }) {
        return tester.pumpRemixApp(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: TextScaler.linear(textScale)),
              // Localizations gives an app's semantics tree its direction,
              // which orders the traversal; mirror it for the rtl cases.
              child: Semantics(
                container: true,
                explicitChildNodes: true,
                textDirection: textDirection,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: availableWidth),
                  child: RemixToast(
                    title: 'Draft saved',
                    description: message,
                    icon: Icons.check,
                    action: withAction
                        ? RemixToastAction(
                            label: 'Undo',
                            onPressed: onUndo ?? () {},
                          )
                        : null,
                    onDismiss: onDismiss ?? () {},
                    dismissLabel: 'Dismiss notification',
                    style: ToastStyler()
                        .padding(.all(padding))
                        .spacing(gap)
                        .merge(style ?? ToastStyler()),
                  ),
                ),
              ),
            ),
          ),
          textDirection: textDirection,
        );
      }

      Rect action(WidgetTester t) => t.getRect(find.byType(RemixButton));
      Rect close(WidgetTester t) => t.getRect(find.byType(RemixIconButton));
      Rect icon(WidgetTester t) => t.getRect(find.byIcon(Icons.check));
      Rect title(WidgetTester t) => t.getRect(find.text('Draft saved'));
      Rect description(WidgetTester t) => t.getRect(find.text(message));
      Rect toast(WidgetTester t) => t.getRect(find.byType(RemixToast));

      Map<String, Rect> layout(WidgetTester t) => {
        'toast': toast(t),
        'icon': icon(t),
        'title': title(t),
        'description': description(t),
        'action': action(t),
        'close': close(t),
      };

      testWidgets('keeps the action beside the message by default', (
        tester,
      ) async {
        await pumpToast(tester);

        expect(tester.takeException(), isNull);
        expect(action(tester).top, lessThan(description(tester).bottom));
        expect(
          action(tester).left,
          greaterThanOrEqualTo(description(tester).right),
        );
        expect(close(tester).left, greaterThanOrEqualTo(action(tester).right));
      });

      testWidgets('places the action below the message', (tester) async {
        await pumpToast(tester, style: below);

        final bounds = toast(tester);
        expect(tester.takeException(), isNull);
        expect(action(tester).top, description(tester).bottom + gap);
        expect(action(tester).left, title(tester).left);
        expect(action(tester).left, description(tester).left);
        // The close button stays on the first line at the trailing corner,
        // although the container centers its children by default.
        expect(close(tester).top, bounds.top + padding);
        expect(close(tester).right, bounds.right - padding);
        expect(icon(tester).top, bounds.top + padding);
        // The toast still wraps its content rather than filling the space.
        expect(bounds.width, lessThan(800));
      });

      testWidgets('ignores the placement without an action', (tester) async {
        await pumpToast(tester, withAction: false);
        final inline = [close(tester), description(tester), toast(tester)];

        await pumpToast(tester, withAction: false, style: below);
        expect([close(tester), description(tester), toast(tester)], inline);

        await pumpToast(tester, withAction: false, availableWidth: 200);
        expect(close(tester).top, lessThan(description(tester).bottom));
      });

      testWidgets('falls back to the stacked arrangement when narrow', (
        tester,
      ) async {
        await pumpToast(tester, availableWidth: 200, style: below);
        final stacked = layout(tester);

        await pumpToast(tester, availableWidth: 200);

        expect(tester.takeException(), isNull);
        expect(layout(tester), stacked);
        expect(action(tester).left, title(tester).left);
        expect(close(tester).top, toast(tester).top + padding);
        // The message keeps the width beside the icon instead of what the
        // controls would leave over.
        expect(description(tester).right, greaterThan(action(tester).left));
        expect(toast(tester).width, 200);
      });

      testWidgets('measures the width left by the style max width', (
        tester,
      ) async {
        await pumpToast(tester, style: ToastStyler().maxWidth(360));
        expect(action(tester).top, lessThan(description(tester).bottom));
        expect(toast(tester).width, lessThanOrEqualTo(360));

        await pumpToast(tester, style: ToastStyler().maxWidth(200));
        expect(
          action(tester).top,
          greaterThanOrEqualTo(description(tester).bottom),
        );
        expect(toast(tester).width, 200);
      });

      testWidgets('raises the fallback width with the text scale', (
        tester,
      ) async {
        await pumpToast(tester, availableWidth: 400);
        expect(action(tester).top, lessThan(description(tester).bottom));

        await pumpToast(tester, availableWidth: 400, textScale: 2);
        expect(tester.takeException(), isNull);
        expect(
          action(tester).top,
          greaterThanOrEqualTo(description(tester).bottom),
        );
      });

      testWidgets('lets a breakpoint variant switch the placement', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.reset);
        final style = ToastStyler().onBreakpoint(
          const Breakpoint.maxWidth(767),
          below,
        );

        // 340 is wide enough to keep the action inline without the variant.
        tester.view.physicalSize = const Size(375, 800);
        await pumpToast(tester, availableWidth: 340, style: style);
        expect(
          action(tester).top,
          greaterThanOrEqualTo(description(tester).bottom),
        );
        expect(close(tester).top, toast(tester).top + padding);

        tester.view.physicalSize = const Size(1024, 800);
        await pumpToast(tester, availableWidth: 340, style: style);
        expect(action(tester).top, lessThan(description(tester).bottom));
      });

      testWidgets(
        'can be sized by IntrinsicWidth when it has no inline action',
        (tester) async {
          Widget toast({required bool withAction, ToastStyler? style}) =>
              IntrinsicWidth(
                child: RemixToast(
                  title: 'Draft saved',
                  description: message,
                  action: withAction
                      ? RemixToastAction(label: 'Undo', onPressed: () {})
                      : null,
                  onDismiss: () {},
                  dismissLabel: 'Dismiss notification',
                  style: style ?? ToastStyler(),
                ),
              );

          await tester.pumpRemixApp(toast(withAction: true, style: below));
          expect(tester.takeException(), isNull);
          expect(
            action(tester).top,
            greaterThanOrEqualTo(description(tester).bottom),
          );

          await tester.pumpRemixApp(toast(withAction: false));
          expect(tester.takeException(), isNull);
        },
      );

      for (final direction in TextDirection.values) {
        for (final (name, width, style) in [
          ('below', 800.0, below),
          ('narrow', 200.0, null),
        ]) {
          testWidgets('mirrors the $name arrangement in $direction', (
            tester,
          ) async {
            await pumpToast(
              tester,
              availableWidth: width,
              style: style,
              textDirection: direction,
            );

            final bounds = toast(tester);
            final ltr = direction == TextDirection.ltr;
            // Distance of a rect's start and end edges from the toast's.
            double fromStart(Rect r) =>
                ltr ? r.left - bounds.left : bounds.right - r.right;
            double fromEnd(Rect r) =>
                ltr ? bounds.right - r.right : r.left - bounds.left;

            expect(tester.takeException(), isNull);
            expect(
              action(tester).top,
              greaterThanOrEqualTo(description(tester).bottom),
            );
            expect(fromStart(icon(tester)), padding);
            expect(fromEnd(close(tester)), padding);
            expect(close(tester).top, bounds.top + padding);
            expect(fromStart(action(tester)), fromStart(title(tester)));
            expect(fromStart(action(tester)), fromStart(description(tester)));
          });
        }
      }

      for (final (name, width, scale, style) in [
        ('inline', 800.0, 1.0, null),
        ('below', 800.0, 1.0, below),
        ('narrow', 200.0, 1.0, null),
        ('large text', 400.0, 2.0, null),
      ]) {
        for (final direction in TextDirection.values) {
          testWidgets('reads in order when $name in $direction', (
            tester,
          ) async {
            final handle = tester.ensureSemantics();
            await pumpToast(
              tester,
              availableWidth: width,
              textScale: scale,
              style: style,
              textDirection: direction,
            );

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
      }

      for (final (name, width, style) in [
        ('inline', 800.0, null),
        ('below', 800.0, below),
        ('narrow', 200.0, null),
      ]) {
        for (final direction in TextDirection.values) {
          testWidgets('tabs to the action before the close button when $name '
              'in $direction', (tester) async {
            await pumpToast(
              tester,
              availableWidth: width,
              style: style,
              textDirection: direction,
            );

            bool focusIsIn(Type type) {
              final focused = FocusManager.instance.primaryFocus?.context;
              return find
                  .descendant(
                    of: find.byType(type),
                    matching: find.byElementPredicate((e) => e == focused),
                  )
                  .evaluate()
                  .isNotEmpty;
            }

            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            expect(focusIsIn(RemixButton), isTrue);

            await tester.sendKeyEvent(LogicalKeyboardKey.tab);
            expect(focusIsIn(RemixIconButton), isTrue);
          });
        }
      }

      for (final (name, width, style) in [
        ('inline', 800.0, null),
        ('below', 800.0, below),
        ('narrow', 200.0, null),
      ]) {
        testWidgets('keeps both buttons tappable when $name', (tester) async {
          var undone = 0;
          var dismissed = 0;
          await pumpToast(
            tester,
            availableWidth: width,
            style: style,
            onUndo: () => undone++,
            onDismiss: () => dismissed++,
          );

          await tester.tap(find.widgetWithText(RemixButton, 'Undo'));
          await tester.tap(find.byType(RemixIconButton));

          expect(undone, 1);
          expect(dismissed, 1);
        });
      }
    });

    test('requires a dismiss label with onDismiss', () {
      expect(
        () => RemixToast(title: 'Saved', onDismiss: () {}),
        throwsAssertionError,
      );
    });
  });
}
