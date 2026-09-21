import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'registry_source.dart';

const projectConfigFileName = 'remix.yaml';
const supportedProjectSchema = 3;

/// A parsed `remix.yaml`.
///
/// One shape: every project names its registries and a default among them.
/// A configuration that cannot say where its source came from is not a
/// configuration this CLI can act on, so that combination is unrepresentable
/// rather than rejected at runtime.
final class ProjectConfig {
  ProjectConfig({
    required Directory packageRoot,
    required this.prefix,
    required this.preset,
    required this.uiPath,
    required this.defaultRegistry,
    required Map<String, RegistrySource> registries,
  }) : registries = Map.unmodifiable(registries) {
    _validatePrefix(prefix);
    _validateUiPath(packageRoot, uiPath);
    // A third-party registry names its own presets, so only the shape is
    // checked here; the registry itself rejects a preset it does not carry.
    _validatePresetName(preset);
    validateNamespace(defaultRegistry);
    for (final namespace in this.registries.keys) {
      validateNamespace(namespace);
    }
    if (!this.registries.containsKey(defaultRegistry)) {
      throw const FormatException(
        'defaultRegistry must name a configured registry.',
      );
    }
  }

  factory ProjectConfig.parse(String source, {required Directory packageRoot}) {
    final Object? document;
    try {
      document = loadYaml(source);
    } on YamlException catch (error) {
      throw FormatException('Invalid $projectConfigFileName: $error');
    }
    if (document is! YamlMap) {
      throw const FormatException('$projectConfigFileName must contain a map.');
    }
    final schema = document['schema'];
    if (schema is! int || schema != supportedProjectSchema) {
      throw FormatException(
        'Unsupported remix.yaml schema $schema; '
        'remix_cli supports schema $supportedProjectSchema. A project written '
        'by an earlier prerelease names no registry to read from: delete '
        'remix.yaml and run remix init to pin one. Installed source is yours '
        'and is left alone; review it afterwards with add --diff.',
      );
    }
    _requireExactKeys(document, {
      'schema',
      'prefix',
      'preset',
      'paths',
      'defaultRegistry',
      'registries',
    }, 'configuration');
    final prefix = document['prefix'];
    if (prefix is! String) {
      throw const FormatException('remix.yaml prefix must be a string.');
    }
    final preset = document['preset'];
    if (preset is! String) {
      throw const FormatException('remix.yaml preset must be a string.');
    }
    final paths = document['paths'];
    if (paths is! YamlMap) {
      throw const FormatException('remix.yaml paths must be a map.');
    }
    _requireExactKeys(paths, {'ui'}, 'paths');
    final uiPath = paths['ui'];
    if (uiPath is! String) {
      throw const FormatException('remix.yaml paths.ui must be a string.');
    }
    final configured = document['registries'];
    final defaultRegistry = document['defaultRegistry'];
    if (configured is! YamlMap || defaultRegistry is! String)
      throw const FormatException(
        'registries must be a map and defaultRegistry a string.',
      );
    final sources = <String, RegistrySource>{};
    for (final entry in configured.entries) {
      if (entry.key is! String || entry.value is! YamlMap)
        throw const FormatException('Invalid registry source.');
      final value = entry.value as YamlMap;
      _requireExactKeys(value, {
        'repository',
        'path',
        'ref',
        'revision',
      }, 'registry source');
      if (value.values.any((v) => v is! String))
        throw const FormatException('Registry source fields must be strings.');
      sources[entry.key as String] = RegistrySource(
        repository: value['repository'] as String,
        path: value['path'] as String,
        ref: value['ref'] as String,
        revision: value['revision'] as String,
      );
    }
    return ProjectConfig(
      packageRoot: packageRoot,
      prefix: prefix,
      preset: preset,
      uiPath: uiPath,
      defaultRegistry: defaultRegistry,
      registries: sources,
    );
  }

  final String prefix;
  final String preset;
  final String uiPath;
  final String defaultRegistry;
  final Map<String, RegistrySource> registries;

  int get schema => supportedProjectSchema;

  String get valuePrefix =>
      '${prefix.substring(0, 1).toLowerCase()}${prefix.substring(1)}';

