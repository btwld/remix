import 'dart:io';

import 'package:test/test.dart';

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

  test('checks chained commands', () {
    expect(check('`remix add button && remix add textfield`'), [
      contains('`textfield`'),
    ]);
  });

  test('unscoped commands must work in every preset', () {
    expect(check('`remix add dialog`'), [contains('heroui registry catalog')]);
  });

  test(
    'follows init across tutorial blocks and checks continued arguments',
    () {
      expect(
        check(r'''
```bash
remix init --preset vanilla
remix add dialog
```
```shell
dart run remix_cli:remix init --preset=heroui
```
```bash
$ remix add modal \
    dialog # unavailable in HeroUI
```
'''),
        [
          allOf(
            contains('example.mdx:9'),
            contains('`dialog`'),
            contains('heroui'),
          ),
        ],
      );
    },
  );

  test('validates explicit preset scopes and official qualified names', () {
    expect(
      check('''
{/* remix-preset: vanilla, fortal */}
`remix add @remix/dialog`
<!-- remix-preset: fortal -->
`remix add base_button`
<!-- remix-preset: heroui -->
`remix add @remix/base_button`
'''),
      [contains('`@remix/base_button` is absent from the heroui registry')],
    );
    expect(check('<!-- remix-preset: unknown -->'), [
      contains('unknown registry preset'),
    ]);
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
}
