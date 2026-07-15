import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas/golden.dart';
import 'package:mix_atlas/mix_atlas.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

import 'support/fortal_atlas_catalog.dart';

void main() {
  late AtlasCapture capture;

  setUpAll(() async {
    capture =
        await AtlasCaptureReader(
          source: AtlasDirectorySource(
            Directory('../../atlas/fortal').absolute,
          ),
        ).load(
          const AtlasRepositoryRequest(
            repository: 'local',
            ref: 'local',
            manifestPath: 'capture.json',
          ),
        );
  });

  for (final theme in fortalAtlasCatalog.themes) {
    for (final entry in fortalAtlasEntries) {
      testWidgets('${entry.atlas.id} portable parity - ${theme.id}', (
        tester,
      ) async {
        tester.platformDispatcher.platformBrightnessTestValue =
            theme.brightness;
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(4096, 4096);
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
        final document = capture.componentDocuments.singleWhere(
          (candidate) => candidate.id == entry.atlas.id,
        );
        final portableAtlas = _portableAtlas(
          entry,
          capture: capture,
          document: document,
          themeId: theme.id,
        );
        final sheetSize = _oracleSize(entry.atlas.id, theme.id);

        await expectAtlasWidgetParity(
          tester,
          producer: _contactSheet(entry.atlas, theme, size: sheetSize),
          portable: _contactSheet(portableAtlas, theme, size: sheetSize),
          failureDirectory: Directory('../../../fortal-parity'),
          failureName: '${entry.atlas.id}-${theme.id}',
        );
      });
    }
  }
}

ComponentAtlas _portableAtlas(
  FortalAtlasEntry entry, {
  required AtlasCapture capture,
  required AtlasComponentDocument document,
  required String themeId,
}) {
  final producer = entry.atlas;

  return ComponentAtlas(
    id: producer.id,
    label: producer.label,
    rowAxes: producer.rowAxes,
    scenarios: producer.scenarios,
    rows: [
      for (final row in producer.rows)
        AtlasRow(
          row.id,
          (_, cell) => AtlasPortableComponent(
            capture: capture,
            component: document,
            selection: AtlasComponentSelection(
              recipeId: row.id,
              stateId: cell.scenario.id,
              themeId: themeId,
            ),
          ),
          label: row.label,
          values: row.values,
        ),
    ],
  );
}

Widget _contactSheet(
  ComponentAtlas atlas,
  AtlasTheme theme, {
  required Size size,
}) {
  return SizedBox(
    width: size.width,
    height: size.height,
    child: MaterialApp(
      home: Align(
        alignment: Alignment.topLeft,
        child: SingleChildScrollView(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Builder(
              builder: (context) => theme.builder(
                context,
                ColoredBox(
                  color: theme.background,
                  child: Material(
                    type: MaterialType.transparency,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: AtlasView(
                        atlas: atlas,
                        title: '${atlas.id} - ${theme.id}',
                        labelColor: theme.brightness == Brightness.dark
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
      theme: ThemeData(brightness: theme.brightness),
      debugShowCheckedModeBanner: false,
    ),
  );
}

Size _oracleSize(String componentId, String themeId) {
  final bytes = File(
    'test/atlas/goldens/$themeId/$componentId.png',
  ).readAsBytesSync();
  if (bytes.length < 24 ||
      bytes[0] != 0x89 ||
      String.fromCharCodes(bytes.sublist(1, 4)) != 'PNG') {
    throw StateError('Invalid Atlas oracle PNG for $themeId/$componentId.');
  }
  final header = ByteData.sublistView(bytes);

  return Size(header.getUint32(16).toDouble(), header.getUint32(20).toDouble());
}
