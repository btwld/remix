import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/motion_harness.dart';

const _enter = Duration(milliseconds: 300);
const _exit = Duration(milliseconds: 200);
const _tick = Duration(milliseconds: 1);

final class _Probe {
  Animation<double>? animation;
  Rect? anchor;
}

RemixPanelTransition _transition(_Probe probe) => RemixPanelTransition(
  duration: _enter,
  reverseDuration: _exit,
  builder: (context, info, panel) {
    probe.animation = info.animation;
    probe.anchor = info.anchorRect;
    return FadeTransition(opacity: info.animation, child: panel);
  },
);

Widget _select({SelectStyler? style, SelectSpec? styleSpec}) =>
    RemixSelect<String>(
      onChanged: (_) {},
      trigger: const RemixSelectTrigger(placeholder: 'Choose'),
      items: const [RemixSelectItem(value: 'a', label: 'Alpha')],
      style: style ?? SelectStyler(),
      styleSpec: styleSpec,
    );

void main() {
  group('RemixSelect panelTransition', () {
    testWidgets('a style transition drives the open and holds the exit', (
      tester,
    ) async {
      final probe = _Probe();
      await MotionHarness.pump(
        tester,
        _select(style: SelectStyler().panelTransition(_transition(probe))),
      );

      await tester.tap(find.text('Choose'));
      await tester.pump();
      await tester.pump();
      await tester.pump(_enter ~/ 2);
      expect(probe.animation!.value, closeTo(.5, .05));
      expect(
        probe.anchor!.size,
        tester.getSize(find.byType(NakedSelect<String>).first),
      );
      await tester.pump(_enter + _tick);
      expect(probe.animation!.value, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(_exit ~/ 2);
      expect(find.text('Alpha'), findsOneWidget);
      expect(probe.animation!.value, closeTo(.5, .05));

      await tester.pump(_exit + _tick);
      await tester.pump();
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('a raw styleSpec carries the transition', (tester) async {
      final probe = _Probe();
      await MotionHarness.pump(
        tester,
        _select(styleSpec: SelectSpec(panelTransition: _transition(probe))),
      );

      await tester.tap(find.text('Choose'));
      await tester.pump();
      await tester.pump();
      await tester.pump(_enter + _tick);

      expect(probe.animation!.value, 1);
    });

    testWidgets('the default is the 150 ms fade it always was', (tester) async {
      await MotionHarness.pump(tester, _select());

      await tester.tap(find.text('Choose'));
      await tester.pump();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 75));
      final halfway = effectiveOpacity(tester, find.text('Alpha'));
      expect(halfway, inExclusiveRange(0, 1));

      await tester.pump(const Duration(milliseconds: 76));
      expect(effectiveOpacity(tester, find.text('Alpha')), 1);
    });

    testWidgets('reduced motion opens and closes a custom transition at once', (
      tester,
    ) async {
      final probe = _Probe();
      final harness = await MotionHarness.pump(
        tester,
        _select(style: SelectStyler().panelTransition(_transition(probe))),
      );
      await harness.set(MotionRequest.mediaQuery, enabled: true);

      await tester.tap(find.text('Choose'));
      await tester.pump();
      expect(probe.animation!.value, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('Alpha'), findsNothing);
    });
  });
}
