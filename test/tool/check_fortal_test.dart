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
