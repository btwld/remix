import 'dart:ui' show PointerDeviceKind;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

import '../helpers/glyphs.dart';
import '../helpers/pump.dart';

const _latest = ValueKey('agent-conversation-latest');

Widget _turn(int index) => SizedBox(
  key: ValueKey('turn-$index'),
  height: 100,
  child: Text('Turn $index'),
);

/// Hosts a conversation whose turns the test adds.
Future<(ValueNotifier<int>, ScrollController, FocusNode)> _pump(
  WidgetTester tester, {
  int turns = 10,
  bool busy = false,
  bool disableAnimations = false,
  AgentConversationStyler style = const AgentConversationStyler.create(),
}) async {
  final count = ValueNotifier(turns);
  final controller = ScrollController();
  final start = FocusNode(debugLabel: 'start');
  addTearDown(count.dispose);
  addTearDown(controller.dispose);
  addTearDown(start.dispose);
  await pumpAgent(
    tester,
    Column(
      children: [
        Focus(focusNode: start, child: const SizedBox(height: 1)),
        SizedBox(
          width: 600,
          height: 300,
          child: ValueListenableBuilder<int>(
            valueListenable: count,
            builder: (context, count, _) => AgentConversation.builder(
              itemCount: count,
              itemBuilder: (context, index) => _turn(index),
              scrollController: controller,
              busy: busy,
              empty: const Text('What should we work on?'),
              glyphBuilder: testGlyphs,
              style: style,
            ),
          ),
        ),
      ],
    ),
    disableAnimations: disableAnimations,
  );
  await tester.pump();
  return (count, controller, start);
}

Future<void> _wheel(WidgetTester tester, double dy) async {
  final mouse = TestPointer(1, PointerDeviceKind.mouse);
  mouse.hover(tester.getCenter(find.byType(AgentConversation)));
  await tester.sendEventToBinding(mouse.scroll(Offset(0, dy)));
  await tester.pump();
}

Matcher _atEndOf(ScrollController controller) =>
    closeTo(controller.position.maxScrollExtent, 0.5);

