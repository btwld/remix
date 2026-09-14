import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:remix/remix.dart';

import 'ui/ui.dart';

import 'host.dart';
import 'motion.dart';

/// Application-owned catalog controls; Agent surfaces use installed recipes.
final class _AgentDemoStyles {
  _AgentDemoStyles(this.theme, {required this.narrow, required this.feedback});

  final AnimationConfig? feedback;

  final bool narrow;

  final HostTheme theme;

  Color get ink => theme.ink;
  Color get paper => theme.surface;
  Color get line => theme.hairline;

  CardStyler get card => CardStyler()
      .color(paper)
      .border(.all(.color(line).width(1)))
      .borderRadius(.circular(12))
      .padding(.all(16));

  ButtonStyler get button => uiButtonStyle(
    style: ButtonStyler(
      animation: feedback,
    ).minHeight(48).padding(.horizontal(12)),
  );

  ButtonStyler get quietButton => uiButtonStyle(
    variant: .outline,
    style: ButtonStyler(
      animation: feedback,
    ).minHeight(48).padding(.horizontal(12)),
  );

  ButtonStyler get ghostButton => uiButtonStyle(
    variant: .ghost,
    style: ButtonStyler(
      animation: feedback,
    ).minHeight(48).padding(.horizontal(12)),
  );

  ButtonStyler decision(ButtonStyler style) =>
      narrow ? style.width(double.infinity) : style;
}

_AgentDemoStyles _styles(BuildContext context) => _AgentDemoStyles(
  HostTheme.of(context),
  narrow: MediaQuery.sizeOf(context).width < 600,
  feedback: catalogMotion(context, quick: true),
);

class CatalogAction extends StatelessWidget {
  const CatalogAction({
    super.key,
    required this.label,
    this.onPressed,
    this.quiet = true,
  });
  final String label;
  final VoidCallback? onPressed;
  final bool quiet;

  @override
  Widget build(BuildContext context) {
    final styles = _styles(context);
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Align(
        alignment: AlignmentDirectional.centerEnd,
        child: RemixButton(
          label: label,
          onPressed: onPressed,
          enabled: onPressed != null,
          style: quiet ? styles.quietButton : styles.button,
        ),
      ),
    );
  }
}

/// The catalog's composer, styled by the installed recipes.
///
/// Both call sites go through here so the standalone demo and the composed run
/// cannot drift apart.
Widget _installedComposer(
  BuildContext context, {
  required ValueChanged<String> onSubmit,
  bool running = false,
  VoidCallback? onStop,
}) {
  final feedback = catalogMotion(context, quick: true);
  final recipe = uiAgentComposerRecipe(
    // The send control already owns a 48px row of its own under the field.
    // A two-line floor on top of that made an empty composer the tallest
    // thing in the catalog.
    fieldStyle: TextFieldStyler().minHeight(44),
    submitStyle: IconButtonStyler(animation: feedback),
    stopStyle: IconButtonStyler(animation: feedback),
  );

  return UiComposer(
    style: recipe.style,
    surfaceStyle: recipe.surfaceStyle,
    fieldStyle: recipe.fieldStyle,
    submitStyle: recipe.submitStyle,
    stopStyle: recipe.stopStyle,
    minLines: 1,
    running: running,
    onSubmit: onSubmit,
    onStop: onStop,
  );
}

class ComposerDemo extends StatefulWidget {
  const ComposerDemo({super.key});
  @override
  State<ComposerDemo> createState() => _ComposerDemoState();
}

class _ComposerDemoState extends State<ComposerDemo> {
  var running = false;
  String? sent;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _installedComposer(
          context,
          running: running,
          onSubmit: (value) => setState(() {
            sent = value;
            running = true;
          }),
          onStop: () => setState(() => running = false),
        ),
        if (sent != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('Last sent: $sent', style: HostTheme.of(context).meta),
          ),
      ],
    );
  }
}

