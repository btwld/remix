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
    // Deliberately differs from the repository: a version bump must move the
    // activation constraint and publication check without editing the gate.
    File('${root.path}/packages/remix_cli/pubspec.yaml')
      ..parent.createSync(recursive: true)
      ..writeAsStringSync('version: 7.4.0-beta.9\n');
    pin = expectedInstallPin(root, 'remix_cli');
    version = pin.substring(1);
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
      // Never execute a consumer check, even on a successful activation.
      return args.first == 'create' ? 'fixture reached consumer setup' : null;
    },
  );

  test(
    'uses the shared install pin and reports the executable version',
    () async {
      final client = published();
      expect(await check(client: client), 'fixture reached consumer setup');
      expect(commands.take(2), [
        ['fake-dart', 'pub', 'global', 'activate', 'remix_cli', pin],
        ['fake-dart', 'pub', 'global', 'run', 'remix_cli:remix', '--version'],
      ]);
      expect(
        client.requests.single.toString(),
        'https://pub.dev/api/packages/remix_cli',
      );
      expect(out.toString(), contains('Activated remix_cli $version'));
      expect(out.toString(), contains('documented constraint $pin'));
    },
  );

  test(
    'allows newer versions that satisfy the documented constraint',
    () async {
      for (final newer in ['7.4.0-beta.10', '7.4.0', '7.5.0']) {
        expect(
          await check(activatedVersion: newer),
          'fixture reached consumer setup',
        );
        expect(out.toString(), contains('Activated remix_cli $newer'));
      }
    },
  );

  test('rejects the old stable CLI and other versions outside the pin', () async {
    for (final wrong in ['0.1.0', '7.4.0-beta.8', '8.0.0']) {
      commands.clear();
      expect(
        await check(activatedVersion: wrong),
        'Activated remix_cli $wrong does not satisfy documented constraint $pin.',
      );
      expect(commands, hasLength(2));
      expect(out.toString(), contains('Activated remix_cli $wrong'));
    }
  });

  test('fails clearly when the executable version cannot be parsed', () async {
    for (final malformed in ['', 'unknown version']) {
      commands.clear();
      final problem = await check(activatedVersion: malformed);
      expect(
        problem,
        contains('Could not determine activated remix_cli version'),
      );
      expect(problem, contains('expected documented constraint $pin'));
      expect(commands, hasLength(2));
    }
  });

  test(
    'an unpublished or retracted CLI explains the publication order',
    () async {
      for (final response in <PubResponse>[
        (statusCode: 404, body: 'not found'),
        (statusCode: 200, body: '{"versions": []}'),
        (
          statusCode: 200,
          body: jsonEncode({
            'versions': [
              {'version': version, 'retracted': true},
              {'version': '7.4.0-beta.10'},
            ],
          }),
        ),
      ]) {
        expect(
          await check(client: published(response: response)),
          'remix_cli $pin is not on pub.dev yet; push tag remix_cli-v$version, '
          'wait for the Publish workflow, then re-run Promote registry',
        );
        expect(commands, isEmpty);
      }
    },
  );

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
