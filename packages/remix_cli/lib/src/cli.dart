import 'package:args/command_runner.dart';

import 'version.dart';

/// Conventional successful process exit.
const successExitCode = 0;

/// Conventional command-line usage failure.
const usageExitCode = 64;

/// A runtime failure after valid command parsing.
const failureExitCode = 1;

typedef LineWriter = void Function(String line);

typedef InitHandler = Future<void> Function(InitOptions options);
typedef RegistryHandler = Future<void> Function(RegistryOptions options);

typedef AddHandler = Future<void> Function(AddOptions options);

final class InitOptions {
  const InitOptions({
    required this.prefix,
    required this.preset,
    required this.uiPath,
    this.registry,
    this.repository,
    this.path,
    this.ref,
  });

  final String prefix;
  final String preset;
  final String uiPath;
  final String? registry;
  final String? repository;
  final String? path;
  final String? ref;
}

enum AddMode { write, dryRun, diff, overwrite }

final class AddOptions {
  const AddOptions({required this.items, required this.mode});

  /// The explicitly requested registry items, in invocation order.
  ///
  /// Registry dependencies are not listed here. The distinction is load
  /// bearing: [AddMode.overwrite] applies to what the caller asked for and
  /// never to what was pulled in behind it.
  final List<String> items;
  final AddMode mode;
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
  final runner =
      CommandRunner<int>('remix', 'Install editable Remix UI source.')
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
  } on Object catch (error) {
    writeError(error.toString());
    return failureExitCode;
  }
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
      ..addOption('prefix', defaultsTo: 'Ui')
      ..addOption(
        'preset',
        defaultsTo: 'vanilla',
        help: 'Preset name; vanilla, fortal, and carbon have default sources.',
      )
      ..addOption('ui-path', defaultsTo: 'lib/ui')
      ..addOption('registry', help: 'Default registry namespace, e.g. @carbon.')
      ..addOption('repository', help: 'Public GitHub owner/repository.')
      ..addOption('path', help: 'Registry directory in the repository.')
      ..addOption('ref', help: 'Branch, tag, or commit to pin.');
  }

  final InitHandler? _handler;

  @override
  String get name => 'init';

  @override
  String get description => 'Initialize Remix source installation settings.';

  @override
  Future<int> run() async {
    if (argResults!.rest.isNotEmpty) {
      usageException('init accepts no positional arguments.');
    }
    final registry = argResults!.option('registry');
    final repository = argResults!.option('repository');
    if ((registry == null) != (repository == null)) {
      usageException('init requires --registry and --repository together.');
    }
    if (registry == null &&
        (argResults!.option('path') != null ||
            argResults!.option('ref') != null)) {
      usageException('init --path and --ref require a custom registry.');
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
        registry: registry,
        repository: repository,
        path: argResults!.option('path'),
        ref: argResults!.option('ref'),
      ),
    );
    return successExitCode;
  }
}

final class _AddCommand extends Command<int> {
  _AddCommand(this._handler) {
    argParser
      ..addFlag('dry-run', negatable: false)
      ..addFlag('diff', negatable: false)
      ..addFlag('overwrite', negatable: false);
  }

  final AddHandler? _handler;

  @override
  String get name => 'add';

  @override
  String get description => 'Install registry items and their dependencies.';

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

    final handler = _handler;
    if (handler == null) {
      throw StateError('The add command is not available.');
    }
    await handler(
      AddOptions(
        items: List.unmodifiable(positional),
        mode: modes.isEmpty ? AddMode.write : modes.single,
      ),
    );
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
}

final class _RegistryActionCommand extends Command<int> {
  _RegistryActionCommand(this.action, this.handler) {
    argParser.addOption('ref');
    if (action == RegistryAction.add) {
      argParser.addOption('repository');
      argParser.addOption('path', defaultsTo: 'registry');
    }
  }
  final RegistryAction action;
  final RegistryHandler? handler;
  @override
  String get name => action.name;
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
