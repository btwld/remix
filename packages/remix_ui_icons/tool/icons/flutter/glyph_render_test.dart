// Renders every glyph through Flutter and compares it with its source SVG.
//
// tool/icons/check.py rasterizes the SVG masters with CairoSVG and runs this
// test against that directory and an independently SVG-derived reference font:
//
//     REMIX_ICONS_RASTERS=<dir> flutter test tool/icons/flutter
//
// raster.py already proves each font outline matches its SVG through one
// rasterizer. This proves the same through Flutter's own text pipeline: the
// font loads, every codepoint maps to its glyph, and the glyph fills the icon
// box at its master size the way the drawing does. Both fonts pass through the
// same platform rasterizer; CoreText adds different edge coverage than Cairo.
// Geometry must also remain within the Cairo source's one-pixel coverage band.
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix_ui_icons/icons_index.dart';

/// The raster scale check.py writes. A 24 px master renders at 96 px.
const scale = 4;

/// Mean absolute alpha difference, in 0-255, over the whole icon box.
///
/// The expected font is built from SVGs with an independent cmap, not from the
/// compiled font. Both use the same platform text rasterizer. Cairo geometry
/// and font-outline comparisons remain separate checks.
const maxMeanAlphaDelta = 6.0;

/// Pixels at least half covered in one raster with no half-covered pixel
/// within one pixel in the other, as a share of the pixels covered in either.
///
/// Flutter's text rasterizer applies its own gamma to glyph edges, so edge
/// pixels legitimately differ by a few steps of coverage. A one-pixel band
/// absorbs that and nothing else: a wrong, missing, offset, or mirrored
/// glyph leaves whole strokes outside it.
const maxStrayCoverage = 0.005;

typedef _Difference = ({double mean, double stray});

late String referenceFamily;
late Map<String, dynamic> referenceCodes;

String _kebab(String name) => name.replaceAllMapped(
  RegExp('[A-Z]'),
  (match) => '-${match[0]!.toLowerCase()}',
);

String _rasterPath(String rasters, RemixIconEntry entry) =>
    '$rasters/${entry.family.name}/${entry.style.name}/${entry.master}/'
    '${_kebab(entry.concept)}.png';

Future<Uint8List> _alpha(ui.Image image) async {
  final bytes = (await image.toByteData(format: ui.ImageByteFormat.rawRgba))!;
  final rgba = bytes.buffer.asUint8List();
  return Uint8List.fromList([
    for (var index = 3; index < rgba.length; index += 4) rgba[index],
  ]);
}

/// See [maxStrayCoverage].
double _strayCoverage(Uint8List actual, Uint8List expected, int width) {
  final height = actual.length ~/ width;
  bool covered(Uint8List alpha, int x, int y) =>
      x >= 0 &&
      y >= 0 &&
      x < width &&
      y < height &&
      alpha[y * width + x] >= 128;
  bool near(Uint8List alpha, int x, int y) {
    for (var dy = -1; dy <= 1; dy++) {
      for (var dx = -1; dx <= 1; dx++) {
        if (covered(alpha, x + dx, y + dy)) return true;
      }
    }
    return false;
  }

  var stray = 0;
  var union = 0;
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      final a = covered(actual, x, y);
      final b = covered(expected, x, y);
      if (a || b) union++;
      if ((a && !near(expected, x, y)) || (b && !near(actual, x, y))) stray++;
    }
  }
  return union == 0 ? 0 : stray / union;
}

Future<Uint8List> _renderFont(
  WidgetTester tester,
  IconData icon,
  int size, {
  Offset offset = Offset.zero,
}) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: Transform.translate(
            offset: offset,
            child: Icon(
              icon,
              size: size.toDouble(),
              color: const Color(0xFF000000),
            ),
          ),
        ),
      ),
    ),
  );
  final boundary =
      key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
  return (await tester.runAsync(() async {
    final image = await boundary.toImage();
    final alpha = await _alpha(image);
    image.dispose();
    return alpha;
  }))!;
}

