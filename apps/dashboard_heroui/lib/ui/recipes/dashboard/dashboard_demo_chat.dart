import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

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
    required this.glyphBuilder,
    required this.heading,
    required this.body,
    required this.dockStyle,
    required this.conversationStyle,
    required this.latestStyle,
    required this.messageStyle,
    required this.messageToggleStyle,
    required this.stepsStyle,
    required this.stepStyle,
    required this.stepsDisclosureStyle,
    required this.toolCallStyle,
    required this.toolCallDisclosureStyle,
    required this.toolInputStyle,
    required this.allowOnceStyle,
    required this.alwaysAllowStyle,
    required this.denyStyle,
    required this.answerStyle,
    required this.answerActionStyle,
    required this.sourcesStyle,
    required this.sourcesDisclosureStyle,
    required this.sourceStyle,
    required this.suggestionsStyle,
    required this.suggestionStyle,
    required this.composerStyle,
    required this.composerFieldStyle,
    required this.submitStyle,
    required this.stopStyle,
  });

  /// Builds the demo's buttons: "New chat".
  final UiDashboardAgentButtonBuilder buttonBuilder;

  /// Draws every glyph of the Agent widgets.
  final AgentGlyphBuilder glyphBuilder;

  /// Style of the empty state's question.
  final TextStyler heading;

  /// Style of the page's supporting text.
  final TextStyler body;

  /// Bounds the composer to the conversation's column.
  final BoxStyler dockStyle;

  /// Style of the [AgentConversation].
  final AgentConversationStyler conversationStyle;

  /// Style of the button that returns to the latest output.
  final IconButtonStyler latestStyle;

  /// Style of the reader's [AgentMessage].
  final AgentMessageStyler messageStyle;

  /// Style of the button that expands a long message.
  final ButtonStyler messageToggleStyle;

  /// Style of the [AgentSteps] line and rail.
  final AgentStepsStyler stepsStyle;

  /// Style of each step on the rail.
  final AgentStepStyler stepStyle;

  /// Style of the steps' disclosure.
  final DisclosureStyler stepsDisclosureStyle;

  /// Style of the [AgentToolCall].
  final AgentToolCallStyler toolCallStyle;

  /// Style of the tool call's output disclosure.
  final DisclosureStyler toolCallDisclosureStyle;

  /// Style of the approval card's inputs.
  final DataListStyler toolInputStyle;

  /// Style of the "Allow once" action.
  final ButtonStyler allowOnceStyle;

  /// Style of the "Always allow" action.
  final ButtonStyler alwaysAllowStyle;

  /// Style of the "Deny" action.
  final ButtonStyler denyStyle;

  /// Style of the [AgentAnswer].
  final AgentAnswerStyler answerStyle;

  /// Style of every answer action.
  final IconButtonStyler answerActionStyle;

  /// Style of the [AgentSources] line and list.
  final AgentSourcesStyler sourcesStyle;

  /// Style of the sources' disclosure.
  final DisclosureStyler sourcesDisclosureStyle;

  /// Style of a source the reader can open.
  final ButtonStyler sourceStyle;

  /// Style of the [AgentSuggestions] row.
  final AgentSuggestionsStyler suggestionsStyle;

  /// Style of each suggestion.
  final ButtonStyler suggestionStyle;

  /// Style of the [AgentComposer].
  final AgentComposerStyler composerStyle;

  /// Style of the composer's text field.
  final TextFieldStyler composerFieldStyle;

  /// Style of the composer's send action.
  final IconButtonStyler submitStyle;

  /// Style of the composer's stop action.
  final IconButtonStyler stopStyle;
}

/// The scripted path a demo run takes.
enum _Scenario {
  /// Runs the tool without asking, then answers.
  success,

  /// Asks for permission, runs the tool, then answers.
  permission,

  /// Asks for permission and the tool fails; retrying succeeds.
  failure,
}

/// Where a run is.
enum _Stage {
  preparing,
  permission,
  running,
  answering,
  complete,
  failed,
  stopped,
  denied,
}

