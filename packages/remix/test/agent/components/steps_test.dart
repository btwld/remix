import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/glyphs.dart';
import '../helpers/mock.dart';
import '../helpers/pump.dart';

const _shimmerKey = ValueKey('shimmer');

Widget _shimmer(BuildContext context, Widget child) =>
    KeyedSubtree(key: _shimmerKey, child: child);

/// Hosts steps that the test moves through a run.
Future<ValueNotifier<AgentSteps>> _pump(
  WidgetTester tester,
  AgentSteps steps, {
  bool disableAnimations = false,
}) async {
  final notifier = ValueNotifier(steps);
  addTearDown(notifier.dispose);
  await pumpAgent(
    tester,
    ValueListenableBuilder<AgentSteps>(
      valueListenable: notifier,
      builder: (context, steps, _) => steps,
    ),
    disableAnimations: disableAnimations,
  );
  return notifier;
}

AgentSteps _steps(
  AgentRunStatus status, {
  List<AgentStep> steps = const [readModule, foundTests],
  Duration? duration,
  AgentRunClock? clock,
  bool? defaultExpanded,
}) => AgentSteps(
  steps: steps,
  status: status,
  duration: duration,
  clock: clock,
  defaultExpanded: defaultExpanded,
  shimmer: _shimmer,
  glyphBuilder: testGlyphs,
);

