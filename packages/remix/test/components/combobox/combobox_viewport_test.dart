import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';

import 'combobox_test_host.dart';

void main() {
  for (final direction in TextDirection.values) {
    testWidgets('wrapped rows fade only at scrollable ends: $direction', (
      tester,
    ) async {
      final key = GlobalKey();
      final rows = List.generate(
        12,
        (i) => 'Suggestion $i wraps',
      );
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (query) => query.text == 'short' ? ['Short'] : rows,
            style: testComboboxStyle()
                .panel(ComboboxPanelStyler().maxHeight(161))
                .option(
                  ComboboxOptionStyler()
                      .color(const Color(0xFFFF0000))
                      .onFocused(.color(const Color(0xFFFF0000)))
                      .onHovered(.color(const Color(0xFFFF0000))),
                ),
          ),
          direction: direction,
          scale: 2,
          repaintKey: key,
        ),
      );
      await openCombobox(tester);
      final scroll = find.byType(SingleChildScrollView);
      final controller = tester
          .widget<RawScrollbar>(find.byType(RawScrollbar))
          .controller!;
      expect(tester.getSize(find.text(rows.first)).height, greaterThan(48));

      Future<void> expectEdges(bool topFade, bool bottomFade) async {
        final viewport = tester.getRect(scroll);
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = (await tester.runAsync(boundary.toImage))!;
        final data = (await tester.runAsync(
          () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
        ))!;
        final origin = boundary.localToGlobal(Offset.zero);
        final x = (viewport.left + 2 - origin.dx).floor();
        int green(double y) => data.getUint8(
          (((y - origin.dy).floor() * image.width + x) * 4) + 1,
        );
        expect(green(viewport.top + 1), topFade ? greaterThan(180) : 0);
        expect(green(viewport.bottom - 2), bottomFade ? greaterThan(180) : 0);
        expect(green(viewport.top + 16), 0, reason: 'fade stays short');
        image.dispose();
      }

      await expectEdges(false, true);
      controller.jumpTo(83);
      await tester.pumpAndSettle();
      await expectEdges(true, true);
      Actions.invoke(
        tester.element(find.byType(EditableText)),
        const AutocompleteLastOptionIntent(),
      );
      await tester.pumpAndSettle();
      await expectEdges(true, false);
      expect(
        tester.getRect(find.text(rows.last)).bottom,
        lessThanOrEqualTo(tester.getRect(scroll).bottom),
      );

      // Changing results also changes the viewport dimensions and scroll range.
      await tester.enterText(find.byType(EditableText), 'short');
      await tester.pumpAndSettle();
      expect(controller.position.maxScrollExtent, 0);
      await expectEdges(false, false);
      expect(tester.takeException(), isNull);
    });

    testWidgets('thumb gutter clears row fills: $direction', (tester) async {
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => List.generate(20, (i) => 'Suggestion $i'),
            style: testComboboxStyle(),
          ),
          direction: direction,
        ),
      );
      await openCombobox(tester);
      final bar = tester.getRect(find.byType(RawScrollbar));
      final viewport = tester.getRect(find.byType(SingleChildScrollView));
      final gutter = direction == TextDirection.rtl
          ? viewport.left - bar.left
          : bar.right - viewport.right;
      expect(gutter, greaterThanOrEqualTo(6));
    });
  }
}
