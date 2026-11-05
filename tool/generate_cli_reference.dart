import 'dart:io';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';

import '../packages/remix_cli/lib/src/cli.dart';

const cliReferencePath = 'docs/open-code/cli.mdx';

const generatedStart =
    '{/* generated:start  Rendered by tool/generate_cli_reference.dart from '
    'packages/remix_cli/lib/src/cli.dart. Edit the parsers, then run '
    '`dart run melos run docs:cli`; `docs:check` fails on drift. */}';

const generatedEnd = '{/* generated:end */}';

const _exitCodes = [
  (
    successExitCode,
    'Success, including help, version, dry-run, diff, and no-op reruns',
  ),
  (usageExitCode, 'Invalid command or arguments'),
  (
    failureExitCode,
    'Configuration, registry, dependency, process, generation, analysis, or '
        'filesystem failure',
  ),
  (
    driftExitCode,
    '`add --diff --exit-code` found authored source that differs',
  ),
];

/// Rewrites the generated region of docs/open-code/cli.mdx from remix_cli's
/// argument parsers. Pass --check to fail on drift instead.
void main(List<String> arguments) {
  final check = arguments.contains('--check');
  final unknown = arguments.where((argument) => argument != '--check');
  if (unknown.isNotEmpty) {
    stderr.writeln('Unsupported arguments: ${unknown.join(', ')}');
    exitCode = 64;
    return;
  }

  final workspaceRoot = Directory.current;
  final pubspec = File('${workspaceRoot.path}/pubspec.yaml');
  if (!pubspec.existsSync() ||
      !RegExp(
        r'^name:\s*remix_workspace\s*$',
        multiLine: true,
      ).hasMatch(pubspec.readAsStringSync())) {
    stderr.writeln('Run this generator from the workspace root.');
    exitCode = 64;
    return;
  }

  if (check) {
    final failures = checkCliReference(workspaceRoot);
    if (failures.isNotEmpty) {
      failures.forEach(stderr.writeln);
      exitCode = 1;
      return;
    }
    stdout.writeln('$cliReferencePath matches the remix_cli parsers.');
    return;
  }

  final page = File('${workspaceRoot.path}/$cliReferencePath');
  if (!page.existsSync()) {
    stderr.writeln('$cliReferencePath is missing.');
    exitCode = 1;
    return;
  }
  try {
    page.writeAsStringSync(
      replaceGeneratedRegion(page.readAsStringSync(), renderCliReference()),
    );
  } on FormatException catch (error) {
    stderr.writeln('$cliReferencePath: ${error.message}');
    exitCode = 1;
    return;
  }
  stdout.writeln('Wrote $cliReferencePath.');
}

String renderCliReference() {
  final runner = remixCommandRunner();
  final buffer = StringBuffer()
    ..writeln('## Commands')
    ..writeln()
    ..writeln(runner.description)
    ..writeln();
  _writeFence(buffer, runner.invocation);
  _writeOptions(buffer, runner.argParser);
  buffer
    ..writeln(
      "For one command's help in a terminal, run `remix help <command>` or "
      '`remix <command> --help`; both print the same text.',
    )
    ..writeln();
  _writeFence(buffer, runner.usageFooter);

  for (final command in runner.commands.values) {
    if (command.hidden || command.name == 'help') continue;
    _writeCommand(buffer, command, ['remix'], level: 3);
  }

  buffer
    ..writeln('## Exit codes')
    ..writeln()
    ..writeln('| Code | Meaning |')
    ..writeln('| --- | --- |');
  for (final (code, meaning) in _exitCodes) {
    buffer.writeln('| `$code` | $meaning |');
  }
  return buffer.toString();
}

/// Swaps the text between the generated markers in [page] for [rendered].
///
/// Throws a [FormatException] unless each marker appears exactly once, in
/// order.
String replaceGeneratedRegion(String page, String rendered) {
  final start = _singleIndex(page, generatedStart);
  final end = _singleIndex(page, generatedEnd);
  if (end < start) {
    throw const FormatException('generated:end comes before generated:start.');
  }
  return '${page.substring(0, start)}$generatedStart\n\n$rendered\n'
      '${page.substring(end)}';
}

