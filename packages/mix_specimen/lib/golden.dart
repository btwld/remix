/// Golden-snapshot harness for specimen sheets.
///
/// Test-only entrypoint (depends on `flutter_test`); import from test files
/// and `flutter_test_config.dart`, never from app code.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mix_specimen.dart';

/// Loads Roboto and MaterialIcons from the Flutter SDK cache so specimen
/// goldens render legible text and icons instead of the block test font.
///
/// Call from `flutter_test_config.dart` before running tests.
Future<void> loadSpecimenFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  if (flutterRoot == null) return;

  final fontsDir = Directory('$flutterRoot/bin/cache/artifacts/material_fonts');
  if (!fontsDir.existsSync()) return;

  final files = fontsDir.listSync().whereType<File>().toList()
    ..sort((a, b) => a.path.compareTo(b.path));

  final roboto = FontLoader('Roboto');
  final icons = FontLoader('MaterialIcons');
  for (final file in files) {
    final name = file.uri.pathSegments.last;
    if (name.startsWith('Roboto-')) {
      roboto.addFont(_fontData(file));
    } else if (name == 'MaterialIcons-Regular.otf') {
      icons.addFont(_fontData(file));
    }
  }

  await roboto.load();
  await icons.load();
}

Future<ByteData> _fontData(File file) async =>
    ByteData.sublistView(await file.readAsBytes());

/// Pumps [specimen] under [theme] and compares it against
/// `goldens/<theme.id>/<specimen.id>.png` (relative to the test file).
///
/// Records a manifest entry; call [SpecimenManifest.write] from
/// `tearDownAll` so `--update-goldens` also refreshes `manifest.json`.
Future<void> expectSpecimenGolden(
  WidgetTester tester, {
  required Specimen specimen,
  required SpecimenTheme theme,
}) async {
  tester.platformDispatcher.platformBrightnessTestValue = theme.brightness;
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(4096, 4096);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

  const sheetKey = ValueKey('mix_specimen.sheet');
  final isDark = theme.brightness == Brightness.dark;

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: theme.brightness),
      home: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Builder(
              builder: (context) => theme.builder(
                context,
                RepaintBoundary(
                  key: sheetKey,
                  child: ColoredBox(
                    color: theme.background,
                    // Transparent Material supplies a real DefaultTextStyle
                    // (Roboto in tests); without it component text falls back
                    // to the block test font with yellow underlines.
                    child: Material(
                      type: MaterialType.transparency,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: SpecimenSheet(
                          specimen: specimen,
                          title: '${specimen.id} - ${theme.id}',
                          labelColor: isDark
                              ? const Color(0x99FFFFFF)
                              : const Color(0x99000000),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );

  // Fixed pump instead of pumpAndSettle: looping animations (spinners) never
  // settle, and a fixed offset keeps their captured frame deterministic.
  await tester.pump(const Duration(milliseconds: 200));

  final goldenPath = 'goldens/${theme.id}/${specimen.id}.png';
  await expectLater(find.byKey(sheetKey), matchesGoldenFile(goldenPath));

  SpecimenManifest.entries.add({
    'component': specimen.id,
    'theme': theme.id,
    'brightness': theme.brightness.name,
    'file': goldenPath,
    'rows': [for (final row in specimen.rows) row.id],
    'columns': [
      for (final scenario in specimen.scenarios)
        {
          'id': scenario.id,
          'states': [for (final state in scenario.states) state.name],
          'props': scenario.props,
        },
    ],
  });
}

/// Accumulates entries for `goldens/manifest.json`, the machine-readable
/// index AI agents use to locate and interpret specimen sheets.
abstract final class SpecimenManifest {
  static final entries = <Map<String, Object?>>[];

  /// Writes the manifest next to the goldens. No-op unless the run passed
  /// `--update-goldens`, mirroring when golden files themselves change.
  static Future<void> write() async {
    if (!autoUpdateGoldenFiles || entries.isEmpty) return;

    final comparator = goldenFileComparator;
    if (comparator is! LocalFileComparator) return;

    entries.sort((a, b) {
      final byComponent = (a['component']! as String).compareTo(
        b['component']! as String,
      );
      if (byComponent != 0) return byComponent;

      return (a['theme']! as String).compareTo(b['theme']! as String);
    });

    final file = File.fromUri(
      comparator.basedir.resolve('goldens/manifest.json'),
    );
    await file.parent.create(recursive: true);
    await file.writeAsString(
      const JsonEncoder.withIndent(
        '  ',
      ).convert({'schema': 'mix_specimen/v0', 'entries': entries}),
    );
  }
}
