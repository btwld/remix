import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:playground/range_slider_reference.dart';
import 'package:remix/remix.dart';

void main() {
  testWidgets(
    'reference stays usable at narrow RTL large-text and wide dark sizes',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      for (final variant in [
        (width: 320.0, dark: false, rtl: true, scale: 2.0),
        (width: 1280.0, dark: true, rtl: false, scale: 1.0),
      ]) {
        tester.view.physicalSize = Size(variant.width, 1000);
        await tester.pumpWidget(
          RangeSliderReferenceApp(
            dark: variant.dark,
            rtl: variant.rtl,
            textScale: variant.scale,
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(find.byType(RemixRangeSlider), findsOneWidget);
        expect(find.text('3 matching sample stays'), findsOneWidget);
        expect(
          tester.getSize(find.byType(RemixRangeSlider)).height,
          greaterThanOrEqualTo(48),
        );
        await tester.pumpWidget(const SizedBox());
      }
    },
  );

  testWidgets(
    'reference filters actual sample rows and reset restores the interval',
    (tester) async {
      await tester.pumpWidget(const RangeSliderReferenceApp());
      final slider = tester.widget<RemixRangeSlider>(
        find.byType(RemixRangeSlider),
      );
      slider.onChanged!([0, 120]);
      await tester.pumpAndSettle();
      expect(find.text('1 matching sample stays'), findsOneWidget);
      expect(find.text('The courtyard room'), findsOneWidget);
      expect(find.text('The riverside studio'), findsNothing);
      await tester.ensureVisible(find.text('Reset'));
      await tester.tap(find.text('Reset'));
      await tester.pumpAndSettle();
      expect(
        tester.widget<RemixRangeSlider>(find.byType(RemixRangeSlider)).values,
        [80, 240],
      );
      expect(find.text('3 matching sample stays'), findsOneWidget);
    },
  );
}