void main() {
  testWidgets('spaces turns apart and the blocks of a turn closer', (
    tester,
  ) async {
    await pumpAgent(
      tester,
      SizedBox(
        width: 600,
        height: 400,
        child: AgentConversation(
          style: AgentConversationStyler(turnSpacing: 48, blockSpacing: 24),
          children: const [
            AgentTurn(
              children: [
                SizedBox(key: ValueKey('a1'), height: 20),
                SizedBox(key: ValueKey('a2'), height: 20),
              ],
            ),
            AgentTurn(children: [SizedBox(key: ValueKey('b1'), height: 20)]),
          ],
        ),
      ),
    );

    Rect rect(String key) => tester.getRect(find.byKey(ValueKey(key)));
    expect(rect('a2').top - rect('a1').bottom, 24);
    expect(rect('b1').top - rect('a2').bottom, 48);
  });

  testWidgets('centers turns in a wider transcript at their maximum width', (
    tester,
  ) async {
    await pumpAgent(
      tester,
      SizedBox(
        width: 800,
        height: 400,
        child: AgentConversation(
          style: AgentConversationStyler(maxWidth: 600),
          children: const [SizedBox(key: ValueKey('turn'), height: 20)],
        ),
      ),
    );

    final turn = tester.getRect(find.byKey(const ValueKey('turn')));
    expect(turn.width, 600);
    expect(turn.left, 100);
  });

  testWidgets('shows the empty slot until the first turn', (tester) async {
    final (count, _, _) = await _pump(tester, turns: 0);
    expect(find.text('What should we work on?'), findsOneWidget);

    count.value = 1;
    await tester.pump();
    expect(find.text('What should we work on?'), findsNothing);
    expect(find.text('Turn 0'), findsOneWidget);
  });

  testWidgets('follows new turns at the live edge', (tester) async {
    final (count, controller, _) = await _pump(tester);
    expect(controller.offset, _atEndOf(controller));

    count.value = 14;
    await tester.pump();
    expect(controller.offset, _atEndOf(controller));
    expect(find.text('Turn 13'), findsOneWidget);
  });

  testWidgets('offers the latest after the reader scrolls back, animated', (
    tester,
  ) async {
    final (count, controller, _) = await _pump(tester);
    expect(find.byKey(_latest), findsNothing);

    await _wheel(tester, -400);
    expect(find.byKey(_latest), findsOneWidget);
    expect(findGlyph(AgentGlyph.latest), findsOneWidget);
    expect(
      find.ancestor(
        of: find.byKey(_latest),
        matching: find.byType(FadeTransition),
      ),
      findsOneWidget,
    );

    // Output that arrives while the reader reads older turns does not move
    // them.
    final reading = controller.offset;
    count.value = 12;
    await tester.pump();
    expect(controller.offset, reading);

    await tester.tap(find.byKey(_latest));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    // The return animates: partway there after one frame.
    expect(controller.offset, lessThan(controller.position.maxScrollExtent));
    await tester.pumpAndSettle();
    expect(controller.offset, _atEndOf(controller));
    expect(find.byKey(_latest), findsNothing);
  });

  testWidgets('reduced motion shows the way back and returns at once', (
    tester,
  ) async {
    final (_, controller, _) = await _pump(tester, disableAnimations: true);

    await _wheel(tester, -400);
    expect(find.byKey(_latest), findsOneWidget);
    expect(
      find.ancestor(
        of: find.byKey(_latest),
        matching: find.byType(FadeTransition),
      ),
      findsNothing,
    );

    await tester.tap(find.byKey(_latest));
    await tester.pump();
    expect(controller.offset, _atEndOf(controller));
    expect(find.byKey(_latest), findsNothing);
  });

  testWidgets('scrolls with the arrow keys, Page Up, Home and End', (
    tester,
  ) async {
    final (_, controller, start) = await _pump(tester);
    final end = controller.position.maxScrollExtent;
    start.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(FocusManager.instance.primaryFocus?.debugLabel, 'AgentConversation');

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pump();
    expect(controller.offset, end - 50);

    await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
    await tester.pump();
    expect(controller.offset, end - 50 - 300 * 0.8);

    await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
    expect(controller.offset, 0);
    // Leaving the end releases the live edge, so the way back appears.
    expect(find.byKey(_latest), findsOneWidget);

    await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pumpAndSettle();
    expect(controller.offset, _atEndOf(controller));
    expect(find.byKey(_latest), findsNothing);
  });

  testWidgets('returning from the keyboard moves focus to the transcript', (
    tester,
  ) async {
    final (_, controller, start) = await _pump(tester);
    await _wheel(tester, -400);
    start.requestFocus();
    await tester.pump();
    // The transcript, then the way back.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(FocusManager.instance.primaryFocus?.debugLabel, 'Scroll to latest');

    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.byKey(_latest), findsNothing);
    expect(controller.offset, _atEndOf(controller));
    expect(FocusManager.instance.primaryFocus?.debugLabel, 'AgentConversation');
  });

  testWidgets('reports work in progress without a live region', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, busy: true);

    final node = tester.getSemantics(find.bySemanticsLabel('Conversation'));
    expect(node.value, 'Busy');
    expect(node, isNot(isSemantics(isLiveRegion: true)));
    semantics.dispose();
  });

  testWidgets('a host live edge drives the transcript', (tester) async {
    final liveEdge = AgentLiveEdgeController();
    addTearDown(liveEdge.dispose);
    await pumpAgent(
      tester,
      SizedBox(
        width: 600,
        height: 300,
        child: AgentConversation.builder(
          itemCount: 10,
          itemBuilder: (context, index) => _turn(index),
          liveEdge: liveEdge,
        ),
      ),
    );
    await tester.pump();

    liveEdge.release();
    await tester.pump();
    expect(liveEdge.following, isFalse);
    await _wheel(tester, -400);
    expect(liveEdge.showLatest, isTrue);
    expect(find.byKey(_latest), findsOneWidget);
  });
}
