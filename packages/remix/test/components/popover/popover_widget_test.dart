import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('RemixPopover', () {
    testWidgets('is closed by default and opens styled content on tap', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixPopover(
          popoverChild: const Text('Popover content'),
          style: PopoverStyler().color(Colors.purple).padding(.all(12)),
          child: const Text('Open popover'),
        ),
      );

      expect(find.text('Open popover'), findsOneWidget);
      expect(find.text('Popover content'), findsNothing);

      await tester.tap(find.text('Open popover'));
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Popover content'),
          matching: find.byType(Box),
        ),
        findsOneWidget,
      );
    });

    testWidgets('closes on an outside tap and reports lifecycle changes', (
      tester,
    ) async {
      var openCount = 0;
      var closeCount = 0;

      await tester.pumpRemixApp(
        RemixPopover(
          popoverChild: const Text('Popover content'),
          onOpen: () => openCount++,
          onClose: () => closeCount++,
          child: const Text('Open popover'),
        ),
      );

      await tester.tap(find.text('Open popover'));
      await tester.pumpAndSettle();

      expect(openCount, 1);
      expect(closeCount, 0);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsNothing);
      expect(closeCount, 1);
    });

    testWidgets('supports programmatic control when tap opening is disabled', (
      tester,
    ) async {
      final controller = MenuController();

      await tester.pumpRemixApp(
        RemixPopover(
          controller: controller,
          openOnTap: false,
          popoverChild: const Text('Popover content'),
          child: const Text('Popover trigger'),
        ),
      );

      await tester.tap(find.text('Popover trigger'));
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsNothing);

      controller.open();
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsOneWidget);

      controller.close();
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('Escape closes the popover and restores trigger focus', (
      tester,
    ) async {
      final triggerFocusNode = FocusNode(debugLabel: 'popover trigger');
      addTearDown(triggerFocusNode.dispose);

      await tester.pumpRemixApp(
        RemixPopover(
          triggerFocusNode: triggerFocusNode,
          popoverChild: const Text('Popover content'),
          child: const Text('Open popover'),
        ),
      );

      await tester.tap(find.text('Open popover'));
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Popover content'), findsNothing);
      expect(triggerFocusNode.hasFocus, isTrue);
    });

    // NakedPopover wraps the child of an openOnTap: false popover in its own
    // focusable Focus. These tests pin that wrapper's effect on a button child:
    // it is an extra tab stop, and it, not the button, takes focus back when
    // the popover closes.
    group('openOnTap: false with a button child', () {
      Future<FocusNode> pumpButtonPopover(WidgetTester tester) async {
        final controller = MenuController();
        final before = FocusNode();
        final after = FocusNode();
        addTearDown(before.dispose);
        addTearDown(after.dispose);
        await tester.pumpRemixApp(
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Focus(focusNode: before, child: const SizedBox(height: 20)),
              RemixPopover(
                controller: controller,
                openOnTap: false,
                popoverChild: const Text('Popover content'),
                child: RemixButton(
                  label: 'Open popover',
                  onPressed: () => controller.isOpen
                      ? controller.close()
                      : controller.open(),
                ),
              ),
              Focus(focusNode: after, child: const SizedBox(height: 20)),
            ],
          ),
        );
        return before..requestFocus();
      }

      Future<FocusNode> tab(WidgetTester tester) async {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        return FocusManager.instance.primaryFocus!;
      }

      bool isInsideButton(FocusNode node) =>
          node.context!.findAncestorWidgetOfExactType<RemixButton>() != null;

      testWidgets('the wrapper is a tab stop ahead of the button', (
        tester,
      ) async {
        final before = await pumpButtonPopover(tester);
        await tester.pump();

        final wrapper = await tab(tester);
        expect(isInsideButton(wrapper), isFalse);
        expect(find.byType(RemixButton), findsOneWidget);

        final button = await tab(tester);
        expect(isInsideButton(button), isTrue);
        expect(button.ancestors, contains(wrapper));

        final next = await tab(tester);
        expect(isInsideButton(next), isFalse);
        expect(next, isNot(same(before)));
        expect(next, isNot(same(wrapper)));
      });

      testWidgets('closing returns focus to the wrapper, not the button', (
        tester,
      ) async {
        await pumpButtonPopover(tester);
        await tester.pump();
        final wrapper = await tab(tester);
        final button = await tab(tester);
        expect(button.hasPrimaryFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(find.text('Popover content'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('Popover content'), findsNothing);
        expect(FocusManager.instance.primaryFocus, same(wrapper));
        expect(button.hasFocus, isFalse);
      });
    });

    testWidgets('forwards the trigger semantic label', (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpRemixApp(
        const RemixPopover(
          semanticLabel: 'Show account details',
          popoverChild: Text('Account details'),
          child: Icon(Icons.person),
        ),
      );

      expect(find.bySemanticsLabel('Show account details'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets(
      'controlled mode preserves child semantics and reports expanded state',
      (tester) async {
        final semantics = tester.ensureSemantics();
        final controller = MenuController();
        var activationCount = 0;

        await tester.pumpRemixApp(
          RemixPopover(
            controller: controller,
            openOnTap: false,
            semanticLabel: 'Configured popover label',
            popoverChild: const Text('Controlled content'),
            child: TextButton(
              onPressed: () {
                activationCount++;
                controller.open();
              },
              child: const Text('Open controlled popover'),
            ),
          ),
        );

        final trigger = find.widgetWithText(
          TextButton,
          'Open controlled popover',
        );
        final semanticsTrigger = find.semantics.byLabel(
          'Open controlled popover',
        );
        expect(semanticsTrigger, findsOne);
        expect(
          find.semantics.byLabel('Configured popover label'),
          findsNothing,
        );
        expect(
          tester.getSemantics(trigger),
          isSemantics(
            label: 'Open controlled popover',
            isButton: true,
            hasTapAction: true,
            hasExpandedState: true,
            isExpanded: false,
          ),
        );

        tester.semantics.tap(semanticsTrigger);
        await tester.pumpAndSettle();

        expect(activationCount, 1);
        expect(find.text('Controlled content'), findsOneWidget);
        expect(
          tester.getSemantics(trigger),
          isSemantics(hasExpandedState: true, isExpanded: true),
        );
        semantics.dispose();
      },
    );

    testWidgets('reports collapsed and expanded trigger semantics', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpRemixApp(
        const RemixPopover(
          semanticLabel: 'Show account details',
          popoverChild: Text('Account details'),
          child: Icon(Icons.person),
        ),
      );

      final trigger = find.bySemanticsLabel('Show account details');
      expect(
        tester.getSemantics(trigger),
        isSemantics(
          label: 'Show account details',
          isButton: true,
          hasTapAction: true,
          hasExpandedState: true,
          isExpanded: false,
        ),
      );

      await tester.tap(trigger);
      await tester.pumpAndSettle();

      expect(
        tester.getSemantics(trigger),
        isSemantics(hasExpandedState: true, isExpanded: true),
      );
      semantics.dispose();
    });

    testWidgets('uses a raw style spec when supplied', (tester) async {
      const rawContainer = StyleSpec(
        spec: BoxSpec(constraints: BoxConstraints.tightFor(width: 240)),
      );

      await tester.pumpRemixApp(
        const RemixPopover(
          styleSpec: PopoverSpec(container: rawContainer),
          popoverChild: Text('Raw styled content'),
          child: Text('Open popover'),
        ),
      );

      await tester.tap(find.text('Open popover'));
      await tester.pumpAndSettle();

      final box = tester.widget<Box>(
        find.ancestor(
          of: find.text('Raw styled content'),
          matching: find.byType(Box),
        ),
      );
      expect(box.styleSpec, equals(rawContainer));
    });
  });
}
