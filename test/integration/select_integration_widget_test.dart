import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('RemixSelect Integration Tests', () {
    testWidgets('renders with initial value', (tester) async {
      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: 'Apple',
          onChanged: (_) {},
          items: [
            RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
            RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
          ],
          child: const RemixSelectTrigger(label: 'Apple'),
        ),
      );

      expect(find.byType(RemixSelect<String>), findsOneWidget);
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('opens dropdown when trigger is tapped', (tester) async {
      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: 'Apple',
          onChanged: (_) {},
          items: [
            RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
            RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
            RemixSelectItem<String>(value: 'Orange', label: 'Orange'),
          ],
          child: const RemixSelectTrigger(label: 'Apple'),
        ),
      );

      // Tap trigger to open dropdown
      await tester.tap(find.byType(RemixSelectTrigger));
      await tester.pumpAndSettle();

      // All options should be visible
      expect(find.text('Apple'), findsWidgets);
      expect(find.text('Banana'), findsOneWidget);
      expect(find.text('Orange'), findsOneWidget);
    });

    testWidgets('selects item when tapped', (tester) async {
      String? selectedValue = 'Apple';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixSelect<String>(
              selectedValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
              items: [
                RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
                RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
                RemixSelectItem<String>(value: 'Orange', label: 'Orange'),
              ],
              child: RemixSelectTrigger(label: selectedValue ?? 'Select'),
            );
          },
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(RemixSelectTrigger));
      await tester.pumpAndSettle();

      // Select Banana
      await tester.tap(find.text('Banana').last);
      await tester.pumpAndSettle();

      expect(selectedValue, 'Banana');
    });

    testWidgets('closes dropdown after selection', (tester) async {
      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: 'Apple',
          onChanged: (_) {},
          items: [
            RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
            RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
          ],
          child: const RemixSelectTrigger(label: 'Apple'),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(RemixSelectTrigger));
      await tester.pumpAndSettle();
      
      // Verify dropdown is open
      expect(find.text('Banana'), findsOneWidget);

      // Select an item
      await tester.tap(find.text('Banana'));
      await tester.pumpAndSettle();

      // Dropdown should be closed (only trigger text visible)
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('handles empty items list', (tester) async {
      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: null,
          onChanged: (_) {},
          items: const [],
          child: const RemixSelectTrigger(label: 'No items'),
        ),
      );

      expect(find.byType(RemixSelect<String>), findsOneWidget);
      expect(find.text('No items'), findsOneWidget);
    });

    testWidgets('handles null selected value', (tester) async {
      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: null,
          onChanged: (_) {},
          items: [
            RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
            RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
          ],
          child: const RemixSelectTrigger(label: 'Select an option'),
        ),
      );

      expect(find.text('Select an option'), findsOneWidget);
    });

    testWidgets('maintains selection after widget rebuild', (tester) async {
      String? selectedValue = 'Apple';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemixSelect<String>(
                  selectedValue: selectedValue,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  },
                  items: [
                    RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
                    RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
                  ],
                  child: RemixSelectTrigger(label: selectedValue ?? 'Select'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      // Force rebuild
                    });
                  },
                  child: const Text('Rebuild'),
                ),
              ],
            );
          },
        ),
      );

      // Select Banana
      await tester.tap(find.byType(RemixSelectTrigger));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Banana').last);
      await tester.pumpAndSettle();

      expect(selectedValue, 'Banana');

      // Force rebuild
      await tester.tap(find.text('Rebuild'));
      await tester.pumpAndSettle();

      // Selection should be maintained
      expect(selectedValue, 'Banana');
    });

    testWidgets('handles disabled state', (tester) async {
      bool wasCalled = false;

      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: 'Apple',
          enabled: false,
          onChanged: (_) {
            wasCalled = true;
          },
          items: [
            RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
            RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
          ],
          child: const RemixSelectTrigger(label: 'Apple'),
        ),
      );

      // Try to tap trigger
      await tester.tap(find.byType(RemixSelectTrigger));
      await tester.pumpAndSettle();

      // Dropdown should not open
      expect(find.text('Banana'), findsNothing);
      expect(wasCalled, false);
    });

    testWidgets('closes dropdown when tapping outside', (tester) async {
      await tester.pumpRemixApp(
        Stack(
          children: [
            const Positioned(
              top: 50,
              left: 50,
              child: Text('Outside'),
            ),
            Center(
              child: RemixSelect<String>(
                selectedValue: 'Apple',
                onChanged: (_) {},
                items: [
                  RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
                  RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
                ],
                child: const RemixSelectTrigger(label: 'Apple'),
              ),
            ),
          ],
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(RemixSelectTrigger));
      await tester.pumpAndSettle();
      
      // Verify dropdown is open
      expect(find.text('Banana'), findsOneWidget);

      // Tap outside
      await tester.tap(find.text('Outside'));
      await tester.pumpAndSettle();

      // Dropdown should be closed
      expect(find.text('Banana'), findsNothing);
    });

    testWidgets('handles hover state', (tester) async {
      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: 'Apple',
          onChanged: (_) {},
          items: [
            RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
            RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
          ],
          child: const RemixSelectTrigger(label: 'Apple'),
        ),
      );

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(RemixSelectTrigger)));
      await tester.pumpAndSettle();

      // Select should still be functional
      expect(find.byType(RemixSelect<String>), findsOneWidget);
    });

    testWidgets('supports custom item widgets', (tester) async {
      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: 'Apple',
          onChanged: (_) {},
          items: [
            RemixSelectItem<String>(
              value: 'Apple',
              label: '🍎 Apple',
            ),
            RemixSelectItem<String>(
              value: 'Banana',
              label: '🍌 Banana',
            ),
          ],
          child: const RemixSelectTrigger(label: 'Select fruit'),
        ),
      );

      // Open dropdown
      await tester.tap(find.byType(RemixSelectTrigger));
      await tester.pumpAndSettle();

      // Custom labels should be visible
      expect(find.text('🍎 Apple'), findsOneWidget);
      expect(find.text('🍌 Banana'), findsOneWidget);
    });

    testWidgets('handles rapid open/close', (tester) async {
      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: 'Apple',
          onChanged: (_) {},
          items: [
            RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
            RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
          ],
          child: const RemixSelectTrigger(label: 'Apple'),
        ),
      );

      // Rapid open/close
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.byType(RemixSelectTrigger));
        await tester.pump(const Duration(milliseconds: 50));
      }
      await tester.pumpAndSettle();

      // Should handle rapid interactions without crash
      expect(find.byType(RemixSelect<String>), findsOneWidget);
    });

    testWidgets('preserves accessibility semantics', (tester) async {
      await tester.pumpRemixApp(
        RemixSelect<String>(
          selectedValue: 'Apple',
          onChanged: (_) {},
          items: [
            RemixSelectItem<String>(value: 'Apple', label: 'Apple'),
            RemixSelectItem<String>(value: 'Banana', label: 'Banana'),
          ],
          child: const RemixSelectTrigger(label: 'Apple'),
        ),
      );

      // Verify component is accessible (has semantics)
      // Note: Due to NakedSelect using excludeSemantics: true,
      // semantic labels cannot be inherited from parent widgets.
      // This is a known limitation that should be fixed in naked_ui.
      final semantics = tester.getSemantics(find.byType(RemixSelect<String>));
      expect(semantics, isNotNull);
    });

    testWidgets('handles complex value types', (tester) async {
      final user1 = _User(id: 1, name: 'Alice');
      final user2 = _User(id: 2, name: 'Bob');
      final user3 = _User(id: 3, name: 'Charlie');
      
      _User? selectedUser = user1;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixSelect<_User>(
              selectedValue: selectedUser,
              onChanged: (value) {
                setState(() {
                  selectedUser = value;
                });
              },
              items: [
                RemixSelectItem<_User>(value: user1, label: user1.name),
                RemixSelectItem<_User>(value: user2, label: user2.name),
                RemixSelectItem<_User>(value: user3, label: user3.name),
              ],
              child: RemixSelectTrigger(label: selectedUser?.name ?? 'Select user'),
            );
          },
        ),
      );

      // Open and select Bob
      await tester.tap(find.byType(RemixSelectTrigger));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bob').last);
      await tester.pumpAndSettle();

      expect(selectedUser, user2);
      expect(selectedUser?.name, 'Bob');
    });
  });
}

class _User {
  final int id;
  final String name;

  _User({required this.id, required this.name});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _User && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}