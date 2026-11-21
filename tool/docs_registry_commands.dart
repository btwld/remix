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
  r'^\s*(?:<!--|\{/\*)\s*remix-preset:\s*([a-z][a-z0-9_]*)\s*(?:-->|\*/\})\s*$',
);
final _command = RegExp(
  r'^\s*(?:\$\s+)?(?:dart\s+run\s+remix_cli:)?remix\s+(init|add)(?:\s+(.*))?$',
);
final _inlineCode = RegExp(r'`([^`]+)`');
final _presetOption = RegExp(r'''(?:^|\s)--preset[=\s]+["']?([a-z0-9_]+)''');
final _thirdPartyItem = RegExp(r'^@(?!remix/)[\w-]+/[a-z][a-z0-9_]*$');
final _helpDescription = RegExp(r'[ \t]{2,}');
final _arguments = RegExp(
  r'''<[\w.-]+>|(?:\d*[<>]|&>)>?\s*(?:"[^"]*"|'[^']*'|[^\s<>]+)|(?<word>[^\s<>]+)''',
);

/// Common examples must work in every preset. An `init` selects the preset
/// within its shell block; a `remix-preset:` comment sets the page default.
List<String> checkRegistryCommands(
  String source,
  String path,
  Map<String, Set<String>> catalogs,
) {
  final failures = <String>[];
  final lines = source.split('\n');
  String? pagePreset;
  String? blockPreset;
  String? fence;
  for (var index = 0; index < lines.length; index++) {
    final location = '$path:${index + 1}';
    final line = lines[index];
    final delimiter = _fence.firstMatch(line);
    if (delimiter != null) {
      fence = fence == null ? delimiter[1] : null;
      blockPreset = null;
      continue;
    }
    final scope = fence == null ? _scope.firstMatch(line) : null;
    if (scope != null) {
      pagePreset = scope[1]!;
      if (!catalogs.containsKey(pagePreset)) {
        failures.add('$location: unknown registry preset `$pagePreset`.');
      }
      continue;
    }
    final shell = const {'', 'bash', 'shell'}.contains(fence);
    final examples = switch (fence) {
      null => _inlineCode.allMatches(line).map((match) => match[1]!),
      'text' => [line.trim().split(_helpDescription).first],
      _ when shell => [line],
      _ => <String>[],
    };
    for (final example in examples) {
      final command = _command.firstMatch(example.split('#').first.trimRight());
      if (command == null) continue;
      final args = command[2] ?? '';
      if (command[1] == 'init') {
        if (!shell || args.startsWith('[')) continue;
        blockPreset = _presetOption.firstMatch(args)?[1] ?? 'vanilla';
        if (!catalogs.containsKey(blockPreset)) {
          failures.add('$location: unknown registry preset `$blockPreset`.');
        }
        continue;
      }
      final preset = blockPreset ?? pagePreset;
      failures.addAll(
        _checkAdd(
          args,
          location,
          preset == null ? catalogs.keys : [preset],
          catalogs,
        ),
      );
    }
  }
  return failures;
}

Iterable<String> _checkAdd(
  String arguments,
  String location,
  Iterable<String> presets,
  Map<String, Set<String>> catalogs,
) sync* {
  for (final match in _arguments.allMatches(arguments)) {
    final word = match.namedGroup('word');
    if (word == null) continue;
    final item = word.replaceAll(RegExp(r'''^["']|["']$'''), '');
    if (item.isEmpty ||
        RegExp(r'^[-\[$]').hasMatch(item) ||
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
