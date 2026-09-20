import 'dart:convert';
import 'dart:io';

import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/project_config.dart';
import 'package:remix_cli/src/registry_graph.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:test/test.dart';

import 'installer_test.dart' show happyRunner;
import 'test_support.dart';

void main() {
  late Directory root;
  late FixtureRegistries fixture;
  late Installer installer;
  late List<String> output;
  setUp(() {
    root = createFlutterPackage();
    fixture = FixtureRegistries();
    output = [];
    installer = Installer(
      projectRoot: root,
      writeOut: output.add,
      sources: fixture.resolver,
      processRunner: happyRunner(root, runRealGit: true),
    );
    fixture.save(root);
  });
  tearDown(() => root.deleteSync(recursive: true));

  test(
    'duplicate local names, cross edges and shared dependencies retain identity',
    () async {
      fixture.company['button'] = item('company', [
        '@remix/button',
        '@remix/theme',
      ]);
      final graph = await RegistryGraph.resolve(
        fixture.config(root),
        const ['@company/button'],
        fixture.resolver,
      );
      expect(graph.items.map((i) => i.name), [
        '@remix/theme',
        '@remix/button',
        '@company/button',
      ]);
      final before = snapshotFiles(root);
      await installer.add(
        const AddOptions(items: ['@company/button'], mode: AddMode.dryRun),
      );
      expect(snapshotFiles(root), before);
      expect(
        output.join('\n'),
        contains('@company (fortal) revision ${'b' * 40}'),
      );
      expect(
        fixture.requests.every(
          (uri) => uri.host == 'raw.githubusercontent.com',
        ),
        isTrue,
      );
    },
  );

  test(
    'one invocation installs roots from two registries, sharing a dependency',
    () async {
      // Batch install and pinned multi-registry resolution meet here: the
      // roots are qualified against different registries, and the dependency
      // they agree on must still be emitted once, ahead of both.
      final graph = await RegistryGraph.resolve(fixture.config(root), const [
        'button',
        '@company/button',
      ], fixture.resolver);

      expect(graph.items.map((i) => i.name), [
        '@remix/theme',
        '@remix/button',
        '@company/button',
      ]);
      expect(graph.requestedNames, {'@remix/button', '@company/button'});

      await installer.add(
        const AddOptions(
          items: ['button', '@company/button'],
          mode: AddMode.write,
        ),
      );

      expect(
        File('${root.path}/lib/ui/button.dart').readAsStringSync(),
        contains('class UiButton'),
      );
      expect(
        File('${root.path}/lib/ui/company.dart').readAsStringSync(),
        contains('class UiCompany'),
      );
      // Written once, by the single shared traversal rather than per root.
      expect(
        output.where((line) => line.startsWith('Added @remix/theme.')),
        hasLength(1),
      );
    },
  );

  test(
    'a root requested twice in one invocation fails before any write',
    () async {
      final before = snapshotFiles(root);

      await expectLater(
        RegistryGraph.resolve(fixture.config(root), const [
          'button',
          '@remix/button',
        ], fixture.resolver),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            contains('requested twice'),
          ),
        ),
      );
      expect(snapshotFiles(root), before);
    },
  );

  test(
    'two registries install; update, diff and overwrite are independent of CLI version',
    () async {
      fixture.company['button'] = item('company', ['@remix/button']);
      await installer.add(
        const AddOptions(items: ['@company/button'], mode: AddMode.write),
      );
      final dependency = File('${root.path}/lib/ui/button.dart');
      dependency.writeAsStringSync('// custom dependency\n');
      final configBefore = File('${root.path}/remix.yaml').readAsStringSync();
      final installed = File('${root.path}/lib/ui/company.dart');
      final oldSource = installed.readAsStringSync();
      await installer.registry(
        const RegistryOptions(
          action: RegistryAction.update,
          namespace: '@company',
          ref: 'v2',
        ),
      );
      expect(installed.readAsStringSync(), oldSource);
      final updated = File('${root.path}/remix.yaml').readAsStringSync();
      expect(updated, isNot(configBefore));
      expect(
        parsePinned(updated, root).registries['@remix']!.revision,
        'a' * 40,
      );
      final beforeDiff = snapshotFiles(root);
      await installer.add(
        const AddOptions(items: ['@company/button'], mode: AddMode.diff),
      );
      expect(snapshotFiles(root), beforeDiff);
      expect(output.join('\n'), contains('revision two'));
      await installer.add(
        const AddOptions(items: ['@company/button'], mode: AddMode.write),
      );
      expect(installed.readAsStringSync(), oldSource);
      await installer.add(
        const AddOptions(items: ['@company/button'], mode: AddMode.overwrite),
      );
      expect(installed.readAsStringSync(), contains('revision two'));
      expect(dependency.readAsStringSync(), '// custom dependency\n');
      expect(File('${root.path}/remix.yaml').readAsStringSync(), updated);
    },
  );

  test(
    'generation retains adapters outside the current registry graph',
    () async {
      fixture.official['button'] = {
        ...item('button'),
        'generated': ['@ui/button.g.dart'],
      };
      final other = File('${root.path}/lib/ui/company.g.dart')
        ..writeAsStringSync('// existing adapter');
      final runner = happyRunner(root);
      await Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: fixture.resolver,
        processRunner: runner,
      ).add(const AddOptions(items: ['button'], mode: AddMode.write));
      final build = runner.calls.singleWhere(
        (call) => call.arguments.contains('build_runner'),
      );
      expect(
        build.arguments,
        contains('--build-filter=package:consumer/ui/company.g.dart'),
      );
      expect(other.existsSync(), isTrue);
    },
  );

  test(
    'existing schema-3 initialization does not resolve releases again',
    () async {
      final before = snapshotFiles(root);
      final offline = GitHubSources(
        transport: (_) async {
          fail('existing init contacted GitHub');
        },
      );
      await Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: offline,
      ).initialize(
        const InitOptions(prefix: 'Ui', preset: 'fortal', uiPath: 'lib/ui'),
      );
      expect(snapshotFiles(root), before);
    },
  );

  test('failed update leaves the previous pin and all source intact', () async {
    final before = snapshotFiles(root);
    final missing = GitHubSources(
      transport: (_) async => const RegistryResponse(404, ''),
    );
    await expectLater(
      Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: missing,
      ).registry(
        const RegistryOptions(
          action: RegistryAction.update,
          namespace: '@company',
          ref: 'missing',
        ),
      ),
      throwsFormatException,
    );
    expect(snapshotFiles(root), before);
  });

  for (final failure in [
    'cycle',
    'unknown namespace',
    'target conflict',
    'package conflict',
    'missing template',
    'traversal',
  ]) {
    test('$failure fails before processes or writes', () async {
      switch (failure) {
        case 'cycle':
          fixture.company['button'] = item('company', ['@remix/button']);
          fixture.official['button'] = item('button', ['@company/button']);
        case 'unknown namespace':
          fixture.company['button'] = item('company', ['@missing/button']);
        case 'target conflict':
          fixture.company['button'] = item('button', ['@remix/button']);
        case 'package conflict':
          fixture.company['button'] = {
            ...item('company', ['@remix/button']),
            'dependencies': {'example': '^2.0.0'},
          };
          fixture.official['button'] = {
            ...item('button'),
            'dependencies': {'example': '^1.0.0'},
          };
        case 'missing template':
          fixture.company['button'] = item('missing', ['@remix/button']);
        case 'traversal':
          fixture.company['button'] = {
            'files': [
              {
                'source': 'templates/%2e%2e/outside',
                'target': '@ui/company.dart',
              },
            ],
          };
      }
      final runner = RecordingProcessRunner((_) async {
        fail('process ran before preflight completed');
      });
      final checked = Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: fixture.resolver,
        processRunner: runner,
      );
      final before = snapshotFiles(root);
      await expectLater(
        checked.add(
          const AddOptions(items: ['@company/button'], mode: AddMode.write),
        ),
        throwsFormatException,
      );
      expect(snapshotFiles(root), before);
      expect(runner.calls, isEmpty);
    });
  }

  /// Writes a legacy schema-1/2 project: its configuration, authored source,
  /// generated adapters, and the dependency files migration must not touch.
  void writeLegacyProject(int schema, String preset) {
    File('${root.path}/remix.yaml').writeAsStringSync(
      LegacyProject(
        packageRoot: root,
        prefix: 'Acme',
        preset: preset,
        uiPath: 'lib/custom',
        schema: schema,
      ).encode(),
    );
    File('${root.path}/lib/custom/button.dart')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync('// authored');
    File(
      '${root.path}/lib/custom/button.g.dart',
    ).writeAsStringSync('// adapter');
    File('${root.path}/build.yaml').writeAsStringSync(
      'targets:\n'
      r'  $default:'
      '\n    builders:\n'
      '      mix_generator:spec_styler_generator:\n'
      '        generate_for:\n'
      '          - lib/custom/button.dart\n',
    );
    writeRequiredPubspec(root);
    writeRequiredLock(root);
  }

  for (final (schema, beforePreset, afterPreset, ref) in [
    (1, 'default', 'vanilla', 'registry-v1'),
    (2, 'default', 'vanilla', 'registry-v1'),
    (2, 'fortal', 'fortal', 'registry-v1'),
    (2, 'default', 'vanilla', null),
  ]) {
    test('schema $schema $beforePreset migration '
        '${ref ?? 'without a ref'} changes configuration only', () async {
      writeLegacyProject(schema, beforePreset);
      final before = snapshotFiles(root)..remove('remix.yaml');
      await installer.registry(
        RegistryOptions(action: RegistryAction.migrate, ref: ref),
      );
      final parsed = parsePinned(null, root);
      expect(parsed.prefix, 'Acme');
      expect(parsed.uiPath, 'lib/custom');
      expect(parsed.preset, afterPreset);
      expect(parsed.schema, 3);
      // Omitting the ref pins the newest stable registry release instead.
      final source = parsed.registries['@remix']!;
      expect(source.repository, officialRepository);
      expect(source.ref, ref ?? stableRegistryTag);
      expect(source.revision, (ref == null ? 'd' : 'b') * 40);
      expect(snapshotFiles(root)..remove('remix.yaml'), before);
      expect(
        output.contains('Renamed legacy preset default to vanilla.'),
        beforePreset == 'default',
      );
      expect(output.last, contains('--diff'));
    });
  }

  for (final schema in [1, 2]) {
    test(
      'schema $schema migration without a remote vanilla preset writes nothing',
      () async {
        writeLegacyProject(schema, 'default');
        final before = snapshotFiles(root);
        await expectLater(
          Installer(
            projectRoot: root,
            writeOut: output.add,
            sources: GitHubSources(
              transport: (uri) async => uri.host == 'api.github.com'
                  ? RegistryResponse(
                      200,
                      uri.path.contains('/commits/')
                          ? jsonEncode({'sha': 'e' * 40})
                          : '{"default_branch":"main"}',
                    )
                  : const RegistryResponse(
                      200,
                      'schema: 1\npresets:\n  fortal: fortal/registry.yaml',
                    ),
            ),
          ).registry(
            const RegistryOptions(
              action: RegistryAction.migrate,
              ref: 'registry-v1',
            ),
          ),
          throwsA(
            isA<FormatException>().having(
              (error) => error.message,
              'message',
              contains('no vanilla preset'),
            ),
          ),
        );
        expect(snapshotFiles(root), before);
        expect(output, isEmpty);
      },
    );
  }

  test(
    'registration validates preset before saving and does not replace a namespace',
    () async {
      final before = snapshotFiles(root);
      await expectLater(
        installer.registry(
          const RegistryOptions(
            action: RegistryAction.add,
            namespace: '@other',
            repository: 'owner/no-preset',
          ),
        ),
        throwsFormatException,
      );
      expect(snapshotFiles(root), before);
      await installer.registry(
        const RegistryOptions(
          action: RegistryAction.add,
          namespace: '@other',
          repository: 'owner/company',
        ),
      );
      expect(parsePinned(null, root).registries['@other']!.ref, 'main');
      await expectLater(
        installer.registry(
          const RegistryOptions(
            action: RegistryAction.add,
            namespace: '@other',
            repository: 'owner/company',
          ),
        ),
        throwsFormatException,
      );
    },
  );
}

