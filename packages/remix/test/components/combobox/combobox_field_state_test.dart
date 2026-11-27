import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import 'combobox_test_host.dart';

const _open = Color(0xFFFF0000);

void main() {
  testWidgets('the default editor resolves under selected while open', (
    tester,
  ) async {
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          label: 'Fruit',
          optionsBuilder: (value) => suggestions.where(
            (option) =>
                option.toLowerCase().startsWith(value.text.toLowerCase()),
          ),
          style: testComboboxStyle().field(
            TextFieldStyler().onSelected(
              TextFieldStyler().label(TextStyler().color(_open)),
            ),
          ),
        ),
      ),
    );
    Color? labelColor() => tester.widget<Text>(find.text('Fruit')).style?.color;

    expect(labelColor(), isNot(_open));
    await tester.tap(find.byType(EditableText));
    await tester.enterText(find.byType(EditableText), 'ap');
    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsOneWidget);
    expect(labelColor(), _open);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('Apple'), findsNothing);
    expect(labelColor(), isNot(_open));
  });

  testWidgets('forwards helperText and errorText to the default editor', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            label: 'Fruit',
            helperText: 'Pick a ripe one',
            errorText: 'Out of stock',
            optionsBuilder: (_) => suggestions,
            style: testComboboxStyle(),
          ),
        ),
      );

      final helper = tester.getTopLeft(find.text('Pick a ripe one'));
      final error = tester.getTopLeft(find.text('Out of stock'));
      expect(helper.dy, greaterThan(tester.getTopLeft(find.text('Fruit')).dy));
      expect(error.dy, greaterThan(helper.dy));

      final editor = tester.semantics
          .simulatedAccessibilityTraversal()
          .map((node) => node.getSemanticsData())
          .singleWhere((data) => data.flagsCollection.isTextField);
      expect(editor.validationResult, SemanticsValidationResult.invalid);
      expect(editor.hint, contains('Pick a ripe one'));
      expect(editor.hint, contains('Out of stock'));
    } finally {
      semantics.dispose();
    }
  });
}
