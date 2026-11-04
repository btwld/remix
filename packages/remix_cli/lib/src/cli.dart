import 'dart:io' show FileSystemException;

import 'package:args/command_runner.dart';

import 'process_runner.dart';
import 'version.dart';

/// Conventional successful process exit.
const successExitCode = 0;

/// Conventional command-line usage failure.
const usageExitCode = 64;

/// A runtime failure after valid command parsing.
const failureExitCode = 1;

/// `add --diff --exit-code` found authored source that differs.
///
/// Not [failureExitCode]: CI has to tell drift from a failed `pub get`.
const driftExitCode = 2;

typedef LineWriter = void Function(String line);

/// The presets `remix init --help` describes, in `registry/index.yaml` order.
///
/// Help text, not validation: the pinned index owns the real set and
/// `catalogPathForPreset` enforces it, so a newer preset still installs with
/// an older CLI. A test pins these keys to the checkout's index.
const officialPresets = {
  'vanilla': 'Neutral, minimal theme inspired by shadcn/ui.',
  'fortal': "Fortal's own visual language.",
  'heroui': 'The look of HeroUI web 3.2.6.',
};

/// An install that stopped partway, with the steps that finished and the
/// command to rerun.
final class InstallFailure implements Exception {
  const InstallFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// The text for a failure the user can act on, or null when [error] is a bug.
///
/// Expected failures print as their message alone, never behind a Dart type
/// name. Anything this does not recognize is a defect in remix_cli and gets
/// a bug report with its stack instead.
String? expectedFailureMessage(Object error) => switch (error) {
  InstallFailure(:final message) => message,
  ProcessFailure() => error.toString(),
  FileSystemException(:final message, :final path, :final osError) =>
    '$message${path == null ? '' : ': $path'}'
        '${osError == null ? '' : ' (${osError.message})'}',
  // toString, not message: YamlException keeps its line and column there, and
  // jsonDecode keeps its offset and excerpt.
  FormatException() => error.toString().replaceFirst(
    RegExp('^FormatException: '),
    '',
  ),
  _ => null,
};

String _bugReport(Object error, StackTrace stack) {
  final details = '$error\n$stack'.trimRight().replaceAll('\n', '\n  ');
  return 'remix_cli $remixCliVersion hit an unexpected error. This is a bug; '
      'please report it at https://github.com/btwld/remix/issues with the '
      'output below.\n  $details';
}

typedef InitHandler = Future<void> Function(InitOptions options);
typedef RegistryHandler = Future<void> Function(RegistryOptions options);

/// The installer reports what `add` found; only the shell maps it to an exit
/// code, so `--exit-code` never reaches [AddOptions].
typedef AddHandler = Future<AddResult> Function(AddOptions options);

enum AddResult {
  done,

  /// `--diff` found authored source that differs from the registry.
  differs,
}

final class InitOptions {
  const InitOptions({
    required this.prefix,
    required this.preset,
    required this.uiPath,
  });

  final String prefix;
  final String preset;
  final String uiPath;
}

enum AddMode { write, dryRun, diff, overwrite }

final class AddOptions {
  const AddOptions({
    required this.items,
    required this.mode,
    this.adopt = false,
  });

  /// The explicitly requested registry items, in invocation order.
  ///
  /// Registry dependencies are not listed here. The distinction is load
  /// bearing: [AddMode.overwrite] applies to what the caller asked for and
  /// never to what was pulled in behind it.
  final List<String> items;
  final AddMode mode;

  /// Explicitly attest ownership of existing files for the named items.
  final bool adopt;
}

enum RegistryAction { add, update }

final class RegistryOptions {
  const RegistryOptions({
    required this.action,
    this.namespace,
    this.repository,
    this.path = 'registry',
    this.ref,
  });
  final RegistryAction action;
  final String? namespace;
  final String? repository;
  final String path;
  final String? ref;
}

Future<int> runRemixCli(
  List<String> arguments, {
  required LineWriter writeOut,
  required LineWriter writeError,
  InitHandler? onInit,
  AddHandler? onAdd,
  RegistryHandler? onRegistry,
}) async {
  final runner = _RemixRunner()
    ..argParser.addFlag(
      'version',
      negatable: false,
      help: 'Print the remix_cli version.',
    )
    ..addCommand(_InitCommand(onInit))
    ..addCommand(_AddCommand(onAdd))
    ..addCommand(_RegistryCommand(onRegistry));

  final helpCode = _writeRequestedHelp(
    arguments,
    runner: runner,
    writeOut: writeOut,
    writeError: writeError,
  );
  if (helpCode != null) return helpCode;

  if (arguments.contains('--version')) {
    if (arguments.length != 1) {
      writeError('The --version option cannot be combined with a command.');
      return usageExitCode;
    }
    writeOut(remixCliVersion);
    return successExitCode;
  }

  if (arguments.isEmpty) {
    writeError(runner.usage);
    return usageExitCode;
  }

  try {
    // CommandRunner already prints help when it returns no command result.
    return await runner.run(arguments) ?? successExitCode;
  } on UsageException catch (error) {
    writeError(error.message);
    writeError(error.usage);
    return usageExitCode;
  } on Object catch (error, stack) {
    writeError(expectedFailureMessage(error) ?? _bugReport(error, stack));
    return failureExitCode;
  }
}

/// Subclassed only for the footer, which args exposes as a getter.
final class _RemixRunner extends CommandRunner<int> {
  _RemixRunner() : super('remix', 'Install editable Remix UI source.');