  String encode() {
    final buffer =
        StringBuffer('schema: $schema\nprefix: ${_encodeYamlScalar(prefix)}\n')
          ..writeln('preset: ${_encodeYamlScalar(preset)}')
          ..writeln('paths:\n  ui: ${_encodeYamlPath(uiPath)}')
          ..writeln('defaultRegistry: ${jsonEncode(defaultRegistry)}')
          ..writeln('registries:');
    for (final entry in registries.entries) {
      final source = entry.value;
      buffer
        ..writeln('  ${jsonEncode(entry.key)}:')
        ..writeln('    repository: ${jsonEncode(source.repository)}')
        ..writeln('    path: ${jsonEncode(source.path)}')
        ..writeln('    ref: ${jsonEncode(source.ref)}')
        ..writeln('    revision: ${jsonEncode(source.revision)}');
    }
    return buffer.toString();
  }
}

void validateProjectSettings(
  Directory root, {
  required String prefix,
  required String preset,
  required String uiPath,
}) {
  _validatePrefix(prefix);
  _validatePresetName(preset);
  _validateUiPath(root, uiPath);
}

void validateProjectFilePath(Directory packageRoot, String relativePath) {
  _validateProjectPath(packageRoot, relativePath, _ProjectPathKind.file);
}

void _validateProjectPath(
  Directory packageRoot,
  String relativePath,
  _ProjectPathKind targetKind,
) {
  if (relativePath.isEmpty ||
      p.isAbsolute(relativePath) ||
      p.posix.isAbsolute(relativePath) ||
      relativePath.contains('\\')) {
    throw FormatException('$relativePath must be a project-relative path.');
  }
  final normalized = p.posix.normalize(relativePath);
  if (normalized != relativePath ||
      normalized == '..' ||
      normalized.startsWith('../')) {
    throw FormatException(
      '$relativePath must be normalized without traversal.',
    );
  }

  final root = packageRoot.resolveSymbolicLinksSync();
  final segments = p.posix.split(relativePath);
  var current = root;
  for (var index = 0; index < segments.length; index++) {
    final segment = segments[index];
    current = p.join(current, segment);
    final type = FileSystemEntity.typeSync(current, followLinks: false);
    if (type == FileSystemEntityType.notFound) {
      break;
    }
    final String resolved;
    try {
      resolved = switch (type) {
        FileSystemEntityType.directory => Directory(
          current,
        ).resolveSymbolicLinksSync(),
        FileSystemEntityType.file => File(current).resolveSymbolicLinksSync(),
        FileSystemEntityType.link => Link(current).resolveSymbolicLinksSync(),
        _ => throw FormatException(
          '$relativePath has an unsupported path type.',
        ),
      };
    } on FileSystemException {
      throw FormatException('$relativePath contains an unresolved link.');
    }
    if (resolved != root && !p.isWithin(root, resolved)) {
      throw FormatException('$relativePath resolves outside the package root.');
    }

    final effectiveType = type == FileSystemEntityType.link
        ? FileSystemEntity.typeSync(current)
        : type;
    final isTarget = index == segments.length - 1;
    if (!isTarget && effectiveType != FileSystemEntityType.directory) {
      throw FormatException(
        '$relativePath crosses a path that is not a directory.',
      );
    }
    if (isTarget &&
        targetKind == _ProjectPathKind.directory &&
        effectiveType != FileSystemEntityType.directory) {
      throw FormatException('$relativePath must be a directory path.');
    }
    if (isTarget &&
        targetKind == _ProjectPathKind.file &&
        effectiveType != FileSystemEntityType.file) {
      throw FormatException('$relativePath must be a file path.');
    }
    current = resolved;
  }
}

