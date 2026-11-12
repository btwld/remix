import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import '../../components/activity.dart';
import '../../components/answer.dart';
import '../../components/composer.dart';
import '../../components/execution.dart';
import '../../components/message.dart';
import '../../components/permission.dart';
import '../../components/plan.dart';
import '../../components/transcript.dart';
import '../../models/activity_item.dart';
import '../../models/plan_item.dart';
import '../../models/statuses.dart';

/// How prominent a demo button is.
enum UiDashboardAgentButtonTone {
  /// The filled, main action.
  primary,

  /// A tinted, secondary action.
  soft,

  /// An outlined, low-emphasis action.
  outline,
}

/// Builds a demo button with a [label], an optional [onPressed] and a [tone].
typedef UiDashboardAgentButtonBuilder =
    Widget Function(
      String label,
      VoidCallback? onPressed,
      UiDashboardAgentButtonTone tone,
    );

/// Preset-owned styles consumed by the shared deterministic Agent demo.
final class UiDashboardAgentStyles {
  const UiDashboardAgentStyles({
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
    this.transcriptLatestStyle = const IconButtonStyler.create(),
    this.turnStyle = const FlexBoxStyler.create(),
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

  /// Builds the demo's buttons: starters and "New chat".
  final UiDashboardAgentButtonBuilder buttonBuilder;

  /// Style of the page heading.
  final TextStyler heading;

  /// Style of the page's supporting text.
  final TextStyler body;

  /// Style of each [UiMessage].
  final UiMessageStyler messageStyle;

  /// Style of each message's card.
  final CardStyler messageSurfaceStyle;

  /// Style of each [UiAnswer].
  final UiAnswerStyler answerStyle;

  /// Style of each answer's card.
  final CardStyler answerSurfaceStyle;

  /// Style of each answer's sources disclosure.
  final DisclosureStyler answerSourcesStyle;

  /// Style of each answer's copy action.
  final IconButtonStyler answerCopyStyle;

  /// Style of each answer's retry action.
  final IconButtonStyler answerRetryStyle;

  /// Style of the [UiTranscript].
  final UiTranscriptStyler transcriptStyle;

  /// Style of the transcript's scroll-to-latest button.
  final IconButtonStyler transcriptLatestStyle;

  /// Lays out one turn: the prompt, the agent's work and its answer.
  ///
  /// The transcript's spacing separates turns, so keep a turn's own spacing
  /// the tighter of the two: each prompt then reads with the reply below it.
  final FlexBoxStyler turnStyle;

  /// Style of the [UiPlan].
  final UiPlanStyler planStyle;

  /// Style of the plan's disclosure.
  final DisclosureStyler planDisclosureStyle;

  /// Style of the [UiActivity] ledger.
  final UiActivityStyler activityStyle;

  /// Style of the ledger's disclosure.
  final DisclosureStyler activityDisclosureStyle;

  /// Style of the [UiPermission].
  final UiPermissionStyler permissionStyle;

  /// Style of the permission's card.
  final CardStyler permissionSurfaceStyle;

  /// Style of the permission's details disclosure.
  final DisclosureStyler permissionDetailsStyle;

  /// Style of the permission's parameter list.
  final DataListStyler permissionParametersStyle;

  /// Style of the "Allow once" action.
  final ButtonStyler permissionAllowOnceStyle;

  /// Style of the "Always allow" action.
  final ButtonStyler permissionAlwaysAllowStyle;

  /// Style of the "Deny" action.
  final ButtonStyler permissionDenyStyle;

  /// Style of the [UiExecution].
  final UiExecutionStyler executionStyle;

  /// Style of the execution's card.
  final CardStyler executionSurfaceStyle;

  /// Style of the execution's disclosure.
  final DisclosureStyler executionDisclosureStyle;

  /// Style of the execution's copy action.
  final IconButtonStyler executionCopyStyle;

  /// Style of the execution's retry action.
  final IconButtonStyler executionRetryStyle;

  /// Style of the [UiComposer].
  final UiComposerStyler composerStyle;

  /// Style of the composer's card.
  final CardStyler composerSurfaceStyle;

  /// Style of the composer's text field.
  final TextFieldStyler composerFieldStyle;

  /// Style of the composer's send action.
  final IconButtonStyler composerSubmitStyle;

  /// Style of the composer's stop action.
  final IconButtonStyler composerStopStyle;
}

/// The scripted path a demo run takes.
enum _Scenario {
  /// Streams an answer without asking for permission.
  success,

  /// Asks for permission before the tool runs.
  permission,

  /// Fails partway through; retrying succeeds.
  failure,
}

/// Where the current run is.
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
class UiDashboardChatPage extends StatefulWidget {
  const UiDashboardChatPage({
    super.key,
    required this.styles,
    this.stepDelay = const Duration(milliseconds: 320),
  });

  /// The preset's styles for every Agent component on the page.
  final UiDashboardAgentStyles styles;

  /// Pause between the scripted steps of a run.
  final Duration stepDelay;

  @override
  State<UiDashboardChatPage> createState() => _UiDashboardChatPageState();
}

class _UiDashboardChatPageState extends State<UiDashboardChatPage> {
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
  // Turns are numbered so a copy confirmation belongs to one answer: several
  // answers can share the same text.
  var _turn = 0;
  int? _copiedTurn;
  Timer? _copiedTimer;
  final _history =
      <({int turn, String prompt, String answer, bool succeeded})>[];

  UiDashboardAgentStyles get styles => widget.styles;

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
    _copiedTimer?.cancel();
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
    _clearCopied();
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

  Future<void> _copyAnswer(int turn, String text) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    _copiedTimer?.cancel();
    setState(() => _copiedTurn = turn);
    _copiedTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copiedTurn = null);
    });
  }

  // A confirmation answers the last action; a new run replaces it.
  void _clearCopied() {
    _copiedTimer?.cancel();
    _copiedTimer = null;
    _copiedTurn = null;
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
      _clearCopied();
      if (!keepMessage && _prompt.isNotEmpty) {
        _history.add((
          turn: _turn,
          prompt: _prompt,
          answer: _visibleAnswer,
          succeeded: _stage == _Stage.complete,
        ));
      }
      _scenario = scenario;
      if (!keepMessage) {
        _turn++;
        _prompt = prompt.trim();
      }
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

  @override
  Widget build(BuildContext context) {
    final gutter = MediaQuery.sizeOf(context).width < 600 ? 16.0 : 20.0;
    return Box(
      style: BoxStyler()
          .padding(
            .fromLTRB(
              gutter,
              gutter,
              gutter,
              gutter + MediaQuery.viewInsetsOf(context).bottom,
            ),
          )
          .alignment(.center),
      child: Box(
        style: BoxStyler().maxWidth(800),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final compact = constraints.maxHeight < 500;
            return ColumnBox(
              style: FlexBoxStyler().crossAxisAlignment(.stretch).spacing(12),
              children: [
                ColumnBox(
                  style: FlexBoxStyler()
                      .mainAxisSize(.min)
                      .crossAxisAlignment(.stretch)
                      .spacing(4),
                  children: [
                    RowBox(
                      style: FlexBoxStyler().spacing(12),
                      children: [
                        Expanded(
                          child: StyledText(
                            'Agent chat',
                            style: styles.heading,
                          ),
                        ),
                        styles.buttonBuilder('New chat', _reset, .outline),
                      ],
                    ),
                    StyledText('Interactive demo', style: styles.body),
                  ],
                ),
                // The transcript offers its own way back to the latest.
                Expanded(child: _transcript(compact: compact)),
                _composer(maxLines: compact ? 2 : 8),
                if (!compact)
                  Box(
                    style: BoxStyler().alignment(.center),
                    child: StyledText(
                      'Simulated responses and tools — no backend or credentials.',
                      style: styles.body,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _starters() => Wrap(
    alignment: WrapAlignment.center,
    spacing: 8,
    runSpacing: 8,
    children: [
      _starter('Review checkout', .success),
      _starter('Run terminal checks', .permission),
      _starter('Recover a failed command', .failure),
    ],
  );

  Widget _starter(String label, _Scenario scenario) => styles.buttonBuilder(
    label,
    () => _start(label, scenario: scenario),
    // Suggestions are outlined so the only filled shape in the
    // conversation is the reader's own message.
    .outline,
  );

  Widget _transcript({bool compact = false}) {
    final turns = <Widget>[
      for (final turn in _history)
        _turnGroup([
          _message(turn.prompt),
          _answerWidget(
            turn.turn,
            turn.answer,
            .complete,
            sources: turn.succeeded,
          ),
        ]),
      if (_prompt.isNotEmpty) _currentTurn(),
    ];
    return UiTranscript(
      controller: _scroll,
      followOutput: _following,
      busy: _active,
      onFollowChanged: (value) {
        if (_following != value) setState(() => _following = value);
      },
      style: styles.transcriptStyle,
      latestStyle: styles.transcriptLatestStyle,
      children: turns.isEmpty
          ? [
              Box(
                style: BoxStyler().alignment(.center).padding(.all(32)),
                child: ColumnBox(
                  style: FlexBoxStyler()
                      .mainAxisSize(.min)
                      .crossAxisAlignment(.center)
                      .spacing(16),
                  children: [
                    const StyledText('Choose a starter or write a message.'),
                    if (!compact) _starters(),
                  ],
                ),
              ),
            ]
          : turns,
    );
  }

  /// The turn in progress: the prompt and whichever parts of the agent's work
  /// the current stage has reached.
  Widget _currentTurn() => _turnGroup([
    _message(_prompt),
    _plan(),
    // Activity says what the agent is doing until a card says it instead.
    if (_stage == _Stage.preparing) _activity(),
    // A decided request that let the tool run is told by the tool row
    // below it, so only a pending or denied request is shown.
    if (_stage == _Stage.permission ||
        (_scenario == _Scenario.permission && _stage == _Stage.denied))
      _permission(),
    if (_toolStarted &&
        {
          _Stage.running,
          _Stage.complete,
          _Stage.failed,
          _Stage.stopped,
        }.contains(_stage))
      _execution(),
    if (_answer.isNotEmpty || {_Stage.denied, _Stage.stopped}.contains(_stage))
      _answerWidget(
        _turn,
        _visibleAnswer,
        _answerStatus,
        sources: _stage == _Stage.complete,
      ),
  ]);

  Widget _plan() => UiPlan(
    style: styles.planStyle,
    disclosureStyle: styles.planDisclosureStyle,
    items: [
      const UiPlanItem(
        id: 'inspect',
        title: 'Inspect the request',
        status: .completed,
      ),
      UiPlanItem(
        id: 'tool',
        title: 'Run focused work',
        status: _active
            ? .inProgress
            : _stage == _Stage.complete
            ? .completed
            : .cancelled,
      ),
    ],
  );

  Widget _activity() => UiActivity(
    style: styles.activityStyle,
    disclosureStyle: styles.activityDisclosureStyle,
    status: _active ? .working : .complete,
    items: [
      UiActivityItem(
        id: 'run',
        title: _activityLabel,
        status: _active ? .active : .complete,
      ),
    ],
  );

  Widget _permission() {
    final requestId = _runId;
    final narrow = MediaQuery.sizeOf(context).width < 600;
    return UiPermission(
      requestId: requestId,
      tool: 'terminal.run',
      description: 'Run deterministic focused checks in this demo.',
      status: _permissionStatus,
      parameters: const [
        RemixDataListItem(label: 'Command', value: 'flutter test'),
      ],
      style: styles.permissionStyle.merge(
        UiPermissionStyler(
          actions: FlexBoxStyler()
              .direction(narrow ? .vertical : .horizontal)
              .crossAxisAlignment(narrow ? .stretch : .center),
        ),
      ),
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
    );
  }

  Widget _execution() => UiExecution(
    tool: 'terminal.run',
    title: 'Focused checks',
    status: _executionStatus,
    style: styles.executionStyle,
    surfaceStyle: styles.executionSurfaceStyle,
    disclosureStyle: styles.executionDisclosureStyle,
    copyStyle: styles.executionCopyStyle,
    retryStyle: styles.executionRetryStyle,
    onCopy: () => Clipboard.setData(ClipboardData(text: _executionOutput)),
    onRetry: _retry,
    child: StyledText(_executionOutput),
  );

  UiPermissionStatus get _permissionStatus => switch (_stage) {
    .permission => .pending,
    .denied => .denied,
    .stopped => .allowed,
    .failed => .error,
    _ => _active ? .running : .complete,
  };

  UiExecutionStatus get _executionStatus => switch (_stage) {
    .running => .running,
    .complete => .success,
    .failed => .error,
    _ => .cancelled,
  };

  UiAnswerStatus get _answerStatus => switch (_stage) {
    .running => .streaming,
    .failed => .error,
    _ => .complete,
  };

  // Each turn is one transcript item, so the transcript's spacing falls
  // between turns and the turn's own, tighter spacing within one.
  Widget _turnGroup(List<Widget> children) => ColumnBox(
    style: FlexBoxStyler()
        .mainAxisSize(.min)
        .crossAxisAlignment(.stretch)
        .spacing(8)
        .merge(styles.turnStyle),
    children: children,
  );

  Widget _message(String value) => UiMessage(
    role: .user,
    style: styles.messageStyle,
    surfaceStyle: styles.messageSurfaceStyle,
    child: StyledText(value),
  );

  Widget _answerWidget(
    int turn,
    String value,
    UiAnswerStatus status, {
    bool sources = true,
  }) {
    return UiAnswer(
      streamId: _runId,
      status: status,
      style: styles.answerStyle,
      surfaceStyle: styles.answerSurfaceStyle,
      sourcesStyle: styles.answerSourcesStyle,
      copyStyle: styles.answerCopyStyle,
      retryStyle: styles.answerRetryStyle,
      onCopy: () => _copyAnswer(turn, value),
      feedback: _copiedTurn == turn ? const StyledText('Copied') : null,
      onRetry: _retry,
      // Sources belong to an answer that used them, not to a failure.
      sourcesContent: sources && status == .complete
          ? const StyledText('Deterministic local fixture · no network')
          : null,
      child: StyledText(value),
    );
  }

  Widget _composer({required int maxLines}) => UiComposer(
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
