import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

Key _triggerKey(String id) => Key('trigger-$id');

Widget _tip(
  String id, {
  FocusNode? focusNode,
  GlobalKey<RawTooltipState>? tooltipKey,
  Duration hoverDelay = Duration.zero,
  Duration dismissDelay = const Duration(milliseconds: 100),
  TooltipTriggerMode triggerMode = TooltipTriggerMode.longPress,
  bool enableTapToDismiss = true,
  ValueChanged<bool>? onOpenChanged,
  VoidCallback? onTriggered,
}) => NakedTooltip(
  tooltipKey: tooltipKey,
  hoverDelay: hoverDelay,
  dismissDelay: dismissDelay,
  triggerMode: triggerMode,
  enableTapToDismiss: enableTapToDismiss,
  onOpenChanged: onOpenChanged,
  onTriggered: onTriggered,
  // The default animation, so a closing bubble could overlap the next one.
  overlayBuilder: (context, animation) => FadeTransition(
    key: Key('fade-$id'),
    opacity: animation,
    child: SizedBox(width: 80, height: 24, child: Text('Tip $id')),
  ),
  child: Focus(
    focusNode: focusNode,
    child: SizedBox(key: _triggerKey(id), width: 80, height: 40),
  ),
);

Widget _row(List<Widget> tips) => Center(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      for (final tip in tips) ...[tip, const SizedBox(width: 120)],
    ],
  ),
);

List<String> _shownTips() => [
  for (final id in const ['A', 'B'])
    if (find.text('Tip $id').evaluate().isNotEmpty) id,
];

// Pumps frame by frame, failing if two bubbles are ever rendered together.
Future<void> _expectSingleBubble(
  WidgetTester tester, {
  Duration duration = const Duration(milliseconds: 400),
}) async {
  const step = Duration(milliseconds: 10);
  for (var elapsed = Duration.zero; elapsed < duration; elapsed += step) {
    await tester.pump(step);
    expect(_shownTips().length, lessThanOrEqualTo(1));
  }
  await tester.pumpAndSettle();
}

Future<TestGesture> _mouse(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  return mouse;
}

Future<void> _hover(WidgetTester tester, TestGesture mouse, String id) =>
    mouse.moveTo(tester.getCenter(find.byKey(_triggerKey(id))));

