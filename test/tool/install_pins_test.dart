import 'dart:io';

import 'package:test/test.dart';

import '../../tool/install_pins.dart';

void main() {
  group('installCommands', () {
    test('reads pins from the pub add and global activate spellings', () {
      const source = '''
flutter pub add remix:^1.0.0-beta.16
flutter pub add 'dev:remix_cli:^1.0.0-beta.1'
flutter pub add "remix_ui_icons:^1.0.0-beta.1"
dart pub global activate remix_cli '^1.0.0-beta.1'
''';

      final commands = installCommands(source);

      expect(commands.map((c) => (c.package, c.constraint?.text)), [
        ('remix', '^1.0.0-beta.16'),
        ('remix_cli', '^1.0.0-beta.1'),
        ('remix_ui_icons', '^1.0.0-beta.1'),
        ('remix_cli', '^1.0.0-beta.1'),
      ]);
      for (final command in commands) {
        final constraint = command.constraint!;
        expect(
          source.substring(constraint.start, constraint.end),
          constraint.text,
        );
      }
    });

    test('reports an unversioned install as a null constraint', () {
      const source = '''
For base widgets: `flutter pub add remix`, then import the package.

```bash
flutter pub add dev:remix_cli
dart pub global activate remix_cli
remix <command>
```
''';

      final commands = installCommands(source);

      expect(commands.map((c) => (c.package, c.constraint)), [
        ('remix', null),
        ('remix_cli', null),
        ('remix_cli', null),
      ]);
      for (final command in commands) {
        expect(source.substring(command.start), startsWith('pub '));
      }
    });

    test('ignores path dependencies, other packages, and Git activation', () {
      const source = '''
dart pub add "dev:remix_cli@{path: /path/to/remix/packages/remix_cli}"
flutter pub add "remix:{path: /path/to/remix/packages/remix}"
flutter pub add "remix_ui_fonts:^0.1.0"
flutter pub add remix_cli_helper
dart pub global activate --source git https://github.com/btwld/remix.git \\
  --git-path packages/remix_cli --git-ref main
''';

      expect(installCommands(source), isEmpty);
    });
  });

  group('checkReleaseState', () {
    const pins = {
      'remix': '^1.0.0-beta.16',
      'remix_cli': '^1.0.0-beta.1',
      'remix_ui_icons': '^1.0.0-beta.1',
    };

    test('accepts pinned commands', () {
      final failures = <String>[];

      checkReleaseState(
        'flutter pub add remix:^1.0.0-beta.16\n',
        'docs/example.mdx',
        pins,
        failures,
      );

      expect(failures, isEmpty);
    });

    test('reports missing pins, stale pins, and staging prose', () {
      final failures = <String>[];

      checkReleaseState(
        '''
flutter pub add dev:remix_cli
flutter pub add remix:^1.0.0-beta.14
This checkout is unpublished and not published yet.
''',
        'docs/example.mdx',
        pins,
        failures,
      );

      expect(
        failures,
        containsAll([
          contains('installs remix_cli without a version'),
          contains('pins remix ^1.0.0-beta.14'),
          contains('says "unpublished"'),
          contains('says "not published yet"'),
          contains('says "This checkout"'),
        ]),
      );
    });
  });

  group('sync_install_pins', () {
    final tool = File('tool/sync_install_pins.dart').absolute.path;
    late Directory sandbox;

    void write(String path, String content) {
      File('${sandbox.path}/$path')
        ..parent.createSync(recursive: true)
        ..writeAsStringSync(content);
    }

    String read(String path) =>
        File('${sandbox.path}/$path').readAsStringSync();

    ProcessResult sync() => Process.runSync(Platform.resolvedExecutable, [
      tool,
    ], workingDirectory: sandbox.path);

    setUp(() {
      sandbox = Directory.systemTemp.createTempSync('remix_install_pins_');
      write('pubspec.yaml', 'name: remix_workspace\n');
      write('packages/remix/pubspec.yaml', 'version: 1.0.0-beta.16\n');
      write('packages/remix_cli/pubspec.yaml', 'version: 1.0.0-beta.1\n');
      write('packages/remix_ui_icons/pubspec.yaml', 'version: 1.0.0-beta.1\n');
      for (final directory in publishedSkillDirectories) {
        Directory('${sandbox.path}/$directory').createSync(recursive: true);
      }
      for (final relative in skillEvalRelativePaths) {
        write(relative, '{}\n');
      }
      write(
        'skills/using-remix/evals/evals.json',
        '{"expected_output":"flutter pub add dev:remix_cli:^1.0.0-beta.0 '
            'then remix init"}\n',
      );
      for (final file in consumerDocumentationFiles) {
        write(file, '# Placeholder\n');
      }
      write('docs/getting-started.mdx', '''
---
title: Getting started
---

```bash
flutter pub add remix:^1.0.0-beta.14
flutter pub add dev:remix_cli
```
''');
      write('packages/remix_cli/README.md', '''
# remix_cli

```shell
flutter pub add 'dev:remix_cli:^1.0.0-beta.0'
dart pub global activate remix_cli '^1.0.0-beta.0'
dart pub add "dev:remix_cli@{path: /path/to/remix/packages/remix_cli}"
```
''');
    });

    tearDown(() => sandbox.deleteSync(recursive: true));

    test('rewrites stale pins, keeps unversioned and path commands', () {
      final result = sync();

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect(
        read('docs/getting-started.mdx'),
        contains('remix:^1.0.0-beta.16'),
      );
      expect(
        read('docs/getting-started.mdx'),
        contains('pub add dev:remix_cli\n'),
      );
      expect(
        read('packages/remix_cli/README.md'),
        contains("'dev:remix_cli:^1.0.0-beta.1'"),
      );
      expect(
        read('packages/remix_cli/README.md'),
        contains("activate remix_cli '^1.0.0-beta.1'"),
      );
      expect(
        read('packages/remix_cli/README.md'),
        contains('"dev:remix_cli@{path: /path/to/remix/packages/remix_cli}"'),
      );
      expect(
        '${result.stdout}',
        contains('remix ^1.0.0-beta.14 -> ^1.0.0-beta.16'),
      );
      expect(
        read('skills/using-remix/evals/evals.json'),
        contains('dev:remix_cli:^1.0.0-beta.1'),
      );
    });

    test('is a no-op the second time', () {
      sync();
      final before = read('docs/getting-started.mdx');

      final result = sync();

      expect(result.exitCode, 0, reason: '${result.stderr}');
      expect(read('docs/getting-started.mdx'), before);
      expect('${result.stdout}', contains('already match'));
    });
  });
}
