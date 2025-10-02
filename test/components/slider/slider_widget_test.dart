import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';
import 'package:remix/remix.dart';

void main() {
  Future<double> _pumpSlider(
    WidgetTester tester, {
    required RemixSliderStyle style,
    double value = 0.5,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 240,
              child: RemixSlider(
                value: value,
                min: 0,
                max: 1,
                onChanged: (_) {},
                style: style,
              ),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final sliderFinder = find.byType(NakedSlider);
    expect(sliderFinder, findsOneWidget);
    return tester.getSize(sliderFinder).height;
  }

  testWidgets('default slider height falls back to 24 logical pixels',
      (tester) async {
    final height = await _pumpSlider(
      tester,
      style: const RemixSliderStyle.create(),
    );

    expect(height, closeTo(24.0, 0.01));
  });

  testWidgets('custom track thickness expands slider height', (tester) async {
    final defaultHeight = await _pumpSlider(
      tester,
      style: const RemixSliderStyle.create(),
    );

    final thickHeight = await _pumpSlider(
      tester,
      style: RemixSliderStyle().trackThickness(20.0),
    );

    expect(thickHeight, greaterThan(defaultHeight));
    expect(thickHeight, closeTo(36.0, 0.01));
  });

  testWidgets('custom thumb size influences overall layout height',
      (tester) async {
    final height = await _pumpSlider(
      tester,
      style: RemixSliderStyle().thumbSize(const Size(40, 12)),
    );

    // trackThickness defaults to 8 -> total height = 12 + 8
    expect(height, closeTo(20.0, 0.01));
  });

  testWidgets('handles very small value range gracefully', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: RemixSlider(
          value: 5.0,
          min: 5.0,
          max: 5.001,
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('handles zero track thickness with fallback', (tester) async {
    final height = await _pumpSlider(
      tester,
      style: RemixSliderStyle().trackThickness(0.0),
    );

    // Should fall back to default track width (8.0)
    // Height = thumbSize.height (16) + trackThickness (8) = 24
    expect(height, closeTo(24.0, 0.01));
  });
}
