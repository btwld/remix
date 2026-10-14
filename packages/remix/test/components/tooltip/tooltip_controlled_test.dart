import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets(
    'tooltipKey shows imperatively, reports visibility, and preserves trigger focus',
    (tester) async {
      final focus = FocusNode();
      final tooltipKey = GlobalKey<RawTooltipState>();
      final changes = <bool>[];
      var dismissed = 0;
      addTearDown(focus.dispose);
      await tester.pumpWidget(
        MaterialApp(
          home: Actions(
            actions: {
              DismissIntent: CallbackAction<DismissIntent>(
                onInvoke: (_) {
                  dismissed++;
                  return null;
                },
              ),
            },
            child: RemixTooltip(
              tooltipKey: tooltipKey,
              onOpenChanged: changes.add,
              style: TooltipStyler().waitDuration(const Duration(seconds: 10)),
              tooltipChild: const Text('Tooltip content'),
              child: RemixButton(
                focusNode: focus,
                label: 'Trigger',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      focus.requestFocus();
      await tester.pump();
      expect(find.text('Tooltip content'), findsNothing);
      expect(tooltipKey.currentState!.ensureTooltipVisible(), isTrue);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Tooltip content'), findsOneWidget);
      expect(changes, [true]);
      expect(focus.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text('Tooltip content'), findsNothing);
      expect(changes, [true, false]);
      expect(dismissed, 0);
      expect(focus.hasFocus, isTrue);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(dismissed, 1);
      expect(focus.hasFocus, isTrue);
    },
  );

  testWidgets(
    'closed tooltip delegates Escape to the enclosing dismiss action',
    (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      var dismissed = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: Actions(
            actions: {
              DismissIntent: CallbackAction<DismissIntent>(
                onInvoke: (_) {
                  dismissed++;
                  return null;
                },
              ),
            },
            child: RemixTooltip(
              style: TooltipStyler().waitDuration(const Duration(seconds: 10)),
              tooltipChild: const Text('Tooltip content'),
              child: RemixButton(
                focusNode: focus,
                label: 'Trigger',
                onPressed: () {},
              ),
            ),
          ),
        ),
      );
      focus.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      expect(dismissed, 1);
    },
  );

  testWidgets('closed tooltip delegates only unmodified Escape', (
    tester,
  ) async {
    final focus = FocusNode();
    addTearDown(focus.dispose);
    var dismissed = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) {
                dismissed++;
                return null;
              },
            ),
          },
          child: RemixTooltip(
            style: TooltipStyler().waitDuration(const Duration(seconds: 10)),
            tooltipChild: const Text('Tooltip content'),
            child: RemixButton(
              focusNode: focus,
              label: 'Trigger',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    focus.requestFocus();
    await tester.pump();
    for (final modifier in [
      LogicalKeyboardKey.controlLeft,
      LogicalKeyboardKey.altLeft,
      LogicalKeyboardKey.shiftLeft,
      LogicalKeyboardKey.metaLeft,
    ]) {
      await tester.sendKeyDownEvent(modifier);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.sendKeyUpEvent(modifier);
      expect(dismissed, 0, reason: modifier.debugName);
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    expect(dismissed, 1);
  });
}
