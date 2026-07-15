import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'support/fortal_atlas_catalog.dart';

void main() {
  group('Fortal portable adapters', () {
    test('build 21 strict deterministic component-v2 documents', () {
      final documents = <Map<String, Object?>>[];

      for (final entry in fortalAtlasEntries) {
        final first = entry.buildPortable().buildJson();
        final second = entry.buildPortable().buildJson();
        final recipes = first['recipes']! as List<Object?>;
        final states = first['states']! as List<Object?>;

        expect(first['schema'], 'mix_atlas/component/v2');
        expect(first['id'], entry.atlas.id);
        expect(recipes, hasLength(entry.atlas.rows.length));
        expect(states, hasLength(entry.atlas.scenarios.length));
        expect(jsonEncode(first), jsonEncode(second));
        expect(jsonEncode(first), isNot(contains('unsupported')));
        documents.add(first);
      }

      final recipeCount = documents.fold<int>(
        0,
        (total, document) =>
            total + (document['recipes']! as List<Object?>).length,
      );
      final cellsPerTheme = fortalAtlasEntries.fold<int>(
        0,
        (total, entry) =>
            total + entry.atlas.rows.length * entry.atlas.scenarios.length,
      );

      expect(documents, hasLength(21));
      expect(recipeCount, 148);
      expect(cellsPerTheme, 613);
      expect(cellsPerTheme * fortalAtlasCatalog.themes.length, 1226);
    });

    test('preserves structural and accessibility state evidence', () {
      final documents = {
        for (final entry in fortalAtlasEntries)
          entry.atlas.id: entry.buildPortable().buildDocument(),
      };

      expect(documents['button']!.states['loading']!.propertyOverrides, {
        'enabled': false,
        'loading': true,
      });
      for (final id in ['checkbox', 'radio', 'switch', 'toggle']) {
        expect(
          documents[id]!.states['selected']!.propertyOverrides['selected'],
          isTrue,
        );
        expect(
          documents[id]!.states['disabled']!.propertyOverrides['enabled'],
          isFalse,
        );
      }
      expect(
        documents['accordion']!
            .states['expanded']!
            .propertyOverrides['expanded'],
        isTrue,
      );
      expect(
        documents['textfield']!.states['error']!.propertyOverrides['error'],
        isTrue,
      );
      expect(documents['tabs']!.semantics.role, 'tab');
      expect(documents['slider']!.semantics.role, 'slider');
    });
  });
}
