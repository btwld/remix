import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pixels per logical pixel in [capturePixels].
const pixelScale = 4;

/// An RGBA capture of a repaint boundary.
final class Pixels {
  const Pixels(this._data, this._width);

  final ByteData _data;
  final int _width;

  Color at(int x, int y) {
    final offset = (y * _width + x) * 4;
    return Color.fromARGB(
      _data.getUint8(offset + 3),
      _data.getUint8(offset),
      _data.getUint8(offset + 1),
      _data.getUint8(offset + 2),
    );
  }
}

/// Renders the repaint boundary at [key] at [pixelScale] times its logical
/// size.
Future<Pixels> capturePixels(WidgetTester tester, GlobalKey key) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(find.byKey(key));
  return (await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: pixelScale.toDouble());
    final data = (await image.toByteData())!;
    return Pixels(data, image.width);
  }))!;
}

/// Passes when every channel of [actual] is within 2/255 of [expected].
void expectNearColor(Color actual, Color expected) {
  for (final (name, a, e) in [
    ('red', actual.r, expected.r),
    ('green', actual.g, expected.g),
    ('blue', actual.b, expected.b),
    ('alpha', actual.a, expected.a),
  ]) {
    expect(
      (a - e).abs() * 255,
      lessThanOrEqualTo(2),
      reason: '$name of $actual is not near $expected',
    );
  }
}
