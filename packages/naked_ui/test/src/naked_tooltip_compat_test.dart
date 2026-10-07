import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

const _triggerKey = Key('compat-trigger');

// naked_ui 1.1.0 behaviors that the RawTooltip path keeps.
void main() {
  group('NakedTooltip 1.1.0 behaviors on RawTooltip', () {
    testWidgets('focus opens after hoverDelay and blur closes after '
        'dismissDelay', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      final changes = <bool>[];
      await tester.pumpMaterialWidget(
        Center(
          child: _tooltip(
            hoverDelay: const Duration(milliseconds: 100),
            dismissDelay: const Duration(milliseconds: 100),
            onOpenChanged: changes.add,
            child: Focus(focusNode: focus, child: _trigger),
          ),
        ),
      );

      focus.requestFocus();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Tip'), findsNothing);
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsOneWidget);

      focus.unfocus();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(find.text('Tip'), findsOneWidget);
      await tester.pump(const Duration(milliseconds: 60));
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsNothing);
      expect(changes, [true, false]);
    });

    testWidgets('focus that leaves before hoverDelay never opens', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpMaterialWidget(
        Center(
          child: _tooltip(
            hoverDelay: const Duration(milliseconds: 100),
            child: Focus(focusNode: focus, child: _trigger),
          ),
        ),
      );

      focus.requestFocus();
      await tester.pump(const Duration(milliseconds: 50));
      focus.unfocus();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsNothing);
    });

    testWidgets('a focused tooltip stays open when the mouse leaves', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpMaterialWidget(
        Center(
          child: _tooltip(
            child: Focus(focusNode: focus, child: _trigger),
          ),
        ),
      );
      final mouse = await _mouse(tester);

      focus.requestFocus();
      await tester.pumpAndSettle();
      await mouse.moveTo(tester.getCenter(find.byKey(_triggerKey)));
      await tester.pumpAndSettle();
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsOneWidget);

      focus.unfocus();
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsNothing);
    });

    testWidgets('blur keeps a tooltip whose trigger is still hovered', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpMaterialWidget(
        Center(
          child: _tooltip(
            child: Focus(focusNode: focus, child: _trigger),
          ),
        ),
      );
      final mouse = await _mouse(tester);

      await mouse.moveTo(tester.getCenter(find.byKey(_triggerKey)));
      focus.requestFocus();
      await tester.pumpAndSettle();
      focus.unfocus();
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsOneWidget);

      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsNothing);
    });

    testWidgets('Escape closes a visible tooltip', (tester) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      await tester.pumpMaterialWidget(
        Center(
          child: _tooltip(
            enableTapToDismiss: false,
            child: Focus(focusNode: focus, child: _trigger),
          ),
        ),
      );

      focus.requestFocus();
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Tip'), findsNothing);
      expect(focus.hasFocus, isTrue);
    });

    testWidgets('Escape reaches an enclosing dismiss action when closed', (
      tester,
    ) async {
      final focus = FocusNode();
      addTearDown(focus.dispose);
      var dismissed = 0;
      await tester.pumpMaterialWidget(
        Actions(
          actions: {
            DismissIntent: CallbackAction<DismissIntent>(
              onInvoke: (_) => dismissed++,
            ),
          },
          child: Center(
            child: _tooltip(
              // Focus never opens it; only the enclosing action can react.
              hoverDelay: const Duration(seconds: 10),
              child: Focus(focusNode: focus, child: _trigger),
            ),
          ),
        ),
      );

      focus.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(dismissed, 1);
      expect(find.text('Tip'), findsNothing);
    });

    testWidgets('overlay descendants receive collision-resolved placement', (
      tester,
    ) async {
      final tooltipKey = GlobalKey<RawTooltipState>();
      OverlayPlacement? placement;
      await tester.pumpMaterialWidget(
        Align(
          alignment: Alignment.bottomCenter,
          child: NakedTooltip(
            tooltipKey: tooltipKey,
            triggerMode: TooltipTriggerMode.manual,
            animationStyle: AnimationStyle.noAnimation,
            positioning: const OverlayPositionConfig(
              side: OverlaySide.bottom,
              alignment: OverlayAlignment.center,
              collisionPadding: EdgeInsets.all(8),
            ),
            overlayBuilder: (context, animation) => Builder(
              builder: (context) {
                placement = OverlayPlacement.of(context);
                return const SizedBox(width: 160, height: 100);
              },
            ),
            child: const SizedBox(width: 100, height: 40),
          ),
        ),
      );
      expect(tooltipKey.currentState?.ensureTooltipVisible(), isTrue);
      await tester.pumpAndSettle();

      expect(placement, isNotNull);
      expect(placement!.side, OverlaySide.top);
      expect(placement!.wasFlipped, isTrue);
    });

    testWidgets('the trigger does not leak placement to its own subtree', (
      tester,
    ) async {
      OverlayPlacement? triggerPlacement;
      await tester.pumpMaterialWidget(
        Center(
          child: _tooltip(
            child: Builder(
              builder: (context) {
                triggerPlacement = OverlayPlacement.maybeOf(context);
                return _trigger;
              },
            ),
          ),
        ),
      );
      expect(triggerPlacement, isNull);
    });
  });
}

const _trigger = SizedBox(key: _triggerKey, width: 100, height: 40);

NakedTooltip _tooltip({
  required Widget child,
  Duration hoverDelay = Duration.zero,
  Duration dismissDelay = Duration.zero,
  bool enableTapToDismiss = true,
  ValueChanged<bool>? onOpenChanged,
}) => NakedTooltip(
  hoverDelay: hoverDelay,
  dismissDelay: dismissDelay,
  enableTapToDismiss: enableTapToDismiss,
  onOpenChanged: onOpenChanged,
  animationStyle: AnimationStyle.noAnimation,
  overlayBuilder: (context, animation) =>
      const SizedBox(width: 60, height: 20, child: Text('Tip')),
  child: child,
);

Future<TestGesture> _mouse(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  return mouse;
}
