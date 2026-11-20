import 'dart:ui' show SemanticsAction;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart' show NakedCombobox;
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
  style: _transitionStyle(probe),
);

bool _retainsPanel(WidgetTester tester) =>
    tester
        .widget<NakedCombobox<String>>(find.byType(NakedCombobox<String>))
        .exitBuilder !=
    null;

ComboboxStyler _transitionStyle(_Probe probe) => testComboboxStyle().panel(
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
      expect(find.text('Apple'), findsNothing);
      expect(closes, 1);
      await tester.pump();
      await tester.pump(_exit ~/ 2);
      expect(find.text('Apple'), findsOneWidget);
      expect(probe.animations.last.value, closeTo(.5, .15));
      expect(closes, 1);

      await tester.pump(_exit + _tick);
      await tester.pump();
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('the open runs in the frame the panel mounts', (tester) async {
      final probe = _Probe();
      await tester.pumpWidget(comboboxHost(_combobox(probe)));
      await tester.tap(find.byType(EditableText));
      await tester.pump(Duration.zero);

      // The first frame already has the panel and its transition running.
      expect(find.text('Apple'), findsOneWidget);
      expect(probe.animations.last.status, AnimationStatus.forward);
      expect(probe.animations.last.value, 0);

      // One long step is measured from that frame, not from the next one.
      await tester.pump(_enter ~/ 2);
      expect(probe.animations.last.value, closeTo(.5, .01));
    });

    testWidgets('the held exit starts after one empty frame', (tester) async {
      final probe = _Probe();
      await tester.pumpWidget(comboboxHost(_combobox(probe)));
      await _open(tester);
      await tester.pump(_enter + _tick);
      expect(probe.animations.last.value, 1);
      final bounds = tester.getRect(find.text('Apple'));

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump(Duration.zero);
      expect(find.text('Apple'), findsNothing);
      expect(probe.animations.last.status, AnimationStatus.completed);
      await tester.pump(Duration.zero);

      expect(find.text('Apple'), findsOneWidget);
      expect(tester.getRect(find.text('Apple')), bounds);
      expect(probe.animations.last.value, 1);
      expect(probe.animations.last.status, AnimationStatus.reverse);

      // The transition is applied once: a second host would square the fade.
      await tester.pump(_exit ~/ 2);
      expect(probe.animations.last.value, closeTo(.5, .01));
      final fades = find.ancestor(
        of: find.text('Apple'),
        matching: find.byType(FadeTransition),
      );
      expect(fades, findsOneWidget);
      expect(
        tester.widget<FadeTransition>(fades).opacity.value,
        closeTo(.5, .01),
      );
    });

    testWidgets('announces the field and the options, and not the exit copy', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => suggestions,
            label: 'Fruit',
            style: testComboboxStyle().panel(
              ComboboxPanelStyler().panelTransition(
                RemixPanelTransition(
                  duration: _enter,
                  reverseDuration: _exit,
                  builder: (context, info, panel) => Semantics(
                    label: 'Transition wrapper',
                    container: true,
                    explicitChildNodes: true,
                    child: FadeTransition(
                      opacity: info.animation,
                      child: panel,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final editor = tester.semantics
          .simulatedAccessibilityTraversal()
          .singleWhere(
            (node) => node.getSemanticsData().flagsCollection.isTextField,
          );
      editor.owner!.performAction(editor.id, SemanticsAction.tap);
      await tester.pump();
      editor.owner!.performAction(editor.id, SemanticsAction.setText, 'A');
      await tester.pump();
      await tester.pump(_enter ~/ 2);

      // Mid-open: the field keeps its name and the options are named buttons.
      expect(find.bySemanticsLabel('Fruit'), findsOneWidget);
      expect(find.bySemanticsLabel('Transition wrapper'), findsOneWidget);
      final traversal = tester.semantics.simulatedAccessibilityTraversal();
      expect(
        traversal.map((node) => node.getSemanticsData().label),
        containsAll(suggestions),
      );
      for (final option in suggestions) {
        expect(
          tester.getSemantics(find.bySemanticsLabel(option)),
          isSemantics(
            isButton: true,
            isEnabled: true,
            isFocusable: true,
            hasEnabledState: true,
            hasTapAction: true,
            hasFocusAction: true,
          ),
        );
      }

      await tester.pump(_enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump(Duration.zero);
      await tester.pump(Duration.zero);
      await tester.pump(_exit ~/ 2);
      // Mid-exit the panel is drawn, but the copy takes no part in semantics.
      expect(find.text('Apple'), findsOneWidget);
      expect(find.bySemanticsLabel('Apple'), findsNothing);
      expect(find.bySemanticsLabel('Transition wrapper'), findsNothing);
      expect(find.bySemanticsLabel('Fruit'), findsOneWidget);
      handle.dispose();
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
      expect(_retainsPanel(tester), isFalse);
      await _open(tester);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();

      expect(find.text('Apple'), findsNothing);
      await tester.enterText(find.byType(EditableText), 'Ap');
      await tester.pump();
      expect(find.text('Apple'), findsOneWidget);
    });

    testWidgets('changing transition styles preserves the editor', (
      tester,
    ) async {
      final probe = _Probe();
      final style = ValueNotifier(testComboboxStyle());
      addTearDown(style.dispose);
      await tester.pumpWidget(
        comboboxHost(
          ValueListenableBuilder<ComboboxStyler>(
            valueListenable: style,
            builder: (context, value, _) => RemixCombobox<String>(
              optionsBuilder: (_) => suggestions,
              style: value,
            ),
          ),
        ),
      );
      await _open(tester);
      final editor = find.byType(EditableText);
      final state = tester.state<EditableTextState>(editor);
      final controller = state.widget.controller;
      controller.selection = const TextSelection.collapsed(offset: 0);

      expect(_retainsPanel(tester), isFalse);
      for (final (newStyle, retainsPanel) in [
        (_transitionStyle(probe), true),
        (testComboboxStyle(), false),
      ]) {
        style.value = newStyle;
        await tester.pump();
        expect(_retainsPanel(tester), retainsPanel);
        expect(tester.state<EditableTextState>(editor), same(state));
        expect(state.widget.focusNode.hasFocus, isTrue);
        expect(controller.text, 'A');
        expect(controller.selection, const TextSelection.collapsed(offset: 0));
      }
      expect(probe.animations, isNotEmpty);
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('a transition from an inherited overlay variant retains exit', (
      tester,
    ) async {
      final probe = _Probe();
      await tester.pumpWidget(
        comboboxHost(
          StyleProvider<ComboboxSpec>(
            style: ComboboxStyler().onBuilder((context) {
              return context
                          .getInheritedWidgetOfExactType<
                            AutocompleteHighlightedOption
                          >() ==
                      null
                  ? ComboboxStyler()
                  : _transitionStyle(probe);
            }),
            child: RemixCombobox<String>(optionsBuilder: (_) => suggestions),
          ),
        ),
      );
      expect(_retainsPanel(tester), isTrue);
      await _open(tester);
      await tester.pump(_enter + _tick);
      expect(probe.animations.last.value, 1);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(find.text('Apple'), findsNothing);
      await tester.pump();
      expect(find.text('Apple'), findsOneWidget);
      expect(probe.animations.last.status, AnimationStatus.reverse);
    });

    testWidgets('raw spec without motion bypasses the fluent exit', (
      tester,
    ) async {
      final probe = _Probe();
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => suggestions,
            style: _transitionStyle(probe),
            styleSpec: const ComboboxSpec(),
          ),
        ),
      );
      expect(_retainsPanel(tester), isFalse);
      await _open(tester);
      expect(find.text('Apple'), findsOneWidget);
      expect(probe.animations, isEmpty);
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

    for (final request in MotionRequest.values) {
      testWidgets('$request turned off in the hide frame skips that exit', (
        tester,
      ) async {
        final probe = _Probe();
        final harness = await MotionHarness.pump(tester, _combobox(probe));
        await harness.set(request, enabled: true);
        await _open(tester);
        expect(probe.animations.last.value, 1);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        expect(find.text('Apple'), findsNothing);
        await harness.set(request, enabled: false);
        expect(find.text('Apple'), findsNothing);

        await tester.enterText(find.byType(EditableText), 'Ap');
        await tester.pump();
        expect(probe.animations.last.value, 0);
        await tester.pump(_enter ~/ 2);
        expect(probe.animations.last.value, closeTo(.5, .01));
      });

      testWidgets('$request skips the exit and permits the next entry', (
        tester,
      ) async {
        final probe = _Probe();
        final harness = await MotionHarness.pump(tester, _combobox(probe));
        await harness.set(request, enabled: true);
        await _open(tester);
        expect(probe.animations.last.value, 1);

        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        expect(find.text('Apple'), findsNothing);
        await tester.pump();
        expect(find.text('Apple'), findsNothing);

        await harness.set(request, enabled: false);
        await tester.enterText(find.byType(EditableText), 'Ap');
        await tester.pump();
        expect(probe.animations.last.value, 0);
        await tester.pump(_enter ~/ 2);
        expect(probe.animations.last.value, closeTo(.5, .01));
      });

      testWidgets('$request settles entries and exits already in flight', (
        tester,
      ) async {
        final probe = _Probe();
        final harness = await MotionHarness.pump(tester, _combobox(probe));
        await _open(tester);
        await tester.pump(_enter ~/ 2);
        expect(probe.animations.last.value, closeTo(.5, .01));
        await harness.set(request, enabled: true);
        expect(probe.animations.last.value, 1);

        await harness.set(request, enabled: false);
        await tester.sendKeyEvent(LogicalKeyboardKey.escape);
        await tester.pump();
        await tester.pump();
        await tester.pump(_exit ~/ 2);
        expect(probe.animations.last.value, closeTo(.5, .01));
        expect(find.text('Apple'), findsOneWidget);

        await harness.set(request, enabled: true);
        expect(probe.animations.last.value, 0);
        expect(find.text('Apple'), findsNothing);
        await tester.pump();
        expect(find.text('Apple'), findsNothing);
      });
    }

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
