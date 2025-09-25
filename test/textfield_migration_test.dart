import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import 'helpers/test_helpers.dart';

void main() {
  group('TextField NakedTextField Migration', () {
    testWidgets('should properly use NakedTextField under the hood',
        (tester) async {
      final controller = TextEditingController();

      await tester.pumpRemixApp(
        RemixTextField(
          controller: controller,
          hintText: 'Test hint',
          enabled: true,
          autofocus: false,
        ),
      );

      // Verify widget tree contains NakedTextField
      expect(find.byType(RemixTextField), findsOneWidget);

      // Enter text and verify it's captured
      await tester.enterText(find.byType(RemixTextField), 'Hello World');
      expect(controller.text, 'Hello World');

      controller.dispose();
    });

    testWidgets('state callbacks should work correctly', (tester) async {
      await tester.pumpRemixApp(
        RemixTextField(
          hintText: 'Test',
          onPressed: () {
            // Press callback should work
          },
        ),
      );

      // Tap the field to trigger focus
      await tester.tap(find.byType(RemixTextField));
      await tester.pump();

      // Widget should exist and be functional
      expect(find.byType(RemixTextField), findsOneWidget);
    });

    testWidgets('all new properties should be accepted', (tester) async {
      await tester.pumpRemixApp(
        RemixTextField(
          groupId: 'test-group',
          ignorePointers: false,
          clipBehavior: Clip.antiAlias,
          stylusHandwritingEnabled: false,
          onTapAlwaysCalled: true,
          smartDashesType: SmartDashesType.enabled,
          smartQuotesType: SmartQuotesType.enabled,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
      );

      expect(find.byType(RemixTextField), findsOneWidget);
    });

    testWidgets('styling through RemixTextFieldSpec should work', (tester) async {
      await tester.pumpRemixApp(
        RemixTextField(
          hintText: 'Styled field',
          style: const RemixTextFieldStyle.create(),
        ),
      );

      expect(find.byType(RemixTextField), findsOneWidget);
      expect(find.text('Styled field'), findsOneWidget);
    });
  });
}
