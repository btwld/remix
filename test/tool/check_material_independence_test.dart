import 'dart:io';

import 'package:test/test.dart';

const _packages = [
  'packages/naked_ui',
  'packages/remix',
  'packages/remix_ui_icons',
  'packages/remix_ui_fonts',
  'registry_source',
];

void main() {
  final checker = File('tool/check_material_independence.dart').absolute.path;
  late Directory sandbox;

  File source(String package) =>
      File('${sandbox.path}/$package/lib/source.dart');
  File manifest(String package) =>
      File('${sandbox.path}/$package/pubspec.yaml');
  ProcessResult check() => Process.runSync(Platform.resolvedExecutable, [
    checker,
  ], workingDirectory: sandbox.path);

  setUp(() {
    sandbox = Directory.systemTemp.createTempSync('remix_material_boundary_');
    for (final package in _packages) {
      source(package).parent.createSync(recursive: true);
      source(
        package,
      ).writeAsStringSync("import 'package:flutter/widgets.dart';\n");
      manifest(package).writeAsStringSync('name: fixture\n');
    }
  });

  tearDown(() => sandbox.deleteSync(recursive: true));

  test('accepts widget primitives and custom fonts', () {
    manifest('packages/remix_ui_icons').writeAsStringSync('''
name: fixture
flutter:
  fonts:
    - family: RemixIcons
      fonts:
        - asset: icons.otf
''');
    final result = check();
    expect(result.exitCode, 0, reason: '${result.stderr}');
  });

  for (final package in _packages) {
    test('rejects direct Material imports in $package', () {
      source(
        package,
      ).writeAsStringSync("import 'package:flutter/material.dart';\n");
      final result = check();
      expect(result.exitCode, 1);
      expect(result.stderr, contains('$package/lib/source.dart:1'));
    });
  }

  for (final (label, directive, line) in [
    ('export', "export 'package:flutter/material.dart';", 1),
    (
      'private Material library',
      "import 'package:flutter/src/material/theme.dart';",
      1,
    ),
    (
      'material_ui library',
      "import 'package:material_ui/material_ui.dart';",
      1,
    ),
    (
      'conditional import',
      "import 'package:flutter/widgets.dart'\n"
          "  if (dart.library.html) 'package:flutter/material.dart';",
      2,
    ),
    (
      'conditional export',
      "export 'package:flutter/widgets.dart'\n"
          "  if (dart.library.html) 'package:flutter/material.dart';",
      2,
    ),
  ]) {
    test('rejects $label with the offending URI line', () {
      source('packages/naked_ui').writeAsStringSync('$directive\n');
      final result = check();
      expect(result.exitCode, 1);
      expect(
        result.stderr,
        contains('packages/naked_ui/lib/source.dart:$line'),
      );
    });
  }

  test('rejects the Material icon-font flag and material_ui dependency', () {
    manifest('packages/naked_ui').writeAsStringSync('''
name: fixture
dependencies:
  material_ui: ^1.0.0
flutter:
  uses-material-design: true
''');
    final result = check();
    expect(result.exitCode, 1);
    expect(result.stderr, contains('declares material_ui'));
    expect(result.stderr, contains('declares uses-material-design'));
  });

  test('fails closed when a protected package is missing', () {
    manifest('registry_source').deleteSync();
    final result = check();
    expect(result.exitCode, 1);
    expect(result.stderr, contains('registry_source is missing'));
  });
}
