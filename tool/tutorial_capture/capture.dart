/// Screenshot helpers for the tutorial replay (`tool/replay_tutorial.py`).
///
/// The replay copies this directory into a sample's `test/` folder, runs one
/// capture test, and removes the copies, so none of it ships in the samples.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

const _boundary = Key('tutorial-capture');

/// The test font replaces every family that is not loaded explicitly, so
/// Geist and Material Icons come from the app's own font manifest.
Future<void> loadManifestFonts() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final manifest =
      jsonDecode(await rootBundle.loadString('FontManifest.json'))
          as List<dynamic>;
  for (final entry in manifest.cast<Map<String, dynamic>>()) {
    final loader = FontLoader(entry['family'] as String);
    for (final font
        in (entry['fonts'] as List<dynamic>).cast<Map<String, dynamic>>()) {
      loader.addFont(rootBundle.load(font['asset'] as String));
    }
    await loader.load();
  }
}

Future<void> pumpScene(WidgetTester tester, Widget app) async {
  // first-main's WidgetsApp shows the debug banner; SampleApp turns it off.
  WidgetsApp.debugAllowBannerOverride = false;
  addTearDown(() => WidgetsApp.debugAllowBannerOverride = true);
  tester.view.physicalSize = const Size(1440, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(RepaintBoundary(key: _boundary, child: app));
  await tester.pumpAndSettle();
}

Future<void> writeCapture(WidgetTester tester) async {
  const output = String.fromEnvironment('TUTORIAL_CAPTURE_OUT');
  if (output.isEmpty) {
    throw StateError('Pass --dart-define=TUTORIAL_CAPTURE_OUT=<png path>');
  }
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_boundary),
  );
  await tester.runAsync(() async {
    final image = await boundary.toImage(pixelRatio: 1);
    final ByteData? png;
    try {
      png = await image.toByteData(format: ui.ImageByteFormat.png);
    } finally {
      image.dispose();
    }
    await File(output).writeAsBytes(png!.buffer.asUint8List());
  });
}
