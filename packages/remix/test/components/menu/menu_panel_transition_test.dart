import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/motion_harness.dart';
import '../../helpers/test_helpers.dart';

const _enter = Duration(milliseconds: 360);
const _exit = Duration(milliseconds: 260);

/// A simulation is done only after its duration has passed, not at it.
const _tick = Duration(milliseconds: 1);

final class _Probe {
  final progress = <double>[];
  final anchors = <Rect>[];
  OverlayPlacement? placement;
  Animation<double>? animation;
}

RemixPanelTransition _transition(_Probe probe) => RemixPanelTransition(
  duration: _enter,
  reverseDuration: _exit,
  builder: (context, info, panel) {
    probe.animation = info.animation;
    probe.anchors.add(info.anchorRect);
    probe.placement = OverlayPlacement.maybeOf(context);
    return FadeTransition(opacity: info.animation, child: panel);
  },
);

/// Taps the trigger and pumps until the open animation has started, so the
/// next pump is its first tick.
Future<void> _openPanel(WidgetTester tester) async {
  await tester.tap(find.text('Options'));
  await tester.pump();
  await tester.pump();
}

RemixMenu<String> _menu(
  _Probe probe, {
  MenuController? controller,
  void Function(VoidCallback hideOverlay)? onCloseRequested,
  VoidCallback? onClose,
  ValueChanged<String>? onSelected,
  MenuSpec? styleSpec,
}) => RemixMenu<String>(
  controller: controller,
  trigger: const RemixMenuTrigger(label: 'Options'),
  items: const [
    RemixMenuItem(value: 'copy', label: 'Copy'),
    RemixMenuItem(value: 'paste', label: 'Paste'),
  ],
  onSelected: onSelected,
  onClose: onClose,
  onCloseRequested: onCloseRequested,
  style: MenuStyler().panelTransition(_transition(probe)),
  styleSpec: styleSpec,
);

