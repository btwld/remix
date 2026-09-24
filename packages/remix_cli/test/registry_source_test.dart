import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:remix_cli/src/project_config.dart';
import 'package:remix_cli/src/registry.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  test(
    'official index loads vanilla and fortal but rejects legacy default',
    () async {
      final source = RegistrySource(
        repository: officialRepository,
        path: 'registry',
        ref: 'registry-stable',
        revision: 'a' * 40,
      );
      final resolver = GitHubSources(
        transport: (uri) async {
          final relative = uri.path.split('/registry/').last;
          return RegistryResponse(
            200,
            File('../../registry/$relative').readAsStringSync(),
          );
        },
      );
      final vanillaRegistry = resolver.open(source, 'vanilla');
      final vanilla = await vanillaRegistry.catalog();
      final fortal = await resolver.open(source, 'fortal').catalog();
      expect(vanilla.preset, 'vanilla');
      expect(fortal.preset, 'fortal');
      final template = await vanillaRegistry.template(
        vanilla.items['button']!.files.first,
      );
      expect(template, isNotEmpty);
      expect(fortal.items, isNotEmpty);
      await expectLater(
        resolver.open(source, 'default').catalog(),
        throwsFormatException,
      );
    },
  );

  final sha = 'a' * 40;
  test(
    'incompatible registry-stable fails closed without another ref',
    () async {
      final root = createFlutterPackage();
      addTearDown(() => root.deleteSync(recursive: true));
      final before = snapshotFiles(root);
      final requests = <Uri>[];
      final resolver = GitHubSources(
        transport: (uri) async {
          requests.add(uri);
          if (uri.host == 'api.github.com')
            return RegistryResponse(200, jsonEncode({'sha': sha}));
          return const RegistryResponse(200, 'schema: 99');
        },
      );
      await expectLater(
        Installer(
          projectRoot: root,
          writeOut: (_) {},
          sources: resolver,
        ).initialize(
          const InitOptions(prefix: 'Ui', preset: 'fortal', uiPath: 'lib/ui'),
        ),
        throwsFormatException,
      );
      expect(snapshotFiles(root), before);
      expect(
        requests
            .where((uri) => uri.path.contains('/commits/'))
            .map((uri) => uri.pathSegments.last),
        ['registry-stable'],
      );
      expect(requests.any((uri) => uri.path.contains('/releases')), isFalse);
    },
  );

  test(
    'schema 1 rejects qualified dependencies; schema 2 validates their syntax',
    () {
      for (final (schema, dependency) in [
        (1, '@company/button'),
        (2, '@company/../button'),
        (2, '@BAD/button'),
      ]) {
        expect(
          () => RegistryCatalog.parse(
            jsonEncode({
              'schema': schema,
              'items': {
                'button': {
                  'registryDependencies': [dependency],
                  'files': [
                    {'source': 'templates/button', 'target': '@ui/button.dart'},
                  ],
                },
              },
            }),
            preset: 'default',
          ),
          throwsFormatException,
        );
      }
    },
  );

  // GitHub answers a commit lookup for an unknown ref with this 422, not 404.
  RegistryResponse missingCommit(String ref) => RegistryResponse(
    422,
    jsonEncode({
      'message': 'No commit found for SHA: $ref',
      'documentation_url':
          'https://docs.github.com/rest/commits/commits#get-a-commit',
      'status': '422',
    }),
  );

  test('missing registry-stable fails initialization without writes', () async {
    final root = createFlutterPackage();
    addTearDown(() => root.deleteSync(recursive: true));
    final before = snapshotFiles(root);
    final requests = <Uri>[];
    final resolver = GitHubSources(
      transport: (uri) async {
        requests.add(uri);
        if (uri.path.endsWith('/commits/registry-stable')) {
          return missingCommit('registry-stable');
        }
        return const RegistryResponse(200, '{"default_branch":"main"}');
      },
    );
    await expectLater(
      Installer(
        projectRoot: root,
        writeOut: (_) {},
        sources: resolver,
      ).initialize(
        const InitOptions(prefix: 'Ui', preset: 'fortal', uiPath: 'lib/ui'),
      ),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains(
            'No registry-stable branch is published for btwld/remix',
          ),
        ),
      ),
    );
    expect(snapshotFiles(root), before);
    expect(
      requests.any(
        (uri) => uri.path == '/repos/btwld/remix/commits/registry-stable',
      ),
      isTrue,
    );
    expect(requests.any((uri) => uri.path.contains('/releases')), isFalse);
  });

  test(
    'schema 3 round-trip preserves coordinates and permits remote presets',
    () {
      final root = createFlutterPackage();
      addTearDown(() => root.deleteSync(recursive: true));
      final config = ProjectConfig(
        packageRoot: root,
        prefix: 'Acme',
        preset: 'custom',
        uiPath: 'lib/brand',
        defaultRegistry: '@company',
        registries: {
          '@company': RegistrySource(
            repository: 'owner/repo',
            path: 'nested/registry',
            ref: 'v1',
            revision: sha,
          ),
        },
      );
      final parsed = ProjectConfig.parse(config.encode(), packageRoot: root);
      expect(parsed.encode(), config.encode());
      for (final namespace in ['company', '@', '@UPPER', '@a/b', '@a b']) {
        expect(
          () => ProjectConfig(
            packageRoot: root,
            prefix: 'Ui',
            preset: 'default',
            uiPath: 'lib/ui',
            defaultRegistry: namespace,
            registries: {namespace: config.registries.values.single},
          ),
          throwsFormatException,
        );
      }
    },
  );

  for (final ref in ['feature/branch', 'v1', sha, null]) {
    test(
      'resolves ${ref ?? 'default branch'} and reads only exact SHA assets',
      () async {
        final requests = <Uri>[];
        final resolver = GitHubSources(
          transport: (uri) async {
            requests.add(uri);
            if (uri.host == 'api.github.com') {
              return RegistryResponse(
                200,
                jsonEncode(
                  uri.path.endsWith('/repos/owner/repo')
                      ? {'default_branch': 'main'}
                      : {'sha': sha},
                ),
              );
            }
            expect(uri.path, startsWith('/owner/repo/$sha/nested/registry/'));
            return RegistryResponse(
              200,
              uri.path.endsWith('index.yaml')
                  ? 'schema: 1\npresets:\n  fortal: presets/fortal/registry.yaml\n'
                  : uri.path.endsWith('registry.yaml')
                  ? 'schema: 2\nitems:\n  button:\n    files:\n      - source: templates/button.dart.tmpl\n        target: "@ui/button.dart"\n'
                  : 'class {{typePrefix}}Button {}',
            );
          },
        );
        final source = await resolver.resolve(
          repository: 'owner/repo',
          path: 'nested/registry',
          ref: ref,
        );
        expect(source.ref, ref ?? 'main');
        expect(source.revision, sha);
        final registry = resolver.open(source, 'fortal');
        final catalog = await registry.catalog();
        expect(
          await registry.template(catalog.items['button']!.files.single),
          contains('{{typePrefix}}Button'),
        );
        expect(
          requests
              .where((uri) => uri.host == 'api.github.com')
              .last
              .pathSegments
              .last,
          ref ?? 'main',
        );
      },
    );
  }

  test(
    'latestOfficial resolves registry-stable and never scans releases',
    () async {
      final requests = <Uri>[];
      final resolver = GitHubSources(
        transport: (uri) async {
          requests.add(uri);
          return RegistryResponse(200, jsonEncode({'sha': sha}));
        },
      );
      final source = await resolver.latestOfficial();
      expect(source.repository, 'btwld/remix');
      expect(source.ref, 'registry-stable');
      expect(source.revision, sha);
      expect(
        requests.any(
          (uri) =>
              uri.host == 'api.github.com' &&
              uri.path == '/repos/btwld/remix/commits/registry-stable',
        ),
        isTrue,
      );
      expect(requests.any((uri) => uri.path.contains('/releases')), isFalse);
    },
  );

  test(
    'latestOfficial keeps transport failures distinct from a missing branch',
    () async {
      for (final entry in <String, RegistryTransport>{
        'not found': (_) async => const RegistryResponse(404, ''),
        'rate limit': (_) async => const RegistryResponse(
          403,
          '',
          headers: {'x-ratelimit-remaining': '0'},
        ),
        'timed out': (_) async => throw TimeoutException('timeout'),
        'network failure': (_) async => throw const SocketException('offline'),
        'failed (422)': (uri) async => uri.path.contains('/commits/')
            ? const RegistryResponse(422, '{"message":"Validation Failed"}')
            : const RegistryResponse(200, '{"default_branch":"main"}'),
      }.entries) {
        await expectLater(
          GitHubSources(transport: entry.value).latestOfficial(),
          throwsA(
            isA<FormatException>().having(
              (e) => e.message,
              'message',
              allOf(
                contains(entry.key),
                isNot(contains('No registry-stable branch is published')),
              ),
            ),
          ),
        );
      }
    },
  );

  test('a missing ref reads as not found; other 422s stay failures', () async {
    Future<RegistrySource> resolveWith(RegistryResponse commit) =>
        GitHubSources(
          transport: (uri) async => uri.path.contains('/commits/')
              ? commit
              : const RegistryResponse(200, '{"default_branch":"main"}'),
        ).resolve(repository: 'owner/repo', ref: 'typo');

    await expectLater(
      resolveWith(missingCommit('typo')),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('GitHub ref typo not found'),
        ),
      ),
    );
    await expectLater(
      resolveWith(
        const RegistryResponse(422, '{"message":"Validation Failed"}'),
      ),
      throwsA(
        isA<FormatException>().having(
          (e) => e.message,
          'message',
          allOf(contains('failed (422)'), isNot(contains('not found'))),
        ),
      ),
    );
  });

  for (final entry in <String, RegistryTransport>{
    'not found': (_) async => const RegistryResponse(404, ''),
    'rate limit': (_) async => const RegistryResponse(
      403,
      '',
      headers: {'x-ratelimit-remaining': '0'},
    ),
    'timed out': (_) async => throw TimeoutException('timeout'),
    'network failure': (_) async => throw const SocketException('offline'),
    'failed (500)': (_) async => const RegistryResponse(500, ''),
  }.entries) {
    test('reports ${entry.key} distinctly', () async {
      await expectLater(
        GitHubSources(
          transport: entry.value,
        ).resolve(repository: 'owner/repo', ref: 'v1'),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            contains(entry.key),
          ),
        ),
      );
    });
  }

  for (final path in [
    '../registry',
    '/registry',
    'a/../b',
    'a//b',
    'a%2fb',
    'a?b',
    'a#b',
    'a\\b',
  ]) {
    test('rejects unsafe source path $path before transport', () async {
      final resolver = GitHubSources(
        transport: (_) async {
          fail('unexpected request');
        },
      );
      await expectLater(
        resolver.resolve(repository: 'owner/repo', path: path),
        throwsFormatException,
      );
    });
  }

  test(
    'rejects missing preset, unsupported index/catalog and index traversal',
    () async {
      final source = RegistrySource(
        repository: 'owner/repo',
        path: 'registry',
        ref: 'v1',
        revision: sha,
      );
      for (final index in [
        'schema: 2\npresets: {}',
        'schema: 1\npresets: {}',
        'schema: 1\npresets:\n  fortal: ../outside.yaml',
        'schema: 1\npresets:\n  fortal: registry.yaml',
      ]) {
        final resolver = GitHubSources(
          transport: (uri) async => RegistryResponse(
            200,
            uri.path.endsWith('index.yaml') ? index : 'schema: 99\nitems: {}',
          ),
        );
        await expectLater(
          resolver.open(source, 'fortal').catalog(),
          throwsFormatException,
        );
      }
    },
  );
}
