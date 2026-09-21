/// Reads a registry distribution straight off the filesystem.
///
/// Test-only: the shipped CLI reads through a pinned commit and nothing else.
/// This exists so the suite and the repository's own consumer harness can
/// exercise the registry bytes in *this* checkout, which is the version a
/// change is actually proposing, rather than whatever is published.
library;

import 'dart:io';

import 'package:remix_cli/src/registry.dart';
import 'package:remix_cli/src/registry_reader.dart';
import 'package:remix_cli/src/registry_source.dart';

/// The committed `registry/` directory of the repository containing [start].
///
/// Callers run from varying working directories -- the package root under
/// `dart test`, the workspace root under `dart run` -- so the tree is found by
/// walking up to the checkout that holds it rather than by a fixed hop count.
Directory findCheckoutRegistry([Directory? start]) {
  for (
    var directory = (start ?? Directory.current).absolute;
    ;
    directory = directory.parent
  ) {
    final candidate = Directory('${directory.path}/registry');
    if (File('${candidate.path}/index.yaml').existsSync()) return candidate;
    if (directory.path == directory.parent.path) {
      throw StateError(
        'No registry/index.yaml above ${(start ?? Directory.current).path}.',
      );
    }
  }
}

/// One preset of an on-disk distribution.
final class CheckoutRegistry implements RegistryReader {
  CheckoutRegistry(this.distribution, this.preset);

  final Directory distribution;
  final String preset;

  /// The preset's own directory, resolved through the committed index so the
  /// checkout and the published distribution use one layout rule.
  late final Future<Uri> _catalogUri = _resolveCatalogUri();

  Future<Uri> _resolveCatalogUri() async => distribution.uri.resolve(
    catalogPathForPreset(
      await _readUri(distribution.uri.resolve('index.yaml')),
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

  Future<String> _readUri(Uri uri) {
    final file = File.fromUri(uri);
    if (!file.existsSync()) {
      throw FormatException('Checkout registry has no ${file.path}.');
    }
    return file.readAsString();
  }
}

/// Serves the on-disk distribution in place of a published release.
final class CheckoutSources implements RegistrySources {
  CheckoutSources(this.distribution);

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
      CheckoutRegistry(distribution, preset);
}