  @override
  String get usageFooter => '''

Get started:
  remix init          Pin the official registry and create lib/ui/ui.dart.
  remix add button    Install an item and the items it needs.''';
}

int? _writeRequestedHelp(
  List<String> arguments, {
  required CommandRunner<int> runner,
  required LineWriter writeOut,
  required LineWriter writeError,
}) {
  // Route the common help forms through the injected output callback.
  if (arguments.length == 1 &&
      (arguments.single == '--help' ||
          arguments.single == '-h' ||
          arguments.single == 'help')) {
    writeOut(runner.usage);
    return successExitCode;
  }

  String? commandName;
  if (arguments.length == 2 && arguments.first == 'help') {
    commandName = arguments.last;
  } else if (arguments.length == 2 &&
      (arguments.last == '--help' || arguments.last == '-h')) {
    commandName = arguments.first;
  }
  if (commandName == null) return null;

  final command = runner.commands[commandName];
  if (command == null || commandName == 'help') {
    writeError('Could not find a command named "$commandName".');
    writeError(runner.usage);
    return usageExitCode;
  }
  writeOut(command.usage);
  return successExitCode;
}

final class _InitCommand extends Command<int> {
  _InitCommand(this._handler) {
    argParser
      ..addOption(
        'prefix',
        defaultsTo: 'Ui',
        valueHelp: 'Name',
        help: 'Type prefix for installed widgets, as in UiButton.',
      )
      // No `allowed:`: the parser would reject a preset that the pinned
      // index publishes but this CLI build predates.
      ..addOption(
        'preset',
        defaultsTo: 'vanilla',
        valueHelp: 'name',
        help: 'Design language for every installed item.',
        allowedHelp: officialPresets,
      )
      ..addOption(
        'ui-path',
        defaultsTo: 'lib/ui',
        valueHelp: 'path',
        help: 'Directory for installed source and its ui.dart barrel.',
      );
  }

  final InitHandler? _handler;

  @override
  String get name => 'init';

  @override
  String get description => 'Initialize Remix source installation settings.';

  @override
  String get invocation => 'remix init [options]';

  @override
  String get usageFooter => '''

Examples:
  remix init                                  Vanilla preset, Ui prefix, source in lib/ui.
  remix init --preset fortal --prefix Acme    Fortal source with widgets named AcmeButton.''';

  @override
  Future<int> run() async {
    if (argResults!.rest.isNotEmpty) {
      usageException('init accepts no positional arguments.');
    }
    final handler = _handler;
    if (handler == null) {
      throw StateError('The init command is not available.');
    }
    await handler(
      InitOptions(
        prefix: argResults!.option('prefix')!,
        preset: argResults!.option('preset')!,
        uiPath: argResults!.option('ui-path')!,
      ),
    );
    return successExitCode;
  }
}

final class _AddCommand extends Command<int> {
  _AddCommand(this._handler) {
    argParser
      ..addFlag(
        'dry-run',
        negatable: false,
        help: 'Print the plan without running tools or writing files.',
      )
      ..addFlag(
        'diff',
        negatable: false,
        help:
            'Show how installed source differs from the registry; write '
            'nothing.',
      )
      ..addFlag(
        'exit-code',
        negatable: false,
        help:
            'With --diff, exit $driftExitCode when authored source differs, '
            'like git diff --exit-code.',
      )
      ..addFlag(
        'overwrite',
        negatable: false,
        help:
            'Replace the named items with registry source. Installed '
            'dependencies are kept.',
      )
      ..addFlag(
        'adopt',
        negatable: false,
        help: 'Record verified legacy ownership without replacing source.',
      );
  }

  final AddHandler? _handler;

  @override
  String get name => 'add';

