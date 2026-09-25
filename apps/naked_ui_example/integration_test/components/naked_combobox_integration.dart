import 'package:naked_ui_example/api/naked_combobox.0.dart' as combobox_example;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('NakedCombobox Integration Tests', () {
    testWidgets('typing shows an option that can be tapped', (tester) async {
      await tester.pumpWidget(const combobox_example.MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(EditableText));
      await tester.enterText(find.byType(EditableText), 'Ap');
      await tester.pumpAndSettle();

      expect(find.text('Apple'), findsWidgets);
      await tester.tap(find.text('Apple').last);
      await tester.pumpAndSettle();

      expect(find.byType(EditableText), findsOneWidget);
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).controller.text,
        'Apple',
      );
    });
  });
}
