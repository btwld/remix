import 'dart:async';
import 'dart:io';

import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/process_runner.dart';
import 'package:remix_cli/src/version.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import 'checkout_registry.dart';

/// Usage for [arguments], including the shapes args prints with `print()`.
Future<String> _usage(List<String> arguments) async {
  final printed = <String>[];
  final code = await runZoned(
    () => runRemixCli(arguments, writeOut: printed.add, writeError: fail),
    zoneSpecification: ZoneSpecification(
      print: (_, _, _, line) => printed.add(line),
    ),
  );
  expect(code, successExitCode, reason: arguments.join(' '));
  return printed.join('\n');
}

void main() {
  group('help', () {
    test('describes every option and flag', () async {
      final undescribed = RegExp(
        r'^\s*(-\w, )?--[\w-]+(=<[^>]+>)?\s*(\(defaults to [^)]*\))?$',
        multiLine: true,
      );
      for (final command in [
        ['init'],
        ['add'],
        ['list'],
        ['registry', 'add'],
        ['registry', 'update'],
      ]) {
        final usage = await _usage([...command, '--help']);
        expect(usage, contains('    --'), reason: command.join(' '));
        expect(
          undescribed.allMatches(usage).map((match) => match[0]),
          isEmpty,
          reason: command.join(' '),
        );
      }
    });

    test('shows what to type for each command', () async {
      expect(
        await _usage(['help', 'add']),
        allOf(
          contains('Usage: remix add <item...> [options]'),
          contains('Examples:\n  remix add button '),
          contains('remix add button --diff --exit-code '),
        ),
      );
      expect(
        await _usage(['help', 'init']),
        allOf(
          contains('Usage: remix init [options]'),
          contains('Examples:\n  remix init '),
        ),
      );
      expect(
        await _usage(['help', 'registry']),
        contains('Examples:\n  remix registry add @acme --repository '),
      );
      expect(
        await _usage(['registry', 'add', '--help']),
        contains(
          'Usage: remix registry add <@namespace> --repository <owner/repo>',
        ),
      );
      expect(
        await _usage(['--help']),
        allOf(
          contains('Get started:\n  remix init '),
          contains('\n  remix list '),
          contains('\n  list       List the items you can add'),
        ),
      );
      expect(
        await _usage(['help', 'list']),
        contains('Usage: remix list [options]'),
      );
    });

    test('init lists the official presets without restricting them', () async {
      final usage = await _usage(['help', 'init']);
      for (final MapEntry(key: preset, value: summary)
          in officialPresets.entries) {
        expect(usage, contains(RegExp('\\[$preset\\].* $summary')));
      }
    });

    test('officialPresets follows the checkout index, in order', () {
      final index =
          loadYaml(
                File(
                  '${findCheckoutRegistry().path}/index.yaml',
                ).readAsStringSync(),
              )
              as YamlMap;

      expect(
        officialPresets.keys.toList(),
        (index['presets'] as YamlMap).keys.toList(),
      );
    });
  });

  test('--help prints usage successfully', () async {
    final output = <String>[];

    final code = await runRemixCli(
      ['--help'],
      writeOut: output.add,
      writeError: fail,
    );

    expect(code, successExitCode);
    expect(output.join('\n'), contains('Usage: remix <command>'));
  });

  test('bare help prints usage exactly once', () async {
    final output = <String>[];

    final code = await runRemixCli(
      ['help'],
      writeOut: output.add,
      writeError: fail,
    );

    expect(code, successExitCode);
    expect(
      'Usage: remix <command>'.allMatches(output.join('\n')).length,
      1,
      reason: 'CommandRunner help plus the null-result fallback printed twice.',
    );
  });

  test('command help is routed through the injected writer', () async {
    final output = <String>[];

    final code = await runRemixCli(
      ['init', '--help'],
      writeOut: output.add,
      writeError: fail,
    );

    expect(code, successExitCode);
    expect(output.join('\n'), contains('Usage: remix init'));
  });

  test('help after command arguments prints command usage once', () async {
    for (final arguments in [
      ['add', 'button', '--help'],
      ['init', '--prefix', 'Acme', '--help'],
    ]) {
      final result = await Process.run(Platform.resolvedExecutable, [
        'run',
        'bin/remix.dart',
        ...arguments,
      ]);

      expect(result.exitCode, successExitCode);
      expect(result.stderr, isEmpty);
      expect('Usage: remix '.allMatches(result.stdout as String), hasLength(1));
      expect(result.stdout, contains('Usage: remix ${arguments.first}'));
      expect(result.stdout, isNot(contains('Usage: remix <command>')));
    }
  });

  test('missing and unknown commands are usage errors', () async {
    final errors = <String>[];

    expect(
      await runRemixCli([], writeOut: fail, writeError: errors.add),
      usageExitCode,
    );
    expect(errors.join('\n'), contains('Usage: remix <command>'));

    errors.clear();
    expect(
      await runRemixCli(['unknown'], writeOut: fail, writeError: errors.add),
      usageExitCode,
    );
    expect(errors.join('\n'), contains('Could not find a command named'));
  });

  test('help for a misspelled list suggests it', () async {
    final errors = <String>[];

    final code = await runRemixCli(
      ['help', 'lsit'],
      writeOut: fail,
      writeError: errors.add,
    );

    expect(code, usageExitCode);
    expect(
      errors.first,
      'Could not find a command named "lsit".\nDid you mean list or init?',
    );
  });

  test('list dispatches its output mode', () async {
    ListOptions? received;

    final code = await runRemixCli(
      ['list', '--json'],
      writeOut: fail,
      writeError: fail,
      onList: (options) async => received = options,
    );

    expect(code, successExitCode);
    expect(received!.json, isTrue);
  });

  test('help for a misspelled command suggests the near one', () async {
    final errors = <String>[];

    final code = await runRemixCli(
      ['help', 'ad'],
      writeOut: fail,
      writeError: errors.add,
    );

    expect(code, usageExitCode);
    expect(
      errors.first,
      'Could not find a command named "ad".\nDid you mean add?',
    );
  });

  test('--version agrees with pubspec.yaml', () async {
    final output = <String>[];
    final pubspec =
        loadYaml(File('pubspec.yaml').readAsStringSync()) as YamlMap;

    final code = await runRemixCli(
      ['--version'],
      writeOut: output.add,
      writeError: fail,
    );

    expect(code, successExitCode);
    expect(output, [pubspec['version']]);
  });

  test('init dispatches parsed defaults and custom values', () async {
    InitOptions? received;
    Future<void> onInit(InitOptions options) async => received = options;

    expect(
      await runRemixCli(
        ['init'],
        writeOut: fail,
        writeError: fail,
        onInit: onInit,
      ),
      successExitCode,
    );
    expect(received!.prefix, 'Ui');
    expect(received!.preset, 'vanilla');
    expect(received!.uiPath, 'lib/ui');

    await runRemixCli(
      [
        'init',
        '--prefix',
        'Acme',
        '--preset',
        'default',
        '--ui-path',
        'lib/design_system',
      ],
      writeOut: fail,
      writeError: fail,
      onInit: onInit,
    );
    expect(received!.prefix, 'Acme');
    expect(received!.preset, 'default');
    expect(received!.uiPath, 'lib/design_system');
  });

  test('add dispatches one item and mode', () async {
    AddOptions? received;

    final code = await runRemixCli(
      ['add', 'button', '--diff'],
      writeOut: fail,
      writeError: fail,
      onAdd: (options) async {
        received = options;
        return AddResult.done;
      },
    );

    expect(code, successExitCode);
    expect(received!.items, ['button']);
    expect(received!.mode, AddMode.diff);
  });

  test('add dispatches several items in invocation order', () async {
    AddOptions? received;

    final code = await runRemixCli(
      ['add', 'button', 'card', 'dialog'],
      writeOut: fail,
      writeError: fail,
      onAdd: (options) async {
        received = options;
        return AddResult.done;
      },
    );

    expect(code, successExitCode);
    expect(received!.items, ['button', 'card', 'dialog']);
    expect(received!.mode, AddMode.write);
  });

  test('add with no item fails before dispatch', () async {
    var dispatched = false;
    final errors = <String>[];

    final code = await runRemixCli(
      ['add'],
      writeOut: (_) {},
      writeError: errors.add,
      onAdd: (_) async {
        dispatched = true;
        return AddResult.done;
      },
    );

    expect(code, usageExitCode);
    expect(errors.join('\n'), contains('add requires at least one item.'));
    expect(dispatched, isFalse);
  });

  test('a repeated item fails before dispatch', () async {
    var dispatched = false;
    final errors = <String>[];

    final code = await runRemixCli(
      ['add', 'button', 'card', 'button'],
      writeOut: (_) {},
      writeError: errors.add,
      onAdd: (_) async {
        dispatched = true;
        return AddResult.done;
      },
    );

    expect(code, usageExitCode);
    expect(errors.join('\n'), contains('add received button more than once.'));
    expect(dispatched, isFalse);
  });

  test('mutually exclusive add modes fail before dispatch', () async {
    var dispatched = false;
    final errors = <String>[];

    final code = await runRemixCli(
      ['add', 'button', '--dry-run', '--overwrite'],
      writeOut: fail,
      writeError: errors.add,
      onAdd: (_) async {
        dispatched = true;
        return AddResult.done;
      },
    );

    expect(code, usageExitCode);
    expect(dispatched, isFalse);
    expect(errors.join('\n'), contains('mutually exclusive'));
  });

  group('add --exit-code', () {
    Future<int> run(List<String> flags, AddResult result) => runRemixCli(
      ['add', 'button', ...flags],
      writeOut: fail,
      writeError: fail,
      onAdd: (_) async => result,
    );

    test('exits $driftExitCode only when --diff found differences', () async {
      expect(await run(['--diff', '--exit-code'], AddResult.differs), 2);
      expect(await run(['--diff', '--exit-code'], AddResult.done), 0);
      expect(await run(['--diff'], AddResult.differs), 0);
    });

    test('without --diff is a usage error before dispatch', () async {
      final errors = <String>[];

      final code = await runRemixCli(
        ['add', 'button', '--exit-code'],
        writeOut: fail,
        writeError: errors.add,
        onAdd: (_) async => fail('dispatched'),
      );

      expect(code, usageExitCode);
      expect(errors.first, '--exit-code requires --diff.');
    });
  });

  test('runtime handler failures use a stable failure exit', () async {
    final errors = <String>[];

    final code = await runRemixCli(
      ['init'],
      writeOut: fail,
      writeError: errors.add,
      onInit: (_) async => throw StateError('broken'),
    );

    expect(code, failureExitCode);
    final report = errors.single;
    expect(report, contains('broken'));
    expect(report, startsWith('remix_cli $remixCliVersion hit an unexpected'));
    expect(report, contains('https://github.com/btwld/remix/issues'));
    expect(report, contains('\n  #0 '));
    for (final line in report.split('\n').skip(1)) {
      expect(line, startsWith('  '));
    }
  });

  test('expected handler failures print the message alone', () async {
    final errors = <String>[];

    final code = await runRemixCli(
      ['init'],
      writeOut: fail,
      writeError: errors.add,
      onInit: (_) async => throw const FormatException('Run remix init.'),
    );

    expect(code, failureExitCode);
    expect(errors, ['Run remix init.']);
  });

  group('expectedFailureMessage', () {
    final invocation = ProcessInvocation(
      executable: 'dart',
      arguments: const ['analyze', 'lib/ui'],
      workingDirectory: '.',
    );
    final cases = <String, (Object, Matcher)>{
      'FormatException': (
        const FormatException('bad input'),
        equals('bad input'),
      ),
      'FormatException with offset': (
        const FormatException('Unexpected character', '{x', 1),
        allOf(startsWith('Unexpected character'), contains('{x')),
      ),
      'YamlException': (
        _yamlError('a: [b'),
        allOf(startsWith('Error on line'), isNot(contains('Exception'))),
      ),
      'ProcessFailure': (
        ProcessFailure(
          invocation,
          const ProcessOutput(exitCode: 1, stdout: '', stderr: 'boom'),
          detail: 'Analysis failed',
        ),
        equals('Analysis failed: dart analyze lib/ui\nboom'),
      ),
      'FileSystemException': (
        const FileSystemException(
          'Cannot open file',
          'lib/ui/ui.dart',
          OSError('Permission denied', 13),
        ),
        equals('Cannot open file: lib/ui/ui.dart (Permission denied)'),
      ),
      'InstallFailure': (
        const InstallFailure('stopped\nCompleted steps: none.'),
        equals('stopped\nCompleted steps: none.'),
      ),
      'StateError': (StateError('bug'), isNull),
      'TypeError': (_typeError(), isNull),
    };
    for (final MapEntry(key: name, value: (error, matcher)) in cases.entries) {
      test(name, () => expect(expectedFailureMessage(error), matcher));
    }
  });
}

Object _yamlError(String source) {
  try {
    loadYaml(source);
  } on YamlException catch (error) {
    return error;
  }
  throw StateError('$source parsed');
}

Object _typeError() {
  try {
    <Object?>[null].single as String;
  } on TypeError catch (error) {
    return error;
  }
  throw StateError('cast succeeded');
}
