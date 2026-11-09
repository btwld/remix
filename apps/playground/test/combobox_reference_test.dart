import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/combobox_reference.dart';

void main() {
  testWidgets(
    'reference accepts a city by keyboard and keeps locked field disabled',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(
        bool.fromEnvironment('COMBOBOX_NARROW') ? 320 : 800,
        1200,
      );
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const ComboboxReferenceApp());
      await tester.pumpAndSettle();
      final fields = find.byType(EditableText);
      expect(fields, findsNWidgets(2));
      expect(find.byType(Navigator), findsOneWidget);
      expect(find.byType(Overlay), findsOneWidget);
      await tester.ensureVisible(fields.first);
      await tester.tap(fields.first);
      await tester.enterText(fields.first, 'san');
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();
      const city = 'San Sebastián, Basque Country · Spain';
      final editor = tester.widget<EditableText>(fields.first);
      expect(editor.controller.text, city);
      expect(editor.focusNode.hasFocus, isTrue);
      expect(find.text('Selected: $city'), findsOneWidget);
      expect(
        find.text('San Francisco, California · United States'),
        findsNothing,
      );

      final locked = tester.widget<EditableText>(fields.last);
      expect(locked.readOnly, isTrue);
      await tester.ensureVisible(fields.last);
      // The disabled editor intentionally ignores pointer hits. Tap its area.
      await tester.tapAt(tester.getCenter(fields.last));
      await tester.pumpAndSettle();
      expect(locked.focusNode.hasFocus, isFalse);
      expect(locked.controller.text, isEmpty);
      expect(find.text('Selected: $city'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );
}
