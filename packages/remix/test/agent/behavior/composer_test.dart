import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/agent.dart';

import '../helpers/pump.dart';

// The key cases are ported from registry_source/test/agent/components/
// behavior_test.dart (the composer's Enter handling) onto a harness: a Remix
// text area under a Focus that hands key events to the controller, as the
// composer widget does.

Future<({AgentComposerController composer, FocusNode focus})> _pump(
  WidgetTester tester, {
  required ValueChanged<String>? onSubmit,
  bool allowSubmit = true,
  bool running = false,
}) async {
  final composer = AgentComposerController(running: running);
  final focus = FocusNode();
  addTearDown(composer.dispose);
  addTearDown(focus.dispose);
  await pumpAgent(
    tester,
    Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: (node, event) => composer.handleKeyEvent(
        event,
        onSubmit: onSubmit,
        allowSubmit: allowSubmit,
      ),
      child: RemixTextArea(controller: composer, focusNode: focus),
    ),
    overlay: true,
  );
  focus.requestFocus();
  await tester.pump();
  return (composer: composer, focus: focus);
}

void main() {
  group('draft', () {
    test('a draft is any text besides whitespace', () {
      final composer = AgentComposerController(text: '  \n ');
      addTearDown(composer.dispose);
      expect(composer.hasDraft, isFalse);
      expect(composer.canSubmit, isFalse);
      composer.text = ' Run the tests ';
      expect(composer.hasDraft, isTrue);
      expect(composer.canSubmit, isTrue);
    });

    test('submit takes the trimmed draft and clears the field', () {
      final composer = AgentComposerController(text: '  Run the tests \n');
      addTearDown(composer.dispose);
      expect(composer.submit(), 'Run the tests');
      expect(composer.text, isEmpty);
      expect(composer.submit(), isNull, reason: 'Nothing is left to send.');
    });

    test('clearOnSubmit false keeps the draft after sending', () {
      final composer = AgentComposerController(
        text: 'Run the tests',
        clearOnSubmit: false,
      );
      addTearDown(composer.dispose);
      expect(composer.submit(), 'Run the tests');
      expect(composer.text, 'Run the tests');
    });

    test('a live run blocks sending and notifies once per change', () {
      final composer = AgentComposerController(text: 'draft');
      addTearDown(composer.dispose);
      var notified = 0;
      composer.addListener(() => notified++);
      composer
        ..running = true
        ..running = true;
      expect(notified, 1);
      expect(composer.canSubmit, isFalse);
      expect(composer.submit(), isNull);
      expect(composer.text, 'draft');
      composer.running = false;
      expect(composer.submit(), 'draft');
    });

    test('the Send button sends an open IME composition', () {
      final composer = AgentComposerController.fromValue(
        const TextEditingValue(
          text: 'compose',
          selection: TextSelection.collapsed(offset: 7),
          composing: TextRange(start: 0, end: 7),
        ),
      );
      addTearDown(composer.dispose);
      expect(composer.isComposing, isTrue);
      expect(composer.canSubmit, isTrue, reason: 'Send stays available.');
      // Android keeps the last word composing; tapping Send must still send.
      expect(composer.submit(), 'compose');
      expect(composer.text, isEmpty);
    });
  });

  group('Enter (ported)', () {
    testWidgets('IME composition and Shift+Enter belong to the field', (
      tester,
    ) async {
      final submitted = <String>[];
      final (:composer, :focus) = await _pump(tester, onSubmit: submitted.add);
      composer.value = const TextEditingValue(
        text: 'compose',
        selection: TextSelection.collapsed(offset: 7),
        composing: TextRange(start: 0, end: 7),
      );
      await tester.pump();
      expect(await tester.sendKeyEvent(LogicalKeyboardKey.enter), isFalse);
      expect(submitted, isEmpty);

      composer.value = const TextEditingValue(
        text: 'line',
        selection: TextSelection.collapsed(offset: 4),
      );
      await tester.pump();
      await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
      expect(await tester.sendKeyEvent(LogicalKeyboardKey.enter), isFalse);
      await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      expect(submitted, isEmpty);

      await tester.sendKeyEvent(LogicalKeyboardKey.numpadEnter);
      await tester.pump();
      expect(submitted, ['line']);
      expect(composer.text, isEmpty);
      expect(focus.hasFocus, isTrue);
    });

    testWidgets(
      'Enter never falls through to a newline in a sending composer',
      (tester) async {
        final submitted = <String>[];
        final (:composer, focus: _) = await _pump(
          tester,
          onSubmit: submitted.add,
        );

        // A handled key is not passed on to the platform's text input.
        expect(await tester.sendKeyEvent(LogicalKeyboardKey.enter), isTrue);
        expect(submitted, isEmpty);

        composer
          ..text = 'draft'
          ..running = true;
        await tester.pump();
        expect(await tester.sendKeyEvent(LogicalKeyboardKey.enter), isTrue);
        expect(submitted, isEmpty);
        expect(composer.text, 'draft');

        composer.running = false;
        await tester.pump();
        await tester.sendKeyDownEvent(LogicalKeyboardKey.enter);
        expect(
          await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter),
          isTrue,
        );
        expect(
          await tester.sendKeyRepeatEvent(LogicalKeyboardKey.enter),
          isTrue,
        );
        await tester.sendKeyUpEvent(LogicalKeyboardKey.enter);
        expect(submitted, ['draft'], reason: 'A held Enter sends once.');

        await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
        expect(await tester.sendKeyEvent(LogicalKeyboardKey.enter), isFalse);
        await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
      },
    );

    testWidgets('a composer without onSubmit leaves Enter to the field', (
      tester,
    ) async {
      await _pump(tester, onSubmit: null);
      expect(await tester.sendKeyEvent(LogicalKeyboardKey.enter), isFalse);
    });
  });

  testWidgets('a host that disables sending keeps Enter from the field', (
    tester,
  ) async {
    final submitted = <String>[];
    final (:composer, focus: _) = await _pump(
      tester,
      onSubmit: submitted.add,
      allowSubmit: false,
    );
    composer.text = 'draft';
    await tester.pump();
    expect(await tester.sendKeyEvent(LogicalKeyboardKey.enter), isTrue);
    expect(submitted, isEmpty);
    expect(composer.text, 'draft');
  });

  testWidgets('a composer created running ignores Enter until the run ends', (
    tester,
  ) async {
    final submitted = <String>[];
    final (:composer, focus: _) = await _pump(
      tester,
      onSubmit: submitted.add,
      running: true,
    );
    composer.text = 'draft';
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(submitted, isEmpty, reason: 'Enter is ignored while running.');
    composer.running = false;
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(submitted, ['draft']);
  });

  testWidgets('other keys stay with the field', (tester) async {
    final (composer: _, focus: _) = await _pump(tester, onSubmit: (_) {});
    expect(await tester.sendKeyEvent(LogicalKeyboardKey.keyA), isFalse);
  });
}
