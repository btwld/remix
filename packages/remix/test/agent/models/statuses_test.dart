import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

void main() {
  // Ported from registry_source/test/agent/behavior/statuses_test.dart.
  group('carried-over statuses', () {
    test('permission machine is not a boolean', () {
      expect(AgentPermissionStatus.values, hasLength(7));
      for (final status in AgentPermissionStatus.values) {
        expect(
          status.isWorking ^ status.isSettled,
          isTrue,
          reason: status.name,
        );
      }
      expect(AgentPermissionStatus.allowed.isWorking, isTrue);
      expect(AgentPermissionStatus.allowed.isSettled, isFalse);
      expect(AgentPermissionStatus.pending.isWorking, isTrue);
      expect(AgentPermissionStatus.pending.keepsDetailsOpen, isFalse);
      expect(AgentPermissionStatus.deciding.keepsDetailsOpen, isTrue);
      expect(AgentPermissionStatus.running.keepsDetailsOpen, isTrue);
      expect(AgentPermissionStatus.denied.isSettled, isTrue);
    });

    test('execution and answer expose working vs actions', () {
      expect(AgentExecutionStatus.running.isWorking, isTrue);
      expect(AgentExecutionStatus.success.isSettled, isTrue);
      expect(AgentAnswerStatus.streaming.showsActions, isFalse);
      expect(AgentAnswerStatus.complete.showsActions, isTrue);
      expect(AgentAnswerStatus.error.showsActions, isTrue);
    });

    test('plan items report active and done', () {
      expect(AgentPlanItemStatus.inProgress.isActive, isTrue);
      expect(AgentPlanItemStatus.completed.isDone, isTrue);
      expect(AgentPlanItemStatus.cancelled.isDone, isTrue);
      expect(AgentPlanItemStatus.pending.isDone, isFalse);
    });
  });

  group('work phases', () {
    test('a finished phase is settled or failed', () {
      expect(AgentWorkPhase.values.where((phase) => phase.isFinished), [
        AgentWorkPhase.settled,
        AgentWorkPhase.failed,
      ]);
    });

    test('run, permission and execution statuses map to one phase each', () {
      expect(AgentRunStatus.values.map((status) => status.phase), [
        AgentWorkPhase.working,
        AgentWorkPhase.waiting,
        AgentWorkPhase.settled,
      ]);
      expect(AgentPermissionStatus.values.map((status) => status.phase), [
        AgentWorkPhase.waiting,
        AgentWorkPhase.working,
        AgentWorkPhase.working,
        AgentWorkPhase.working,
        AgentWorkPhase.settled,
        AgentWorkPhase.settled,
        AgentWorkPhase.failed,
      ]);
      expect(AgentExecutionStatus.values.map((status) => status.phase), [
        AgentWorkPhase.working,
        AgentWorkPhase.settled,
        AgentWorkPhase.failed,
        AgentWorkPhase.settled,
      ]);
    });
  });
}
