import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

const _triggerKey = Key('animation-trigger');
const _fadeKey = Key('tooltip-fade');

void main() {
  group('NakedTooltip animation style', () {
    testWidgets('partial styles use the default show and hide durations', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        Center(child: _tooltip(const AnimationStyle(curve: Curves.linear))),
      );
      final mouse = await _hover(tester);
      expect(tester.takeException(), isNull);

      await tester.pump(const Duration(milliseconds: 75));
      expect(_opacity(tester), closeTo(0.5, 0.01));
      await tester.pump(const Duration(milliseconds: 75));
      expect(_opacity(tester), 1);

      await mouse.moveTo(Offset.zero);
      await tester.pump();
      await tester.pump(const Duration(microseconds: 37500));
      expect(_opacity(tester), closeTo(0.5, 0.01));
      await tester.pump(const Duration(microseconds: 37500));
      expect(_opacity(tester), 0);
      await tester.pumpAndSettle();
      expect(find.text('Tooltip'), findsNothing);
    });

    testWidgets('honors an explicit reverse curve', (tester) async {
      await tester.pumpMaterialWidget(
        Center(
          child: _tooltip(
            const AnimationStyle(
              curve: Curves.linear,
              reverseCurve: Curves.easeIn,
              duration: Duration(milliseconds: 200),
              reverseDuration: Duration(milliseconds: 200),
            ),
          ),
        ),
      );
      final mouse = await _hover(tester);
      await tester.pumpAndSettle();

      await mouse.moveTo(Offset.zero);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(_opacity(tester), closeTo(Curves.easeIn.transform(0.5), 0.01));
    });

    testWidgets('defaults the reverse curve to the flipped show curve', (
      tester,
    ) async {
      await tester.pumpMaterialWidget(
        Center(
          child: _tooltip(
            const AnimationStyle(
              curve: Curves.easeIn,
              duration: Duration(milliseconds: 200),
              reverseDuration: Duration(milliseconds: 200),
            ),
          ),
        ),
      );
      final mouse = await _hover(tester);
      await tester.pumpAndSettle();

      await mouse.moveTo(Offset.zero);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(_opacity(tester), closeTo(1 - Curves.easeIn.transform(0.5), 0.01));
    });

    testWidgets(
      'updates durations while open without resetting state or focus',
      (tester) async {
        final tooltipKey = GlobalKey<RawTooltipState>();
        final focus = FocusNode();
        final changes = <bool>[];
        late StateSetter update;
        var style = const AnimationStyle(
          curve: Curves.linear,
          reverseCurve: Curves.linear,
          duration: Duration(milliseconds: 100),
          reverseDuration: Duration(milliseconds: 50),
        );
        addTearDown(() async {
          await tester.pumpWidget(const SizedBox.shrink());
          focus.dispose();
        });
        await tester.pumpMaterialWidget(
          Center(
            child: StatefulBuilder(
              builder: (_, setState) {
                update = setState;
                return _tooltip(
                  style,
                  tooltipKey: tooltipKey,
                  onOpenChanged: changes.add,
                  child: Focus(
                    focusNode: focus,
                    child: const SizedBox(
                      key: _triggerKey,
                      width: 100,
                      height: 40,
                    ),
                  ),
                );
              },
            ),
          ),
        );
        focus.requestFocus();
        tooltipKey.currentState!.ensureTooltipVisible();
        await tester.pumpAndSettle();
        final rawState = tooltipKey.currentState;
        expect(changes, [true]);

        update(() {
          style = style.copyWith(
            duration: const Duration(milliseconds: 400),
            reverseDuration: const Duration(milliseconds: 200),
          );
        });
        await tester.pump();
        expect(tooltipKey.currentState, same(rawState));
        expect(focus.hasFocus, isTrue);
        expect(find.text('Tooltip'), findsOneWidget);
        expect(changes, [true]);

        RawTooltip.dismissAllToolTips();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(_opacity(tester), closeTo(0.5, 0.01));
        await tester.pump(const Duration(milliseconds: 100));
        expect(_opacity(tester), 0);
        await tester.pumpAndSettle();
        expect(find.text('Tooltip'), findsNothing);
        expect(changes, [true, false]);

        tooltipKey.currentState!.ensureTooltipVisible();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(_opacity(tester), closeTo(0.25, 0.01));
        expect(tooltipKey.currentState, same(rawState));
        expect(focus.hasFocus, isTrue);
        expect(changes, [true, false, true]);
      },
    );

    testWidgets('updates the show duration while the overlay is absent', (
      tester,
    ) async {
      late StateSetter update;
      var duration = const Duration(milliseconds: 100);
      await tester.pumpMaterialWidget(
        Center(
          child: StatefulBuilder(
            builder: (_, setState) {
              update = setState;
              return _tooltip(
                AnimationStyle(
                  curve: Curves.linear,
                  duration: duration,
                  reverseDuration: const Duration(milliseconds: 50),
                ),
              );
            },
          ),
        ),
      );
      final mouse = await _hover(tester);
      await tester.pumpAndSettle();
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(find.text('Tooltip'), findsNothing);

      update(() => duration = const Duration(milliseconds: 400));
      await tester.pump();
      await mouse.moveTo(tester.getCenter(find.byKey(_triggerKey)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(_opacity(tester), closeTo(0.25, 0.01));
    });

    for (final (name, duration, opacityAt100ms) in [
      ('a slower duration', const Duration(milliseconds: 400), 0.25),
      ('no animation', Duration.zero, 1.0),
    ]) {
      testWidgets('applies $name set before the first show', (tester) async {
        late StateSetter update;
        var style = const AnimationStyle(
          curve: Curves.linear,
          duration: Duration(milliseconds: 100),
        );
        await tester.pumpMaterialWidget(
          Center(
            child: StatefulBuilder(
              builder: (_, setState) {
                update = setState;
                return _tooltip(style);
              },
            ),
          ),
        );
        // Any pointer down makes RawTooltip create its animation controller.
        await tester.tapAt(Offset.zero);
        update(() => style = style.copyWith(duration: duration));
        await tester.pump();

        await _hover(tester);
        expect(tester.takeException(), isNull);
        if (duration == Duration.zero) {
          expect(_opacity(tester), 1);
        }
        await tester.pump(const Duration(milliseconds: 100));
        expect(_opacity(tester), closeTo(opacityAt100ms, 0.01));
      });
    }

    testWidgets('updates the curves without resetting a visible tooltip', (
      tester,
    ) async {
      late StateSetter update;
      var style = const AnimationStyle(
        curve: Curves.linear,
        reverseCurve: Curves.linear,
        duration: Duration(milliseconds: 200),
        reverseDuration: Duration(milliseconds: 200),
      );
      await tester.pumpMaterialWidget(
        Center(
          child: StatefulBuilder(
            builder: (_, setState) {
              update = setState;
              return _tooltip(style);
            },
          ),
        ),
      );
      final mouse = await _hover(tester);
      await tester.pumpAndSettle();

      update(() => style = style.copyWith(reverseCurve: Curves.easeIn));
      await tester.pump();
      expect(_opacity(tester), 1);
      await mouse.moveTo(Offset.zero);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(_opacity(tester), closeTo(Curves.easeIn.transform(0.5), 0.01));
    });
  });
}

NakedTooltip _tooltip(
  AnimationStyle style, {
  GlobalKey<RawTooltipState>? tooltipKey,
  ValueChanged<bool>? onOpenChanged,
  Widget? child,
}) => NakedTooltip(
  tooltipKey: tooltipKey,
  onOpenChanged: onOpenChanged,
  dismissDelay: Duration.zero,
  animationStyle: style,
  overlayBuilder: (_, animation) => FadeTransition(
    key: _fadeKey,
    opacity: animation,
    child: const SizedBox(width: 120, height: 40, child: Text('Tooltip')),
  ),
  child: child ?? const SizedBox(key: _triggerKey, width: 100, height: 40),
);

double _opacity(WidgetTester tester) =>
    tester.widget<FadeTransition>(find.byKey(_fadeKey)).opacity.value;

Future<TestGesture> _hover(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(() async {
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
  await mouse.moveTo(tester.getCenter(find.byKey(_triggerKey)));
  await tester.pump();
  return mouse;
}
