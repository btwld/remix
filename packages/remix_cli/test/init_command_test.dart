import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/project_config.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  late Directory root;
  late List<String> output;
  late Installer installer;

  setUp(() {
    root = createFlutterPackage();
    output = <String>[];
    installer = Installer(
      projectRoot: root,
      writeOut: output.add,
      sources: const FixtureOfficialResolver(),
    );
  });
  tearDown(() => root.deleteSync(recursive: true));

  // The omitted `--preset` is the path most consumers take, so these drive the
  // installer through the command line rather than calling it directly.
  test('init without --preset selects vanilla for a new project', () async {
    expect(
      await runRemixCli(
        ['init'],
        writeOut: output.add,
        writeError: fail,
        onInit: installer.initialize,
      ),
      successExitCode,
    );
    expect(
      ProjectConfig.parse(
        File(p.join(root.path, 'remix.yaml')).readAsStringSync(),
        packageRoot: root,
      ).preset,
      'vanilla',
    );
  });

  test('Fortal keeps the official default registry', () async {
    await installer.initialize(
      const InitOptions(prefix: 'Ui', preset: 'fortal', uiPath: 'lib/ui'),
    );
    final config = ProjectConfig.parse(
      File(p.join(root.path, 'remix.yaml')).readAsStringSync(),
      packageRoot: root,
    );
    expect(config.defaultRegistry, '@remix');
    expect(config.registries['@remix']!.repository, officialRepository);
    expect(config.registries['@remix']!.ref, officialStableRef);
  });

  for (final schema in [1, 2]) {
    test(
      'init refuses a prerelease schema $schema project untouched',
      () async {
        File(p.join(root.path, 'remix.yaml')).writeAsStringSync(
          'schema: $schema\nprefix: Ui\n'
          '${schema == 2 ? 'preset: vanilla\n' : ''}'
          'paths:\n  ui: lib/ui\n',
        );
        File(p.join(root.path, 'lib/ui/ui.dart'))
          ..createSync(recursive: true)
          ..writeAsStringSync(emptyManagedBarrel);
        final before = snapshotFiles(root);
        final errors = <String>[];
        expect(
          await runRemixCli(
            ['init'],
            writeOut: output.add,
            writeError: errors.add,
            onInit: installer.initialize,
          ),
          failureExitCode,
        );
        // Reinitializing is the only way forward, and it is destructive enough
        // that the CLI must not choose it on the project's behalf.
        expect(errors.single, contains('remix init'));
        expect(snapshotFiles(root), before);
      },
    );
  }

  test('schema 3 requires exact preset identity', () async {
    final source = await const FixtureOfficialResolver().latestOfficial();
    final config = ProjectConfig(
      packageRoot: root,
      prefix: 'Ui',
      preset: 'fortal',
      uiPath: 'lib/ui',
      defaultRegistry: '@remix',
      registries: {'@remix': source},
    );
    File(p.join(root.path, 'remix.yaml')).writeAsStringSync(config.encode());
    File(p.join(root.path, 'lib/ui/ui.dart'))
      ..createSync(recursive: true)
      ..writeAsStringSync(emptyManagedBarrel);
    final before = snapshotFiles(root);
    await expectLater(
      installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      ),
      throwsFormatException,
    );
    expect(snapshotFiles(root), before);
  });

  test('schema 3 custom registries require exact preset identity', () async {
    // Third-party registries name their own presets, so `default` and
    // `vanilla` are two unrelated names here rather than a legacy rename.
    final custom = RegistrySource(
      repository: 'owner/company',
      path: 'registry',
      ref: 'v1',
      revision: 'b' * 40,
    );
    final offline = Installer(
      projectRoot: root,
      writeOut: output.add,
      sources: GitHubSources(
        transport: (_) async {
          fail('existing init contacted GitHub');
        },
      ),
    );
    for (final (configured, requested, matches) in [
      ('acme_light', 'vanilla', false),
      ('vanilla', 'acme_light', false),
      ('acme_dark', 'acme_dark', true),
    ]) {
      File(p.join(root.path, 'remix.yaml')).writeAsStringSync(
        ProjectConfig(
          packageRoot: root,
          prefix: 'Ui',
          preset: configured,
          uiPath: 'lib/ui',
          defaultRegistry: '@company',
          registries: {'@company': custom},
        ).encode(),
      );
      File(p.join(root.path, 'lib/ui/ui.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync(emptyManagedBarrel);
      final before = snapshotFiles(root);
      final reason = '$configured accepted $requested';
      final run = offline.initialize(
        InitOptions(prefix: 'Ui', preset: requested, uiPath: 'lib/ui'),
      );
      if (matches) {
        await run;
        expect(output.last, 'Remix is already initialized.', reason: reason);
      } else {
        await expectLater(run, throwsFormatException, reason: reason);
      }
      expect(snapshotFiles(root), before, reason: reason);
    }
  });

  test('initializes defaults and an identical second run is a no-op', () async {
    await installer.initialize(
      const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
    );
    expect(
      File(p.join(root.path, 'remix.yaml')).readAsStringSync(),
      '''schema: 3
prefix: Ui
preset: vanilla
paths:
  ui: lib/ui
defaultRegistry: "@remix"
registries:
  "@remix":
    repository: "conceptadev/remix"
    path: "registry"
    ref: "registry-stable"
    revision: "${'a' * 40}"
''',
    );
    expect(
      File(p.join(root.path, 'lib', 'ui', 'ui.dart')).readAsStringSync(),
      emptyManagedBarrel,
    );
    expect(output.single, 'Initialized remix.yaml and lib/ui/ui.dart.');
    final first = snapshotFiles(root);

    await installer.initialize(
      const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
    );

    expect(snapshotFiles(root), first);
    expect(output.last, 'Remix is already initialized.');
  });

  test(
    'repairs only a missing config and names the barrel preserved',
    () async {
      await installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      );
      File(p.join(root.path, 'remix.yaml')).deleteSync();
      output.clear();

      await installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      );

      expect(output, ['Created remix.yaml; preserved lib/ui/ui.dart.']);
    },
  );

  test(
    'repairs only a missing barrel and names the config preserved',
    () async {
      await installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      );
      File(p.join(root.path, 'lib', 'ui', 'ui.dart')).deleteSync();
      output.clear();

      await installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      );

      expect(output, ['Created lib/ui/ui.dart; preserved remix.yaml.']);
    },
  );

  test('initializes a custom prefix and path', () async {
    await installer.initialize(
      const InitOptions(
        prefix: 'Acme',
        preset: 'vanilla',
        uiPath: 'lib/design_system',
      ),
    );

    expect(
      File(p.join(root.path, 'remix.yaml')).readAsStringSync(),
      contains('prefix: Acme'),
    );
    expect(
      File(p.join(root.path, 'lib', 'design_system', 'ui.dart')).existsSync(),
      isTrue,
    );
  });

  test('custom init pins Carbon as the only default registry', () async {
    final requests = <Uri>[];
    final custom = Installer(
      projectRoot: root,
      writeOut: output.add,
      sources: _customSources(requests: requests),
    );

    final code = await runRemixCli(
      [
        'init',
        '--prefix',
        'Acme',
        '--preset',
        'carbon',
        '--registry',
        '@carbon',
        '--repository',
        'example/carbon-registry',
        '--ref',
        'stable',
      ],
      writeOut: output.add,
      writeError: fail,
      onInit: custom.initialize,
    );

    expect(code, successExitCode);
    final config = ProjectConfig.parse(
      File(p.join(root.path, 'remix.yaml')).readAsStringSync(),
      packageRoot: root,
    );
    expect(config.preset, 'carbon');
    expect(config.prefix, 'Acme');
    expect(config.defaultRegistry, '@carbon');
    expect(config.registries.keys, ['@carbon']);
    expect(config.registries['@carbon']!.repository, 'example/carbon-registry');
    expect(config.registries['@carbon']!.ref, 'stable');
    expect(config.registries['@carbon']!.revision, 'c' * 40);
    expect(requests.map((uri) => uri.host), contains('api.github.com'));
    expect(
      requests.where((uri) => uri.host == 'raw.githubusercontent.com'),
      everyElement(predicate<Uri>((uri) => uri.path.contains('c' * 40))),
    );
  });

  test(
    'an explicit source can introduce a preset unknown to the CLI',
    () async {
      final custom = Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: _customSources(preset: 'acme'),
      );

      expect(
        await runRemixCli(
          [
            'init',
            '--preset',
            'acme',
            '--registry',
            '@acme',
            '--repository',
            'example/carbon-registry',
            '--ref',
            'stable',
          ],
          writeOut: output.add,
          writeError: fail,
          onInit: custom.initialize,
        ),
        successExitCode,
      );
      final config = ProjectConfig.parse(
        File(p.join(root.path, 'remix.yaml')).readAsStringSync(),
        packageRoot: root,
      );
      expect(config.preset, 'acme');
      expect(config.defaultRegistry, '@acme');
      expect(config.registries.keys, ['@acme']);
      expect(config.registries['@acme']!.revision, 'c' * 40);
    },
  );

  test('an explicit source overrides the known Vanilla default', () async {
    final custom = Installer(
      projectRoot: root,
      writeOut: output.add,
      sources: _customSources(preset: 'vanilla'),
    );

    await custom.initialize(
      const InitOptions(
        prefix: 'Ui',
        preset: 'vanilla',
        uiPath: 'lib/ui',
        registry: '@acme',
        repository: 'example/carbon-registry',
        ref: 'stable',
      ),
    );
    final config = ProjectConfig.parse(
      File(p.join(root.path, 'remix.yaml')).readAsStringSync(),
      packageRoot: root,
    );
    expect(config.defaultRegistry, '@acme');
    expect(config.registries.keys, ['@acme']);
    expect(config.registries['@acme']!.repository, 'example/carbon-registry');
    expect(config.registries['@acme']!.revision, 'c' * 40);
  });

  test(
    'known Carbon preset selects its separate registry automatically',
    () async {
      final requests = <Uri>[];
      final carbon = Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: _customSources(requests: requests),
      );

      expect(
        await runRemixCli(
          ['init', '--prefix', 'Acme', '--preset', 'carbon'],
          writeOut: output.add,
          writeError: fail,
          onInit: carbon.initialize,
        ),
        successExitCode,
      );
      final config = ProjectConfig.parse(
        File(p.join(root.path, 'remix.yaml')).readAsStringSync(),
        packageRoot: root,
      );
      expect(config.preset, 'carbon');
      expect(config.defaultRegistry, '@carbon');
      expect(config.registries.keys, ['@carbon']);
      expect(config.registries['@carbon']!.repository, 'btwld/flutter-carbon');
      expect(config.registries['@carbon']!.path, 'registry');
      expect(config.registries['@carbon']!.ref, 'stable');
      expect(config.registries['@carbon']!.revision, 'c' * 40);
      expect(
        requests.map((uri) => uri.path),
        contains('/repos/btwld/flutter-carbon/commits/stable'),
      );
      expect(
        requests.where((uri) => uri.host == 'raw.githubusercontent.com'),
        everyElement(predicate<Uri>((uri) => uri.path.contains('c' * 40))),
      );

      final before = snapshotFiles(root);
      final offline = Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: GitHubSources(
          transport: (_) async => fail('re-init went online'),
        ),
      );
      await offline.initialize(
        const InitOptions(prefix: 'Acme', preset: 'carbon', uiPath: 'lib/ui'),
      );
      expect(snapshotFiles(root), before);
    },
  );

  test('known Carbon source failure leaves project untouched', () async {
    final before = snapshotFiles(root);
    final carbon = Installer(
      projectRoot: root,
      writeOut: output.add,
      sources: _customSources(missingRef: true),
    );

    await expectLater(
      carbon.initialize(
        const InitOptions(prefix: 'Ui', preset: 'carbon', uiPath: 'lib/ui'),
      ),
      throwsFormatException,
    );
    expect(snapshotFiles(root), before);
    expect(output, isEmpty);
  });

  test(
    'matching custom init is offline and mismatched source is untouched',
    () async {
      final custom = Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: _customSources(),
      );
      const options = InitOptions(
        prefix: 'Acme',
        preset: 'carbon',
        uiPath: 'lib/ui',
        registry: '@carbon',
        repository: 'example/carbon-registry',
        ref: 'stable',
      );
      await custom.initialize(options);
      final before = snapshotFiles(root);
      final offline = Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: GitHubSources(
          transport: (_) async => fail('re-init went online'),
        ),
      );
      await offline.initialize(options);
      expect(output.last, 'Remix is already initialized.');
      expect(snapshotFiles(root), before);

      for (final mismatch in [
        const InitOptions(
          prefix: 'Acme',
          preset: 'carbon',
          uiPath: 'lib/ui',
          registry: '@other',
          repository: 'example/carbon-registry',
        ),
        const InitOptions(
          prefix: 'Acme',
          preset: 'carbon',
          uiPath: 'lib/ui',
          registry: '@carbon',
          repository: 'example/other',
        ),
        const InitOptions(
          prefix: 'Acme',
          preset: 'carbon',
          uiPath: 'lib/ui',
          registry: '@carbon',
          repository: 'example/carbon-registry',
          path: 'elsewhere',
        ),
        const InitOptions(
          prefix: 'Acme',
          preset: 'carbon',
          uiPath: 'lib/ui',
          registry: '@carbon',
          repository: 'example/carbon-registry',
          ref: 'next',
        ),
      ]) {
        await expectLater(offline.initialize(mismatch), throwsFormatException);
        expect(snapshotFiles(root), before);
      }
    },
  );

  test('custom init failures leave no configuration or barrel', () async {
    for (final sources in [
      _customSources(
        index: 'schema: 1\npresets:\n  vanilla: vanilla/registry.yaml\n',
      ),
      _customSources(missingRef: true),
      _customSources(failNetwork: true),
    ]) {
      final before = snapshotFiles(root);
      final custom = Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: sources,
      );
      await expectLater(
        custom.initialize(
          const InitOptions(
            prefix: 'Acme',
            preset: 'carbon',
            uiPath: 'lib/ui',
            registry: '@carbon',
            repository: 'example/carbon-registry',
            ref: 'stable',
          ),
        ),
        throwsFormatException,
      );
      expect(snapshotFiles(root), before);
    }
  });

  test('rejects an unknown preset without partial initialization', () async {
    final before = snapshotFiles(root);

    await expectLater(
      installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'missing', uiPath: 'lib/ui'),
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('--registry @name and --repository owner/repo'),
        ),
      ),
    );

    expect(snapshotFiles(root), before);
  });

  test(
    'rejects runtime prefixes before initialization writes source',
    () async {
      for (final prefix in ['Remix', 'Mix']) {
        final before = snapshotFiles(root);
        final errors = <String>[];

        final code = await runRemixCli(
          ['init', '--prefix', prefix],
          writeOut: output.add,
          writeError: errors.add,
          onInit: installer.initialize,
        );

        expect(code, failureExitCode, reason: prefix);
        expect(errors.single, contains('reserved'), reason: prefix);
        expect(snapshotFiles(root), before, reason: prefix);
        expect(output, isEmpty, reason: prefix);
      }
    },
  );

  test(
    'rejects a file in the UI path without partial initialization',
    () async {
      File(p.join(root.path, 'lib', 'design_system')).writeAsStringSync('file');
      final before = snapshotFiles(root);

      await expectLater(
        installer.initialize(
          const InitOptions(
            prefix: 'Acme',
            preset: 'vanilla',
            uiPath: 'lib/design_system',
          ),
        ),
        throwsFormatException,
      );

      expect(snapshotFiles(root), before);
    },
  );

  test('rejects a directory at the barrel target without mutation', () async {
    Directory(
      p.join(root.path, 'lib', 'ui', 'ui.dart'),
    ).createSync(recursive: true);
    final before = snapshotFiles(root);

    await expectLater(
      installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      ),
      throwsFormatException,
    );

    expect(snapshotFiles(root), before);
  });

  test('rejects a mismatched existing config without mutation', () async {
    final config = File(p.join(root.path, 'remix.yaml'))
      ..writeAsStringSync('''schema: 1
prefix: Other
paths:
  ui: lib/ui
''');
    final before = snapshotFiles(root);

    await expectLater(
      installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      ),
      throwsFormatException,
    );

    expect(config.readAsStringSync(), contains('Other'));
    expect(snapshotFiles(root), before);
  });

  test('rejects changing the preset of an initialized project', () async {
    await installer.initialize(
      const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
    );
    final before = snapshotFiles(root);

    await expectLater(
      installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'fortal', uiPath: 'lib/ui'),
      ),
      throwsA(
        isA<FormatException>().having(
          (error) => error.message,
          'message',
          contains('prefix, preset, and UI path'),
        ),
      ),
    );

    expect(snapshotFiles(root), before);
  });

  test('rejects unrelated and malformed barrels without mutation', () async {
    for (final source in [
      'library;\n',
      '$managedExportsEnd\n$managedExportsStart\n',
      '$managedExportsStart\n$managedExportsStart\n$managedExportsEnd\n',
      '$managedExportsStart\n// remix_cli:exports:other\n$managedExportsEnd\n',
    ]) {
      final barrel = File(p.join(root.path, 'lib', 'ui', 'ui.dart'))
        ..createSync(recursive: true)
        ..writeAsStringSync(source);
      final before = snapshotFiles(root);

      await expectLater(
        installer.initialize(
          const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
        ),
        throwsFormatException,
        reason: source,
      );

      expect(snapshotFiles(root), before);
      barrel.deleteSync();
    }
  });

  test('rejects non-Flutter and missing package roots', () async {
    File(p.join(root.path, 'pubspec.yaml')).writeAsStringSync('name: plain\n');
    await expectLater(
      installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      ),
      throwsFormatException,
    );

    File(p.join(root.path, 'pubspec.yaml')).deleteSync();
    await expectLater(
      installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      ),
      throwsFormatException,
    );
  });
}

