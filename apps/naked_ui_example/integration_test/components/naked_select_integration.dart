import 'package:naked_ui_example/api/naked_select.0.dart' as select_example;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:naked_ui/naked_ui.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NakedSelect Integration Tests', () {
    testWidgets('select opens and closes correctly', (tester) async {
      // Use the actual example app
      await tester.pumpWidget(const select_example.MyApp());
      await tester.pump(const Duration(milliseconds: 100));

      final selectFinder = find.byType(NakedSelect<String>);
      expect(selectFinder, findsOneWidget);

      // Initially dropdown should be closed
      expect(find.text('Apple'), findsNothing);

      // Tap to open dropdown
      await tester.tap(selectFinder);
      await tester.pumpAndSettle();

      // Dropdown should be open now
      expect(find.text('Apple'), findsOneWidget);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Orange'), findsOneWidget);

      // Escape closes it and the trigger reports collapsed.
      final semantics = tester.ensureSemantics();
      expect(
        tester.getSemantics(find.text('Choose fruit...')),
        isSemantics(isButton: true, hasExpandedState: true, isExpanded: true),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);
      expect(
        tester.getSemantics(find.text('Choose fruit...')),
        isSemantics(isButton: true, hasExpandedState: true, isExpanded: false),
      );
      semantics.dispose();
    });

    testWidgets('Escape returns focus to the trigger', (tester) async {
      final triggerFocusNode = FocusNode();
      addTearDown(triggerFocusNode.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: _fruitSelect(triggerFocusNode: triggerFocusNode),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Fruit'));
      await tester.pumpAndSettle();
      expect(triggerFocusNode.hasFocus, isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsNothing);
      expect(triggerFocusNode.hasFocus, isTrue);
    });

    testWidgets('a controlled select opens and closes through its owner', (
      tester,
    ) async {
      final requests = <bool>[];
      var open = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) => _fruitSelect(
                  open: open,
                  onOpenChanged: (value) {
                    requests.add(value);
                    setState(() => open = value);
                  },
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Fruit'));
      await tester.pumpAndSettle();
      expect(requests, [true]);
      expect(find.text('Apple'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(requests, [true, false]);
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('a select inside a popover closes before the popover', (
      tester,
    ) async {
      var open = false;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NakedPopover(
                popoverBuilder: (context, info) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Popover content'),
                    // Owner state lives outside the popover builder.
                    StatefulBuilder(
                      builder: (context, setState) => _fruitSelect(
                        open: open,
                        onOpenChanged: (value) => setState(() => open = value),
                      ),
                    ),
                  ],
                ),
                child: const Text('Open popover'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open popover'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Fruit'));
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Apple'), findsNothing);
      expect(find.text('Popover content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('single selection mode works correctly', (tester) async {
      String? selectedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  return NakedSelect<String>(
                    value: selectedValue,
                    onChanged: (value) => setState(() => selectedValue = value),
                    overlayBuilder: (context, info) {
                      return Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NakedSelectOption<String>(
                              value: 'Apple',
                              child: Text('Apple'),
                            ),
                            NakedSelectOption<String>(
                              value: 'Banana',
                              child: Text('Banana'),
                            ),
                          ],
                        ),
                      );
                    },
                    builder: (context, state, child) {
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(selectedValue ?? 'Select an option'),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open dropdown
      await tester.tap(find.text('Select an option'));
      await tester.pumpAndSettle();

      // Select an item (use .last pattern for overlay items)
      await tester.tap(find.text('Apple').last);
      await tester.pumpAndSettle();

      // Verify selection
      expect(selectedValue, 'Apple');
      expect(find.text('Apple'), findsOneWidget); // Should show selected value

      // Dropdown should be closed
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('onSelectedValueChanged callback works', (tester) async {
      String? lastSelectedValue;
      int callbackCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NakedSelect<String>(
                value: null,
                onChanged: (value) {
                  lastSelectedValue = value;
                  callbackCount++;
                },
                overlayBuilder: (context, info) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NakedSelectOption<String>(
                          value: 'Test Value',
                          child: Text('Test Value'),
                        ),
                      ],
                    ),
                  );
                },
                builder: (context, state, _) => const Text('Select'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open and select
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Test Value').last);
      await tester.pumpAndSettle();

      // Verify callback
      expect(lastSelectedValue, 'Test Value');
      expect(callbackCount, 1);
    });

    testWidgets('closeOnSelect behavior works correctly', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NakedSelect<String>(
                value: null,
                closeOnSelect: true,
                onChanged: (value) {},
                overlayBuilder: (context, info) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey),
                    ),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NakedSelectOption<String>(
                          value: 'Option 1',
                          child: Text('Option 1'),
                        ),
                        NakedSelectOption<String>(
                          value: 'Option 2',
                          child: Text('Option 2'),
                        ),
                      ],
                    ),
                  );
                },
                builder: (context, state, _) => const Text('Select'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Open dropdown
      await tester.tap(find.text('Select'));
      await tester.pumpAndSettle();
      expect(find.text('Option 1'), findsOneWidget);
      expect(find.text('Option 2'), findsOneWidget);

      // Select an item
      await tester.tap(find.text('Option 1').last);
      await tester.pumpAndSettle();

      // Dropdown should be closed (closeOnSelect: true)
      expect(find.text('Option 2'), findsNothing);
    });

    testWidgets('disabled select blocks interactions', (tester) async {
      bool wasCallbackCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NakedSelect<String>(
                value: null,
                enabled: false,
                onChanged: (value) => wasCallbackCalled = true,
                overlayBuilder: (context, info) {
                  return Container(
                    padding: const EdgeInsets.all(8),
                    child: const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NakedSelectOption<String>(
                          value: 'dummy',
                          child: Text('Menu Content'),
                        ),
                      ],
                    ),
                  );
                },
                builder: (context, state, _) => const Text('Disabled Select'),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Try to tap - should not open
      await tester.tap(find.text('Disabled Select'));
      await tester.pumpAndSettle();

      // Menu should not be open
      expect(find.text('Menu Content'), findsNothing);
      expect(wasCallbackCalled, isFalse);
    });

    testWidgets('works with example app interaction', (tester) async {
      // Test the full example with hover states and complex styling
      await tester.pumpWidget(const select_example.MyApp());
      await tester.pumpAndSettle();

      // Open dropdown via the trigger (tap the select widget itself)
      final selectFinder = find.byType(NakedSelect<String>);
      expect(selectFinder, findsOneWidget);
      await tester.tap(selectFinder);
      await tester.pumpAndSettle();

      // Select an option (use .last pattern for overlay items)
      await tester.tap(find.text('Banana').last);
      await tester.pumpAndSettle();

      // Dropdown should close and show selected value
      expect(find.text('Apple'), findsNothing); // Menu closed

      // Test that we can open again and see the selection reflected
      await tester.tap(selectFinder);
      await tester.pumpAndSettle();

      // Should see all options again (scope to menu items to avoid trigger label)
      expect(
        find.descendant(
          of: find.byType(NakedSelectOption<String>),
          matching: find.text('Apple'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(NakedSelectOption<String>),
          matching: find.text('Banana'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byType(NakedSelectOption<String>),
          matching: find.text('Orange'),
        ),
        findsOneWidget,
      );
    });
  });
}

Widget _fruitSelect({
  bool? open,
  ValueChanged<bool>? onOpenChanged,
  FocusNode? triggerFocusNode,
}) => NakedSelect<String>(
  open: open,
  onOpenChanged: onOpenChanged,
  triggerFocusNode: triggerFocusNode,
  onChanged: (_) {},
  builder: (context, state, child) =>
      const Padding(padding: EdgeInsets.all(12), child: Text('Fruit')),
  overlayBuilder: (context, info) => const ColoredBox(
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NakedSelectOption<String>(value: 'apple', child: Text('Apple')),
        NakedSelectOption<String>(value: 'banana', child: Text('Banana')),
      ],
    ),
  ),
);
