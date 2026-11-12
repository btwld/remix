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

  test('the barrel exports the widgets with their specs and stylers', () {
    final composer = AgentComposerController();
    addTearDown(composer.dispose);
    const call = AgentToolCallPart(id: 'id', name: 'tool');
    final widgets = <Widget>[
      AgentConversation(
        style: AgentConversationStyler(turnSpacing: 48, blockSpacing: 24),
        children: const [AgentTurn(children: [])],
      ),
      AgentConversation.builder(
        itemCount: 0,
        itemBuilder: (context, index) => const SizedBox.shrink(),
      ),
      AgentMessage(
        role: AgentRole.user,
        style: AgentMessageStyler().onUser(AgentMessageStyler()),
        child: const SizedBox.shrink(),
      ),
      AgentSteps(
        steps: const [],
        style: AgentStepsStyler().onStatus(
          AgentRunStatus.working,
          AgentStepsStyler(),
        ),
        stepStyle: AgentStepStyler().onStatus(
          AgentStepStatus.active,
          AgentStepStyler(),
        ),
      ),
      AgentToolCall(
        call: call,
        style: AgentToolCallStyler().onStatus(
          AgentToolCallStatus.failed,
          AgentToolCallStyler(),
        ),
      ),
      const AgentAnswer(child: SizedBox.shrink()),
      const AgentSources(sources: []),
      AgentSuggestions(
        suggestions: const [AgentSuggestion(label: 'label')],
        controller: composer,
      ),
      const AgentComposer(),
      AgentGlyphs(
        builder: (context, glyph, spec) => null,
        child: const SizedBox.shrink(),
      ),
      AgentToolRenderers(
        renderers: {'tool': (context, call) => const SizedBox.shrink()},
        child: const SizedBox.shrink(),
      ),
    ];
    expect(widgets, hasLength(11));
    expect(AgentGlyph.values, contains(AgentGlyph.toolFailed));
    expect(AgentAnswerFeedback.values, hasLength(2));

    const specs = <Object>[
      AgentConversationSpec(),
      AgentMessageSpec(),
      AgentStepsSpec(),
      AgentStepSpec(),
      AgentToolCallSpec(),
      AgentAnswerSpec(),
      AgentSourcesSpec(),
      AgentSuggestionsSpec(),
      AgentComposerSpec(),
    ];
    expect(specs, hasLength(9));
  });
}
