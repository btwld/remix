import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/glyphs.dart';
import '../helpers/mock.dart';
import '../helpers/pump.dart';

const _allowOnce = ValueKey('agent-tool-call-allow-once');
const _deny = ValueKey('agent-tool-call-deny');
const _alwaysAllow = ValueKey('agent-tool-call-always-allow');

/// Hosts one tool call that the test moves through its lifecycle.
Future<ValueNotifier<AgentToolCallPart>> _pump(
  WidgetTester tester,
  AgentToolCallPart call, {
  ValueChanged<AgentApprovalDecision>? onDecision,
  bool withDecision = true,
  AgentToolCallStyler style = const AgentToolCallStyler.create(),
  Map<String, AgentToolRenderer>? renderers,
}) async {
  final notifier = ValueNotifier(call);
  addTearDown(notifier.dispose);
  Widget child = ValueListenableBuilder<AgentToolCallPart>(
    valueListenable: notifier,
    builder: (context, call, _) => AgentToolCall(
      call: call,
      onDecision: withDecision ? (onDecision ?? (_) {}) : null,
      glyphBuilder: testGlyphs,
      style: style,
    ),
  );
  if (renderers != null) {
    child = AgentToolRenderers(renderers: renderers, child: child);
  }
  await pumpAgent(
    tester,
    SizedBox(
      width: 768,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Focus(focusNode: _start, child: const SizedBox(height: 1)),
          child,
        ],
      ),
    ),
  );
  return notifier;
}

/// Where keyboard traversal starts, just before the tool call.
final _start = FocusNode(debugLabel: 'start');

Future<void> _tab(WidgetTester tester, int times) async {
  _start.requestFocus();
  await tester.pump();
  for (var i = 0; i < times; i++) {
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
  }
}

/// The row's text, summary then meta.
Finder _rowText(String text) => find.textContaining(text, findRichText: true);

Future<void> _move(
  WidgetTester tester,
  ValueNotifier<AgentToolCallPart> notifier,
  AgentToolCallPart next,
) async {
  notifier.value = next;
  await tester.pumpAndSettle();
}

bool _isEnabled(WidgetTester tester, Key key) =>
    tester.widget<RemixButton>(find.byKey(key)).enabled;

