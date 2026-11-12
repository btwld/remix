import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

void main() {
  test('the barrel exports the models and the behavior', () {
    const parts = <AgentMessagePart>[
      AgentTextPart('text'),
      AgentStepsPart(steps: [], status: AgentRunStatus.working),
      AgentToolCallPart(id: 'id', name: 'tool'),
      AgentSourcesPart([AgentSource(id: 'id', title: 'title')]),
      AgentDataPart(name: 'name'),
    ];
    expect(parts, hasLength(5));
    expect(const AgentPlanItem(id: 'id', title: 'title').status, isNotNull);
    expect(const AgentActivityItem(id: 'id', title: 'title').status, isNotNull);
    expect(AgentRole.values, hasLength(2));
    expect(const AgentDisclosurePolicy(), isA<AgentDisclosurePolicy>());

    final disposables = <ChangeNotifier>[
      AgentLiveEdgeController(),
      AgentDisclosureController(),
      AgentComposerController(),
      AgentRunClock(),
    ];
    for (final notifier in disposables) {
      notifier.dispose();
    }
    expect(
      AgentApprovalGuard(id: 'id', status: AgentToolCallStatus.running),
      isA<AgentApprovalGuard>(),
    );
    expect(AgentAnnouncer(), isA<AgentAnnouncer>());
    expect(
      AgentLiveEdgeScrollPhysics(liveEdge: AgentLiveEdgeController()),
      isA<ScrollPhysics>(),
    );
    expect(
      AgentLiveEdge(
        controller: AgentLiveEdgeController(),
        builder: (context, scrollController, physics) =>
            const SizedBox.shrink(),
      ),
      isA<StatefulWidget>(),
    );
  });
}
