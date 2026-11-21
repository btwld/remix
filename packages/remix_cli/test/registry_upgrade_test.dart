import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/registry.dart';
import 'package:remix_cli/src/registry_reader.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:test/test.dart';

import 'checkout_registry.dart';
import 'test_support.dart';

const _oldRevision = 'c6c9f172d2219271925df2b3dc535d7eccf4facb';
const _newRevision = '6667e18693b7c3f40e390183e78c9dfce2aba07d';
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
const _themeOwner = 'btwld/remix/registry#vanilla/theme';

void main() {
  late Directory root;

  setUp(() {
    root = createFlutterPackage();
    addTearDown(() => root.deleteSync(recursive: true));
  });

  test(
    'a partially adopted install cannot add a second export alongside components/textfield.dart',
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
      await _seedOldVanilla(root, installer);
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
        expect(error, contains('still exports components/textfield.dart'));
        expect(error, contains(_barrel));
        expect(error, contains('REGISTRY_511_MIGRATION.md'));
      }
      expect(await _run(installer, ['add', 'link', '--dry-run']), (0, ''));
      expect(processes.calls, isEmpty);
      expect(snapshotFiles(root), before);
    },
  );

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
    'an old pin can migrate an edited text field and compile',
    () async {
      File projectFile(String path) => File(p.join(root.path, path));

      final sources = _CutoverSources(findCheckoutRegistry());
      final errors = <String>[];
      final installer = Installer(
        projectRoot: root,
        writeOut: (_) {},
        sources: sources,
      );
      Future<int> run(List<String> args, {Installer? using}) {
        errors.clear();
        return runInstallerCli(
          args,
          using ?? installer,
          writeOut: (_) {},
          writeError: errors.add,
        );
      }

      projectFile('pubspec.yaml').writeAsStringSync('''
dev_dependencies:
  flutter_test:
    sdk: flutter
''', mode: FileMode.append);
      final packages = p.join(sources.distribution.parent.path, 'packages');
      projectFile('pubspec_overrides.yaml').writeAsStringSync(
        [
          'dependency_overrides:',
          for (final name in ['remix', 'naked_ui', 'remix_ui_fonts'])
            '  $name:\n    path: ${jsonEncode(p.join(packages, name))}',
          '',
        ].join('\n'),
      );
      expect(await run(['init', '--prefix', 'Acme']), 0, reason: '$errors');
      expect(await run(['add', 'search_field']), 0, reason: '$errors');

      const oldField = 'lib/ui/components/textfield.dart';
      const oldAdapter = 'lib/ui/components/textfield.g.dart';
      const oldExport = "export 'components/textfield.dart';";
      const newExport = "export 'components/text_field.dart';";
      const originalHeight = '.minHeight(AcmeTokens.controlMd)';
      const editedHeight = '.minHeight(AcmeTokens.controlLg)';
      final original = projectFile(oldField).readAsStringSync();
      expect(original, contains(originalHeight));
      projectFile(
        oldField,
      ).writeAsStringSync(original.replaceFirst(originalHeight, editedHeight));
      final barrel = projectFile('lib/ui/ui.dart');
      expect(barrel.readAsStringSync(), contains(oldExport));
      projectFile(
        'lib/ui/app_only.dart',
      ).writeAsStringSync('const appOnly = 42;\n');
      barrel.writeAsStringSync(
        "\nexport 'app_only.dart';\n",
        mode: FileMode.append,
      );

      expect(
        projectFile('remix.yaml').readAsStringSync(),
        contains(_oldRevision),
      );
      expect(
        await run(['registry', 'update', '@remix', '--ref', _newRevision]),
        0,
        reason: '$errors',
      );
      expect(
        projectFile('remix.yaml').readAsStringSync(),
        contains(_newRevision),
      );

      final processes = RecordingProcessRunner(
        (_) async => successProcessOutput,
      );
      final preflight = Installer(
        projectRoot: root,
        writeOut: (_) {},
        sources: sources,
        processRunner: processes,
      );
      final before = snapshotFiles(root);
      for (final flags in [
        ['--dry-run'],
        ['--diff', '--exit-code'],
        ['--overwrite'],
        ['--adopt'],
        <String>[],
      ]) {
        expect(
          await run(['add', 'search_field', ...flags], using: preflight),
          1,
          reason: '$flags: $errors',
        );
        final message = errors.join('\n');
        expect(message, contains('@remix/textfield'));
        expect(message, contains('@remix/text_field'));
        expect(message, contains('remix.ownership.json'));
        expect(message, contains('REGISTRY_511_MIGRATION.md'));
      }
      expect(processes.calls, isEmpty);
      expect(snapshotFiles(root), before);
      expect(await run(['add', 'link', '--dry-run'], using: preflight), 0);

      final customizedField = projectFile(oldField).readAsStringSync();
      projectFile(oldField).deleteSync();
      projectFile(oldAdapter).deleteSync();
      barrel.writeAsStringSync(
        barrel.readAsStringSync().replaceFirst('$oldExport\n', ''),
      );
      final receipt = projectFile('remix.ownership.json');
      final ownership =
          jsonDecode(receipt.readAsStringSync()) as Map<String, dynamic>;
      final targets = ownership['targets'] as Map<String, dynamic>;
      expect(targets.remove(oldField), endsWith('/textfield'));
      expect(targets.remove(oldAdapter), endsWith('/textfield'));
      final untouchedTargets = Map.of(targets);
      receipt.writeAsStringSync(jsonEncode(ownership));
      final searchField = projectFile('lib/ui/components/search_field.dart');
      searchField.writeAsStringSync(
        searchField.readAsStringSync().replaceFirst(
          "'textfield.dart'",
          "'text_field.dart'",
        ),
      );

      expect(await run(['add', 'text_field', '--diff']), 0, reason: '$errors');
      expect(await run(['add', 'text_field']), 0, reason: '$errors');
      final newField = projectFile('lib/ui/components/text_field.dart');
      final updated = newField.readAsStringSync();
      expect(customizedField, contains(editedHeight));
      expect(updated, contains(originalHeight));
      newField.writeAsStringSync(
        updated.replaceFirst(originalHeight, editedHeight),
      );
      expect(newField.readAsStringSync(), contains(editedHeight));
      final exports = barrel.readAsLinesSync();
      expect(exports.where((line) => line == newExport), hasLength(1));
      expect(exports, isNot(contains(oldExport)));
      expect(exports, contains("export 'app_only.dart';"));
      final updatedOwnership =
          jsonDecode(receipt.readAsStringSync()) as Map<String, dynamic>;
      final updatedTargets =
          updatedOwnership['targets'] as Map<String, dynamic>;
      expect(
        updatedTargets,
        containsPair(
          'lib/ui/components/text_field.g.dart',
          endsWith('/text_field'),
        ),
      );
      expect(updatedTargets, isNot(contains(oldField)));
      expect(updatedTargets, isNot(contains(oldAdapter)));
      for (final MapEntry(:key, :value) in untouchedTargets.entries) {
        expect(updatedTargets, containsPair(key, value));
      }

      projectFile('test/upgrade_test.dart')
        ..createSync(recursive: true)
        ..writeAsStringSync('''
import 'package:consumer/ui/ui.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('the upgraded barrel exposes the field', () {
    expect(const AcmeTextField(), isA<AcmeTextField>());
    expect(const AcmeSearchField(semanticLabel: 'Search').semanticLabel, 'Search');
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
    timeout: const Timeout(Duration(minutes: 8)),
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

Future<void> _seedOldVanilla(Directory root, Installer installer) async {
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
    targets: {for (final path in _themeExports) 'lib/ui/$path': _themeOwner},
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

final class _CutoverSources implements RegistrySources {
  _CutoverSources(this.distribution);

  final Directory distribution;

  @override
  Future<RegistrySource> latestOfficial() =>
      resolve(repository: officialRepository, ref: _oldRevision);

  @override
  Future<RegistrySource> resolve({
    required String repository,
    String path = 'registry',
    String? ref,
  }) async => RegistrySource(
    repository: repository,
    path: path,
    ref: ref!,
    revision: ref,
  );

  @override
  RegistryReader open(RegistrySource pin, String preset) =>
      pin.revision == _oldRevision
      ? _BeforeCutover(distribution)
      : CheckoutRegistry(distribution, preset);

  @override
  Future<String?> file(RegistrySource pin, String path) =>
      readCheckoutFile(distribution, path);
}

final class _BeforeCutover implements RegistryReader {
  _BeforeCutover(this.distribution)
    : checkout = CheckoutRegistry(distribution, 'vanilla');

  final Directory distribution;
  final CheckoutRegistry checkout;

  @override
  Future<RegistryCatalog> catalog() async => RegistryCatalog.parse(
    (await File(
      p.join(distribution.path, 'vanilla', 'registry.yaml'),
    ).readAsString()).replaceAll('text_field', 'textfield'),
    preset: 'vanilla',
  );

  @override
  Future<String> template(RegistryFile file) async =>
      (await checkout.template(
            RegistryFile(
              source: file.source.replaceAll('textfield', 'text_field'),
              target: file.target,
            ),
          ))
          .replaceAll('text_field.dart', 'textfield.dart')
          .replaceAll('text_field.g.dart', 'textfield.g.dart');

  @override
  Future<String> icons() => checkout.icons();
}