void main() {
  group('RemixPanelTransition', () {
    test('has value equality and defaults reverseDuration to duration', () {
      Widget builder(BuildContext c, RemixPanelTransitionInfo i, Widget p) => p;

      expect(
        RemixPanelTransition(builder: builder),
        RemixPanelTransition(builder: builder),
      );
      expect(
        RemixPanelTransition(builder: builder),
        isNot(RemixPanelTransition(builder: builder, duration: Duration.zero)),
      );
      expect(RemixPanelTransition(builder: builder).reverseDuration, isNull);
    });

    test('MenuSpec carries and styler merges the transition', () {
      Widget builder(BuildContext c, RemixPanelTransitionInfo i, Widget p) => p;
      final transition = RemixPanelTransition(builder: builder);

      expect(const MenuSpec().panelTransition, isNull);
      expect(MenuSpec(panelTransition: transition).panelTransition, transition);
      expect(
        MenuStyler().panelTransition(transition).merge(MenuStyler()),
        MenuStyler().panelTransition(transition),
      );
    });
  });

  group('RemixMenu panelTransition', () {
    testWidgets('opens through the animation, keeps the panel mounted '
        'through the exit and then hides', (tester) async {
      final probe = _Probe();
      final calls = <String>[];
      await tester.pumpRemixApp(
        _menu(probe, onClose: () => calls.add('close')),
      );

      await tester.tap(find.text('Options'));
      await tester.pump();
      expect(find.text('Copy'), findsOneWidget);
      expect(probe.animation!.value, 0);

      await tester.pump(); // post-frame start
      await tester.pump(_enter ~/ 2);
      expect(probe.animation!.value, closeTo(.5, .05));
      await tester.pump(_enter + _tick);
      expect(probe.animation!.value, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('Copy'), findsOneWidget, reason: 'exit is playing');
      expect(calls, isEmpty);

      await tester.pump(_exit ~/ 2);
      expect(find.text('Copy'), findsOneWidget);
      expect(probe.animation!.value, closeTo(.5, .05));
      expect(calls, isEmpty);

      await tester.pump(_exit + _tick);
      await tester.pump();
      expect(find.text('Copy'), findsNothing);
      expect(calls, ['close']);
    });

    testWidgets('hands the builder the trigger bounds and the placement', (
      tester,
    ) async {
      final probe = _Probe();
      await tester.pumpRemixApp(_menu(probe));

      await _openPanel(tester);

      final trigger = tester.getRect(find.byType(NakedButton).first);
      expect(probe.anchors.last.size, trigger.size);
      expect(probe.anchors.last.topLeft, trigger.topLeft);
      expect(probe.placement, isNotNull);
      await tester.pump(_enter + _tick);
    });

    testWidgets('a panel with no transition shows and hides at once', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        RemixMenu<String>(
          trigger: const RemixMenuTrigger(label: 'Options'),
          items: const [RemixMenuItem(value: 'copy', label: 'Copy')],
        ),
      );

      await tester.tap(find.text('Options'));
      await tester.pump();
      expect(find.text('Copy'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('Copy'), findsNothing);
    });

    testWidgets('selecting an item plays the exit and reports the value once', (
      tester,
    ) async {
      final probe = _Probe();
      final selected = <String>[];
      await tester.pumpRemixApp(_menu(probe, onSelected: selected.add));

      await _openPanel(tester);
      await tester.pump(_enter + _tick);
      await tester.tap(find.text('Paste'));
      await tester.pump();

      expect(selected, ['paste']);
      expect(find.text('Paste'), findsOneWidget);
      await tester.pump(_exit + _tick);
      await tester.pump();
      expect(find.text('Paste'), findsNothing);
      expect(selected, ['paste']);
    });

    testWidgets('a leaving panel takes no pointer input', (tester) async {
      final probe = _Probe();
      final selected = <String>[];
      await tester.pumpRemixApp(_menu(probe, onSelected: selected.add));

      await _openPanel(tester);
      await tester.pump(_enter + _tick);
      await tester.tap(find.text('Paste'));
      await tester.pump(_exit ~/ 2);
      await tester.tap(find.text('Copy'), warnIfMissed: false);
      await tester.pump(_exit + _tick);

      expect(selected, ['paste']);
    });

    testWidgets('a caller onCloseRequested keeps the panel until hideOverlay '
        'and its hideOverlay plays the exit', (tester) async {
      final probe = _Probe();
      final requests = <VoidCallback>[];
      await tester.pumpRemixApp(_menu(probe, onCloseRequested: requests.add));

      await _openPanel(tester);
      await tester.pump(_enter + _tick);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(requests, hasLength(1));
      await tester.pump(_exit * 2);
      expect(find.text('Copy'), findsOneWidget);
      expect(probe.animation!.value, 1, reason: 'the caller has not hidden');

      requests.single();
      await tester.pump();
      await tester.pump(_exit ~/ 2);
      expect(find.text('Copy'), findsOneWidget);
      await tester.pump(_exit + _tick);
      await tester.pump();
      expect(find.text('Copy'), findsNothing);
    });

    testWidgets('a second close request during the exit does nothing more', (
      tester,
    ) async {
      final probe = _Probe();
      final controller = MenuController();
      final closes = <String>[];
      await tester.pumpRemixApp(
        _menu(probe, controller: controller, onClose: () => closes.add('x')),
      );

      await _openPanel(tester);
      await tester.pump(_enter + _tick);
      controller.close();
      await tester.pump(_exit ~/ 4);
      controller.close();
      await tester.pump(_exit + _tick);
      await tester.pump();

      expect(find.text('Copy'), findsNothing);
      expect(closes, ['x']);
    });

    testWidgets('closing before the open frame hides at once', (tester) async {
      final probe = _Probe();
      final controller = MenuController();
      await tester.pumpRemixApp(_menu(probe, controller: controller));

      controller.open();
      await tester.pump();
      controller.close();
      await tester.pump();
      await tester.pump();

      expect(find.text('Copy'), findsNothing);
    });

    testWidgets('reduced motion opens and closes at once', (tester) async {
      final probe = _Probe();
      final harness = await MotionHarness.pump(tester, _menu(probe));
      await harness.set(MotionRequest.mediaQuery, enabled: true);

      await _openPanel(tester);
      expect(probe.animation!.value, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('Copy'), findsNothing);
    });

    testWidgets('a raw styleSpec carries the transition', (tester) async {
      final probe = _Probe();
      await tester.pumpRemixApp(
        _menu(probe, styleSpec: MenuSpec(panelTransition: _transition(probe))),
      );

      await _openPanel(tester);
      await tester.pump(_enter ~/ 2);

      expect(probe.animation!.value, closeTo(.5, .05));
      await tester.pump(_enter + _tick);
    });
  });
}
