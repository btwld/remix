/// Checks the released CLI against a candidate without test-only transports.
/// Usage: dart run tool/check_published_cli.dart --preset vanilla --ref <40-hex-SHA>
/// First activate the published package: dart pub global activate remix_cli.
library;

import 'dart:io';

import 'package:yaml/yaml.dart';

import 'check_open_code.dart'
    show
        registryRemixFloor,
        writeHostedFloorOverride,
        hostedFloorOverrideProblem;
import 'consumer_check_reporting.dart';
import 'open_code_lifecycle.dart';

typedef PublishedCliRunner = Future<String?> Function(String, List<String>);

/// Production sequence exposed to fakes: use only the globally activated
/// published executable. In particular, no checkout CLI or harness can enter it.
Future<String?> checkPublishedCliCandidate({
  required Directory app,
  required Directory repositoryRoot,
  required String preset,
  required String sha,
  required String dart,
  required String flutter,
  required PublishedCliRunner run,
}) async {
  if (!['vanilla', 'fortal', 'heroui'].contains(preset) ||
      !RegExp(r'^[0-9a-f]{40}$').hasMatch(sha)) {
    return 'Expected a supported preset and a full lowercase candidate SHA.';
  }
  final create = await run(flutter, [
    'create',
    '--empty',
    '--no-pub',
    '--platforms=web',
    '--project-name',
    'published_cli_fixture',
    app.path,
  ]);
  if (create != null) return create;
  final floor = registryRemixFloor(repositoryRoot, preset);
  writeHostedFloorOverride(app, floor: floor);
  final items = preset == 'heroui'
      ? ['search_field', 'button']
      : ['dashboard_shell', 'button'];
  for (final command in [
    ['pub', 'get'],
    [
      'pub',
      'global',
      'run',
      'remix_cli:remix',
      'init',
      '--prefix',
      'Released',
      '--preset',
      preset,
    ],
    [
      'pub',
      'global',
      'run',
      'remix_cli:remix',
      'registry',
      'update',
      '@remix',
      '--ref',
      sha,
    ],
    ['pub', 'global', 'run', 'remix_cli:remix', 'add', ...items],
    ['analyze', 'lib/ui'],
  ]) {
    final failure = await run(dart, command);
    if (failure != null) return failure;
    if (command.contains('update')) {
      final config =
          loadYaml(File('${app.path}/remix.yaml').readAsStringSync())
              as YamlMap;
      if (config['registries']['@remix']['revision'] != sha) {
        return 'Published CLI did not pin @remix to candidate $sha.';
      }
    }
  }
  return hostedFloorOverrideProblem(app, floor: floor);
}

Future<void> main(List<String> arguments) async {
  if (arguments.length != 4 ||
      arguments[0] != '--preset' ||
      arguments[2] != '--ref' ||
      !['vanilla', 'fortal', 'heroui'].contains(arguments[1]) ||
      !RegExp(r'^[0-9a-f]{40}$').hasMatch(arguments[3])) {
    stderr.writeln(
      'Usage: dart run tool/check_published_cli.dart --preset vanilla|fortal|heroui --ref <40-hex-SHA>',
    );
    exitCode = 64;
    return;
  }
  final preset = arguments[1];
  final repositoryRoot = Directory.current.absolute;
  final lifecycle = OpenCodeLifecycle(
    repositoryRoot: repositoryRoot,
    keep: false,
  );
  final summary = Platform.environment['GITHUB_STEP_SUMMARY'];
  final reporter = ConsumerCheckReporter(
    out: stdout,
    err: stderr,
    githubActions: Platform.environment['GITHUB_ACTIONS'] == 'true',
    summaryFile: summary == null ? null : File(summary),
  );
  lifecycle.watchSignals();
  reporter.startPhase('Published CLI ($preset)');
  try {
    await lifecycle.sweep();
    final failure = await lifecycle.run<String>((parent) async {
      final app = Directory('${parent.path}/app');
      return checkPublishedCliCandidate(
        app: app,
        repositoryRoot: repositoryRoot,
        preset: preset,
        sha: arguments[3],
        dart: Platform.resolvedExecutable,
        flutter: 'flutter',
        run: (command, args) => reporter.run(
          lifecycle.processes,
          command,
          args,
          workingDirectory: app.existsSync() ? app.path : parent.path,
        ),
      );
    });
    if (failure != null || lifecycle.cleanupProblem != null) {
      reporter.failure(failure ?? lifecycle.cleanupProblem!);
      exitCode = 1;
    }
  } on OpenCodeCancelled {
    exitCode = lifecycle.processes.cancellationExitCode!;
  } on Object catch (error, stackTrace) {
    reporter.failure(
      'Published CLI candidate check failed: $error\n$stackTrace',
    );
    exitCode = 1;
  } finally {
    try {
      await lifecycle.close();
    } finally {
      reporter.finish('Published CLI: $preset');
    }
  }
}
