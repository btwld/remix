import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

void main() {
  late List<Iterable<String>> shown;
  late List<String> selected;

  setUp(() {
    shown = [];
    selected = [];
  });

  Future<void> pumpCombobox(
    WidgetTester tester, {
    required Iterable<String> options,
    required bool Function(String option)? isOptionDisabled,
  }) async {
    await tester.pumpMaterialWidget(
      NakedCombobox<String>(
        isOptionDisabled: isOptionDisabled,
        onSelected: selected.add,
        optionsBuilder: (value) => options,
        fieldBuilder: (context, state, controller, focusNode, submit) {
          return SizedBox(
            width: 200,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              // Keep focus on submit, as Remix's editor does.
              onEditingComplete: controller.clearComposing,
              onSubmitted: (_) => submit(),
            ),
          );
        },
        overlayBuilder: (context, current) {
          shown.add(current);
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in current)
                NakedComboboxOption<String>(
                  value: option,
                  builder: (context, state, child) => Text(
                    [
                      if (state.isHighlighted) 'hi',
                      if (state.isDisabled) 'off',
                      option,
                    ].join(':'),
                    key: ValueKey('option-$option'),
                  ),
                ),
            ],
          );
        },
      ),
    );
    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();
  }

  String fieldText(WidgetTester tester) =>
      tester.widget<TextField>(find.byType(TextField)).controller!.text;

  testWidgets('the overlay shows disabled options in result order', (
    tester,
  ) async {
    await pumpCombobox(
      tester,
      options: ['apple', 'banana', 'cherry'],
      isOptionDisabled: (option) => option == 'banana',
    );

    expect(shown.last, ['apple', 'banana', 'cherry']);
    expect(find.text('hi:apple'), findsOneWidget);
    expect(find.text('off:banana'), findsOneWidget);
    expect(find.text('cherry'), findsOneWidget);
  });

  testWidgets('arrow keys skip disabled options and Enter accepts', (
    tester,
  ) async {
    await pumpCombobox(
      tester,
      options: ['apple', 'banana', 'cherry'],
      isOptionDisabled: (option) => option == 'banana',
    );

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(find.text('hi:cherry'), findsOneWidget);
    expect(find.textContaining('hi:'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(find.text('hi:apple'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump();
    expect(selected, ['cherry']);
    expect(fieldText(tester), 'cherry');
  });

  testWidgets('first, last and page navigation land on enabled options', (
    tester,
  ) async {
    await pumpCombobox(
      tester,
      options: ['avocado', 'apple', 'banana', 'cherry', 'date'],
      isOptionDisabled: (option) => option == 'avocado' || option == 'date',
    );
    expect(find.text('hi:apple'), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    expect(find.text('hi:cherry'), findsOneWidget);

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pump();
    expect(find.text('hi:apple'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.pageDown);
    await tester.pump();
    expect(find.text('hi:cherry'), findsOneWidget);
    expect(find.textContaining('hi:'), findsOneWidget);
  });

  testWidgets('a disabled option ignores taps', (tester) async {
    await pumpCombobox(
      tester,
      options: ['apple', 'banana'],
      isOptionDisabled: (option) => option == 'banana',
    );

    await tester.tap(find.text('off:banana'));
    await tester.pump();
    await tester.pump();
    expect(selected, isEmpty);
    expect(fieldText(tester), 'a');
    expect(find.text('off:banana'), findsOneWidget);
  });

  testWidgets(
    'only disabled results keep the panel open and Enter accepts nothing',
    (tester) async {
      await pumpCombobox(
        tester,
        options: ['apple', 'banana'],
        isOptionDisabled: (option) => true,
      );

      expect(shown.last, ['apple', 'banana']);
      expect(find.text('off:apple'), findsOneWidget);
      expect(find.text('off:banana'), findsOneWidget);
      expect(find.textContaining('hi:'), findsNothing);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      expect(find.textContaining('hi:'), findsNothing);

      // Accepting would rewrite the text, move the caret and close the panel.
      final controller = tester
          .widget<TextField>(find.byType(TextField))
          .controller!;
      controller.selection = const TextSelection.collapsed(offset: 0);
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      await tester.pump();
      expect(selected, isEmpty);
      expect(controller.text, 'a');
      expect(controller.selection, const TextSelection.collapsed(offset: 0));
      expect(find.text('off:apple'), findsOneWidget);
    },
  );

  testWidgets('availability is read when results arrive', (tester) async {
    var unavailable = 'banana';
    await pumpCombobox(
      tester,
      options: ['apple', 'banana', 'cherry'],
      isOptionDisabled: (option) => option == unavailable,
    );
    expect(find.text('off:banana'), findsOneWidget);

    unavailable = 'cherry';
    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pump();
    await tester.pump();
    expect(find.text('banana'), findsOneWidget);
    expect(find.text('off:cherry'), findsOneWidget);
  });

  testWidgets('disabled options are exposed as disabled buttons', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pumpCombobox(
      tester,
      options: ['apple', 'banana'],
      isOptionDisabled: (option) => option == 'banana',
    );

    expect(
      tester.getSemantics(find.byKey(const ValueKey('option-banana'))),
      isSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: false,
        hasTapAction: false,
      ),
    );
    expect(
      tester.getSemantics(find.byKey(const ValueKey('option-apple'))),
      isSemantics(isButton: true, isEnabled: true, hasTapAction: true),
    );
    handle.dispose();
  });
}
