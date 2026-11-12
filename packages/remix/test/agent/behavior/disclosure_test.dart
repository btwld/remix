import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix/agent.dart';

import '../helpers/pump.dart';

// The registry's AgentPlan, AgentActivity, AgentExecution, AgentPermission and
// message collapsible each paired the disclosure storage with their own
// lifecycle rules. The cases below are ported from
// registry_source/test/agent/components/{disclosure_contract,lifecycle,
// behavior}_test.dart onto one harness: a Remix disclosure whose open state
// an AgentDisclosureController owns. Those widgets let a completion override
// the reader's toggle; that parity runs with respectReaderToggle: false.

const _parity = AgentDisclosurePolicy(respectReaderToggle: false);

void main() {
  lifecycleCallbackTests();
  group('AgentDisclosurePolicy.request', () {
    const policy = AgentDisclosurePolicy();

    test('opens on work, closes on settle, leaves a failure open', () {
      expect(
        policy.request(AgentWorkPhase.settled, AgentWorkPhase.working),
        true,
      );
      expect(
        policy.request(AgentWorkPhase.waiting, AgentWorkPhase.working),
        true,
      );
      expect(
        policy.request(AgentWorkPhase.working, AgentWorkPhase.waiting),
        null,
      );
      expect(
        policy.request(AgentWorkPhase.working, AgentWorkPhase.settled),
        false,
      );
      expect(
        policy.request(AgentWorkPhase.waiting, AgentWorkPhase.settled),
        false,
      );
      expect(
        policy.request(AgentWorkPhase.working, AgentWorkPhase.failed),
        null,
      );
    });

    test('asks for nothing when the phase does not change', () {
      for (final phase in AgentWorkPhase.values) {
        expect(policy.request(phase, phase), isNull, reason: phase.name);
      }
    });

    test('each rule can be turned off', () {
      const quiet = AgentDisclosurePolicy(
        openWhileWorking: false,
        collapseWhenSettled: false,
      );
      for (final from in AgentWorkPhase.values) {
        for (final to in AgentWorkPhase.values) {
          expect(quiet.request(from, to), isNull, reason: '$from → $to');
        }
      }
      const closesFailures = AgentDisclosurePolicy(keepOpenOnFailure: false);
      expect(
        closesFailures.request(AgentWorkPhase.working, AgentWorkPhase.failed),
        false,
      );
    });

    test('compares by value', () {
      expect(const AgentDisclosurePolicy(), policy);
      expect(_parity, isNot(policy));
      expect(_parity.hashCode, isNot(policy.hashCode));
    });
  });

  group('storage contract (ported)', () {
    testWidgets(
      'releasing control keeps the last controlled value and ignores new '
      'defaults',
      (tester) async {
        final requests = <bool>[];
        Future<void> pump(bool? expanded, bool defaultExpanded) async {
          await pumpAgent(
            tester,
            _Disclosure(
              expanded: expanded,
              defaultExpanded: defaultExpanded,
              onExpandedChanged: requests.add,
            ),
          );
          await tester.pumpAndSettle();
        }

        await pump(true, false);
        await tester.tap(find.text('Steps'));
        await tester.pump();
        await tester.tap(find.text('Steps'));
        await tester.pump();
        expect(requests, [false, false]);
        expect(find.text('Body'), findsOneWidget);

        await pump(null, false);
        expect(find.text('Body'), findsOneWidget);
        expect(requests, [false, false]);
        await tester.tap(find.text('Steps'));
        await tester.pumpAndSettle();
        expect(find.text('Body'), findsNothing);
        await pump(null, true);
        expect(find.text('Body'), findsNothing);
        expect(requests, [false, false, false]);
      },
    );

    testWidgets('control is released before a simultaneous completion', (
      tester,
    ) async {
      final requests = <bool>[];
      Future<void> pump(bool? expanded, AgentWorkPhase phase) => pumpAgent(
        tester,
        _Disclosure(
          phase: phase,
          expanded: expanded,
          onExpandedChanged: requests.add,
        ),
      );
      await pump(true, AgentWorkPhase.working);
      await pump(null, AgentWorkPhase.settled);
      await tester.pumpAndSettle();
      expect(requests, [false]);
      expect(find.text('Body'), findsNothing);
      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);
      expect(requests, [false, true]);
    });

    testWidgets('toggles while working use the current callback', (
      tester,
    ) async {
      final oldRequests = <bool>[];
      final currentRequests = <bool>[];
      Future<void> pump(AgentWorkPhase phase, ValueChanged<bool> callback) =>
          pumpAgent(
            tester,
            _Disclosure(
              phase: phase,
              policy: _parity,
              onExpandedChanged: callback,
            ),
          );
      await pump(AgentWorkPhase.working, oldRequests.add);
      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      expect(oldRequests, [false]);
      expect(find.text('Body'), findsNothing);
      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      expect(oldRequests, [false, true]);
      await pump(AgentWorkPhase.settled, currentRequests.add);
      await tester.pumpAndSettle();
      expect(oldRequests, [false, true]);
      expect(currentRequests, [false]);
      expect(find.text('Body'), findsNothing);
      await tester.tap(find.text('Steps'));
      await tester.pump();
      expect(currentRequests, [false, true]);
    });
  });

  group('lifecycle requests (ported)', () {
    testWidgets('a controlled surface emits collapse and reopen requests', (
      tester,
    ) async {
      final key = GlobalKey<_PhaseHarnessState>();
      await pumpAgent(
        tester,
        _PhaseHarness(
          key: key,
          initial: AgentWorkPhase.working,
          expanded: true,
        ),
      );

      key.currentState!.move(AgentWorkPhase.settled);
      await tester.pump();
      key.currentState!.move(AgentWorkPhase.working);
      await tester.pump();

      expect(key.currentState!.requests, [false, true]);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('a surface can opt out of collapsing when settled', (
      tester,
    ) async {
      final key = GlobalKey<_PhaseHarnessState>();
      await pumpAgent(
        tester,
        _PhaseHarness(
          key: key,
          initial: AgentWorkPhase.working,
          policy: const AgentDisclosurePolicy(collapseWhenSettled: false),
        ),
      );

      key.currentState!.move(AgentWorkPhase.settled);
      await tester.pumpAndSettle();

      expect(key.currentState!.requests, isEmpty);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('a controlled closed surface requests open and close', (
      tester,
    ) async {
      // The registry activity and execution cases: a controlled surface opens
      // only when its host accepts the request.
      final key = GlobalKey<_PhaseHarnessState>();
      await pumpAgent(
        tester,
        _PhaseHarness(
          key: key,
          initial: AgentWorkPhase.settled,
          expanded: false,
        ),
      );

      expect(find.text('Body'), findsNothing);
      key.currentState!.move(AgentWorkPhase.working);
      await tester.pump();
      expect(find.text('Body'), findsNothing);
      key.currentState!.move(AgentWorkPhase.settled);
      await tester.pumpAndSettle();

      expect(key.currentState!.requests, [true, false]);
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('a settled surface stays toggleable', (tester) async {
      final key = GlobalKey<_PhaseHarnessState>();
      await pumpAgent(
        tester,
        _PhaseHarness(key: key, initial: AgentWorkPhase.working),
      );

      key.currentState!.move(AgentWorkPhase.settled);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('permission statuses request open, then a terminal close', (
      tester,
    ) async {
      final key = GlobalKey<_PhaseHarnessState>();
      await pumpAgent(
        tester,
        _PhaseHarness(
          key: key,
          initial: AgentPermissionStatus.pending.phase,
          expanded: false,
        ),
      );

      key.currentState!.move(AgentPermissionStatus.deciding.phase);
      await tester.pump();
      key.currentState!.move(AgentPermissionStatus.complete.phase);
      await tester.pump();

      expect(key.currentState!.requests, [true, false]);
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('details stay independently toggleable in flight', (
      tester,
    ) async {
      final key = GlobalKey<_PhaseHarnessState>();
      await pumpAgent(
        tester,
        _PhaseHarness(
          key: key,
          initial: AgentPermissionStatus.pending.phase,
          defaultExpanded: false,
        ),
        disableAnimations: true,
      );

      key.currentState!.move(AgentPermissionStatus.deciding.phase);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);

      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);

      key.currentState!.move(AgentPermissionStatus.complete.phase);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('steps that all finish collapse, and new work reopens', (
      tester,
    ) async {
      // The registry plan counted cancelled items as settled.
      AgentWorkPhase phaseOf(List<AgentStepStatus> steps) =>
          steps.every((status) => status.isDone)
          ? AgentWorkPhase.settled
          : AgentWorkPhase.working;
      final key = GlobalKey<_PhaseHarnessState>();
      await pumpAgent(
        tester,
        _PhaseHarness(
          key: key,
          initial: phaseOf([AgentStepStatus.active, AgentStepStatus.pending]),
        ),
      );
      key.currentState!.move(
        phaseOf([AgentStepStatus.complete, AgentStepStatus.cancelled]),
      );
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
      key.currentState!.move(
        phaseOf([AgentStepStatus.active, AgentStepStatus.pending]),
      );
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('a running tool stays toggleable and reopens on a new run', (
      tester,
    ) async {
      final key = GlobalKey<_PhaseHarnessState>();
      await pumpAgent(
        tester,
        _PhaseHarness(key: key, initial: AgentExecutionStatus.running.phase),
        disableAnimations: true,
      );
      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsNothing);
      key.currentState!.move(AgentExecutionStatus.success.phase);
      await tester.pumpAndSettle();
      key.currentState!.move(AgentExecutionStatus.running.phase);
      await tester.pumpAndSettle();
      expect(find.text('Body'), findsOneWidget);
    });
  });

  group('the reader decides within a run', () {
    Future<GlobalKey<_PhaseHarnessState>> start(WidgetTester tester) async {
      final key = GlobalKey<_PhaseHarnessState>();
      await pumpAgent(
        tester,
        _PhaseHarness(
          key: key,
          initial: AgentToolCallStatus.inputStreaming.phase,
        ),
        disableAnimations: true,
      );
      return key;
    }

    testWidgets('a success collapses an untouched surface', (tester) async {
      final key = await start(tester);
      key.currentState!.move(AgentToolCallStatus.running.phase);
      key.currentState!.move(AgentToolCallStatus.succeeded.phase);
      await tester.pumpAndSettle();
      expect(key.currentState!.requests, [false]);
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('a failure stays open', (tester) async {
      final key = await start(tester);
      key.currentState!.move(AgentToolCallStatus.running.phase);
      key.currentState!.move(AgentToolCallStatus.failed.phase);
      await tester.pumpAndSettle();
      expect(key.currentState!.requests, isEmpty);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('a reader who opened it keeps it open past success', (
      tester,
    ) async {
      final key = await start(tester);
      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      expect(key.currentState!.controller.readerToggled, isTrue);

      key.currentState!.move(AgentToolCallStatus.succeeded.phase);
      await tester.pumpAndSettle();
      expect(key.currentState!.requests, [false, true]);
      expect(find.text('Body'), findsOneWidget);
    });

    testWidgets('a reader who closed it keeps it closed when work resumes', (
      tester,
    ) async {
      // Approval pauses the run and running resumes it: the same run.
      final key = await start(tester);
      key.currentState!.move(AgentToolCallStatus.awaitingApproval.phase);
      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      key.currentState!.move(AgentToolCallStatus.running.phase);
      key.currentState!.move(AgentToolCallStatus.failed.phase);
      await tester.pumpAndSettle();
      expect(key.currentState!.requests, [false]);
      expect(find.text('Body'), findsNothing);
    });

    testWidgets('the next run starts fresh', (tester) async {
      final key = await start(tester);
      await tester.tap(find.text('Steps'));
      await tester.pumpAndSettle();
      key.currentState!.move(AgentToolCallStatus.succeeded.phase);
      expect(key.currentState!.controller.readerToggled, isTrue);

      key.currentState!.move(AgentToolCallStatus.running.phase);
      await tester.pumpAndSettle();
      expect(key.currentState!.controller.readerToggled, isFalse);
      expect(key.currentState!.requests, [false, true]);
      expect(find.text('Body'), findsOneWidget);
    });
  });

  test('listeners hear changes to the stored value only', () {
    final controller = AgentDisclosureController(defaultExpanded: false);
    addTearDown(controller.dispose);
    var notified = 0;
    controller.addListener(() => notified++);

    controller.updatePhase(AgentWorkPhase.working);
    expect(controller.expanded, isTrue);
    expect(notified, 1);
    controller.toggle(true);
    expect(notified, 1);
    controller.updateExpanded(false);
    expect(controller.isControlled, isTrue);
    expect(notified, 2);
    controller.toggle(true);
    expect(controller.expanded, isFalse, reason: 'The host decides.');
    expect(notified, 2);
  });
}

/// A Remix disclosure whose open state an [AgentDisclosureController] owns,
/// configured from widget properties as a component would be.
class _Disclosure extends StatefulWidget {
  const _Disclosure({
    this.phase = AgentWorkPhase.settled,
    this.expanded,
    this.defaultExpanded = true,
    this.policy = const AgentDisclosurePolicy(),
    this.onExpandedChanged,
    this.onController,
  });

  final AgentWorkPhase phase;
  final bool? expanded;
  final bool defaultExpanded;
  final AgentDisclosurePolicy policy;
  final ValueChanged<bool>? onExpandedChanged;
  final ValueChanged<AgentDisclosureController>? onController;

  @override
  State<_Disclosure> createState() => _DisclosureState();
}

class _DisclosureState extends State<_Disclosure> {
  late final AgentDisclosureController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AgentDisclosureController(
      phase: widget.phase,
      expanded: widget.expanded,
      defaultExpanded: widget.defaultExpanded,
      policy: widget.policy,
      onExpandedChanged: widget.onExpandedChanged,
    )..addListener(_rebuild);
    widget.onController?.call(_controller);
  }

  void _rebuild() => setState(() {});

  @override
  void didUpdateWidget(_Disclosure oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller
      ..policy = widget.policy
      ..onExpandedChanged = widget.onExpandedChanged
      ..updateExpanded(widget.expanded)
      ..updatePhase(widget.phase);
  }

  @override
  Widget build(BuildContext context) => RemixDisclosure(
    expanded: _controller.expanded,
    onExpandedChanged: _controller.toggle,
    trigger: const Text('Steps'),
    content: const Text('Body'),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

/// Drives a [_Disclosure] through phases and records its requests.
class _PhaseHarness extends StatefulWidget {
  const _PhaseHarness({
    super.key,
    required this.initial,
    this.expanded,
    this.defaultExpanded = true,
    this.policy = const AgentDisclosurePolicy(),
  });

  final AgentWorkPhase initial;
  final bool? expanded;
  final bool defaultExpanded;
  final AgentDisclosurePolicy policy;

  @override
  State<_PhaseHarness> createState() => _PhaseHarnessState();
}

class _PhaseHarnessState extends State<_PhaseHarness> {
  late var phase = widget.initial;
  final requests = <bool>[];
  late AgentDisclosureController controller;

  /// Moves the work; several moves before a pump apply in order.
  void move(AgentWorkPhase next) {
    controller.updatePhase(next);
    setState(() => phase = next);
  }

  @override
  Widget build(BuildContext context) => _Disclosure(
    phase: phase,
    expanded: widget.expanded,
    defaultExpanded: widget.defaultExpanded,
    policy: widget.policy,
    onExpandedChanged: requests.add,
    onController: (value) => controller = value,
  );
}

class _SetStateHost extends StatefulWidget {
  const _SetStateHost();

  @override
  State<_SetStateHost> createState() => _SetStateHostState();
}

class _SetStateHostState extends State<_SetStateHost> {
  var status = AgentToolCallStatus.running;
  var requests = 0;

  void advance() => setState(() => status = AgentToolCallStatus.succeeded);

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 300,
    width: 400,
    child: ListView.builder(
      itemCount: 1,
      itemBuilder: (context, index) => AgentToolCall(
        call: AgentToolCallPart(
          id: 'call',
          name: 'terminal.run',
          status: status,
          output: 'ok',
        ),
        // The host reacts to the lifecycle by rebuilding itself.
        onExpandedChanged: (_) => setState(() => requests++),
      ),
    ),
  );
}

void lifecycleCallbackTests() {
  testWidgets('a lifecycle callback can set state on an ancestor', (
    tester,
  ) async {
    await pumpAgent(tester, const _SetStateHost());
    final host = tester.state<_SetStateHostState>(find.byType(_SetStateHost));

    host.advance();
    await tester.pump();
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(host.requests, 1);
  });
}
