import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/glyphs.dart';
import '../helpers/mock.dart' as mock;
import '../helpers/pump.dart';

// Each state of the approved mock (shots 01-06), composed from the widgets with
// the mock's spacing: a 768 column, 48 between turns, 24 between blocks.

const _send = ValueKey('agent-composer-send');
const _stop = ValueKey('agent-composer-stop');

final _conversation = AgentConversationStyler(
  maxWidth: 768,
  turnSpacing: 48,
  blockSpacing: 24,
);

class _Turn {
  const _Turn({
    required this.steps,
    this.call,
    this.answer,
    this.running = false,
  });

  final AgentSteps steps;
  final AgentToolCallPart? call;
  final String? answer;
  final bool running;
}

Future<void> _pumpScreen(WidgetTester tester, _Turn? turn) async {
  final controller = AgentComposerController(running: turn?.running ?? false);
  final focusNode = FocusNode();
  addTearDown(controller.dispose);
  addTearDown(focusNode.dispose);
  final composer = AgentComposer(
    controller: controller,
    focusNode: focusNode,
    onSubmit: (_) {},
    onStop: () {},
    hintText: turn == null ? 'Ask the agent…' : 'Ask a follow-up…',
  );
  await pumpAgent(
    tester,
    AgentGlyphs(
      builder: testGlyphs,
      child: SizedBox(
        width: 1280,
        height: 900,
        child: Column(
          children: [
            Expanded(
              child: AgentConversation(
                style: _conversation,
                empty: turn != null
                    ? null
                    : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('What should we work on?'),
                          SizedBox(width: 768, child: composer),
                          AgentSuggestions(
                            controller: controller,
                            focusNode: focusNode,
                            suggestions: const [
                              AgentSuggestion(label: 'Review checkout'),
                              AgentSuggestion(label: 'Run terminal checks'),
                              AgentSuggestion(
                                label: 'Recover a failed command',
                              ),
                            ],
                          ),
                        ],
                      ),
                children: [
                  if (turn != null)
                    AgentTurn(
                      children: [
                        const AgentMessage(
                          role: AgentRole.user,
                          child: Text(mock.prompt),
                        ),
                        turn.steps,
                        if (turn.call case final call?)
                          AgentToolCall(call: call, onDecision: (_) {}),
                        if (turn.answer case final answer?)
                          AgentAnswer(
                            sources: answer.startsWith('The cart')
                                ? const AgentSources(sources: mock.sources)
                                : null,
                            onCopy: () {},
                            onFeedback: (_) {},
                            onRetry: () {},
                            child: Text(answer),
                          ),
                      ],
                    ),
                ],
              ),
            ),
            if (turn != null) SizedBox(width: 768, child: composer),
          ],
        ),
      ),
    ),
    surface: const Size(1280, 900),
    overlay: true,
  );
  await tester.pumpAndSettle();
}

/// The blocks of the turn, top to bottom, are in the expected order with
/// the block spacing between them.
void _expectStacked(WidgetTester tester, List<Finder> blocks) {
  for (var i = 1; i < blocks.length; i++) {
    final above = tester.getRect(blocks[i - 1]);
    final below = tester.getRect(blocks[i]);
    expect(below.top - above.bottom, closeTo(24, 0.01));
  }
}

void main() {
  testWidgets('01 empty: a question, the composer and three starters', (
    tester,
  ) async {
    await _pumpScreen(tester, null);

    expect(find.text('What should we work on?'), findsOneWidget);
    expect(find.text('Ask the agent…'), findsOneWidget);
    expect(find.byType(RemixButton), findsNWidgets(3));
    expect(find.byKey(_send), findsOneWidget);
    expect(find.byType(AgentTurn), findsNothing);
  });

  testWidgets('02 approval: steps wait and the card asks; Stop is live', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const _Turn(
        running: true,
        steps: AgentSteps(
          steps: [mock.readModule, mock.foundTests],
          status: AgentRunStatus.waiting,
        ),
        call: mock.approvalCall,
      ),
    );

    expect(find.text('Waiting for approval · 2 steps'), findsOneWidget);
    expect(find.text(mock.foundTests.title), findsOneWidget);
    expect(find.text('Run the cart tests?'), findsOneWidget);
    expect(find.text('Allow once'), findsOneWidget);
    expect(find.byKey(_stop), findsOneWidget);
    _expectStacked(tester, [
      find.byType(AgentMessage),
      find.byType(AgentSteps),
      find.byType(AgentToolCall),
    ]);
  });

  testWidgets('03 running: the row streams its output under the steps', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const _Turn(
        running: true,
        steps: AgentSteps(
          steps: [mock.readModule, mock.foundTests],
          defaultExpanded: false,
        ),
        call: mock.runningCall,
      ),
    );

    expect(find.text('Thinking…'), findsOneWidget);
    expect(find.text('Running'), findsOneWidget);
    expect(find.text(mock.runningOutput), findsOneWidget);
    expect(find.byKey(_stop), findsOneWidget);
    _expectStacked(tester, [
      find.byType(AgentMessage),
      find.byType(AgentSteps),
      find.byType(AgentToolCall),
    ]);
  });

  testWidgets('04 done: settled steps, a quiet row and the answer', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const _Turn(
        steps: AgentSteps(
          steps: [mock.readModule, mock.foundTests, mock.ranTests],
          status: AgentRunStatus.complete,
          duration: Duration(seconds: 6),
        ),
        call: mock.doneCall,
        answer: 'The cart flow is ready. All 31 checkout tests pass.',
      ),
    );

    expect(find.text('Thought for 6s · 3 steps'), findsOneWidget);
    expect(find.text(mock.readModule.title), findsNothing);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.text(mock.runningOutput), findsNothing);
    expect(find.text('2 files referenced'), findsOneWidget);
    expect(find.byType(RemixIconButton), findsNWidgets(5));
    expect(find.byKey(_send), findsOneWidget);
    _expectStacked(tester, [
      find.byType(AgentMessage),
      find.byType(AgentSteps),
      find.byType(AgentToolCall),
      find.byType(AgentAnswer),
    ]);
  });

  testWidgets('05 failed: the failure stays open above the answer', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      const _Turn(
        steps: AgentSteps(
          steps: [mock.readModule, mock.foundTests, mock.ranTests],
          status: AgentRunStatus.complete,
          duration: Duration(seconds: 4),
        ),
        call: mock.failedCall,
        answer: 'One test fails: the order stays pending after submission.',
      ),
    );

    expect(find.text('Thought for 4s · 3 steps'), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
    expect(find.text(mock.failedError), findsOneWidget);
    expect(
      tester.getRect(find.text(mock.failedError)).bottom,
      lessThan(tester.getRect(find.byType(AgentAnswer)).top),
    );
  });

  testWidgets('06 denied: the row records the refusal', (tester) async {
    await _pumpScreen(
      tester,
      const _Turn(
        steps: AgentSteps(
          steps: [mock.readModule, mock.foundTests],
          status: AgentRunStatus.complete,
          duration: Duration(seconds: 3),
        ),
        call: mock.deniedCall,
        answer: "Understood, I won't run anything.",
      ),
    );

    expect(find.text('Thought for 3s · 2 steps'), findsOneWidget);
    expect(
      find.textContaining('Denied · terminal.run', findRichText: true),
      findsOneWidget,
    );
    expect(find.byType(RemixDisclosure), findsOneWidget);
    expect(find.text("Understood, I won't run anything."), findsOneWidget);
  });
}
