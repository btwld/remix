import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_sheets/golden.dart';
import 'package:playground/sheets/fortal_catalog.dart';

Object? _readJson(String path) => jsonDecode(File(path).readAsStringSync());

List<String> _artifactPaths(String root, String extension) {
  final paths = Directory(root)
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith(extension))
      .map(
        (file) => file.path
            .substring(root.length + 1)
            .replaceAll(Platform.pathSeparator, '/'),
      )
      .toList();
  paths.sort();
  return paths;
}

void main() {
  test('committed sheet metadata matches the live catalog', () {
    const goldenRoot = 'test/goldens';

    expect(
      _readJson('$goldenRoot/catalog.json'),
      sheetCatalogMetadata(fortalCatalog),
    );

    final expectedJson = <String>['catalog.json'];
    final expectedPng = <String>[];
    for (final theme in fortalCatalog.themes) {
      for (final sheet in fortalCatalog.sheets) {
        final jsonPath = '${theme.id}/${sheet.id}.json';
        final pngPath = '${theme.id}/${sheet.id}.png';
        expectedJson.add(jsonPath);
        expectedPng.add(pngPath);
        expect(
          _readJson('$goldenRoot/$jsonPath'),
          componentSheetMetadata(sheet, theme),
          reason: jsonPath,
        );
      }
    }

    expectedJson.sort();
    expectedPng.sort();
    expect(_artifactPaths(goldenRoot, '.json'), expectedJson);
    expect(_artifactPaths(goldenRoot, '.png'), expectedPng);
  });
}