/// What each suggestion sends once the reader submits it.
const _suggestions = [
  (
    label: 'Review checkout',
    prompt: 'Review the checkout flow and tell me if the cart is ready.',
    scenario: _Scenario.success,
  ),
  (
    label: 'Run terminal checks',
    prompt: 'Run the checkout tests and tell me if the cart flow is ready.',
    scenario: _Scenario.permission,
  ),
  (
    label: 'Recover a failed command',
    prompt: 'Run the checkout tests again and recover if one fails.',
    scenario: _Scenario.failure,
  ),
];

const _command = r'$ flutter test test/cart';

const _output = [
  _command,
  '00:01 +12: cart_state_test.dart: adds an item',
  '00:02 +27: cart_totals_test.dart: applies a discount',
  '00:03 +31: checkout_flow_test.dart: submits the order…',
];

const _failedOutput = [
  _command,
  '00:02 +30: cart_totals_test.dart: applies a discount',
];

const _failedError =
    '00:03 +30 -1: checkout_flow_test.dart: submits the order [E]\n'
    '  Expected: OrderStatus.placed\n'
    '    Actual: OrderStatus.pending';

const _answerChunks = [
  'The cart flow is ready. ',
  'All 31 checkout tests pass, including the discount and order-submission '
      'paths.\n\n',
  'One thing to watch: cart_totals_test.dart only covers single-currency '
      'carts, so a multi-currency case is worth adding before launch.',
];

const _failedAnswer =
    'One test fails: the order stays pending after submission. I can look at '
    'the payment stub that resolves it.';

const _deniedAnswer =
    "Understood, I won't run anything. From reading the code, the cart flow "
    "looks complete, but I can't confirm the tests pass without running them.";

const _stoppedAnswer = 'Run stopped; partial output was preserved.';

const _toolInput = <AgentToolInput>[
  (label: 'Command', value: 'flutter test test/cart'),
  (label: 'Directory', value: 'packages/checkout'),
];

const _sources = [
  AgentSource(id: 'totals', title: 'cart_totals_test.dart'),
  AgentSource(id: 'flow', title: 'checkout_flow_test.dart'),
];

/// One question and the run that answers it.
final class _Turn {
  _Turn({required this.id, required this.prompt, required this.scenario});

  final int id;
  final String prompt;
  _Scenario scenario;
  _Stage stage = _Stage.preparing;
  AgentApprovalDecision? decision;
  int outputLines = 0;
  int answerChunks = 0;

  /// Measures how long the run worked, for "Thought for 4s".
  final clock = AgentRunClock();

  /// Whether the tool started, so a stopped run reports what it left behind.
  bool toolStarted = false;

  bool get active => const {
    _Stage.preparing,
    _Stage.permission,
    _Stage.running,
    _Stage.answering,
  }.contains(stage);
}

/// Complete local-only Agent demonstration shared by every dashboard preset.
///
/// It scripts the states of an agent turn: the empty conversation with
/// suggestions that fill the composer, a tool call that asks for approval,
/// the run, the answer, a failed command and a denied request.
class UiDashboardChatPage extends StatefulWidget {
  const UiDashboardChatPage({
    super.key,
    required this.styles,
    this.stepDelay = const Duration(milliseconds: 320),
  });

  /// The preset's styles for every Agent widget on the page.
  final UiDashboardAgentStyles styles;

  /// Pause between the scripted steps of a run.
  final Duration stepDelay;

  @override
  State<UiDashboardChatPage> createState() => _UiDashboardChatPageState();
}

class _UiDashboardChatPageState extends State<UiDashboardChatPage> {
  final _composer = AgentComposerController();
  final _composerFocus = FocusNode();
  final _composerKey = GlobalKey();
  final _turns = <_Turn>[];
  Timer? _timer;
  var _runId = 0;
  var _nextTurn = 0;
  var _alwaysAllowTerminal = false;
  AgentAnswerFeedback? _feedback;

  UiDashboardAgentStyles get styles => widget.styles;

  _Turn? get _current => _turns.isEmpty ? null : _turns.last;

