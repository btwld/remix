import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/glyphs.dart';
import '../helpers/pump.dart';

const _send = ValueKey('agent-composer-send');
const _stop = ValueKey('agent-composer-stop');

class _Log {
  final sent = <String>[];
  int stops = 0;
}

Future<(AgentComposerController, FocusNode, _Log)> _pump(
  WidgetTester tester, {
  bool running = false,
  AgentComposerStyler style = const AgentComposerStyler.create(),
}) async {
  final controller = AgentComposerController(running: running);
  final focusNode = FocusNode();
  addTearDown(controller.dispose);
  addTearDown(focusNode.dispose);
  final log = _Log();
  await pumpAgent(
    tester,
    SizedBox(
      width: 600,
      child: AgentComposer(
        controller: controller,
        focusNode: focusNode,
        onSubmit: log.sent.add,
        onStop: () => log.stops++,
        hintText: 'Ask the agent…',
        leading: const SizedBox(key: ValueKey('attach'), width: 32, height: 32),
        glyphBuilder: testGlyphs,
        style: style,
      ),
    ),
    overlay: true,
  );
  return (controller, focusNode, log);
}

bool _enabled(WidgetTester tester, Key key) =>
    tester.widget<RemixIconButton>(find.byKey(key)).enabled;

double _fieldHeight(WidgetTester tester) =>
    tester.getSize(find.byType(RemixTextArea)).height;

