import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:remix/remix.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Simple RemixButton Integration Test', () {
    testWidgets('RemixButton basic functionality test', (WidgetTester tester) async {
      bool wasPressed = false;

      // Build our app and trigger a frame
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RemixButton(
                key: const ValueKey('test_button'),
                label: 'Test Button',
                onPressed: () {
                  wasPressed = true;
                },
              ),
            ),
          ),
        ),
      );

      // Verify the button exists
      expect(find.text('Test Button'), findsOneWidget);
      expect(find.byKey(const ValueKey('test_button')), findsOneWidget);

      // Tap the button
      await tester.tap(find.byKey(const ValueKey('test_button')));
      await tester.pumpAndSettle();

      // Verify the button was pressed
      expect(wasPressed, isTrue);
    });

    testWidgets('RemixButton disabled state test', (WidgetTester tester) async {
      bool wasPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RemixButton(
                key: const ValueKey('disabled_button'),
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

      // Verify the button exists
      expect(find.text('Disabled Button'), findsOneWidget);

      // Try to tap the disabled button
      await tester.tap(find.byKey(const ValueKey('disabled_button')));
      await tester.pumpAndSettle();

      // Verify the button was NOT pressed
      expect(wasPressed, isFalse);
    });

    testWidgets('RemixButton loading state test', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: RemixButton(
                key: const ValueKey('loading_button'),
                label: 'Loading Button',
                loading: true,
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      // Verify the button exists
      expect(find.byKey(const ValueKey('loading_button')), findsOneWidget);
      
      // Verify loading indicator is shown
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}