import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

import '../helpers/mock.dart';
import '../helpers/pump.dart';

void main() {
  for (final reset in ['Show less', 'new call', 'settled']) {
    testWidgets('Show all survives recycling until $reset', (tester) async {
      final scroll = ScrollController();
      final output = List.generate(12, (i) => 'line $i').join('\n');
      final call = ValueNotifier(runningCall.copyWith(output: output));
      addTearDown(scroll.dispose);
      addTearDown(call.dispose);
      const target = ValueKey('full-output');
      const toggle = ValueKey('agent-tool-call-output-toggle');
      await pumpAgent(
        tester,
        SizedBox(
          width: 768,
          height: 400,
          child: ValueListenableBuilder<AgentToolCallPart>(
            valueListenable: call,
            builder: (context, value, _) => AgentConversation(
              scrollController: scroll,
              showLatestButton: false,
              children: [
                for (var i = 0; i < 30; i++)
                  const AgentTurn(children: [SizedBox(height: 200)]),
                AgentTurn(
                  children: [
                    AgentToolCall(
                      key: target,
                      call: value,
                      style: AgentToolCallStyler(outputMaxHeight: 60),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Show all'), findsOneWidget);
      await tester.tap(find.byKey(toggle));
      FocusManager.instance.primaryFocus?.unfocus();
      await tester.pumpAndSettle();
      final state = tester.state(find.byKey(target));

      Future<void> recycle() async {
        scroll.jumpTo(0);
        await tester.pumpAndSettle();
        expect(find.byKey(target), findsNothing);
        scroll.jumpTo(scroll.position.maxScrollExtent);
        await tester.pumpAndSettle();
      }

      await recycle();
      expect(find.text('Show less'), findsOneWidget);
      expect(tester.state(find.byKey(target)), same(state));
      expect(
        tester.getSize(find.byType(SingleChildScrollView)).height,
        tester.getSize(find.text(output)).height,
      );

      switch (reset) {
        case 'Show less':
          await tester.tap(find.byKey(toggle));
          FocusManager.instance.primaryFocus?.unfocus();
        case 'new call':
          call.value = AgentToolCallPart(
            id: 'new-call',
            name: runningCall.name,
            status: AgentToolCallStatus.running,
            output: output,
          );
        case 'settled':
          call.value = call.value.copyWith(
            status: AgentToolCallStatus.succeeded,
          );
      }
      await tester.pumpAndSettle();
      await recycle();
      expect(tester.state(find.byKey(target)), isNot(same(state)));
      if (reset == 'settled') {
        expect(find.text(output), findsNothing);
      } else {
        expect(find.text('Show all'), findsOneWidget);
        expect(tester.getSize(find.byType(SingleChildScrollView)).height, 60);
      }
    });
  }

  for (final tool in [true, false]) {
    for (final expanded in [false, true]) {
      testWidgets(
        '${tool ? 'tool output' : 'steps rail'} keeps a reader ${expanded ? 'open' : 'close'} across recycling',
        (tester) async {
          final scroll = ScrollController();
          final finished = ValueNotifier(false);
          addTearDown(scroll.dispose);
          addTearDown(finished.dispose);
          const target = ValueKey('disclosure');
          final body = tool ? runningOutput : readModule.title;
          await pumpAgent(
            tester,
            SizedBox(
              width: 768,
              height: 400,
              child: ValueListenableBuilder<bool>(
                valueListenable: finished,
                builder: (context, done, _) => AgentConversation(
                  scrollController: scroll,
                  showLatestButton: false,
                  children: [
                    for (var i = 0; i < 30; i++) const SizedBox(height: 200),
                    AgentTurn(
                      children: [
                        if (tool)
                          AgentToolCall(
                            key: target,
                            call: done ? doneCall : runningCall,
                            defaultExpanded: done ? null : !expanded,
                          )
                        else
                          AgentSteps(
                            key: target,
                            steps: const [readModule],
                            status: done
                                ? AgentRunStatus.complete
                                : AgentRunStatus.working,
                            defaultExpanded: done ? null : !expanded,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          await tester.tap(
            tool
                ? find.textContaining(
                    'Running the cart tests',
                    findRichText: true,
                  )
                : find.text('Thinking…'),
          );
          FocusManager.instance.primaryFocus?.unfocus();
          await tester.pumpAndSettle();
          expect(find.text(body), expanded ? findsOneWidget : findsNothing);
          final state = tester.state(find.byKey(target));

          Future<void> recycle() async {
            scroll.jumpTo(0);
            await tester.pumpAndSettle();
            expect(find.byKey(target), findsNothing);
            scroll.jumpTo(scroll.position.maxScrollExtent);
            await tester.pumpAndSettle();
          }

          await recycle();
          expect(find.text(body), expanded ? findsOneWidget : findsNothing);
          expect(tester.state(find.byKey(target)), same(state));

          finished.value = true;
          await tester.pumpAndSettle();
          await recycle();
          expect(find.text(body), expanded ? findsOneWidget : findsNothing);
          expect(
            tester.state(find.byKey(target)),
            expanded ? same(state) : isNot(same(state)),
            reason: 'A settled closed surface no longer needs retention.',
          );
        },
      );
    }
  }
}
