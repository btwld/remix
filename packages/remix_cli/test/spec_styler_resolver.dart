import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/registry_reader.dart';
import 'package:remix_cli/src/registry_source.dart';

import 'checkout_registry.dart';
import 'test_support.dart';

/// The official registry plus `spec_demo`, an item whose source is a
/// `@MixableSpec`.
///
/// The Agent widgets ship in `package:remix/agent.dart`, so no official item
/// installs a spec any more; the installer's scoped builder configuration
/// still has to work for registries that do.
final class SpecStylerResolver implements RegistrySources {
  const SpecStylerResolver();

  static Directory? _overlay;

  /// A copy of the committed `registry/` tree with `spec_demo` added.
  static Directory get distribution => _overlay ??= _copyWithSpecDemo();

  static Directory _copyWithSpecDemo() {
    final source = findCheckoutRegistry();
    final root = Directory.systemTemp.createTempSync('spec_styler_registry_');
    final copy = Directory('${root.path}/registry')..createSync();
    for (final entity in source.listSync(recursive: true)) {
      final relative = p.relative(entity.path, from: source.path);
      if (entity is Directory) {
        Directory('${copy.path}/$relative').createSync(recursive: true);
      } else if (entity is File) {
        entity.copySync('${copy.path}/$relative');
      }
    }
    for (final preset in ['vanilla', 'fortal', 'heroui']) {
      File('${copy.path}/$preset/templates/spec_demo/spec_demo.dart.tmpl')
        ..createSync(recursive: true)
        ..writeAsStringSync('''import 'package:flutter/widgets.dart';
import 'package:mix_annotations/mix_annotations.dart';

part 'spec_demo.g.dart';

@MixableSpec()
final class {{typePrefix}}DemoSpec {
  const {{typePrefix}}DemoSpec();
}
''');
      File('${copy.path}/$preset/registry.yaml').writeAsStringSync('''

  spec_demo:
    dependencies:
      mix_annotations: ^2.2.0-beta.1
    devDependencies:
      build_runner: ^2.10.1
      mix_generator: ^2.2.0-beta.3
    files:
      - source: templates/spec_demo/spec_demo.dart.tmpl
        target: "@ui/components/spec_demo.dart"
    generated:
      - "@ui/components/spec_demo.g.dart"
    exports:
      - components/spec_demo.dart
''', mode: FileMode.append);
    }
    return copy;
  }

  @override
  Future<RegistrySource> latestOfficial() =>
      const FixtureOfficialResolver().latestOfficial();

  @override
  Future<RegistrySource> resolve({
    required String repository,
    String path = 'registry',
    String? ref,
  }) => const FixtureOfficialResolver().resolve(
    repository: repository,
    path: path,
    ref: ref,
  );

  @override
  RegistryReader open(RegistrySource pin, String preset) =>
      CheckoutRegistry(distribution, preset);

  @override
  Future<String?> file(RegistrySource pin, String path) =>
      readCheckoutFile(distribution, path);
}
