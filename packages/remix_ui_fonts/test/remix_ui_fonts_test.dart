import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remix_ui_fonts/remix_ui_fonts.dart';
import 'package:yaml/yaml.dart';

const _fontsDirectory = 'lib/fonts';

/// A `flutter: fonts:` entry declared in the pubspec.
typedef _Declared = ({String family, int weight});

String _sha256(String path) =>
    sha256.convert(File(path).readAsBytesSync()).toString();

void main() {
  // Tests run with the package root as the working directory.
  final pubspec = loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;

  // Font asset path -> declared family and weight.
  final declared = <String, _Declared>{
    for (final family
        in ((pubspec['flutter'] as YamlMap)['fonts'] as YamlList)
            .cast<YamlMap>())
      for (final font in (family['fonts'] as YamlList).cast<YamlMap>())
        font['asset'] as String: (
          family: family['family'] as String,
          weight: font['weight'] as int,
        ),
  };

  // One directory per upstream font project, each with its own lock.
  final projects =
      Directory(_fontsDirectory)
          .listSync()
          .whereType<Directory>()
          .map((directory) => directory.path)
          .toList()
        ..sort();

  test('lib/fonts holds only font project directories', () {
    expect(Directory(_fontsDirectory).listSync().whereType<File>(), isEmpty);
    expect(projects, isNotEmpty);
  });

  test('each family declares a weight at most once', () {
    final seen = <_Declared>{};
    for (final font in declared.values) {
      expect(seen.add(font), isTrue, reason: '$font is declared twice');
    }
  });

  test('every declared font asset exists', () {
    for (final asset in declared.keys) {
      expect(File(asset).existsSync(), isTrue, reason: '$asset is missing');
    }
  });

  for (final project in projects) {
    group(project, () {
      final lockPath = '$project/fonts.lock.json';
      final lock = File(lockPath).existsSync()
          ? jsonDecode(File(lockPath).readAsStringSync())
                as Map<String, Object?>
          : null;

      test('has a fonts.lock.json with its upstream and license', () {
        expect(lock, isNotNull, reason: '$lockPath is missing');
        expect(lock!['upstream'], isA<Map<String, Object?>>());
        expect(lock['license'], isA<Map<String, Object?>>());
      });

      test('declares every font file it holds, and holds nothing else', () {
        final license = (lock!['license'] as Map<String, Object?>)['path'];
        final files = Directory(project)
            .listSync(recursive: true)
            .whereType<File>()
            .map((file) => file.path)
            .toSet();
        final fonts = files.where((path) => path.endsWith('.ttf')).toSet();

        expect(
          fonts,
          declared.keys.where((asset) => asset.startsWith('$project/')).toSet(),
        );
        expect(files.difference(fonts), {lockPath, license});
      });

      test('matches its lock byte for byte', () {
        final locked = (lock!['fonts'] as List<Object?>)
            .cast<Map<String, Object?>>();
        expect(
          {for (final font in locked) font['path'] as String},
          declared.keys.where((asset) => asset.startsWith('$project/')).toSet(),
          reason: 'the lock must cover exactly the declared fonts',
        );
        for (final font in locked) {
          final path = font['path'] as String;
          expect(_sha256(path), font['sha256'], reason: '$path drifted');
          expect(
            (family: font['family'], weight: font['weight']),
            declared[path],
            reason: '$path family or weight differs from the pubspec',
          );
        }
        final license = lock['license'] as Map<String, Object?>;
        expect(
          _sha256(license['path'] as String),
          license['sha256'],
          reason: 'the license text drifted',
        );
      });
    });
  }

  test('RemixFonts names exactly the families declared in pubspec', () {
    final prefix = 'packages/${pubspec['name']}/';

    expect(RemixFonts.geist, '${prefix}Geist');
    expect(RemixFonts.geistMono, '${prefix}GeistMono');
    // Add each new family's constant here.
    expect({
      RemixFonts.geist,
      RemixFonts.geistMono,
    }, declared.values.map((font) => '$prefix${font.family}').toSet());
  });
}
