import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show LogicalKeyboardKey;
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _enter = Duration(milliseconds: 300);
const _exit = Duration(milliseconds: 200);
const _tick = Duration(milliseconds: 1);

RemixPopover _popover(
  List<Animation<double>> animations, {
  List<Rect>? anchors,
  void Function(VoidCallback hideOverlay)? onCloseRequested,
}) => RemixPopover(
  popoverChild: const Text('Popover content'),
  onCloseRequested: onCloseRequested,
  style: PopoverStyler().panelTransition(
    RemixPanelTransition(
      duration: _enter,
      reverseDuration: _exit,
      builder: (context, info, panel) {
        animations.add(info.animation);
        anchors?.add(info.anchorRect);
        return FadeTransition(opacity: info.animation, child: panel);
      },
    ),
  ),
  child: const Text('Open popover'),
);

void main() {
  group('RemixPopover panelTransition', () {
    testWidgets('plays the open and the exit and keeps the panel mounted', (
      tester,
    ) async {
      final animations = <Animation<double>>[];
      final anchors = <Rect>[];
      await tester.pumpRemixApp(_popover(animations, anchors: anchors));

      await tester.tap(find.text('Open popover'));
      await tester.pump();
      expect(animations.last.value, 0);
      await tester.pump();
      await tester.pump(_enter ~/ 2);
      expect(animations.last.value, closeTo(.5, .05));
      await tester.pump(_enter + _tick);
      expect(animations.last.value, 1);
      expect(anchors.last.size, tester.getSize(find.text('Open popover')));

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(_exit ~/ 2);
      expect(find.text('Popover content'), findsOneWidget);
      expect(animations.last.value, closeTo(.5, .1));

      await tester.pump(_exit + _tick);
      await tester.pump();
      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('a caller onCloseRequested decides when the exit plays', (
      tester,
    ) async {
      final animations = <Animation<double>>[];
      final requests = <VoidCallback>[];
      await tester.pumpRemixApp(
        _popover(animations, onCloseRequested: requests.add),
      );

      await tester.tap(find.text('Open popover'));
      await tester.pump();
      await tester.pump();
      await tester.pump(_enter + _tick);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(_exit * 2);

      expect(requests, hasLength(1));
      expect(find.text('Popover content'), findsOneWidget);
      expect(animations.last.value, 1);

      requests.single();
      await tester.pump();
      await tester.pump(_exit ~/ 2);
      expect(find.text('Popover content'), findsOneWidget);
      await tester.pump(_exit + _tick);
      await tester.pump();
      expect(find.text('Popover content'), findsNothing);
    });

    testWidgets('without a transition the panel hides at once', (tester) async {
      await tester.pumpRemixApp(
        const RemixPopover(
          popoverChild: Text('Popover content'),
          child: Text('Open popover'),
        ),
      );

      await tester.tap(find.text('Open popover'));
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(find.text('Popover content'), findsNothing);
    });

    test('PopoverSpec carries the transition', () {
      Widget builder(BuildContext c, RemixPanelTransitionInfo i, Widget p) => p;
      final transition = RemixPanelTransition(builder: builder);

      expect(const PopoverSpec().panelTransition, isNull);
      expect(
        PopoverSpec(panelTransition: transition).panelTransition,
        transition,
      );
    });
  });
}
