import 'package:naked_ui_example/api/naked_popover.0.dart' as popover_example;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../helpers/test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NakedPopover Integration Tests', () {
    testWidgets('popover opens and closes correctly', (tester) async {
      // Use the actual example app
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: popover_example.PopoverExample()),
        ),
      );
      await tester.pumpAndSettle();

      // Find the trigger for the popover (text inside the trigger container)
      final triggerButtonFinder = find.text('Show Popover');
      expect(triggerButtonFinder, findsOneWidget);

      // Initially, popover content should not be visible
      expect(find.text('Popover Content'), findsNothing);

      // Tap to open popover
      await tester.tap(triggerButtonFinder);
      await tester.pumpAndSettle();

      // Verify popover content is now visible
      expect(find.text('Popover Content'), findsOneWidget);

      // Tap outside to close popover
      await tester.tapAt(const Offset(150, 1));
      await tester.pumpAndSettle();

      // Verify popover content is closed
      expect(find.text('Popover Content'), findsNothing);
    });

    testWidgets('popover trigger reports hover state', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NakedPopover(
                popoverBuilder: (context, info) =>
                    const Text('Popover Content'),
                builder: (context, state, child) =>
                    Text(state.isHovered ? 'Hovered' : 'Idle'),
              ),
            ),
          ),
        ),
      );
      expect(find.text('Idle'), findsOneWidget);

      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(find.text('Idle')));
      await tester.pumpAndSettle();
      expect(find.text('Hovered'), findsOneWidget);
      // Hover alone does not open a popover.
      expect(find.text('Popover Content'), findsNothing);

      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(find.text('Idle'), findsOneWidget);
    });

    testWidgets('popover handles keyboard activation', (tester) async {
      final popoverKey = UniqueKey();
      final triggerFocusNode = tester.createManagedFocusNode();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NakedPopover(
                key: popoverKey,
                triggerFocusNode: triggerFocusNode,
                popoverBuilder: (context, info) =>
                    const Text('Popover Content'),
                child: const Text('Trigger'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Popover Content'), findsNothing);

      await tester.pressKeyOn(triggerFocusNode, LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(
        find.text('Popover Content'),
        findsOneWidget,
        reason: 'Enter on the focused trigger must open the popover',
      );
    });

    testWidgets('popover sits below the trigger with its side offset', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: popover_example.PopoverExample())),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Show Popover'));
      await tester.pumpAndSettle();

      // The example uses side: bottom, alignment: center, sideOffset: 8.
      final trigger = tester.getRect(
        find
            .ancestor(
              of: find.text('Show Popover'),
              matching: find.byType(Container),
            )
            .first,
      );
      final panel = tester.getRect(
        find.ancestor(
          of: find.text('Popover Content'),
          matching: find.byType(popover_example.PopoverMenu),
        ),
      );
      expect(panel.top, moreOrLessEquals(trigger.bottom + 8, epsilon: 0.5));
      expect(
        panel.center.dx,
        moreOrLessEquals(trigger.center.dx, epsilon: 0.5),
      );
    });

    testWidgets('popover closes from its content and from Escape', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: Center(child: popover_example.PopoverExample())),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Show Popover'));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.text('Show Popover')),
        isSemantics(isButton: true, hasExpandedState: true, isExpanded: true),
      );
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);

      await tester.tap(find.text('Show Popover'));
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
      expect(
        tester.getSemantics(find.text('Show Popover')),
        isSemantics(
          isButton: true,
          hasExpandedState: true,
          isExpanded: false,
          isFocused: true,
        ),
      );
      semantics.dispose();
    });
  });
}
