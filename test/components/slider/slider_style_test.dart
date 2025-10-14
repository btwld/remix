import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets('track thickness persists after color updates', (tester) async {
    final style = RemixSliderStyle()
        .thickness(6.0)
        .trackColor(Colors.red)
        .rangeColor(Colors.blue);

    late RemixSliderSpec resolved;

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

    expect(resolved.trackWidth, closeTo(6.0, 0.001));
    expect(resolved.rangeWidth, closeTo(6.0, 0.001));
  });

  testWidgets('thumbSize helper applies tight constraints', (tester) async {
    final style = RemixSliderStyle().thumbSize(const Size(32, 18));

    late RemixSliderSpec resolved;

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

    final constraints = resolved.thumb.spec.constraints;
    expect(constraints, isNotNull);
    expect(constraints!.hasTightWidth, isTrue);
    expect(constraints.hasTightHeight, isTrue);
    expect(constraints.maxWidth, closeTo(32.0, 0.001));
    expect(constraints.maxHeight, closeTo(18.0, 0.001));
  });
}
