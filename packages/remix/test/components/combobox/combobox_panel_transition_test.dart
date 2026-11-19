import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/motion_harness.dart';
import 'combobox_test_host.dart';

const _enter = Duration(milliseconds: 300);
const _exit = Duration(milliseconds: 200);
const _tick = Duration(milliseconds: 16);

final class _Probe {
  final animations = <Animation<double>>[];
  final anchors = <Rect>[];
}

Widget _combobox(_Probe probe) => RemixCombobox<String>(
  optionsBuilder: (_) => suggestions,
  style: testComboboxStyle().panel(
    ComboboxPanelStyler().panelTransition(
      RemixPanelTransition(
        duration: _enter,
        reverseDuration: _exit,
        builder: (context, info, panel) {
          probe.animations.add(info.animation);
          probe.anchors.add(info.anchorRect);
          return FadeTransition(opacity: info.animation, child: panel);
        },
      ),
    ),
  ),
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(EditableText));
  await tester.pump();
  await tester.enterText(find.byType(EditableText), 'A');
  await tester.pump();
  await tester.pump();
}

void main() {
  group('RemixCombobox panelTransition', () {
    testWidgets('plays the open on the panel', (tester) async {
      final probe = _Probe();
      await tester.pumpWidget(comboboxHost(_combobox(probe)));
      await _open(tester);

      expect(find.text('Apple'), findsOneWidget);
      await tester.pump(_enter ~/ 2);
      expect(probe.animations.last.value, closeTo(.5, .1));
      await tester.pump(_enter + _tick);
      expect(probe.animations.last.value, 1);
      expect(probe.anchors.last.width, 280);
      expect(probe.anchors.last.height, greaterThan(0));
    });

    testWidgets('holds the panel through the exit and then lets go', (
      tester,
    ) async {
      final probe = _Probe();
      var closes = 0;
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => suggestions,
            onClose: () => closes++,
            style: testComboboxStyle().panel(
              ComboboxPanelStyler().panelTransition(
                RemixPanelTransition(
                  duration: _enter,
                  reverseDuration: _exit,
                  builder: (context, info, panel) {
                    probe.animations.add(info.animation);
                    return FadeTransition(
                      opacity: info.animation,
                      child: panel,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      await _open(tester);
      await tester.pump(_enter + _tick);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      // The very frame the panel is hidden still shows it.
      expect(find.text('Apple'), findsOneWidget);
      await tester.pump(_tick);
      await tester.pump(_exit ~/ 2);
      expect(find.text('Apple'), findsOneWidget);
      expect(probe.animations.last.value, closeTo(.5, .15));
      expect(closes, 1);

      await tester.pump(_exit + _tick);
      await tester.pump();
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('a panel with no transition hides at once', (tester) async {
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => suggestions,
            style: testComboboxStyle(),
          ),
        ),
      );
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump();

      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('opening again during the exit brings the panel back', (
      tester,
    ) async {
      final probe = _Probe();
      await tester.pumpWidget(comboboxHost(_combobox(probe)));
      await _open(tester);
      await tester.pump(_enter + _tick);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(_exit ~/ 2);

      await tester.enterText(find.byType(EditableText), 'Ap');
      await tester.pump();
      await tester.pump();
      await tester.pump(_enter + _tick);
      await tester.pump(_exit + _tick);

      expect(find.text('Apple'), findsOneWidget);
      expect(probe.animations.last.value, 1);
    });

    testWidgets('reduced motion hides at once', (tester) async {
      final probe = _Probe();
      final harness = await MotionHarness.pump(tester, _combobox(probe));
      await harness.set(MotionRequest.mediaQuery, enabled: true);
      await tester.tap(find.byType(EditableText));
      await tester.enterText(find.byType(EditableText), 'A');
      await tester.pump();
      await tester.pump();

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump();
      await tester.pump();
      expect(find.text('Apple'), findsNothing);
    });

    test('the panel spec carries the transition', () {
      const transition = RemixPanelTransition(builder: _passThrough);

      expect(const ComboboxPanelSpec().panelTransition, isNull);
      expect(
        const ComboboxPanelSpec(panelTransition: transition).panelTransition,
        transition,
      );
      expect(
        ComboboxPanelStyler()
            .panelTransition(transition)
            .merge(ComboboxPanelStyler()),
        ComboboxPanelStyler().panelTransition(transition),
      );
    });
  });
}

Widget _passThrough(
  BuildContext context,
  RemixPanelTransitionInfo info,
  Widget panel,
) => panel;
