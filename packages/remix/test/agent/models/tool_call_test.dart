import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

void main() {
  group('AgentToolCallStatus', () {
    test('every status is exactly one of working, deciding and settled', () {
      for (final status in AgentToolCallStatus.values) {
        final roles = [
          status.isWorking,
          status.needsDecision,
          status.isSettled,
        ].where((role) => role);
        expect(roles, hasLength(1), reason: status.name);
      }
    });

    test('the lifecycle reads as one row that changes in place', () {
      expect(
        AgentToolCallStatus.values.map((status) => status.phase).toList(),
        [
          AgentWorkPhase.working, // inputStreaming
          AgentWorkPhase.waiting, // awaitingApproval
          AgentWorkPhase.settled, // denied
          AgentWorkPhase.working, // running
          AgentWorkPhase.settled, // succeeded
          AgentWorkPhase.failed, // failed
          AgentWorkPhase.settled, // cancelled
        ],
      );
      expect(AgentToolCallStatus.awaitingApproval.needsDecision, isTrue);
      expect(AgentToolCallStatus.inputStreaming.isWorking, isTrue);
      expect(AgentToolCallStatus.running.isWorking, isTrue);
    });
  });

  test('only deny refuses the call', () {
    expect(AgentApprovalDecision.values.where((decision) => !decision.allows), [
      AgentApprovalDecision.deny,
    ]);
  });

  group('AgentToolCallPart', () {
    const call = AgentToolCallPart(
      id: 'call-1',
      name: 'terminal.run',
      summary: 'Run the cart tests',
      input: [(label: 'Command', value: 'flutter test test/cart')],
      status: AgentToolCallStatus.awaitingApproval,
    );

    test('starts streaming its input with nothing recorded', () {
      const fresh = AgentToolCallPart(id: 'call-2', name: 'fs.read');
      expect(fresh.status, AgentToolCallStatus.inputStreaming);
      expect(fresh.input, isEmpty);
      expect(fresh.decision, isNull);
      expect(fresh.output, isNull);
    });

    test('changes in place and records the decision', () {
      final allowed = call.copyWith(
        status: AgentToolCallStatus.running,
        decision: AgentApprovalDecision.allowOnce,
      );
      expect(allowed.id, call.id);
      expect(allowed.name, call.name);
      expect(allowed.summary, call.summary);
      expect(allowed.input, call.input);
      expect(allowed.status, AgentToolCallStatus.running);
      expect(allowed.decision, AgentApprovalDecision.allowOnce);

      final failed = allowed.copyWith(
        status: AgentToolCallStatus.failed,
        output: r'$ flutter test test/cart',
        error: '1 test failed',
        duration: const Duration(milliseconds: 3100),
      );
      expect(failed.decision, AgentApprovalDecision.allowOnce);
      expect(failed.error, '1 test failed');
      expect(failed.duration, const Duration(milliseconds: 3100));
    });

    test('compares every field, including the input values', () {
      const same = AgentToolCallPart(
        id: 'call-1',
        name: 'terminal.run',
        summary: 'Run the cart tests',
        input: [(label: 'Command', value: 'flutter test test/cart')],
        status: AgentToolCallStatus.awaitingApproval,
      );
      expect(same, call);
      expect(same.hashCode, call.hashCode);
      for (final other in [
        call.copyWith(status: AgentToolCallStatus.running),
        call.copyWith(input: [(label: 'Command', value: 'flutter test')]),
        call.copyWith(decision: AgentApprovalDecision.deny),
        call.copyWith(result: const {'passed': 31}),
        call.copyWith(detail: '31 tests'),
        call.copyWith(description: 'Runs the suite'),
      ]) {
        expect(other, isNot(call));
      }
    });
  });

  test('a failed call retries with its stale fields cleared', () {
    const failed = AgentToolCallPart(
      id: 'call-1',
      name: 'terminal.run',
      status: AgentToolCallStatus.failed,
      output: 'partial',
      error: 'exit 1',
      decision: AgentApprovalDecision.allowOnce,
      detail: '3 tests',
      duration: Duration(seconds: 2),
    );

    // Without a flag, null keeps the value.
    expect(failed.copyWith(error: null).error, 'exit 1');

    final retry = failed.copyWith(
      status: AgentToolCallStatus.running,
      clearError: true,
      clearOutput: true,
      clearDecision: true,
      clearDetail: true,
      clearDuration: true,
    );
    expect(retry.status, AgentToolCallStatus.running);
    expect(retry.error, isNull);
    expect(retry.output, isNull);
    expect(retry.decision, isNull);
    expect(retry.detail, isNull);
    expect(retry.duration, isNull);
    expect(retry.id, 'call-1');
  });

  test('a step clears its detail', () {
    const step = AgentStep(id: 's', title: 'Read', detail: '2s');
    expect(step.copyWith(detail: null).detail, '2s');
    expect(step.copyWith(clearDetail: true).detail, isNull);
  });
}