GitHubSources _customSources({
  List<Uri>? requests,
  String preset = 'carbon',
  String? index,
  bool missingRef = false,
  bool failNetwork = false,
}) => GitHubSources(
  transport: (uri) async {
    requests?.add(uri);
    if (failNetwork) throw const SocketException('offline');
    if (uri.path == '/repos/example/carbon-registry' ||
        uri.path == '/repos/btwld/flutter-carbon') {
      return const RegistryResponse(200, '{"default_branch":"stable"}');
    }
    if (uri.path == '/repos/example/carbon-registry/commits/stable' ||
        uri.path == '/repos/btwld/flutter-carbon/commits/stable') {
      if (missingRef) return const RegistryResponse(404, 'missing');
      return RegistryResponse(200, '{"sha":"${'c' * 40}"}');
    }
    if (uri.path.endsWith('/registry/index.yaml')) {
      return RegistryResponse(
        200,
        index ?? 'schema: 1\npresets:\n  $preset: $preset/registry.yaml\n',
      );
    }
    if (uri.path.endsWith('/registry/$preset/registry.yaml')) {
      return const RegistryResponse(200, '''schema: 2
items:
  theme:
    files:
      - source: templates/theme.dart.tmpl
        target: "@ui/theme.dart"
''');
    }
    return const RegistryResponse(404, 'missing');
  },
);
