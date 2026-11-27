import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

const _open = Color(0xFFFF0000);
const _turn = Duration(milliseconds: 400);

Widget _select({
  SelectTriggerStyler? trigger,
  RemixSelectTrigger triggerData = const RemixSelectTrigger(
    placeholder: 'Pick',
  ),
}) => RemixSelect<int>(
  trigger: triggerData,
  items: const [
    RemixSelectItem(value: 1, label: 'One'),
    RemixSelectItem(value: 2, label: 'Two'),
  ],
  onChanged: (_) {},
  style: trigger == null ? SelectStyler() : SelectStyler().trigger(trigger),
);

/// The rotation, in radians, the trigger paints its indicator with, or
/// `null` when the indicator has no rotation wrapper.
double? _indicatorAngle(WidgetTester tester) {
  final transforms = find.ancestor(
    of: find.byKey(const ValueKey('remix-select-indicator')),
    matching: find.byType(Transform),
  );
  if (transforms.evaluate().isEmpty) return null;
  final matrix = tester.widget<Transform>(transforms.first).transform;
  return math.atan2(matrix.entry(1, 0), matrix.entry(0, 0));
}

Future<void> _openSelect(WidgetTester tester) async {
  await tester.tap(find.text('Pick'));
  await tester.pump();
}

void main() {
  group('RemixSelect trigger open state', () {
    testWidgets('resolves the trigger under selected while open', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _select(
          trigger: SelectTriggerStyler().onSelected(
            SelectTriggerStyler().placeholder(TextStyler().color(_open)),
          ),
        ),
      );
      Color? color() => tester.widget<Text>(find.text('Pick')).style?.color;

      expect(color(), isNot(_open));
      await _openSelect(tester);
      await tester.pumpAndSettle();
      expect(color(), _open);

      await tester.tapAt(Offset.zero);
      await tester.pumpAndSettle();
      expect(color(), isNot(_open));
    });

    testWidgets('keeps the focus-visible style on the trigger', (tester) async {
      await tester.pumpRemixApp(
        _select(
          trigger: SelectTriggerStyler().onFocusVisible(
            SelectTriggerStyler().placeholder(TextStyler().color(_open)),
          ),
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();

      expect(tester.widget<Text>(find.text('Pick')).style?.color, _open);
    });
  });

  group('RemixSelect indicatorAngle', () {
    testWidgets('without it the default chevron flips at once', (tester) async {
      await tester.pumpRemixApp(_select());
      expect(_indicatorAngle(tester), 0);

      await _openSelect(tester);
      expect(_indicatorAngle(tester), closeTo(math.pi, 1e-9));
    });

    testWidgets('an animated open angle turns the chevron with the panel', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        _select(
          trigger: SelectTriggerStyler()
              .indicatorAngle(0)
              .onSelected(SelectTriggerStyler().indicatorAngle(math.pi))
              .animate(AnimationConfig.linear(_turn)),
        ),
      );
      expect(_indicatorAngle(tester), 0);

      await _openSelect(tester);
      await tester.pump(_turn ~/ 2);
      expect(_indicatorAngle(tester), closeTo(math.pi / 2, 0.05));

      await tester.pumpAndSettle();
      expect(_indicatorAngle(tester), closeTo(math.pi, 1e-9));

      await tester.tapAt(Offset.zero);
      await tester.pump();
      await tester.pump(_turn ~/ 2);
      expect(_indicatorAngle(tester), closeTo(math.pi / 2, 0.05));
      await tester.pumpAndSettle();
      expect(_indicatorAngle(tester), closeTo(0, 1e-9));
    });

    testWidgets('turns custom trigger icons too', (tester) async {
      const icons = RemixSelectTrigger(
        placeholder: 'Pick',
        collapsedIcon: Icons.expand_more,
        expandedIcon: Icons.expand_more,
      );
      await tester.pumpRemixApp(_select(triggerData: icons));
      expect(_indicatorAngle(tester), isNull);

      await tester.pumpRemixApp(
        _select(
          triggerData: icons,
          trigger: SelectTriggerStyler().onSelected(
            SelectTriggerStyler().indicatorAngle(math.pi),
          ),
        ),
      );
      await _openSelect(tester);
      await tester.pumpAndSettle();
      expect(_indicatorAngle(tester), closeTo(math.pi, 1e-9));
    });
  });
}
