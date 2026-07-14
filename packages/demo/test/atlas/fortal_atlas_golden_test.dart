import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mix_atlas/golden.dart';

import 'support/fortal_atlas_catalog.dart';

void main() {
  test('catalog covers every Fortal component family', () {
    final componentRoot = Directory('../remix/lib/src/components');
    final sourceIds = [
      for (final directory in componentRoot.listSync().whereType<Directory>())
        if (_hasFortalStyles(directory))
          directory.uri.pathSegments
              .where((part) => part.isNotEmpty)
              .last
              .replaceAll('_', '-'),
    ]..sort();
    final catalogIds = [
      for (final atlas in fortalAtlasCatalog.atlases) atlas.id,
    ]..sort();

    expect(catalogIds, sourceIds);
  });

  registerAtlasCatalogGoldens(fortalAtlasCatalog);
}

bool _hasFortalStyles(Directory directory) {
  final sourceId = directory.uri.pathSegments
      .where((part) => part.isNotEmpty)
      .last;

  return File('${directory.path}/fortal_${sourceId}_styles.dart').existsSync();
}
