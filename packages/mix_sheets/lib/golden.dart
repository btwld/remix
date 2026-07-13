/// Golden-snapshot harness for component sheets.
///
/// Test-only entrypoint (depends on `flutter_test`); import from test files
/// and `flutter_test_config.dart`, never from app code.
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'mix_sheets.dart';

/// Configuration for sheet golden generation.
abstract final class SheetGoldens {
  /// Operating systems whose rendered bytes match the committed baselines.
  ///
  /// Font rasterization differs subtly across platforms, so goldens are only
  /// generated and compared on the platforms listed here; everywhere else
  /// [expectSheetGolden] skips the comparison. Override in
  /// `flutter_test_config.dart` if your team generates goldens elsewhere.
  static Set<String> platforms = {'macos'};
}

/// Loads Roboto and MaterialIcons from the Flutter SDK cache so sheet
/// goldens render legible text and icons instead of the block test font.
///
/// Call from `flutter_test_config.dart` before running tests. Throws when
/// the fonts cannot be located: silently falling back to the block font
/// would produce baselines that mismatch every correctly-rendered run.
Future<void> loadSheetFonts() async {
  final flutterRoot = Platform.environment['FLUTTER_ROOT'];
  final fontsDir = flutterRoot == null
      ? null
      : Directory('$flutterRoot/bin/cache/artifacts/material_fonts');
  if (fontsDir == null || !fontsDir.existsSync()) {
    throw StateError(
      'mix_sheets could not locate the Flutter SDK material fonts '
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
void configureSheetGoldenComparator() {
  final current = goldenFileComparator;
  if (current is! LocalFileComparator || current is _SheetLocalFileComparator) {
    return;
  }

  goldenFileComparator = _SheetLocalFileComparator(
    current.basedir.resolve('.mix_sheets_test.dart'),
  );
}

final class _SheetLocalFileComparator extends LocalFileComparator {
  _SheetLocalFileComparator(super.testFile);

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) {
    final file = File.fromUri(basedir.resolve(golden.path));
    file.parent.createSync(recursive: true);
    file.writeAsBytesSync(imageBytes);

    return Future.value();
  }
}

/// Pumps [sheet] under [theme] and compares it against
/// `goldens/<theme.id>/<sheet.id>.png` (relative to the test file).
///
/// With `--update-goldens` it also writes a `<sheet.id>.json` sidecar next
/// to the image describing the sheet's axes, so agents can interpret the grid
/// without reading the test source. Each test owns its own sidecar; test
/// files run in separate processes, so a shared manifest would lose entries.
///
/// On platforms outside [SheetGoldens.platforms] the test is skipped.
Future<void> expectSheetGolden(
  WidgetTester tester, {
  required ComponentSheet sheet,
  required SheetTheme theme,
}) async {
  sheet.validate();
  if (!SheetGoldens.platforms.contains(Platform.operatingSystem)) {
    markTestSkipped(
      'Sheet goldens are generated on ${SheetGoldens.platforms}; '
      'rendering differs on ${Platform.operatingSystem}.',
    );

    return;
  }

  tester.platformDispatcher.platformBrightnessTestValue = theme.brightness;
  tester.view.devicePixelRatio = 1.0;
  tester.view.physicalSize = const Size(4096, 4096);
  addTearDown(tester.view.reset);
  addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);

  const sheetKey = ValueKey('mix_sheets.sheet');
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
                        child: SheetView(
                          sheet: sheet,
                          title: '${sheet.id} - ${theme.id}',
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
  // The zero-duration pump also flushes deterministic post-frame overlay opens
  // after nested local Navigators have attached their anchors.
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));

  final goldenPath = 'goldens/${theme.id}/${sheet.id}.png';
  await expectLater(find.byKey(sheetKey), matchesGoldenFile(goldenPath));

  _writeSidecar(sheet, theme, goldenPath);
}

/// Writes the machine-readable sidecar describing a sheet's axes. No-op
/// unless the run passed `--update-goldens`, mirroring when the golden
/// image itself changes.
void _writeSidecar(ComponentSheet sheet, SheetTheme theme, String goldenPath) {
  if (!autoUpdateGoldenFiles) return;

  final comparator = goldenFileComparator;
  if (comparator is! LocalFileComparator) return;

  final sidecarPath = 'goldens/${theme.id}/${sheet.id}.json';
  final file = File.fromUri(comparator.basedir.resolve(sidecarPath));
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    const JsonEncoder.withIndent(
      '  ',
    ).convert(componentSheetMetadata(sheet, theme)),
  );
}

/// Creates the structured v1 sidecar payload for a sheet.
Map<String, Object?> componentSheetMetadata(
  ComponentSheet sheet,
  SheetTheme theme,
) {
  sheet.validate();
  return {
    'schema': 'mix_sheets/sheet/v1',
    'component': sheet.id,
    if (sheet.label != null) 'componentLabel': sheet.label,
    'theme': theme.id,
    if (theme.label != null) 'themeLabel': theme.label,
    'brightness': theme.brightness.name,
    'file': '${sheet.id}.png',
    'rowAxes': [
      for (final axis in sheet.rowAxes) {'id': axis.id, 'label': axis.label},
    ],
    'rows': [
      for (final row in sheet.rows)
        {
          'id': row.id,
          if (row.label != null) 'label': row.label,
          'values': {
            for (final axis in sheet.rowAxes)
              axis.id: {
                'id': row.values[axis.id]!.id,
                'label': row.values[axis.id]!.label,
              },
          },
        },
    ],
    'columns': [
      for (final scenario in sheet.scenarios)
        {
          'id': scenario.id,
          if (scenario.label != null) 'label': scenario.label,
          'states': [for (final state in scenario.states) state.name],
          'props': scenario.props,
        },
    ],
  };
}

/// Creates the deterministic v1 catalog index payload.
Map<String, Object?> sheetCatalogMetadata(SheetCatalog catalog) {
  catalog.validate();
  return {
    'schema': 'mix_sheets/catalog/v1',
    'id': catalog.id,
    if (catalog.label != null) 'label': catalog.label,
    'themes': [
      for (final theme in catalog.themes)
        {
          'id': theme.id,
          if (theme.label != null) 'label': theme.label,
          'brightness': theme.brightness.name,
        },
    ],
    'sheets': [
      for (final sheet in catalog.sheets)
        {
          'id': sheet.id,
          if (sheet.label != null) 'label': sheet.label,
          'files': [
            for (final theme in catalog.themes)
              {
                'theme': theme.id,
                'image': '${theme.id}/${sheet.id}.png',
                'metadata': '${theme.id}/${sheet.id}.json',
              },
          ],
        },
    ],
  };
}

/// Registers one golden test per catalog sheet/theme pair and writes a
/// deterministic `goldens/catalog.json` index during golden updates.
void registerSheetCatalogGoldens(SheetCatalog catalog) {
  catalog.validate();
  for (final theme in catalog.themes) {
    for (final sheet in catalog.sheets) {
      testWidgets('${sheet.id} sheet - ${theme.id}', (tester) async {
        await expectSheetGolden(tester, sheet: sheet, theme: theme);
        _writeCatalogIndex(catalog);
      });
    }
  }
}

void _writeCatalogIndex(SheetCatalog catalog) {
  if (!autoUpdateGoldenFiles) return;
  final comparator = goldenFileComparator;
  if (comparator is! LocalFileComparator) return;

  final file = File.fromUri(comparator.basedir.resolve('goldens/catalog.json'));
  file.parent.createSync(recursive: true);
  file.writeAsStringSync(
    const JsonEncoder.withIndent('  ').convert(sheetCatalogMetadata(catalog)),
  );
}
