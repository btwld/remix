import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix_new.dart';

void main() {
  group('RemixButton Widget Tests', () {
    testWidgets('RemixButton renders correctly with label', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RemixButton(
                label: 'Test Button',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify the button text is displayed
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('RemixButton responds to tap when enabled', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RemixButton(
                label: 'Tap Me',
                onPressed: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      // Tap the button
      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      // Verify callback was triggered
      expect(wasPressed, isTrue);
    });

    testWidgets('RemixButton does not respond when disabled', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RemixButton(
                label: 'Disabled Button',
                enabled: false,
                onPressed: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      // Try to tap the disabled button
      await tester.tap(find.text('Disabled Button'));
      await tester.pumpAndSettle();

      // Verify callback was NOT triggered
      expect(wasPressed, isFalse);
    });

    testWidgets('RemixButton shows loading state', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RemixButton(
                label: 'Loading Button',
                loading: true,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('RemixButton.icon renders icon only', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RemixButton.icon(
                Icons.favorite,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify icon is displayed
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });

    testWidgets('RemixButton with icon', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RemixButton(
                    label: 'Button with Icon',
                    icon: Icons.star,
                    onPressed: () {},
                  ),
                  const SizedBox(height: 10),
                  RemixButton.icon(
                    Icons.favorite,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Verify both buttons and icons are displayed
      expect(find.text('Button with Icon'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsOneWidget);
      expect(find.byIcon(Icons.favorite), findsOneWidget);
    });
  });
}