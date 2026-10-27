import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/motion_harness.dart';

Widget _select() => RemixSelect<String>(
  onChanged: (_) {},
  trigger: const RemixSelectTrigger(placeholder: 'Choose'),
  items: const [RemixSelectItem(value: 'a', label: 'Alpha')],
);

Future<void> _open(WidgetTester tester) async {
  await tester.tap(find.text('Choose'));
  await tester.pump();
}

Future<void> _close(WidgetTester tester) async {
  await tester.sendKeyEvent(LogicalKeyboardKey.escape);
  await tester.pump();
}

void main() {
  group('RemixSelect reduced motion', () {
    testWidgets('fades the menu in and out by default', (tester) async {
      await MotionHarness.pump(tester, _select());

      await _open(tester);
      await tester.pump(const Duration(milliseconds: 50));

      expect(
        effectiveOpacity(tester, find.text('Alpha')),
        inExclusiveRange(0, 1),
      );

      await tester.pumpAndSettle();
      expect(effectiveOpacity(tester, find.text('Alpha')), 1);

      await _close(tester);
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Alpha'), findsOneWidget);
      expect(
        effectiveOpacity(tester, find.text('Alpha')),
        inExclusiveRange(0, 1),
      );

      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsNothing);
    });

    for (final request in MotionRequest.values) {
      testWidgets('opens and closes without a transition on a ${request.name} '
          'request', (tester) async {
        final harness = await MotionHarness.pump(tester, _select());
        await harness.set(request, enabled: true);

        await _open(tester);

        expect(effectiveOpacity(tester, find.text('Alpha')), 1);

        await _close(tester);

        expect(find.text('Alpha'), findsNothing);
      });

      testWidgets('follows a ${request.name} request made while mounted', (
        tester,
      ) async {
        final harness = await MotionHarness.pump(tester, _select());

        await harness.set(request, enabled: true);
        await _open(tester);
        expect(effectiveOpacity(tester, find.text('Alpha')), 1);
        await _close(tester);

        await harness.set(request, enabled: false);
        await _open(tester);
        await tester.pump(const Duration(milliseconds: 50));
        expect(
          effectiveOpacity(tester, find.text('Alpha')),
          inExclusiveRange(0, 1),
        );
      });
    }

    testWidgets('still reports onClose when closing without a transition', (
      tester,
    ) async {
      var closed = 0;
      final harness = await MotionHarness.pump(
        tester,
        RemixSelect<String>(
          onChanged: (_) {},
          onClose: () => closed++,
          trigger: const RemixSelectTrigger(placeholder: 'Choose'),
          items: const [RemixSelectItem(value: 'a', label: 'Alpha')],
        ),
      );
      await harness.set(MotionRequest.platform, enabled: true);

      await _open(tester);
      await _close(tester);

      expect(closed, 1);
    });
  });
}
