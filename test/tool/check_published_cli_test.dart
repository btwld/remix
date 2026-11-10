import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_pub_floors.dart';
import '../../tool/check_published_cli.dart';
import '../../tool/install_pins.dart';

void main() {
  late Directory root;
  late String pin;
  late String version;
  late List<List<String>> commands;
  late StringBuffer out;

  setUp(() {
    root = Directory.systemTemp.createTempSync('published_cli_test_');
    // Candidate X+1 and its synchronized documentation are not published yet.
    File('${root.path}/packages/remix_cli/pubspec.yaml')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync('version: 7.4.0-beta.9\n');
    pin = expectedInstallPin(root, 'remix_cli');
    version = '7.4.0-beta.8';
    commands = [];
    out = StringBuffer();
  });

  tearDown(() => root.deleteSync(recursive: true));

  _PubClient published({PubResponse? response, bool offline = false}) =>
      _PubClient((_) async {
        if (offline) throw const SocketException('fixture offline');
        return response ??
            (
              statusCode: 200,
              body: jsonEncode({
                'versions': [
                  {'version': version},
                ],
              }),
            );
      });

  Future<String?> check({
    String? activatedVersion,
    PubFloorClient? client,
    String? failingCommand,
    bool complete = false,
  }) => checkPublishedCliCandidate(
    app: Directory('${root.path}/app'),
    repositoryRoot: root,
    preset: 'vanilla',
    sha: 'a' * 40,
    dart: 'fake-dart',
    flutter: 'fake-flutter',
    pubClient: client ?? published(),
    out: out,
    run: (executable, args, {capturedOutput}) async {
      commands.add([executable, ...args]);
      if (args.contains(failingCommand)) return 'fixture command failed';
      if (args.contains('--version')) {
        capturedOutput!.writeln(activatedVersion ?? version);
      }
      // Every command is fake, including the full successful consumer path.
      if (args.first == 'create') {
        if (!complete) return 'fixture reached consumer setup';
        Directory('${root.path}/app').createSync();
      }
      if (args.contains('update')) {
        File('${root.path}/app/remix.yaml').writeAsStringSync(
          'registries: {"@remix": {revision: "${'a' * 40}"}}',
        );
      }
      return null;
    },
  );

  test('tests published X even when candidate X+1 is unpublished', () async {
    final client = published();
    expect(await check(client: client), 'fixture reached consumer setup');
    expect(commands.take(2), [
      ['fake-dart', 'pub', 'global', 'activate', 'remix_cli', version],
      ['fake-dart', 'pub', 'global', 'run', 'remix_cli:remix', '--version'],
    ]);
    expect(
      client.requests.single.toString(),
      'https://pub.dev/api/packages/remix_cli',
    );
    expect(out.toString(), contains('Activated remix_cli $version'));
    expect(out.toString(), contains('documented constraint $pin'));
  });

  test('unpublished X+1 passes the complete gate using published X', () async {
    File('${root.path}/registry/vanilla/registry.yaml')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync('items: {theme: {dependencies: {remix: ^1.0.0}}}');
    expect(await check(complete: true), isNull);
    expect(commands.first.last, version);
    expect(commands.last, ['fake-dart', 'analyze', 'lib/ui']);
  });

  test('selects newest same-major release, including prereleases', () async {
    final response = (
      statusCode: 200,
      body: jsonEncode({
        'latest': {'version': '0.1.0'},
        'versions': [
          {'version': '8.0.0'},
          {'version': '7.5.0-beta.2'},
          {'version': '7.5.0-beta.3', 'retracted': true},
          {'version': '0.1.0'},
          {'version': version},
          {'version': '7.4.0'},
        ],
      }),
    );
    expect(
      await check(
        client: published(response: response),
        activatedVersion: '7.5.0-beta.2',
      ),
      'fixture reached consumer setup',
    );
    expect(commands.first.last, '7.5.0-beta.2');
    expect(out.toString(), isNot(contains('WARNING')));
  });

  test('warns separately when the documented pin is not published', () async {
    expect(await check(), 'fixture reached consumer setup');
    expect(out.toString(), contains('WARNING: documented remix_cli pin $pin'));
    expect(out.toString(), contains('no published satisfier'));
    expect(out.toString(), contains('candidate 7.4.0-beta.9'));
  });

  test('a published satisfier need not equal the documented minimum', () async {
    expect(
      await check(
        client: published(
          response: (
            statusCode: 200,
            body: '{"versions": [{"version": "7.4.0-beta.10"}]}',
          ),
        ),
        activatedVersion: '7.4.0-beta.10',
      ),
      'fixture reached consumer setup',
    );
    expect(out.toString(), isNot(contains('WARNING')));
  });

  test('rejects any executable other than the exact selected release', () async {
    for (final wrong in ['0.1.0', '7.4.0-beta.9', '7.5.0', '8.0.0']) {
      commands.clear();
      expect(
        await check(activatedVersion: wrong),
        'Activated remix_cli $wrong does not match selected published version $version.',
      );
      expect(commands, hasLength(2));
    }
  });

  test('reads the version after pub build chatter', () async {
    expect(
      await check(
        activatedVersion:
            'Building package executable...\n'
            'Built remix_cli:remix.\n'
            '$version\n',
      ),
      'fixture reached consumer setup',
    );
    expect(out.toString(), contains('Activated remix_cli $version'));
  });

  test('reads the version before a warning', () async {
    expect(
      await check(
        activatedVersion: '$version\nWarning: deprecated precompile option.\n',
      ),
      'fixture reached consumer setup',
    );
    expect(out.toString(), contains('Activated remix_cli $version'));
  });

  test('reads the version with CRLF output', () async {
    expect(
      await check(
        activatedVersion:
            'Building package executable...\r\n'
            '$version\r\n'
            'Warning: deprecated precompile option.\r\n',
      ),
      'fixture reached consumer setup',
    );
    expect(out.toString(), contains('Activated remix_cli $version'));
  });

  test('uses the last exact semver line including build metadata', () async {
    version = '7.4.0-beta.8+build.42';
    expect(
      await check(
        activatedVersion:
            '7.4.0-beta.7\n'
            '$version\n'
            'Warning: installed 8.0.0\n',
      ),
      'fixture reached consumer setup',
    );
    expect(out.toString(), contains('Activated remix_cli $version'));
  });

  test('fails clearly when the executable version cannot be parsed', () async {
    for (final malformed in [
      '',
      'unknown version',
      'Building package executable...\nBuilt remix_cli:remix.\n',
      'Warning: installed $version\n',
      'v$version',
      '7.4',
    ]) {
      commands.clear();
      final problem = await check(activatedVersion: malformed);
      expect(
        problem,
        contains('Could not determine activated remix_cli version'),
      );
      expect(problem, contains('expected published version $version'));
      expect(commands, hasLength(2));
    }
  });

  test('no unretracted same-major release stops before activation', () async {
    for (final response in <PubResponse>[
      (statusCode: 404, body: 'not found'),
      (statusCode: 200, body: '{"versions": []}'),
      (
        statusCode: 200,
        body: jsonEncode({
          'versions': [
            {'version': version, 'retracted': true},
            {'version': '8.0.0'},
          ],
        }),
      ),
    ]) {
      expect(
        await check(client: published(response: response)),
        'No published, unretracted remix_cli in major 7 on pub.dev; '
        'cannot check the candidate with a released CLI.',
      );
      expect(commands, isEmpty);
    }
  });

  test(
    'preflight keeps server and network failures distinct from missing releases',
    () async {
      expect(
        await check(
          client: published(response: (statusCode: 503, body: 'offline')),
        ),
        contains('pub.dev preflight for remix_cli failed: HTTP 503'),
      );
      final problem = await check(client: published(offline: true));
      expect(problem, contains('fixture offline'));
      expect(problem, isNot(contains('not on pub.dev yet')));
      expect(commands, isEmpty);
    },
  );

  test('malformed pub.dev metadata fails before activation', () async {
    expect(
      await check(client: published(response: (statusCode: 200, body: '{}'))),
      contains('pub.dev preflight for remix_cli failed'),
    );
    expect(commands, isEmpty);
  });

  test(
    'activation and version command failures stop before consumer setup',
    () async {
      for (final command in ['activate', '--version']) {
        commands.clear();
        expect(await check(failingCommand: command), 'fixture command failed');
        expect(commands, hasLength(command == 'activate' ? 1 : 2));
      }
    },
  );
}

final class _PubClient implements PubFloorClient {
  _PubClient(this.reply);
  final Future<PubResponse> Function(Uri) reply;
  final requests = <Uri>[];

  @override
  Future<PubResponse> get(Uri uri) {
    requests.add(uri);
    return reply(uri);
  }

  @override
  void close() {}
}
