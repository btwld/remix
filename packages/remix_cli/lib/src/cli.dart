import 'dart:io' show FileSystemException;

import 'package:args/command_runner.dart';

import 'process_runner.dart';
import 'skills.dart';
import 'suggest.dart';
import 'version.dart';

/// Conventional successful process exit.
const successExitCode = 0;

/// Conventional command-line usage failure.
const usageExitCode = 64;

/// A runtime failure after valid command parsing.
const failureExitCode = 1;

/// `add --diff --exit-code` found authored source that differs.
///
/// CI has to tell drift from a failed `pub get`, so this is not
/// [failureExitCode].
const driftExitCode = 2;

/// Each exit code with its meaning, in the order the docs list them.
///
/// `tool/generate_cli_reference.dart` renders the CLI reference's exit-code
/// table from this list, so a new code or a changed meaning reaches the docs
/// when it is edited here.
const exitCodeReference = <(int code, String meaning)>[
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

typedef LineWriter = void Function(String line);

/// The presets `remix init --help` describes, in `registry/index.yaml` order.
///
/// Help only. The pinned index validates the preset, so no `allowed:` list
/// rejects a preset this build predates.
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
String? expectedFailureMessage(Object error) => switch (error) {
  InstallFailure(:final message) => message,
  ProcessFailure() => error.toString(),
  FileSystemException(:final message, :final path, :final osError) => [
    message,
    if (path != null && path.isNotEmpty) ': $path',
    if (osError != null) ' (${osError.message})',
  ].join(),
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
  return 'remix_cli $remixCliVersion hit an unexpected error. This is a bug. '
      'Report it at https://github.com/btwld/remix/issues with the '
      'output below.\n  $details';
}

typedef InitHandler = Future<void> Function(InitOptions options);
typedef ListHandler = Future<void> Function(ListOptions options);
typedef RegistryHandler = Future<void> Function(RegistryOptions options);
typedef SkillsInstallHandler =
    Future<void> Function(SkillsInstallOptions options);

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

final class ListOptions {
  const ListOptions({this.json = false});

  /// One JSON document on stdout, for scripts and agents.
  final bool json;
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

final class SkillsInstallOptions {
  const SkillsInstallOptions({this.directory});

  /// The `--dir` value, or null when the flag is absent.
  ///
  /// Null is not the default directory. It means "the directory the last
  /// install recorded, or `.agents/skills` on a first install", which only
  /// the installer can resolve because it reads `remix.skills.json`.
  final String? directory;
}

Future<int> runRemixCli(
  List<String> arguments, {
  required LineWriter writeOut,
  required LineWriter writeError,
  InitHandler? onInit,
  AddHandler? onAdd,
  ListHandler? onList,
  RegistryHandler? onRegistry,
  SkillsInstallHandler? onSkillsInstall,
}) async {
  final runner = RemixCommandRunner(
    onInit: onInit,
    onAdd: onAdd,
    onList: onList,
    onRegistry: onRegistry,
    onSkillsInstall: onSkillsInstall,
  );

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
  final unknown = _unknownCommand(
    arguments,
    runner: runner,
    writeError: writeError,
  );
  if (unknown != null) return unknown;

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

/// Suggests a misspelled command at any level.
///
/// Leaf arguments, such as `remix add buton`, are left for that command.
/// The runner turns the args suggester off, so this is the only one.
int? _unknownCommand(
  List<String> arguments, {
  required CommandRunner<int> runner,
  required LineWriter writeError,
}) {
  var commands = runner.commands;
  Command<int>? parent;
  for (final token in arguments) {
    if (token.startsWith('-') || commands.isEmpty) return null;
    final command = commands[token];
    if (command == null) {
      return _writeUnknownCommand(
        token,
        commands: commands,
        usage: parent?.usage ?? runner.usage,
        subcommand: parent != null,
        writeError: writeError,
      );
    }
    parent = command;
    commands = command.subcommands;
  }
  return null;
}

int _writeUnknownCommand(
  String name, {
  required Map<String, Command<int>> commands,
  required String usage,
  required bool subcommand,
  required LineWriter writeError,
}) {
  final kind = subcommand ? 'subcommand' : 'command';
  writeError(
    [
      'Could not find a $kind named "$name".',
      ?didYouMean(name, [
        for (final MapEntry(:key, :value) in commands.entries)
          if (!value.hidden) key,
      ]),
    ].join('\n'),
  );
  writeError(usage);
  return usageExitCode;
}

/// The `remix` command line, with its flags and commands registered.
///
/// Public so [runRemixCli] and the docs generator walk the same parser tree.
/// Commands are registered in reader order; `--help` sorts them anyway.
final class RemixCommandRunner extends CommandRunner<int> {
  RemixCommandRunner({
    InitHandler? onInit,
    AddHandler? onAdd,
    ListHandler? onList,
    RegistryHandler? onRegistry,
    SkillsInstallHandler? onSkillsInstall,
  }) : super(
         'remix',
         'Install editable Remix UI source.',
         // args has its own command suggester; turning it off leaves one voice.
         suggestionDistanceLimit: 0,
       ) {
    argParser.addFlag(
      'version',
      negatable: false,
      help: 'Print the remix_cli version.',
    );
    addCommand(_InitCommand(onInit));
    addCommand(_ListCommand(onList));
    addCommand(_AddCommand(onAdd));
    addCommand(_RegistryCommand(onRegistry));
    addCommand(_SkillsCommand(onSkillsInstall));
  }

  @override
  String get usageFooter => '''

Get started:
  remix init              Pin the official registry and create lib/ui/ui.dart.
  remix list              See the items you can add.
  remix add button        Install an item and the items it needs.
  remix skills install    Give your coding agent the skills at your pin.''';
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
    return _writeUnknownCommand(
      commandName,
      commands: runner.commands,
      usage: runner.usage,
      subcommand: false,
      writeError: writeError,
    );
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
  remix init                                  Vanilla, Ui prefix, lib/ui.
  remix init --preset fortal --prefix Acme    Fortal preset, AcmeButton.''';

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
            'Show how installed source differs from the registry and write '
            'nothing.',
      )
      ..addFlag(
        'exit-code',
        negatable: false,
        help: 'With --diff, exit $driftExitCode when authored source differs.',
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
  remix add button                       Install button and what it needs.
  remix add button card dialog           Install several items at once.
  remix add button --dry-run             Print the plan and change nothing.
  remix add button --diff --exit-code    Exit $driftExitCode on drift, for CI.
  remix add @acme/card                   Install from a registry you added.''';

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

final class _ListCommand extends Command<int> {
  _ListCommand(this._handler) {
    argParser.addFlag(
      'json',
      negatable: false,
      help: 'Print the listing as JSON for scripts and agents.',
    );
  }

  final ListHandler? _handler;

  @override
  String get name => 'list';

  @override
  String get description => 'List the items you can add from your registries.';

  @override
  String get invocation => 'remix list [options]';

  @override
  Future<int> run() async {
    if (argResults!.rest.isNotEmpty) {
      usageException('list accepts no positional arguments.');
    }
    final handler = _handler;
    if (handler == null) {
      throw StateError('The list command is not available.');
    }
    await handler(ListOptions(json: argResults!.flag('json')));
    return successExitCode;
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
  remix registry add @acme --repository acme/design  Pin its default branch.
  remix registry update @remix                       Re-pin to latest stable.
  remix add @acme/card --diff                        See what a new pin changes.''';
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

final class _SkillsCommand extends Command<int> {
  _SkillsCommand(SkillsInstallHandler? handler) {
    addSubcommand(_SkillsInstallCommand(handler));
  }

  @override
  String get name => 'skills';

  @override
  String get description => 'Give coding agents the Remix skills at your pin.';

  @override
  String get usageFooter => '''

Examples:
  remix skills install                       Copy skills into .agents/skills.
  remix skills install --dir .claude/skills  Copy them where Claude Code looks.''';
}

/// One option. `--dry-run` and `--overwrite` are absent on purpose: every
/// effect is a text file under version control, and deleting a conflicting
/// file is the explicit act that replaces it.
final class _SkillsInstallCommand extends Command<int> {
  _SkillsInstallCommand(this._handler) {
    argParser.addOption(
      'dir',
      valueHelp: 'path',
      help:
          'Project directory your agent loads skills from. Defaults to the '
          'directory of the last install, or $defaultSkillsDirectory.',
    );
  }

  final SkillsInstallHandler? _handler;

  @override
  String get name => 'install';

  @override
  String get invocation => 'remix skills install [options]';

  @override
  String get description =>
      'Copy the Remix skills from the pinned @remix commit into the project '
      'and register them in AGENTS.md.';

  @override
  Future<int> run() async {
    if (argResults!.rest.isNotEmpty) {
      usageException('skills install accepts no positional arguments.');
    }
    final String? directory;
    try {
      directory = switch (argResults!.option('dir')) {
        final value? => parseSkillsDirectory(value),
        null => null,
      };
    } on FormatException catch (error) {
      usageException('--dir ${error.message}');
    }
    final handler = _handler;
    if (handler == null) {
      throw StateError('The skills command is not available.');
    }
    await handler(SkillsInstallOptions(directory: directory));
    return successExitCode;
  }
}
