import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas_capture/mix_atlas_capture.dart';

void main() {
  test(
    'committed Fortal capture loads as 21 complete portable matrices',
    () async {
      final capture =
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
      final documents = capture.componentDocuments;
      final componentIds = {for (final document in documents) document.id};
      final catalogIds = {
        for (final component in capture.catalog.components) component.id,
      };
      final recipeCount = documents.fold<int>(
        0,
        (total, document) => total + document.recipes.length,
      );
      final cellsPerTheme = documents.fold<int>(
        0,
        (total, document) =>
            total + document.recipes.length * document.states.length,
      );

    expect(capture.manifest.componentDocuments, hasLength(21));
      expect(documents, hasLength(21));
      expect(componentIds, catalogIds);
      expect(documents.map((document) => document.schema).toSet(), {
        AtlasComponentDocumentSchema.v2,
      });
      expect(recipeCount, 148);
      expect(cellsPerTheme, 613);
      expect(cellsPerTheme * capture.catalog.themes.length, 1226);
      expect(capture.atlasMetadata, hasLength(42));
      expect(
        capture.protocolCoverage.items.map((item) => item.status).toSet(),
        {'supported'},
      );
      expect(capture.protocolCoverage.unsupportedCount, 0);
      expect(
        capture.files.keys.where((path) => path.startsWith('styles/')),
        isEmpty,
      );
      expect(
        documents
            .expand((document) => document.diagnostics)
            .map((diagnostic) => diagnostic.severity),
        everyElement('info'),
      );
    },
  );
}
