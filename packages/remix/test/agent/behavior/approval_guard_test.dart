import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

void main() {
  // Ported from registry_source/test/agent/components/behavior_test.dart
  // ("permission latch prevents duplicate decisions and resets").
  test('takes one decision and re-arms for a new request', () {
    final guard = AgentApprovalGuard(
      id: 'call-1',
      status: AgentToolCallStatus.awaitingApproval,
    );
    var decisions = 0;
    void press(AgentApprovalDecision decision) {
      if (guard.decide(decision)) decisions++;
    }

    press(AgentApprovalDecision.deny);
    press(AgentApprovalDecision.deny);
    expect(decisions, 1);

    guard.update(id: 'call-2', status: AgentToolCallStatus.awaitingApproval);
    press(AgentApprovalDecision.deny);
    expect(decisions, 2);
  });

  test('a second, different decision is refused too', () {
    final guard = AgentApprovalGuard(
      id: 'call-1',
      status: AgentToolCallStatus.awaitingApproval,
    );
    expect(guard.decide(AgentApprovalDecision.allowOnce), isTrue);
    expect(guard.decide(AgentApprovalDecision.deny), isFalse);
    expect(guard.decision, AgentApprovalDecision.allowOnce);
    expect(guard.canDecide, isFalse);
  });

  test('only a call that awaits approval can be decided', () {
    for (final status in AgentToolCallStatus.values) {
      final guard = AgentApprovalGuard(id: 'call', status: status);
      expect(
        guard.decide(AgentApprovalDecision.allowOnce),
        status == AgentToolCallStatus.awaitingApproval,
        reason: status.name,
      );
    }
  });

  test('the same call returning to approval re-arms the guard', () {
    final guard = AgentApprovalGuard(
      id: 'call-1',
      status: AgentToolCallStatus.awaitingApproval,
    )..decide(AgentApprovalDecision.allowOnce);

    // The host has not recorded the decision yet: still the same request.
    guard.update(id: 'call-1', status: AgentToolCallStatus.awaitingApproval);
    expect(guard.canDecide, isFalse);

    guard.update(id: 'call-1', status: AgentToolCallStatus.running);
    expect(guard.decision, AgentApprovalDecision.allowOnce);
    guard.update(id: 'call-1', status: AgentToolCallStatus.awaitingApproval);
    expect(guard.decision, isNull);
    expect(guard.decide(AgentApprovalDecision.alwaysAllow), isTrue);
  });

  test('a new id that does not await approval keeps the guard closed', () {
    final guard = AgentApprovalGuard(
      id: 'call-1',
      status: AgentToolCallStatus.awaitingApproval,
    )..decide(AgentApprovalDecision.deny);
    guard.update(id: 'call-2', status: AgentToolCallStatus.running);
    expect(guard.id, 'call-2');
    expect(guard.status, AgentToolCallStatus.running);
    expect(guard.canDecide, isFalse);
  });

  test('rearm lets the reader decide again after a failed request', () {
    final guard = AgentApprovalGuard(
      id: 'call-1',
      status: AgentToolCallStatus.awaitingApproval,
    )..decide(AgentApprovalDecision.allowOnce);
    expect(guard.canDecide, isFalse);

    guard.rearm();
    expect(guard.decision, isNull);
    expect(guard.decide(AgentApprovalDecision.deny), isTrue);
  });

  test('a host clearing its recorded decision re-arms the guard', () {
    final guard = AgentApprovalGuard(
      id: 'call-1',
      status: AgentToolCallStatus.awaitingApproval,
    )..decide(AgentApprovalDecision.allowOnce);

    guard.update(
      id: 'call-1',
      status: AgentToolCallStatus.awaitingApproval,
      recorded: AgentApprovalDecision.allowOnce,
    );
    expect(guard.canDecide, isFalse);

    // The request failed: the host takes the decision back.
    guard.update(id: 'call-1', status: AgentToolCallStatus.awaitingApproval);
    expect(guard.canDecide, isTrue);
  });
}
