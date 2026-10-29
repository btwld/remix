/// Compiles the checkout-only CLI once without sharing installer state.
library;

import 'dart:io';

Future<File> compileRegistryConsumerCli({
  required String dart,
  required Directory repositoryRoot,
  required Directory outputDirectory,
  Map<String, String>? environment,
}) async {
  final snapshot = File('${outputDirectory.path}/registry_consumer_cli.dill');
  final arguments = [
    'compile',
    'kernel',
    '${repositoryRoot.path}/tool/registry_consumer_cli.dart',
    '-o',
    snapshot.path,
  ];
  final result = await Process.run(
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