Future<void> _move(
  WidgetTester tester,
  ValueNotifier<AgentSteps> notifier,
  AgentSteps next,
) async {
  notifier.value = next;
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('a working run reads "Thinking…" with its rail open', (
    tester,
  ) async {
    await _pump(tester, _steps(AgentRunStatus.working));

    expect(find.text('Thinking…'), findsOneWidget);
    expect(find.byKey(_shimmerKey), findsOneWidget);
    expect(findGlyph(AgentGlyph.thinking), findsOneWidget);
    expect(findGlyph(AgentGlyph.disclosureOpen), findsOneWidget);
    expect(find.text(readModule.title), findsOneWidget);
    expect(findGlyph(AgentGlyph.stepComplete), findsNWidgets(2));
  });

  testWidgets('reduced motion drops the shimmer', (tester) async {
    await _pump(
      tester,
      _steps(AgentRunStatus.working),
      disableAnimations: true,
    );

    expect(find.text('Thinking…'), findsOneWidget);
    expect(find.byKey(_shimmerKey), findsNothing);
  });

  testWidgets('a paused run waits for approval and keeps its rail', (
    tester,
  ) async {
    final notifier = await _pump(tester, _steps(AgentRunStatus.working));
    await _move(tester, notifier, _steps(AgentRunStatus.waiting));

    expect(find.text('Waiting for approval · 2 steps'), findsOneWidget);
    expect(find.byKey(_shimmerKey), findsNothing);
    expect(findGlyph(AgentGlyph.waiting), findsOneWidget);
    expect(find.text(foundTests.title), findsOneWidget);
  });

  testWidgets('a settled run reads "Thought for 6s" and collapses', (
    tester,
  ) async {
    final notifier = await _pump(tester, _steps(AgentRunStatus.working));
    await _move(
      tester,
      notifier,
      _steps(
        AgentRunStatus.complete,
        steps: const [readModule, foundTests, ranTests],
        duration: const Duration(milliseconds: 5200),
      ),
    );

    expect(find.text('Thought for 6s · 3 steps'), findsOneWidget);
    expect(findGlyph(AgentGlyph.thought), findsOneWidget);
    expect(findGlyph(AgentGlyph.disclosureClosed), findsOneWidget);
    expect(find.text(readModule.title), findsNothing);
  });

  testWidgets('a settled run without a duration reads the run clock', (
    tester,
  ) async {
    var now = Duration.zero;
    final clock = AgentRunClock(now: () => now)..start();
    addTearDown(clock.dispose);
    final notifier = await _pump(
      tester,
      _steps(AgentRunStatus.working, clock: clock),
    );

    now = const Duration(seconds: 4);
    clock.stop();
    await _move(
      tester,
      notifier,
      _steps(AgentRunStatus.complete, steps: const [readModule], clock: clock),
    );

    expect(find.text('Thought for 4s · 1 step'), findsOneWidget);
  });

  testWidgets('history starts collapsed', (tester) async {
    await _pump(
      tester,
      _steps(AgentRunStatus.complete, duration: const Duration(seconds: 3)),
    );

    expect(find.text('Thought for 3s · 2 steps'), findsOneWidget);
    expect(find.text(readModule.title), findsNothing);
  });

  testWidgets('a reader who opened the rail keeps it open as the run settles', (
    tester,
  ) async {
    final notifier = await _pump(
      tester,
      _steps(AgentRunStatus.working, defaultExpanded: false),
    );
    expect(find.text(readModule.title), findsNothing);

    await tester.tap(find.text('Thinking…'));
    await tester.pumpAndSettle();
    await _move(tester, notifier, _steps(AgentRunStatus.complete));
    expect(find.text(readModule.title), findsOneWidget);

    // The next run starts fresh: settling it collapses the rail again.
    await _move(tester, notifier, _steps(AgentRunStatus.working));
    await _move(tester, notifier, _steps(AgentRunStatus.complete));
    expect(find.text(readModule.title), findsNothing);
  });

  testWidgets('the line toggles from the keyboard', (tester) async {
    final start = FocusNode(debugLabel: 'start');
    addTearDown(start.dispose);
    await pumpAgent(
      tester,
      Column(
        children: [
          Focus(focusNode: start, child: const SizedBox(height: 1)),
          _steps(AgentRunStatus.complete, duration: const Duration(seconds: 3)),
        ],
      ),
    );

    start.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(find.text(readModule.title), findsOneWidget);
  });

  testWidgets('each step reads its title and status', (tester) async {
    final semantics = tester.ensureSemantics();
    await _pump(
      tester,
      _steps(
        AgentRunStatus.working,
        steps: [
          readModule,
          const AgentStep(
            id: 'run',
            title: 'Run the cart tests',
            status: AgentStepStatus.active,
          ),
        ],
      ),
    );

    expect(
      find.bySemanticsLabel('Read the checkout module, Done'),
      findsOneWidget,
    );
    expect(
      find.bySemanticsLabel('Run the cart tests, In progress'),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('a step resolves its style with its own status', (tester) async {
    const active = Color(0xFF202020);
    const done = Color(0xFF646464);
    await pumpAgent(
      tester,
      AgentSteps(
        steps: const [
          readModule,
          AgentStep(
            id: 'run',
            title: 'Run the cart tests',
            status: AgentStepStatus.active,
          ),
        ],
        stepStyle: AgentStepStyler(title: TextStyler().color(done)).onStatus(
          AgentStepStatus.active,
          AgentStepStyler(title: TextStyler().color(active)),
        ),
      ),
    );

    expect(tester.widget<Text>(find.text(readModule.title)).style?.color, done);
    expect(
      tester.widget<Text>(find.text('Run the cart tests')).style?.color,
      active,
    );
  });

  testWidgets('a run without steps is a line, not a control', (tester) async {
    await _pump(tester, _steps(AgentRunStatus.working, steps: const []));

    expect(find.text('Thinking…'), findsOneWidget);
    expect(find.byType(RemixDisclosure), findsNothing);
    expect(findGlyph(AgentGlyph.disclosureOpen), findsNothing);
  });

  testWidgets('a host label builder replaces the English line', (tester) async {
    await pumpAgent(
      tester,
      AgentSteps(
        steps: const [readModule],
        status: AgentRunStatus.complete,
        duration: const Duration(seconds: 2),
        labelBuilder: (status, steps, duration) =>
            '${status.name} $steps ${duration?.inSeconds}',
      ),
    );

    expect(find.text('complete 1 2'), findsOneWidget);
  });
}
