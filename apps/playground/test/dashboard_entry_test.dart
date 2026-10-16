import 'package:flutter/material.dart' show MaterialApp;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/main.dart';
import 'package:playground/ui/ui.dart';

void main() {
  testWidgets(
    'PlaygroundApp mounts PlaygroundDashboardDemo directly under WidgetsApp',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const PlaygroundApp());
      await tester.pump();

      expect(find.byType(WidgetsApp), findsOneWidget);
      expect(find.byType(MaterialApp), findsNothing);
      expect(find.byType(PlaygroundDashboardDemo), findsOneWidget);
      expect(find.text('Revenue trend'), findsOneWidget);
      expect(find.text('Recent orders'), findsOneWidget);
      expect(find.text('ORD-1048'), findsOneWidget);
      expect(find.text('Northstar workspace'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'dashboard appearance toggle and compact drawer work without MaterialApp',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(const PlaygroundApp());
      await tester.pump();

      expect(find.bySemanticsLabel('Use dark appearance'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('dashboard-appearance-toggle')).first,
      );
      await tester.pump();
      expect(find.bySemanticsLabel('Use light appearance'), findsOneWidget);
      expect(tester.takeException(), isNull);

      tester.view.physicalSize = const Size(390, 844);
      await tester.pump();
      expect(find.byKey(const ValueKey('dashboard-menu')), findsWidgets);
      await tester.tap(find.byKey(const ValueKey('dashboard-menu')).first);
      for (var frame = 0; frame < 5; frame++) {
        await tester.pump(const Duration(milliseconds: 100));
      }
      expect(find.byKey(const ValueKey('dashboard-sidebar')), findsWidgets);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'sidebar collapse and expand animate across 16ms frames without overflow or Mix warnings',
    (tester) async {
      tester.view.physicalSize = const Size(1440, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);

      final mixWarnings = <String>[];
      final originalDebugPrint = debugPrint;
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message != null && message.contains('Mix: could not convert')) {
          mixWarnings.add(message);
        }
      };
      try {
        await tester.pumpWidget(const PlaygroundApp());
        await tester.pump();
        expect(mixWarnings, isEmpty);

        await tester.tap(
          find.byKey(const ValueKey('dashboard-collapse')).first,
        );
        for (var frame = 0; frame < 16; frame++) {
          await tester.pump(const Duration(milliseconds: 16));
          expect(
            tester.takeException(),
            isNull,
            reason: 'collapse frame $frame',
          );
          expect(mixWarnings, isEmpty, reason: 'collapse frame $frame');
        }

        await tester.tap(
          find.byKey(const ValueKey('dashboard-collapse')).first,
        );
        for (var frame = 0; frame < 16; frame++) {
          await tester.pump(const Duration(milliseconds: 16));
          expect(tester.takeException(), isNull, reason: 'expand frame $frame');
          expect(mixWarnings, isEmpty, reason: 'expand frame $frame');
        }
      } finally {
        debugPrint = originalDebugPrint;
      }
    },
  );

  testWidgets('Agent chat destination runs interactive scenarios locally', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1440, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

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

    await tester.pumpWidget(const PlaygroundApp());
    await tester.pump();

    await tester.tap(find.text('Chat').first);
    await tester.pump();
    expect(find.text('Agent chat'), findsOneWidget);

    await tester.tap(find.text('Review checkout'));
    for (var frame = 0; frame < 5; frame++) {
      await tester.pump(const Duration(milliseconds: 350));
    }
    expect(find.textContaining('ready for review'), findsWidgets);

    final copyAnswer = find.bySemanticsLabel('Copy answer');
    if (copyAnswer.evaluate().isNotEmpty) {
      await tester.tap(copyAnswer.first);
      await tester.pump();
      expect(copied, isNotEmpty);
    }
    expect(tester.takeException(), isNull);
  });
}
