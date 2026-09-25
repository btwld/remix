import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

void main() {
  Future<void> pumpCombobox(
    WidgetTester tester, {
    required AutocompleteOptionsBuilder<String> optionsBuilder,
    ValueChanged<String>? onSelected,
    TextEditingController? controller,
    FocusNode? focusNode,
    TextEditingValue? initialValue,
    bool enabled = true,
    VoidCallback? onOpen,
    VoidCallback? onClose,
    void Function(NakedComboboxState<String> state)? onState,
  }) async {
    await tester.pumpMaterialWidget(
      NakedCombobox<String>(
        enabled: enabled,
        controller: controller,
        focusNode: focusNode,
        initialValue: initialValue,
        onSelected: onSelected,
        onOpen: onOpen,
        onClose: onClose,
        optionsBuilder: optionsBuilder,
        fieldBuilder: (context, state, fieldController, fieldFocus, submit) {
          onState?.call(state);
          return SizedBox(
            width: 200,
            child: TextField(
              controller: fieldController,
              focusNode: fieldFocus,
              onSubmitted: (_) => submit(),
            ),
          );
        },
        overlayBuilder: (context, current) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final option in current)
                NakedComboboxOption<String>(
                  value: option,
                  builder: (context, state, child) {
                    return Text(
                      state.isHighlighted ? 'hi:$option' : option,
                      key: ValueKey('option-$option'),
                    );
                  },
                ),
            ],
          );
        },
      ),
    );
  }

  testWidgets('opens on focus when options exist and stays closed otherwise', (
    tester,
  ) async {
    var opens = 0;
    await pumpCombobox(
      tester,
      onOpen: () => opens++,
      optionsBuilder: (value) {
        if (value.text.isEmpty) return const <String>[];
        return ['apple'];
      },
    );

    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(find.text('apple'), findsNothing);

    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('apple'), findsOneWidget);
    expect(opens, 1);
  });

  testWidgets('arrow keys move the highlight and enter selects it', (
    tester,
  ) async {
    String? selected;
    await pumpCombobox(
      tester,
      onSelected: (value) => selected = value,
      optionsBuilder: (value) => ['apple', 'apricot'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'ap');
    await tester.pump();
    await tester.pump();

    expect(find.text('hi:apple'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
    expect(find.text('hi:apricot'), findsOneWidget);

    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    await tester.pump();

    expect(selected, 'apricot');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'apricot',
    );
    expect(find.text('hi:apricot'), findsNothing);
  });

  testWidgets('escape closes the options view', (tester) async {
    var closes = 0;
    await pumpCombobox(
      tester,
      onClose: () => closes++,
      optionsBuilder: (value) => ['apple'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('apple'), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.pump();
    expect(find.textContaining('apple'), findsNothing);
    expect(closes, 1);
  });

  testWidgets('tapping an option selects it', (tester) async {
    String? selected;
    await pumpCombobox(
      tester,
      onSelected: (value) => selected = value,
      optionsBuilder: (value) => ['apple', 'banana'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();

    await tester.tap(find.textContaining('apple'));
    await tester.pump();
    await tester.pump();

    expect(selected, 'apple');
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'apple',
    );
  });

  testWidgets('clears value when the field text no longer matches', (
    tester,
  ) async {
    NakedComboboxState<String>? latest;
    await pumpCombobox(
      tester,
      onState: (state) => latest = state,
      optionsBuilder: (value) => ['apple'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.pump();
    await tester.tap(find.textContaining('apple'));
    await tester.pump();
    await tester.pump();
    expect(latest?.value, 'apple');

    await tester.enterText(find.byType(TextField), 'apple pie');
    await tester.pump();
    expect(latest?.value, isNull);
    expect(latest?.text, 'apple pie');
  });

  testWidgets('disabled combobox never opens', (tester) async {
    await pumpCombobox(
      tester,
      enabled: false,
      optionsBuilder: (value) => ['apple'],
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'apple');
    await tester.pump();
    await tester.pump();
    expect(find.byType(NakedComboboxOption<String>), findsNothing);
  });

  testWidgets('uses an external controller and focus node pair', (
    tester,
  ) async {
    final controller = TextEditingController();
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);

    await pumpCombobox(
      tester,
      controller: controller,
      focusNode: focusNode,
      optionsBuilder: (value) => ['banana'],
    );

    focusNode.requestFocus();
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'b');
    await tester.pump();
    await tester.pump();
    expect(controller.text, 'b');
    expect(find.textContaining('banana'), findsOneWidget);
  });

  testWidgets('ignores a stale async options result', (tester) async {
    await pumpCombobox(
      tester,
      optionsBuilder: (value) async {
        if (value.text == 'a') {
          await Future<void>.delayed(const Duration(milliseconds: 30));
          return ['apple'];
        }
        return ['banana'];
      },
    );

    await tester.tap(find.byType(TextField));
    await tester.enterText(find.byType(TextField), 'a');
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'b');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.textContaining('banana'), findsOneWidget);
    expect(find.text('hi:apple'), findsNothing);
    expect(find.text('apple'), findsNothing);
  });
}
