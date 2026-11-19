import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import 'combobox_test_host.dart';

const _enter = Duration(milliseconds: 300);
const _exit = Duration(milliseconds: 200);
const _tick = Duration(milliseconds: 16);

Widget _combobox(List<Animation<double>> animations, {List<Rect>? anchors}) =>
    RemixCombobox<String>(
      optionsBuilder: (_) => suggestions,
      style: testComboboxStyle().panelTransition(
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
    );

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.byType(EditableText));
  await tester.pump();
  await tester.enterText(find.byType(EditableText), 'A');
  await tester.pump();
}

void main() {
  group('RemixCombobox panelTransition', () {
    testWidgets('plays the open on the panel', (tester) async {
      final animations = <Animation<double>>[];
      final anchors = <Rect>[];
      await tester.pumpWidget(
        comboboxHost(_combobox(animations, anchors: anchors)),
      );
      await _open(tester);
      expect(find.text('Apple'), findsOneWidget);
      expect(animations.last.value, lessThan(1));
      await tester.pump(_enter ~/ 2);
      expect(animations.last.value, closeTo(.5, .1));
      await tester.pump(_enter + _tick);
      expect(animations.last.value, 1);
      expect(anchors.last.width, 280);
      expect(anchors.last.height, greaterThan(0));
    });

    testWidgets('keeps a snapshot of the panel for the exit', (tester) async {
      final animations = <Animation<double>>[];
      await tester.pumpWidget(comboboxHost(_combobox(animations)));
      await _open(tester);
      await tester.pump(_enter + _tick);
      await tester.pump();

      // Escape hides the suggestions: the panel unmounts at once, and the
      // exit plays on its image in the overlay.
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump();
      expect(find.text('Apple'), findsNothing);
      expect(find.byType(RawImage), findsOneWidget);
      expect(animations.last.value, closeTo(1, .2));

      await tester.pump(_exit ~/ 2);
      expect(animations.last.value, closeTo(.5, .15));

      await tester.pump(_exit + _tick);
      await tester.pump();
      expect(find.byType(RawImage), findsNothing);
    });

    testWidgets('a combobox without a transition shows and hides at once', (
      tester,
    ) async {
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => suggestions,
            style: testComboboxStyle(),
          ),
        ),
      );
      await _open(tester);
      expect(find.text('Apple'), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('Apple'), findsNothing);
      expect(find.byType(RawImage), findsNothing);
    });

    testWidgets('reduced motion opens whole and plays no exit', (tester) async {
      final animations = <Animation<double>>[];
      await tester.pumpWidget(
        MediaQuery(
          data: const MediaQueryData(disableAnimations: true),
          child: comboboxHost(_combobox(animations)),
        ),
      );
      await _open(tester);
      await tester.pump();
      expect(animations.last.value, 1);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump();
      expect(find.byType(RawImage), findsNothing);
    });

    testWidgets('reopening drops an exit that is still playing', (
      tester,
    ) async {
      final animations = <Animation<double>>[];
      await tester.pumpWidget(comboboxHost(_combobox(animations)));
      await _open(tester);
      await tester.pump(_enter + _tick);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      await tester.pump(_exit ~/ 4);
      await tester.enterText(find.byType(EditableText), 'Ap');
      await tester.pump();
      await tester.pump();
      expect(find.byType(RawImage), findsNothing);
      expect(find.text('Apple'), findsOneWidget);
    });

    test('ComboboxPanelSpec carries and merges the transition', () {
      final transition = RemixPanelTransition(
        builder: (context, info, panel) => panel,
      );
      final spec = const ComboboxPanelSpec().copyWith(
        panelTransition: transition,
      );
      expect(spec.panelTransition, transition);
      expect(const ComboboxPanelSpec().panelTransition, isNull);
    });
  });
}
