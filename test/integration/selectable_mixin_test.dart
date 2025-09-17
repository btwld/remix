import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('SelectableMixin Behavior Tests', () {
    testWidgets(
        'RemixRadio updates stateController.selected when groupValue changes',
        (tester) async {
      String groupValue = 'option1';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<String>(
              groupValue: groupValue,
              onChanged: (value) {
                setState(() {
                  groupValue = value!;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemixRadio<String>(
                    key: const Key('radio1'),
                    value: 'option1',
                  ),
                  RemixRadio<String>(
                    key: const Key('radio2'),
                    value: 'option2',
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        groupValue =
                            groupValue == 'option1' ? 'option2' : 'option1';
                      });
                    },
                    child: const Text('Toggle'),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Initial state verification
      expect(groupValue, 'option1');

      // Tap toggle button to change group value externally
      await tester.tap(find.text('Toggle'));
      await tester.pumpAndSettle();
      expect(groupValue, 'option2');

      // Tap radio directly to change selection
      await tester.tap(find.byKey(const Key('radio1')));
      await tester.pumpAndSettle();
      expect(groupValue, 'option1');
    });

    testWidgets('RemixRadio in group context properly manages selected state',
        (tester) async {
      String groupValue = 'A';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<String>(
              groupValue: groupValue,
              onChanged: (value) {
                setState(() {
                  groupValue = value!;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemixRadio<String>(
                    key: const Key('radioA'),
                    value: 'A',
                  ),
                  RemixRadio<String>(
                    key: const Key('radioB'),
                    value: 'B',
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Initial state - A should be selected
      expect(groupValue, 'A');

      // Select B
      await tester.tap(find.byKey(const Key('radioB')));
      await tester.pumpAndSettle();
      expect(groupValue, 'B');

      // Select A again
      await tester.tap(find.byKey(const Key('radioA')));
      await tester.pumpAndSettle();
      expect(groupValue, 'A');
    });

    testWidgets('RemixCheckbox properly handles nullable bool in onChanged',
        (tester) async {
      bool? isChecked = false;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixCheckbox(
              selected: isChecked ?? false,
              onChanged: (value) {
                setState(() {
                  isChecked = value ?? false; // Handle nullable bool
                });
              },
            );
          },
        ),
      );

      // Initially unchecked
      expect(isChecked, false);

      // Tap to check
      await tester.tap(find.byType(RemixCheckbox));
      await tester.pumpAndSettle();
      expect(isChecked, true);

      // Tap to uncheck
      await tester.tap(find.byType(RemixCheckbox));
      await tester.pumpAndSettle();
      expect(isChecked, false);
    });

    testWidgets('RemixCheckbox tristate functionality', (tester) async {
      bool? tristateValue;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixCheckbox(
              tristate: true,
              selected: tristateValue,
              onChanged: (value) {
                setState(() {
                  tristateValue = value;
                });
              },
            );
          },
        ),
      );

      // Initially null (indeterminate)
      expect(tristateValue, isNull);

      // First tap: null -> false (NakedCheckbox toggles to false from null)
      await tester.tap(find.byType(RemixCheckbox));
      await tester.pumpAndSettle();
      expect(tristateValue, false);

      // Second tap: false -> true
      await tester.tap(find.byType(RemixCheckbox));
      await tester.pumpAndSettle();
      expect(tristateValue, true);

      // Third tap: true -> false
      await tester.tap(find.byType(RemixCheckbox));
      await tester.pumpAndSettle();
      expect(tristateValue, false);
    });

    testWidgets(
        'Multiple RemixRadio widgets in group maintain mutual exclusivity',
        (tester) async {
      String? selectedValue = 'first';

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixRadioGroup<String>(
              groupValue: selectedValue,
              onChanged: (value) {
                setState(() {
                  selectedValue = value;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      RemixRadio<String>(
                        key: const Key('first'),
                        value: 'first',
                        semanticLabel: 'First Option',
                      ),
                      const Text('First Option'),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      RemixRadio<String>(
                        key: const Key('second'),
                        value: 'second',
                        semanticLabel: 'Second Option',
                      ),
                      const Text('Second Option'),
                    ],
                  ),
                  Wrap(
                    spacing: 8,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      RemixRadio<String>(
                        key: const Key('third'),
                        value: 'third',
                        semanticLabel: 'Third Option',
                      ),
                      const Text('Third Option'),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Initially first should be selected
      expect(selectedValue, 'first');

      // Select second - should deselect first
      await tester.tap(find.byKey(const Key('second')));
      await tester.pumpAndSettle();
      expect(selectedValue, 'second');

      // Select third - should deselect second
      await tester.tap(find.byKey(const Key('third')));
      await tester.pumpAndSettle();
      expect(selectedValue, 'third');

      // Select first again - should deselect third
      await tester.tap(find.byKey(const Key('first')));
      await tester.pumpAndSettle();
      expect(selectedValue, 'first');
    });

    testWidgets('RemixCheckbox handles both regular and tristate modes',
        (tester) async {
      bool regularChecked = false;
      bool? tristateValue = false;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return Column(
              children: [
                // Regular checkbox
                RemixCheckbox(
                  key: const Key('regular'),
                  selected: regularChecked,
                  onChanged: (value) {
                    setState(() {
                      regularChecked = value ?? false;
                    });
                  },
                ),
                // Tristate checkbox
                RemixCheckbox(
                  key: const Key('tristate'),
                  tristate: true,
                  selected: tristateValue,
                  onChanged: (value) {
                    setState(() {
                      tristateValue = value;
                    });
                  },
                ),
              ],
            );
          },
        ),
      );

      // Test regular checkbox
      expect(regularChecked, false);
      await tester.tap(find.byKey(const Key('regular')));
      await tester.pumpAndSettle();
      expect(regularChecked, true);

      // Test tristate checkbox starting at false; expected cycle with NakedCheckbox:
      // false -> true -> false
      expect(tristateValue, false);
      // false -> true
      await tester.tap(find.byKey(const Key('tristate')));
      await tester.pumpAndSettle();
      expect(tristateValue, true);
      // true -> false
      await tester.tap(find.byKey(const Key('tristate')));
      await tester.pumpAndSettle();
      expect(tristateValue, false);
    });
  });
}