/// Compare through the platform font rasterizer, plus Cairo geometry coverage.
/// [path] selects the expected source independently of the rendered entry; the
/// negative controls deliberately use another drawing's path.
Future<_Difference> _compare(
  WidgetTester tester,
  RemixIconEntry entry,
  String path, {
  IconData? renderedIcon,
  Offset offset = Offset.zero,
}) async {
  final size = entry.master * scale;
  final parts = path.replaceAll(r'\', '/').split('/');
  final source = parts
      .sublist(parts.length - 4)
      .join('/')
      .replaceAll('.png', '.svg');
  // This test alone loads an independently assigned source-font cmap.
  final expectedIcon = IconData(
    // ignore: non_const_argument_for_const_parameter
    referenceCodes[source] as int,
    // ignore: non_const_argument_for_const_parameter
    fontFamily: referenceFamily,
  );
  final actual = await _renderFont(
    tester,
    renderedIcon ?? entry.icon,
    size,
    offset: offset,
  );
  final expected = await _renderFont(tester, expectedIcon, size);
  final cairo = (await tester.runAsync(() async {
    final codec = await ui.instantiateImageCodec(File(path).readAsBytesSync());
    final frame = await codec.getNextFrame();
    final alpha = await _alpha(frame.image);
    frame.image.dispose();
    codec.dispose();
    return alpha;
  }))!;
  if (actual.length != expected.length || actual.length != cairo.length) {
    return (mean: double.infinity, stray: 1.0);
  }
  var delta = 0;
  for (var index = 0; index < actual.length; index++) {
    delta += (actual[index] - expected[index]).abs();
  }
  return (
    mean: delta / actual.length,
    stray: math.max(
      _strayCoverage(actual, expected, size),
      _strayCoverage(actual, cairo, size),
    ),
  );
}

bool _matches(_Difference difference) =>
    difference.mean <= maxMeanAlphaDelta &&
    difference.stray <= maxStrayCoverage;

String _describe(_Difference difference) =>
    'mean alpha delta ${difference.mean.toStringAsFixed(2)}, stray coverage '
    '${(difference.stray * 100).toStringAsFixed(2)}%';

void main() {
  final rasters = Platform.environment['REMIX_ICONS_RASTERS'];

  setUpAll(() async {
    if (rasters == null) {
      fail('Set REMIX_ICONS_RASTERS; tool/icons/check.py runs this test.');
    }
    final reference =
        jsonDecode(File('$rasters/source-reference.json').readAsStringSync())
            as Map<String, dynamic>;
    referenceFamily = reference['family'] as String;
    referenceCodes = reference['codepoints'] as Map<String, dynamic>;
    await (FontLoader(referenceFamily)..addFont(
          Future.value(
            ByteData.sublistView(
              File('$rasters/source-reference.otf').readAsBytesSync(),
            ),
          ),
        ))
        .load();
    final font = File(
      'lib/src/generated/fonts/RemixIcons.otf',
    ).readAsBytesSync();
    await (FontLoader(
      'packages/remix_ui_icons/RemixIcons',
    )..addFont(Future.value(ByteData.sublistView(font)))).load();
  });

  testWidgets('every glyph matches its source SVG', (tester) async {
    final failures = <String>[];
    var worstMean = 0.0;
    var worstStray = 0.0;
    for (final entry in remixIconEntries) {
      final difference = await _compare(
        tester,
        entry,
        _rasterPath(rasters!, entry),
      );
      if (difference.mean > worstMean) worstMean = difference.mean;
      if (difference.stray > worstStray) worstStray = difference.stray;
      if (!_matches(difference)) {
        failures.add(
          '${entry.family.name}.${entry.name}: ${_describe(difference)}',
        );
      }
    }
    // ignore: avoid_print
    print(
      '${remixIconEntries.length} glyphs rendered; worst '
      '${_describe((mean: worstMean, stray: worstStray))}.',
    );
    expect(failures, isEmpty, reason: failures.join('\n'));
  });

  testWidgets('a different drawing does not match', (tester) async {
    // The control: if the comparison cannot tell neighbors apart, the test
    // above proves nothing.
    RemixIconEntry entry(String name, RemixIconFamily family) =>
        remixIconEntries.singleWhere(
          (entry) => entry.name == name && entry.family == family,
        );
    final pairs = [
      (entry('chevronLeft', .outline), entry('chevronRight', .outline)),
      (entry('arrowUp', .outline), entry('arrowDown', .outline)),
      (entry('plus16', .outline), entry('plusFilled16', .outline)),
      (entry('search', .outline), entry('search', .rounded)),
      (entry('star12', .rounded), entry('star12', .outline)),
    ];
    for (final (rendered, drawing) in pairs) {
      final difference = await _compare(
        tester,
        rendered,
        _rasterPath(rasters!, drawing),
      );
      // ignore: avoid_print
      print(
        '${rendered.family.name}.${rendered.name} against '
        '${drawing.family.name}.${drawing.name}: ${_describe(difference)}',
      );
      expect(
        _matches(difference),
        isFalse,
        reason:
            '${rendered.family.name}.${rendered.name} matched the drawing of '
            '${drawing.family.name}.${drawing.name}',
      );
    }
  });

  testWidgets('a missing glyph does not match', (tester) async {
    final entry = remixIconEntries.singleWhere(
      (entry) =>
          entry.family == RemixIconFamily.outline && entry.name == 'grid12',
    );
    final difference = await _compare(
      tester,
      entry,
      _rasterPath(rasters!, entry),
      renderedIcon: const IconData(
        0x10FFFF,
        fontFamily: 'RemixIcons',
        fontPackage: 'remix_ui_icons',
      ),
    );
    expect(_matches(difference), isFalse);
  });

  testWidgets('a displaced glyph does not match', (tester) async {
    final entry = remixIconEntries.singleWhere(
      (entry) =>
          entry.family == RemixIconFamily.outline && entry.name == 'grid12',
    );
    final difference = await _compare(
      tester,
      entry,
      _rasterPath(rasters!, entry),
      offset: const Offset(2, 0),
    );
    expect(_matches(difference), isFalse);
  });
}
