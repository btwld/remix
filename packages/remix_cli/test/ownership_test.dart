import 'dart:convert';
import 'dart:io';

import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:test/test.dart';

import 'installer_test.dart' show happyRunner;
import 'multi_registry_test.dart' show FixtureRegistries, item, parseConfig;
import 'test_support.dart';

void main() {
  late Directory root;
  late FixtureRegistries fixture;
  late RecordingProcessRunner runner;
  late RecordingFileWriter writer;
  late Installer installer;
  late List<String> output;
  setUp(() {
    root = createFlutterPackage();
    fixture = FixtureRegistries()..save(root);
    runner = happyRunner(root, runRealGit: true);
    writer = RecordingFileWriter(root);
    output = [];
    installer = Installer(
      projectRoot: root,
      writeOut: output.add,
      processRunner: runner,
      fileWriter: writer,
      sources: fixture.resolver,
    );
  });
  tearDown(() => root.deleteSync(recursive: true));

  Future<void> add(List<String> items, [AddMode mode = AddMode.write]) =>
      installer.add(AddOptions(items: items, mode: mode));
  Future<void> rejected(
    List<String> items,
    AddMode mode,
    String message,
  ) async {
    final before = snapshotFiles(root);
    runner.calls.clear();
    writer.paths.clear();
    await expectLater(
      add(items, mode),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains(message),
        ),
      ),
    );
    expect(snapshotFiles(root), before);
    expect(runner.calls, isEmpty);
    expect(writer.paths, isEmpty);
  }

  Future<int> adopt(List<String> items, [List<String> flags = const []]) =>
      runInstallerCli(
        ['add', ...items, '--adopt', ...flags],
        installer,
        writeOut: output.add,
        writeError: output.add,
      );

  test('combined same-target request rejects before mutation', () async {
    fixture.company['button'] = item('button');
    await rejected(['button', '@company/button'], AddMode.write, 'both target');
  });
  for (final mode in AddMode.values) {
    test(
      'sequential different-owner collision rejects in ${mode.name}',
      () async {
        fixture.company['button'] = item('button');
        await add(['button']);
        await rejected(['@company/button'], mode, 'owned by');
      },
    );
  }
  test(
    'different item in the same registry cannot overwrite an owner',
    () async {
      await add(['button']);
      fixture.official.remove('button');
      fixture.official['replacement'] = item('button');
      await rejected(['replacement'], AddMode.overwrite, 'owned by');
    },
  );
  test(
    'generated output reservation rejects authored and generated collisions even when missing',
    () async {
      fixture.official['button'] = {
        ...item('button', ['theme']),
        'generated': ['@ui/button.g.dart'],
      };
      await add(['button']);
      File('${root.path}/lib/ui/button.g.dart').deleteSync();
      fixture.company['button'] = {
        'files': [
          {
            'source': 'templates/company.dart.tmpl',
            'target': '@ui/button.g.dart',
          },
        ],
      };
      await rejected(['@company/button'], AddMode.write, 'owned by');
      fixture.company['button'] = {
        ...item('company'),
        'generated': ['@ui/button.g.dart'],
      };
      await rejected(['@company/button'], AddMode.overwrite, 'owned by');
    },
  );
  test('combined generated collision rejects before mutation', () async {
    fixture.company['button'] = {
      ...item('company'),
      'generated': ['@ui/button.dart'],
    };
    await rejected(['button', '@company/button'], AddMode.write, 'both target');
  });
  test(
    'same-owner reinstall preserves edits; revision update and explicit overwrite work',
    () async {
      await add(['@company/button']);
      final source = File('${root.path}/lib/ui/company.dart');
      source.writeAsStringSync('// customized recipe\n');
      final ownership = File(
        '${root.path}/remix.ownership.json',
      ).readAsStringSync();
      await add(['@company/button']);
      expect(source.readAsStringSync(), '// customized recipe\n');
      await installer.registry(
        const RegistryOptions(
          action: RegistryAction.update,
          namespace: '@company',
          ref: 'v2',
        ),
      );
      await add(['@company/button'], AddMode.overwrite);
      expect(source.readAsStringSync(), contains('revision two'));
      expect(
        File('${root.path}/remix.ownership.json').readAsStringSync(),
        ownership,
      );
    },
  );
  test(
    'disjoint sequential registries preserve customized dependencies and pubspec',
    () async {
      await add(['button']);
      final theme = File('${root.path}/lib/ui/theme.dart')
        ..writeAsStringSync('// custom theme\n');
      final button = File('${root.path}/lib/ui/button.dart')
        ..writeAsStringSync('// custom button\n');
      final pubspec = File('${root.path}/pubspec.yaml');
      pubspec.writeAsStringSync(
        '${pubspec.readAsStringSync()}# custom constraints\n',
      );
      final pubspecBefore = pubspec.readAsStringSync();
      fixture.company['button'] = item('company', ['@remix/button']);
      await add(['@company/button']);
      await add(['@company/button'], AddMode.overwrite);
      expect(theme.readAsStringSync(), '// custom theme\n');
      expect(button.readAsStringSync(), '// custom button\n');
      expect(pubspec.readAsStringSync(), pubspecBefore);
      final targets =
          jsonDecode(
                File('${root.path}/remix.ownership.json').readAsStringSync(),
              )['targets']
              as Map;
      expect(
        targets.keys,
        containsAll([
          'lib/ui/company.dart',
          'lib/ui/button.dart',
          'lib/ui/theme.dart',
        ]),
      );
    },
  );
  test(
    'disjoint dry-run and diff propose ownership without writing it',
    () async {
      await add(['button']);
      final before = snapshotFiles(root);
      for (final mode in [AddMode.dryRun, AddMode.diff]) {
        await add(['@company/button'], mode);
        expect(snapshotFiles(root), before);
      }
      expect(output.join('\n'), contains('remix.ownership.json'));
    },
  );
  for (final mode in AddMode.values) {
    test('legacy unknown files reject in ${mode.name}', () async {
      File(
        '${root.path}/lib/ui/company.dart',
      ).writeAsStringSync('// owned locally\n');
      await rejected(['@company/button'], mode, 'unknown registry ownership');
    });
  }
  test(
    'legacy adoption is explicit, previewable and preserves edits',
    () async {
      File(
        '${root.path}/lib/ui/company.dart',
      ).writeAsStringSync('// legacy edits\n');
      final before = snapshotFiles(root);
      for (final mode in ['--dry-run', '--diff']) {
        expect(await adopt(['@company/button'], [mode]), successExitCode);
        expect(snapshotFiles(root), before);
      }
      expect(await adopt(['@company/button']), successExitCode);
      expect(
        File('${root.path}/lib/ui/company.dart').readAsStringSync(),
        '// legacy edits\n',
      );
      await add(['@company/button']);
      fixture.official['replacement'] = item('company');
      await rejected(['replacement'], AddMode.overwrite, 'owned by');
    },
  );
  test('legacy dependencies must be explicitly named for adoption', () async {
    File(
      '${root.path}/lib/ui/theme.dart',
    ).writeAsStringSync('// edited theme\n');
    File(
      '${root.path}/lib/ui/button.dart',
    ).writeAsStringSync('// edited button\n');
    final before = snapshotFiles(root);
    expect(await adopt(['button']), failureExitCode);
    expect(snapshotFiles(root), before);
    expect(await adopt(['theme', 'button']), successExitCode);
    expect(
      File('${root.path}/lib/ui/theme.dart').readAsStringSync(),
      '// edited theme\n',
    );
  });
  test('adopt cannot override a known different owner', () async {
    await add(['button']);
    fixture.company['button'] = item('button');
    final before = snapshotFiles(root);
    runner.calls.clear();
    expect(await adopt(['@company/button']), failureExitCode);
    expect(snapshotFiles(root), before);
    expect(runner.calls, isEmpty);
    expect(await adopt(['@company/button'], ['--overwrite']), usageExitCode);
  });
  test(
    'a missing legacy record still permits disjoint additions without claiming old files',
    () async {
      File(
        '${root.path}/lib/ui/button.dart',
      ).writeAsStringSync('// unknown button\n');
      await add(['@company/button']);
      await rejected(
        ['button'],
        AddMode.overwrite,
        'unknown registry ownership',
      );
    },
  );
  test(
    'namespace aliases and ref changes retain identity; repository changes do not',
    () async {
      await add(['@company/button']);
      final config = parseConfig(null, root);
      final source = config.registries['@company']!;
      File('${root.path}/remix.yaml').writeAsStringSync(
        config
            .copyWith(registries: {...config.registries, '@alias': source})
            .encode(),
      );
      await add(['@alias/button'], AddMode.overwrite);
      File('${root.path}/remix.yaml').writeAsStringSync(
        config
            .copyWith(
              registries: {
                ...config.registries,
                '@company': RegistrySource(
                  repository: 'other/company',
                  path: source.path,
                  ref: source.ref,
                  revision: source.revision,
                ),
              },
            )
            .encode(),
      );
      await rejected(['@company/button'], AddMode.overwrite, 'owned by');
    },
  );
  test('registry path changes retain distinct ownership', () async {
    await add(['@company/button']);
    final config = parseConfig(null, root);
    final source = config.registries['@company']!;
    File('${root.path}/remix.yaml').writeAsStringSync(
      config
          .copyWith(
            registries: {
              ...config.registries,
              '@company': RegistrySource(
                repository: source.repository,
                path: 'different/registry',
                ref: source.ref,
                revision: source.revision,
              ),
            },
          )
          .encode(),
    );
    await rejected(['@company/button'], AddMode.overwrite, 'owned by');
  });
  test('deleted authored files retain reservations', () async {
    await add(['@company/button']);
    File('${root.path}/lib/ui/company.dart').deleteSync();
    fixture.official['replacement'] = item('company');
    await rejected(['replacement'], AddMode.write, 'owned by');
    await add(['@company/button']);
  });
  test(
    'partial source failure retains ownership before the first source write',
    () async {
      final failing = Installer(
        projectRoot: root,
        writeOut: (_) {},
        sources: fixture.resolver,
        processRunner: happyRunner(root, failStage: 'analyze'),
      );
      await expectLater(
        failing.add(const AddOptions(items: ['button'], mode: AddMode.write)),
        throwsStateError,
      );
      fixture.company['button'] = item('button');
      await rejected(['@company/button'], AddMode.overwrite, 'owned by');
    },
  );
  test(
    'malformed ownership and changed project context reject before processes',
    () async {
      await add(['@company/button']);
      final record = File('${root.path}/remix.ownership.json');
      final valid = record.readAsStringSync();
      record.writeAsStringSync('{"schema":999}');
      await rejected(['@company/button'], AddMode.write, 'malformed');
      record.writeAsStringSync(valid);
      final config = File('${root.path}/remix.yaml');
      config.writeAsStringSync(
        config.readAsStringSync().replaceFirst('prefix: Ui', 'prefix: Acme'),
      );
      await rejected(['@company/button'], AddMode.write, 'does not match');
    },
  );
  test('internal symlink alias cannot bypass ownership', () async {
    if (Platform.isWindows) return; // Windows link privileges vary by host.
    await add(['button']);
    Link(
      '${root.path}/lib/ui/alias.dart',
    ).createSync('${root.path}/lib/ui/button.dart');
    fixture.company['button'] = item('alias');
    await rejected(['@company/button'], AddMode.overwrite, 'owned by');
  });
  test('a missing reservation still prevents nested target takeover', () async {
    await add(['@company/button']);
    File('${root.path}/lib/ui/company.dart').deleteSync();
    fixture.official['replacement'] = {
      'files': [
        {
          'source': 'templates/nested.dart.tmpl',
          'target': '@ui/company.dart/nested.dart',
        },
      ],
    };
    await rejected(['replacement'], AddMode.write, 'overlaps reserved target');
  });
  test(
    'case-only target differences cannot bypass portable ownership',
    () async {
      await add(['button']);
      fixture.company['button'] = item('Button');
      await rejected(['@company/button'], AddMode.overwrite, 'owned by');
      final before = snapshotFiles(root);
      runner.calls.clear();
      expect(await adopt(['@company/button']), failureExitCode);
      expect(snapshotFiles(root), before);
      expect(runner.calls, isEmpty);
    },
  );
  test('managed barrel aliases cannot be adopted', () async {
    if (Platform.isWindows) return;
    Link(
      '${root.path}/lib/ui/barrel.dart',
    ).createSync('${root.path}/lib/ui/ui.dart');
    fixture.company['button'] = item('barrel');
    final before = snapshotFiles(root);
    runner.calls.clear();
    expect(await adopt(['@company/button']), failureExitCode);
    expect(snapshotFiles(root), before);
    expect(runner.calls, isEmpty);
  });
  test(
    'old schema configuration continues to require reinitialization',
    () async {
      File(
        '${root.path}/remix.yaml',
      ).writeAsStringSync('schema: 2\nprefix: Ui\n');
      await rejected(
        ['button'],
        AddMode.write,
        'Unsupported remix.yaml schema',
      );
    },
  );
}
