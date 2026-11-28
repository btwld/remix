import 'package:flutter/rendering.dart' show RenderRepaintBoundary;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// An opaque green that no control in these tests paints, so its bounding box
/// in a rendered image is a selection indicator wherever its layer was placed.
const indicatorGreen = Color(0xFF00C800);

/// The bounding box, in global coordinates, of the pixels [color] paints
/// inside the [RepaintBoundary] keyed [boundary], or `null` when there are
/// none. Reads what is drawn, because an indicator is placed by its layer.
Future<Rect?> paintedRect(
  WidgetTester tester,
  GlobalKey boundary, {
  Color color = indicatorGreen,
}) async {
  final origin = tester.getTopLeft(find.byKey(boundary));
  final result = await tester.runAsync(() async {
    final render =
        boundary.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await render.toImage();
    final data = (await image.toByteData())!;
    var minX = image.width, minY = image.height, maxX = -1, maxY = -1;
    final r = (color.r * 255).round(), g = (color.g * 255).round();
    final b = (color.b * 255).round();
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final i = (y * image.width + x) * 4;
        if (data.getUint8(i) == r &&
            data.getUint8(i + 1) == g &&
            data.getUint8(i + 2) == b &&
            data.getUint8(i + 3) == 255) {
          if (x < minX) minX = x;
          if (y < minY) minY = y;
          if (x > maxX) maxX = x;
          if (y > maxY) maxY = y;
        }
      }
    }
    return maxX < 0
        ? null
        : Rect.fromLTRB(
            minX.toDouble(),
            minY.toDouble(),
            maxX + 1.0,
            maxY + 1.0,
          );
  });
  return result?.shift(origin);
}

/// Expects the painted rect to match [expected] to within antialiasing.
void expectRectNear(Rect? actual, Rect expected) {
  expect(actual, isNotNull, reason: 'the indicator paints');
  expect(actual!.left, closeTo(expected.left, 1.5));
  expect(actual.top, closeTo(expected.top, 1.5));
  expect(actual.right, closeTo(expected.right, 1.5));
  expect(actual.bottom, closeTo(expected.bottom, 1.5));
}