Directory validateFlutterPackageRoot(Directory directory) {
  final root = directory.absolute;
  final pubspec = File(p.join(root.path, 'pubspec.yaml'));
  if (!pubspec.existsSync()) {
    throw const FormatException(
      'Run remix from a Flutter package root containing pubspec.yaml.',
    );
  }

  final Object? document;
  try {
    document = loadYaml(pubspec.readAsStringSync());
  } on YamlException catch (error) {
    throw FormatException('Invalid pubspec.yaml: $error');
  }
  if (document is! YamlMap) {
    throw const FormatException('pubspec.yaml must contain a map.');
  }
  final dependencies = document['dependencies'];
  final flutter = dependencies is YamlMap ? dependencies['flutter'] : null;
  if (flutter is! YamlMap || flutter['sdk'] != 'flutter') {
    throw const FormatException(
      'Run remix from a Flutter package whose dependencies include the Flutter SDK.',
    );
  }
  return root;
}

void _validatePrefix(String prefix) {
  if (prefix == 'Remix' || prefix == 'Mix') {
    throw FormatException(
      '$prefix is reserved for runtime dependencies. '
      'Choose an application prefix such as Ui or Acme.',
    );
  }
  if (!RegExp(r'^[A-Z][A-Za-z0-9]*$').hasMatch(prefix)) {
    throw const FormatException(
      'prefix must be an ASCII UpperCamel Dart identifier.',
    );
  }
  final valuePrefix =
      '${prefix.substring(0, 1).toLowerCase()}${prefix.substring(1)}';
  if (_dartReservedWords.contains(valuePrefix)) {
    throw FormatException(
      '$prefix derives the reserved Dart word $valuePrefix.',
    );
  }
}

void _validatePresetName(String preset) {
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(preset)) {
    throw const FormatException('preset must be a lowercase ASCII identifier.');
  }
}

void _validateUiPath(Directory packageRoot, String uiPath) {
  _validateProjectPath(packageRoot, uiPath, _ProjectPathKind.directory);
  if (!uiPath.startsWith('lib/')) {
    throw const FormatException('paths.ui must be inside lib/.');
  }
}

String _encodeYamlPath(String value) =>
    _plainYamlPath.hasMatch(value) ? value : jsonEncode(value);

/// Quotes a scalar YAML would otherwise read back as something other than the
/// string that was written.
///
/// The prefix and preset grammars admit `TRUE`, `true` and `NULL`, which YAML
/// reads as a boolean or null and the parser then rejects as "must be a
/// string". Without this, a successful rewrite turns a readable project into
/// an unreadable one. Asking the parser beats listing keywords, which would
/// drift from whatever schema the YAML package implements.
String _encodeYamlScalar(String value) {
  final Object? parsed;
  try {
    parsed = loadYaml(value);
  } on YamlException {
    return jsonEncode(value);
  }
  return parsed is String && parsed == value ? value : jsonEncode(value);
}

void _requireExactKeys(YamlMap map, Set<String> expected, String location) {
  final keys = map.keys.whereType<String>().toSet();
  if (keys.length != map.length) {
    throw FormatException('$location keys must be strings.');
  }
  final missing = expected.difference(keys);
  final unknown = keys.difference(expected);
  if (missing.isNotEmpty) {
    throw FormatException('$location is missing ${missing.join(', ')}.');
  }
  if (unknown.isNotEmpty) {
    throw FormatException('$location has unknown keys: ${unknown.join(', ')}.');
  }
}

const _dartReservedWords = <String>{
  'abstract',
  'as',
  'assert',
  'async',
  'await',
  'base',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'covariant',
  'default',
  'deferred',
  'do',
  'dynamic',
  'else',
  'enum',
  'export',
  'extends',
  'extension',
  'external',
  'factory',
  'false',
  'final',
  'finally',
  'for',
  'Function',
  'get',
  'hide',
  'if',
  'implements',
  'import',
  'in',
  'interface',
  'is',
  'late',
  'library',
  'mixin',
  'new',
  'null',
  'of',
  'on',
  'operator',
  'part',
  'required',
  'rethrow',
  'return',
  'sealed',
  'set',
  'show',
  'static',
  'super',
  'switch',
  'sync',
  'this',
  'throw',
  'true',
  'try',
  'typedef',
  'var',
  'void',
  'when',
  'while',
  'with',
  'yield',
};

enum _ProjectPathKind { directory, file }

final _plainYamlPath = RegExp(r'^[A-Za-z0-9_./-]+$');
