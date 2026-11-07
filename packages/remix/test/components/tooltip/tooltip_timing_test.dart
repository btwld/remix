import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

import '../../helpers/test_helpers.dart';

void main() {
  testWidgets('tooltip wires showDuration to touchDelay, dismissDuration to '
      'dismissDelay, and skipDelayDuration through', (tester) async {
    const wait = Duration(milliseconds: 111);
    const show = Duration(milliseconds: 222);
    const dismiss = Duration(milliseconds: 333);
    const skip = Duration(milliseconds: 444);

    await tester.pumpRemixApp(
      RemixTooltip(
        tooltipChild: const Text('tip'),
        style: TooltipStyler(
          waitDuration: wait,
          showDuration: show,
          dismissDuration: dismiss,
          skipDelayDuration: skip,
        ),
        child: const Text('target'),
      ),
    );
    await tester.pumpAndSettle();

    final naked = tester.widget<NakedTooltip>(find.byType(NakedTooltip));
    expect(naked.hoverDelay, wait);
    expect(naked.touchDelay, show);
    expect(naked.dismissDelay, dismiss);
    expect(naked.skipDelayDuration, skip);
  });

  testWidgets('tooltip default timings match Material-aligned defaults', (
    tester,
  ) async {
    await tester.pumpRemixApp(
      const RemixTooltip(tooltipChild: Text('tip'), child: Text('target')),
    );
    await tester.pumpAndSettle();

    final naked = tester.widget<NakedTooltip>(find.byType(NakedTooltip));
    expect(naked.hoverDelay, const Duration(milliseconds: 300));
    expect(naked.touchDelay, const Duration(milliseconds: 1500));
    expect(naked.dismissDelay, const Duration(milliseconds: 100));
    expect(naked.skipDelayDuration, const Duration(milliseconds: 300));
  });
}
