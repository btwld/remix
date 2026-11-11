import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui_example/api/naked_combobox.0.dart' as combobox;
import 'package:naked_ui_example/api/naked_slider.0.dart' as slider;
import 'package:naked_ui_example/api/naked_textfield.0.dart' as textfield;
import 'package:naked_ui_example/src/example_app.dart';

void main() {
  for (final example in [
    (name: 'Fruit', app: const combobox.MyApp(), slider: false),
    (name: 'Simple TextField', app: const textfield.MyApp(), slider: false),
    (name: 'Simple Slider', app: const slider.MyApp(), slider: true),
  ]) {
    testWidgets('${example.name} exposes a stable control name', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(example.app);
        await tester.pump();
        final nodes = tester.semantics.simulatedAccessibilityTraversal();
        final control = nodes.singleWhere((node) {
          final flags = node.getSemanticsData().flagsCollection;
          return example.slider ? flags.isSlider : flags.isTextField;
        });
        expect(control.getSemanticsData().label, example.name);
        if (!example.slider) {
          await tester.enterText(find.byType(EditableText), 'ap');
          await tester.pumpAndSettle();
          expect(control.getSemanticsData().label, example.name);
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      } finally {
        semantics.dispose();
      }
    });
  }

  testWidgets(
    'RTL slider painting follows its controlled value and rail origin',
    (tester) async {
      final boundaryKey = GlobalKey();
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          ExampleApp(
            child: Center(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: RepaintBoundary(
                  key: boundaryKey,
                  child: const ColoredBox(
                    color: Color(0xFFFFFFFF),
                    child: slider.SliderExample(),
                  ),
                ),
              ),
            ),
          ),
        );
        final rect = tester.getRect(find.byType(slider.SliderExample));
        await tester.tapAt(Offset(rect.left + rect.width / 4, rect.center.dy));
        await tester.pumpAndSettle();
        final node = tester.semantics
            .simulatedAccessibilityTraversal()
            .singleWhere(
              (node) => node.getSemanticsData().flagsCollection.isSlider,
            );
        expect(node.getSemanticsData().value, '75%');
        final boundary =
            boundaryKey.currentContext!.findRenderObject()!
                as RenderRepaintBoundary;
        final pixels = await tester.runAsync(() async {
          final image = await boundary.toImage(pixelRatio: 1);
          final bytes = (await image.toByteData(
            format: ui.ImageByteFormat.rawRgba,
          ))!;
          final width = image.width;
          image.dispose();
          return (bytes: bytes, width: width);
        });
        int pixel(double x) => pixels!.bytes.getUint32(
          ((rect.height / 2).floor() * pixels.width + x.floor()) * 4,
        );
        // A white thumb follows the quarter-width pointer. The active black fill
        // extends toward the RTL minimum at the right edge, not the left edge.
        expect(pixel(rect.width / 4), 0xFFFFFFFF);
        expect(pixel(rect.width * .875), 0x000000FF);
        expect(pixel(rect.width * .125), isNot(0x000000FF));
        expect(tester.takeException(), isNull);
      } finally {
        semantics.dispose();
      }
    },
  );
}
