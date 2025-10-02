import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('RemixTooltip uses NakedTooltip instead of NakedPopover',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: RemixTooltip(
              tooltipChild: Text('Tooltip content'),
              child: Text('Hover me'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final tooltipFinder = find.byType(NakedTooltip);
    expect(tooltipFinder, findsOneWidget);
  });

  testWidgets('RemixTooltip applies default durations', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: RemixTooltip(
              tooltipChild: Text('Tooltip content'),
              child: Text('Hover me'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final nakedTooltip = tester.widget<NakedTooltip>(
      find.byType(NakedTooltip),
    );

    expect(nakedTooltip.waitDuration, const Duration(milliseconds: 300));
    expect(nakedTooltip.showDuration, const Duration(milliseconds: 1500));
  });

  testWidgets('RemixTooltip applies custom wait duration from style',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: RemixTooltip(
              style: RemixTooltipStyle().waitDuration(
                const Duration(milliseconds: 500),
              ),
              tooltipChild: const Text('Tooltip content'),
              child: const Text('Hover me'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final nakedTooltip = tester.widget<NakedTooltip>(
      find.byType(NakedTooltip),
    );

    expect(nakedTooltip.waitDuration, const Duration(milliseconds: 500));
  });

  testWidgets('RemixTooltip applies custom show duration from style',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: RemixTooltip(
              style: RemixTooltipStyle().showDuration(
                const Duration(milliseconds: 3000),
              ),
              tooltipChild: const Text('Tooltip content'),
              child: const Text('Hover me'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final nakedTooltip = tester.widget<NakedTooltip>(
      find.byType(NakedTooltip),
    );

    expect(nakedTooltip.showDuration, const Duration(milliseconds: 3000));
  });

  testWidgets('RemixTooltip applies both custom durations from style',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: RemixTooltip(
              style: RemixTooltipStyle()
                  .waitDuration(const Duration(milliseconds: 200))
                  .showDuration(const Duration(milliseconds: 1500)),
              tooltipChild: const Text('Tooltip content'),
              child: const Text('Hover me'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final nakedTooltip = tester.widget<NakedTooltip>(
      find.byType(NakedTooltip),
    );

    expect(nakedTooltip.waitDuration, const Duration(milliseconds: 200));
    expect(nakedTooltip.showDuration, const Duration(milliseconds: 1500));
  });

  testWidgets('RemixTooltip passes semantics label correctly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: RemixTooltip(
              tooltipChild: Text('Tooltip content'),
              tooltipSemantics: 'Tooltip semantic label',
              child: Text('Hover me'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final nakedTooltip = tester.widget<NakedTooltip>(
      find.byType(NakedTooltip),
    );

    expect(nakedTooltip.semanticsLabel, 'Tooltip semantic label');
  });
}
