import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/installer.dart';
import 'package:test/test.dart';

import 'checkout_registry.dart';
import 'test_support.dart';

const _barrel = 'lib/ui/ui.dart';
const _receipt = 'remix.ownership.json';
const _oldExport = "export 'components/textfield.dart';";
const _oldField = 'lib/ui/components/textfield.dart';
const _oldAdapter = 'lib/ui/components/textfield.g.dart';
const _themeExports = [
  'theme/effects.dart',
  'theme/theme_data.dart',
  'theme/theme_scope.dart',
  'theme/tokens.dart',
];
const _oldOwner = 'btwld/remix/registry#vanilla/textfield';
const _themeOwner = 'btwld/remix/registry#vanilla/theme';

void main() {
  late Directory root;

  setUp(() {
    root = createFlutterPackage();
    addTearDown(() => root.deleteSync(recursive: true));
  });

  test(
    'a partially adopted install cannot add a second managed export',
    () async {
      final processes = RecordingProcessRunner(
        (_) async => successProcessOutput,
      );
      final installer = Installer(
        projectRoot: root,
        sources: const FixtureOfficialResolver(),
        processRunner: processes,
        writeOut: (_) {},
      );
      await _seedOldVanilla(root, installer, recordTextField: false);
      for (final path in _themeExports) {
        _file(root, 'lib/ui/$path').createSync(recursive: true);
      }
      final before = snapshotFiles(root);

      for (final flags in [
        ['--dry-run'],
        ['--diff', '--exit-code'],
        ['--overwrite'],
        ['--adopt'],
        <String>[],
      ]) {
        final (exitCode, error) = await _run(installer, [
          'add',
          'search_field',
          ...flags,
        ]);
        expect(exitCode, 1, reason: '$flags: $error');
        expect(
          error,
          contains('@remix/textfield was renamed to @remix/text_field'),
        );
        expect(error, contains('components/textfield.dart'));
        expect(error, contains(_barrel));
        expect(error, contains('REGISTRY_511_MIGRATION.md'));
      }
      expect(await _run(installer, ['add', 'link', '--dry-run']), (0, ''));
      expect(processes.calls, isEmpty);
      expect(snapshotFiles(root), before);
    },
  );

  test('a case-only receipt match must refer to the exported file', () async {
    final installer = Installer(
      projectRoot: root,
      sources: const FixtureOfficialResolver(),
      writeOut: (_) {},
    );
    expect(await _run(installer, ['init']), (0, ''));
    _file(root, _oldField)
      ..createSync(recursive: true)
      ..writeAsStringSync('class UiTextField {}\n');
    const recordedTarget = 'lib/ui/components/TextField.dart';
    final recordedFile = _file(root, recordedTarget);
    final sameFile = recordedFile.existsSync();
    if (!sameFile) {
      recordedFile.writeAsStringSync('const companyLegacyWidget = 42;\n');
    }
    final barrel = _file(root, _barrel);
    barrel.writeAsStringSync(
      updateManagedBarrel(barrel.readAsStringSync(), [
        'components/textfield.dart',
      ]),
    );
    _writeOwnership(
      root,
      preset: 'vanilla',
      uiPath: 'lib/ui',
      targets: {
        recordedTarget: 'example/company/registry#vanilla/legacy_widget',
      },
    );
    final before = snapshotFiles(root);

    final (exitCode, error) = await _run(installer, [
      'add',
      'search_field',
      '--dry-run',
    ]);
    expect(exitCode, sameFile ? 0 : 1, reason: error);
    if (!sameFile)
      expect(error, contains('still exports components/textfield.dart'));
    expect(snapshotFiles(root), before);
  });

  for (final (preset, oldItem, newItem) in [
    ('vanilla', 'textfield', 'text_field'),
    ('fortal', 'textfield', 'text_field'),
    ('heroui', 'textfield', 'text_field'),
    ('heroui', 'textarea', 'text_area'),
  ]) {
    test('$preset permits a third-party export of $oldItem.dart', () async {
      final installer = Installer(
        projectRoot: root,
        sources: const FixtureOfficialResolver(),
        writeOut: (_) {},
      );
      expect(await _run(installer, ['init', '--preset', preset]), (0, ''));
      final legacyExport = 'components/$oldItem.dart';
      final legacyTarget = 'lib/ui/$legacyExport';
      _file(root, legacyTarget)
        ..createSync(recursive: true)
        ..writeAsStringSync('const companyLegacyWidget = 42;\n');
      final barrel = _file(root, _barrel);
      barrel.writeAsStringSync(
        updateManagedBarrel(barrel.readAsStringSync(), [legacyExport]),
      );
      _writeOwnership(
        root,
        preset: preset,
        uiPath: 'lib/ui',
        targets: {
          legacyTarget: 'example/company/registry#$preset/legacy_widget',
        },
      );
      final before = snapshotFiles(root);

      expect(await _run(installer, ['add', '@remix/$newItem', '--dry-run']), (
        0,
        '',
      ));
      expect(snapshotFiles(root), before);
    });
  }

  for (final (preset, oldItem, newItem) in [
    ('fortal', 'textfield', 'text_field'),
    ('heroui', 'textarea', 'text_area'),
  ]) {
    test('$preset rejects an obsolete adapter reservation', () async {
      final installer = Installer(
        projectRoot: root,
        sources: const FixtureOfficialResolver(),
        writeOut: (_) {},
      );
      expect(
        await _run(installer, [
          'init',
          '--preset',
          preset,
          '--ui-path',
          'lib/design',
        ]),
        (0, ''),
      );
      final adapter = 'lib/design/components/$oldItem.g.dart';
      _writeOwnership(
        root,
        preset: preset,
        uiPath: 'lib/design',
        targets: {adapter: 'btwld/remix/registry#$preset/$oldItem'},
      );
      final before = snapshotFiles(root);

      final (exitCode, error) = await _run(installer, [
        'add',
        newItem,
        '--dry-run',
      ]);
      expect(exitCode, 1, reason: error);
      expect(error, contains('@remix/$oldItem was renamed to @remix/$newItem'));
      expect(error, contains(adapter));
      expect(error, contains(_receipt));
      expect(snapshotFiles(root), before);
    });
  }

  test(
    'migrating simulated pre-rename source compiles with one text field export',
    () async {
      final installer = Installer(
        projectRoot: root,
        sources: const FixtureOfficialResolver(),
        writeOut: (_) {},
      );
      await _seedOldVanilla(root, installer, recordTextField: true);
      _file(root, 'pubspec.yaml').writeAsStringSync('''
dev_dependencies:
  flutter_test:
    sdk: flutter
''', mode: FileMode.append);
      final packages = p.join(findCheckoutRegistry().parent.path, 'packages');
      _file(root, 'pubspec_overrides.yaml').writeAsStringSync(
        [
          'dependency_overrides:',
          for (final name in ['remix', 'naked_ui', 'remix_ui_fonts'])
            '  $name:\n    path: ${jsonEncode(p.join(packages, name))}',
          '',
        ].join('\n'),
      );

      final customization = _file(root, _oldField).readAsLinesSync().last;
      _file(root, _oldField).deleteSync();
      _file(root, _oldAdapter).deleteSync();
      final barrel = _file(root, _barrel);
      barrel.writeAsStringSync(
        barrel.readAsStringSync().replaceFirst('$_oldExport\n', ''),
      );
      final receipt = _file(root, _receipt);
      final ownership =
          jsonDecode(receipt.readAsStringSync()) as Map<String, dynamic>;
      final targets = ownership['targets'] as Map<String, dynamic>;
      targets.remove(_oldField);
      targets.remove(_oldAdapter);
      receipt.writeAsStringSync(jsonEncode(ownership));

      expect(
        await _run(installer, ['add', 'text_field', 'search_field', '--diff']),
        (0, ''),
      );
      expect(await _run(installer, ['add', 'text_field', 'search_field']), (
        0,
        '',
      ));
      _file(
        root,
        'lib/ui/components/text_field.dart',
      ).writeAsStringSync('\n$customization\n', mode: FileMode.append);
      final exports = barrel.readAsLinesSync();
      expect(
        exports.where((line) => line == "export 'components/text_field.dart';"),
        hasLength(1),
      );
      expect(exports, isNot(contains(_oldExport)));
      final updatedOwnership =
          jsonDecode(receipt.readAsStringSync()) as Map<String, dynamic>;
      final updatedTargets =
          updatedOwnership['targets'] as Map<String, dynamic>;
      for (final path in _themeExports) {
        expect(updatedTargets, containsPair('lib/ui/$path', _themeOwner));
      }
      expect(
        updatedTargets,
        containsPair(
          'lib/ui/components/text_field.dart',
          'btwld/remix/registry#vanilla/text_field',
        ),
      );
      expect(
        updatedTargets,
        containsPair(
          'lib/ui/components/text_field.g.dart',
          'btwld/remix/registry#vanilla/text_field',
        ),
      );
      expect(updatedTargets, isNot(contains(_oldField)));
      expect(updatedTargets, isNot(contains(_oldAdapter)));

      _file(root, 'test/upgrade_test.dart')
        ..createSync(recursive: true)
        ..writeAsStringSync('''
import 'package:consumer/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the upgraded barrel retains the app customization', () {
    expect(const AcmeTextField(), isA<AcmeTextField>());
    expect(const AcmeSearchField(semanticLabel: 'Search').semanticLabel, 'Search');
    expect(customFieldHeight, 40);
    expect(appOnly, 42);
  });
}
''');
      final smoke = await Process.run(
        'flutter',
        ['test', '--no-pub'],
        workingDirectory: root.path,
        runInShell: Platform.isWindows,
      );
      expect(smoke.exitCode, 0, reason: '${smoke.stdout}\n${smoke.stderr}');
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}

Future<(int, String)> _run(Installer installer, List<String> arguments) async {
  final errors = <String>[];
  final exitCode = await runInstallerCli(
    arguments,
    installer,
    writeOut: (_) {},
    writeError: errors.add,
  );
  return (exitCode, errors.join('\n'));
}

File _file(Directory root, String path) => File(p.join(root.path, path));

Future<void> _seedOldVanilla(
  Directory root,
  Installer installer, {
  required bool recordTextField,
}) async {
  expect(await _run(installer, ['init', '--prefix', 'Acme']), (0, ''));
  _file(root, _oldField)
    ..createSync(recursive: true)
    ..writeAsStringSync(
      "part 'textfield.g.dart';\n\nconst customFieldHeight = 40;\n",
    );
  _file(root, _oldAdapter).writeAsStringSync(
    "part of 'textfield.dart';\n\nclass AcmeTextField { const AcmeTextField(); }\n",
  );
  _file(
    root,
    'lib/ui/app_only.dart',
  ).writeAsStringSync('const appOnly = 42;\n');
  _file(root, _barrel).writeAsStringSync('''
library;

$managedExportsStart
$_oldExport
${_themeExports.map((path) => "export '$path';").join('\n')}
$managedExportsEnd

export 'app_only.dart';
''');
  _writeOwnership(
    root,
    preset: 'vanilla',
    uiPath: 'lib/ui',
    prefix: 'Acme',
    targets: {
      for (final path in _themeExports) 'lib/ui/$path': _themeOwner,
      if (recordTextField) ...{_oldField: _oldOwner, _oldAdapter: _oldOwner},
    },
  );
}

void _writeOwnership(
  Directory root, {
  required String preset,
  required String uiPath,
  String prefix = 'Ui',
  required Map<String, String> targets,
}) {
  _file(root, _receipt).writeAsStringSync(
    jsonEncode({
      'schema': 1,
      'context': {'prefix': prefix, 'preset': preset, 'uiPath': uiPath},
      'targets': targets,
    }),
  );
}
