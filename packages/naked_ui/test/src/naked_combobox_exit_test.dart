import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

final class _Exit {
  VoidCallback? dismiss;
  int built = 0;
  Widget? view;
}

Future<void> _pump(
  WidgetTester tester,
  _Exit exit, {
  bool withExit = true,
  VoidCallback? onClose,
  ValueChanged<String>? onSelected,
}) {
  return tester.pumpMaterialWidget(
    Align(
      alignment: Alignment.topLeft,
      child: NakedCombobox<String>(
        onClose: onClose,
        onSelected: onSelected,
        optionsBuilder: (value) =>
            value.text.isEmpty ? const <String>[] : ['apple', 'apricot'],
        exitBuilder: withExit
            ? (context, view, dismiss) {
                exit.built++;
                exit.dismiss = dismiss;
                exit.view = view;
                return Opacity(opacity: .5, child: view);
              }
            : null,
        fieldBuilder: (context, state, controller, focusNode, submit) =>
            SizedBox(
              width: 200,
              child: TextField(
                controller: controller,
                focusNode: focusNode,
                onSubmitted: (_) => submit(),
              ),
            ),
        overlayBuilder: (context, options) => Material(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in options)
                NakedComboboxOption<String>(
                  value: option,
                  builder: (context, state, _) => Text(
                    state.isHighlighted ? 'hi:$option' : option,
                    key: ValueKey('option-$option'),
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
}

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(TextField));
  await tester.enterText(find.byType(TextField), 'ap');
  await tester.pump();
  await tester.pump();
}

void main() {
  group('NakedCombobox exitBuilder', () {
    testWidgets('keeps the last options view in the frame that hides it, '
        'in the same place, until dismissed', (tester) async {
      final exit = _Exit();
      var closes = 0;
      await _pump(tester, exit, onClose: () => closes++);
      await _open(tester);
      final before = tester.getRect(find.byKey(const ValueKey('option-apple')));

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      // The view is still there, in the very frame it was hidden.
      expect(find.byKey(const ValueKey('option-apple')), findsOneWidget);
      expect(exit.built, greaterThan(0));
      expect(
        tester.getRect(find.byKey(const ValueKey('option-apple'))),
        before,
      );
      await tester.pump(const Duration(seconds: 1));
      expect(find.byKey(const ValueKey('option-apple')), findsOneWidget);
      expect(closes, 1, reason: 'onClose reports the unmount, not the exit');

      exit.dismiss!();
      await tester.pump();
      expect(find.byKey(const ValueKey('option-apple')), findsNothing);
      exit.dismiss!();
      await tester.pump();
    });

    testWidgets('the exit view takes no pointer input and no semantics', (
      tester,
    ) async {
      final exit = _Exit();
      final selected = <String>[];
      await _pump(tester, exit, onSelected: selected.add);
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      await tester.tap(
        find.byKey(const ValueKey('option-apple')),
        warnIfMissed: false,
      );
      await tester.pump();

      expect(selected, isEmpty);
      final handle = tester.ensureSemantics();
      expect(find.bySemanticsLabel('apple'), findsNothing);
      handle.dispose();
    });

    testWidgets('opening again removes the exit layer at once', (tester) async {
      final exit = _Exit();
      await _pump(tester, exit);
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'apr');
      await tester.pump();
      await tester.pump();

      expect(find.byKey(const ValueKey('option-apple')), findsOneWidget);
    });

    testWidgets('without an exitBuilder the view leaves at once', (
      tester,
    ) async {
      final exit = _Exit();
      await _pump(tester, exit, withExit: false);
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(find.byKey(const ValueKey('option-apple')), findsNothing);
      expect(exit.built, 0);
    });

    testWidgets('disposing during an exit leaves no layer behind', (
      tester,
    ) async {
      final exit = _Exit();
      await _pump(tester, exit);
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    });
  });
}