  bool get _active => _current?.active ?? false;

  @override
  void dispose() {
    _cancelPending();
    for (final turn in _turns) {
      turn.clock.dispose();
    }
    _composer.dispose();
    _composerFocus.dispose();
    super.dispose();
  }

  void _cancelPending() {
    _runId++;
    _timer?.cancel();
    _timer = null;
  }

  void _syncComposer() => _composer.running = _active;

  void _reset() {
    _cancelPending();
    for (final turn in _turns) {
      turn.clock.dispose();
    }
    _composer.clear();
    setState(() {
      _turns.clear();
      _alwaysAllowTerminal = false;
      _feedback = null;
      _syncComposer();
    });
  }

  _Scenario _scenarioFor(String prompt) {
    for (final suggestion in _suggestions) {
      if (suggestion.prompt == prompt) return suggestion.scenario;
    }
    return _Scenario.permission;
  }

  void _start(String prompt) {
    if (_active || prompt.trim().isEmpty) return;
    final turn = _Turn(
      id: _nextTurn++,
      prompt: prompt.trim(),
      scenario: _scenarioFor(prompt.trim()),
    );
    setState(() {
      _turns.add(turn);
      _feedback = null;
    });
    _begin(turn);
  }

  /// Starts, or restarts after a retry, the run of [turn].
  void _begin(_Turn turn) {
    _cancelPending();
    final id = _runId;
    setState(() {
      turn
        ..stage = _Stage.preparing
        ..decision = null
        ..outputLines = 0
        ..answerChunks = 0
        ..toolStarted = false
        ..clock.reset()
        ..clock.start();
      _syncComposer();
    });
    _timer = Timer(widget.stepDelay, () {
      if (!mounted || id != _runId) return;
      if (turn.scenario != _Scenario.success && !_alwaysAllowTerminal) {
        setState(() => turn.stage = _Stage.permission);
      } else {
        _run(turn, id);
      }
    });
  }

  void _run(_Turn turn, int id) {
    final failing = turn.scenario == _Scenario.failure;
    final lines = failing ? _failedOutput : _output;
    setState(() {
      turn
        ..toolStarted = true
        ..stage = _Stage.running
        ..outputLines = 1;
    });
    _timer = Timer.periodic(widget.stepDelay, (timer) {
      if (!mounted || id != _runId) {
        timer.cancel();
        return;
      }
      setState(() {
        if (turn.outputLines < lines.length) {
          turn.outputLines++;
        } else if (failing) {
          timer.cancel();
          turn.clock.stop();
          turn.stage = _Stage.failed;
          _syncComposer();
        } else if (turn.stage == _Stage.running) {
          turn.stage = _Stage.answering;
        } else if (turn.answerChunks < _answerChunks.length) {
          turn.answerChunks++;
        } else {
          timer.cancel();
          turn.clock.stop();
          turn.stage = _Stage.complete;
          _syncComposer();
        }
      });
    });
  }

  void _decide(_Turn turn, AgentApprovalDecision decision) {
    if (turn.stage != _Stage.permission) return;
    if (decision == AgentApprovalDecision.deny) {
      _cancelPending();
      setState(() {
        turn
          ..decision = decision
          ..clock.stop()
          ..stage = _Stage.denied;
        _syncComposer();
      });
      return;
    }
    if (decision == AgentApprovalDecision.alwaysAllow) {
      _alwaysAllowTerminal = true;
    }
    setState(() => turn.decision = decision);
    _run(turn, _runId);
  }

  void _stop() {
    final turn = _current;
    if (turn == null) return;
    _cancelPending();
    setState(() {
      turn
        ..clock.stop()
        ..stage = _Stage.stopped;
      _syncComposer();
    });
  }

  void _retry(_Turn turn) {
    if (_active) return;
    // A failure retries into success; a denied or stopped run asks again.
    if (turn.scenario == _Scenario.failure) turn.scenario = _Scenario.success;
    _begin(turn);
  }

