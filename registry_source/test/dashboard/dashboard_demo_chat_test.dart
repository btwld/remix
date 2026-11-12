import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';
import 'package:registry_source/src/dashboard/dashboard_demo_chat.dart';
import 'package:registry_source/src/fortal/recipes/dashboard/dashboard_demo.dart';
import 'package:remix/agent.dart';

const _success = 'Review the checkout flow and tell me if the cart is ready.';
const _failure = 'Run the checkout tests again and recover if one fails.';
const _tick = Duration(milliseconds: 350);

Future<void> _open(WidgetTester tester, {Duration Function()? now}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1280, 1800);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(_host(const FortalDashboardDemo(initialPage: .chat)));
  final styles = tester
      .widget<RegistryDashboardChatPage>(find.byType(RegistryDashboardChatPage))
      .styles;
  await tester.pumpWidget(
    _host(RegistryDashboardChatPage(styles: styles, now: now)),
  );
  await tester.pumpAndSettle();
}

Widget _host(Widget child) => WidgetsApp(
  key: ValueKey(child.runtimeType),
  color: const Color(0xFFFFFFFF),
  pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
    settings: settings,
    pageBuilder: (context, _, _) => builder(context),
  ),
  builder: (_, navigator) => FortalTheme(child: navigator!),
  home: child,
);

Future<void> _send(WidgetTester tester, String prompt) async {
  await tester.enterText(find.byType(EditableText), prompt);
  await tester.pump();
  await tester.tap(find.byKey(const ValueKey('agent-composer-send')));
  await tester.pump();
}

Future<void> _finish(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(_tick);
  }
}

Finder _action(int turn, String action) => find.descendant(
  of: find.byType(AgentAnswer).at(turn),
  matching: find.byKey(ValueKey('agent-answer-$action')),
);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pump();
}

List<AgentAnswerFeedback?> _votes(WidgetTester tester) => tester
    .widgetList<AgentAnswer>(find.byType(AgentAnswer))
    .map((answer) => answer.feedback)
    .toList();

