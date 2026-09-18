import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../agent/components/activity.dart';
import '../agent/components/answer.dart';
import '../agent/components/composer.dart';
import '../agent/components/execution.dart';
import '../agent/components/message.dart';
import '../agent/components/permission.dart';
import '../agent/components/plan.dart';
import '../agent/components/transcript.dart';
import '../agent/models/activity_item.dart';
import '../agent/models/plan_item.dart';
import '../agent/models/statuses.dart';

enum RegistryDashboardAgentButtonTone { primary, soft, outline }

typedef RegistryDashboardAgentButtonBuilder =
    Widget Function(
      String label,
      VoidCallback? onPressed,
      RegistryDashboardAgentButtonTone tone,
    );

/// Preset-owned styles consumed by the shared deterministic Agent demo.
final class RegistryDashboardAgentStyles {
  const RegistryDashboardAgentStyles({
    required this.buttonBuilder,
    required this.heading,
    required this.body,
    required this.messageStyle,
    required this.messageSurfaceStyle,
    required this.answerStyle,
    required this.answerSurfaceStyle,
    required this.answerSourcesStyle,
    required this.answerCopyStyle,
    required this.answerRetryStyle,
    required this.transcriptStyle,
    required this.planStyle,
    required this.planDisclosureStyle,
    required this.activityStyle,
    required this.activityDisclosureStyle,
    required this.permissionStyle,
    required this.permissionSurfaceStyle,
    required this.permissionDetailsStyle,
    required this.permissionParametersStyle,
    required this.permissionAllowOnceStyle,
    required this.permissionAlwaysAllowStyle,
    required this.permissionDenyStyle,
    required this.executionStyle,
    required this.executionSurfaceStyle,
    required this.executionDisclosureStyle,
    required this.executionCopyStyle,
    required this.executionRetryStyle,
    required this.composerStyle,
    required this.composerSurfaceStyle,
    required this.composerFieldStyle,
    required this.composerSubmitStyle,
    required this.composerStopStyle,
  });

  final RegistryDashboardAgentButtonBuilder buttonBuilder;
  final TextStyler heading;
  final TextStyler body;
  final AgentMessageStyler messageStyle;
  final CardStyler messageSurfaceStyle;
  final AgentAnswerStyler answerStyle;
  final CardStyler answerSurfaceStyle;
  final DisclosureStyler answerSourcesStyle;
  final IconButtonStyler answerCopyStyle;
  final IconButtonStyler answerRetryStyle;
  final AgentTranscriptStyler transcriptStyle;
  final AgentPlanStyler planStyle;
  final DisclosureStyler planDisclosureStyle;
  final AgentActivityStyler activityStyle;
  final DisclosureStyler activityDisclosureStyle;
  final AgentPermissionStyler permissionStyle;
  final CardStyler permissionSurfaceStyle;
  final DisclosureStyler permissionDetailsStyle;
  final DataListStyler permissionParametersStyle;
  final ButtonStyler permissionAllowOnceStyle;
  final ButtonStyler permissionAlwaysAllowStyle;
  final ButtonStyler permissionDenyStyle;
  final AgentExecutionStyler executionStyle;
  final CardStyler executionSurfaceStyle;
  final DisclosureStyler executionDisclosureStyle;
  final IconButtonStyler executionCopyStyle;
  final IconButtonStyler executionRetryStyle;
  final AgentComposerStyler composerStyle;
  final CardStyler composerSurfaceStyle;
  final TextFieldStyler composerFieldStyle;
  final IconButtonStyler composerSubmitStyle;
  final IconButtonStyler composerStopStyle;
}

enum _Scenario { success, permission, failure }

enum _Stage {
  idle,
  preparing,
  permission,
  running,
  complete,
  failed,
  stopped,
  denied,
}