  @override
  Widget build(BuildContext context) {
    final composer = KeyedSubtree(key: _composerKey, child: _composerBox());
    final empty = _turns.isEmpty;

    return AgentGlyphs(
      builder: styles.glyphBuilder,
      // The keyboard lifts the composer: nothing above it resizes for it.
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ColumnBox(
          style: FlexBoxStyler().crossAxisAlignment(.stretch),
          children: [
            if (!empty)
              Box(
                style: BoxStyler()
                    .alignment(.centerRight)
                    .padding(.fromLTRB(20, 12, 20, 0)),
                child: styles.buttonBuilder('New chat', _reset, .outline),
              ),
            Expanded(child: empty ? _emptyState(composer) : _conversation()),
            if (!empty) _dock(composer),
          ],
        ),
      ),
    );
  }

  /// The question, the composer and the suggestions, centered.
  Widget _emptyState(Widget composer) => LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: constraints.maxHeight),
        child: Center(
          child: Box(
            style: styles.dockStyle,
            child: ColumnBox(
              style: FlexBoxStyler()
                  .mainAxisSize(.min)
                  .crossAxisAlignment(.stretch)
                  .spacing(12),
              children: [
                Box(
                  style: BoxStyler().alignment(.center).padding(.bottom(12)),
                  child: StyledText(
                    'What should we work on?',
                    style: styles.heading,
                  ),
                ),
                composer,
                AgentSuggestions(
                  controller: _composer,
                  focusNode: _composerFocus,
                  suggestions: [
                    for (final suggestion in _suggestions)
                      AgentSuggestion(
                        label: suggestion.label,
                        prompt: suggestion.prompt,
                      ),
                  ],
                  style: styles.suggestionsStyle,
                  suggestionStyle: styles.suggestionStyle,
                ),
                _disclaimer(),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _dock(Widget composer) => Box(
    style: styles.dockStyle,
    child: ColumnBox(
      style: FlexBoxStyler()
          .mainAxisSize(.min)
          .crossAxisAlignment(.stretch)
          .spacing(8)
          .padding(.bottom(16)),
      children: [composer, _disclaimer()],
    ),
  );

  Widget _disclaimer() => Box(
    style: BoxStyler().alignment(.center),
    child: StyledText(
      'Simulated responses and tools — no backend or credentials.',
      style: styles.body,
    ),
  );

  Widget _composerBox() => AgentComposer(
    controller: _composer,
    focusNode: _composerFocus,
    onSubmit: _start,
    onStop: _stop,
    hintText: _turns.isEmpty ? 'Ask the agent…' : 'Ask a follow-up…',
    style: styles.composerStyle,
    fieldStyle: styles.composerFieldStyle,
    submitStyle: styles.submitStyle,
    stopStyle: styles.stopStyle,
  );

  Widget _conversation() => AgentConversation(
    busy: _active,
    style: styles.conversationStyle,
    latestStyle: styles.latestStyle,
    children: [for (final turn in _turns) _turn(turn)],
  );

  Widget _turn(_Turn turn) {
    final call = _toolCall(turn);
    final answer = _answer(turn);

    return AgentTurn(
      key: ValueKey(turn.id),
      children: [
        AgentMessage(
          role: .user,
          style: styles.messageStyle,
          toggleStyle: styles.messageToggleStyle,
          child: Text(turn.prompt),
        ),
        _steps(turn),
        if (call != null)
          AgentToolCall(
            call: call,
            onDecision: (decision) => _decide(turn, decision),
            style: styles.toolCallStyle,
            disclosureStyle: styles.toolCallDisclosureStyle,
            inputStyle: styles.toolInputStyle,
            allowOnceStyle: styles.allowOnceStyle,
            alwaysAllowStyle: styles.alwaysAllowStyle,
            denyStyle: styles.denyStyle,
          ),
        if (answer != null) answer,
      ],
    );
  }

  Widget _steps(_Turn turn) {
    final waiting = turn.stage == _Stage.permission;
    final settled = !turn.active;
    final steps = <AgentStep>[
      AgentStep(
        id: 'read',
        title: 'Read the checkout module',
        status: turn.stage == _Stage.preparing ? .active : .complete,
      ),
      if (turn.stage != _Stage.preparing)
        const AgentStep(
          id: 'found',
          title: 'Found 4 test files for the cart',
          status: .complete,
        ),
      if (turn.toolStarted)
        AgentStep(
          id: 'ran',
          title: 'Ran the cart tests',
          status: switch (turn.stage) {
            .running => .active,
            .stopped || .failed => .cancelled,
            _ => .complete,
          },
        ),
    ];

    return AgentSteps(
      key: ValueKey('steps-${turn.id}-${turn.scenario.name}'),
      steps: steps,
      status: waiting
          ? .waiting
          : settled
          ? .complete
          : .working,
      clock: turn.clock,
      style: styles.stepsStyle,
      stepStyle: styles.stepStyle,
      disclosureStyle: styles.stepsDisclosureStyle,
    );
  }

  AgentToolCallPart? _toolCall(_Turn turn) {
    final failing = turn.scenario == _Scenario.failure;
    final lines = (failing ? _failedOutput : _output)
        .take(turn.outputLines)
        .join('\n');
    const id = 'call';
    const name = 'terminal.run';

    return switch (turn.stage) {
      .preparing => null,
      .permission => const AgentToolCallPart(
        id: id,
        name: name,
        summary: 'Run the cart tests',
        description:
            'The agent wants to run the checkout test suite in this workspace.',
        input: _toolInput,
        status: .awaitingApproval,
      ),
      .running => AgentToolCallPart(
        id: id,
        name: name,
        summary: 'Running the cart tests',
        input: _toolInput,
        status: .running,
        output: lines,
        decision: turn.decision,
      ),
      .answering || .complete => AgentToolCallPart(
        id: id,
        name: name,
        summary: 'Tests passed',
        detail: '31 tests',
        input: _toolInput,
        status: .succeeded,
        output: _output.join('\n'),
        decision: turn.decision,
        duration: const Duration(milliseconds: 2900),
      ),
      .failed => AgentToolCallPart(
        id: id,
        name: name,
        summary: '1 test failed',
        detail: '30 of 31 passed',
        input: _toolInput,
        status: .failed,
        output: _failedOutput.join('\n'),
        error: _failedError,
        decision: turn.decision,
        duration: const Duration(milliseconds: 3100),
      ),
      .denied => const AgentToolCallPart(
        id: id,
        name: name,
        summary: 'Run the cart tests',
        input: _toolInput,
        status: .denied,
        decision: .deny,
      ),
      .stopped =>
        turn.toolStarted
            ? AgentToolCallPart(
                id: id,
                name: name,
                summary: 'Run the cart tests',
                input: _toolInput,
                status: .cancelled,
                output: lines,
                decision: turn.decision,
              )
            : null,
    };
  }

  Widget? _answer(_Turn turn) {
    final (text, status) = switch (turn.stage) {
      .answering => (
        _answerChunks.take(turn.answerChunks).join(),
        AgentAnswerStatus.streaming,
      ),
      .complete => (_answerChunks.join(), AgentAnswerStatus.complete),
      .failed => (_failedAnswer, AgentAnswerStatus.complete),
      .denied => (_deniedAnswer, AgentAnswerStatus.complete),
      .stopped => (_stoppedAnswer, AgentAnswerStatus.complete),
      _ => ('', AgentAnswerStatus.complete),
    };
    if (text.isEmpty) return null;
    final complete = turn.stage == _Stage.complete;

    return AgentAnswer(
      id: turn.id,
      status: status,
      style: styles.answerStyle,
      actionStyle: styles.answerActionStyle,
      sources: complete
          ? AgentSources(
              sources: _sources,
              style: styles.sourcesStyle,
              disclosureStyle: styles.sourcesDisclosureStyle,
              sourceStyle: styles.sourceStyle,
            )
          : null,
      onCopy: () => Clipboard.setData(ClipboardData(text: text)),
      feedback: _feedback,
      onFeedback: (value) => setState(() => _feedback = value),
      onRetry: () => _retry(turn),
      child: Text(text),
    );
  }
}
