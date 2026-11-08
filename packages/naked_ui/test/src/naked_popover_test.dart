import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:naked_ui/src/utilities/anchored_overlay.dart';

import '../test_helpers.dart';
import 'helpers/builder_state_scope.dart';

Matcher _closeTo(double v, [double eps = 0.5]) =>
    moreOrLessEquals(v, epsilon: eps);

void main() {
  group('NakedPopover', () {
    testWidgets(
      'view-safe panel re-fits when consumed safe-area insets change',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 600);
        tester.view.padding = const FakeViewPadding(bottom: 20);
        tester.view.viewPadding = const FakeViewPadding(bottom: 20);
        addTearDown(tester.view.reset);
        final controller = MenuController();
        const panelKey = Key('refit panel');
        await tester.pumpWidget(
          WidgetsApp(
            color: const Color(0xffffffff),
            builder: (context, child) => Overlay.wrap(
              child: SafeArea(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: NakedPopover(
                    controller: controller,
                    avoidViewInsets: true,
                    constrainToAvailableSpace: true,
                    positioning: const OverlayPositionConfig(
                      collisionPadding: EdgeInsets.all(8),
                    ),
                    popoverBuilder: (context, info) =>
                        const SizedBox(key: panelKey, width: 100, height: 400),
                    child: const SizedBox(width: 80, height: 30),
                  ),
                ),
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        expect(tester.getRect(find.byKey(panelKey)).bottom, greaterThan(192));

        tester.view.padding = const FakeViewPadding(bottom: 400);
        tester.view.viewPadding = const FakeViewPadding(bottom: 400);
        await tester.pumpAndSettle();
        expect(
          tester.getRect(find.byKey(panelKey)).bottom,
          lessThanOrEqualTo(192),
        );
        expect(controller.isOpen, isTrue);
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'view-safe panel respects safe top in a scaled nested Overlay',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(800, 600);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);
        final controller = MenuController();
        const panelKey = Key('panel');
        await tester.pumpWidget(
          WidgetsApp(
            color: const Color(0xffffffff),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(viewPadding: const EdgeInsets.only(top: 80)),
              child: Overlay.wrap(
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Transform.scale(
                    scale: .5,
                    alignment: Alignment.topLeft,
                    child: SizedBox(
                      width: 400,
                      height: 300,
                      child: Overlay.wrap(
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: NakedPopover(
                            controller: controller,
                            avoidViewInsets: true,
                            positioning: const OverlayPositionConfig(
                              collisionPadding: EdgeInsets.zero,
                            ),
                            popoverBuilder: (context, info) => const SizedBox(
                              key: panelKey,
                              width: 300,
                              height: 600,
                            ),
                            child: const SizedBox(width: 80, height: 30),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        controller.open();
        await tester.pumpAndSettle();
        final panel = tester.getRect(find.byKey(panelKey));
        expect(
          panel.top,
          greaterThanOrEqualTo(80),
          reason: 'Panel global rect: $panel',
        );
        expect(tester.takeException(), isNull);
      },
    );
    testWidgets('renders child and is closed by default', (tester) async {
      await tester.pumpMaterialWidget(
        NakedPopover(
          popoverBuilder: (context, info) => const Text('Popover Content'),
          child: const Text('Trigger'),
        ),
      );

      expect(find.text('Trigger'), findsOneWidget);
      expect(find.text('Popover Content'), findsNothing);
    });

    testWidgets('opens on tap and closes on outside tap', (tester) async {
      await tester.pumpMaterialWidget(
        Center(
          child: NakedPopover(
            popoverBuilder: (context, info) => const Text('Popover Content'),
            child: const Text('Trigger'),
          ),
        ),
      );

      expect(find.text('Popover Content'), findsNothing);

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle(); // robust against future animations
      expect(find.text('Popover Content'), findsOneWidget);

      // Tap outside to close
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
    });

    testWidgets('toggles via trigger (tap again closes)', (tester) async {
      await tester.pumpMaterialWidget(
        Center(
          child: NakedPopover(
            popoverBuilder: (context, info) => const Text('Popover Content'),
            child: const Text('Trigger'),
          ),
        ),
      );

      await tester.tap(find.text('Trigger')); // open
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsOneWidget);

      await tester.tap(find.text('Trigger')); // close
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
    });

    testWidgets(
      'closes on Escape key (overlay had focus) and returns focus to trigger',
      (tester) async {
        final triggerFocusNode = FocusNode(debugLabel: 'trigger');

        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: Focus(
                // give the trigger a node we can assert on
                focusNode: triggerFocusNode,
                child: const Text('Trigger'),
              ),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsOneWidget);

        // Press ESC to dismiss
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsNothing);

        // Focus should return to trigger (RawMenuAnchor.childFocusNode path)
        expect(triggerFocusNode.hasFocus, isTrue);
      },
    );

    testWidgets('a caller-provided Focus child is the only trigger tab stop', (
      tester,
    ) async {
      final before = FocusNode(debugLabel: 'before popover');
      final trigger = FocusNode(debugLabel: 'popover trigger');
      final after = FocusNode(debugLabel: 'after popover');
      addTearDown(before.dispose);
      addTearDown(trigger.dispose);
      addTearDown(after.dispose);

      await tester.pumpMaterialWidget(
        Column(
          children: [
            Focus(focusNode: before, child: const SizedBox(height: 20)),
            NakedPopover(
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: Focus(
                focusNode: trigger,
                child: const SizedBox(
                  width: 100,
                  height: 40,
                  child: Text('Trigger'),
                ),
              ),
            ),
            Focus(focusNode: after, child: const SizedBox(height: 20)),
          ],
        ),
      );

      before.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(trigger.hasPrimaryFocus, isTrue);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(after.hasPrimaryFocus, isTrue);
    });

    testWidgets('a Focus child without a node does not add a tab stop', (
      tester,
    ) async {
      final before = FocusNode(debugLabel: 'before popover');
      final after = FocusNode(debugLabel: 'after popover');
      addTearDown(before.dispose);
      addTearDown(after.dispose);

      await tester.pumpMaterialWidget(
        Column(
          children: [
            Focus(focusNode: before, child: const SizedBox(height: 20)),
            NakedPopover(
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: const Focus(
                child: SizedBox(width: 100, height: 40, child: Text('Trigger')),
              ),
            ),
            Focus(focusNode: after, child: const SizedBox(height: 20)),
          ],
        ),
      );

      before.requestFocus();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(after.hasPrimaryFocus, isFalse);

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      expect(after.hasPrimaryFocus, isTrue);
    });

    testWidgets('caller-owned trigger reports keyboard pressed state', (
      tester,
    ) async {
      final trigger = FocusNode(debugLabel: 'popover trigger');
      addTearDown(trigger.dispose);
      Set<WidgetState> states = {};

      await tester.pumpMaterialWidget(
        NakedPopover(
          popoverBuilder: (context, info) => const Text('Popover Content'),
          builder: (context, state, child) {
            states = state.states;
            return child!;
          },
          child: Focus(
            focusNode: trigger,
            child: const SizedBox(
              width: 100,
              height: 40,
              child: Text('Trigger'),
            ),
          ),
        ),
      );

      trigger.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();

      expect(states, contains(WidgetState.pressed));
      expect(find.text('Popover Content'), findsOneWidget);

      await tester.pump(const Duration(milliseconds: 100));
      expect(states, isNot(contains(WidgetState.pressed)));
    });

    testWidgets('opens via Space key on trigger (internal focus)', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        Center(
          child: NakedPopover(
            popoverBuilder: (context, info) => const Text('Popover Content'),
            child: const Text('Trigger'),
          ),
        ),
      );

      // Focus the trigger via TAB (FocusTraversal) then activate with Space
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();

      expect(find.text('Popover Content'), findsOneWidget);
    });

    testWidgets('opens via Enter key on trigger (internal focus)', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        Center(
          child: NakedPopover(
            popoverBuilder: (context, info) => const Text('Popover Content'),
            child: const Text('Trigger'),
          ),
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(find.text('Popover Content'), findsOneWidget);
    });

    testWidgets('positions popover based on anchors', (tester) async {
      const triggerKey = Key('trigger');
      const popoverKey = Key('popover');

      await tester.pumpMaterialWidget(
        Center(
          child: NakedPopover(
            positioning: const OverlayPositionConfig(
              alignment: OverlayAlignment.center,
            ),
            popoverBuilder: (context, info) => const SizedBox(
              key: popoverKey,
              width: 100,
              height: 60,
              child: Text('Popover Content'),
            ),
            child: const SizedBox(
              key: triggerKey,
              width: 80,
              height: 40,
              child: Text('Trigger'),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(triggerKey));
      await tester.pumpAndSettle();

      final triggerCenter = tester.getCenter(find.byKey(triggerKey));
      final popoverCenter = tester.getCenter(find.byKey(popoverKey));
      expect(popoverCenter.dx, _closeTo(triggerCenter.dx)); // horizontal align

      // Popover top aligns to trigger bottom (follower top to target bottom)
      final triggerBottom = tester.getBottomLeft(find.byKey(triggerKey)).dy;
      final popoverTop = tester.getTopLeft(find.byKey(popoverKey)).dy;
      expect(popoverTop, _closeTo(triggerBottom));
    });

    testWidgets('lets content grow taller than the space beside the trigger', (
      tester,
    ) async {
      const triggerKey = Key('trigger');
      BoxConstraints? constraints;

      await tester.pumpMaterialWidget(
        Align(
          alignment: Alignment.bottomCenter,
          child: NakedPopover(
            popoverBuilder: (context, info) => LayoutBuilder(
              builder: (context, value) {
                constraints = value;
                return const SizedBox(width: 100, height: 400);
              },
            ),
            child: const SizedBox(key: triggerKey, width: 80, height: 40),
          ),
        ),
      );
      await tester.tap(find.byKey(triggerKey));
      await tester.pumpAndSettle();

      expect(
        constraints?.maxHeight,
        tester.view.physicalSize.height / tester.view.devicePixelRatio,
      );
    });

    for (final useRootOverlay in [false, true]) {
      for (final offset in [0.0, 200.0]) {
        testWidgets(
          'nested view-safe panel inherits root=$useRootOverlay at offset $offset',
          (tester) async {
            tester.view.devicePixelRatio = 1;
            tester.view.physicalSize = const Size(800, 600);
            addTearDown(tester.view.resetDevicePixelRatio);
            addTearDown(tester.view.resetPhysicalSize);
            final outer = MenuController();
            final inner = MenuController();
            const panelKey = Key('nested safe panel');
            await tester.pumpWidget(
              WidgetsApp(
                color: const Color(0xffffffff),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    viewPadding: const EdgeInsets.only(top: 80, bottom: 60),
                  ),
                  child: Overlay.wrap(
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: offset, top: offset),
                        child: SizedBox(
                          width: 400,
                          height: 300,
                          child: Overlay.wrap(
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: NakedPopover(
                                controller: outer,
                                useRootOverlay: useRootOverlay,
                                avoidViewInsets: true,
                                popoverBuilder: (context, info) => NakedPopover(
                                  controller: inner,
                                  useRootOverlay: !useRootOverlay,
                                  positioning: const OverlayPositionConfig(
                                    collisionPadding: EdgeInsets.all(8),
                                  ),
                                  popoverBuilder: (context, info) =>
                                      const SizedBox(
                                        key: panelKey,
                                        width: 300,
                                        height: 600,
                                      ),
                                  child: const SizedBox(width: 80, height: 30),
                                ),
                                child: const SizedBox(width: 80, height: 30),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            outer.open();
            await tester.pumpAndSettle();
            inner.open();
            await tester.pumpAndSettle();
            final panel = tester.getRect(find.byKey(panelKey));
            // The oversized panel fills the intersection of the target Overlay
            // and the safe view, with the caller's extra collision padding.
            final top = useRootOverlay || offset == 0 ? 88.0 : 208.0;
            final bottom = useRootOverlay ? 532.0 : offset + 292;
            expect(panel.top, _closeTo(top));
            expect(panel.bottom, _closeTo(bottom));
            expect(panel.width, 300);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }

    testWidgets(
      'inherited nearest-overlay mode resolves an intermediary Overlay',
      (tester) async {
        final outer = MenuController();
        final inner = MenuController();
        const intermediaryKey = Key('intermediary overlay');
        const panelKey = Key('intermediary panel');
        await tester.pumpWidget(
          WidgetsApp(
            color: const Color(0xffffffff),
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                viewPadding: const EdgeInsets.only(top: 80, bottom: 60),
              ),
              child: Overlay.wrap(
                child: Center(
                  child: NakedPopover(
                    controller: outer,
                    avoidViewInsets: true,
                    popoverBuilder: (context, info) => SizedBox(
                      width: 250,
                      height: 260,
                      child: Overlay.wrap(
                        key: intermediaryKey,
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: NakedPopover(
                            controller: inner,
                            useRootOverlay: true,
                            positioning: const OverlayPositionConfig(
                              collisionPadding: EdgeInsets.all(8),
                            ),
                            popoverBuilder: (context, info) => const SizedBox(
                              key: panelKey,
                              width: 300,
                              height: 600,
                            ),
                            child: const SizedBox(width: 80, height: 30),
                          ),
                        ),
                      ),
                    ),
                    child: const SizedBox(width: 80, height: 30),
                  ),
                ),
              ),
            ),
          ),
        );
        outer.open();
        await tester.pumpAndSettle();
        inner.open();
        await tester.pumpAndSettle();
        final target = tester.getRect(find.byKey(intermediaryKey));
        final panel = tester.getRect(find.byKey(panelKey));
        final safeView = Rect.fromLTRB(
          0,
          80,
          tester.view.physicalSize.width / tester.view.devicePixelRatio,
          tester.view.physicalSize.height / tester.view.devicePixelRatio - 60,
        );
        expect(panel, target.intersect(safeView).deflate(8));
        expect(tester.takeException(), isNull);
      },
    );

    for (final rawGroup in [false, true]) {
      for (final useRootOverlay in [false, true]) {
        testWidgets(
          '${rawGroup ? 'RawMenuAnchorGroup' : 'NakedMenubar'} resets overlay inheritance to root=$useRootOverlay',
          (tester) async {
            tester.view.devicePixelRatio = 1;
            tester.view.physicalSize = const Size(800, 600);
            addTearDown(tester.view.resetDevicePixelRatio);
            addTearDown(tester.view.resetPhysicalSize);
            final outer = MenuController();
            final inner = MenuController();
            const targetKey = Key('group target overlay');
            const panelKey = Key('group panel');
            const positioning = OverlayPositionConfig(
              collisionPadding: EdgeInsets.all(8),
            );
            const panel = SizedBox(key: panelKey, width: 300, height: 600);
            const trigger = SizedBox(width: 80, height: 30);
            final group = rawGroup
                ? RawMenuAnchorGroup(
                    controller: MenuController(),
                    child: RawMenuAnchor(
                      controller: inner,
                      useRootOverlay: useRootOverlay,
                      overlayBuilder: (context, info) => AnchoredOverlay(
                        info: info,
                        positioning: positioning,
                        useRootOverlay: useRootOverlay,
                        child: panel,
                      ),
                      child: trigger,
                    ),
                  )
                : NakedMenubar(
                    child: NakedMenu<String>(
                      controller: inner,
                      useRootOverlay: useRootOverlay,
                      positioning: positioning,
                      overlayBuilder: (context, info) => panel,
                      child: trigger,
                    ),
                  );
            await tester.pumpWidget(
              WidgetsApp(
                color: const Color(0xffffffff),
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    viewPadding: const EdgeInsets.only(top: 80, bottom: 60),
                  ),
                  child: Overlay.wrap(
                    child: Center(
                      child: NakedPopover(
                        controller: outer,
                        useRootOverlay: !useRootOverlay,
                        avoidViewInsets: true,
                        popoverBuilder: (context, info) => SizedBox(
                          width: 250,
                          height: 260,
                          child: Overlay.wrap(
                            key: targetKey,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: group,
                            ),
                          ),
                        ),
                        child: trigger,
                      ),
                    ),
                  ),
                ),
              ),
            );
            outer.open();
            await tester.pumpAndSettle();
            inner.open();
            await tester.pumpAndSettle();
            final rect = tester.getRect(find.byKey(panelKey));
            const safeView = Rect.fromLTRB(0, 80, 800, 540);
            if (useRootOverlay) {
              expect(rect.height, safeView.height - 16);
              expect(rect.top, 88);
              expect(rect.bottom, 532);
            } else {
              final target = tester.getRect(find.byKey(targetKey));
              expect(rect, target.intersect(safeView).deflate(8));
            }
            expect(tester.takeException(), isNull);
          },
        );
      }
    }

    testWidgets('can position against a separate keyed anchor', (tester) async {
      final anchorKey = GlobalKey();
      const triggerKey = Key('separate-trigger');
      const popoverKey = Key('separate-popover');
      Rect? builderAnchorRect;

      await tester.pumpMaterialWidget(
        Stack(
          children: [
            Positioned(
              left: 80,
              top: 60,
              child: SizedBox(key: anchorKey, width: 120, height: 40),
            ),
            Positioned(
              left: 300,
              top: 160,
              child: NakedPopover(
                anchorKey: anchorKey,
                positioning: const OverlayPositionConfig(
                  avoidCollisions: false,
                ),
                popoverBuilder: (context, info) {
                  builderAnchorRect = info.anchorRect;
                  return const SizedBox(
                    key: popoverKey,
                    width: 80,
                    height: 30,
                    child: Text('Separate content'),
                  );
                },
                child: const SizedBox(
                  key: triggerKey,
                  width: 40,
                  height: 30,
                  child: Text('Separate trigger'),
                ),
              ),
            ),
          ],
        ),
      );

      await tester.tap(find.byKey(triggerKey));
      await tester.pumpAndSettle();

      final anchorRect = tester.getRect(find.byKey(anchorKey));
      final popoverRect = tester.getRect(find.byKey(popoverKey));
      expect(builderAnchorRect, anchorRect);
      expect(popoverRect.topLeft, anchorRect.bottomLeft);
    });

    testWidgets('outside tap: true swallows, false propagates', (tester) async {
      var backgroundTaps = 0;

      Future<void> mount({required bool consumeOutsideTaps}) async {
        backgroundTaps = 0;
        await tester.pumpMaterialWidget(
          Stack(
            children: [
              // Background tap target to detect propagation
              Positioned.fill(
                child: GestureDetector(
                  onTap: () => backgroundTaps++,
                  child: const ColoredBox(color: Colors.transparent),
                ),
              ),
              Center(
                child: NakedPopover(
                  popoverBuilder: (context, info) => const SizedBox(
                    width: 100,
                    height: 60,
                    child: Text('Popover Content'),
                  ),
                  child: const Text('Trigger'),
                  consumeOutsideTaps: consumeOutsideTaps,
                ),
              ),
            ],
          ),
        );
      }

      // consumeOutsideTaps = true: outside tap closes and does not propagate
      await mount(consumeOutsideTaps: true);
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsOneWidget);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
      expect(backgroundTaps, 0, reason: 'outside tap is swallowed');

      // consumeOutsideTaps = false: outside tap closes and propagates
      await mount(consumeOutsideTaps: false);
      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsOneWidget);

      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
      expect(
        backgroundTaps,
        greaterThan(0),
        reason: 'outside tap propagates when not consumed',
      );
    });

    testWidgets('ESC closes even when no outside space is tappable', (
      tester,
    ) async {
      // Regression test: if the overlay covers the whole screen with hit testing,
      // DismissIntent should still close via ESC.
      await tester.pumpMaterialWidget(
        SizedBox.expand(
          child: Center(
            child: NakedPopover(
              popoverBuilder: (context, info) => const SizedBox(
                width: 120,
                height: 80,
                child: Text('Popover Content'),
              ),
              child: const Text('Trigger'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();
      expect(find.text('Popover Content'), findsNothing);
    });

    testStateScopeBuilder<NakedPopoverState>(
      'builder\'s context contains NakedStateScope',
      (builder) => NakedPopover(
        popoverBuilder: (context, info) =>
            const SizedBox(child: Text('Popover Content')),
        builder: builder,
        child: const Text('Trigger'),
      ),
    );

    testWidgets('builder exposes pressed and open interaction states', (
      tester,
    ) async {
      NakedPopoverState? state;

      await tester.pumpMaterialWidget(
        Center(
          child: NakedPopover(
            popoverBuilder: (context, info) => const Text('Popover Content'),
            builder: (context, value, child) {
              state = value;
              return const SizedBox(
                key: Key('trigger'),
                width: 100,
                height: 40,
              );
            },
          ),
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('trigger'))),
      );
      await tester.pump(const Duration(milliseconds: 100));
      expect(state!.isPressed, isTrue);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(state!.isPressed, isFalse);
      expect(state!.isOpen, isTrue);
    });

    group('openOnTap behavior', () {
      testWidgets('does not open on tap when openOnTap is false', (
        tester,
      ) async {
        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              openOnTap: false,
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: const Text('Trigger'),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(
          find.text('Popover Content'),
          findsNothing,
          reason: 'popover should not open when openOnTap is false',
        );
      });

      testWidgets('can still open via controller when openOnTap is false', (
        tester,
      ) async {
        final controller = MenuController();

        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              openOnTap: false,
              controller: controller,
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: const Text('Trigger'),
            ),
          ),
        );

        expect(find.text('Popover Content'), findsNothing);

        controller.open();
        await tester.pumpAndSettle();

        expect(find.text('Popover Content'), findsOneWidget);
      });
    });

    group('openOnTap: false with the caller\'s control', () {
      late FocusNode before;
      late FocusNode after;
      late FocusNode button;
      late MenuController controller;

      setUp(() {
        before = FocusNode(debugLabel: 'before popover');
        after = FocusNode(debugLabel: 'after popover');
        button = FocusNode(debugLabel: 'caller button');
        controller = MenuController();
        addTearDown(before.dispose);
        addTearDown(after.dispose);
        addTearDown(button.dispose);
      });

      Widget row({FocusNode? triggerFocusNode, FocusNode? buttonFocusNode}) {
        return Column(
          children: [
            Focus(focusNode: before, child: const SizedBox(height: 20)),
            NakedPopover(
              controller: controller,
              openOnTap: false,
              triggerFocusNode: triggerFocusNode,
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: NakedButton(
                focusNode: buttonFocusNode,
                onPressed: () =>
                    controller.isOpen ? controller.close() : controller.open(),
                child: const SizedBox(
                  width: 100,
                  height: 40,
                  child: Text('Trigger'),
                ),
              ),
            ),
            Focus(focusNode: after, child: const SizedBox(height: 20)),
          ],
        );
      }

      Future<void> tab(WidgetTester tester) async {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
      }

      testWidgets('the button is the only trigger tab stop', (tester) async {
        await tester.pumpMaterialWidget(
          row(triggerFocusNode: button, buttonFocusNode: button),
        );
        before.requestFocus();
        await tester.pump();

        await tab(tester);
        expect(button.hasPrimaryFocus, isTrue);

        await tab(tester);
        expect(after.hasPrimaryFocus, isTrue);
      });

      testWidgets(
        'the button is the only tab stop without a triggerFocusNode',
        (tester) async {
          await tester.pumpMaterialWidget(row(buttonFocusNode: button));
          before.requestFocus();
          await tester.pump();

          await tab(tester);
          expect(button.hasPrimaryFocus, isTrue);

          await tab(tester);
          expect(after.hasPrimaryFocus, isTrue);
        },
      );

      testWidgets('Enter opens the popover and Escape returns focus to the '
          'button that carries triggerFocusNode', (tester) async {
        await tester.pumpMaterialWidget(
          row(triggerFocusNode: button, buttonFocusNode: button),
        );
        before.requestFocus();
        await tester.pump();
        await tab(tester);
        expect(button.hasPrimaryFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('Popover Content'), findsNothing);
        expect(button.hasPrimaryFocus, isTrue);
      });

      testWidgets('Escape moves focus to the button that carries '
          'triggerFocusNode when it was not focused before opening', (
        tester,
      ) async {
        await tester.pumpMaterialWidget(
          row(triggerFocusNode: button, buttonFocusNode: button),
        );
        before.requestFocus();
        await tester.pump();

        controller.open();
        await tester.pumpAndSettle();
        expect(button.hasFocus, isFalse);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(button.hasPrimaryFocus, isTrue);
      });

      testWidgets('Escape returns focus to the button without a '
          'triggerFocusNode', (tester) async {
        await tester.pumpMaterialWidget(row(buttonFocusNode: button));
        before.requestFocus();
        await tester.pump();
        await tab(tester);
        expect(button.hasPrimaryFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('Popover Content'), findsNothing);
        expect(button.hasPrimaryFocus, isTrue);
      });

      testWidgets('without a triggerFocusNode, Escape returns focus to '
          'whatever had it before opening', (tester) async {
        await tester.pumpMaterialWidget(row(buttonFocusNode: button));
        before.requestFocus();
        await tester.pump();

        controller.open();
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();

        expect(find.text('Popover Content'), findsNothing);
        expect(before.hasPrimaryFocus, isTrue);
      });

      testWidgets('openOnTap: true still makes the trigger the single tab '
          'stop that receives focus back', (tester) async {
        await tester.pumpMaterialWidget(
          Column(
            children: [
              Focus(focusNode: before, child: const SizedBox(height: 20)),
              NakedPopover(
                controller: controller,
                triggerFocusNode: button,
                popoverBuilder: (context, info) =>
                    const Text('Popover Content'),
                child: const SizedBox(
                  width: 100,
                  height: 40,
                  child: Text('Trigger'),
                ),
              ),
              Focus(focusNode: after, child: const SizedBox(height: 20)),
            ],
          ),
        );
        before.requestFocus();
        await tester.pump();

        await tab(tester);
        expect(button.hasPrimaryFocus, isTrue);

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsOneWidget);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsNothing);
        expect(button.hasPrimaryFocus, isTrue);

        await tab(tester);
        expect(after.hasPrimaryFocus, isTrue);
      });
    });

    group('lifecycle callbacks', () {
      testWidgets('calls onOpen when popover opens', (tester) async {
        bool onOpenCalled = false;

        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              onOpen: () => onOpenCalled = true,
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: const Text('Trigger'),
            ),
          ),
        );

        expect(onOpenCalled, isFalse);

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(onOpenCalled, isTrue);
      });

      testWidgets('calls onClose when popover closes', (tester) async {
        bool onCloseCalled = false;

        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              onClose: () => onCloseCalled = true,
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: const Text('Trigger'),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(onCloseCalled, isFalse);

        // Close by tapping outside
        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();

        expect(onCloseCalled, isTrue);
      });
    });

    group('custom open/close request handlers', () {
      testWidgets('onOpenRequested can prevent opening', (tester) async {
        bool customShowCalled = false;

        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              onOpenRequested: (info, show) {
                customShowCalled = true;
                // Intentionally not calling show() to prevent opening
              },
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: const Text('Trigger'),
            ),
          ),
        );

        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();

        expect(customShowCalled, isTrue);
        expect(
          find.text('Popover Content'),
          findsNothing,
          reason: 'popover should not open when show() is not called',
        );
      });

      testWidgets('onCloseRequested can delay closing', (tester) async {
        bool customHideCalled = false;
        VoidCallback? storedHide;

        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              onCloseRequested: (hide) {
                customHideCalled = true;
                storedHide = hide;
                // Intentionally not calling hide() immediately
              },
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: const Text('Trigger'),
            ),
          ),
        );

        // Open popover
        await tester.tap(find.text('Trigger'));
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsOneWidget);

        // Tap outside to trigger close request
        await tester.tapAt(const Offset(5, 5));
        await tester.pumpAndSettle();

        expect(customHideCalled, isTrue);
        expect(
          find.text('Popover Content'),
          findsOneWidget,
          reason: 'popover should still be open until hide() is called',
        );

        // Now call hide
        storedHide?.call();
        await tester.pumpAndSettle();

        expect(find.text('Popover Content'), findsNothing);
      });
    });

    group('controller', () {
      testWidgets('uses a replacement external controller', (tester) async {
        final firstController = MenuController();
        final secondController = MenuController();
        late StateSetter rebuild;
        MenuController controller = firstController;

        await tester.pumpMaterialWidget(
          StatefulBuilder(
            builder: (context, setState) {
              rebuild = setState;
              return NakedPopover(
                controller: controller,
                popoverBuilder: (context, info) =>
                    const Text('Popover Content'),
                child: const Text('Trigger'),
              );
            },
          ),
        );

        rebuild(() => controller = secondController);
        await tester.pump();

        secondController.open();
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsOneWidget);
        expect(secondController.isOpen, isTrue);
      });

      testWidgets('can open and close via external controller', (tester) async {
        final controller = MenuController();

        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              controller: controller,
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: const Text('Trigger'),
            ),
          ),
        );

        expect(find.text('Popover Content'), findsNothing);

        controller.open();
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsOneWidget);

        controller.close();
        await tester.pumpAndSettle();
        expect(find.text('Popover Content'), findsNothing);
      });

      testWidgets('controller.isOpen reflects current state', (tester) async {
        final controller = MenuController();

        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              controller: controller,
              popoverBuilder: (context, info) => const Text('Popover Content'),
              child: const Text('Trigger'),
            ),
          ),
        );

        expect(controller.isOpen, isFalse);

        controller.open();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isTrue);

        controller.close();
        await tester.pumpAndSettle();
        expect(controller.isOpen, isFalse);
      });
    });

    testWidgets(
      'reports focused state when triggerFocusNode matches Focus child node',
      (tester) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        Set<WidgetState> latestStates = const {};

        await tester.pumpMaterialWidget(
          Center(
            child: NakedPopover(
              triggerFocusNode: focusNode,
              popoverBuilder: (context, info) => const Text('Popover Content'),
              builder: (context, state, child) {
                latestStates = state.states.toSet();
                return child ?? const SizedBox.shrink();
              },
              child: Focus(focusNode: focusNode, child: const Text('Trigger')),
            ),
          ),
        );

        expect(latestStates, isNot(contains(WidgetState.focused)));

        focusNode.requestFocus();
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isTrue);
        expect(latestStates, contains(WidgetState.focused));

        focusNode.unfocus();
        await tester.pumpAndSettle();

        expect(focusNode.hasFocus, isFalse);
        expect(latestStates, isNot(contains(WidgetState.focused)));
      },
    );
  });
}