class MessageDemo extends StatelessWidget {
  const MessageDemo({super.key});
  @override
  Widget build(BuildContext context) {
    final recipe = uiAgentMessageRecipe();
    return UiMessageGroup(
      spacing: 16,
      children: [
        UiMessage(
          role: UiRole.user,
          style: recipe.style,
          surfaceStyle: recipe.surfaceStyle,
          header: Text('You', style: HostTheme.of(context).meta),
          child: const Text('Review the checkout flow and pause before tests.'),
        ),
        UiMessage(
          role: UiRole.assistant,
          style: recipe.style,
          surfaceStyle: recipe.surfaceStyle,
          header: Text('Agent', style: HostTheme.of(context).meta),
          child: UiMessageCollapsible(
            style: recipe.collapsibleStyle,
            toggleStyle: recipe.toggleStyle,
            child: const Text(
              'I will inspect the checkout flow, map the payment path, verify the shared cart model, and pause before running focused checks. '
              'This longer message demonstrates explicit opt-in clipping: the host asks for it, the collapsed height is the host\'s number, '
              'and everything past that height stays clipped until someone expands the row. Long enough to clip at the catalog\'s own width, '
              'not only on a phone.',
            ),
          ),
        ),
      ],
    );
  }
}

class TranscriptDemo extends StatefulWidget {
  const TranscriptDemo({super.key});
  @override
  State<TranscriptDemo> createState() => _TranscriptDemoState();
}

