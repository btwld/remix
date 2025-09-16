import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../helpers/test_helpers.dart';

void main() {
  group('RemixTextField', () {
    testWidgets('should create with basic properties', (tester) async {
      final controller = TextEditingController();

      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          height: 120,
          child: RemixTextField(
            controller: controller,
            hintText: 'Enter text',
            label: 'Username',
            helperText: 'This is a helper text',
          ),
        ),
      );

      // Verify the widget exists
      expect(find.byType(RemixTextField), findsOneWidget);

      // Verify label is displayed
      expect(find.text('Username'), findsOneWidget);

      // Verify helper text is displayed
      expect(find.text('This is a helper text'), findsOneWidget);

      // Verify hint text is displayed when field is empty
      expect(find.text('Enter text'), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should hide hint text when typing', (tester) async {
      final controller = TextEditingController();

      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          height: 120,
          child: RemixTextField(
            controller: controller,
            hintText: 'Enter text',
          ),
        ),
      );

      // Verify hint text is initially visible
      expect(find.text('Enter text'), findsOneWidget);

      // Type some text
      controller.text = 'Hello';
      await tester.pump();

      // Verify hint text is now hidden (SizedBox.shrink replaces it)
      expect(find.text('Enter text'), findsNothing);

      controller.dispose();
    });

    testWidgets('should work with leading and trailing widgets',
        (tester) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          height: 120,
          child: RemixTextField(
            leading: const Icon(Icons.person),
            trailing: const Icon(Icons.clear),
            hintText: 'Username',
          ),
        ),
      );

      // Verify leading and trailing widgets are displayed
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.clear), findsOneWidget);
    });

    testWidgets('should handle disabled state', (tester) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          height: 120,
          child: RemixTextField(
            enabled: false,
            hintText: 'Disabled field',
          ),
        ),
      );

      // Verify the widget exists
      expect(find.byType(RemixTextField), findsOneWidget);
    });

    testWidgets('should handle password field', (tester) async {
      final controller = TextEditingController(text: 'password123');

      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          height: 120,
          child: RemixTextField(
            controller: controller,
            obscureText: true,
            hintText: 'Password',
          ),
        ),
      );

      // Verify the widget exists
      expect(find.byType(RemixTextField), findsOneWidget);

      controller.dispose();
    });

    testWidgets('should work without external controller',
        (WidgetTester tester) async {
      await tester.pumpRemixApp(
        SizedBox(
          width: 400,
          height: 120,
          child: RemixTextField(
            hintText: 'Type here',
          ),
        ),
      );

      // Verify hint text is initially visible
      expect(find.text('Type here'), findsOneWidget);

      // Type text directly into the field
      await tester.enterText(find.byType(EditableText), 'Hello World');
      await tester.pump();

      // Verify hint text is hidden after typing
      expect(find.text('Type here'), findsNothing);
      // Verify the text was entered
      expect(find.text('Hello World'), findsOneWidget);
    });
  });
}
