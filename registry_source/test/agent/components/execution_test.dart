import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:registry_source/agent.dart';

import '../helpers/pump.dart';

void main() {
  testWidgets('tool identifier is rendered with the execution title', (
    tester,
  ) async {
    await pumpAgent(
      tester,
      const AgentExecution(
        tool: 'terminal.run',
        title: 'Focused tests',
        child: Text('output'),
      ),
    );

    expect(find.text('terminal.run'), findsOneWidget);
    expect(find.text('Focused tests'), findsOneWidget);
  });

  testWidgets('a failure keeps its output open; a success collapses it', (
    tester,
  ) async {
    Widget execution(AgentExecutionStatus status) => AgentExecution(
      tool: 'tool',
      title: 'Run',
      status: status,
      child: const Text('output'),
    );

    for (final (outcome, open) in [
      (AgentExecutionStatus.error, true),
      (AgentExecutionStatus.success, false),
    ]) {
      await pumpAgent(tester, const SizedBox());
      await pumpAgent(tester, execution(AgentExecutionStatus.running));
      expect(find.text('output'), findsOneWidget);
      await pumpAgent(tester, execution(outcome));
      await tester.pumpAndSettle();
      expect(
        find.text('output').hitTestable(),
        open ? findsOneWidget : findsNothing,
        reason: '$outcome',
      );
    }
  });

  testWidgets('copy and retry actions appear only after settlement', (
    tester,
  ) async {
    Widget execution(AgentExecutionStatus status) => AgentExecution(
      tool: 'tool',
      title: 'Run',
      status: status,
      collapseOnComplete: false,
      onCopy: () {},
      onRetry: () {},
      child: const Text('output'),
    );

    await pumpAgent(tester, execution(AgentExecutionStatus.running));
    expect(find.bySemanticsLabel('Copy output'), findsNothing);
    expect(find.bySemanticsLabel('Retry execution'), findsNothing);

    await pumpAgent(tester, execution(AgentExecutionStatus.error));
    expect(find.bySemanticsLabel('Copy output'), findsOneWidget);
    expect(find.bySemanticsLabel('Retry execution'), findsOneWidget);
  });

  testWidgets('execution status and indicator builders are replaceable', (
    tester,
  ) async {
    await pumpAgent(
      tester,
      AgentExecution(
        tool: 'tool',
        title: 'Run',
        statusBuilder: (context, status) =>
            const SizedBox(key: ValueKey('custom-execution-status')),
        indicatorBuilder: (context, expanded) =>
            const SizedBox(key: ValueKey('custom-execution-indicator')),
        child: const Text('output'),
      ),
    );

    expect(
      find.byKey(const ValueKey('custom-execution-status')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('custom-execution-indicator')),
      findsOneWidget,
    );
  });

  testWidgets(
    'a focused execution card leaves transcript scroll keys working',
    (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);

      await pumpAgent(
        tester,
        SizedBox(
          width: 400,
          height: 200,
          child: AgentTranscript(
            followOutput: false,
            controller: controller,
            children: const [
              AgentExecution(
                tool: 'tool',
                title: 'Run',
                child: Focus(
                  autofocus: true,
                  child: SizedBox(width: 80, height: 80),
                ),
              ),
              SizedBox(height: 400),
            ],
          ),
        ),
      );
      await tester.pump();

      expect(controller.position.maxScrollExtent, greaterThan(0));
      expect(controller.offset, 0);

      // The card used to wrap its output in a second AgentTranscript, whose
      // action consumed this intent against a zero scroll extent instead of
      // letting the host transcript scroll.
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();

      expect(controller.offset, greaterThan(0));
    },
  );

  testWidgets('execution announces its status once', (tester) async {
    // Disposed inline, not in a tearDown: the framework verifies outstanding
    // handles at the end of the test body, before tearDowns run.
    final handle = tester.ensureSemantics();

    await pumpAgent(
      tester,
      const AgentExecution(
        tool: 'tool',
        title: 'Run',
        status: AgentExecutionStatus.running,
        child: Text('output'),
      ),
    );

    final values = <String>[];
    void collect(SemanticsNode node) {
      if (node.value.isNotEmpty) values.add(node.value);
      node.visitChildren((child) {
        collect(child);

        return true;
      });
    }

    collect(tester.getSemantics(find.byType(AgentExecution)));

    // The positive assertion keeps the negative one honest: if the walk stopped
    // seeing values, this would fail rather than pass vacuously.
    expect(values.where((value) => value.contains('Running')), hasLength(1));
    // The nested transcript also carried `busy`, so a running card reported its
    // state twice -- once as this value, once as a nested 'Busy'.
    expect(values.where((value) => value.contains('Busy')), isEmpty);

    handle.dispose();
  });

  testWidgets('long output scrolls inside a bounded viewport and follows', (
    tester,
  ) async {
    final key = GlobalKey<_StreamingExecutionState>();
    await pumpAgent(
      tester,
      SizedBox(width: 400, child: _StreamingExecution(key: key)),
    );
    await tester.pump();

    final card = tester.getRect(find.byType(AgentExecution));
    final output = find.descendant(
      of: find.byType(AgentExecution),
      matching: find.byType(SingleChildScrollView),
    );
    expect(tester.getSize(output).height, 100);
    expect(card.height, lessThan(200));

    key.currentState!.append(20);
    await tester.pump();
    expect(tester.getRect(find.byType(AgentExecution)), card);
    expect(
      tester.getRect(find.text('line 39', findRichText: true)).bottom,
      lessThanOrEqualTo(tester.getRect(output).bottom + 0.5),
      reason: 'A running tool keeps its newest line in view.',
    );
  });
}

class _StreamingExecution extends StatefulWidget {
  const _StreamingExecution({super.key});

  @override
  State<_StreamingExecution> createState() => _StreamingExecutionState();
}

class _StreamingExecutionState extends State<_StreamingExecution> {
  var lines = 20;

  void append(int count) => setState(() => lines += count);

  @override
  Widget build(BuildContext context) => AgentExecution(
    tool: 'flutter test',
    title: 'Run tests',
    style: AgentExecutionStyler(viewport: BoxStyler().maxHeight(100)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var line = 0; line < lines; line++)
          SizedBox(height: 20, child: Text('line $line')),
      ],
    ),
  );
}
