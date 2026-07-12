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

/// Configuration for specimen golden generation.
abstract final class SpecimenGoldens {
  /// Operating systems whose rendered bytes match the committed baselines.
  ///
  /// Font rasterization differs subtly across platforms, so goldens are only
  /// generated and compared on the platforms listed here; everywhere else
  /// [expectSpecimenGolden] skips the comparison. Override in
  /// `flutter_test_config.dart` if your team generates goldens elsewhere.
  static Set<String> platforms = {'macos'};
}

/// Loads Roboto and MaterialIcons from the Flutter SDK cache so specimen
/// goldens render legible text and icons instead of the block test font.
///
/// Call from `flutter_test_config.dart` before running tests. Throws when
/// the fonts cannot be located: silently falling back to the block font
/// would produce baselines that mismatch every correctly-rendered run.
Future<void> loadSpecimenFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  final fontsDir = flutterRoot == null
      ? null
      : Directory('$flutterRoot/bin/cache/artifacts/material_fonts');
  if (fontsDir == null || !fontsDir.existsSync()) {
    throw StateError(
      'mix_specimen could not locate the Flutter SDK material fonts '
      '(FLUTTER_ROOT=${flutterRoot ?? 'unset'}). Run tests through the '
      'flutter tool so FLUTTER_ROOT is set and the font cache exists.',
    );
  }

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

/// Installs a local golden comparator with synchronous artifact writes.
///
/// Flutter's default [LocalFileComparator] uses asynchronous file writes from
/// inside the test binding's `runAsync` zone. That future can hang indefinitely
/// on some macOS/Flutter combinations after the PNG has already been written.
/// These artifacts are small and infrequently updated, so a synchronous write
/// is both reliable and negligible compared with rendering the sheet.
///
/// Call this once from `flutter_test_config.dart` before [testMain].
void configureSpecimenGoldenComparator() {
  final current = goldenFileComparator;
  if (current is! LocalFileComparator ||
      current is _SpecimenLocalFileComparator) {
    return;
  }

  goldenFileComparator = _SpecimenLocalFileComparator(
    current.basedir.resolve('.mix_specimen_test.dart'),
  );
}

final class _SpecimenLocalFileComparator extends LocalFileComparator {
  _SpecimenLocalFileComparator(super.testFile);

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) {
    final file = File.fromUri(basedir.resolve(golden.path));
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(imageBytes);

    return Future.value();
  }
}

/// Pumps [specimen] under [theme] and compares it against
/// `goldens/<theme.id>/<specimen.id>.png` (relative to the test file).
///
/// With `--update-goldens` it also writes a `<specimen.id>.json` sidecar next
/// to the image describing the sheet's axes, so agents can interpret the grid
/// without reading the test source. Each test owns its own sidecar; test
/// files run in separate processes, so a shared manifest would lose entries.
///
/// On platforms outside [SpecimenGoldens.platforms] the test is skipped.
Future<void> expectSpecimenGolden(
  WidgetTester tester, {
  required Specimen specimen,
  required SpecimenTheme theme,
}) async {
  if (!SpecimenGoldens.platforms.contains(Platform.operatingSystem)) {
    markTestSkipped(
      'Specimen goldens are generated on ${SpecimenGoldens.platforms}; '
      'rendering differs on ${Platform.operatingSystem}.',
    );

    return;
  }

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

  _writeSidecar(specimen, theme, goldenPath);
}

/// Writes the machine-readable sidecar describing a sheet's axes. No-op
/// unless the run passed `--update-goldens`, mirroring when the golden
/// image itself changes.
void _writeSidecar(Specimen specimen, SpecimenTheme theme, String goldenPath) {
  if (!autoUpdateGoldenFiles) return;

  final comparator = goldenFileComparator;
  if (comparator is! LocalFileComparator) return;

  final sidecarPath = 'goldens/${theme.id}/${specimen.id}.json';
  final file = File.fromUri(comparator.basedir.resolve(sidecarPath));
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert({
      'schema': 'mix_specimen/v0',
      'component': specimen.id,
      'theme': theme.id,
      'brightness': theme.brightness.name,
      'file': '${specimen.id}.png',
      'rows': [for (final row in specimen.rows) row.id],
      'columns': [
        for (final scenario in specimen.scenarios)
          {
            'id': scenario.id,
            'states': [for (final state in scenario.states) state.name],
            'props': scenario.props,
          },
      ],
    }),
  );
}
