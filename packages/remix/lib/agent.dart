/// Agent chat surfaces for Remix.
///
/// **Experimental.** This library is outside Remix's stability promise: its
/// API may change in any release, including minor and patch releases, until
/// it is declared stable. `package:remix/remix.dart` does not export it.
///
/// It owns the structure and the behavior of an agent conversation; presets
/// supply the look as registry recipes. Import it beside
/// `package:remix/remix.dart`, which provides the base widgets and stylers.
///
/// ## Public API names
///
/// Models:
///
/// * [AgentMessagePart], the sealed message content that follows the AI SDK's
///   `parts`: [AgentTextPart], [AgentStepsPart], [AgentToolCallPart],
///   [AgentSourcesPart] and [AgentDataPart].
/// * [AgentToolCallStatus], [AgentApprovalDecision] and [AgentToolInput] for a
///   tool call; [AgentStep] and [AgentStepStatus] for steps; [AgentSource].
/// * [AgentWorkPhase], the lifecycle position every policy reads.
/// * The statuses and items of the current registry surfaces, carried over:
///   [AgentRunStatus], [AgentAnswerStatus], [AgentPermissionStatus],
///   [AgentExecutionStatus], [AgentPlanItem], [AgentActivityItem] and
///   [AgentRole].
///
/// Behavior: [AgentLiveEdgeController], [AgentLiveEdgeScrollPhysics] and
/// [AgentLiveEdge]; [AgentDisclosurePolicy] and [AgentDisclosureController];
/// [AgentComposerController]; [AgentApprovalGuard]; [AgentRunClock];
/// [AgentAnnouncer] and [AgentAnnouncement].
///
/// Widgets, each with a spec and a styler: `AgentConversation`,
/// `AgentMessage`, `AgentSteps`, `AgentToolCall` (the row and the approval
/// card), `AgentAnswer`, `AgentSources`, `AgentSuggestions`, `AgentComposer`,
/// `AgentMarkdown` and `AgentCodeBlock`. The embed and highlighting hooks are
/// `AgentToolRenderers`, `AgentFenceBuilder` and `AgentCodeHighlighter`.
///
/// A tool call's data is [AgentToolCallPart], so `AgentToolCall` names its
/// widget alone.
library;

export 'src/agent/behavior/announcer.dart';
export 'src/agent/behavior/approval_guard.dart';
export 'src/agent/behavior/composer.dart';
export 'src/agent/behavior/disclosure.dart';
export 'src/agent/behavior/live_edge.dart';
export 'src/agent/behavior/run_clock.dart';
export 'src/agent/components/conversation.dart';
export 'src/agent/components/glyphs.dart' hide agentGlyph;
export 'src/agent/components/message.dart';
export 'src/agent/components/steps.dart';
export 'src/agent/models/activity_item.dart';
export 'src/agent/models/message_part.dart';
export 'src/agent/models/plan_item.dart';
export 'src/agent/models/source.dart';
export 'src/agent/models/statuses.dart';
export 'src/agent/models/step.dart';
export 'src/agent/models/tool_call.dart';
