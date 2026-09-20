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

  for (final schema in [1, 2]) {
    test(
      'init without --preset preserves legacy default schema $schema',
      () async {
        File(p.join(root.path, 'remix.yaml')).writeAsStringSync(
          'schema: $schema\nprefix: Ui\n'
          '${schema == 2 ? 'preset: default\n' : ''}'
          'paths:\n  ui: lib/ui\n',
        );
        File(p.join(root.path, 'lib/ui/ui.dart'))
          ..createSync(recursive: true)
          ..writeAsStringSync(emptyManagedBarrel);
        final before = snapshotFiles(root);
        expect(
          await runRemixCli(
            ['init'],
            writeOut: output.add,
            writeError: fail,
            onInit: installer.initialize,
          ),
          successExitCode,
        );
        expect(snapshotFiles(root), before);
        expect(output.last, 'Remix is already initialized.');
      },
    );
  }

  test('schema 3 requires exact preset identity', () async {
    final source = await const FixtureOfficialResolver().latestOfficial();
    final config = PinnedProject(
      packageRoot: root,
      prefix: 'Ui',
      preset: 'default',
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
      ('default', 'vanilla', false),
      ('vanilla', 'default', false),
      ('acme_dark', 'acme_dark', true),
    ]) {
      File(p.join(root.path, 'remix.yaml')).writeAsStringSync(
        PinnedProject(
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
    ref: "registry-v1"
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

  test('rejects an unknown preset without partial initialization', () async {
    final before = snapshotFiles(root);

    await expectLater(
      installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'missing', uiPath: 'lib/ui'),
      ),
      throwsFormatException,
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
            preset: 'default',
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
        const InitOptions(prefix: 'Ui', preset: 'default', uiPath: 'lib/ui'),
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
        const InitOptions(prefix: 'Ui', preset: 'default', uiPath: 'lib/ui'),
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
          const InitOptions(prefix: 'Ui', preset: 'default', uiPath: 'lib/ui'),
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
        const InitOptions(prefix: 'Ui', preset: 'default', uiPath: 'lib/ui'),
      ),
      throwsFormatException,
    );

    File(p.join(root.path, 'pubspec.yaml')).deleteSync();
    await expectLater(
      installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'default', uiPath: 'lib/ui'),
      ),
      throwsFormatException,
    );
  });
}
