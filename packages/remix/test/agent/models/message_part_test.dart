import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

/// Names a part by its kind; the switch must stay exhaustive without a
/// default, which is what the sealed type promises.
String _kind(AgentMessagePart part) => switch (part) {
  AgentTextPart() => 'text',
  AgentStepsPart() => 'steps',
  AgentToolCallPart() => 'tool',
  AgentSourcesPart() => 'sources',
  AgentDataPart() => 'data',
};

void main() {
  const steps = [
    AgentStep(
      id: 'read',
      title: 'Read the checkout module',
      status: AgentStepStatus.complete,
    ),
    AgentStep(
      id: 'find',
      title: 'Found 4 test files for the cart',
      status: AgentStepStatus.complete,
    ),
  ];

  test('a message is the AI SDK parts: text, steps, tool, sources, data', () {
    const parts = <AgentMessagePart>[
      AgentStepsPart(
        steps: steps,
        status: AgentRunStatus.complete,
        duration: Duration(seconds: 6),
      ),
      AgentToolCallPart(id: 'call-1', name: 'terminal.run'),
      AgentTextPart('The cart flow is ready.'),
      AgentSourcesPart([AgentSource(id: 'a', title: 'cart_totals.dart')]),
      AgentDataPart(name: 'coverage', data: {'cart_state.dart': 0.96}),
    ];
    expect(parts.map(_kind), ['steps', 'tool', 'text', 'sources', 'data']);
  });

  test('text is complete unless the host says it streams', () {
    expect(const AgentTextPart('Done').status, AgentAnswerStatus.complete);
    expect(
      const AgentTextPart('Do', status: AgentAnswerStatus.streaming),
      isNot(const AgentTextPart('Do')),
    );
    expect(const AgentTextPart('Done'), const AgentTextPart('Done'));
  });

  test('steps compare their steps, run status and duration', () {
    final part = AgentStepsPart(
      steps: List.of(steps),
      status: AgentRunStatus.waiting,
    );
    final same = AgentStepsPart(
      steps: List.of(steps),
      status: AgentRunStatus.waiting,
    );
    expect(part, same);
    expect(part.hashCode, same.hashCode);
    expect(
      part,
      isNot(AgentStepsPart(steps: steps, status: AgentRunStatus.working)),
    );
    expect(
      part,
      isNot(
        AgentStepsPart(
          steps: steps,
          status: AgentRunStatus.waiting,
          duration: const Duration(seconds: 3),
        ),
      ),
    );
    expect(
      part,
      isNot(AgentStepsPart(steps: [steps.first], status: part.status)),
    );
  });

  test('a step merges plan and activity rows and updates by copy', () {
    const step = AgentStep(id: 'run', title: 'Run the tests');
    expect(step.status, AgentStepStatus.pending);
    final active = step.copyWith(status: AgentStepStatus.active);
    expect(active, isNot(step));
    expect(active.status.isActive, isTrue);
    expect(active.copyWith(detail: '2.9s').detail, '2.9s');
    expect(
      active.copyWith(status: AgentStepStatus.complete).status.isDone,
      isTrue,
    );
    expect(AgentStepStatus.cancelled.isDone, isTrue);
    expect(AgentStepStatus.pending.isDone, isFalse);
    expect(
      const AgentStep(id: 'a', title: 'A'),
      const AgentStep(id: 'a', title: 'A'),
    );
  });

  test('sources and data compare by value', () {
    final uri = Uri.file('/repo/cart_totals.dart');
    expect(
      AgentSourcesPart([AgentSource(id: 'a', title: 'cart', uri: uri)]),
      AgentSourcesPart([AgentSource(id: 'a', title: 'cart', uri: uri)]),
    );
    expect(
      const AgentSource(id: 'a', title: 'cart'),
      isNot(AgentSource(id: 'a', title: 'cart', uri: uri)),
    );
    expect(
      const AgentDataPart(name: 'coverage', id: 'c', data: 84),
      const AgentDataPart(name: 'coverage', id: 'c', data: 84),
    );
    expect(
      const AgentDataPart(name: 'coverage', data: 84),
      isNot(const AgentDataPart(name: 'chart', data: 84)),
    );
  });
}
