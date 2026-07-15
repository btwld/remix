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
          style: RemixPopoverStyler()
              .backgroundColor(Colors.purple)
              .paddingAll(12),
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

    testWidgets('keeps the semantic label when tap opening is disabled', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpRemixApp(
        const RemixPopover(
          openOnTap: false,
          semanticLabel: 'Account details',
          popoverChild: Text('Account details content'),
          child: Icon(Icons.person),
        ),
      );

      expect(find.bySemanticsLabel('Account details'), findsOneWidget);
      semantics.dispose();
    });

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
          styleSpec: RemixPopoverSpec(container: rawContainer),
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
      expect(box.styleSpec, same(rawContainer));
    });

    testWidgets('FortalPopover supplies the themed overlay style', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        const FortalPopover(
          popoverChild: Text('Fortal content'),
          child: Text('Open Fortal popover'),
        ),
      );

      await tester.tap(find.text('Open Fortal popover'));
      await tester.pumpAndSettle();

      expect(find.text('Fortal content'), findsOneWidget);
      expect(
        find.ancestor(
          of: find.text('Fortal content'),
          matching: find.byType(Box),
        ),
        findsOneWidget,
      );
    });
  });
}
