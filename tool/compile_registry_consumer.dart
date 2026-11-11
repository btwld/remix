/// Compiles the checkout-only CLI once without sharing installer state.
library;

import 'dart:io';

import 'open_code_lifecycle.dart';
import 'consumer_check_reporting.dart';

Future<File> compileRegistryConsumerCli({
  required String dart,
  required Directory repositoryRoot,
  required Directory outputDirectory,
  Map<String, String>? environment,
  OpenCodeProcesses? processes,
  ConsumerCheckReporter? reporter,
}) async {
  final snapshot = File('${outputDirectory.path}/registry_consumer_cli.dill');
  final arguments = [
    'compile',
    'kernel',
    '${repositoryRoot.path}/tool/registry_consumer_cli.dart',
    '-o',
    snapshot.path,
  ];
  if (reporter != null) {
    final problem = await reporter.run(
      processes ?? OpenCodeProcesses(),
      dart,
      arguments,
      workingDirectory: repositoryRoot.path,
      environment: environment,
      step: 'compile CLI',
    );
    if (problem != null || !snapshot.existsSync()) {
      throw ProcessException(
        dart,
        arguments,
        problem ?? 'CLI compilation produced no snapshot.',
        1,
      );
    }
    return snapshot;
  }
  final run = processes?.run ?? Process.run;
  final result = await run(
    dart,
    arguments,
    workingDirectory: repositoryRoot.path,
    environment: environment,
  );
  if (result.exitCode != 0 || !snapshot.existsSync()) {
    throw ProcessException(
      dart,
      arguments,
      'Could not compile the registry consumer CLI.\n'
      '${result.stdout}${result.stderr}',
      result.exitCode == 0 ? 1 : result.exitCode,
    );
  }
  return snapshot;
}
