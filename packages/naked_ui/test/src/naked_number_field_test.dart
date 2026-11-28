import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

class _Harness {
  double? value;
  final proposals = <double?>[];
  bool accept = true;

  void onChanged(double? next) {
    proposals.add(next);
    if (accept) value = next;
  }
}

Future<void> _pump(
  WidgetTester tester,
  _Harness harness, {
  double min = double.negativeInfinity,
  double max = double.infinity,
  double step = 1,
  double? largeStep,
  bool enabled = true,
  bool readOnly = false,
  bool withOnChanged = true,
  FocusNode? focusNode,
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
        child: StatefulBuilder(
          builder: (context, setState) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              NakedNumberField(
                value: harness.value,
                min: min,
                max: max,
                step: step,
                largeStep: largeStep,
                enabled: enabled,
                readOnly: readOnly,
                focusNode: focusNode,
                onChanged: withOnChanged
                    ? (next) => setState(() => harness.onChanged(next))
                    : null,
                builder: (context, field) => SizedBox(
                  width: 300,
                  child: Row(
                    children: [
                      ExcludeFocus(
                        child: TextFieldTapRegion(
                          child: NakedButton(
                            onPressed: field.decrement,
                            semanticLabel: 'Decrease',
                            child: const Text('-'),
                          ),
                        ),
                      ),
                      Expanded(
                        child: field.spinButton(
                          NakedTextField(
                            controller: field.controller,
                            focusNode: field.focusNode,
                            enabled: field.enabled,
                            readOnly: field.readOnly,
                            keyboardType: field.keyboardType,
                            onSubmitted: field.onSubmitted,
                            semanticLabel: 'Quantity',
                            builder: (context, state, editable) => editable,
                          ),
                        ),
                      ),
                      ExcludeFocus(
                        child: TextFieldTapRegion(
                          child: NakedButton(
                            onPressed: field.increment,
                            semanticLabel: 'Increase',
                            child: const Text('+'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const _After(),
            ],
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

class _After extends StatelessWidget {
  const _After();

  @override
  Widget build(BuildContext context) => NakedButton(
    onPressed: () {},
    semanticLabel: 'After',
    child: const Text('after'),
  );
}

Finder get _editor => find.byType(EditableText);

String _text(WidgetTester tester) =>
    tester.widget<EditableText>(_editor).controller.text;

Future<void> _focusEditor(WidgetTester tester) async {
  await tester.tap(_editor);
  await tester.pump();
}

Future<void> _press(WidgetTester tester, LogicalKeyboardKey key) async {
  await tester.sendKeyEvent(key);
  await tester.pump();
}

void main() {
  group('semantics', () {
    testWidgets('the editor node carries value, next values and step actions', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final harness = _Harness()..value = 5;
      await _pump(tester, harness, min: 0, max: 10);

      expect(
        tester.getSemantics(_editor),
        isSemantics(
          label: 'Quantity',
          value: '5',
          increasedValue: '6',
          decreasedValue: '4',
          isTextField: true,
          isEnabled: true,
          hasEnabledState: true,
          isFocusable: true,
          hasIncreaseAction: true,
          hasDecreaseAction: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.text('+')),
        isSemantics(
          label: 'Increase',
          isButton: true,
          isEnabled: true,
          isTextField: false,
          hasTapAction: true,
          hasIncreaseAction: false,
        ),
      );

      tester
          .getSemantics(_editor)
          .owner!
          .performAction(
            tester.getSemantics(_editor).id,
            SemanticsAction.increase,
          );
      await tester.pump();
      expect(harness.proposals, [6]);
      expect(_text(tester), '6');
      expect(tester.getSemantics(_editor).value, '6');
      handle.dispose();
    });

    testWidgets('a bound side drops its action and next value', (tester) async {
      final handle = tester.ensureSemantics();
      final harness = _Harness()..value = 10;
      await _pump(tester, harness, min: 0, max: 10);

      final data = tester.getSemantics(_editor).getSemanticsData();
      expect(data.hasAction(SemanticsAction.increase), isFalse);
      expect(data.hasAction(SemanticsAction.decrease), isTrue);
      expect(data.increasedValue, isEmpty);
      expect(data.decreasedValue, '9');
      expect(
        tester
            .getSemantics(find.text('+'))
            .getSemanticsData()
            .hasAction(SemanticsAction.tap),
        isFalse,
      );
      handle.dispose();
    });

    testWidgets('disabled and read-only fields expose no step actions', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      for (final (enabled, readOnly) in [(false, false), (true, true)]) {
        final harness = _Harness()..value = 5;
        await _pump(
          tester,
          harness,
          min: 0,
          max: 10,
          enabled: enabled,
          readOnly: readOnly,
        );
        final data = tester.getSemantics(_editor).getSemanticsData();
        expect(data.hasAction(SemanticsAction.increase), isFalse);
        expect(data.hasAction(SemanticsAction.decrease), isFalse);
        expect(data.value, '5');
        expect(data.flagsCollection.isReadOnly, isTrue);
      }
      handle.dispose();
    });
  });

  group('keyboard', () {
    testWidgets('arrows, pages, Home and End step a bounded field', (
      tester,
    ) async {
      final harness = _Harness()..value = 50;
      await _pump(tester, harness, min: 0, max: 100, step: 2, largeStep: 20);
      await _focusEditor(tester);

      await _press(tester, LogicalKeyboardKey.arrowUp);
      await _press(tester, LogicalKeyboardKey.arrowDown);
      await _press(tester, LogicalKeyboardKey.arrowDown);
      await _press(tester, LogicalKeyboardKey.pageUp);
      await _press(tester, LogicalKeyboardKey.pageDown);
      await _press(tester, LogicalKeyboardKey.end);
      await _press(tester, LogicalKeyboardKey.arrowUp);
      await _press(tester, LogicalKeyboardKey.home);
      await _press(tester, LogicalKeyboardKey.arrowDown);

      expect(harness.proposals, [52, 50, 48, 68, 48, 100, 0]);
      expect(_text(tester), '0');
    });

    testWidgets('Home and End move the caret when the side is unbounded', (
      tester,
    ) async {
      final harness = _Harness()..value = 123;
      await _pump(tester, harness);
      await _focusEditor(tester);
      final controller = tester.widget<EditableText>(_editor).controller;

      await _press(tester, LogicalKeyboardKey.home);
      expect(controller.selection.baseOffset, 0);
      await _press(tester, LogicalKeyboardKey.end);
      expect(controller.selection.baseOffset, 3);
      expect(harness.proposals, isEmpty);
    });

    testWidgets('a held arrow repeats and stops at the bound', (tester) async {
      final harness = _Harness()..value = 8;
      await _pump(tester, harness, max: 10);
      await _focusEditor(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();
      for (var i = 0; i < 3; i++) {
        await tester.sendKeyRepeatEvent(LogicalKeyboardKey.arrowUp);
        await tester.pump();
      }
      await tester.sendKeyUpEvent(LogicalKeyboardKey.arrowUp);
      await tester.pump();

      expect(harness.proposals, [9, 10]);
    });

    testWidgets('shift-modified arrows stay with the editor', (tester) async {
      final harness = _Harness()..value = 5;
      await _pump(tester, harness);
      await _focusEditor(tester);

      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      await _press(tester, LogicalKeyboardKey.arrowUp);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);

      expect(harness.proposals, isEmpty);
    });

    testWidgets('read-only, disabled and callback-less fields ignore keys', (
      tester,
    ) async {
      for (final (enabled, readOnly, withOnChanged) in [
        (true, true, true),
        (true, false, false),
      ]) {
        final harness = _Harness()..value = 5;
        await _pump(
          tester,
          harness,
          enabled: enabled,
          readOnly: readOnly,
          withOnChanged: withOnChanged,
        );
        await _focusEditor(tester);
        await _press(tester, LogicalKeyboardKey.arrowUp);
        expect(harness.proposals, isEmpty);
        expect(_text(tester), '5');
      }
    });

    testWidgets('fractional steps land on the step grid', (tester) async {
      final harness = _Harness()..value = 0;
      await _pump(tester, harness, step: 0.1);
      await _focusEditor(tester);

      for (var i = 0; i < 3; i++) {
        await _press(tester, LogicalKeyboardKey.arrowUp);
      }

      expect(harness.proposals, [0.1, 0.2, 0.3]);
      expect(_text(tester), '0.3');
    });
  });

  group('drafts', () {
    testWidgets('submit commits a typed draft once, clamped', (tester) async {
      final harness = _Harness()..value = 5;
      await _pump(tester, harness, min: 0, max: 99);
      await _focusEditor(tester);

      await tester.enterText(_editor, '500');
      expect(harness.proposals, isEmpty);
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(harness.proposals, [99]);
      expect(_text(tester), '99');
    });

    testWidgets('losing focus commits; a bad draft reverts; empty is null', (
      tester,
    ) async {
      final harness = _Harness()..value = 5;
      await _pump(tester, harness);

      await _focusEditor(tester);
      await tester.enterText(_editor, '12');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      expect(harness.proposals, [12]);

      await _focusEditor(tester);
      await tester.enterText(_editor, 'twelve');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      expect(harness.proposals, [12]);
      expect(_text(tester), '12');

      await _focusEditor(tester);
      await tester.enterText(_editor, '');
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pump();
      expect(harness.proposals, [12, null]);
      expect(_text(tester), '');
    });

    testWidgets('a declined commit restores the owner value', (tester) async {
      final harness = _Harness()
        ..value = 5
        ..accept = false;
      await _pump(tester, harness);
      await _focusEditor(tester);

      await tester.enterText(_editor, '8');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(harness.proposals, [8]);
      expect(_text(tester), '5');

      await _focusEditor(tester);
      await _press(tester, LogicalKeyboardKey.arrowUp);
      expect(harness.proposals, [8, 6]);
      expect(_text(tester), '5');
    });

    testWidgets('stepping starts from the typed draft', (tester) async {
      final harness = _Harness()..value = 5;
      await _pump(tester, harness);
      await _focusEditor(tester);

      await tester.enterText(_editor, '40');
      await tester.tap(find.text('+'));
      await tester.pump();

      expect(harness.proposals, [41]);
      expect(_text(tester), '41');
      expect(
        tester.widget<EditableText>(_editor).focusNode.hasFocus,
        isTrue,
        reason: 'a step control press keeps the editor focused',
      );
    });

    testWidgets('an empty field steps to the minimum, or zero', (tester) async {
      final bounded = _Harness();
      await _pump(tester, bounded, min: 3, max: 9);
      await tester.tap(find.text('+'));
      await tester.pump();
      expect(bounded.proposals, [3]);

      final unbounded = _Harness();
      await _pump(tester, unbounded);
      await tester.tap(find.text('-'));
      await tester.pump();
      expect(unbounded.proposals, [0]);
    });
  });

  group('focus', () {
    testWidgets('the field is one Tab stop; step controls take none', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final harness = _Harness()..value = 1;
      await _pump(tester, harness, focusNode: focusNode);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(focusNode.hasPrimaryFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);
      expect(
        FocusManager.instance.primaryFocus?.context?.widget,
        isNot(isA<EditableText>()),
      );
    });

    testWidgets('step controls follow the bounds', (tester) async {
      final harness = _Harness()..value = 0;
      await _pump(tester, harness, min: 0, max: 1);

      await tester.tap(find.text('-'));
      await tester.pump();
      expect(harness.proposals, isEmpty);

      await tester.tap(find.text('+'));
      await tester.pump();
      await tester.tap(find.text('+'));
      await tester.pump();
      expect(harness.proposals, [1]);
    });
  });

  testWidgets('keyboard type follows the sign and the step fraction', (
    tester,
  ) async {
    late TextInputType type;
    Future<void> pump({required double min, required double step}) =>
        tester.pumpWidget(
          WidgetsApp(
            color: const Color(0xff000000),
            builder: (context, _) => NakedNumberField(
              value: 1,
              min: min,
              step: step,
              builder: (context, field) {
                type = field.keyboardType;
                return const SizedBox();
              },
            ),
          ),
        );

    await pump(min: 0, step: 1);
    expect(
      type,
      const TextInputType.numberWithOptions(signed: false, decimal: false),
    );
    await pump(min: -5, step: 0.25);
    expect(
      type,
      const TextInputType.numberWithOptions(signed: true, decimal: true),
    );
  });
}
