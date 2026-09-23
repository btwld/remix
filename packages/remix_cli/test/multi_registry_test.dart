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
      final graph = await RegistryGraph.resolve(fixture.config(root), const [
        '@company/button',
      ], fixture.resolver);
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
        parseConfig(updated, root).registries['@remix']!.revision,
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
    'existing schema-3 initialization does not resolve the registry again',
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

  test('the published third-party walkthrough runs end to end', () async {
    // Follows docs/guides/registries.mdx exactly, through the public CLI
    // handlers: init, register the namespace, install from it. A custom
    // registry has to offer the preset `init` already selected, and this is
    // what proves the documented flow can actually be completed.
    final consumer = createFlutterPackage();
    addTearDown(() => consumer.deleteSync(recursive: true));
    writeRequiredPubspec(consumer);
    final guided = Installer(
      projectRoot: consumer,
      writeOut: output.add,
      sources: fixture.resolver,
      processRunner: happyRunner(consumer, runRealGit: true),
    );
    Future<int> run(List<String> arguments) => runRemixCli(
      arguments,
      writeOut: output.add,
      writeError: fail,
      onInit: guided.initialize,
      onAdd: guided.add,
      onRegistry: guided.registry,
    );

    expect(await run(['init']), successExitCode);
    expect(
      await run([
        'registry',
        'add',
        '@acme',
        '--repository',
        'owner/company',
        '--ref',
        'v1',
      ]),
      successExitCode,
    );
    expect(await run(['add', '@acme/button']), successExitCode);

    final config = parseConfig(null, consumer);
    expect(config.preset, 'vanilla');
    expect(config.registries.keys, containsAll(['@remix', '@acme']));
    expect(
      File('${consumer.path}/lib/ui/company.dart').readAsStringSync(),
      contains('class UiCompany'),
    );
  });

  test(
    'drift guidance on a pinned project names the pin, not the CLI',
    () async {
      // The pinned counterpart of the legacy notice in installer_test: a CLI
      // upgrade cannot move a recorded revision, so it must not be suggested.
      // Re-resolving the recorded ref is what moves a registry-stable pin;
      // `add` never does it, so the notice names `registry update`.
      fixture.official['button'] = {
        ...item('button'),
        'dependencies': {'remix': '^1.0.0'},
      };
      writeRequiredPubspec(root, remix: '^1.0.0');
      writeRequiredLock(root, remix: '1.2.0');

      await Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: fixture.resolver,
        processRunner: happyRunner(root, lockedRemix: '1.2.0'),
      ).add(const AddOptions(items: ['button'], mode: AddMode.write));

      expect(
        output,
        contains(
          allOf(
            startsWith('Resolved remix 1.2.0;'),
            contains('remix registry update @remix'),
            isNot(contains('--ref')),
            isNot(contains('newer release')),
            isNot(contains('pub upgrade')),
          ),
        ),
      );
    },
  );

  test('drift guidance on a SHA pin names --ref', () async {
    // A SHA or tag re-resolves to itself, so a bare `registry update` would
    // leave the pin where it is. Only registry-stable advances without --ref.
    final pinned = fixture.config(root);
    File('${root.path}/remix.yaml').writeAsStringSync(
      ProjectConfig(
        packageRoot: root,
        prefix: pinned.prefix,
        preset: pinned.preset,
        uiPath: pinned.uiPath,
        defaultRegistry: pinned.defaultRegistry,
        registries: {
          ...pinned.registries,
          '@remix': RegistrySource(
            repository: officialRepository,
            path: 'registry',
            ref: 'a' * 40,
            revision: 'a' * 40,
          ),
        },
      ).encode(),
    );
    fixture.official['button'] = {
      ...item('button'),
      'dependencies': {'remix': '^1.0.0'},
    };
    writeRequiredPubspec(root, remix: '^1.0.0');
    writeRequiredLock(root, remix: '1.2.0');

    await Installer(
      projectRoot: root,
      writeOut: output.add,
      sources: fixture.resolver,
      processRunner: happyRunner(root, lockedRemix: '1.2.0'),
    ).add(const AddOptions(items: ['button'], mode: AddMode.write));

    expect(
      output,
      contains(
        allOf(
          startsWith('Resolved remix 1.2.0;'),
          contains('remix registry update @remix --ref <newer ref>'),
        ),
      ),
    );
  });

  test(
    'registry update re-resolves registry-stable to the promoted commit',
    () async {
      final before = snapshotFiles(root);

      await installer.registry(
        const RegistryOptions(
          action: RegistryAction.update,
          namespace: '@remix',
        ),
      );

      final updated = parseConfig(null, root);
      expect(updated.registries['@remix']!.ref, 'registry-stable');
      expect(updated.registries['@remix']!.revision, 'd' * 40);
      expect(updated.registries['@company']!.revision, 'b' * 40);
      expect(
        fixture.requests.any(
          (uri) => uri.path.endsWith('/commits/registry-stable'),
        ),
        isTrue,
      );
      expect(
        fixture.requests.any((uri) => uri.path.contains('/releases')),
        isFalse,
      );
      before.remove('remix.yaml');
      expect(snapshotFiles(root)..remove('remix.yaml'), before);
    },
  );

  test(
    'registry update preserves a preset YAML would read as a keyword',
    () async {
      // The encoder is what `registry update` writes, so the round-trip has to
      // hold on the real rewrite path and not just in isolation.
      File('${root.path}/remix.yaml').writeAsStringSync(
        ProjectConfig(
          packageRoot: root,
          prefix: 'Ui',
          preset: 'true',
          uiPath: 'lib/ui',
          defaultRegistry: '@remix',
          registries: {
            '@remix': RegistrySource(
              repository: officialRepository,
              path: 'registry',
              ref: 'registry-stable',
              revision: 'a' * 40,
            ),
          },
        ).encode(),
      );

      await installer.registry(
        const RegistryOptions(
          action: RegistryAction.update,
          namespace: '@remix',
          ref: 'v2',
        ),
      );

      final rewritten = parseConfig(null, root);
      expect(rewritten.preset, 'true');
      expect(rewritten.registries['@remix']!.revision, 'c' * 40);
    },
  );

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
      expect(parseConfig(null, root).registries['@other']!.ref, 'main');
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

/// Parses `remix.yaml`, from [source] or from the project every command under
/// test has to leave one behind in.
ProjectConfig parseConfig(String? source, Directory root) =>
    ProjectConfig.parse(
      source ?? File('${root.path}/remix.yaml').readAsStringSync(),
      packageRoot: root,
    );

/// The branch CI promotes, which `latestOfficial` resolves.
const stableRegistryRef = 'registry-stable';

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
              : tag == stableRegistryRef
              ? 'd'
              : 'b';
          return RegistryResponse(200, jsonEncode({'sha': sha * 40}));
        }
        return const RegistryResponse(200, '{"default_branch":"main"}');
      }
      if (uri.path.contains('no-preset'))
        return const RegistryResponse(200, 'schema: 1\npresets: {}');
      if (uri.path.endsWith('index.yaml'))
        return const RegistryResponse(
          200,
          'schema: 1\npresets:\n  vanilla: vanilla/registry.yaml\n  fortal: fortal/registry.yaml\n  "true": vanilla/registry.yaml',
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
  ProjectConfig config(Directory root) => ProjectConfig(
    packageRoot: root,
    prefix: 'Ui',
    preset: 'fortal',
    uiPath: 'lib/ui',
    defaultRegistry: '@remix',
    registries: {
      '@remix': RegistrySource(
        repository: officialRepository,
        path: 'registry',
        ref: 'registry-stable',
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
