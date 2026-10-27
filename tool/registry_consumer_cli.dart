/// Test-only entry point that points the installer at a registry other than
/// the promoted stable branch. The shipped CLI deliberately has no such mode.
import 'dart:io';

import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/registry.dart';
import 'package:remix_cli/src/registry_reader.dart';
import 'package:remix_cli/src/registry_source.dart';

import '../packages/remix_cli/test/checkout_registry.dart';

Future<void> main(List<String> arguments) async {
  final releaseRef = Platform.environment['REMIX_REGISTRY_RELEASE_REF'];
  // A kernel snapshot lives in the checker's temporary directory, so its
  // Platform.script no longer identifies the checkout. Only this test entry
  // point accepts an explicit root; the shipped CLI still uses pinned GitHub.
  final registryRoot = Platform.environment['REMIX_REGISTRY_ROOT'];
  exitCode = await runInstallerCli(
    arguments,
    Installer(
      projectRoot: Directory.current,
      writeOut: stdout.writeln,
      sources: Platform.environment['REMIX_REGISTRY_OWNERSHIP_PROBE'] == '1'
          ? _OwnershipProbeSources(
              Directory.fromUri(Platform.script.resolve('../registry/')),
            )
          : releaseRef == null
          ? CheckoutSources(
              registryRoot == null
                  ? Directory.fromUri(Platform.script.resolve('../registry/'))
                  : Directory(registryRoot),
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

/// An additive registry fixture available only through the checkout harness.
final class _OwnershipProbeSources implements RegistrySources {
  _OwnershipProbeSources(this.distribution);
  final Directory distribution;

  @override
  Future<RegistrySource> latestOfficial() =>
      CheckoutSources(distribution).latestOfficial();

  @override
  Future<RegistrySource> resolve({
    required String repository,
    String path = 'registry',
    String? ref,
  }) async {
    if (repository != 'fixture/addon') throw UnsupportedError(repository);
    return RegistrySource(
      repository: repository,
      path: path,
      ref: ref ?? 'v1',
      revision: '1' * 40,
    );
  }

  @override
  RegistryReader open(RegistrySource pin, String preset) =>
      pin.repository == 'fixture/addon'
      ? _OwnershipProbeRegistry()
      : CheckoutRegistry(distribution, preset);
}

final class _OwnershipProbeRegistry implements RegistryReader {
  @override
  Future<RegistryCatalog> catalog() async => RegistryCatalog.parse('''schema: 2
items:
  extra_button:
    registryDependencies: ["@remix/button"]
    files:
      - source: templates/extra_button.dart.tmpl
        target: '@ui/addons/extra_button.dart'
    generated: ['@ui/addons/extra_button.g.dart']
    exports: [addons/extra_button.dart]
''', preset: 'vanilla');

  @override
  Future<String> template(RegistryFile file) async =>
      '''import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';
import 'package:remix/remix.dart';

import '../components/button.dart';

part 'extra_button.g.dart';

@MixWidget(target: RemixButton.new)
ButtonStyler {{valuePrefix}}ExtraButtonStyle({ButtonStyler style = const ButtonStyler.create()}) =>
    {{valuePrefix}}ButtonStyle(style: style);
''';

  @override
  Future<String> icons() =>
      throw UnsupportedError('No icon placeholders in fixture');
}