/// Failures for a missing, malformed, or stale CLI reference page.
List<String> checkCliReference(Directory workspaceRoot) {
  final page = File('${workspaceRoot.path}/$cliReferencePath');
  if (!page.existsSync()) return ['$cliReferencePath is missing.'];
  final source = page.readAsStringSync();
  final String expected;
  try {
    expected = replaceGeneratedRegion(source, renderCliReference());
  } on FormatException catch (error) {
    return ['$cliReferencePath: ${error.message}'];
  }
  if (source != expected) {
    return [
      '$cliReferencePath is stale. Run `dart run melos run docs:cli` and '
          'commit the result.',
    ];
  }
  return [];
}

int _singleIndex(String page, String marker) {
  final index = page.indexOf(marker);
  if (index < 0) throw FormatException('Missing marker: $marker');
  if (page.indexOf(marker, index + 1) >= 0) {
    throw FormatException('Marker appears more than once: $marker');
  }
  return index;
}

void _writeCommand(
  StringBuffer buffer,
  Command<int> command,
  List<String> parents, {
  required int level,
}) {
  final path = [...parents, command.name];
  buffer
    ..writeln('${'#' * level} ${path.join(' ')}')
    ..writeln()
    ..writeln(command.description)
    ..writeln();
  _writeFence(buffer, command.invocation);
  _writeOptions(buffer, command.argParser);
  _writeFence(buffer, command.usageFooter);
  for (final subcommand in command.subcommands.values.toSet()) {
    if (subcommand.hidden) continue;
    _writeCommand(buffer, subcommand, path, level: level + 1);
  }
}

void _writeOptions(StringBuffer buffer, ArgParser parser) {
  final options = parser.options.values
      .where((option) => !option.hide && option.name != 'help')
      .toList();
  if (options.isEmpty) return;
  buffer
    ..writeln('| Option | Default | Description |')
    ..writeln('| --- | --- | --- |');
  for (final option in options) {
    final defaultsTo = option.defaultsTo;
    final defaultCell = option.isFlag || defaultsTo == null
        ? ''
        : _code('$defaultsTo');
    buffer.writeln(
      '| ${_code(_optionSyntax(option))} | $defaultCell | '
      '${_description(option)} |',
    );
  }
  buffer.writeln();
}

String _optionSyntax(Option option) {
  final name = option.isFlag && option.negatable!
      ? '--[no-]${option.name}'
      : '--${option.name}';
  final valueHelp = option.valueHelp;
  return [
    if (option.abbr case final abbr?) '-$abbr, ',
    name,
    if (valueHelp != null) ' <$valueHelp>',
  ].join();
}

String _description(Option option) {
  final allowedHelp = option.allowedHelp;
  final allowed = [
    for (final value in option.allowed ?? allowedHelp?.keys ?? <String>[])
      switch (allowedHelp?[value]) {
        final help? => '${_code(value)} (${_prose(_trimPeriod(help))})',
        null => _code(value),
      },
  ];
  return [
    if (option.help case final help?) _prose(help),
    if (allowed.isNotEmpty) 'One of ${allowed.join(', ')}.',
  ].join(' ');
}

String _trimPeriod(String text) =>
    text.endsWith('.') ? text.substring(0, text.length - 1) : text;

/// Table-cell prose: escapes the pipe that ends a cell and the characters MDX
/// would read as JSX.
String _prose(String text) =>
    text.replaceAllMapped(RegExp(r'[|<{}]'), (match) => '\\${match[0]}');

String _code(String text) => '`${text.replaceAll('|', r'\|')}`';

void _writeFence(StringBuffer buffer, String? text) {
  final trimmed = text?.trim() ?? '';
  if (trimmed.isEmpty) return;
  buffer
    ..writeln('```text')
    ..writeln(trimmed)
    ..writeln('```')
    ..writeln();
}
