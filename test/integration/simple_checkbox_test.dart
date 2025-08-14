import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix_new.dart';

void main() {
  group('RemixCheckbox Simple Tests', () {
    testWidgets('renders and toggles', (tester) async {
      bool isChecked = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return RemixCheckbox(
                  selected: isChecked,
                  onChanged: (value) {
                    setState(() {
                      isChecked = value;
                    });
                  },
                );
              },
            ),
          ),
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

    testWidgets('shows label', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RemixCheckbox(
              selected: false,
              label: 'Accept Terms',
            ),
          ),
        ),
      );

      expect(find.text('Accept Terms'), findsOneWidget);
    });

    testWidgets('respects disabled state', (tester) async {
      bool isChecked = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RemixCheckbox(
              selected: isChecked,
              enabled: false,
              onChanged: (value) {
                isChecked = value;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byType(RemixCheckbox));
      await tester.pumpAndSettle();
      
      // Should not change when disabled
      expect(isChecked, false);
    });
  });
}