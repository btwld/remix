import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import '../../helpers/motion_harness.dart';

Widget _accordion() => RemixAccordionGroup<String>(
  controller: RemixAccordionController<String>(),
  child: RemixAccordion<String>(
    value: 'a',
    title: 'Details',
    child: const Text('Panel'),
  ),
);

Future<void> _toggle(WidgetTester tester) async {
  await tester.tap(find.text('Details'));
  await tester.pump();
}

void main() {
  group('RemixAccordion reduced motion', () {
    testWidgets('fades the panel in and out by default', (tester) async {
      await MotionHarness.pump(tester, _accordion());

      await _toggle(tester);
      await tester.pump(const Duration(milliseconds: 50));

      expect(
        effectiveOpacity(tester, find.text('Panel')),
        inExclusiveRange(0, 1),
      );

      await tester.pumpAndSettle();
      expect(effectiveOpacity(tester, find.text('Panel')), 1);

      await _toggle(tester);
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Panel'), findsOneWidget);

      await tester.pumpAndSettle();
      expect(find.text('Panel'), findsNothing);
    });

    for (final request in MotionRequest.values) {
      testWidgets('expands and collapses without a transition on a '
          '${request.name} request', (tester) async {
        final harness = await MotionHarness.pump(tester, _accordion());
        await harness.set(request, enabled: true);

        await _toggle(tester);

        expect(effectiveOpacity(tester, find.text('Panel')), 1);

        await _toggle(tester);

        expect(find.text('Panel'), findsNothing);
      });

      testWidgets('collapses at once when a ${request.name} request arrives '
          'while expanded', (tester) async {
        final harness = await MotionHarness.pump(tester, _accordion());
        await _toggle(tester);
        await tester.pumpAndSettle();

        await harness.set(request, enabled: true);
        await _toggle(tester);

        expect(find.text('Panel'), findsNothing);
      });

      testWidgets('fades out a panel expanded under a ${request.name} request '
          'once the request is lifted', (tester) async {
        final harness = await MotionHarness.pump(tester, _accordion());
        await harness.set(request, enabled: true);
        await _toggle(tester);
        expect(effectiveOpacity(tester, find.text('Panel')), 1);

        await harness.set(request, enabled: false);
        await _toggle(tester);
        await tester.pump(const Duration(milliseconds: 50));

        expect(
          effectiveOpacity(tester, find.text('Panel')),
          inExclusiveRange(0, 1),
        );
        await tester.pumpAndSettle();
        expect(find.text('Panel'), findsNothing);
      });

      testWidgets('animates again once a ${request.name} request is lifted', (
        tester,
      ) async {
        final harness = await MotionHarness.pump(tester, _accordion());
        await harness.set(request, enabled: true);
        await harness.set(request, enabled: false);

        await _toggle(tester);
        await tester.pump(const Duration(milliseconds: 50));

        expect(
          effectiveOpacity(tester, find.text('Panel')),
          inExclusiveRange(0, 1),
        );
      });
    }

    for (final request in MotionRequest.values) {
      testWidgets('settles an active entrance on a ${request.name} request', (
        tester,
      ) async {
        final harness = await MotionHarness.pump(tester, _accordion());
        await _toggle(tester);
        await tester.pump(const Duration(milliseconds: 50));
        expect(
          effectiveOpacity(tester, find.text('Panel')),
          inExclusiveRange(0, 1),
        );

        await harness.set(request, enabled: true);
        expect(effectiveOpacity(tester, find.text('Panel')), 1);

        await harness.set(request, enabled: false);
        expect(effectiveOpacity(tester, find.text('Panel')), 1);
      });

      testWidgets('unmounts an active exit on a ${request.name} request', (
        tester,
      ) async {
        final harness = await MotionHarness.pump(tester, _accordion());
        await _toggle(tester);
        await tester.pumpAndSettle();
        await _toggle(tester);
        await tester.pump(const Duration(milliseconds: 50));
        expect(find.text('Panel'), findsOneWidget);

        await harness.set(request, enabled: true);
        expect(find.text('Panel'), findsNothing);
        await harness.set(request, enabled: false);
        expect(find.text('Panel'), findsNothing);
        await tester.pumpAndSettle();
        expect(find.text('Panel'), findsNothing);
      });
    }

    testWidgets('rapid re-entry does not reuse an outgoing panel identity', (
      tester,
    ) async {
      await MotionHarness.pump(tester, _accordion());
      await _toggle(tester);
      await tester.pumpAndSettle();
      await _toggle(tester);
      await tester.pump(const Duration(milliseconds: 30));
      await _toggle(tester);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(find.text('Panel'), findsOneWidget);
    });

    testWidgets('keeps the panel mounted when the preference changes', (
      tester,
    ) async {
      final harness = await MotionHarness.pump(
        tester,
        RemixAccordionGroup<String>(
          controller: RemixAccordionController<String>(),
          child: RemixAccordion<String>(
            value: 'a',
            title: 'Details',
            child: const _Counter(),
          ),
        ),
      );
      await _toggle(tester);
      await tester.pumpAndSettle();
      await tester.tap(find.byType(_Counter));
      await tester.pump();
      expect(find.text('1'), findsOneWidget);

      await harness.set(MotionRequest.platform, enabled: true);

      expect(find.text('1'), findsOneWidget);
      await harness.set(MotionRequest.platform, enabled: false);
      expect(find.text('1'), findsOneWidget);
    });
  });
}

class _Counter extends StatefulWidget {
  const _Counter();

  @override
  State<_Counter> createState() => _CounterState();
}

class _CounterState extends State<_Counter> {
  int count = 0;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => setState(() => count++),
    child: Text('$count'),
  );
}
