import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_fortal.dart';

void main() {
  test('the authored Fortal catalog satisfies its independent contract', () {
    expect(checkFortalContract(Directory.current), isEmpty);
  });

  group('contract drift', () {
    late Directory candidate;
    late File catalogFile;
    late Map<String, dynamic> catalog;

    setUp(() {
      candidate = Directory.systemTemp.createTempSync('fortal_contract_');
      addTearDown(() => candidate.deleteSync(recursive: true));
      catalogFile = File(
        '${candidate.path}/registry_source/specs/fortal_catalog.json',
      );
      catalog =
          jsonDecode(
                File(
                  'registry_source/specs/fortal_catalog.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      void copy(String path) {
        final target = File('${candidate.path}/$path');
        target.parent.createSync(recursive: true);
        File(path).copySync(target.path);
      }

      for (final file in Directory(
        'registry_source/lib/src/fortal',
      ).listSync(recursive: true).whereType<File>()) {
        copy(file.path);
      }
      copy('registry_source/specs/fortal_catalog.json');
      copy('registry_source/specs/fortal.md');
      final tests = <String>{
        'test/fortal/palette_contrast_test.dart',
        'test/fortal/spec_conformance_test.dart',
        'test/fortal/focus_ring_test.dart',
        for (final family in catalog['families'] as List)
          ...List<String>.from(family['tests'] as List),
      };
      for (final path in tests) {
        copy('registry_source/$path');
      }
      for (final family in catalog['families'] as List) {
        for (final axis in (family['enums'] as Map).values) {
          final source = axis['defaultSource'] as String?;
          if (source != null) copy(source);
        }
      }
      copy(catalog['visualGate'] as String);
    });

    test('a removed classic variant cannot silently return', () {
      final button = File(
        '${candidate.path}/registry_source/lib/src/fortal/components/button.dart',
      );
      button.writeAsStringSync(
        button.readAsStringSync().replaceFirst(
          'enum FortalButtonVariant {',
          'enum FortalButtonVariant { classic,',
        ),
      );
      expect(
        checkFortalContract(candidate),
        anyElement(contains('FortalButtonVariant')),
      );
    });

    // Adds [value] to [enumName] in [file] and to the catalog axis of every
    // family in [owners], so only a family that shares the enum disagrees.
    void driftSharedEnum({
      required String file,
      required String enumName,
      required String value,
      required String kind,
      required Set<String> owners,
    }) {
      final source = File(
        '${candidate.path}/registry_source/lib/src/fortal/components/$file',
      );
      source.writeAsStringSync(
        source.readAsStringSync().replaceFirst(
          'enum $enumName {',
          'enum $enumName { $value,',
        ),
      );
      for (final family in catalog['families'] as List) {
        if (!owners.contains(family['id'])) continue;
        (family['enums'][kind]['values'] as List).insert(0, value);
      }
      catalogFile.writeAsStringSync(jsonEncode(catalog));
    }

    test('surface reads its size from the card', () {
      driftSharedEnum(
        file: 'card.dart',
        enumName: 'FortalCardSize',
        value: 'size0',
        kind: 'size',
        owners: {'card'},
      );
      expect(
        checkFortalContract(candidate),
        anyElement(
          contains(
            'FortalCardSize: [size0, size1, size2, size3, size4, size5] '
            'differs from the Fortal specification '
            '[size1, size2, size3, size4, size5]',
          ),
        ),
      );
    });

    test('combobox reads its variant from the text field', () {
      driftSharedEnum(
        file: 'text_field.dart',
        enumName: 'FortalTextFieldVariant',
        value: 'outline',
        kind: 'variant',
        owners: {'text_field', 'text_area'},
      );
      expect(
        checkFortalContract(candidate),
        anyElement(
          contains(
            'FortalTextFieldVariant: [outline, surface, soft] '
            'differs from the Fortal specification [surface, soft]',
          ),
        ),
      );
    });

    test('matching values do not make the slider enum the combobox size', () {
      final combobox = (catalog['families'] as List).singleWhere(
        (family) => family['id'] == 'combobox',
      );
      combobox['enums']['size']['enumOwner'] = 'slider';
      catalogFile.writeAsStringSync(jsonEncode(catalog));

      expect(
        checkFortalContract(candidate),
        contains(
          'combobox: size uses FortalTextFieldSize, but the catalog names '
          'FortalSliderSize.',
        ),
      );
    });

    test(
      'the inventory follows a declared enum source through a re-export',
      () {
        final components =
            '${candidate.path}/registry_source/lib/src/fortal/components';
        final typography = File('$components/typography.dart');
        final source = typography.readAsStringSync();
        final enumStart = source.indexOf('/// The nine steps');
        final enumEnd = source.indexOf('/// The text style token');
        File(
          '$components/text_axes.dart',
        ).writeAsStringSync(source.substring(enumStart, enumEnd));
        typography.writeAsStringSync(
          '${source.substring(0, enumStart)}'
          "import 'text_axes.dart';\n\nexport 'text_axes.dart';\n\n"
          '${source.substring(enumEnd)}',
        );
        final text = (catalog['families'] as List).singleWhere(
          (family) => family['id'] == 'text',
        );
        text['enumRecipe'] = 'text_axes';
        catalogFile.writeAsStringSync(jsonEncode(catalog));

        expect(checkFortalContract(candidate), isEmpty);
      },
    );

    test('a missing shared enum recipe is reported as contract drift', () {
      File(
        '${candidate.path}/registry_source/lib/src/fortal/components/typography.dart',
      ).deleteSync();
      expect(
        checkFortalContract(candidate),
        anyElement(contains('typography.dart for FortalTextSize')),
      );
    });

    File candidateButton() => File(
      '${candidate.path}/registry_source/lib/src/fortal/components/button.dart',
    );

    void appendToButton(String source) => candidateButton().writeAsStringSync(
      '${candidateButton().readAsStringSync()}\n$source\n',
    );

    test('a control cannot start casting a shadow', () {
      appendToButton('final shadow = FortalTokens.shadow2;');
      expect(
        checkFortalContract(candidate),
        anyElement(contains('button casts a shadow')),
      );
    });

    test('a recipe cannot build its own focus ring', () {
      appendToButton('final ring = RemixBoxEffectsMix(outlineOffset: 3);');
      expect(
        checkFortalContract(candidate),
        anyElement(contains('button builds a focus ring by hand')),
      );
    });

    test('the shadow scan also reads layered shadow tokens', () {
      appendToButton('final shadow = FortalTokens.shadow1Layers;');
      expect(
        checkFortalContract(candidate),
        anyElement(contains('button casts a shadow')),
      );
    });

    test('a raw blurred shadow counts as casting one', () {
      appendToButton('final shadow = BoxShadowMix(blurRadius: 8);');
      expect(
        checkFortalContract(candidate),
        anyElement(contains('button casts a shadow')),
      );
    });

    test('a modifier or nested generics cannot hide a public widget', () {
      appendToButton(
        'final class FortalHidden<T extends List<int>> extends StatelessWidget {}',
      );
      expect(
        checkFortalContract(candidate),
        anyElement(contains('FortalHidden is public')),
      );
    });

    test('a generated public widget must join the catalog', () {
      File(
        '${candidate.path}/registry_source/lib/src/fortal/components/button.g.dart',
      ).writeAsStringSync('class FortalMadeThing extends StatelessWidget {}\n');
      expect(
        checkFortalContract(candidate),
        anyElement(contains('FortalMadeThing is public')),
      );
    });

    test('a new public widget must join the catalog', () {
      appendToButton('class FortalNewThing extends StatelessWidget {}');
      expect(
        checkFortalContract(candidate),
        anyElement(contains('FortalNewThing is public')),
      );
    });

    test('documented defaults must match the theme constructors', () {
      catalog['theme']['enums']['panelBackground']['default'] = 'translucent';
      catalogFile.writeAsStringSync(jsonEncode(catalog));
      expect(
        checkFortalContract(candidate),
        anyElement(contains('panelBackground')),
      );
    });

    test('every family keeps a real test owner', () {
      final family = (catalog['families'] as List).first;
      final path = (family['tests'] as List).first;
      File('${candidate.path}/registry_source/$path').deleteSync();
      expect(checkFortalContract(candidate), anyElement(contains('$path')));
    });

    test('an authored family cannot disappear from the catalog', () {
      (catalog['families'] as List).removeWhere(
        (family) => family['id'] == 'avatar',
      );
      catalogFile.writeAsStringSync(jsonEncode(catalog));
      expect(checkFortalContract(candidate), anyElement(contains('avatar')));
    });
  });
}
