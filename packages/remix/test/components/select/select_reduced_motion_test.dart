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

    for (final request in MotionRequest.values) {
      testWidgets('settles an active entrance on a ${request.name} request', (
        tester,
      ) async {
        final harness = await MotionHarness.pump(tester, _select());
        await _open(tester);
        await tester.pump(const Duration(milliseconds: 50));
        expect(
          effectiveOpacity(tester, find.text('Alpha')),
          inExclusiveRange(0, 1),
        );

        await harness.set(request, enabled: true);
        expect(effectiveOpacity(tester, find.text('Alpha')), 1);

        await harness.set(request, enabled: false);
        expect(effectiveOpacity(tester, find.text('Alpha')), 1);
      });

      testWidgets('finishes an active exit once on a ${request.name} request', (
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
        await _open(tester);
        await tester.pumpAndSettle();
        await _close(tester);
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('Alpha'), findsOneWidget);

        await harness.set(request, enabled: true);
        // A MediaQuery update arrives during build; RawMenuAnchor defers
        // hiding its overlay until that frame ends. Flush the removal without
        // advancing the clock or letting the old fade finish naturally.
        await tester.pump();
        expect(find.text('Alpha'), findsNothing);
        expect(closed, 1);

        await harness.set(request, enabled: false);
        await _open(tester);
        await tester.pump(const Duration(milliseconds: 50));
        expect(
          effectiveOpacity(tester, find.text('Alpha')),
          inExclusiveRange(0, 1),
        );
        await tester.pumpAndSettle();
        await _close(tester);
        await tester.pumpAndSettle();
        expect(closed, 2);
      });
    }

    testWidgets('stops observing platform requests after unmount', (
      tester,
    ) async {
      final harness = await MotionHarness.pump(tester, _select());
      await _open(tester);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.pumpWidget(const SizedBox.shrink());
      await harness.set(MotionRequest.platform, enabled: true);
      expect(tester.takeException(), isNull);
    });

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
