import 'dart:io';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../../tool/docs_registry_commands.dart';

void main() {
  final catalogs = {
    'vanilla': {'button', 'text_field', 'dialog'},
    'fortal': {'button', 'text_field', 'dialog', 'base_button'},
    'heroui': {'button', 'text_field', 'modal'},
  };

  List<String> check(String source) =>
      checkRegistryCommands(source, 'example.mdx', catalogs);

  test('checks each literal argument, including after a flag', () {
    expect(check('Install with `remix add button --diff textfield`.'), [
      contains('example.mdx:1: `remix add` item `textfield`'),
    ]);
  });

  test('unscoped commands must work in every preset', () {
    expect(check('`remix add dialog`'), [contains('heroui registry catalog')]);
  });

  test('init sets the preset only within its shell block', () {
    expect(
      check(r'''
```bash
remix init --preset vanilla
remix add dialog
```
```shell
$ remix add dialog # this is a general example
```
`remix add dialog`
'''),
      [
        allOf(contains('example.mdx:6'), contains('heroui registry catalog')),
        allOf(contains('example.mdx:8'), contains('heroui registry catalog')),
      ],
    );
  });

  test('validates explicit preset scopes and official qualified names', () {
    expect(
      check('''
{/* remix-preset: vanilla */}
`remix add @remix/dialog`
```shell
dart run remix_cli:remix init --preset=heroui
remix add "modal" @remix/dialog
```
`remix add dialog`
<!-- remix-preset: fortal -->
`remix add base_button`
'''),
      [contains('`@remix/dialog` is absent from the heroui registry')],
    );
    expect(check('<!-- remix-preset: unknown -->'), [
      contains('unknown registry preset'),
    ]);
  });

  test('ignores shell redirections without skipping later item IDs', () {
    expect(
      check('''
```bash
remix add button > install.log 2>&1
remix add button 2> errors.log < input
remix add button>>"install log" --diff textfield
```
'''),
      [contains('example.mdx:4: `remix add` item `textfield`')],
    );
  });

  test('skips placeholders and external IDs; handles annotated CLI help', () {
    expect(
      check(r'''
`remix add <item>` or `remix add @acme/custom --dry-run`
```bash
remix add "$items" --diff
```
```text
  remix add button      Install button and what it needs.
  remix add textfield   An outdated CLI help example.
```
'''),
      [contains('`textfield`')],
    );
  });

  test(
    'reads each catalog from the registry index rather than a fixed path',
    () {
      final root = Directory.systemTemp.createTempSync('docs-registry-');
      addTearDown(() => root.deleteSync(recursive: true));
      Directory('${root.path}/registry').createSync();
      File(
        '${root.path}/registry/index.yaml',
      ).writeAsStringSync('presets:\n  test_preset: custom.yaml\n');
      File(
        '${root.path}/registry/custom.yaml',
      ).writeAsStringSync('items:\n  theme: {}\n  text_field: {}\n');
      final failures = <String>[];
      expect(readRegistryItems(root, failures), {
        'test_preset': {'theme', 'text_field'},
      });
      expect(failures, isEmpty);
    },
  );

  test('the switching guide names each official icon library', () {
    final catalog =
        loadYaml(File('registry/icons.yaml').readAsStringSync()) as YamlMap;
    final libraries = (catalog['libraries'] as YamlMap).keys;
    final readme = File('packages/remix_cli/README.md').readAsStringSync();
    final guide = readme
        .split('\n### ')
        .singleWhere(
          (section) => section.startsWith('Switch icon libraries\n'),
        );
    for (final library in libraries) {
      expect(guide, contains('`$library`'));
    }
  });
}