void main() {
  group('the approval card', () {
    testWidgets(
      'adopts a recorded decision on mount and re-arms when cleared',
      (tester) async {
        final decisions = <AgentApprovalDecision>[];
        final notifier = await _pump(
          tester,
          approvalCall.copyWith(decision: AgentApprovalDecision.allowOnce),
          onDecision: decisions.add,
        );
        for (final key in [_allowOnce, _deny, _alwaysAllow]) {
          expect(_isEnabled(tester, key), isFalse);
          await tester.tap(find.byKey(key), warnIfMissed: false);
        }
        expect(decisions, isEmpty);

        await _move(tester, notifier, approvalCall);
        expect(_isEnabled(tester, _deny), isTrue);
        await tester.tap(find.byKey(_deny));
        expect(decisions, [AgentApprovalDecision.deny]);
      },
    );

    testWidgets('asks the question with the tool, description and input', (
      tester,
    ) async {
      await _pump(tester, approvalCall);

      expect(find.text('Run the cart tests?'), findsOneWidget);
      expect(find.text('terminal.run'), findsOneWidget);
      expect(find.text(approvalCall.description!), findsOneWidget);
      expect(find.text('Needs approval'), findsOneWidget);
      expect(find.byType(RemixDataList), findsOneWidget);
      for (final input in approvalCall.input) {
        expect(find.text(input.label), findsOneWidget);
        expect(find.text(input.value), findsOneWidget);
      }
      expect(findGlyph(AgentGlyph.approval), findsOneWidget);
      // The card replaces the row; there is no output well to open.
      expect(find.byType(RemixDisclosure), findsNothing);
    });

    testWidgets('puts the scoped allow first and the primary decision last', (
      tester,
    ) async {
      await _pump(tester, approvalCall);

      final always = tester.getCenter(find.byKey(_alwaysAllow));
      final deny = tester.getCenter(find.byKey(_deny));
      final allow = tester.getCenter(find.byKey(_allowOnce));
      expect(always.dx, lessThan(deny.dx));
      expect(deny.dx, lessThan(allow.dx));
      expect(
        find.descendant(
          of: find.byKey(_alwaysAllow),
          matching: find.text('Always allow terminal.run', findRichText: true),
        ),
        findsOneWidget,
      );

      // Focus order follows: Always allow, Deny, then Allow once.
      final focused = <String>[];
      for (var i = 1; i <= 3; i++) {
        await _tab(tester, i);
        final context = FocusManager.instance.primaryFocus!.context!;
        focused.add(
          context.findAncestorWidgetOfExactType<RemixButton>()!.label,
        );
      }
      expect(focused, ['Always allow terminal.run', 'Deny', 'Allow once']);
    });

    testWidgets('omits Always allow when the host does not offer it', (
      tester,
    ) async {
      await pumpAgent(
        tester,
        AgentToolCall(
          call: approvalCall,
          offerAlwaysAllow: false,
          onDecision: (_) {},
        ),
      );

      expect(find.byKey(_alwaysAllow), findsNothing);
      expect(find.byKey(_allowOnce), findsOneWidget);
    });

    testWidgets('takes one decision per request', (tester) async {
      final decisions = <AgentApprovalDecision>[];
      final notifier = await _pump(
        tester,
        approvalCall,
        onDecision: decisions.add,
      );

      await tester.tap(find.byKey(_allowOnce));
      await tester.pump();
      // A second press, or a change of mind, before the host records the
      // first decision is refused.
      await tester.tap(find.byKey(_allowOnce), warnIfMissed: false);
      await tester.tap(find.byKey(_deny), warnIfMissed: false);
      await tester.pump();
      expect(decisions, [AgentApprovalDecision.allowOnce]);
      expect(_isEnabled(tester, _allowOnce), isFalse);
      expect(_isEnabled(tester, _deny), isFalse);
      expect(_isEnabled(tester, _alwaysAllow), isFalse);

      // The same call asking again is a new request.
      await _move(tester, notifier, runningCall);
      await _move(tester, notifier, approvalCall);
      expect(_isEnabled(tester, _deny), isTrue);
      await tester.tap(find.byKey(_deny));
      await tester.pump();
      expect(decisions, [
        AgentApprovalDecision.allowOnce,
        AgentApprovalDecision.deny,
      ]);

      // So is a different call that asks.
      await _move(
        tester,
        notifier,
        const AgentToolCallPart(
          id: 'call-2',
          name: 'terminal.run',
          status: AgentToolCallStatus.awaitingApproval,
        ),
      );
      await tester.tap(find.byKey(_alwaysAllow));
      await tester.pump();
      expect(decisions.last, AgentApprovalDecision.alwaysAllow);
    });

    testWidgets('keeps a pending decision when a lazy list recycles it', (
      tester,
    ) async {
      final decisions = <AgentApprovalDecision>[];
      final scroll = ScrollController();
      addTearDown(scroll.dispose);
      await pumpAgent(
        tester,
        SizedBox(
          width: 768,
          height: 400,
          child: AgentConversation(
            scrollController: scroll,
            children: [
              for (var i = 0; i < 30; i++) const SizedBox(height: 200),
              AgentToolCall(
                call: approvalCall,
                onDecision: decisions.add,
                glyphBuilder: testGlyphs,
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_allowOnce));
      await tester.pump();
      expect(decisions, [AgentApprovalDecision.allowOnce]);

      // The host has not recorded the decision yet. Scroll the card far out
      // of the list and back: it must not offer the decision again.
      scroll.jumpTo(0);
      await tester.pumpAndSettle();
      expect(find.byKey(_allowOnce), findsNothing);
      scroll.jumpTo(scroll.position.maxScrollExtent);
      await tester.pumpAndSettle();

      expect(_isEnabled(tester, _allowOnce), isFalse);
      await tester.tap(find.byKey(_allowOnce), warnIfMissed: false);
      await tester.tap(find.byKey(_deny), warnIfMissed: false);
      await tester.pump();
      expect(decisions, [AgentApprovalDecision.allowOnce]);
    });

    testWidgets('disables its actions without a decision handler', (
      tester,
    ) async {
      await _pump(tester, approvalCall, withDecision: false);

      expect(_isEnabled(tester, _allowOnce), isFalse);
      expect(_isEnabled(tester, _deny), isFalse);
      expect(_isEnabled(tester, _alwaysAllow), isFalse);
    });

    testWidgets('returns keyboard focus to the row once the call moves on', (
      tester,
    ) async {
      late ValueNotifier<AgentToolCallPart> notifier;
      notifier = await _pump(
        tester,
        approvalCall,
        onDecision: (_) => notifier.value = runningCall,
      );

      await _tab(tester, 3);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.byKey(_allowOnce), findsNothing);
      expect(
        FocusManager.instance.primaryFocus?.debugLabel,
        'AgentToolCall row',
      );
    });
  });

  group('the row', () {
    for (final slot in ['summary', 'meta', 'toolId']) {
      testWidgets('honors the row $slot text directive', (tester) async {
        final uppercase = TextStyler().uppercase();
        await _pump(
          tester,
          doneCall,
          style: AgentToolCallStyler(
            summary: slot == 'summary' ? uppercase : null,
            meta: slot == 'meta' ? uppercase : null,
            toolId: slot == 'toolId' ? uppercase : null,
          ),
        );
        final summary = slot == 'summary' ? 'TESTS PASSED' : 'Tests passed';
        final meta = slot == 'meta'
            ? '31 TESTS · 2.9S · ALLOWED ONCE'
            : '31 tests · 2.9s · Allowed once';
        final toolId = slot == 'toolId' ? 'TERMINAL.RUN' : 'terminal.run';
        expect(_rowText(summary), findsOneWidget);
        expect(_rowText('$meta · $toolId'), findsOneWidget);
      });
    }

    testWidgets('honors row paragraph configuration and keeps one ellipsis', (
      tester,
    ) async {
      const scaler = TextScaler.linear(1.5);
      const strut = StrutStyle(fontSize: 18);
      const height = TextHeightBehavior(applyHeightToFirstAscent: false);
      const color = Color(0xFF123456);
      await _pump(
        tester,
        doneCall,
        style: AgentToolCallStyler(
          summary: TextStyler()
              .textScaler(scaler)
              .strutStyle(StrutStyleMix(fontSize: 18))
              .textAlign(TextAlign.end)
              .textDirection(TextDirection.rtl)
              .locale(const Locale('ar'))
              .textWidthBasis(TextWidthBasis.longestLine)
              .textHeightBehavior(
                TextHeightBehaviorMix(applyHeightToFirstAscent: false),
              )
              .selectionColor(color)
              .maxLines(3)
              .overflow(TextOverflow.visible),
          meta: TextStyler().locale(const Locale('fr')),
          toolId: TextStyler().locale(const Locale('en')),
        ),
      );
      final text = tester.widget<Text>(
        find.ancestor(
          of: _rowText('Tests passed'),
          matching: find.byType(Text),
        ),
      );
      expect(text.textScaler, scaler);
      expect(text.strutStyle, strut);
      expect(text.textAlign, TextAlign.end);
      expect(text.textDirection, TextDirection.rtl);
      expect(text.locale, const Locale('ar'));
      expect(text.textWidthBasis, TextWidthBasis.longestLine);
      expect(text.textHeightBehavior, height);
      expect(text.selectionColor, color);
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(text.softWrap, isFalse);
      final spans = (text.textSpan! as TextSpan).children!;
      final trailing = spans.last as TextSpan;
      expect((trailing.children!.first as TextSpan).locale, const Locale('fr'));
      expect((trailing.children!.last as TextSpan).locale, const Locale('en'));
    });

    testWidgets('shows a running call with its output open', (tester) async {
      await _pump(tester, runningCall);

      expect(_rowText('Running the cart tests'), findsOneWidget);
      expect(_rowText('terminal.run'), findsOneWidget);
      expect(find.text('Running'), findsOneWidget);
      expect(findGlyph(AgentGlyph.tool), findsOneWidget);
      expect(findGlyph(AgentGlyph.toolRunning), findsOneWidget);
      expect(findGlyph(AgentGlyph.disclosureOpen), findsOneWidget);
      expect(find.text(runningOutput), findsOneWidget);
    });

    testWidgets('records the decision in the meta and collapses on success', (
      tester,
    ) async {
      final notifier = await _pump(tester, runningCall);
      await _move(tester, notifier, doneCall);

      expect(_rowText('Tests passed'), findsOneWidget);
      expect(
        _rowText('31 tests · 2.9s · Allowed once · terminal.run'),
        findsOneWidget,
      );
      expect(find.text('Completed'), findsOneWidget);
      expect(findGlyph(AgentGlyph.toolSucceeded), findsOneWidget);
      expect(findGlyph(AgentGlyph.disclosureClosed), findsOneWidget);
      expect(find.text(runningOutput), findsNothing);
    });

    testWidgets('keeps a failure open with its error after the output', (
      tester,
    ) async {
      final notifier = await _pump(tester, runningCall);
      await _move(tester, notifier, failedCall);

      expect(find.text('Failed'), findsOneWidget);
      expect(findGlyph(AgentGlyph.toolFailed), findsOneWidget);
      expect(findGlyph(AgentGlyph.disclosureOpen), findsOneWidget);
      final output = tester.getRect(find.text(failedOutput));
      final error = tester.getRect(find.text(failedError));
      expect(error.top, greaterThanOrEqualTo(output.bottom));
    });

    testWidgets('a failure loaded from history starts open', (tester) async {
      await _pump(tester, failedCall);

      expect(find.text(failedError), findsOneWidget);
    });

    testWidgets('shows a denied call as a row with nothing to open', (
      tester,
    ) async {
      await _pump(tester, deniedCall);

      expect(_rowText('Run the cart tests'), findsOneWidget);
      expect(_rowText('Denied · terminal.run'), findsOneWidget);
      expect(find.text('Denied'), findsOneWidget);
      expect(findGlyph(AgentGlyph.toolDenied), findsOneWidget);
      expect(find.byType(RemixDisclosure), findsNothing);
      expect(findGlyph(AgentGlyph.disclosureClosed), findsNothing);
    });

    testWidgets('a reader toggle wins over the lifecycle', (tester) async {
      final notifier = await _pump(tester, runningCall);

      // The reader closes the running output, then reopens it; success does
      // not collapse what the reader chose to keep open.
      await tester.tap(_rowText('Running the cart tests'));
      await tester.pumpAndSettle();
      expect(find.text(runningOutput), findsNothing);
      await tester.tap(_rowText('Running the cart tests'));
      await tester.pumpAndSettle();
      await _move(tester, notifier, doneCall);

      expect(find.text(runningOutput), findsOneWidget);
    });

    testWidgets('the output well follows the newest line while running', (
      tester,
    ) async {
      final lines = [for (var i = 0; i < 30; i++) 'line $i'].join('\n');
      final notifier = await _pump(
        tester,
        runningCall.copyWith(output: lines),
        style: AgentToolCallStyler(outputMaxHeight: 60),
      );
      await tester.pump();
      ScrollPosition position() => tester
          .state<ScrollableState>(
            find.descendant(
              of: find.byType(SingleChildScrollView),
              matching: find.byType(Scrollable),
            ),
          )
          .position;

      expect(position().maxScrollExtent, greaterThan(0));
      expect(position().pixels, position().maxScrollExtent);

      notifier.value = runningCall.copyWith(output: '$lines\nline 30\nline 31');
      await tester.pump();
      await tester.pump();
      expect(position().pixels, position().maxScrollExtent);
    });

    testWidgets('styles a status through its variant', (tester) async {
      const red = Color(0xFFCE2C31);
      await _pump(
        tester,
        failedCall,
        style: AgentToolCallStyler().onStatus(
          AgentToolCallStatus.failed,
          AgentToolCallStyler(statusLabel: TextStyler().color(red)),
        ),
      );

      final failed = tester.widget<Text>(find.text('Failed'));
      expect(failed.style?.color, red);
    });

    testWidgets('resolves hover, press and focus variants on the row', (
      tester,
    ) async {
      const idle = Color(0xFF111111);
      const hovered = Color(0xFF222222);
      const pressed = Color(0xFF333333);
      const focused = Color(0xFF444444);
      await _pump(
        tester,
        runningCall,
        style:
            AgentToolCallStyler(
                  row: FlexBoxStyler().color(idle).onPressed(.color(pressed)),
                )
                .onHovered(
                  AgentToolCallStyler(row: FlexBoxStyler().color(hovered)),
                )
                .onFocused(
                  AgentToolCallStyler(row: FlexBoxStyler().color(focused)),
                ),
      );
      Color? rowColor() => tester
          .widgetList<DecoratedBox>(
            find.descendant(
              of: find.byType(RemixDisclosure),
              matching: find.byType(DecoratedBox),
            ),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .map((decoration) => decoration.color)
          .where((color) => [idle, hovered, pressed, focused].contains(color))
          .single;

      expect(rowColor(), idle);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: const Offset(799, 599));
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(_rowText('Running the cart tests')));
      await tester.pump();
      expect(rowColor(), hovered);
      await mouse.down(tester.getCenter(_rowText('Running the cart tests')));
      await tester.pump(const Duration(milliseconds: 150));
      expect(rowColor(), pressed);
      await mouse.up();
      await mouse.moveTo(const Offset(799, 599));
      await tester.pumpAndSettle();
      await _tab(tester, 1);
      expect(rowColor(), focused);
    });

    testWidgets('a row without output still resolves hover styling', (
      tester,
    ) async {
      const hovered = Color(0xFF222222);
      await _pump(
        tester,
        deniedCall,
        style: AgentToolCallStyler(
          row: FlexBoxStyler().onHovered(.color(hovered)),
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: const Offset(799, 599));
      addTearDown(mouse.removePointer);
      await mouse.moveTo(tester.getCenter(_rowText('Run the cart tests')));
      await tester.pump();
      expect(
        tester
            .widgetList<DecoratedBox>(find.byType(DecoratedBox))
            .map((box) => box.decoration)
            .whereType<BoxDecoration>()
            .any((decoration) => decoration.color == hovered),
        isTrue,
      );
    });

    testWidgets('a host icon replaces the tool glyph', (tester) async {
      await pumpAgent(
        tester,
        AgentToolCall(
          call: deniedCall,
          icon: const SizedBox(key: ValueKey('terminal'), width: 16),
          glyphBuilder: testGlyphs,
        ),
      );

      expect(find.byKey(const ValueKey('terminal')), findsOneWidget);
      expect(findGlyph(AgentGlyph.tool), findsNothing);
    });

    testWidgets('maps tool names to themed icons with fallback and override', (
      tester,
    ) async {
      const color = Color(0xFF123456);
      final names = <String>[];
      await pumpAgent(
        tester,
        AgentGlyphs(
          builder: testGlyphs,
          toolIconBuilder: (context, name, spec) {
            names.add(name);
            expect(spec.color, color);
            return name == 'terminal.run'
                ? const Icon(IconData(0xe001), key: ValueKey('named-tool'))
                : null;
          },
          child: Column(
            children: [
              AgentToolCall(
                call: deniedCall,
                style: AgentToolCallStyler(icon: IconStyler().color(color)),
              ),
              AgentToolCall(
                call: const AgentToolCallPart(
                  id: 'unknown',
                  name: 'unknown',
                  status: AgentToolCallStatus.denied,
                ),
                style: AgentToolCallStyler(icon: IconStyler().color(color)),
              ),
              const AgentToolCall(
                call: deniedCall,
                icon: SizedBox(key: ValueKey('explicit-tool')),
              ),
            ],
          ),
        ),
      );

      expect(names, ['terminal.run', 'unknown']);
      expect(find.byKey(const ValueKey('named-tool')), findsOneWidget);
      expect(find.byKey(const ValueKey('explicit-tool')), findsOneWidget);
      expect(findGlyph(AgentGlyph.tool), findsOneWidget);
      expect(
        IconTheme.of(
          tester.element(find.byKey(const ValueKey('named-tool'))),
        ).color,
        color,
      );
    });

    testWidgets('labels the call and its output for assistive technology', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await _pump(tester, failedCall);

      expect(find.bySemanticsLabel('Tool call'), findsOneWidget);
      expect(find.bySemanticsLabel(RegExp('^Tool output')), findsOneWidget);
      semantics.dispose();
    });
  });

  group('tool renderers', () {
    testWidgets('a registered tool renders its own widget from the call', (
      tester,
    ) async {
      AgentToolCallPart? received;
      await _pump(
        tester,
        doneCall,
        renderers: {
          'terminal.run': (context, call) {
            received = call;
            return const Text('custom terminal');
          },
        },
      );

      expect(find.text('custom terminal'), findsOneWidget);
      expect(find.text('Tests passed'), findsNothing);
      expect(received, doneCall);
    });

    testWidgets('approval stays the standard guarded card', (tester) async {
      await _pump(
        tester,
        approvalCall,
        renderers: {'terminal.run': (context, call) => const Text('custom')},
      );

      expect(find.text('custom'), findsNothing);
      expect(find.byKey(_allowOnce), findsOneWidget);
    });

    testWidgets('an unregistered tool falls back to the standard row', (
      tester,
    ) async {
      await _pump(
        tester,
        doneCall,
        renderers: {'coverage': (context, call) => const Text('chart')},
      );

      expect(find.text('chart'), findsNothing);
      expect(find.text('Completed'), findsOneWidget);
    });
  });

  testWidgets('a widget glyph builder wins over the scope', (tester) async {
    await pumpAgent(
      tester,
      AgentGlyphs(
        builder: (context, glyph, spec) =>
            SizedBox(key: ValueKey('scope-${glyph.name}')),
        child: Column(
          children: [
            const AgentToolCall(call: deniedCall),
            AgentToolCall(call: deniedCall, glyphBuilder: testGlyphs),
          ],
        ),
      ),
    );

    expect(find.byKey(const ValueKey('scope-tool')), findsOneWidget);
    expect(findGlyph(AgentGlyph.tool), findsOneWidget);
  });

  testWidgets('without glyphs the row still lays out', (tester) async {
    await pumpAgent(
      tester,
      const SizedBox(width: 400, child: AgentToolCall(call: doneCall)),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Completed'), findsOneWidget);
    expect(
      tester.renderObject<RenderBox>(find.byType(AgentToolCall)).size.width,
      400,
    );
  });

  testWidgets(
    'the approval heading and footer fit at a narrow width and large text',
    (tester) async {
      final decisions = <AgentApprovalDecision>[];
      await pumpAgent(
        tester,
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: SizedBox(
              width: 300,
              child: AgentToolCall(
                call: approvalCall,
                onDecision: decisions.add,
                glyphBuilder: testGlyphs,
              ),
            ),
          ),
        ),
        surface: const Size(800, 4000),
      );

      expect(tester.takeException(), isNull);
      final title = tester.getRect(find.text('Run the cart tests?'));
      expect(title.width, greaterThan(0));
      expect(title.left, greaterThanOrEqualTo(0));
      expect(title.right, lessThanOrEqualTo(300));
      expect(find.text('Needs approval'), findsOneWidget);
      for (final key in [_alwaysAllow, _deny, _allowOnce]) {
        expect(find.byKey(key), findsOneWidget);
        final rect = tester.getRect(find.byKey(key));
        expect(rect.left, greaterThanOrEqualTo(0));
        expect(rect.right, lessThanOrEqualTo(300));
      }
      await tester.tap(find.byKey(_allowOnce));
      expect(decisions, [AgentApprovalDecision.allowOnce]);
    },
  );
}
