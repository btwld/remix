import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

/// Typed reads from a parsed YAML document, shared by `registry.yaml`,
/// `icons.yaml`, and `remix.yaml`.
///
/// Each read throws a [FormatException] that names [label], the field's place
/// in its document, so every file reports a bad value the same way.

/// A Dart package name, also the shape of a registry item name.
final packageNamePattern = RegExp(r'^[a-z][a-z0-9_]*$');

YamlMap yamlMap(Object? source, String label) {
  if (source is! YamlMap) throw FormatException('$label must be a map.');
  return source;
}

String yamlString(Object? source, String label) {
  if (source is! String || source.isEmpty) {
    throw FormatException('$label must be a non-empty string.');
  }
  return source;
}

/// A list of strings; an absent list reads as empty.
List<String> yamlStringList(Object? source, String label) {
  if (source == null) return const [];
  if (source is! YamlList) throw FormatException('$label must be a list.');
  return [for (final value in source) yamlString(value, label)];
}

/// Requires string keys, every key in [required], and nothing outside
/// [required] and [optional].
void requireYamlKeys(
  YamlMap map,
  String label, {
  required Set<String> required,
  Set<String> optional = const {},
}) {
  final keys = map.keys.whereType<String>().toSet();
  if (keys.length != map.length) {
    throw FormatException('$label keys must be strings.');
  }
  final missing = required.difference(keys);
  if (missing.isNotEmpty) {
    throw FormatException('$label is missing ${missing.join(', ')}.');
  }
  final unknown = keys.difference({...required, ...optional});
  if (unknown.isNotEmpty) {
    throw FormatException('$label has unknown keys: ${unknown.join(', ')}.');
  }
}

/// Package names mapped to version constraints; an absent map reads as empty.
Map<String, VersionConstraint> yamlConstraints(Object? source, String label) {
  if (source == null) return const {};
  final map = yamlMap(source, label);
  final result = <String, VersionConstraint>{};
  for (final entry in map.nodes.entries) {
    final name = yamlString(entry.key.value, '$label name');
    if (!packageNamePattern.hasMatch(name)) {
      throw FormatException('$label has invalid package name $name.');
    }
    final value = yamlString(entry.value.value, '$label.$name');
    try {
      result[name] = VersionConstraint.parse(value);
    } on FormatException {
      throw FormatException('$label.$name has invalid constraint $value.');
    }
  }
  return Map.unmodifiable(result);
}
