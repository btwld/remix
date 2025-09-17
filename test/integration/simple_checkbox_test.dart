import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('RemixCheckbox Simple Tests', () {
    testWidgets('renders and toggles', (tester) async {
      bool isChecked = false;

      await tester.pumpRemixApp(
        StatefulBuilder(
          builder: (context, setState) {
            return RemixCheckbox(
              selected: isChecked,
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

    testWidgets('composes with external label', (tester) async {
      await tester.pumpRemixApp(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            RemixCheckbox(
              selected: false,
              semanticLabel: 'Accept Terms',
            ),
            const SizedBox(width: 8),
            const Text('Accept Terms'),
          ],
        ),
      );

      expect(find.text('Accept Terms'), findsOneWidget);
    });

    testWidgets('respects disabled state', (tester) async {
      bool isChecked = false;

      await tester.pumpRemixApp(
        RemixCheckbox(
          selected: isChecked,
          enabled: false,
          onChanged: (value) {
            isChecked = value ?? false; // Handle nullable bool
          },
        ),
      );

      await tester.tap(find.byType(RemixCheckbox));
      await tester.pumpAndSettle();

      // Should not change when disabled
      expect(isChecked, false);
    });
  });
}
