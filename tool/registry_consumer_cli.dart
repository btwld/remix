/// Test-only entry point that points the installer at a registry other than a
/// published GitHub release. The shipped CLI deliberately has no such mode.
import 'dart:io';

import '../packages/remix_cli/lib/src/installer.dart';
import '../packages/remix_cli/lib/src/registry.dart';
import '../packages/remix_cli/lib/src/registry_reader.dart';
import '../packages/remix_cli/lib/src/registry_source.dart';

Future<void> main(List<String> arguments) async {
  final releaseRef = Platform.environment['REMIX_REGISTRY_RELEASE_REF'];
  exitCode = await runInstallerCli(
    arguments,
    Installer(
      projectRoot: Directory.current,
      writeOut: stdout.writeln,
      sources: releaseRef == null
          ? _CheckoutSources(
              Directory.fromUri(Platform.script.resolve('../registry/')),
            )
          : _PublishedSources(releaseRef),
    ),
    writeOut: stdout.writeln,
    writeError: stderr.writeln,
  );
}

/// The committed `registry/` tree in this checkout, read straight from disk.
final class _CheckoutSources implements RegistrySources {
  const _CheckoutSources(this.distribution);

  final Directory distribution;

  /// Schema 3 always records a commit, so a checkout that has none still has
  /// to write a placeholder. Nothing reads it back: [open] ignores the pin.
  @override
  Future<RegistrySource> latestOfficial() async => RegistrySource(
    repository: officialRepository,
    path: 'registry',
    ref: 'checkout',
    revision: '0' * 40,
  );

  @override
  Future<RegistrySource> resolve({
    required String repository,
    String path = 'registry',
    String? ref,
  }) async => throw UnsupportedError(
    'The checkout harness cannot resolve $repository; it serves only the '
    'committed registry/ tree.',
  );

  @override
  RegistryReader open(RegistrySource pin, String preset) =>
      _CheckoutRegistry(distribution, preset);
}

final class _CheckoutRegistry implements RegistryReader {
  _CheckoutRegistry(this.distribution, this.preset);

  final Directory distribution;
  final String preset;

  /// The preset's own directory, resolved through the committed index so the
  /// checkout and the published distribution use one layout rule.
  late final Future<Uri> _catalogUri = _resolveCatalogUri();

  Future<Uri> _resolveCatalogUri() async => distribution.uri.resolve(
    catalogPathForPreset(
      await _read('index.yaml'),
      preset: preset,
      origin: 'checkout',
    ),
  );

  @override
  Future<RegistryCatalog> catalog() async =>
      RegistryCatalog.parse(await _readUri(await _catalogUri), preset: preset);

  @override
  Future<String> template(RegistryFile file) async =>
      _readUri((await _catalogUri).resolve(file.source));

  Future<String> _read(String relative) =>
      _readUri(distribution.uri.resolve(relative));

  Future<String> _readUri(Uri uri) {
    final file = File.fromUri(uri);
    if (!file.existsSync()) {
      throw FormatException('Checkout registry has no ${file.path}.');
    }
    return file.readAsString();
  }
}

/// A real published release, used by the post-release smoke check.
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
