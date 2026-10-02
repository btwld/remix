import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('reports visibility and supports command show', (tester) async {
    final tooltipKey = GlobalKey<RawTooltipState>();
    final changes = <bool>[];
    await tester.pumpWidget(
      MaterialApp(
        home: RemixTooltip(
          tooltipKey: tooltipKey,
          onOpenChanged: changes.add,
          tooltipChild: const Text('Tooltip content'),
          child: const Text('Trigger'),
        ),
      ),
    );

    expect(tooltipKey.currentState?.ensureTooltipVisible(), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('Tooltip content'), findsOneWidget);
    expect(changes, [true]);
  });
}