class _TranscriptDemoState extends State<TranscriptDemo> {
  final _scroll = ScrollController();
  var lines = 10;

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  var following = true;
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      RemixCard(
        style: _styles(context).card,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              following ? 'Following the live edge' : 'Reading history',
              style: HostTheme.of(context).meta,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 180,
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(
                  context,
                ).copyWith(scrollbars: false),
                child: RawScrollbar(
                  controller: _scroll,
                  thumbVisibility: true,
                  thumbColor: HostTheme.of(context).ink.withValues(alpha: 0.45),
                  child: UiTranscript.builder(
                    controller: _scroll,
                    style: uiAgentTranscriptRecipe().style,
                    itemCount: lines,
                    itemBuilder: (_, i) =>
                        Text('Line ${i + 1} of the growing log.'),
                    onFollowChanged: (value) =>
                        setState(() => following = value),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      CatalogAction(
        label: 'Append lines',
        onPressed: () => setState(() => lines += 4),
      ),
    ],
  );
}

class PermissionDemo extends StatefulWidget {
  const PermissionDemo({super.key});
  @override
  State<PermissionDemo> createState() => _PermissionDemoState();
}

class _PermissionDemoState extends State<PermissionDemo> {
  var status = UiPermissionStatus.pending;
  var request = 0;
  @override
  Widget build(BuildContext context) {
    final styles = _styles(context);
    final recipe = uiAgentPermissionRecipe(
      style: UiPermissionStyler(
        actions: FlexBoxStyler()
            .direction(styles.narrow ? .vertical : .horizontal)
            .crossAxisAlignment(styles.narrow ? .stretch : .center),
      ),
    );
    return Column(
      children: [
        UiPermission(
          requestId: request,
          style: recipe.style,
          indicatorBuilder: catalogChevron,
          surfaceStyle: recipe.surfaceStyle,
          detailsStyle: recipe.detailsStyle,
          parametersStyle: recipe.parametersStyle,
          allowOnceStyle: styles.decision(recipe.allowOnceStyle),
          alwaysAllowStyle: styles.decision(recipe.alwaysAllowStyle),
          denyStyle: styles.decision(recipe.denyStyle),
          tool: 'terminal.run',
          status: status,
          description:
              'Run the focused test suite. Always allow applies only '
              'to this command in this demo session.',
          parameters: const [
            RemixDataListItem(label: 'Command', value: 'flutter test'),
            RemixDataListItem(
              label: 'Directory',
              value: 'registry_source/agent',
            ),
          ],
          onAllowOnce: () =>
              setState(() => status = UiPermissionStatus.complete),
          onAlwaysAllow: () =>
              setState(() => status = UiPermissionStatus.complete),
          onDeny: () => setState(() => status = UiPermissionStatus.denied),
        ),
        CatalogAction(
          label: 'Replay',
          onPressed: () => setState(() {
            request++;
            status = UiPermissionStatus.pending;
          }),
        ),
      ],
    );
  }
}

String _executionOutput(UiExecutionStatus status) => switch (status) {
  .running => 'Running the focused test suite…',
  .success => '12 passed · 0 failed',
  .error => 'Checkout validation failed. Review the output and retry.',
  .cancelled => 'Checks stopped before completion.',
};

class ExecutionDemo extends StatefulWidget {
  const ExecutionDemo({super.key});
  @override
  State<ExecutionDemo> createState() => _ExecutionDemoState();
}

class _ExecutionDemoState extends State<ExecutionDemo> {
  var status = UiExecutionStatus.running;
  @override
  Widget build(BuildContext context) {
    final recipe = uiAgentExecutionRecipe();
    return Column(
      children: [
        UiExecution(
          style: recipe.style,
          indicatorBuilder: catalogChevron,
          surfaceStyle: recipe.surfaceStyle,
          disclosureStyle: recipe.disclosureStyle,
          copyStyle: recipe.copyStyle,
          retryStyle: recipe.retryStyle,
          tool: 'terminal.run',
          title: 'Focused checks',
          status: status,
          onCopy: () =>
              Clipboard.setData(ClipboardData(text: _executionOutput(status))),
          onRetry: () => setState(() => status = UiExecutionStatus.running),
          child: Text(_executionOutput(status)),
        ),
        // Cycles through the failure state too. It was the one status with
        // copy written for it that no control in the catalog could reach.
        CatalogAction(
          label: switch (status) {
            UiExecutionStatus.running => 'Succeed',
            UiExecutionStatus.success => 'Fail',
            _ => 'Replay',
          },
          onPressed: () => setState(
            () => status = switch (status) {
              UiExecutionStatus.running => UiExecutionStatus.success,
              UiExecutionStatus.success => UiExecutionStatus.error,
              _ => UiExecutionStatus.running,
            },
          ),
        ),
      ],
    );
  }
}

class PlanDemo extends StatefulWidget {
  const PlanDemo({super.key});
  @override
  State<PlanDemo> createState() => _PlanDemoState();
}

UiPlanItemStatus _planItemStatus(int index, int currentStep) {
  if (index < currentStep) return UiPlanItemStatus.completed;
  if (index == currentStep) return UiPlanItemStatus.inProgress;
  return UiPlanItemStatus.pending;
}

class _PlanDemoState extends State<PlanDemo> {
  var step = 0;
  @override
  Widget build(BuildContext context) {
    final recipe = uiAgentPlanRecipe();
    final items = List.generate(
      3,
      (i) => UiPlanItem(
        id: '$i',
        title: ['Read the brief', 'Map the path', 'Run checks'][i],
        status: _planItemStatus(i, step),
      ),
    );
    return Column(
      children: [
        UiPlan(
          style: recipe.style,
          disclosureStyle: recipe.disclosureStyle,
          indicatorBuilder: catalogChevron,
          items: items,
        ),
        CatalogAction(
          label: step < 3 ? 'Advance' : 'Replay',
          onPressed: () => setState(() => step = step < 3 ? step + 1 : 0),
        ),
      ],
    );
  }
}

class ActivityDemo extends StatefulWidget {
  const ActivityDemo({super.key});
  @override
  State<ActivityDemo> createState() => _ActivityDemoState();
}

class _ActivityDemoState extends State<ActivityDemo> {
  var status = UiRunStatus.working;
  @override
  Widget build(BuildContext context) {
    final recipe = uiAgentActivityRecipe();
    return Column(
      children: [
        UiActivity(
          style: recipe.style,
          disclosureStyle: recipe.disclosureStyle,
          indicatorBuilder: catalogChevron,
          status: status,
          items: [
            const UiActivityItem(
              id: 'read',
              title: 'Reading the brief',
              status: UiActivityItemStatus.complete,
            ),
            UiActivityItem(
              id: 'map',
              title: 'Mapping the path',
              status: status == UiRunStatus.working
                  ? UiActivityItemStatus.active
                  : UiActivityItemStatus.complete,
            ),
          ],
        ),
        CatalogAction(
          label: status == UiRunStatus.working ? 'Complete' : 'Replay',
          onPressed: () => setState(
            () => status = status == UiRunStatus.working
                ? UiRunStatus.complete
                : UiRunStatus.working,
          ),
        ),
      ],
    );
  }
}

class AnswerDemo extends StatefulWidget {
  const AnswerDemo({super.key});
  @override
  State<AnswerDemo> createState() => _AnswerDemoState();
}

class _AnswerDemoState extends State<AnswerDemo> {
  var status = UiAnswerStatus.streaming;
  var stream = 0;
  @override
  Widget build(BuildContext context) {
    final recipe = uiAgentAnswerRecipe();
    return Column(
      children: [
        UiAnswer(
          style: recipe.style,
          sourcesIndicatorBuilder: catalogChevron,
          surfaceStyle: recipe.surfaceStyle,
          sourcesStyle: recipe.sourcesStyle,
          copyStyle: recipe.copyStyle,
          retryStyle: recipe.retryStyle,
          streamId: stream,
          status: status,
          onCopy: () => Clipboard.setData(
            const ClipboardData(text: 'The checkout flow is ready for review.'),
          ),
          onRetry: () => setState(() {
            stream++;
            status = UiAnswerStatus.streaming;
          }),
          sourcesContent: status.isStreaming
              ? null
              : const Text('Checkout brief · payment notes'),
          child: Text(
            status.isStreaming
                ? 'Writing the answer…'
                : 'The checkout flow is ready for review.',
          ),
        ),
        CatalogAction(
          label: 'Complete',
          onPressed: status.isStreaming
              ? () => setState(() => status = UiAnswerStatus.complete)
              : null,
        ),
      ],
    );
  }
}

enum _RunStage { idle, permission, running, complete, error, denied, cancelled }

enum _RunScenario { success, permission, failure }

/// A deterministic host-owned run; no model or terminal is contacted.
class ComposedRunDemo extends StatefulWidget {
  const ComposedRunDemo({
    super.key,
    this.stepDelay = const Duration(milliseconds: 280),
  });

