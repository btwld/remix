import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import '../packages/remix_cli/lib/src/icon_registry.dart';

/// Checks that every constant in the shared icon table exists in its library's
/// package, as the workspace resolves it.
void main() {
  // Parsing already requires every icon to map in every library, the default
  // library to be present, and no constant to be claimed twice.
  final icons = IconRegistry.parse(
    File('registry/icons.yaml').readAsStringSync(),
  );
  for (final library in icons.libraries.entries) {
    final package = library.value.dependencies.keys.single;
    final constants = _packageConstants(
      package,
      library.value.dependencies[package]!,
    );
    for (final icon in icons.icons.entries) {
      final name = icon.value[library.key]!;
      if (!constants.contains(name)) {
        throw StateError('${library.key} has no icon constant $name.');
      }
    }
  }
  stdout.writeln(
    'The icon table is valid: ${icons.icons.length} icons in '
    '${icons.libraries.length} libraries.',
  );
}

Set<String> _packageConstants(String package, VersionConstraint constraint) {
  final root = _packageLib(package, constraint);
  final names = <String>{};
  final pattern = RegExp(r'static const [^ ]+ ([A-Za-z0-9_]+) =');
  for (final file
      in Directory(root)
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    names.addAll(
      pattern
          .allMatches(file.readAsStringSync())
          .map((match) => match.group(1)!),
    );
  }
  if (names.isEmpty) {
    throw StateError('$package does not declare icon constants.');
  }
  return names;
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
