import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../semantics/semantics_test_utils.dart';

Future<void> _pump(
  WidgetTester tester, {
  TextEditingController? controller,
  FocusNode? focusNode,
  bool enabled = true,
  bool readOnly = false,
  ValueChanged<String>? onChanged,
  VoidCallback? onCleared,
  VoidCallback? onEscape,
}) async {
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xff000000),
      pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) =>
            builder(context),
      ),
      home: Center(
        child: Focus(
          onKeyEvent: (node, event) {
            if (event.logicalKey != LogicalKeyboardKey.escape) return .ignored;
            onEscape?.call();
            return .handled;
          },
          child: NakedSearchField(
            controller: controller,
            focusNode: focusNode,
            enabled: enabled,
            readOnly: readOnly,
            onChanged: onChanged,
            onCleared: onCleared,
            builder: (context, field) => Row(
              children: [
                Expanded(
                  child: NakedTextField(
                    controller: field.controller,
                    focusNode: field.focusNode,
                    enabled: field.enabled,
                    readOnly: field.readOnly,
                    onChanged: field.onChanged,
                    semanticLabel: 'Find people',
                    textInputAction: TextInputAction.search,
                    builder: (context, state, editable) => editable,
                  ),
                ),
                if (field.clear != null)
                  TextFieldTapRegion(
                    child: NakedButton(
                      onPressed: field.clear,
                      semanticLabel: 'Clear search',
                      child: const Text('Clear'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  testWidgets('edits and clear have distinct callbacks and accessible nodes', (
    tester,
  ) async {
    final calls = <String>[];
    await _pump(
      tester,
      onChanged: (value) => calls.add('edit:$value'),
      onCleared: () => calls.add('clear'),
    );
    expect(find.byType(NakedButton), findsNothing);
    await tester.enterText(find.byType(EditableText), 'Ada');
    await tester.pump();
    final editor = tester.widget<EditableText>(find.byType(EditableText));
    final root = semanticsRootOf(tester);
    final editors = collectSemanticsNodes(
      root,
      (node) => node.getSemanticsData().flagsCollection.isTextField,
    );
    final buttons = collectSemanticsNodes(
      root,
      (node) => node.getSemanticsData().flagsCollection.isButton,
    );
    expect(editors.single.getSemanticsData().label, 'Find people');
    expect(buttons.single.getSemanticsData().label, 'Clear search');
    editor.focusNode.nextFocus();
    await tester.pump();
    expect(editor.focusNode.hasFocus, isFalse);
    await tester.tap(find.text('Clear'));
    await tester.pump();
    expect(editor.controller.text, isEmpty);
    expect(editor.focusNode.hasFocus, isTrue);
    expect(find.byType(NakedButton), findsNothing);
    expect(calls, ['edit:Ada', 'edit:', 'clear']);
    editor.controller.text = 'programmatic';
    await tester.pump();
    expect(find.byType(NakedButton), findsOneWidget);
    expect(calls, hasLength(3));
  });

  testWidgets('one held Escape clears once; the next empty Escape bubbles', (
    tester,
  ) async {
    var clears = 0;
    var escaped = 0;
    await _pump(tester, onCleared: () => clears++, onEscape: () => escaped++);
    await tester.enterText(find.byType(EditableText), 'Ada');
    await tester.sendKeyDownEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    await tester.sendKeyRepeatEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.escape);
    expect(clears, 1);
    expect(escaped, 0);
    expect(find.byType(NakedButton), findsNothing);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    expect(escaped, greaterThan(0));
    expect(clears, 1);
  });

  testWidgets('IME owns a whole Escape press, not a collapsed range', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    var escaped = 0;
    await _pump(tester, controller: controller, onEscape: () => escaped++);
    await tester.showKeyboard(find.byType(EditableText));
    controller.value = const TextEditingValue(
      text: 'に',
      selection: TextSelection.collapsed(offset: 1),
      composing: TextRange(start: 0, end: 1),
    );
    await tester.pump();
    expect(await tester.sendKeyDownEvent(LogicalKeyboardKey.escape), isFalse);
    controller.value = controller.value.copyWith(
      composing: const TextRange.collapsed(1),
    );
    expect(await tester.sendKeyRepeatEvent(LogicalKeyboardKey.escape), isFalse);
    expect(await tester.sendKeyUpEvent(LogicalKeyboardKey.escape), isFalse);
    expect(escaped, 0);
    expect(controller.text, 'に');
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    expect(controller.text, isEmpty);
  });

  for (final readOnly in [true, false]) {
    testWidgets(
      '${readOnly ? 'read-only' : 'disabled'} prevents even a retained clear action',
      (tester) async {
        final controller = TextEditingController(text: 'Ada');
        addTearDown(controller.dispose);
        var escaped = 0;
        await _pump(tester, controller: controller);
        final clear = tester
            .widget<NakedButton>(find.byType(NakedButton))
            .onPressed!;
        await _pump(
          tester,
          controller: controller,
          readOnly: readOnly,
          enabled: readOnly,
          onEscape: () => escaped++,
        );
        clear();
        expect(find.byType(NakedButton), findsNothing);
        expect(controller.text, 'Ada');
        if (readOnly) {
          await tester.tap(find.byType(EditableText));
          await tester.pump();
          await tester.sendKeyEvent(LogicalKeyboardKey.escape);
          expect(escaped, greaterThan(0));
          expect(controller.text, 'Ada');
        }
      },
    );
  }

  testWidgets('swaps ownership without losing the editing value or focus', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'Ada');
    final focusNode = FocusNode();
    addTearDown(controller.dispose);
    addTearDown(focusNode.dispose);
    await _pump(tester);
    await tester.showKeyboard(find.byType(EditableText));
    await _pump(tester, controller: controller, focusNode: focusNode);
    expect(focusNode.hasFocus, isTrue);
    controller.selection = const TextSelection(baseOffset: 1, extentOffset: 2);
    final value = controller.value;
    await _pump(tester, focusNode: focusNode);
    final editor = tester.widget<EditableText>(find.byType(EditableText));
    expect(editor.controller, isNot(same(controller)));
    expect(editor.controller.value, value);
    expect(editor.focusNode.hasFocus, isTrue);
    controller.clear();
    expect(editor.controller.value, value);
    await _pump(tester);
    final newFocus = tester
        .widget<EditableText>(find.byType(EditableText))
        .focusNode;
    expect(newFocus, isNot(same(focusNode)));
    expect(newFocus.hasFocus, isTrue);
    await tester.pumpWidget(const SizedBox());
    expect(() => focusNode.addListener(() {}), returnsNormally);
    expect(() => controller.text = 'reused', returnsNormally);
  });
}
