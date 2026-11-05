import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:test/test.dart';

import '../../packages/remix_cli/lib/src/cli.dart';
import '../../tool/generate_cli_reference.dart';

void main() {
  final rendered = renderCliReference();

  test('the reference lists every visible command and option', () {
    final runner = remixCommandRunner();
    final missing = <String>[];
    void expectOptions(String owner, ArgParser parser) {
      for (final Option(:name, :hide) in parser.options.values) {
        if (hide || name == 'help') continue;
        if (!rendered.contains('`--$name ') &&
            !rendered.contains('`--$name`') &&
            !rendered.contains('`--[no-]$name')) {
          missing.add('$owner --$name');
        }
      }
    }

    void walk(String path, Command<int> command) {
      if (command.hidden || command.name == 'help') return;
      if (!rendered.contains('# $path\n')) missing.add(path);
      expectOptions(path, command.argParser);
      for (final subcommand in command.subcommands.values) {
        walk('$path ${subcommand.name}', subcommand);
      }
    }

    expectOptions('remix', runner.argParser);
    for (final command in runner.commands.values) {
      walk('remix ${command.name}', command);
    }
    expect(missing, isEmpty);
  });

  group('replaceGeneratedRegion', () {
    test('replaces only the region between the markers', () {
      const before = '---\ntitle: CLI reference\n---\n\nIntro.\n\n';
      const after = '\n\nAfter the region.\n';
      final page =
          '$before$generatedStart\n\n| stale | table |\n\n$generatedEnd$after';

      expect(
        replaceGeneratedRegion(page, rendered),
        '$before$generatedStart\n\n$rendered\n$generatedEnd$after',
      );
    });

    test('rejects a page with a missing or repeated marker', () {
      expect(
        () => replaceGeneratedRegion('no markers here', rendered),
        throwsFormatException,
      );
      expect(
        () => replaceGeneratedRegion(
          '$generatedStart\n$generatedStart\n$generatedEnd\n',
          rendered,
        ),
        throwsFormatException,
      );
    });
  });

  group('checkCliReference', () {
    late Directory workspace;
    late File page;

    setUp(() {
      workspace = Directory.systemTemp.createTempSync('cli_reference_');
      addTearDown(() => workspace.deleteSync(recursive: true));
      page = File('${workspace.path}/$cliReferencePath')
        ..createSync(recursive: true)
        ..writeAsStringSync(
          replaceGeneratedRegion(
            'Intro.\n\n$generatedStart\n$generatedEnd\n',
            rendered,
          ),
        );
    });

    test('passes on a freshly rendered page', () {
      expect(checkCliReference(workspace), isEmpty);
    });

    test('reports an edited region as stale', () {
      page.writeAsStringSync(
        page.readAsStringSync().replaceFirst('| `Ui` |', '| `Acme` |'),
      );
      expect(checkCliReference(workspace), [contains('is stale')]);
    });

    test('reports a missing page', () {
      page.deleteSync();
      expect(checkCliReference(workspace), [contains('is missing')]);
    });
  });

  test('the committed CLI reference matches the parsers', () {
    expect(checkCliReference(Directory.current), isEmpty);
  });
}