  final Duration stepDelay;

  @override
  State<ComposedRunDemo> createState() => _ComposedRunDemoState();
}

class _ComposedRunDemoState extends State<ComposedRunDemo> {
  static const _chunks = [
    'I inspected the checkout flow. ',
    'The shared cart state is correct. ',
    'All 12 focused checks passed.',
  ];

  final _scroll = ScrollController();
  Timer? _timer;
  var stage = _RunStage.idle;
  var scenario = _RunScenario.success;
  var request = 0;
  var prompt = '';
  var answer = '';
  var following = true;
  var alwaysAllow = false;
  var toolStarted = false;
  final history = <({String prompt, String answer})>[];

  String get visibleAnswer => answer.isNotEmpty
      ? answer
      : stage == _RunStage.denied
      ? 'Permission denied. No checks were run.'
      : !toolStarted
      ? 'Stopped before running the tool. No checks were run.'
      : 'Run stopped. Submit another message to try again.';

  @override
  void dispose() {
    _timer?.cancel();
    _scroll.dispose();
    super.dispose();
  }

  void _start(
    String value, {
    _RunScenario nextScenario = _RunScenario.success,
    bool keepMessage = false,
  }) {
    if (stage == .permission || stage == .running) return;
    _timer?.cancel();
    setState(() {
      if (!keepMessage && prompt.isNotEmpty) {
        history.add((prompt: prompt, answer: visibleAnswer));
      }
      if (!keepMessage) prompt = value;
      scenario = nextScenario;
      answer = '';
      following = true;
      toolStarted = false;
      request++;
      stage = nextScenario == .permission && !alwaysAllow
          ? _RunStage.permission
          : _RunStage.running;
    });
    if (stage == .running) _stream(request);
  }

  void _stream(int id) {
    if (!mounted || id != request) return;
    var index = 0;
    setState(() {
      toolStarted = true;
      stage = .running;
    });
    _timer = Timer.periodic(widget.stepDelay, (timer) {
      if (!mounted || id != request) {
        timer.cancel();
        return;
      }
      if (scenario == .failure && index == 1) {
        timer.cancel();
        setState(() {
          stage = .error;
          answer =
              'The simulated command failed. Retry runs the recovery path.';
        });
        return;
      }
      setState(() => answer += _chunks[index++]);
      if (index == _chunks.length) {
        timer.cancel();
        setState(() => stage = .complete);
      }
    });
  }

  void _retry() => _start(
    prompt,
    nextScenario: scenario == .failure ? .success : scenario,
    keepMessage: true,
  );

