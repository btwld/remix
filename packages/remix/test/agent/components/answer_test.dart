import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/glyphs.dart';
import '../helpers/mock.dart';
import '../helpers/pump.dart';

const _copy = ValueKey('agent-answer-copy');
const _positive = ValueKey('agent-answer-positive');
const _negative = ValueKey('agent-answer-negative');
const _retry = ValueKey('agent-answer-retry');

const _body = Text('The cart flow is ready.');

class _Log {
  int copies = 0;
  int retries = 0;
  final verdicts = <AgentAnswerFeedback?>[];
}

/// Hosts an answer whose status and feedback the test changes.
Future<(ValueNotifier<AgentAnswerStatus>, _Log)> _pump(
  WidgetTester tester, {
  AgentAnswerStatus status = AgentAnswerStatus.complete,
  AgentAnswerFeedback? feedback,
  Widget? sources,
}) async {
  final notifier = ValueNotifier(status);
  addTearDown(notifier.dispose);
  final log = _Log();
  await pumpAgent(
    tester,
    SizedBox(
      width: 600,
      child: ValueListenableBuilder<AgentAnswerStatus>(
        valueListenable: notifier,
        builder: (context, status, _) => AgentAnswer(
          status: status,
          sources: sources,
          onCopy: () => log.copies++,
          feedback: feedback,
          onFeedback: log.verdicts.add,
          onRetry: () => log.retries++,
          glyphBuilder: testGlyphs,
          child: _body,
        ),
      ),
    ),
  );
  return (notifier, log);
}

void main() {
  testWidgets('a finished answer shows its body, sources and actions', (
    tester,
  ) async {
    await _pump(tester, sources: const AgentSources(sources: sources));

    expect(find.text('The cart flow is ready.'), findsOneWidget);
    expect(find.text('2 files referenced'), findsOneWidget);
    final order = [
      _copy,
      _positive,
      _negative,
      _retry,
    ].map((key) => tester.getCenter(find.byKey(key)).dx).toList();
    expect(order, [...order]..sort());
    expect(
      tester.getRect(find.text('2 files referenced')).bottom,
      lessThanOrEqualTo(tester.getRect(find.byKey(_copy)).top),
    );
    expect(findGlyph(AgentGlyph.copy), findsOneWidget);
    expect(findGlyph(AgentGlyph.positive), findsOneWidget);
    expect(findGlyph(AgentGlyph.negative), findsOneWidget);
    expect(findGlyph(AgentGlyph.retry), findsOneWidget);
  });

  testWidgets('a streaming answer has no actions and is no live region', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    await _pump(tester, status: AgentAnswerStatus.streaming);

    expect(find.byKey(_copy), findsNothing);
    expect(find.byKey(_retry), findsNothing);
    final answer = tester.getSemantics(find.bySemanticsLabel('Answer'));
    expect(answer, isNot(isSemantics(isLiveRegion: true)));
    expect(
      tester.getSemantics(find.text('The cart flow is ready.')),
      isNot(isSemantics(isLiveRegion: true)),
    );
    semantics.dispose();
  });

  testWidgets('copying shows "Copied" as a status message for a while', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final (_, log) = await _pump(tester);

    await tester.tap(find.byKey(_copy));
    await tester.pump();
    expect(log.copies, 1);
    expect(find.text('Copied'), findsOneWidget);
    expect(
      tester.getSemantics(find.text('Copied')),
      isSemantics(isLiveRegion: true),
    );
    expect(findGlyph(AgentGlyph.copied), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    expect(find.text('Copied'), findsNothing);
    expect(findGlyph(AgentGlyph.copy), findsOneWidget);
    semantics.dispose();
  });

  testWidgets('thumbs report a verdict and take it back', (tester) async {
    final (_, log) = await _pump(tester);
    await tester.tap(find.byKey(_positive));
    await tester.tap(find.byKey(_negative));
    expect(log.verdicts, [
      AgentAnswerFeedback.positive,
      AgentAnswerFeedback.negative,
    ]);
  });

  testWidgets('the chosen verdict reads as toggled and clears on press', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    final (_, log) = await _pump(
      tester,
      feedback: AgentAnswerFeedback.positive,
    );

    expect(
      tester.getSemantics(find.byKey(_positive)),
      isSemantics(label: 'Good response', isToggled: true),
    );
    expect(
      tester.getSemantics(find.byKey(_negative)),
      isSemantics(label: 'Bad response', isToggled: false),
    );
    await tester.tap(find.byKey(_positive));
    expect(log.verdicts, [null]);
    semantics.dispose();
  });

  testWidgets('retry asks again', (tester) async {
    final (_, log) = await _pump(tester);
    await tester.tap(find.byKey(_retry));
    expect(log.retries, 1);
  });

  testWidgets('a new streaming run collapses the sources again', (
    tester,
  ) async {
    final (status, _) = await _pump(
      tester,
      sources: const AgentSources(sources: sources),
    );
    await tester.tap(find.text('2 files referenced'));
    await tester.pumpAndSettle();
    expect(find.text('cart_totals_test.dart'), findsOneWidget);

    status.value = AgentAnswerStatus.streaming;
    await tester.pumpAndSettle();
    expect(find.text('cart_totals_test.dart'), findsNothing);
  });

  testWidgets('an answer without callbacks shows no actions', (tester) async {
    await pumpAgent(tester, const AgentAnswer(child: _body));

    expect(find.byType(RemixIconButton), findsNothing);
  });
}