void main() {
  testWidgets('two answers vote independently and retry resets only its vote', (
    tester,
  ) async {
    await _open(tester);
    await _send(tester, _success);
    await _finish(tester);
    await _tap(tester, _action(0, 'positive'));
    expect(_votes(tester), [AgentAnswerFeedback.positive]);
    await _send(tester, _success);
    await _finish(tester);
    expect(_votes(tester), [AgentAnswerFeedback.positive, null]);
    await _tap(tester, _action(1, 'negative'));
    expect(_votes(tester), [
      AgentAnswerFeedback.positive,
      AgentAnswerFeedback.negative,
    ]);
    await _tap(tester, _action(1, 'retry'));
    await _finish(tester);
    expect(_votes(tester), [AgentAnswerFeedback.positive, null]);
  });

  testWidgets('only the latest answer retries and Stop owns that run', (
    tester,
  ) async {
    await _open(tester);
    for (var i = 0; i < 2; i++) {
      await _send(tester, _success);
      await _finish(tester);
    }
    expect(_action(0, 'retry'), findsNothing);
    expect(_action(1, 'retry'), findsOneWidget);
    await _tap(tester, _action(1, 'retry'));
    final composer = tester.widget<AgentComposer>(find.byType(AgentComposer));
    expect(composer.controller!.running, isTrue);
    expect(
      tester.widget<AgentConversation>(find.byType(AgentConversation)).busy,
      isTrue,
    );
    await tester.enterText(find.byType(EditableText), 'Cannot interrupt retry');
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(find.byType(AgentTurn), findsNWidgets(2));
    expect(find.byKey(const ValueKey('agent-composer-send')), findsNothing);
    await _tap(tester, find.byKey(const ValueKey('agent-composer-stop')));
    expect(composer.controller!.running, isFalse);
    expect(find.text('Run stopped; partial output was preserved.'), findsOne);
    await _finish(tester);
    expect(find.text('Run stopped; partial output was preserved.'), findsOne);
  });

  testWidgets(
    'approval decision time is excluded and tool work resumes clock',
    (tester) async {
      var now = Duration.zero;
      await _open(tester, now: () => now);
      await _send(tester, 'Run the checkout tests');
      now += const Duration(seconds: 2);
      await tester.pump(_tick);
      final clock = tester.widget<AgentSteps>(find.byType(AgentSteps)).clock!;
      expect(clock.isRunning, isFalse);
      expect(clock.elapsed, const Duration(seconds: 2));
      now += const Duration(minutes: 1);
      await tester.pump(const Duration(minutes: 1));
      expect(clock.elapsed, const Duration(seconds: 2));
      await _tap(tester, find.text('Allow once'));
      expect(clock.isRunning, isTrue);
      now += const Duration(seconds: 3);
      await _finish(tester);
      expect(clock.isRunning, isFalse);
      expect(clock.elapsed, const Duration(seconds: 5));
      expect(find.text('Thought for 5s · 3 steps'), findsOneWidget);
    },
  );

  testWidgets(
    'host announces transitions once across chunks, turns and reset',
    (tester) async {
      final messages = <String>[];
      tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
        SystemChannels.accessibility,
        (dynamic event) async {
          if (event['type'] == 'announce') {
            messages.add(event['data']['message'] as String);
          }
          return null;
        },
      );
      addTearDown(() {
        tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler(
          SystemChannels.accessibility,
          null,
        );
      });
      await _open(tester);
      final ids = <String>{};
      for (var i = 0; i < 2; i++) {
        messages.clear();
        await _send(tester, _failure);
        await tester.pump(_tick);
        ids.add(
          tester
              .widgetList<AgentToolCall>(find.byType(AgentToolCall))
              .last
              .call
              .id,
        );
        expect(messages, ['Approval needed for terminal.run.']);
        await tester.pump(const Duration(seconds: 10));
        await _tap(tester, find.text('Allow once'));
        await tester.pump(_tick);
        expect(messages, ['Approval needed for terminal.run.']);
        await _finish(tester);
        expect(messages, [
          'Approval needed for terminal.run.',
          'terminal.run failed.',
          'Answer ready.',
        ]);
      }
      expect(ids, hasLength(2));
      messages.clear();
      await _tap(tester, _action(1, 'retry'));
      // Preparing, output lines and answer chunks must stay quiet.
      for (var i = 0; i < 8; i++) {
        await tester.pump(_tick);
        expect(messages, isEmpty);
      }
      await _finish(tester);
      expect(messages, ['Answer ready.']);
      await _tap(tester, find.text('New chat'));
      messages.clear();
      await _send(tester, _failure);
      await tester.pump(_tick);
      expect(messages, ['Approval needed for terminal.run.']);
      await _tap(tester, find.text('Deny'));
      expect(messages, ['Approval needed for terminal.run.', 'Answer ready.']);
    },
  );

  testWidgets('answer paragraphs have a 12px gap and copy keeps blank lines', (
    tester,
  ) async {
    String? copied;
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = (call.arguments as Map)['text'] as String;
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        null,
      ),
    );
    await _open(tester);
    await _send(tester, _success);
    await _finish(tester);
    const first =
        'The cart flow is ready. All 31 checkout tests pass, including the discount and order-submission paths.';
    const second =
        'One thing to watch: cart_totals_test.dart only covers single-currency carts, so a multi-currency case is worth adding before launch.';
    expect(find.text(first), findsOneWidget);
    expect(find.text(second), findsOneWidget);
    final context = tester.element(find.text(first));
    expect(
      tester.getTopLeft(find.text(second)).dy -
          tester.getBottomLeft(find.text(first)).dy,
      FortalTokens.space3.resolve(context),
    );
    await _tap(tester, _action(0, 'copy'));
    expect(copied, '$first\n\n$second');
  });
}
