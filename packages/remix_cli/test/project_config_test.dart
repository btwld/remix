import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/project_config.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  late Directory root;

  setUp(() => root = createFlutterPackage());
  tearDown(() => root.deleteSync(recursive: true));

  final source = RegistrySource(
    repository: 'owner/repo',
    path: 'registry',
    ref: 'v1',
    revision: 'b' * 40,
  );

  ProjectConfig configure({
    required Directory packageRoot,
    String prefix = 'Ui',
    String preset = 'vanilla',
    String uiPath = 'lib/ui',
    String defaultRegistry = '@company',
    Map<String, RegistrySource>? registries,
  }) => ProjectConfig(
    packageRoot: packageRoot,
    prefix: prefix,
    preset: preset,
    uiPath: uiPath,
    defaultRegistry: defaultRegistry,
    registries: registries ?? {'@company': source},
  );

  test('parses the exact schema 3 shape', () {
    final config = ProjectConfig.parse('''schema: 3
prefix: Acme
preset: vanilla
paths:
  ui: lib/design_system
defaultRegistry: "@remix"
registries:
  "@remix":
    repository: "conceptadev/remix"
    path: "registry"
    ref: "registry-v1"
    revision: "${'a' * 40}"
''', packageRoot: root);

    expect(config.prefix, 'Acme');
    expect(config.valuePrefix, 'acme');
    expect(config.preset, 'vanilla');
    expect(config.uiPath, 'lib/design_system');
    expect(config.defaultRegistry, '@remix');
    expect(config.registries.keys, ['@remix']);
    expect(config.registries['@remix']!.ref, 'registry-v1');
    expect(config.schema, supportedProjectSchema);
  });

  // Schemas 1 and 2 shipped in prereleases and read from a snapshot inside the
  // CLI. That snapshot is gone, so there is no source such a project could be
  // served from -- the parse has to say so instead of failing on a missing key.
  test('rejects the prerelease schemas by naming the way forward', () {
    for (final source in [
      'schema: 1\nprefix: Ui\npaths:\n  ui: lib/ui\n',
      'schema: 2\nprefix: Ui\npreset: vanilla\npaths:\n  ui: lib/ui\n',
    ]) {
      expect(
        () => ProjectConfig.parse(source, packageRoot: root),
        throwsA(
          isA<FormatException>().having(
            (error) => error.message,
            'message',
            allOf(contains('schema'), contains('remix init')),
          ),
        ),
        reason: source,
      );
    }
  });

  test('preset and prefix names YAML reads as keywords round-trip', () {
    // Both grammars admit `true`, `NULL` and friends. Written unquoted, YAML
    // reads them back as a boolean or null and the parser rejects the project,
    // so a successful rewrite would leave it unreadable.
    Directory(p.join(root.path, 'lib', 'ui')).createSync(recursive: true);

    for (final preset in ['true', 'false', 'null', 'acme_dark']) {
      final encoded = configure(packageRoot: root, preset: preset).encode();
      expect(
        ProjectConfig.parse(encoded, packageRoot: root).preset,
        preset,
        reason: encoded,
      );
    }

    for (final prefix in ['TRUE', 'FALSE', 'NULL', 'Acme']) {
      final encoded = configure(packageRoot: root, prefix: prefix).encode();
      expect(
        ProjectConfig.parse(encoded, packageRoot: root).prefix,
        prefix,
        reason: encoded,
      );
    }
  });

  test('the default registry must name a configured one', () {
    Directory(p.join(root.path, 'lib', 'ui')).createSync(recursive: true);

    expect(
      () => configure(packageRoot: root, defaultRegistry: '@missing'),
      throwsFormatException,
    );

    // A registry names its own presets, so the CLI holds a preset to its
    // grammar and leaves membership to the registry that serves it.
    expect(
      configure(packageRoot: root, preset: 'acme_dark').preset,
      'acme_dark',
    );
  });

  test('rejects invalid and reserved prefixes', () {
    for (final prefix in ['', 'ui', '_Ui', 'Ui-name', 'Üi', 'Class', 'Is']) {
      expect(
        () => configure(packageRoot: root, prefix: prefix),
        throwsFormatException,
        reason: prefix,
      );
    }
  });

  test('rejects unknown, missing, and unsupported config fields', () {
    for (final source in [
      // No `registries`, so nothing says where the source came from.
      'schema: 3\nprefix: Ui\npreset: vanilla\npaths:\n  ui: lib/ui\n',
      'schema: 4\nprefix: Ui\npreset: vanilla\npaths:\n  ui: lib/ui\n',
      'schema: 3\npreset: vanilla\npaths:\n  ui: lib/ui\n',
      'schema: 3\nprefix: Ui\npreset: vanilla\npaths:\n  ui: lib/ui\nstyle: new\n',
      'schema: 3\nprefix: Ui\npreset: vanilla\npaths:\n'
          '  ui: lib/ui\n  extra: lib/x\n',
    ]) {
      expect(
        () => ProjectConfig.parse(source, packageRoot: root),
        throwsFormatException,
        reason: source,
      );
    }
  });

  test('rejects preset names outside the identifier grammar', () {
    for (final preset in ['', 'Default', 'default-name', 'acme dark']) {
      expect(
        () => configure(packageRoot: root, preset: preset),
        throwsFormatException,
        reason: preset,
      );
    }
  });

  test('rejects absolute, unnormalized, traversing, and non-lib UI paths', () {
    for (final uiPath in [
      '/lib/ui',
      'lib/../outside',
      'lib/ui/',
      '../lib/ui',
      r'lib\ui',
      'assets/ui',
      'lib',
    ]) {
      expect(
        () => configure(packageRoot: root, uiPath: uiPath),
        throwsFormatException,
        reason: uiPath,
      );
    }
  });

  test('rejects a symlink chain that escapes the package root', () {
    final outside = Directory.systemTemp.createTempSync('remix_cli_outside_');
    addTearDown(() => outside.deleteSync(recursive: true));
    Link(p.join(root.path, 'lib', 'ui')).createSync(outside.path);

    expect(() => configure(packageRoot: root), throwsFormatException);
  });

  test('encoded configuration round-trips YAML-significant UI paths', () {
    for (final uiPath in ['lib/ui #brand', 'lib/ui: brand']) {
      final encoded = configure(packageRoot: root, uiPath: uiPath).encode();
      final reparsed = ProjectConfig.parse(encoded, packageRoot: root);

      expect(reparsed.uiPath, uiPath, reason: encoded);
    }
  });
}