void main() {
  testWidgets('an empty composer offers Send only once there is a draft', (
    tester,
  ) async {
    final (controller, _, _) = await _pump(tester);

    expect(find.text('Ask the agent…'), findsOneWidget);
    expect(find.byKey(const ValueKey('attach')), findsOneWidget);
    expect(findGlyph(AgentGlyph.send), findsOneWidget);
    expect(_enabled(tester, _send), isFalse);

    await tester.enterText(find.byType(EditableText), '   ');
    await tester.pump();
    expect(_enabled(tester, _send), isFalse);

    await tester.enterText(find.byType(EditableText), 'Run the tests');
    await tester.pump();
    expect(_enabled(tester, _send), isTrue);
    expect(controller.canSubmit, isTrue);
  });

  testWidgets('Enter sends the trimmed draft; Shift+Enter adds a line', (
    tester,
  ) async {
    final (controller, _, log) = await _pump(tester);
    await tester.enterText(find.byType(EditableText), '  Run the tests  ');

    await tester.sendKeyDownEvent(LogicalKeyboardKey.shiftLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.shiftLeft);
    await tester.pump();
    expect(log.sent, isEmpty);

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(log.sent, ['Run the tests']);
    expect(controller.text, isEmpty);
  });

  testWidgets('Send sends and keeps focus in the field', (tester) async {
    final (_, focusNode, log) = await _pump(tester);
    await tester.enterText(find.byType(EditableText), 'Run the tests');
    await tester.pump();

    await tester.tap(find.byKey(_send));
    await tester.pump();
    expect(log.sent, ['Run the tests']);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('a live run offers Stop and Enter does not send', (tester) async {
    final (controller, _, log) = await _pump(tester, running: true);

    expect(find.byKey(_send), findsNothing);
    expect(findGlyph(AgentGlyph.stop), findsOneWidget);
    await tester.enterText(find.byType(EditableText), 'Follow-up');
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(log.sent, isEmpty);
    expect(controller.text, 'Follow-up');

    await tester.tap(find.byKey(_stop));
    expect(log.stops, 1);

    controller.running = false;
    await tester.pump();
    expect(find.byKey(_send), findsOneWidget);
    expect(find.byKey(_stop), findsNothing);
  });

  testWidgets('the field grows from one line to its maximum height', (
    tester,
  ) async {
    final (_, _, _) = await _pump(
      tester,
      style: AgentComposerStyler(fieldMaxHeight: 120),
    );
    final oneLine = _fieldHeight(tester);

    await tester.enterText(find.byType(EditableText), 'one\ntwo\nthree');
    await tester.pump();
    final threeLines = _fieldHeight(tester);
    expect(threeLines, greaterThan(oneLine));

    await tester.enterText(
      find.byType(EditableText),
      List.generate(40, (i) => 'line $i').join('\n'),
    );
    await tester.pump();
    expect(_fieldHeight(tester), 120);
  });

  testWidgets('a tap on the surface focuses the field', (tester) async {
    final (_, focusNode, _) = await _pump(tester);
    expect(focusNode.hasFocus, isFalse);

    // The empty middle of the toolbar.
    final toolbar = tester.getRect(find.byKey(const ValueKey('attach')));
    await tester.tapAt(Offset(300, toolbar.center.dy));
    await tester.pump();
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('the surface resolves focused while the field has focus', (
    tester,
  ) async {
    const ring = Color(0xFF8D8D8D);
    final (_, focusNode, _) = await _pump(
      tester,
      style: AgentComposerStyler().onFocused(
        AgentComposerStyler(container: BoxStyler().color(ring)),
      ),
    );
    Color? surface() {
      final box = tester.widget<Box>(
        find
            .descendant(
              of: find.byType(AgentComposer),
              matching: find.byType(Box),
            )
            .first,
      );
      final decoration = box.styleSpec?.spec.decoration;
      return decoration is BoxDecoration ? decoration.color : null;
    }

    expect(surface(), isNull);
    focusNode.requestFocus();
    // Focus lands after the frame; the surface follows on the next one.
    await tester.pump();
    await tester.pump();
    expect(surface(), ring);
  });

  testWidgets('names the composer and its actions', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, running: false);

    expect(find.bySemanticsLabel('Message'), findsWidgets);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Send')),
      isSemantics(label: 'Send', isButton: true),
    );
    semantics.dispose();
  });

  testWidgets('the toolbar wraps at a narrow width and a large text scale', (
    tester,
  ) async {
    final controller = AgentComposerController(text: 'hi');
    addTearDown(controller.dispose);
    await pumpAgent(
      tester,
      Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: SizedBox(
            width: 200,
            child: AgentComposer(
              controller: controller,
              onSubmit: (_) {},
              leading: const SizedBox(
                key: ValueKey('attach'),
                width: 120,
                height: 32,
              ),
              trailing: const SizedBox(
                key: ValueKey('model'),
                width: 120,
                height: 32,
              ),
              glyphBuilder: testGlyphs,
            ),
          ),
        ),
      ),
      overlay: true,
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    for (final finder in [
      find.byKey(const ValueKey('attach')),
      find.byKey(const ValueKey('model')),
      find.byKey(_send),
    ]) {
      expect(finder, findsOneWidget);
      final rect = tester.getRect(finder);
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(200));
    }
  });

  testWidgets('keeps focus in the field after Stop', (tester) async {
    final (_, focusNode, log) = await _pump(tester, running: true);
    expect(focusNode.hasFocus, isFalse);

    await tester.tap(find.byKey(_stop));
    await tester.pump();
    await tester.pump();

    expect(log.stops, 1);
    expect(focusNode.hasFocus, isTrue);
  });

  testWidgets('names the field once', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, running: false);

    expect(find.bySemanticsLabel('Message'), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('the focused state follows a swapped focus node', (tester) async {
    const ring = Color(0xFF8D8D8D);
    final first = FocusNode();
    final second = FocusNode();
    addTearDown(first.dispose);
    addTearDown(second.dispose);
    final node = ValueNotifier(first);
    addTearDown(node.dispose);
    await pumpAgent(
      tester,
      ValueListenableBuilder<FocusNode>(
        valueListenable: node,
        builder: (context, node, _) => SizedBox(
          width: 600,
          child: AgentComposer(
            focusNode: node,
            glyphBuilder: testGlyphs,
            style: AgentComposerStyler().onFocused(
              AgentComposerStyler(container: BoxStyler().color(ring)),
            ),
          ),
        ),
      ),
      overlay: true,
    );
    Color? surface() {
      final box = tester.widget<Box>(
        find
            .descendant(
              of: find.byType(AgentComposer),
              matching: find.byType(Box),
            )
            .first,
      );
      final decoration = box.styleSpec?.spec.decoration;
      return decoration is BoxDecoration ? decoration.color : null;
    }

    // The incoming node already has focus when the swap happens.
    second.requestFocus();
    await tester.pump();
    expect(surface(), isNull);
    node.value = second;
    await tester.pump();
    await tester.pump();
    expect(surface(), ring);

    node.value = first;
    await tester.pump();
    await tester.pump();
    expect(surface(), isNull);
  });
}
