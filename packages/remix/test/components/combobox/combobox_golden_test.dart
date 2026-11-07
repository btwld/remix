// Executed pixel assertions; no platform skip or image-master refresh required.
import 'dart:ui' as ui;
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix/remix.dart';
import 'combobox_test_host.dart';

Future<({ByteData bytes, int width})> capture(
  WidgetTester tester,
  GlobalKey key,
) async {
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  return (await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
    final width = image.width;
    image.dispose();
    return (bytes: bytes, width: width);
  }))!;
}

int pixel(({ByteData bytes, int width}) pixels, Offset point) {
  final i = (point.dy.floor() * pixels.width + point.dx.floor()) * 4;
  return pixels.bytes.getUint32(i);
}

void main() {
  for (final raw in [false, true]) {
    testWidgets(
      'field hover, press, focus and disabled paint respect raw=$raw',
      (tester) async {
        final key = GlobalKey();
        late StateSetter update;
        var enabled = true;
        await tester.pumpWidget(
          comboboxHost(
            StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return RemixCombobox<String>(
                  enabled: enabled,
                  optionsBuilder: (_) => const [],
                  style: ComboboxStyler()
                      .width(280)
                      .field(
                        TextFieldStyler()
                            .padding(.all(8))
                            .color(const Color(0xFFFF0000))
                            .onFocused(.color(const Color(0xFFFFFF00)))
                            .onHovered(.color(const Color(0xFF0000FF)))
                            .onPressed(.color(const Color(0xFF00FF00)))
                            .onDisabled(.color(const Color(0xFF888888))),
                      ),
                  styleSpec: raw
                      ? const ComboboxSpec(
                          container: StyleSpec(
                            spec: BoxSpec(
                              constraints: BoxConstraints.tightFor(width: 280),
                            ),
                          ),
                          field: StyleSpec(
                            spec: TextFieldSpec(
                              container: StyleSpec(
                                spec: BoxSpec(
                                  constraints: BoxConstraints(minHeight: 48),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Color(0xFFAA00AA),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      : null,
                );
              },
            ),
            repaintKey: key,
          ),
        );
        final point =
            tester.getTopLeft(find.byType(RemixTextField)) + const Offset(2, 2);
        Future<void> expectPaint(int expected) async => expect(
          pixel(await capture(tester, key), point),
          raw ? 0xAA00AAFF : expected,
        );
        await expectPaint(0xFF0000FF);
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: const Offset(700, 500));
        await mouse.moveTo(tester.getCenter(find.byType(EditableText)));
        await tester.pumpAndSettle();
        await expectPaint(0x0000FFFF);
        await mouse.down(tester.getCenter(find.byType(EditableText)));
        await tester.pumpAndSettle();
        await expectPaint(0x00FF00FF);
        await mouse.cancel();
        await tester.pumpAndSettle();
        // A released/cancelled press must no longer supply the pressed patch.
        final focus = tester
            .widget<EditableText>(find.byType(EditableText))
            .focusNode;
        focus.requestFocus();
        await mouse.moveTo(const Offset(700, 500));
        await tester.pumpAndSettle();
        expect(focus.hasFocus, isTrue);
        await expectPaint(0xFFFF00FF);
        update(() => enabled = false);
        await tester.pumpAndSettle();
        await expectPaint(0x888888FF);
        await mouse.removePointer();
      },
    );
  }

  testWidgets(
    'painted editor focus and independent row highlight/hover change',
    (tester) async {
      final key = GlobalKey();
      await tester.pumpWidget(
        comboboxHost(
          RemixCombobox<String>(
            optionsBuilder: (_) => suggestions,
            style: testComboboxStyle(),
          ),
          repaintKey: key,
        ),
      );
      final field = tester.getRect(find.byType(RemixTextField));
      final fieldPoint = field.topLeft + const Offset(2, 2);
      expect(pixel(await capture(tester, key), fieldPoint), 0xFFFFFFFF);
      await openCombobox(tester);
      expect(pixel(await capture(tester, key), fieldPoint), 0xE0E0FFFF);
      final panel = tester.getRect(find.byType(SingleChildScrollView).last);
      final first = Offset(
        panel.left + 2,
        tester.getCenter(find.text('Apple')).dy,
      );
      final second = Offset(
        panel.left + 2,
        tester.getCenter(find.text('Apricot')).dy,
      );
      var pixels = await capture(tester, key);
      expect(pixel(pixels, first), 0x0000FFFF);
      expect(pixel(pixels, second), 0xFFFFFFFF);
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(second);
      await tester.pumpAndSettle();
      pixels = await capture(tester, key);
      expect(pixel(pixels, first), 0x0000FFFF);
      expect(pixel(pixels, second), 0x00FF00FF);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      pixels = await capture(tester, key);
      expect(pixel(pixels, first), 0xFFFFFFFF);
      expect(pixel(pixels, second), 0x0000FFFF);
      await mouse.removePointer();
    },
  );

  testWidgets('raw spec bypasses fluent width, field and state paint', (
    tester,
  ) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      comboboxHost(
        RemixCombobox<String>(
          optionsBuilder: (_) => suggestions,
          style: testComboboxStyle().width(500),
          styleSpec: const ComboboxSpec(
            container: StyleSpec(
              spec: BoxSpec(constraints: BoxConstraints.tightFor(width: 240)),
            ),
            field: StyleSpec(
              spec: TextFieldSpec(
                container: StyleSpec(
                  spec: BoxSpec(
                    constraints: BoxConstraints(minHeight: 48),
                    decoration: BoxDecoration(color: Color(0xFFFF0000)),
                  ),
                ),
              ),
            ),
            option: StyleSpec(
              spec: BoxSpec(
                decoration: BoxDecoration(color: Color(0xFFFFFF00)),
              ),
            ),
          ),
        ),
        repaintKey: key,
      ),
    );
    expect(tester.getSize(find.byType(RemixTextField)).width, 240);
    final point =
        tester.getTopLeft(find.byType(RemixTextField)) + const Offset(2, 2);
    expect(pixel(await capture(tester, key), point), 0xFF0000FF);
    await openCombobox(tester);
    expect(pixel(await capture(tester, key), point), 0xFF0000FF);
    final panel = tester.getRect(find.byType(SingleChildScrollView).last);
    expect(
      pixel(await capture(tester, key), Offset(panel.right - 2, panel.top + 2)),
      0xFFFF00FF,
    );
  });
}