/// Complete local-only Agent demonstration shared by both dashboard presets.
class RegistryDashboardChatPage extends StatefulWidget {
  const RegistryDashboardChatPage({
    super.key,
    required this.styles,
    this.stepDelay = const Duration(milliseconds: 320),
  });

  final RegistryDashboardAgentStyles styles;
  final Duration stepDelay;

  @override
  State<RegistryDashboardChatPage> createState() =>
      _RegistryDashboardChatPageState();
}

class _RegistryDashboardChatPageState extends State<RegistryDashboardChatPage> {
  static const _chunks = [
    'I inspected the checkout flow. ',
    'The cart state is shared correctly, ',
    'and the focused checks pass. The flow is ready for review.',
  ];

  final _scroll = ScrollController();
  final _draft = TextEditingController();
  Timer? _timer;
  var _runId = 0;
  var _stage = _Stage.idle;
  var _scenario = _Scenario.success;
  var _prompt = '';
  var _answer = '';
  var _following = true;
  var _toolStarted = false;
  var _alwaysAllowTerminal = false;
  final _history = <({String prompt, String answer})>[];

  RegistryDashboardAgentStyles get styles => widget.styles;

  String get _visibleAnswer => _answer.isNotEmpty
      ? _answer
      : _stage == _Stage.denied
      ? 'Permission denied. No tool ran.'
      : !_toolStarted
      ? 'Stopped before running the tool. No tool ran.'
      : 'Run stopped; partial output was preserved.';

  String get _executionOutput =>
      _answer.isEmpty ? r'$ flutter test' : '${r'$ flutter test'}\n$_answer';

  bool get _active => const {
    _Stage.preparing,
    _Stage.permission,
    _Stage.running,
  }.contains(_stage);

  @override
  void dispose() {
    _cancelPending();
    _scroll.dispose();
    _draft.dispose();
    super.dispose();
  }

  void _cancelPending() {
    _runId++;
    _timer?.cancel();
    _timer = null;
  }

  void _reset() {
    _cancelPending();
    _draft.clear();
    setState(() {
      _stage = _Stage.idle;
      _prompt = '';
      _answer = '';
      _following = true;
      _alwaysAllowTerminal = false;
      _toolStarted = false;
      _history.clear();
    });
  }

  void _start(
    String prompt, {
    _Scenario scenario = _Scenario.success,
    bool keepMessage = false,
  }) {
    if (_active || prompt.trim().isEmpty) return;
    _cancelPending();
    final id = _runId;
    setState(() {
      if (!keepMessage && _prompt.isNotEmpty) {
        _history.add((prompt: _prompt, answer: _visibleAnswer));
      }
      _scenario = scenario;
      if (!keepMessage) _prompt = prompt.trim();
      _answer = '';
      _toolStarted = false;
      _stage = _Stage.preparing;
      _following = true;
    });
    _timer = Timer(widget.stepDelay, () {
      if (!mounted || id != _runId) return;
      if (scenario == _Scenario.permission && !_alwaysAllowTerminal) {
        setState(() => _stage = _Stage.permission);
      } else {
        _stream(id);
      }
    });
  }

  void _stream(int id) {
    var chunk = 0;
    setState(() {
      _toolStarted = true;
      _stage = _Stage.running;
    });
    _timer = Timer.periodic(widget.stepDelay, (timer) {
      if (!mounted || id != _runId) {
        timer.cancel();
        return;
      }
      if (_scenario == _Scenario.failure && chunk == 1) {
        timer.cancel();
        setState(() {
          _stage = _Stage.failed;
          _answer =
              'The simulated command failed. Retry to run the recovery path.';
        });
        return;
      }
      setState(() => _answer += _chunks[chunk++]);
      if (chunk == _chunks.length) {
        timer.cancel();
        setState(() => _stage = _Stage.complete);
      }
    });
  }

  void _allow(int requestId, {required bool always}) {
    if (requestId != _runId || _stage != _Stage.permission) return;
    if (always) _alwaysAllowTerminal = true;
    _stream(_runId);
  }

