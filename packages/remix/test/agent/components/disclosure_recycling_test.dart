import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

import '../helpers/mock.dart';
import '../helpers/pump.dart';

void main() {
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
