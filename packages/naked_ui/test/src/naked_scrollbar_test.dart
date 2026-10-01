import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:naked_ui/naked_ui.dart';

import '../test_helpers.dart';

void main() {
  Widget list({
    ScrollController? controller,
    WidgetStateProperty<Color>? thumbColor,
    WidgetStateProperty<Color>? trackColor,
    WidgetStateProperty<Color>? trackBorderColor,
    WidgetStateProperty<double>? thickness,
    bool? trackVisibility,
    bool? interactive,
    bool? thumbVisibility,
    ValueChanged<bool>? onHoverChange,
    ValueChanged<bool>? onDragChange,
  }) {
    return SizedBox(
      height: 200,
      width: 120,
      child: NakedScrollbar(
        controller: controller,
        thumbColor: thumbColor,
        trackColor: trackColor,
        trackBorderColor: trackBorderColor,
        thickness: thickness,
        trackVisibility: trackVisibility,
        interactive: interactive,
        thumbVisibility: thumbVisibility,
        onHoverChange: onHoverChange,
        onDragChange: onDragChange,
        child: ListView.builder(
          controller: controller,
          itemCount: 40,
          itemBuilder: (context, index) =>
              SizedBox(height: 40, child: Text('Item $index')),
        ),
      ),
    );
  }

  ScrollbarPainter painter(WidgetTester tester) => tester
      .renderObjectList<RenderCustomPaint>(find.byType(CustomPaint))
      .map((render) => render.foregroundPainter)
      .whereType<ScrollbarPainter>()
      .single;

  testWidgets('track colors honor visibility changes and a hidden thumb', (
    tester,
  ) async {
    const track = Color(0xFF112233);
    const border = Color(0xFF445566);
    Future<void> pump({bool? visible, bool thumb = true}) async {
      await tester.pumpMaterialWidget(
        list(
          thumbVisibility: thumb,
          trackVisibility: visible,
          trackColor: const WidgetStatePropertyAll(track),
          trackBorderColor: const WidgetStatePropertyAll(border),
        ),
      );
      await tester.pumpAndSettle();
    }

    await pump();
    expect(painter(tester).trackColor, const Color(0x00000000));
    expect(painter(tester).trackBorderColor, const Color(0x00000000));
    await pump(visible: true);
    expect(painter(tester).trackColor, track);
    expect(painter(tester).trackBorderColor, border);
    await pump(visible: false);
    expect(painter(tester).trackColor, const Color(0x00000000));
    expect(painter(tester).trackBorderColor, const Color(0x00000000));
    await pump(visible: false, thumb: false);
    expect(painter(tester).trackColor, const Color(0x00000000));
    expect(painter(tester).trackBorderColor, const Color(0x00000000));
  });

  testWidgets('thumb drag scrolls the list', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    var dragged = <bool>[];
    await tester.pumpMaterialWidget(
      list(
        controller: controller,
        thumbVisibility: true,
        thumbColor: const WidgetStatePropertyAll(Color(0xFF112233)),
        onDragChange: dragged.add,
      ),
    );
    await tester.pumpAndSettle();

    expect(controller.offset, 0);
    final scrollbar = find.byType(NakedScrollbar);
    final topRight = tester.getTopRight(scrollbar);
    await tester.dragFrom(topRight - const Offset(4, -30), const Offset(0, 80));
    await tester.pumpAndSettle();
    expect(controller.offset, greaterThan(0));
    expect(dragged, [true, false]);
  });

  testWidgets('interactive false ignores a thumb drag', (tester) async {
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpMaterialWidget(
      list(controller: controller, thumbVisibility: true, interactive: false),
    );
    await tester.pumpAndSettle();
    final topRight = tester.getTopRight(find.byType(NakedScrollbar));
    await tester.dragFrom(topRight - const Offset(4, -30), const Offset(0, 80));
    await tester.pumpAndSettle();
    expect(controller.offset, 0);
  });

  testWidgets('thumb color resolves for idle, hovered, and dragged', (
    tester,
  ) async {
    const idle = Color(0xFF0000FF);
    const hovered = Color(0xFF00FF00);
    const dragged = Color(0xFFFF0000);
    final hovers = <bool>[];
    await tester.pumpMaterialWidget(
      list(
        thumbVisibility: true,
        onHoverChange: hovers.add,
        trackVisibility: true,
        trackColor: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.hovered) ? hovered : idle;
        }),
        thickness: WidgetStateProperty.resolveWith((states) {
          return states.contains(WidgetState.dragged) ? 12 : 6;
        }),
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.dragged)) return dragged;
          if (states.contains(WidgetState.hovered)) return hovered;
          return idle;
        }),
      ),
    );
    await tester.pumpAndSettle();

    ScrollbarPainter painter() => tester
        .renderObjectList<RenderCustomPaint>(find.byType(CustomPaint))
        .map((render) => render.foregroundPainter)
        .whereType<ScrollbarPainter>()
        .single;
    expect(painter().color, idle);
    expect(painter().trackColor, idle);
    expect(painter().thickness, 6);

    final onThumb =
        tester.getTopRight(find.byType(NakedScrollbar)) - const Offset(3, -20);
    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer();
    addTearDown(gesture.removePointer);
    await gesture.moveTo(onThumb);
    await tester.pumpAndSettle();
    expect(painter().color, hovered);
    expect(painter().trackColor, hovered);
    expect(hovers, [true]);

    await gesture.down(onThumb);
    await tester.pump(const Duration(milliseconds: 100));
    await gesture.moveBy(const Offset(0, 20));
    await tester.pump();
    expect(painter().color, dragged);
    expect(painter().thickness, 12);

    await gesture.up();
    await tester.pumpAndSettle();
    await gesture.moveTo(const Offset(5, 5));
    await tester.pumpAndSettle();
    expect(painter().color, idle);
    expect(painter().trackColor, idle);
    expect(painter().thickness, 6);
    expect(hovers, [true, false]);
  });
}
