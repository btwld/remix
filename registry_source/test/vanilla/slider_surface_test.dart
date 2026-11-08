import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:registry_source/vanilla.dart';

import 'support.dart';

void main() {
  for (final theme in vanillaThemes) {
    for (final range in [false, true]) {
      testWidgets(
        '${theme.name}: ${range ? 'range' : 'single'} halo matches its tinted surface across the fill',
        (tester) async {
          FocusManager.instance.highlightStrategy =
              FocusHighlightStrategy.automatic;
          addTearDown(
            () => FocusManager.instance.highlightStrategy =
                FocusHighlightStrategy.automatic,
          );
          final surface = Color.alphaBlend(
            const Color(0x306080D0),
            theme.data.background,
          );
          final boundary = GlobalKey();
          await tester.pumpWidget(
            VanillaTheme(
              theme: theme.data,
              child: hostOf(
                Center(
                  child: RepaintBoundary(
                    key: boundary,
                    child: ColoredBox(
                      color: surface,
                      child: SizedBox(
                        width: 240,
                        height: 48,
                        child: range
                            ? VanillaRangeSlider(
                                surfaceColor: surface,
                                values: const [.25, .75],
                                onChanged: (_) {},
                              )
                            : VanillaSlider(
                                surfaceColor: surface,
                                value: .25,
                                onChanged: (_) {},
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final thumb =
              tester.getTopLeft(find.byKey(boundary)) + const Offset(64, 24);
          final mouse = await tester.createGesture(
            kind: PointerDeviceKind.mouse,
          );
          await mouse.addPointer(location: Offset.zero);
          await tester.pump();
          await mouse.moveTo(thumb);
          await tester.pumpAndSettle();
          final hover = await _haloPixels(tester, boundary, range: range);
          await mouse.down(thumb);
          await tester.pumpAndSettle();
          final press = await _haloPixels(tester, boundary, range: range);
          expect(
            press,
            isNot(hover),
            reason: 'mouse press after hover remains distinct',
          );
          await mouse.up();
          await mouse.removePointer();
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}

Future<int> _haloPixels(
  WidgetTester tester,
  GlobalKey boundary, {
  required bool range,
}) async {
  final render = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(boundary),
  );
  final pixels = (await tester.runAsync(() async {
    final image = await render.toImage(pixelRatio: 1);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    image.dispose();
    return bytes;
  }))!;
  int at(int x, int y) => pixels.getUint32((y * 240 + x) * 4, Endian.big);
  final overFill = at(range ? 72 : 55, 23);
  final overSurface = at(63, 15);
  expect(
    overFill,
    overSurface,
    reason: 'the halo stays even across the filled interval',
  );
  final red = (overSurface >> 24) & 255;
  final blue = (overSurface >> 8) & 255;
  expect(
    blue,
    greaterThan(red),
    reason:
        'the halo retains the blue surface tint instead of the neutral page',
  );
  return overSurface;
}