void main() {
  group('NakedTooltip shows one tooltip at a time', () {
    testWidgets('hover handoff removes the previous bubble at once', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(_row([_tip('A'), _tip('B')]));
      final mouse = await _mouse(tester);

      await _hover(tester, mouse, 'A');
      await tester.pumpAndSettle();
      expect(_shownTips(), ['A']);

      await _hover(tester, mouse, 'B');
      await tester.pump();
      expect(_shownTips(), ['B']);
      await _expectSingleBubble(tester);
      expect(_shownTips(), ['B']);
    });

    testWidgets('hover replaces a focused tooltip, which does not return', (
      tester,
    ) async {
      final focusA = FocusNode();
      addTearDown(focusA.dispose);
      await tester.pumpMaterialWidget(
        _row([_tip('A', focusNode: focusA), _tip('B')]),
      );
      final mouse = await _mouse(tester);

      focusA.requestFocus();
      await tester.pumpAndSettle();
      expect(_shownTips(), ['A']);

      await _hover(tester, mouse, 'B');
      await _expectSingleBubble(tester);
      expect(_shownTips(), ['B']);

      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(_shownTips(), isEmpty);
      expect(focusA.hasFocus, isTrue);
      expect(RawTooltip.dismissAllToolTips(), isFalse);

      // Hovering the focused trigger again activates it.
      await _hover(tester, mouse, 'A');
      await tester.pumpAndSettle();
      expect(_shownTips(), ['A']);
    });

    testWidgets('Tab handoff shows only the newly focused tooltip', (
      tester,
    ) async {
      final focusA = FocusNode();
      final focusB = FocusNode();
      addTearDown(focusA.dispose);
      addTearDown(focusB.dispose);
      await tester.pumpMaterialWidget(
        _row([_tip('A', focusNode: focusA), _tip('B', focusNode: focusB)]),
      );

      focusA.requestFocus();
      await tester.pumpAndSettle();
      expect(_shownTips(), ['A']);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(focusB.hasFocus, isTrue);
      expect(_shownTips(), ['B']);
      // Past A's dismissDelay, whose blur timer must not close B.
      await _expectSingleBubble(tester);
      expect(_shownTips(), ['B']);

      // A was dismissed, not just hidden, so nothing stays open after B.
      focusB.unfocus();
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();
      expect(RawTooltip.dismissAllToolTips(), isFalse);
    });

    testWidgets('a newer hover cancels a pending focus show', (tester) async {
      final focusA = FocusNode();
      addTearDown(focusA.dispose);
      await tester.pumpMaterialWidget(
        _row([
          _tip(
            'A',
            focusNode: focusA,
            hoverDelay: const Duration(milliseconds: 200),
          ),
          _tip('B'),
        ]),
      );
      final mouse = await _mouse(tester);

      focusA.requestFocus();
      await tester.pump(const Duration(milliseconds: 50));
      await _hover(tester, mouse, 'B');
      await _expectSingleBubble(tester);
      expect(_shownTips(), ['B']);
    });

    testWidgets('hover replaces a commanded tooltip', (tester) async {
      final keyA = GlobalKey<RawTooltipState>();
      await tester.pumpMaterialWidget(
        _row([
          _tip('A', tooltipKey: keyA, triggerMode: TooltipTriggerMode.manual),
          _tip('B'),
        ]),
      );
      final mouse = await _mouse(tester);

      keyA.currentState!.ensureTooltipVisible();
      await tester.pumpAndSettle();
      expect(_shownTips(), ['A']);

      await _hover(tester, mouse, 'B');
      await _expectSingleBubble(tester);
      expect(_shownTips(), ['B']);

      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(_shownTips(), isEmpty);
    });

    testWidgets('a command replaces a hovered tooltip without overlap', (
      tester,
    ) async {
      final keyB = GlobalKey<RawTooltipState>();
      final changes = <String>[];
      await tester.pumpMaterialWidget(
        _row([
          _tip('A', onOpenChanged: (open) => changes.add('A $open')),
          _tip(
            'B',
            tooltipKey: keyB,
            triggerMode: TooltipTriggerMode.manual,
            onOpenChanged: (open) => changes.add('B $open'),
          ),
        ]),
      );
      final mouse = await _mouse(tester);

      await _hover(tester, mouse, 'A');
      await tester.pumpAndSettle();
      expect(_shownTips(), ['A']);

      keyB.currentState!.ensureTooltipVisible();
      await _expectSingleBubble(tester);
      expect(_shownTips(), ['B']);
      expect(changes, ['A true', 'A false', 'B true']);
    });

    testWidgets('long press replaces a tooltip that ignores outside taps', (
      tester,
    ) async {
      final keyA = GlobalKey<RawTooltipState>();
      var triggered = 0;
      await tester.pumpMaterialWidget(
        _row([
          _tip(
            'A',
            tooltipKey: keyA,
            triggerMode: TooltipTriggerMode.manual,
            enableTapToDismiss: false,
          ),
          _tip('B', onTriggered: () => triggered++),
        ]),
      );

      keyA.currentState!.ensureTooltipVisible();
      await tester.pumpAndSettle();
      expect(_shownTips(), ['A']);

      final press = await tester.startGesture(
        tester.getCenter(find.byKey(_triggerKey('B'))),
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 50));
      expect(_shownTips(), ['B']);
      expect(triggered, 1);
      await press.up();
      // RawTooltip still hides a touch-shown tooltip after touchDelay.
      await tester.pump(const Duration(milliseconds: 1600));
      await tester.pumpAndSettle();
      expect(_shownTips(), isEmpty);
      // A ignores outside taps, so only replacing it could have dismissed it.
      expect(RawTooltip.dismissAllToolTips(), isFalse);
    });

    testWidgets('Escape closes the hovered tooltip without reopening the '
        'focused one', (tester) async {
      final focusA = FocusNode();
      addTearDown(focusA.dispose);
      await tester.pumpMaterialWidget(
        _row([_tip('A', focusNode: focusA), _tip('B')]),
      );
      final mouse = await _mouse(tester);

      focusA.requestFocus();
      await tester.pumpAndSettle();
      await _hover(tester, mouse, 'B');
      await tester.pumpAndSettle();
      expect(_shownTips(), ['B']);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(_shownTips(), isEmpty);

      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(_shownTips(), isEmpty);
      expect(focusA.hasFocus, isTrue);
    });

    testWidgets('leaving a focused trigger for another shows only the other', (
      tester,
    ) async {
      final focusA = FocusNode();
      addTearDown(focusA.dispose);
      await tester.pumpMaterialWidget(
        _row([_tip('A', focusNode: focusA), _tip('B')]),
      );
      final mouse = await _mouse(tester);

      focusA.requestFocus();
      await _hover(tester, mouse, 'A');
      await tester.pumpAndSettle();
      expect(_shownTips(), ['A']);

      // A's pointer exit must not reopen it after B takes over.
      await _hover(tester, mouse, 'B');
      await _expectSingleBubble(tester);
      expect(_shownTips(), ['B']);
    });

    testWidgets('Escape keeps a focused tooltip closed after the pointer '
        'leaves', (tester) async {
      final focusA = FocusNode();
      addTearDown(focusA.dispose);
      await tester.pumpMaterialWidget(_row([_tip('A', focusNode: focusA)]));
      final mouse = await _mouse(tester);

      focusA.requestFocus();
      await _hover(tester, mouse, 'A');
      await tester.pumpAndSettle();
      expect(_shownTips(), ['A']);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(_shownTips(), isEmpty);
      expect(focusA.hasFocus, isTrue);
    });

    testWidgets('closing without a replacement keeps the exit animation', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        _row([_tip('A', dismissDelay: Duration.zero)]),
      );
      final mouse = await _mouse(tester);

      await _hover(tester, mouse, 'A');
      await tester.pumpAndSettle();
      await mouse.moveTo(Offset.zero);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 30));
      final fade = tester.widget<FadeTransition>(
        find.byKey(const Key('fade-A')),
      );
      expect(fade.opacity.value, inExclusiveRange(0, 1));
      await tester.pumpAndSettle();
      expect(_shownTips(), isEmpty);
    });
  });
}
