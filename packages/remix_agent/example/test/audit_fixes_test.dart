import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix_agent_example/ui/ui.dart';
import 'package:remix_agent_example/demos.dart';
import 'package:remix_agent_example/main.dart';
import 'package:remix_agent_example/showcase.dart';

import 'helpers/pump_catalog.dart';

Future<void> pumpDemo(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    WidgetsApp(
      color: const Color(0xFFFFFFFF),
      builder: (_, _) => Overlay.wrap(
        child: DarkHost(child: SingleChildScrollView(child: child)),
      ),
    ),
  );
  await pumpCatalog(tester);
}

Future<void> tapText(WidgetTester tester, String text) async {
  final target = find.text(text).last;
  await tester.ensureVisible(target);
  await pumpCatalog(tester);
  await tester.tap(target);
  await pumpCatalog(tester);
}

void main() {
  testWidgets('copy uses the visible denied answer', (tester) async {
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
    await pumpDemo(tester, const ComposedRunDemo());
    await tapText(tester, 'Permission task');
    await tapText(tester, 'Deny');
    final copy = find.byWidgetPredicate(
      (w) => w is RemixIconButton && w.semanticLabel == 'Copy answer',
    );
    await tester.ensureVisible(copy);
    await tester.tap(copy);
    await pumpCatalog(tester);
    expect(copied, 'Permission denied. No checks were run.');
  });
  testWidgets('failed composed checks settle the plan step', (tester) async {
    await pumpDemo(tester, const ComposedRunDemo());
    await tapText(tester, 'Recoverable failure');
    await tester.pump(const Duration(seconds: 1));
    await pumpCatalog(tester);
    final transcript = find.byType(UiTranscript);
    await tester.ensureVisible(transcript);
    await tester.scrollUntilVisible(
      find.byType(UiPlan),
      -200,
      scrollable: find
          .descendant(of: transcript, matching: find.byType(Scrollable))
          .first,
    );
    final plan = tester.widget<UiPlan>(find.byType(UiPlan));
    expect(plan.items.last.status, UiPlanItemStatus.cancelled);
    expect(plan.items.last.title, 'Focused checks failed');
  });

  testWidgets('stopping before permission does not report a tool execution', (
    tester,
  ) async {
    await pumpDemo(tester, const ComposedRunDemo());
    await tapText(tester, 'Permission task');
    final stop = find.byKey(const ValueKey('ui-composer-stop'));
    await tester.ensureVisible(stop);
    await tester.tap(stop);
    await pumpCatalog(tester);
    expect(find.byType(UiExecution), findsNothing);
    expect(find.byType(UiPermission), findsNothing);
    expect(
      find.text('Stopped before running the tool. No checks were run.'),
      findsOneWidget,
    );
  });

  testWidgets('retry after denial requests permission for a fresh attempt', (
    tester,
  ) async {
    await pumpDemo(tester, const ComposedRunDemo());
    await tapText(tester, 'Permission task');
    final firstRequest = tester
        .widget<UiPermission>(find.byType(UiPermission))
        .requestId;
    await tapText(tester, 'Deny');
    final transcript = find.byType(UiTranscript);
    await tester.ensureVisible(transcript);
    await pumpCatalog(tester);
    final retry = find.byWidgetPredicate(
      (widget) =>
          widget is RemixIconButton && widget.semanticLabel == 'Retry answer',
    );
    await tester.scrollUntilVisible(
      retry,
      200,
      scrollable: find
          .descendant(of: transcript, matching: find.byType(Scrollable))
          .first,
    );
    await pumpCatalog(tester);
    await tester.tap(retry);
    await pumpCatalog(tester);
    final permission = tester.widget<UiPermission>(find.byType(UiPermission));
    expect(permission.status, UiPermissionStatus.pending);
    expect(permission.requestId, isNot(firstRequest));
    expect(find.byType(UiExecution), findsNothing);
  });

  testWidgets('previous turns remain readable inside the active transcript', (
    tester,
  ) async {
    await pumpDemo(tester, const ComposedRunDemo());
    await tapText(tester, 'Successful task');
    for (var i = 0; i < 6; i++) {
      await tester.pump(const Duration(milliseconds: 300));
    }
    await tapText(tester, 'Permission task');
    final transcript = find.byType(UiTranscript);
    await tester.ensureVisible(transcript);
    await pumpCatalog(tester);
    final scrollable = find
        .descendant(of: transcript, matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(
      find.text('Review the checkout flow.'),
      -300,
      scrollable: scrollable,
    );
    await pumpCatalog(tester);
    expect(
      find.descendant(
        of: transcript,
        matching: find.text('Review the checkout flow.'),
      ),
      findsOneWidget,
    );
    expect(find.text('Return to latest'), findsOneWidget);
    final stop = find.byKey(const ValueKey('ui-composer-stop'));
    await tester.ensureVisible(stop);
    await tester.tap(stop);
    await pumpCatalog(tester);
    await tapText(tester, 'Successful task');
    expect(find.text('Return to latest'), findsNothing);
  });

  testWidgets('obsolete permission callbacks cannot authorize a new run', (
    tester,
  ) async {
    await pumpDemo(tester, const ComposedRunDemo());
    await tapText(tester, 'Permission task');
    final previous = tester.widget<UiPermission>(find.byType(UiPermission));
    await tapText(tester, 'New chat');
    await tapText(tester, 'Permission task');
    previous.onAlwaysAllow!();
    previous.onDeny!();
    await tester.pump(const Duration(seconds: 2));
    expect(
      tester.widget<UiPermission>(find.byType(UiPermission)).status,
      UiPermissionStatus.pending,
    );
    expect(find.byType(UiExecution), findsNothing);
  });

  testWidgets('composed run streams after permission and reset cancels work', (
    tester,
  ) async {
    await pumpDemo(
      tester,
      const ComposedRunDemo(stepDelay: Duration(seconds: 2)),
    );
    await tapText(tester, 'Permission task');
    await tapText(tester, 'Allow once');
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(seconds: 2));
    }
    await tester.pump();
    expect(
      tester.widget<UiAnswer>(find.byType(UiAnswer)).status,
      UiAnswerStatus.complete,
    );
    expect(find.textContaining('All 12 focused checks passed'), findsOneWidget);
    await tapText(tester, 'New chat');
    await tapText(tester, 'Permission task');
    await tapText(tester, 'Deny');
    expect(find.text('Permission denied. No checks were run.'), findsOneWidget);
    expect(find.byType(UiExecution), findsNothing);
    await tapText(tester, 'New chat');
    await tapText(tester, 'Successful task');
    final stop = find.byKey(const ValueKey('ui-composer-stop'));
    await tester.ensureVisible(stop);
    await tester.tap(stop);
    await tester.pump();
    expect(
      tester.widget<UiExecution>(find.byType(UiExecution)).status,
      UiExecutionStatus.cancelled,
    );
    await tapText(tester, 'New chat');
    await tester.pump(const Duration(seconds: 10));
    expect(find.byType(UiExecution), findsNothing);
    expect(find.byType(UiAnswer), findsNothing);
  });

  testWidgets('execution reaches failure and retries', (tester) async {
    await pumpDemo(tester, const ExecutionDemo());
    await tapText(tester, 'Succeed');
    await tapText(tester, 'Fail');
    expect(
      tester.widget<UiExecution>(find.byType(UiExecution)).status,
      UiExecutionStatus.error,
    );
    await tapText(tester, 'Focused checks');
    final retry = find.byWidgetPredicate(
      (w) => w is RemixIconButton && w.semanticLabel == 'Retry execution',
    );
    await tester.ensureVisible(retry);
    await tester.tap(retry);
    await pumpCatalog(tester);
    expect(
      tester.widget<UiExecution>(find.byType(UiExecution)).status,
      UiExecutionStatus.running,
    );
  });

  testWidgets('composed run supports always allow', (tester) async {
    await pumpDemo(
      tester,
      const ComposedRunDemo(stepDelay: Duration(seconds: 2)),
    );
    await tapText(tester, 'Permission task');
    await tapText(tester, 'Always allow');
    expect(
      tester.widget<UiExecution>(find.byType(UiExecution)).status,
      UiExecutionStatus.running,
    );
    for (var i = 0; i < 3; i++) {
      await tester.pump(const Duration(seconds: 2));
    }
    await tapText(tester, 'Permission task');
    expect(
      tester.widget<UiPermission>(find.byType(UiPermission)).status,
      UiPermissionStatus.running,
    );
    await tapText(tester, 'New chat');
    await tapText(tester, 'Permission task');
    expect(
      tester.widget<UiPermission>(find.byType(UiPermission)).status,
      UiPermissionStatus.pending,
    );
  });

  testWidgets('plan can replay after completion', (tester) async {
    await pumpDemo(tester, const PlanDemo());
    for (var i = 0; i < 3; i++) {
      await tapText(tester, 'Advance');
    }
    expect(find.text('3/3'), findsOneWidget);
    expect(find.text('Advance'), findsNothing);
    await tapText(tester, 'Replay');
    expect(find.text('0/3'), findsOneWidget);
    expect(find.text('Read the brief'), findsOneWidget);
  });

  testWidgets(
    'answer reveals sources only when complete and copies the answer',
    (tester) async {
      String? copied;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData')
            copied = (call.arguments as Map)['text'] as String;
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );
      await pumpDemo(tester, const AnswerDemo());
      expect(find.text('Sources'), findsNothing);
      await tapText(tester, 'Complete');
      expect(find.text('Sources'), findsOneWidget);
      expect(
        tester
            .widget<RemixButton>(find.widgetWithText(RemixButton, 'Complete'))
            .enabled,
        isFalse,
      );
      final copy = find.byWidgetPredicate(
        (w) => w is RemixIconButton && w.semanticLabel == 'Copy answer',
      );
      await tester.tap(copy);
      await tester.pump();
      expect(copied, 'The checkout flow is ready for review.');
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is RemixIconButton && w.semanticLabel == 'Retry answer',
        ),
      );
      await pumpCatalog(tester);
      expect(find.text('Sources'), findsNothing);
      expect(find.text('Writing the answer…'), findsOneWidget);
    },
  );

  for (final width in [390.0, 1280.0]) {
    testWidgets('navigation preserves clicked destination at width $width', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const RemixAgentExampleApp());
      await pumpCatalog(tester);
      for (final label in ['Activity', 'Answer', 'Composer']) {
        final nav = find.widgetWithText(RemixToggle, label);
        await tester.ensureVisible(nav);
        await pumpCatalog(tester);
        await tester.tap(nav);
        await pumpCatalog(tester);
        expect(tester.widget<RemixToggle>(nav).selected, isTrue);
        final rect = tester.getRect(nav);
        expect(rect.left, greaterThanOrEqualTo(0));
        expect(rect.right, lessThanOrEqualTo(width));
      }
      expect(tester.takeException(), isNull);
    });
  }
}
