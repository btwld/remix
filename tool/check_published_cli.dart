/// Checks the released CLI against a candidate without test-only transports.
/// Usage: dart run tool/check_published_cli.dart --preset vanilla --ref <40-hex-SHA>
/// Activates and verifies the newest published CLI in the documented major line.
library;

import 'dart:convert';
import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import 'check_open_code.dart'
    show
        registryRemixFloor,
        writeHostedFloorOverride,
        hostedFloorOverrideProblem;
import 'check_pub_floors.dart';
import 'consumer_check_reporting.dart';
import 'install_pins.dart';
import 'open_code_lifecycle.dart';

typedef PublishedCliRunner =
    Future<String?> Function(
      String,
      List<String>, {
      StringSink? capturedOutput,
    });

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
  PubFloorClient? pubClient,
  StringSink? out,
}) async {
  if (!['vanilla', 'fortal', 'heroui'].contains(preset) ||
      !RegExp(r'^[0-9a-f]{40}$').hasMatch(sha)) {
    return 'Expected a supported preset and a full lowercase candidate SHA.';
  }
  final pin = expectedInstallPin(repositoryRoot, 'remix_cli');
  final constraint = VersionConstraint.parse(pin) as VersionRange;
  final http = pubClient ?? IoPubFloorClient();
  final List<Version> published;
  try {
    final response = await http
        .get(Uri.https('pub.dev', '/api/packages/remix_cli'))
        .timeout(const Duration(seconds: 8));
    if (response.statusCode != 200 && response.statusCode != 404) {
      return 'pub.dev preflight for remix_cli failed: HTTP ${response.statusCode}; re-run Promote registry.';
    }
    published = response.statusCode == 404
        ? []
        : [
            for (final release
                in (jsonDecode(response.body) as Map)['versions'] as List)
              if (release['retracted'] != true)
                Version.parse(release['version'] as String),
          ];
  } on Object catch (error) {
    return 'pub.dev preflight for remix_cli failed: $error; re-run Promote registry.';
  } finally {
    if (pubClient == null) http.close();
  }
  // This compatibility proof deliberately ignores the candidate's lower bound:
  // its synchronized docs may already name a release not yet on pub.dev.
  final major = constraint.min!.major;
  final compatible =
      published.where((version) => version.major == major).toList()..sort();
  if (compatible.isEmpty) {
    return 'No published, unretracted remix_cli in major $major on pub.dev; '
        'cannot check the candidate with a released CLI.';
  }
  final selected = compatible.last;
  final warning = documentedCliPinWarning(pin, published);
  if (warning != null) (out ?? stdout).writeln(warning);
  final activation = await run(dart, [
    'pub',
    'global',
    'activate',
    'remix_cli',
    selected.toString(),
  ]);
  if (activation != null) return activation;
  final versionOutput = StringBuffer();
  final versionFailure = await run(dart, [
    'pub',
    'global',
    'run',
    'remix_cli:remix',
    '--version',
  ], capturedOutput: versionOutput);
  if (versionFailure != null) return versionFailure;
  final Version version;
  try {
    version = Version.parse(versionOutput.toString().trim());
  } on FormatException {
    return 'Could not determine activated remix_cli version from '
        '`remix --version`: "$versionOutput"; expected published version $selected.';
  }
  (out ?? stdout).writeln(
    'Activated remix_cli $version (documented constraint $pin).',
  );
  if (version != selected) {
    return 'Activated remix_cli $version does not match selected published version $selected.';
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

/// Documentation readiness is separate from released-CLI compatibility. The
/// shared pin tracks the candidate pubspec; warn until a published version can
/// satisfy it, allowing promotion before the candidate's CLI tag is published.
String? documentedCliPinWarning(String pin, Iterable<Version> published) {
  final constraint = VersionConstraint.parse(pin) as VersionRange;
  if (published.any(constraint.allows)) return null;
  return 'WARNING: documented remix_cli pin $pin has no published satisfier; '
      'candidate ${constraint.min} satisfies it when published. '
      'Publish that CLI before advertising the new install pin. '
      'Registry promotion continues with the newest published CLI.';
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
        run: (command, args, {capturedOutput}) => reporter.run(
          lifecycle.processes,
          command,
          args,
          workingDirectory: app.existsSync() ? app.path : parent.path,
          capturedOutput: capturedOutput,
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
