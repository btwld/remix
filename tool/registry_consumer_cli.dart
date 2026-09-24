/// Test-only entry point that points the installer at a registry other than
/// the promoted stable branch. The shipped CLI deliberately has no such mode.
import 'dart:io';

import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/registry_reader.dart';
import 'package:remix_cli/src/registry_source.dart';

import '../packages/remix_cli/test/checkout_registry.dart';

Future<void> main(List<String> arguments) async {
  final releaseRef = Platform.environment['REMIX_REGISTRY_RELEASE_REF'];
  exitCode = await runInstallerCli(
    arguments,
    Installer(
      projectRoot: Directory.current,
      writeOut: stdout.writeln,
      sources: releaseRef == null
          ? CheckoutSources(
              Directory.fromUri(Platform.script.resolve('../registry/')),
            )
          : _PublishedSources(releaseRef),
    ),
    writeOut: stdout.writeln,
    writeError: stderr.writeln,
  );
}

/// A promoted ref, the stable branch or a commit SHA, used by the hosted smoke.
final class _PublishedSources implements RegistrySources {
  const _PublishedSources(this.ref);

  final String ref;
  static const _github = GitHubSources();

  @override
  Future<RegistrySource> latestOfficial() =>
      _github.resolve(repository: officialRepository, ref: ref);

  @override
  Future<RegistrySource> resolve({
    required String repository,
    String path = 'registry',
    String? ref,
  }) => _github.resolve(repository: repository, path: path, ref: ref);

  @override
  RegistryReader open(RegistrySource pin, String preset) =>
      _github.open(pin, preset);
}