  void _stop() {
    _cancelPending();
    setState(() => _stage = _Stage.stopped);
  }

  void _retry() => _start(
    _prompt,
    scenario: _scenario == .failure ? .success : _scenario,
    keepMessage: true,
  );

  void _returnToLatest() {
    setState(() => _following = true);
    if (!_scroll.hasClients) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _scroll.jumpTo(_scroll.position.maxScrollExtent);
    } else {
      _scroll.animateTo(
        _scroll.position.maxScrollExtent,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final gutter = MediaQuery.sizeOf(context).width < 600 ? 16.0 : 32.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        gutter,
        gutter,
        gutter,
        gutter + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 500;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: StyledText('Agent chat', style: styles.heading),
                      ),
                      styles.buttonBuilder('New chat', _reset, .outline),
                    ],
                  ),
                  const SizedBox(height: 4),
                  StyledText('Interactive demo', style: styles.body),
                  if (!compact) ...[
                    const SizedBox(height: 8),
                    StyledText(
                      'Simulated responses and tools — no backend or credentials.',
                      style: styles.body,
                    ),
                    const SizedBox(height: 16),
                    if (!_active) ...[_starters(), const SizedBox(height: 16)],
                  ],
                  Expanded(child: _transcript()),
                  if (!_following)
                    Align(
                      child: styles.buttonBuilder(
                        'Return to latest',
                        _returnToLatest,
                        .soft,
                      ),
                    ),
                  const SizedBox(height: 12),
                  _composer(maxLines: compact ? 2 : 8),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _starters() => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      children: [
        _starter('Review checkout', .success),
        const SizedBox(width: 8),
        _starter('Run terminal checks', .permission),
        const SizedBox(width: 8),
        _starter('Recover a failed command', .failure),
      ],
    ),
  );

  Widget _starter(String label, _Scenario scenario) => styles.buttonBuilder(
    label,
    () => _start(label, scenario: scenario),
    .soft,
  );

  Widget _transcript() {
    final requestId = _runId;
    final children = <Widget>[];
    for (final turn in _history) {
      children.addAll([
        _message(turn.prompt),
        _answerWidget(turn.answer, .complete),
      ]);
    }
    if (_prompt.isNotEmpty) {
      children.add(_message(_prompt));
      children.add(
        AgentPlan(
          style: styles.planStyle,
          disclosureStyle: styles.planDisclosureStyle,
          items: [
            const AgentPlanItem(
              id: 'inspect',
              title: 'Inspect the request',
              status: .completed,
            ),
            AgentPlanItem(
              id: 'tool',
              title: 'Run focused work',
              status: _active
                  ? .inProgress
                  : _stage == _Stage.complete
                  ? .completed
                  : .cancelled,
            ),
          ],
        ),
      );
      children.add(
        AgentActivity(
          style: styles.activityStyle,
          disclosureStyle: styles.activityDisclosureStyle,
          status: _active ? .working : .complete,
          items: [
            AgentActivityItem(
              id: 'run',
              title: _activityLabel,
              status: _active ? .active : .complete,
            ),
          ],
        ),
      );
      if (_stage == _Stage.permission ||
          (_scenario == _Scenario.permission &&
              _stage != _Stage.preparing &&
              (_stage != _Stage.stopped || _toolStarted))) {
        children.add(
          AgentPermission(
            requestId: _runId,
            tool: 'terminal.run',
            description: 'Run deterministic focused checks in this demo.',
            status: _stage == _Stage.permission
                ? .pending
                : _stage == _Stage.denied
                ? .denied
                : _stage == _Stage.stopped
                ? .allowed
                : _stage == _Stage.failed
                ? .error
                : _active
                ? .running
                : .complete,
            parameters: const [
              RemixDataListItem(label: 'Command', value: 'flutter test'),
            ],
            style: styles.permissionStyle,
            surfaceStyle: styles.permissionSurfaceStyle,
            detailsStyle: styles.permissionDetailsStyle,
            parametersStyle: styles.permissionParametersStyle,
            allowOnceStyle: styles.permissionAllowOnceStyle,
            alwaysAllowStyle: styles.permissionAlwaysAllowStyle,
            denyStyle: styles.permissionDenyStyle,
            onAllowOnce: () => _allow(requestId, always: false),
            onAlwaysAllow: () => _allow(requestId, always: true),
            onDeny: () {
              if (requestId != _runId || _stage != _Stage.permission) return;
              _cancelPending();
              setState(() => _stage = _Stage.denied);
            },
          ),
        );
      }
      if (_toolStarted &&
          {
            _Stage.running,
            _Stage.complete,
            _Stage.failed,
            _Stage.stopped,
          }.contains(_stage)) {
        children.add(
          AgentExecution(
            tool: 'terminal.run',
            title: 'Focused checks',
            status: _stage == _Stage.running
                ? .running
                : _stage == _Stage.complete
                ? .success
                : _stage == _Stage.failed
                ? .error
                : .cancelled,
            style: styles.executionStyle,
            surfaceStyle: styles.executionSurfaceStyle,
            disclosureStyle: styles.executionDisclosureStyle,
            copyStyle: styles.executionCopyStyle,
            retryStyle: styles.executionRetryStyle,
            onCopy: () =>
                Clipboard.setData(ClipboardData(text: _executionOutput)),
            onRetry: _retry,
            child: Text(_executionOutput),
          ),
        );
      }
      if (_answer.isNotEmpty ||
          {_Stage.denied, _Stage.stopped}.contains(_stage)) {
        children.add(
          _answerWidget(
            _visibleAnswer,
            _stage == _Stage.running
                ? .streaming
                : _stage == _Stage.failed
                ? .error
                : .complete,
          ),
        );
      }
    }
    return AgentTranscript(
      controller: _scroll,
      followOutput: _following,
      busy: _active,
      onFollowChanged: (value) {
        if (_following != value) setState(() => _following = value);
      },
      style: styles.transcriptStyle,
      children: children.isEmpty
          ? const [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('Choose a starter or write a message.'),
                ),
              ),
            ]
          : children,
    );
  }

  Widget _message(String value) => AgentMessage(
    role: .user,
    style: styles.messageStyle,
    surfaceStyle: styles.messageSurfaceStyle,
    child: Text(value),
  );

  Widget _answerWidget(String value, AgentAnswerStatus status) {
    return AgentAnswer(
      streamId: _runId,
      status: status,
      style: styles.answerStyle,
      surfaceStyle: styles.answerSurfaceStyle,
      sourcesStyle: styles.answerSourcesStyle,
      copyStyle: styles.answerCopyStyle,
      retryStyle: styles.answerRetryStyle,
      onCopy: () => Clipboard.setData(ClipboardData(text: value)),
      onRetry: _retry,
      sourcesContent: const Text('Deterministic local fixture · no network'),
      child: Text(value),
    );
  }

  Widget _composer({required int maxLines}) => AgentComposer(
    controller: _draft,
    maxLines: maxLines,
    running: _active,
    onSubmit: _start,
    onStop: _stop,
    hintText: _active ? 'Run in progress…' : 'Ask the demo agent…',
    style: styles.composerStyle,
    surfaceStyle: styles.composerSurfaceStyle,
    fieldStyle: styles.composerFieldStyle,
    submitStyle: styles.composerSubmitStyle,
    stopStyle: styles.composerStopStyle,
  );

  String get _activityLabel => switch (_stage) {
    .preparing => 'Preparing the run',
    .permission => 'Waiting for permission',
    .running => 'Streaming simulated output',
    .complete => 'Run complete',
    .failed => 'Command failed',
    .stopped => 'Run stopped',
    .denied => 'Permission denied',
    .idle => 'Ready',
  };
}
