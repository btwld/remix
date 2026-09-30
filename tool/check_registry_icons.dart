import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';

import '../packages/remix_cli/lib/src/icon_registry.dart';

/// Checks the shared icon table before the installer consumes it.
///
/// Parsing rejects a constant claimed by two canonical names. Every mapped
/// constant must also exist in that library's package.
void main() {
  final icons = IconRegistry.parse(
    File('registry/icons.yaml').readAsStringSync(),
  );
  if (!icons.libraries.containsKey(defaultIconLibrary)) {
    throw StateError('icons.yaml must define $defaultIconLibrary.');
  }
  for (final library in icons.libraries.entries) {
    final package = library.value.dependencies.keys.single;
    final constants = _packageConstants(
      package,
      library.value.dependencies[package]!,
    );
    for (final icon in icons.icons.entries) {
      final name = icon.value[library.key];
      if (name == null || name.isEmpty) {
        throw StateError('${icon.key} has no ${library.key} icon mapping.');
      }
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

String _packageLib(String package, VersionConstraint constraint) {
  final configured = _packageConfigLib(package);
  if (configured != null) return configured;
  final cached = _cachedLib(package, constraint);
  if (cached != null) return cached;
  final added = Process.runSync(Platform.resolvedExecutable, [
    'pub',
    'cache',
    'add',
    '$package:$constraint',
  ]);
  if (added.exitCode != 0) {
    throw StateError(
      'Could not cache $package $constraint.\n${added.stdout}${added.stderr}',
    );
  }
  final after = _cachedLib(package, constraint);
  if (after == null) {
    throw StateError('$package $constraint was not found in the pub cache.');
  }
  return after;
}

String? _packageConfigLib(String package) {
  const configs = [
    '.dart_tool/package_config.json',
    'registry_source/.dart_tool/package_config.json',
  ];
  for (final relative in configs) {
    final resolved = _libFromPackageConfig(File(relative), package);
    if (resolved != null) return resolved;
  }
  final workspace = Directory('packages/$package/lib');
  if (workspace.existsSync()) return workspace.path;
  return null;
}

String? _libFromPackageConfig(File configFile, String package) {
  if (!configFile.existsSync()) return null;
  final config = jsonDecode(configFile.readAsStringSync()) as Map;
  for (final entry in config['packages'] as List) {
    if (entry is! Map || entry['name'] != package) continue;
    var root = configFile.absolute.uri.resolve(entry['rootUri'] as String);
    if (!root.path.endsWith('/')) {
      root = root.replace(path: '${root.path}/');
    }
    return p.normalize(
      root.resolve(entry['packageUri'] as String? ?? 'lib/').toFilePath(),
    );
  }
  return null;
}

String? _cachedLib(String package, VersionConstraint constraint) {
  final cache =
      Platform.environment['PUB_CACHE'] ??
      p.join(Platform.environment['HOME'] ?? '', '.pub-cache');
  final hosted = Directory(p.join(cache, 'hosted', 'pub.dev'));
  if (!hosted.existsSync()) return null;
  Version? best;
  String? bestPath;
  for (final directory in hosted.listSync().whereType<Directory>()) {
    final name = p.basename(directory.path);
    final separator = name.lastIndexOf('-');
    if (separator <= 0 || name.substring(0, separator) != package) continue;
    final Version version;
    try {
      version = Version.parse(name.substring(separator + 1));
    } on FormatException {
      continue;
    }
    if (!constraint.allows(version)) continue;
    if (best == null || version > best) {
      best = version;
      bestPath = p.join(directory.path, 'lib');
    }
  }
  return bestPath;
}