  void _reset() {
    _timer?.cancel();
    setState(() {
      request++;
      stage = .idle;
      prompt = '';
      answer = '';
      following = true;
      alwaysAllow = false;
      toolStarted = false;
      history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final styles = _styles(context);
    final messageRecipe = uiAgentMessageRecipe();
    final transcriptRecipe = uiAgentTranscriptRecipe();
    final planRecipe = uiAgentPlanRecipe();
    final activityRecipe = uiAgentActivityRecipe();
    final permissionRecipe = uiAgentPermissionRecipe(
      style: UiPermissionStyler(
        actions: FlexBoxStyler()
            .direction(styles.narrow ? .vertical : .horizontal)
            .crossAxisAlignment(styles.narrow ? .stretch : .center),
      ),
    );
    final executionRecipe = uiAgentExecutionRecipe();
    final answerRecipe = uiAgentAnswerRecipe();
    final working = stage == _RunStage.running;
    final requestId = request;
    final complete = stage == _RunStage.complete;
    final active = stage == _RunStage.permission || working;
    final stopped = stage == _RunStage.denied || stage == _RunStage.cancelled;
    final output = _executionOutput(
      complete
          ? UiExecutionStatus.success
          : stage == _RunStage.error
          ? UiExecutionStatus.error
          : stopped
          ? UiExecutionStatus.cancelled
          : UiExecutionStatus.running,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Expanded(child: Text('Interactive demo')),
            CatalogAction(label: 'New chat', onPressed: _reset),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Simulated responses and tools — no backend or credentials.',
        ),
        const SizedBox(height: 16),
        if (!active)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              RemixButton(
                style: uiButtonStyle(
                  variant: .outline,
                  style: ButtonStyler().minHeight(48),
                ),
                label: 'Successful task',
                onPressed: () => _start('Review the checkout flow.'),
              ),
              RemixButton(
                style: uiButtonStyle(
                  variant: .outline,
                  style: ButtonStyler().minHeight(48),
                ),
                label: 'Permission task',
                onPressed: () => _start(
                  'Run the focused checks.',
                  nextScenario: .permission,
                ),
              ),
              RemixButton(
                style: uiButtonStyle(
                  variant: .outline,
                  style: ButtonStyler().minHeight(48),
                ),
                label: 'Recoverable failure',
                onPressed: () => _start(
                  'Recover the failed command.',
                  nextScenario: .failure,
                ),
              ),
            ],
          ),
        if (!active) const SizedBox(height: 20),
        SizedBox(
          height:
              MediaQuery.sizeOf(context).height * (styles.narrow ? 0.34 : 0.40),
          child: UiTranscript(
            controller: _scroll,
            style: transcriptRecipe.style.viewport(
              BoxStyler().padding(.all(0)),
            ),
            followOutput: following,
            busy: active,
            onFollowChanged: (value) {
              if (following != value) setState(() => following = value);
            },
            children: [
              for (final turn in history) ...[
                UiMessage(
                  role: .user,
                  style: messageRecipe.style,
                  surfaceStyle: messageRecipe.surfaceStyle,
                  child: Text(turn.prompt),
                ),
                UiAnswer(
                  status: .complete,
                  style: answerRecipe.style,
                  surfaceStyle: answerRecipe.surfaceStyle,
                  child: Text(turn.answer),
                ),
              ],
              if (stage != _RunStage.idle)
                UiMessage(
                  key: ValueKey('message-$request'),
                  role: UiRole.user,
                  style: messageRecipe.style,
                  surfaceStyle: messageRecipe.surfaceStyle,
                  child: Text(prompt),
                ),
              if (stage != _RunStage.idle)
                UiPlan(
                  key: ValueKey('plan-$request'),
                  style: planRecipe.style,
                  indicatorBuilder: catalogChevron,
                  disclosureStyle: planRecipe.disclosureStyle,
                  items: [
                    const UiPlanItem(
                      id: 'inspect',
                      title: 'Inspect checkout',
                      status: .completed,
                    ),
                    UiPlanItem(
                      id: 'checks',
                      title: stage == _RunStage.error
                          ? 'Focused checks failed'
                          : 'Run focused checks',
                      status: complete
                          ? .completed
                          : stopped || stage == _RunStage.error
                          ? .cancelled
                          : stage == _RunStage.permission
                          ? .pending
                          : .inProgress,
                    ),
                  ],
                ),
              if (stage != _RunStage.idle)
                UiActivity(
                  key: ValueKey('activity-$request'),
                  style: activityRecipe.style,
                  indicatorBuilder: catalogChevron,
                  disclosureStyle: activityRecipe.disclosureStyle,
                  status: complete || stopped || stage == _RunStage.error
                      ? .complete
                      : .working,
                  items: [
                    const UiActivityItem(
                      id: 'read',
                      title: 'Read the checkout flow',
                      status: .complete,
                    ),
                    UiActivityItem(
                      id: 'checks',
                      title: stage == _RunStage.permission
                          ? 'Waiting for permission'
                          : stage == _RunStage.error
                          ? 'Focused checks failed'
                          : stopped
                          ? 'Checks stopped'
                          : complete
                          ? 'Finished focused checks'
                          : 'Running focused checks',
                      status: complete || stopped || stage == _RunStage.error
                          ? .complete
                          : .active,
                    ),
                  ],
                ),
              if (scenario == _RunScenario.permission &&
                  stage != _RunStage.idle &&
                  (stage != _RunStage.cancelled || toolStarted))
                UiPermission(
                  key: ValueKey('permission-$request'),
                  requestId: request,
                  style: permissionRecipe.style,
                  indicatorBuilder: catalogChevron,
                  surfaceStyle: permissionRecipe.surfaceStyle,
                  detailsStyle: permissionRecipe.detailsStyle,
                  parametersStyle: permissionRecipe.parametersStyle,
                  allowOnceStyle: styles.decision(
                    permissionRecipe.allowOnceStyle,
                  ),
                  alwaysAllowStyle: styles.decision(
                    permissionRecipe.alwaysAllowStyle,
                  ),
                  denyStyle: styles.decision(permissionRecipe.denyStyle),
                  tool: 'terminal.run',
                  description:
                      'Run the focused test suite. This demo never executes a command.',
                  status: stage == _RunStage.permission
                      ? .pending
                      : stage == _RunStage.denied
                      ? .denied
                      : stage == _RunStage.cancelled
                      ? .allowed
                      : stage == _RunStage.error
                      ? .error
                      : working
                      ? .running
                      : .complete,
                  parameters: const [
                    RemixDataListItem(label: 'Command', value: 'flutter test'),
                  ],
                  onAllowOnce: () {
                    if (requestId != request || stage != .permission) return;
                    _stream(requestId);
                  },
                  onAlwaysAllow: () {
                    if (requestId != request || stage != .permission) return;
                    alwaysAllow = true;
                    _stream(requestId);
                  },
                  onDeny: () {
                    if (requestId != request || stage != .permission) return;
                    setState(() => stage = _RunStage.denied);
                  },
                ),
              if (toolStarted &&
                  (working ||
                      complete ||
                      stage == _RunStage.error ||
                      stage == _RunStage.cancelled))
                UiExecution(
                  key: ValueKey('execution-$request'),
                  style: executionRecipe.style,
                  indicatorBuilder: catalogChevron,
                  surfaceStyle: executionRecipe.surfaceStyle,
                  disclosureStyle: executionRecipe.disclosureStyle,
                  copyStyle: executionRecipe.copyStyle,
                  retryStyle: executionRecipe.retryStyle,
                  tool: 'terminal.run',
                  title: 'Focused checks',
                  status: complete
                      ? .success
                      : working
                      ? .running
                      : stage == _RunStage.error
                      ? .error
                      : .cancelled,
                  onCopy: () => Clipboard.setData(ClipboardData(text: output)),
                  onRetry: _retry,
                  child: Text(output),
                ),
              if (answer.isNotEmpty || complete || stopped)
                UiAnswer(
                  key: ValueKey('answer-$request'),
                  style: answerRecipe.style,
                  sourcesIndicatorBuilder: catalogChevron,
                  surfaceStyle: answerRecipe.surfaceStyle,
                  sourcesStyle: answerRecipe.sourcesStyle,
                  copyStyle: answerRecipe.copyStyle,
                  retryStyle: answerRecipe.retryStyle,
                  sourcesContent: const Text(
                    'Local simulated checkout fixture.',
                  ),
                  status: working
                      ? .streaming
                      : stage == _RunStage.error
                      ? .error
                      : .complete,
                  onCopy: () =>
                      Clipboard.setData(ClipboardData(text: visibleAnswer)),
                  onRetry: _retry,
                  child: Text(visibleAnswer),
                ),
            ].map((child) => CatalogEntrance(key: child.key, child: child)).toList(),
          ),
        ),
        if (!following)
          CatalogAction(
            label: 'Return to latest',
            onPressed: () {
              setState(() => following = true);
              if (_scroll.hasClients)
                _scroll.jumpTo(_scroll.position.maxScrollExtent);
            },
          ),
        const SizedBox(height: 16),
        _installedComposer(
          context,
          onSubmit: _start,
          running: active,
          onStop: () {
            _timer?.cancel();
            setState(() {
              request++;
              stage = _RunStage.cancelled;
            });
          },
        ),
      ],
    );
  }
}