/// Parses `remix.yaml` as a pinned project. Every command under test here has
/// to leave one behind, so the cast is part of the assertion.
PinnedProject parsePinned(String? source, Directory root) =>
    ProjectConfig.parse(
          source ?? File('${root.path}/remix.yaml').readAsStringSync(),
          packageRoot: root,
        )
        as PinnedProject;

/// The newest stable registry release the fixture publishes.
const stableRegistryTag = 'registry-v3';

Map<String, Object> item(
  String target, [
  List<String> dependencies = const [],
]) => {
  'registryDependencies': dependencies,
  'files': [
    {'source': 'templates/$target.dart.tmpl', 'target': '@ui/$target.dart'},
  ],
  'exports': ['$target.dart'],
};

final class FixtureRegistries {
  final official = <String, Object>{
    'theme': item('theme'),
    'button': item('button', ['theme']),
  };
  final company = <String, Object>{'button': item('company')};
  final requests = <Uri>[];
  late final resolver = GitHubSources(
    transport: (uri) async {
      requests.add(uri);
      if (uri.host == 'api.github.com') {
        if (uri.path.contains('/commits/')) {
          final tag = uri.pathSegments.last;
          final sha = tag == 'v2'
              ? 'c'
              : tag == stableRegistryTag
              ? 'd'
              : 'b';
          return RegistryResponse(200, jsonEncode({'sha': sha * 40}));
        }
        if (uri.path.endsWith('/releases'))
          return RegistryResponse(
            200,
            jsonEncode([
              // An unrelated package release must not hide the registry one.
              {'tag_name': 'v9.0.0', 'draft': false, 'prerelease': false},
              {
                'tag_name': stableRegistryTag,
                'draft': false,
                'prerelease': false,
              },
            ]),
          );
        return const RegistryResponse(200, '{"default_branch":"main"}');
      }
      if (uri.path.contains('no-preset'))
        return const RegistryResponse(200, 'schema: 1\npresets: {}');
      if (uri.path.endsWith('index.yaml'))
        return const RegistryResponse(
          200,
          'schema: 1\npresets:\n  vanilla: vanilla/registry.yaml\n  fortal: fortal/registry.yaml',
        );
      if (uri.path.endsWith('registry.yaml'))
        return RegistryResponse(
          200,
          jsonEncode({
            'schema': 2,
            'items': uri.path.contains('conceptadev/remix')
                ? official
                : company,
          }),
        );
      if (uri.path.endsWith('missing.dart.tmpl'))
        return const RegistryResponse(404, '');
      final name = uri.pathSegments.last.split('.').first;
      return RegistryResponse(
        200,
        '// ${uri.path.contains('c' * 40) ? 'revision two' : 'revision one'}\nclass {{typePrefix}}${name[0].toUpperCase()}${name.substring(1)} {}\n',
      );
    },
  );
  PinnedProject config(Directory root) => PinnedProject(
    packageRoot: root,
    prefix: 'Ui',
    preset: 'fortal',
    uiPath: 'lib/ui',
    defaultRegistry: '@remix',
    registries: {
      '@remix': RegistrySource(
        repository: officialRepository,
        path: 'registry',
        ref: 'registry-v1',
        revision: 'a' * 40,
      ),
      '@company': RegistrySource(
        repository: 'owner/company',
        path: 'nested/registry',
        ref: 'v1',
        revision: 'b' * 40,
      ),
    },
  );
  void save(Directory root) {
    File('${root.path}/remix.yaml').writeAsStringSync(config(root).encode());
    File('${root.path}/lib/ui/ui.dart')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync(emptyManagedBarrel);
  }
}
