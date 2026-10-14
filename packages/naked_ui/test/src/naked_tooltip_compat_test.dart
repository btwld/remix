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

    testWidgets('sideOffset positions the overlay at the exact pixel offset', (
      tester,
    ) async {
      final tooltipKey = GlobalKey<RawTooltipState>();
      await tester.pumpMaterialWidget(
        Center(
          child: NakedTooltip(
            tooltipKey: tooltipKey,
            triggerMode: TooltipTriggerMode.manual,
            animationStyle: AnimationStyle.noAnimation,
            positioning: const OverlayPositionConfig(
              side: OverlaySide.bottom,
              alignment: OverlayAlignment.center,
              sideOffset: 14,
            ),
            overlayBuilder: (context, animation) =>
                const SizedBox(width: 60, height: 20, child: Text('OffsetTip')),
            child: const SizedBox(key: _triggerKey, width: 100, height: 40),
          ),
        ),
      );
      tooltipKey.currentState!.ensureTooltipVisible();
      await tester.pumpAndSettle();

      final triggerRect = tester.getRect(find.byKey(_triggerKey));
      final tipRect = tester.getRect(find.text('OffsetTip'));
      expect(tipRect.top - triggerRect.bottom, 14);
    });
  });

  group('1.2.0 Audit Regressions', () {
    testWidgets(
      'Tabbing from tooltip A to tooltip B keeps B open after A dismissDelay elapses',
      (tester) async {
        final focusA = FocusNode(debugLabel: 'A');
        final focusB = FocusNode(debugLabel: 'B');
        addTearDown(focusA.dispose);
        addTearDown(focusB.dispose);

        await tester.pumpMaterialWidget(
          Row(
            children: [
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: const Duration(milliseconds: 100),
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tip A'),
                child: Focus(
                  focusNode: focusA,
                  child: const SizedBox(
                    width: 80,
                    height: 40,
                    child: Text('A'),
                  ),
                ),
              ),
              NakedTooltip(
                hoverDelay: Duration.zero,
                dismissDelay: const Duration(milliseconds: 100),
                animationStyle: AnimationStyle.noAnimation,
                overlayBuilder: (context, animation) => const Text('Tip B'),
                child: Focus(
                  focusNode: focusB,
                  child: const SizedBox(
                    width: 80,
                    height: 40,
                    child: Text('B'),
                  ),
                ),
              ),
            ],
          ),
        );

        focusA.requestFocus();
        await tester.pumpAndSettle();
        expect(find.text('Tip A'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(focusB.hasFocus, isTrue);
        expect(find.text('Tip B'), findsOneWidget);

        // Advance past tooltip A's 100ms dismissDelay.
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();

        expect(find.text('Tip B'), findsOneWidget);
        expect(find.text('Tip A'), findsNothing);
      },
    );

    testWidgets(
      'Escape from focusable overlay content closes tooltip and does not reopen when focus returns to trigger',
      (tester) async {
        final triggerFocus = FocusNode(debugLabel: 'trigger');
        final contentFocus = FocusNode(debugLabel: 'content');
        addTearDown(triggerFocus.dispose);
        addTearDown(contentFocus.dispose);

        await tester.pumpMaterialWidget(
          Center(
            child: NakedTooltip(
              hoverDelay: Duration.zero,
              dismissDelay: Duration.zero,
              animationStyle: AnimationStyle.noAnimation,
              overlayBuilder: (context, animation) => Focus(
                focusNode: contentFocus,
                child: const SizedBox(
                  width: 80,
                  height: 30,
                  child: Text('Focusable Tip'),
                ),
              ),
              child: Focus(focusNode: triggerFocus, child: _trigger),
            ),
          ),
        );

        triggerFocus.requestFocus();
        await tester.pumpAndSettle();
        expect(find.text('Focusable Tip'), findsOneWidget);

        contentFocus.requestFocus();
        await tester.pump();
        expect(contentFocus.hasFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.text('Focusable Tip'), findsNothing);
      },
    );

    testWidgets(
      'toggling deprecated useRootOverlay preserves trigger child state via KeyedSubtree',
      (tester) async {
        var useRoot = false;
        late StateSetter setHostState;

        await tester.pumpMaterialWidget(
          StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              // ignore: deprecated_member_use_from_same_package
              return NakedTooltip(
                useRootOverlay: useRoot,
                overlayBuilder: (context, animation) => const Text('Tip'),
                child: const _StatefulCounterTrigger(),
              );
            },
          ),
        );

        await tester.tap(find.text('Count: 0'));
        await tester.pump();
        expect(find.text('Count: 1'), findsOneWidget);

        setHostState(() => useRoot = true);
        await tester.pump();
        expect(find.text('Count: 1'), findsOneWidget);
      },
    );

    testWidgets(
      'transitioning from open legacy tooltip to RawTooltip reports onOpenChanged(false)',
      (tester) async {
        var useRoot = true;
        late StateSetter setHostState;
        final focus = FocusNode();
        addTearDown(focus.dispose);
        final changes = <bool>[];

        await tester.pumpMaterialWidget(
          StatefulBuilder(
            builder: (context, setState) {
              setHostState = setState;
              // ignore: deprecated_member_use_from_same_package
              return NakedTooltip(
                useRootOverlay: useRoot,
                hoverDelay: Duration.zero,
                dismissDelay: Duration.zero,
                onOpenChanged: changes.add,
                overlayBuilder: (context, animation) => const Text('LegacyTip'),
                child: Focus(focusNode: focus, child: _trigger),
              );
            },
          ),
        );

        focus.requestFocus();
        await tester.pumpAndSettle();
        expect(find.text('LegacyTip'), findsOneWidget);
        expect(changes, [true]);

        // Switch from legacy path (useRootOverlay: true) to RawTooltip path.
        setHostState(() => useRoot = false);
        await tester.pumpAndSettle();

        expect(find.text('LegacyTip'), findsNothing);
        expect(changes, [true, false]);
      },
    );

    testWidgets(
      'Escape reaches an enclosing dismiss action when LegacyNakedTooltip is closed',
      (tester) async {
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
              // ignore: deprecated_member_use_from_same_package
              child: NakedTooltip(
                useRootOverlay: true,
                // Focus does not open before Escape is pressed.
                hoverDelay: const Duration(seconds: 10),
                overlayBuilder: (context, animation) => const Text('LegacyTip'),
                child: Focus(focusNode: focus, child: _trigger),
              ),
            ),
          ),
        );

        focus.requestFocus();
        await tester.pump();
        expect(find.text('LegacyTip'), findsNothing);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        expect(dismissed, 1);
      },
    );
  });
}

class _StatefulCounterTrigger extends StatefulWidget {
  const _StatefulCounterTrigger();

  @override
  State<_StatefulCounterTrigger> createState() =>
      _StatefulCounterTriggerState();
}

class _StatefulCounterTriggerState extends State<_StatefulCounterTrigger> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _count++),
      child: Text('Count: $_count'),
    );
  }
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
