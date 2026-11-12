import 'package:dashboard/main.dart';
import 'package:dashboard/ui/ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';
import 'package:remix/remix.dart';

const _send = ValueKey('agent-composer-send');

/// Opens the chat page of the dashboard at [size].
Future<void> _openChat(WidgetTester tester, {Size? size}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size ?? const Size(1280, 900);
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const DashboardApp());
  await tester.tap(find.text('Chat').first);
  await tester.pump();
}

/// A suggestion fills the composer; Send submits it, as a reader does.
Future<void> _ask(WidgetTester tester, String suggestion) async {
  await tester.tap(find.text(suggestion));
  await tester.pump();
  await tester.tap(find.byKey(_send));
}

AgentToolCall _call(WidgetTester tester) =>
    tester.widget<AgentToolCall>(find.byType(AgentToolCall));

void main() {
  for (final scenario in [
    (width: 390.0, height: 844.0, lines: 1),
    (width: 390.0, height: 844.0, lines: 8),
    (width: 430.0, height: 844.0, lines: 8),
    (width: 375.0, height: 667.0, lines: 1),
  ]) {
    testWidgets('draft and actions fit above keyboard $scenario', (
      tester,
    ) async {
      await _openChat(tester, size: const Size(1280, 844));
      tester.view.physicalSize = Size(scenario.width, scenario.height);
      await tester.pump();
      final field = find.descendant(
        of: find.byType(AgentComposer),
        matching: find.byType(EditableText),
      );
      final draft = List.generate(
        scenario.lines,
        (index) => 'Draft line $index',
      ).join('\n');
      await tester.enterText(field, draft);
      await tester.pump();
      expect(tester.takeException(), isNull);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      await tester.pump();
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(tester.widget<EditableText>(field).focusNode.hasFocus, isTrue);
      expect(tester.widget<EditableText>(field).controller.text, draft);
      expect(
        tester.getRect(find.byType(AgentComposer)).bottom,
        lessThanOrEqualTo(scenario.height - 300),
      );
      await tester.tap(find.bySemanticsLabel('Send'));
      await tester.pump();
      final stop = find.bySemanticsLabel('Stop');
      expect(
        tester.getRect(stop).bottom,
        lessThanOrEqualTo(scenario.height - 300),
      );
      await tester.tap(stop);
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(
        tester
            .widget<AgentComposer>(find.byType(AgentComposer))
            .controller!
            .running,
        isFalse,
      );
    });
  }

  testWidgets('suggestions fill the composer and do not send', (tester) async {
    await _openChat(tester);

    await tester.tap(find.text('Run terminal checks'));
    await tester.pump();

    final composer = tester.widget<AgentComposer>(find.byType(AgentComposer));
    expect(composer.controller!.text, startsWith('Run the checkout tests'));
    expect(find.byType(AgentTurn), findsNothing);
    expect(composer.focusNode!.hasFocus, isTrue);
  });

  testWidgets('New chat clears the conversation and accepts a fresh message', (
    tester,
  ) async {
    await _openChat(tester);
    final field = find.descendant(
      of: find.byType(AgentComposer),
      matching: find.byType(EditableText),
    );
    await tester.enterText(field, 'Fresh conversation');
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(find.text('Fresh conversation'), findsOneWidget);

    await tester.enterText(field, 'An unsent draft');
    await tester.tap(find.text('New chat'));
    await tester.pump();

    expect(find.text('What should we work on?'), findsOneWidget);
    expect(find.text('Fresh conversation'), findsNothing);
    expect(tester.widget<EditableText>(field).controller.text, isEmpty);
  });

  testWidgets('copy matches the visible stopped answer', (tester) async {
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
    await _openChat(tester);
    await _ask(tester, 'Run terminal checks');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.tap(find.bySemanticsLabel('Stop'));
    await tester.pump();
    await tester.pump();

    final copy = find.byKey(const ValueKey('agent-answer-copy'));
    await tester.ensureVisible(copy);
    await tester.tap(copy);
    await tester.pump();

    expect(copied, 'Run stopped; partial output was preserved.');
  });

  testWidgets('retry after denial asks for approval again', (tester) async {
    await _openChat(tester);
    await _ask(tester, 'Run terminal checks');
    await tester.pump(const Duration(milliseconds: 350));
    expect(_call(tester).call.status, AgentToolCallStatus.awaitingApproval);
    await tester.tap(find.text('Deny'));
    await tester.pump(const Duration(milliseconds: 300));
    await tester.pump();
    expect(_call(tester).call.status, AgentToolCallStatus.denied);

    final retry = find.byKey(const ValueKey('agent-answer-retry'));
    await tester.ensureVisible(retry);
    await tester.tap(retry);
    await tester.pump(const Duration(milliseconds: 350));

    expect(_call(tester).call.status, AgentToolCallStatus.awaitingApproval);
  });

  testWidgets('responsive breakpoint changes preserve a pending approval', (
    tester,
  ) async {
    await _openChat(tester);
    await _ask(tester, 'Run terminal checks');
    await tester.pump(const Duration(milliseconds: 350));
    // The approval footer's own overflow below ~500 is fixed in the library;
    // this checks that the page keeps its state across a breakpoint.
    for (final width in [700.0, 1280.0]) {
      tester.view.physicalSize = Size(width, 900);
      await tester.pump();
      await tester.pump();
      expect(_call(tester).call.status, AgentToolCallStatus.awaitingApproval);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('live theme changes preserve the paused conversation', (
    tester,
  ) async {
    await _openChat(tester);
    await _ask(tester, 'Run terminal checks');
    await tester.pump(const Duration(milliseconds: 350));
    final theme = UiDashboardThemeScope.of(
      tester.element(find.byType(UiDashboardChatPage)),
    );
    theme.onChanged(
      theme.settings.copyWith(
        appearance: UiThemeMode.dark,
        accentColor: .mar,
        panelBackground: .translucent,
        radius: .large,
        scaling: .percent110,
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    final scope = tester.widget<UiTheme>(find.byType(UiTheme));
    expect(scope.mode, UiThemeMode.dark);
    expect(scope.accent, UiAccentColor.mar);
    expect(_call(tester).call.status, AgentToolCallStatus.awaitingApproval);
    expect(tester.takeException(), isNull);
  });

  testWidgets('Stop works during approval and reset cancels pending work', (
    tester,
  ) async {
    await _openChat(tester);
    await _ask(tester, 'Run terminal checks');
    await tester.pump(const Duration(milliseconds: 350));

    await tester.tap(find.bySemanticsLabel('Stop'));
    await tester.pump();
    await tester.pump();

    expect(find.text('Run stopped; partial output was preserved.'), findsOne);
    expect(find.byType(AgentToolCall), findsNothing);
    await tester.tap(find.text('New chat'));
    await tester.pump();
    await _ask(tester, 'Review checkout');
    await tester.pump();
    await tester.tap(find.text('New chat'));
    await tester.pump(const Duration(seconds: 3));
    expect(find.text('What should we work on?'), findsOneWidget);
    expect(find.textContaining('The cart flow is ready'), findsNothing);
  });

  testWidgets('chat runs the approval flow and survives navigation', (
    tester,
  ) async {
    await _openChat(tester);

    await _ask(tester, 'Run terminal checks');
    await tester.pump(const Duration(milliseconds: 350));
    expect(find.text('Allow once'), findsOneWidget);
    final stop = tester.widget<AgentComposer>(find.byType(AgentComposer));
    expect(stop.controller!.running, isTrue);
    expect(stop.onStop, isNotNull);

    await tester.tap(find.text('Allow once'));
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 350));
    }
    expect(find.textContaining('The cart flow is ready'), findsWidgets);

    await tester.tap(find.text('Overview').first);
    await tester.pump();
    await tester.tap(find.text('Chat').first);
    await tester.pump();
    expect(find.textContaining('The cart flow is ready'), findsWidgets);
  });

  testWidgets('a failed command shows its failing lines and can retry', (
    tester,
  ) async {
    await _openChat(tester);
    await _ask(tester, 'Recover a failed command');
    await tester.pump(const Duration(milliseconds: 350));
    await tester.tap(find.text('Allow once'));
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 350));
    }

    expect(_call(tester).call.status, AgentToolCallStatus.failed);
    expect(find.textContaining('Expected: OrderStatus.placed'), findsOneWidget);
    final retry = find.byKey(const ValueKey('agent-answer-retry'));
    await tester.ensureVisible(retry);
    await tester.tap(retry);
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 350));
    }

    expect(find.textContaining('The cart flow is ready'), findsWidgets);
  });
}
