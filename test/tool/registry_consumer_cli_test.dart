import 'dart:io';

import 'package:test/test.dart';

import '../../tool/compile_registry_consumer.dart';

void main() {
  late Directory sandbox;

  setUp(() {
    sandbox = Directory.systemTemp.createTempSync('open_code_tool_test_');
  });

  tearDown(() {
    if (sandbox.existsSync()) sandbox.deleteSync(recursive: true);
  });

  group('compiled checkout CLI', () {
    final root = Directory.current.absolute;
    late Directory compilation;
    late File snapshot;

    setUpAll(() async {
      compilation = Directory.systemTemp.createTempSync('registry_cli_test_');
      try {
        snapshot = await compileRegistryConsumerCli(
          dart: Platform.resolvedExecutable,
          repositoryRoot: root,
          outputDirectory: compilation,
        );
      } on Object {
        compilation.deleteSync(recursive: true);
        rethrow;
      }
    });

    tearDownAll(() {
      if (compilation.existsSync()) compilation.deleteSync(recursive: true);
    });

    Future<ProcessResult> runCli(
      List<String> arguments, {
      required Directory app,
      required bool compiled,
      String? registryRoot,
    }) => Process.run(
      Platform.resolvedExecutable,
      [
        if (compiled)
          snapshot.path
        else ...[
          'run',
          '${root.path}/tool/registry_consumer_cli.dart',
        ],
        ...arguments,
      ],
      workingDirectory: app.path,
      environment: {
        for (final entry in Platform.environment.entries)
          if (entry.key != 'REMIX_REGISTRY_RELEASE_REF' &&
              entry.key != 'REMIX_REGISTRY_ROOT')
            entry.key: entry.value,
        if (compiled || registryRoot != null)
          'REMIX_REGISTRY_ROOT': registryRoot ?? '${root.path}/registry',
      },
      includeParentEnvironment: false,
    );

    test('retains shipped CLI parsing, exits, stdout and stderr', () async {
      final app = Directory('${sandbox.path}/parser');
      await _writeCliConsumer(app);
      for (final arguments in [
        ['--help'],
        ['--version'],
        ['--unknown-option'],
        ['add'],
      ]) {
        final shipped = await Process.run(Platform.resolvedExecutable, [
          'run',
          '${root.path}/packages/remix_cli/bin/remix.dart',
          ...arguments,
        ], workingDirectory: app.path);
        for (final compiled in [false, true]) {
          final result = await runCli(arguments, app: app, compiled: compiled);
          expect(
            [result.exitCode, result.stdout, result.stderr],
            [shipped.exitCode, shipped.stdout, shipped.stderr],
            reason: '${arguments.join(' ')} (compiled: $compiled)',
          );
        }
        expect(
          shipped.exitCode,
          arguments.first.startsWith('--unknown') || arguments.first == 'add'
              ? 64
              : 0,
        );
      }
    });

    for (final preset in ['vanilla', 'fortal']) {
      test('$preset uses an explicit root outside the checkout', () async {
        final trees = <Map<String, String>>[];
        final outputs = <List<Object?>>[];
        for (final compiled in [false, true]) {
          final app = Directory('${sandbox.path}/$compiled');
          await _writeCliConsumer(app);
          final first = await runCli(
            ['init', '--prefix', 'Solo', '--preset', preset],
            app: app,
            compiled: compiled,
          );
          expect(first.exitCode, 0, reason: first.stderr as String);
          expect(first.stdout, 'Initialized remix.yaml and lib/ui/ui.dart.\n');
          expect(first.stderr, isEmpty);
          final before = _cliConsumerFiles(app);
          final again = await runCli(
            ['init', '--prefix', 'Solo', '--preset', preset],
            app: app,
            compiled: compiled,
          );
          expect(again.exitCode, 0, reason: again.stderr as String);
          expect(again.stdout, 'Remix is already initialized.\n');
          expect(again.stderr, isEmpty);
          final dryRun = await runCli(
            ['add', 'icons', '--dry-run'],
            app: app,
            compiled: compiled,
          );
          expect(dryRun.exitCode, 0, reason: dryRun.stderr as String);
          expect(dryRun.stdout, contains('lib/ui/icons.dart'));
          expect(dryRun.stderr, isEmpty);
          final missing = await runCli(
            ['add', 'missing_item', '--dry-run'],
            app: app,
            compiled: compiled,
          );
          expect(missing.exitCode, 1);
          expect(missing.stderr, contains('missing_item'));
          expect(_cliConsumerFiles(app), before);
          trees.add(before);
          outputs.add([
            dryRun.stdout,
            dryRun.stderr,
            missing.stdout,
            missing.stderr,
          ]);
        }
        expect(trees[1], trees[0]);
        expect(outputs[1], outputs[0]);
      });
    }

    test('an invalid explicit root fails without falling back', () async {
      final missingRoot = '${sandbox.path}/no_registry';
      final outputs = <List<Object?>>[];
      for (final compiled in [false, true]) {
        final app = Directory('${sandbox.path}/$compiled');
        await _writeCliConsumer(app);
        final before = _cliConsumerFiles(app);
        final result = await runCli(
          ['init', '--prefix', 'Solo'],
          app: app,
          compiled: compiled,
          registryRoot: missingRoot,
        );
        expect(result.exitCode, 1);
        expect(result.stderr, contains('$missingRoot/index.yaml'));
        expect(_cliConsumerFiles(app), before);
        outputs.add([result.stdout, result.stderr]);
      }
      expect(outputs[1], outputs[0]);
    });

    test('compilation failure reports compiler diagnostics', () async {
      final brokenRoot = Directory('${sandbox.path}/broken');
      final entry = File('${brokenRoot.path}/tool/registry_consumer_cli.dart');
      entry.parent.createSync(recursive: true);
      entry.writeAsStringSync('void main( {\n');
      await expectLater(
        compileRegistryConsumerCli(
          dart: Platform.resolvedExecutable,
          repositoryRoot: brokenRoot,
          outputDirectory: sandbox,
        ),
        throwsA(
          isA<ProcessException>()
              .having((error) => error.errorCode, 'exit', isNot(0))
              .having(
                (error) => error.message,
                'diagnostics',
                contains('Error'),
              ),
        ),
      );
    });
  }, timeout: const Timeout(Duration(minutes: 2)));
}

Future<void> _writeCliConsumer(Directory app) async {
  Directory('${app.path}/lib').createSync(recursive: true);
  File('${app.path}/pubspec.yaml').writeAsStringSync('''
name: cli_fixture
environment:
  sdk: '>=3.12.0 <4.0.0'
dependencies:
  flutter:
    sdk: flutter
''');
  // The consumer harness resolves each minimal app before invoking the CLI.
  // Match that precondition: `dart run` otherwise performs an implicit pub
  // get, while running a kernel snapshot does not.
  final resolved = await Process.run(Platform.resolvedExecutable, [
    'pub',
    'get',
  ], workingDirectory: app.path);
  expect(resolved.exitCode, 0, reason: resolved.stderr as String);
}

Map<String, String> _cliConsumerFiles(Directory app) => {
  for (final file in app.listSync(recursive: true).whereType<File>())
    file.path.substring(app.path.length + 1): file.readAsStringSync(),
};
