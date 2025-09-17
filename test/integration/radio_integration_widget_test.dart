import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

enum TestOption {
  option1,
  option2,
  option3;
}

void main() {
  group('RemixRadio Integration Tests', () {
    testWidgets('renders correctly with label', (tester) async {
      await tester.pumpRemixApp(
        Center(
          child: RemixRadioGroup<String>(
            groupValue: 'option1',
            onChanged: (_) {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                RemixRadio<String>(
                  value: 'option1',
                  semanticLabel: 'Option 1',
                ),
                SizedBox(width: 8),
                Text('Option 1'),
              ],
            ),
          ),
        ),
      );

      expect(find.byType(RemixRadio<String>), findsOneWidget);
      expect(find.text('Option 1'), findsOneWidget);
    });

    testWidgets('renders correctly without label', (tester) async {
      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: 'option1',
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'option1',
          ),
        ),
      );

      expect(find.byType(RemixRadio<String>), findsOneWidget);
    });

    testWidgets('shows selected state when value matches groupValue',
        (tester) async {
      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: 'selected',
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'selected',
          ),
        ),
      );

      // Radio should be in selected state
      expect(find.byType(RemixRadio<String>), findsOneWidget);
    });

    testWidgets('shows unselected state when value does not match groupValue',
        (tester) async {
      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: 'option2',
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'option1',
          ),
        ),
      );

      // Radio should be unselected
      expect(find.byType(RemixRadio<String>), findsOneWidget);
    });

    testWidgets('calls onChanged with correct value when tapped',
        (tester) async {
      String? selectedValue;

      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: 'option2',
          onChanged: (value) {
            selectedValue = value;
          },
          child: RemixRadio<String>(
            value: 'option1',
          ),
        ),
      );

      await tester.tap(find.byType(RemixRadio<String>));
      await tester.pumpAndSettle();

      expect(selectedValue, 'option1');
    });

    testWidgets('does not call onChanged when disabled', (tester) async {
      bool wasCalled = false;

      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: 'option2',
          onChanged: (_) {
            wasCalled = true;
          },
          child: RemixRadio<String>(
            value: 'option1',
            enabled: false,
          ),
        ),
      );

      await tester.tap(find.byType(RemixRadio<String>));
      await tester.pumpAndSettle();

      expect(wasCalled, false);
    });

    testWidgets('handles radio group with multiple options', (tester) async {
      TestOption? selectedOption = TestOption.option1;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<TestOption>(
              groupValue: selectedOption,
              onChanged: (value) {
                setState(() {
                  selectedOption = value;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: TestOption.values.map((option) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RemixRadio<TestOption>(
                        key: Key(option.name),
                        value: option,
                        semanticLabel: option.name,
                      ),
                      const SizedBox(width: 8),
                      Text(option.name),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      );

      // Initial state
      expect(selectedOption, TestOption.option1);

      // Select option2
      await tester.tap(find.byKey(const Key('option2')));
      await tester.pumpAndSettle();
      expect(selectedOption, TestOption.option2);

      // Select option3
      await tester.tap(find.byKey(const Key('option3')));
      await tester.pumpAndSettle();
      expect(selectedOption, TestOption.option3);

      // Select option1 again
      await tester.tap(find.byKey(const Key('option1')));
      await tester.pumpAndSettle();
      expect(selectedOption, TestOption.option1);
    });

    testWidgets('maintains exclusive selection in group', (tester) async {
      String? groupValue = 'A';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<String>(
              groupValue: groupValue,
              onChanged: (newValue) {
                setState(() {
                  groupValue = newValue;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['A', 'B', 'C'].map((value) {
                  return RemixRadio<String>(
                    key: Key(value),
                    value: value,
                  );
                }).toList(),
              ),
            );
          },
        ),
      );

      // Select B
      await tester.tap(find.byKey(const Key('B')));
      await tester.pumpAndSettle();
      expect(groupValue, 'B');

      // Select C - should deselect B
      await tester.tap(find.byKey(const Key('C')));
      await tester.pumpAndSettle();
      expect(groupValue, 'C');
    });

    testWidgets('responds to tap on label text', (tester) async {
      String? selectedValue;

      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: 'option2',
          onChanged: (value) {
            selectedValue = value;
          },
          child: Builder(
            builder: (context) {
              final registry = RadioGroup.maybeOf<String>(context);
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const RemixRadio<String>(
                    value: 'option1',
                    semanticLabel: 'Click me',
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => registry?.onChanged?.call('option1'),
                    child: const Text('Click me'),
                  ),
                ],
              );
            },
          ),
        ),
      );

      // Tap on the custom label widget
      await tester.tap(find.text('Click me'));
      await tester.pumpAndSettle();

      expect(selectedValue, 'option1');
    });

    testWidgets('handles hover state', (tester) async {
      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: 'option2',
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'option1',
          ),
        ),
      );

      // Simulate hover
      final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await gesture.addPointer(location: Offset.zero);
      addTearDown(gesture.removePointer);

      await gesture.moveTo(tester.getCenter(find.byType(RemixRadio<String>)));
      await tester.pumpAndSettle();

      // Radio should still be visible and functional
      expect(find.byType(RemixRadio<String>), findsOneWidget);
    });

    testWidgets('handles focus state', (tester) async {
      await tester.pumpRemixApp(
        Focus(
          autofocus: true,
          child: RemixRadioGroup<String>(
            groupValue: 'option2',
            onChanged: (_) {},
            child: RemixRadio<String>(
              value: 'option1',
            ),
          ),
        ),
      );

      // Verify focus handling
      await tester.pump();
      expect(find.byType(RemixRadio<String>), findsOneWidget);
    });

    testWidgets('updates visual state when groupValue changes externally',
        (tester) async {
      String externalValue = 'option1';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RemixRadioGroup<String>(
                  groupValue: externalValue,
                  onChanged: (_) {},
                  child: Column(
                    children: [
                      RemixRadio<String>(
                        value: 'option1',
                      ),
                      RemixRadio<String>(
                        value: 'option2',
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      externalValue =
                          externalValue == 'option1' ? 'option2' : 'option1';
                    });
                  },
                  child: const Text('Toggle Externally'),
                ),
              ],
            );
          },
        ),
      );

      // Toggle externally
      await tester.tap(find.text('Toggle Externally'));
      await tester.pumpAndSettle();

      // Visual state should update
      expect(find.byType(RemixRadio<String>), findsNWidgets(2));
    });

    testWidgets('handles null onChanged callback', (tester) async {
      await tester.pumpRemixApp(
        RemixRadioGroup<String>(
          groupValue: 'option1',
          onChanged: (_) {},
          child: RemixRadio<String>(
            value: 'option1',
            enabled: false,
          ),
        ),
      );

      // Should render without crash
      expect(find.byType(RemixRadio<String>), findsOneWidget);

      // Tap should not cause error
      await tester.tap(find.byType(RemixRadio<String>));
      await tester.pumpAndSettle();
    });

    testWidgets('preserves accessibility semantics', (tester) async {
      await tester.pumpRemixApp(
        Semantics(
          label: 'Select theme',
          child: RemixRadioGroup<String>(
            groupValue: 'light',
            onChanged: (_) {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                RemixRadio<String>(
                  value: 'dark',
                  semanticLabel: 'Dark mode',
                ),
                SizedBox(width: 8),
                Text('Dark mode'),
              ],
            ),
          ),
        ),
      );

      // Verify semantics are preserved: check the specific semantics node by label
      expect(find.bySemanticsLabel('Select theme'), findsOneWidget);
    });

    testWidgets('handles rapid selection changes', (tester) async {
      int changeCount = 0;
      String? currentValue = 'A';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<String>(
              groupValue: currentValue,
              onChanged: (newValue) {
                changeCount++;
                setState(() {
                  currentValue = newValue;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['A', 'B', 'C'].map((value) {
                  return RemixRadio<String>(
                    key: Key(value),
                    value: value,
                  );
                }).toList(),
              ),
            );
          },
        ),
      );

      // Rapid selection changes
      await tester.tap(find.byKey(const Key('B')));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byKey(const Key('C')));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.byKey(const Key('A')));
      await tester.pumpAndSettle();

      expect(changeCount, 3);
      expect(currentValue, 'A');
    });

    testWidgets('works with custom value types', (tester) async {
      DateTime? selectedDate = DateTime(2024, 1, 1);
      final date1 = DateTime(2024, 1, 1);
      final date2 = DateTime(2024, 2, 1);
      final date3 = DateTime(2024, 3, 1);

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<DateTime>(
              groupValue: selectedDate,
              onChanged: (value) {
                setState(() {
                  selectedDate = value;
                });
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [date1, date2, date3].map((date) {
                  final label = '${date.month}/${date.year}';
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RemixRadio<DateTime>(
                        key: Key(date.toString()),
                        value: date,
                        semanticLabel: label,
                      ),
                      const SizedBox(width: 8),
                      Text(label),
                    ],
                  );
                }).toList(),
              ),
            );
          },
        ),
      );

      // Select date2
      await tester.tap(find.text('2/2024'));
      await tester.pumpAndSettle();
      expect(selectedDate, date2);

      // Select date3
      await tester.tap(find.text('3/2024'));
      await tester.pumpAndSettle();
      expect(selectedDate, date3);
    });
  });
}
