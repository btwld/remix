import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('waitDuration persists through style updates', (tester) async {
    final style = RemixTooltipStyle()
        .waitDuration(const Duration(milliseconds: 300))
        .color(Colors.black);

    late RemixTooltipSpec resolved;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolved = style.resolve(context).spec;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved.waitDuration, const Duration(milliseconds: 300));
  });

  testWidgets('showDuration persists through style updates', (tester) async {
    final style = RemixTooltipStyle()
        .showDuration(const Duration(milliseconds: 1500))
        .padding(EdgeInsetsGeometryMix.all(8));

    late RemixTooltipSpec resolved;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolved = style.resolve(context).spec;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved.showDuration, const Duration(milliseconds: 1500));
  });

  testWidgets('both durations persist when chained', (tester) async {
    final style = RemixTooltipStyle()
        .waitDuration(const Duration(milliseconds: 250))
        .showDuration(const Duration(milliseconds: 2000))
        .borderRadius(BorderRadiusGeometryMix.all(const Radius.circular(8)));

    late RemixTooltipSpec resolved;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolved = style.resolve(context).spec;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved.waitDuration, const Duration(milliseconds: 250));
    expect(resolved.showDuration, const Duration(milliseconds: 2000));
  });

  testWidgets('default durations apply when not specified', (tester) async {
    const style = RemixTooltipStyle.create();

    late RemixTooltipSpec resolved;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) {
            resolved = style.resolve(context).spec;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(resolved.waitDuration, const Duration(milliseconds: 300));
    expect(resolved.showDuration, const Duration(milliseconds: 1500));
  });
}
