import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/fortal.dart';

import '../../helpers/test_helpers.dart';

void main() {
  group('Fortal button motion', () {
    testWidgets('FortalButton thins on hover over 150ms and settles back', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        FortalButton.solid(label: 'Continue', onPressed: () {}),
      );

      await _expectHoverMotion(tester, target: find.byType(FortalButton));
    });

    testWidgets('FortalButton scales to 97% while held', (tester) async {
      await tester.pumpRemixApp(
        FortalButton.solid(label: 'Continue', onPressed: () {}),
      );
      await tester.pumpAndSettle();
      final target = find.byType(FortalButton);
      final width = tester.getSize(target).width;
      double drawnWidth() =>
          tester.getBottomRight(find.text('Continue')).dx -
          tester.getBottomLeft(find.text('Continue')).dx;
      final label = drawnWidth();

      final press = await tester.createGesture(kind: PointerDeviceKind.mouse);
      addTearDown(press.removePointer);
      await press.addPointer(location: tester.getCenter(target));
      await tester.pump();
      await press.down(tester.getCenter(target));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));
      // The tap reports its press after the press timeout; the scale then
      // runs its 150ms from that frame.
      await tester.pump(const Duration(milliseconds: 200));
      expect(drawnWidth(), closeTo(label * 0.97, 0.01));
      expect(tester.getSize(target).width, width, reason: 'layout unchanged');

      await press.up();
      await tester.pumpAndSettle();
      expect(drawnWidth(), closeTo(label, 0.01));
    });

    testWidgets('FortalIconButton thins on hover over 150ms and settles back', (
      tester,
    ) async {
      await tester.pumpRemixApp(
        FortalIconButton.solid(
          icon: Icons.add,
          semanticLabel: 'Add',
          onPressed: () {},
        ),
      );

      await _expectHoverMotion(tester, target: find.byType(FortalIconButton));
    });
  });
}

/// Hovers [target] and checks the solid button's opacity between rest (1)
/// and hover (0.91) partway through each 150ms transition.
Future<void> _expectHoverMotion(
  WidgetTester tester, {
  required Finder target,
}) async {
  await tester.pumpAndSettle();
  double opacity() => tester
      .widget<Opacity>(
        find.descendant(of: target, matching: find.byType(Opacity)).first,
      )
      .opacity;
  expect(opacity(), 1);

  final pointer = await tester.createGesture(kind: PointerDeviceKind.mouse);
  addTearDown(pointer.removePointer);
  await pointer.addPointer(location: Offset.zero);
  await tester.pump();
  await pointer.moveTo(tester.getCenter(target));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 30));

  expect(opacity(), allOf(lessThan(1), greaterThan(0.91)));

  await tester.pump(const Duration(milliseconds: 130));
  expect(opacity(), closeTo(0.91, 1e-9));

  await pointer.moveTo(Offset.zero);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 30));

  expect(opacity(), allOf(lessThan(1), greaterThan(0.91)));

  await tester.pumpAndSettle();
  expect(opacity(), 1);
}