  @override
  String get description => 'Install registry items and their dependencies.';

  @override
  String get invocation => 'remix add <item...> [options]';

  @override
  String get usageFooter =>
      '''

Examples:
  remix add button                       Install button and the items it needs.
  remix add button card dialog           Install several items at once.
  remix add button --dry-run             Print the plan; change nothing.
  remix add button --diff --exit-code    Exit $driftExitCode when installed source differs.
  remix add @acme/card                   Install from a registry added with remix registry add.''';

  @override
  Future<int> run() async {
    final positional = argResults!.rest;
    if (positional.isEmpty) {
      usageException('add requires at least one item.');
    }
    final duplicates = <String>{};
    for (final item in positional) {
      if (!duplicates.add(item)) {
        usageException('add received $item more than once.');
      }
    }

    final modes = <AddMode>[
      if (argResults!.flag('dry-run')) AddMode.dryRun,
      if (argResults!.flag('diff')) AddMode.diff,
      if (argResults!.flag('overwrite')) AddMode.overwrite,
    ];
    if (modes.length > 1) {
      usageException(
        '--dry-run, --diff, and --overwrite are mutually exclusive.',
      );
    }

    if (argResults!.flag('adopt') && argResults!.flag('overwrite')) {
      usageException('--adopt and --overwrite cannot be combined.');
    }
    final exitOnDrift = argResults!.flag('exit-code');
    if (exitOnDrift && !argResults!.flag('diff')) {
      usageException('--exit-code requires --diff.');
    }
    final handler = _handler;
    if (handler == null) {
      throw StateError('The add command is not available.');
    }
    final result = await handler(
      AddOptions(
        items: List.unmodifiable(positional),
        mode: modes.isEmpty ? AddMode.write : modes.single,
        adopt: argResults!.flag('adopt'),
      ),
    );
    return exitOnDrift && result == AddResult.differs
        ? driftExitCode
        : successExitCode;
  }
}

final class _RegistryCommand extends Command<int> {
  _RegistryCommand(RegistryHandler? handler) {
    for (final action in RegistryAction.values) {
      addSubcommand(_RegistryActionCommand(action, handler));
    }
  }
  @override
  String get name => 'registry';
  @override
  String get description => 'Register and pin GitHub registry sources.';

  @override
  String get usageFooter => '''

Examples:
  remix registry add @acme --repository acme/design    Pin acme/design at its default branch.
  remix registry update @remix                         Move @remix to the newest stable commit.
  remix add @acme/card --diff                          Review what a moved pin would change.''';
}

final class _RegistryActionCommand extends Command<int> {
  _RegistryActionCommand(this.action, this.handler) {
    if (action == RegistryAction.add) {
      argParser
        ..addOption(
          'repository',
          valueHelp: 'owner/repo',
          help: 'Public GitHub repository that hosts the registry.',
        )
        ..addOption(
          'path',
          defaultsTo: 'registry',
          valueHelp: 'path',
          help: 'Registry directory inside the repository.',
        );
    }
    argParser.addOption(
      'ref',
      valueHelp: 'ref',
      help: switch (action) {
        RegistryAction.add =>
          'Branch, tag, or commit to pin. Defaults to the default branch.',
        RegistryAction.update =>
          'Branch, tag, or commit to pin. Defaults to the ref in remix.yaml.',
      },
    );
  }
  final RegistryAction action;
  final RegistryHandler? handler;
  @override
  String get name => action.name;
  @override
  String get invocation => switch (action) {
    RegistryAction.add =>
      'remix registry add <@namespace> --repository <owner/repo> [options]',
    RegistryAction.update => 'remix registry update <@namespace> [options]',
  };
  @override
  String get description => switch (action) {
    RegistryAction.add =>
      'Register a public GitHub registry and pin its commit.',
    RegistryAction.update =>
      'Update one registry pin without changing installed source.',
  };
  @override
  Future<int> run() async {
    final rest = argResults!.rest;
    if (rest.length != 1) {
      usageException('$name requires exactly one namespace.');
    }
    if (action == RegistryAction.add &&
        argResults!.option('repository') == null) {
      usageException('registry add requires --repository owner/repo.');
    }
    final handler = this.handler;
    if (handler == null) {
      throw StateError('The registry command is not available.');
    }
    await handler(
      RegistryOptions(
        action: action,
        namespace: rest.isEmpty ? null : rest.single,
        repository: action == RegistryAction.add
            ? argResults!.option('repository')
            : null,
        path: action == RegistryAction.add
            ? argResults!.option('path')!
            : 'registry',
        ref: argResults!.option('ref'),
      ),
    );
    return successExitCode;
  }
}
