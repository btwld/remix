import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'package:remix_agent_example/ui/ui.dart';
import 'package:remix_agent_example/main.dart';

void main() {
  testWidgets('example app boots under WidgetsApp', (tester) async {
    await tester.pumpWidget(const RemixAgentExampleApp());
    await tester.pump();
    expect(find.byType(WidgetsApp), findsOneWidget);
    expect(find.byType(UiComposer), findsWidgets);
    expect(find.byType(UiPermission), findsWidgets);
    expect(find.byType(Navigator), findsNothing);
    expect(find.text('Composer'), findsWidgets);
    expect(find.text('Permission'), findsWidgets);
    expect(find.text('Execution'), findsWidgets);
    expect(find.text('Plan'), findsWidgets);
    expect(find.text('Activity'), findsWidgets);
    expect(find.text('Answer'), findsWidgets);
    expect(find.text('Transcript'), findsWidgets);
    expect(find.text('Message'), findsWidgets);
  });

  testWidgets('consumer import fires composer submit and permission deny', (
    tester,
  ) async {
    final submitted = <String>[];
    var denied = false;

    await tester.pumpWidget(
      MixScope.empty(
        child: WidgetsApp(
          color: const Color(0xFFFFFFFF),
          builder: (_, _) {
            return DefaultTextStyle(
              style: const TextStyle(color: Color(0xFF18181B), fontSize: 14),
              child: Overlay.wrap(
                child: Column(
                  children: [
                    SizedBox(
                      width: 400,
                      child: UiComposer(onSubmit: submitted.add),
                    ),
                    SizedBox(
                      width: 400,
                      child: UiPermission(
                        tool: 'demo.tool',
                        onDeny: () => denied = true,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );

    await tester.enterText(find.byType(UiComposer), 'ship it');
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(submitted, ['ship it']);

    await tester.tap(find.text('Deny'));
    await tester.pump();
    expect(denied, isTrue);
  });

  testWidgets(
    'interactive chat stop and reset reject stale simulation events',
    (tester) async {
      await tester.pumpWidget(const RemixAgentExampleApp());
      final starter = find.text('Successful task');
      await tester.ensureVisible(starter);
      await tester.tap(starter);
      await tester.pump(const Duration(milliseconds: 300));

      final stop = find.bySemanticsLabel('Stop');
      expect(stop, findsOneWidget);
      await tester.ensureVisible(stop);
      await tester.tap(stop);
      await tester.pump();
      expect(find.bySemanticsLabel('Stop'), findsNothing);

      final reset = find.text('New chat');
      await tester.ensureVisible(reset);
      await tester.tap(reset);
      await tester.pump(const Duration(seconds: 2));
      expect(find.textContaining('All 12 focused checks passed'), findsNothing);
    },
  );
}
