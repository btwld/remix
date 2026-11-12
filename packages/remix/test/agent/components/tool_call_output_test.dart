import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

import '../helpers/mock.dart';
import '../helpers/pump.dart';

const _toggle = ValueKey('agent-tool-call-output-toggle');
final _lines = List.generate(12, (i) => 'line $i').join('\n');

Future<ValueNotifier<AgentToolCallPart>> _pump(
  WidgetTester tester, {
  String? output,
  FocusNode? start,
  AgentToolCallStyler? style,
}) async {
  final call = ValueNotifier(runningCall.copyWith(output: output ?? _lines));
  addTearDown(call.dispose);
  await pumpAgent(
    tester,
    SizedBox(
      width: 500,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (start != null)
            Focus(focusNode: start, child: const SizedBox(height: 1)),
          ValueListenableBuilder<AgentToolCallPart>(
            valueListenable: call,
            builder: (context, call, _) => AgentToolCall(
              call: call,
              style: style ?? AgentToolCallStyler(outputMaxHeight: 60),
            ),
          ),
        ],
      ),
    ),
  );
  await tester.pumpAndSettle();
  return call;
}

double _viewportHeight(WidgetTester tester) =>
    tester.getSize(find.byType(SingleChildScrollView)).height;

void main() {
  testWidgets('overflow offers Show all and expands to the full content', (
    tester,
  ) async {
    await _pump(tester);
    expect(find.text('Show all'), findsOneWidget);
    expect(_viewportHeight(tester), 60);
    final contentHeight = tester.getSize(find.text(_lines)).height;
    expect(contentHeight, greaterThan(60));

    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    expect(find.text('Show less'), findsOneWidget);
    expect(_viewportHeight(tester), contentHeight);

    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    expect(_viewportHeight(tester), 60);
    expect(find.text('Show all'), findsOneWidget);
  });

  testWidgets('short output and unbounded output offer no toggle', (
    tester,
  ) async {
    await _pump(tester, output: 'short');
    expect(find.byKey(_toggle), findsNothing);
    expect(_viewportHeight(tester), lessThan(60));

    await _pump(tester, style: AgentToolCallStyler());
    expect(find.byKey(_toggle), findsNothing);
    expect(_viewportHeight(tester), tester.getSize(find.text(_lines)).height);
  });

  testWidgets('expansion survives updates, closing the well and failure', (
    tester,
  ) async {
    final call = await _pump(tester);
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    call.value = call.value.copyWith(output: '$_lines\nnewest line');
    await tester.pumpAndSettle();
    expect(find.text('Show less'), findsOneWidget);
    expect(
      _viewportHeight(tester),
      tester.getSize(find.text('$_lines\nnewest line')).height,
    );

    final row = find.textContaining(
      'Running the cart tests',
      findRichText: true,
    );
    await tester.tap(row);
    await tester.pumpAndSettle();
    expect(find.byKey(_toggle), findsNothing);
    await tester.tap(row);
    await tester.pumpAndSettle();
    expect(find.text('Show less'), findsOneWidget);

    call.value = call.value.copyWith(
      status: AgentToolCallStatus.failed,
      error: 'failure',
    );
    await tester.pumpAndSettle();
    expect(find.text('failure'), findsOneWidget);
    expect(find.text('Show less'), findsOneWidget);
    expect(_viewportHeight(tester), greaterThan(60));
  });

  testWidgets('streaming follows the latest line after restoring the limit', (
    tester,
  ) async {
    final call = await _pump(tester);
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    call.value = call.value.copyWith(output: '$_lines\nnewest line');
    await tester.pumpAndSettle();
    expect(
      _viewportHeight(tester),
      tester.getSize(find.text('$_lines\nnewest line')).height,
    );
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    final position = tester
        .state<ScrollableState>(find.byType(Scrollable))
        .position;
    expect(position.maxScrollExtent, greaterThan(0));
    expect(position.pixels, position.maxScrollExtent);
    call.value = call.value.copyWith(output: '$_lines\nnewest line\nnext line');
    await tester.pumpAndSettle();
    expect(position.pixels, position.maxScrollExtent);
  });

  testWidgets('a failure offers full output when only its error overflows', (
    tester,
  ) async {
    final call = await _pump(tester, output: 'short');
    call.value = call.value.copyWith(
      status: AgentToolCallStatus.failed,
      error: _lines,
    );
    await tester.pumpAndSettle();
    expect(find.text('Show all'), findsOneWidget);
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    expect(find.text('Show less'), findsOneWidget);
    expect(
      _viewportHeight(tester),
      tester.getSize(find.text('short')).height +
          tester.getSize(find.text(_lines)).height,
    );
  });

  testWidgets('expansion belongs to one call identity', (tester) async {
    final call = await _pump(tester);
    await tester.tap(find.byKey(_toggle));
    await tester.pumpAndSettle();
    call.value = AgentToolCallPart(
      id: 'another-call',
      name: 'terminal.run',
      status: AgentToolCallStatus.running,
      output: _lines,
    );
    await tester.pumpAndSettle();
    expect(find.text('Show all'), findsOneWidget);
    expect(_viewportHeight(tester), 60);
  });

  testWidgets(
    'the toggle disappears when content shrinks, even after reopening',
    (tester) async {
      final call = await _pump(tester);
      final row = find.textContaining(
        'Running the cart tests',
        findRichText: true,
      );
      await tester.tap(row);
      await tester.pumpAndSettle();
      call.value = call.value.copyWith(output: 'short');
      await tester.pumpAndSettle();
      await tester.tap(row);
      await tester.pumpAndSettle();
      expect(find.byKey(_toggle), findsNothing);

      call.value = call.value.copyWith(output: _lines);
      await tester.pumpAndSettle();
      expect(find.text('Show all'), findsOneWidget);
      call.value = call.value.copyWith(output: 'short');
      await tester.pumpAndSettle();
      expect(find.byKey(_toggle), findsNothing);
    },
  );

  testWidgets(
    'the output toggle has button semantics and keyboard activation',
    (tester) async {
      final semantics = tester.ensureSemantics();
      final start = FocusNode(debugLabel: 'start');
      addTearDown(start.dispose);
      await _pump(tester, start: start);
      start.requestFocus();
      await tester.pump();
      expect(
        tester.getSemantics(find.byKey(_toggle)),
        matchesSemantics(
          label: 'Show all',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Show less'), findsOneWidget);
      expect(_viewportHeight(tester), greaterThan(60));
      expect(
        tester.getSemantics(find.byKey(_toggle)).getSemanticsData().label,
        'Show less',
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(_viewportHeight(tester), 60);
      semantics.dispose();
    },
  );

  testWidgets('recipes style the toggle surface and label', (tester) async {
    const labelColor = Color(0xFF123456);
    await _pump(
      tester,
      style: AgentToolCallStyler(
        outputMaxHeight: 60,
        outputToggle: FlexBoxStyler().padding(.all(8)),
        outputToggleLabel: TextStyler().color(labelColor),
      ),
    );
    final label = find.text('Show all');
    expect(tester.widget<Text>(label).style?.color, labelColor);
    expect(
      tester.getSize(find.byKey(_toggle)).height,
      tester.getSize(label).height + 16,
    );
  });

  testWidgets('host labels replace the English output toggle labels', (
    tester,
  ) async {
    await pumpAgent(
      tester,
      AgentToolCall(
        call: runningCall.copyWith(output: _lines),
        showAllLabel: 'Expand output',
        showLessLabel: 'Limit output',
        style: AgentToolCallStyler(outputMaxHeight: 60),
      ),
      disableAnimations: true,
    );
    await tester.pumpAndSettle();
    expect(find.text('Expand output'), findsOneWidget);
    await tester.tap(find.byKey(_toggle));
    await tester.pump();
    expect(find.text('Limit output'), findsOneWidget);
    expect(_viewportHeight(tester), tester.getSize(find.text(_lines)).height);
  });
}
