import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  group('Focus Management Tests', () {
    testWidgets('Components create internal focus nodes when none provided',
        (tester) async {
      await tester.pumpWidget(createRemixScope(
        child: MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                RemixButton(label: 'Test Button', onPressed: () {}),
                RemixCheckbox(selected: false, onChanged: (_) {}),
                RemixTextField(),
                RemixSwitch(selected: false, onChanged: (_) {}),
              ],
            ),
          ),
        ),
      ));

      // Verify widgets build without focus node provided
      expect(find.byType(RemixButton), findsOneWidget);
      expect(find.byType(RemixCheckbox), findsOneWidget);
      expect(find.byType(RemixTextField), findsOneWidget);
      expect(find.byType(RemixSwitch), findsOneWidget);
    });

    testWidgets('Components respect external focus nodes', (tester) async {
      final focusNode = FocusNode();

      await tester.pumpWidget(createRemixScope(
        child: MaterialApp(
          home: Scaffold(
            body: RemixButton(
              label: 'Test Button',
              focusNode: focusNode,
              onPressed: () {},
            ),
          ),
        ),
      ));

      // Verify widget uses external focus node
      expect(find.byType(RemixButton), findsOneWidget);

      // Focus the external node
      focusNode.requestFocus();
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);

      focusNode.dispose();
    });

    testWidgets('Components handle focus node transitions', (tester) async {
      final externalFocusNode = FocusNode();
      bool useExternalFocus = false;

      await tester.pumpWidget(createRemixScope(
        child: MaterialApp(
          home: StatefulBuilder(
            builder: (context, setState) {
              return Scaffold(
                body: Column(
                  children: [
                    RemixButton(
                      label: 'Test Button',
                      focusNode: useExternalFocus ? externalFocusNode : null,
                      onPressed: () {},
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          useExternalFocus = !useExternalFocus;
                        });
                      },
                      child: Text('Toggle Focus Node'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ));

      // Initially using internal focus node
      expect(find.byType(RemixButton), findsOneWidget);

      // Switch to external focus node
      await tester.tap(find.text('Toggle Focus Node'));
      await tester.pump();

      expect(find.byType(RemixButton), findsOneWidget);

      // Switch back to internal focus node
      await tester.tap(find.text('Toggle Focus Node'));
      await tester.pump();

      expect(find.byType(RemixButton), findsOneWidget);

      externalFocusNode.dispose();
    });
  });
}
