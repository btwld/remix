import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import '../packages/remix_cli/lib/src/icon_registry.dart';

/// The remix_ui_icons manifest: what became of every 0.1.x icon name.
const _manifestPath = 'packages/remix_ui_icons/tool/icons/manifest.yaml';

/// Checks the shared icon table against the packages it installs.
///
/// - Every constant exists on its library's class, as the workspace resolves
///   the package, and is not a deprecated alias.
/// - Every `remix` mapping agrees with the remix_ui_icons manifest: a
///   canonical name that is a 0.1.x icon maps to its exact replacement, may
///   map to its partial match, and must fall back when it was removed.
void main() {
  // Parsing already requires every icon to map in every library or name a
  // fallback that does, the default library to be present, and no constant
  // to be claimed twice.
  final icons = IconRegistry.parse(
    File('registry/icons.yaml').readAsStringSync(),
  );
  final failures = <String>[];
  for (final library in icons.libraries.entries) {
    final package = library.value.dependencies.keys.single;
    final members = _classMembers(
      package,
      library.value.dependencies[package]!,
      library.value.className,
    );
    for (final icon in icons.icons.entries) {
      final name = icon.value[library.key];
      if (name == null) continue;
      final member = members[name];
      if (member == null) {
        failures.add(
          '${library.key} has no icon constant '
          '${library.value.className}.$name (icons.${icon.key}).',
        );
      } else if (member.deprecated) {
        failures.add(
          'icons.${icon.key} maps ${library.key} to the deprecated '
          '${library.value.className}.$name; use its replacement.',
        );
      }
    }
  }
  failures.addAll(_checkManifest(icons));

  if (failures.isNotEmpty) {
    stderr.writeln('Icon table validation failed:');
    for (final failure in failures) {
      stderr.writeln('- $failure');
    }
    exitCode = 1;
    return;
  }
  final fallbacks = icons.fallbacks.length;
  stdout.writeln(
    'The icon table is valid: ${icons.icons.length} icons in '
    '${icons.libraries.length} libraries; '
    '${icons.icons.length - fallbacks} render from $defaultIconLibrary and '
    '$fallbacks fall back.',
  );
}

List<String> _checkManifest(IconRegistry icons) {
  final manifest = loadYaml(File(_manifestPath).readAsStringSync()) as YamlMap;
  final legacy = manifest['legacy'] as YamlMap;
  final failures = <String>[];
  for (final icon in icons.icons.entries) {
    final entry = legacy[icon.key];
    if (entry is! YamlMap) continue;
    final status = entry['status'] as String;
    final target = entry['target'] as String?;
    final remix = icon.value[defaultIconLibrary];
    switch (status) {
      case 'exact' when remix != target:
        failures.add(
          'icons.${icon.key}: remix_ui_icons replaces ${icon.key} exactly '
          'with $target, so the $defaultIconLibrary mapping must be $target, '
          'not ${remix ?? 'a fallback'}.',
        );
      case 'partial' when remix != null && remix != target:
        failures.add(
          'icons.${icon.key}: remix_ui_icons\' closest match is $target; map '
          '$defaultIconLibrary to it or fall back, not to $remix.',
        );
      case 'removed' when remix != null:
        failures.add(
          'icons.${icon.key}: remix_ui_icons has no ${icon.key}, so it must '
          'fall back rather than map $defaultIconLibrary to $remix.',
        );
    }
  }
  return failures;
}

typedef _Member = ({bool deprecated});

/// The static constants declared in [className], from the package's `lib/`.
Map<String, _Member> _classMembers(
  String package,
  VersionConstraint constraint,
  String className,
) {
  final root = _packageLib(package, constraint);
  final declaration = RegExp(
    '^(?:@\\w+\\s+)*(?:abstract\\s+)?(?:final\\s+)?class $className\\b[^{]*\\{',
    multiLine: true,
  );
  final member = RegExp(
    r'((?:\s*@\w+(?:\([^)]*\))?)*)\s*static const [^ ]+ ([A-Za-z0-9_]+) =',
  );
  final members = <String, _Member>{};
  for (final file
      in Directory(root)
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final source = file.readAsStringSync();
    final start = declaration.firstMatch(source);
    if (start == null) continue;
    // The class body runs to the first closing brace at the start of a line.
    final end = source.indexOf('\n}', start.end);
    final body = source.substring(start.end, end == -1 ? null : end);
    for (final match in member.allMatches(body)) {
      members[match[2]!] = (deprecated: match[1]!.contains('@Deprecated'));
    }
  }
  if (members.isEmpty) {
    throw StateError('$package does not declare icon constants on $className.');
  }
  return members;
}

/// The `lib/` directory of [package] as the workspace resolved it.
///
/// Every icon library's package is a workspace member or a root dev
/// dependency, so it is always in the root package config, and its resolved
/// version must satisfy the table's constraint.
String _packageLib(String package, VersionConstraint constraint) {
  final configFile = File('.dart_tool/package_config.json');
  if (!configFile.existsSync()) {
    throw StateError('Run `dart run melos bootstrap` before this check.');
  }
  final config = jsonDecode(configFile.readAsStringSync()) as Map;
  for (final entry in config['packages'] as List) {
    if (entry is! Map || entry['name'] != package) continue;
    var root = configFile.absolute.uri.resolve(entry['rootUri'] as String);
    if (!root.path.endsWith('/')) root = root.replace(path: '${root.path}/');
    final pubspec =
        loadYaml(File.fromUri(root.resolve('pubspec.yaml')).readAsStringSync())
            as YamlMap;
    final version = Version.parse(pubspec['version'] as String);
    if (!constraint.allows(version)) {
      throw StateError(
        'The workspace resolves $package $version, outside the icon table\'s '
        '$constraint. Move the root dev_dependency or the table together.',
      );
    }
    return p.normalize(
      root.resolve(entry['packageUri'] as String? ?? 'lib/').toFilePath(),
    );
  }
  throw StateError(
    '$package is not resolved in the workspace. Add it to the root '
    'dev_dependencies so this check can read its constants.',
  );
}
