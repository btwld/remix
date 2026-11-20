import 'dart:io';

import 'package:yaml/yaml.dart';

Map<String, Set<String>> readRegistryItems(
  Directory root,
  List<String> failures,
) {
  final registryRoot = '${root.path}/registry';
  final index = File('$registryRoot/index.yaml');
  if (!index.existsSync()) {
    failures.add('registry/index.yaml is missing.');
    return {};
  }
  final presets = (loadYaml(index.readAsStringSync()) as YamlMap)['presets'];
  if (presets is! YamlMap || presets.isEmpty) {
    failures.add('registry/index.yaml declares no presets.');
    return {};
  }
  final catalogs = <String, Set<String>>{};
  for (final MapEntry(:key, :value) in presets.entries) {
    final catalog = File('$registryRoot/$value');
    if (!catalog.existsSync()) {
      failures.add('registry/$value is missing.');
      continue;
    }
    final items = (loadYaml(catalog.readAsStringSync()) as YamlMap)['items'];
    if (items is! YamlMap || items.isEmpty) {
      failures.add('registry/$value declares no items.');
      continue;
    }
    catalogs[key as String] = items.keys.cast<String>().toSet();
  }
  return catalogs;
}

final _fence = RegExp(r'^\s*```([\w-]*)');
final _scope = RegExp(
  r'^\s*(?:<!--|\{/\*)\s*remix-preset:\s*([\w, ]+)\s*(?:-->|\*/\})\s*$',
);
final _command = RegExp(
  r'^\s*(?:\$\s+)?(?:dart\s+run\s+remix_cli:)?remix\s+(init|add)\b(.*)$',
);
final _inlineCode = RegExp(r'`([^`]+)`');
final _presetOption = RegExp(r'''(?:^|\s)--preset[=\s]+["']?([a-z0-9_]+)''');
final _thirdPartyItem = RegExp(r'^@(?!remix/)[\w-]+/[a-z][a-z0-9_]*$');
final _shellSeparator = RegExp(r'[;&|]+');
final _helpDescription = RegExp(r'[ \t]{2,}(?=[A-Z])');

/// Common examples must work in every preset. Shell walks select their preset
/// with `init`; an isolated example can declare it with a `remix-preset:`
/// Markdown/MDX comment, scoped to the rest of the page or the next selection.
List<String> checkRegistryCommands(
  String source,
  String path,
  Map<String, Set<String>> catalogs,
) {
  final failures = <String>[];
  final lines = source.split('\n');
  var presets = catalogs.keys.toList();
  String? fence;
  for (var index = 0; index < lines.length; index++) {
    final location = '$path:${index + 1}';
    var line = lines[index];
    final delimiter = _fence.firstMatch(line);
    if (delimiter != null) {
      fence = fence == null ? delimiter[1] : null;
      continue;
    }
    final scope = fence == null ? _scope.firstMatch(line) : null;
    if (scope != null) {
      presets = scope[1]!.split(',').map((preset) => preset.trim()).toList();
      for (final preset in presets.where(
        (preset) => !catalogs.containsKey(preset),
      )) {
        failures.add('$location: unknown registry preset `$preset`.');
      }
      continue;
    }
    final shell = const {
      '',
      'bash',
      'shell',
      'sh',
      'zsh',
      'console',
    }.contains(fence);
    if (shell) {
      while (line.trimRight().endsWith('\\') && index + 1 < lines.length) {
        final prefix = line.trimRight();
        line = '${prefix.substring(0, prefix.length - 1)} ${lines[++index]}';
      }
    }
    final examples = switch (fence) {
      null => _inlineCode.allMatches(line).map((match) => match[1]!),
      'text' => [line.trim().split(_helpDescription).first],
      _ when shell => [line],
      _ => <String>[],
    };
    for (final example in examples) {
      final commands = example.split('#').first.split(_shellSeparator);
      for (final fragment in commands) {
        final command = _command.firstMatch(fragment);
        if (command == null) continue;
        final args = command[2]!.trim();
        if (command[1] == 'init') {
          if (!shell || args.startsWith('[')) continue;
          final preset = _presetOption.firstMatch(args)?[1] ?? 'vanilla';
          if (!catalogs.containsKey(preset)) {
            failures.add('$location: unknown registry preset `$preset`.');
          }
          presets = [preset];
          continue;
        }
        failures.addAll(_checkAdd(args, location, presets, catalogs));
      }
    }
  }
  return failures;
}

Iterable<String> _checkAdd(
  String arguments,
  String location,
  List<String> presets,
  Map<String, Set<String>> catalogs,
) sync* {
  for (final word in arguments.split(RegExp(r'\s+'))) {
    final item = word.replaceAll(RegExp(r'''^["']|["']$'''), '');
    if (item.isEmpty ||
        RegExp(r'^[-\[<$]').hasMatch(item) ||
        _thirdPartyItem.hasMatch(item)) {
      continue;
    }
    final id = item.replaceFirst(RegExp(r'^@remix/'), '');
    final missing = [
      for (final preset in presets)
        if (catalogs[preset]?.contains(id) == false) preset,
    ];
    if (missing.isNotEmpty) {
      yield '$location: `remix add` item `$item` is absent from the '
          '${missing.join(', ')} registry catalog${missing.length == 1 ? '' : 's'}.';
    }
  }
}
