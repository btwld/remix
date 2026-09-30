import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

/// The icon library a project uses when `remix.yaml` names none. Its
/// constants are also the canonical names in `icons.yaml`.
const defaultIconLibrary = 'remix';

/// The icon libraries a registry can install, and each icon's constant in each.
final class IconRegistry {
  IconRegistry._(this.libraries, this.icons);

  final Map<String, IconLibrary> libraries;
  final Map<String, Map<String, String>> icons;

  factory IconRegistry.parse(String source) {
    final document = loadYaml(source);
    if (document is! YamlMap ||
        document['schema'] != 1 ||
        document['libraries'] is! YamlMap ||
        document['icons'] is! YamlMap) {
      throw const FormatException(
        'Invalid icons.yaml; expected schema 1, libraries, and icons.',
      );
    }
    final libraries = <String, IconLibrary>{};
    for (final entry in (document['libraries'] as YamlMap).entries) {
      final value = entry.value;
      if (entry.key is! String ||
          value is! YamlMap ||
          value['import'] is! String ||
          value['class'] is! String) {
        throw const FormatException('Invalid icons.yaml library.');
      }
      libraries[entry.key as String] = IconLibrary(
        import: value['import'] as String,
        className: value['class'] as String,
        dependencies: _dependencies(value['dependency'], 'icons.yaml'),
      );
    }
    final icons = <String, Map<String, String>>{};
    // Two canonical icons must not render as the same glyph in any library.
    final claimed = <String, Map<String, String>>{};
    for (final entry in (document['icons'] as YamlMap).entries) {
      if (entry.key is! String || entry.value is! YamlMap) {
        throw const FormatException('Invalid icons.yaml icon mapping.');
      }
      final canonical = entry.key as String;
      final mapping = <String, String>{};
      for (final mapped in (entry.value as YamlMap).entries) {
        if (mapped.key is! String || mapped.value is! String) {
          throw const FormatException('Invalid icons.yaml icon mapping.');
        }
        final library = mapped.key as String;
        final constant = mapped.value as String;
        if (library == defaultIconLibrary && constant != canonical) {
          throw FormatException(
            'icons.yaml $defaultIconLibrary name for $canonical must be '
            '$canonical.',
          );
        }
        final taken = claimed.putIfAbsent(library, () => {});
        final previous = taken[constant];
        if (previous != null) {
          throw FormatException(
            'icons.yaml maps $library.$constant to both $previous and '
            '$canonical.',
          );
        }
        taken[constant] = canonical;
        mapping[library] = constant;
      }
      icons[canonical] = mapping;
    }
    return IconRegistry._(libraries, icons);
  }

  IconLibrary library(String name) =>
      libraries[name] ??
      (throw FormatException(
        'Icon library $name is not listed in icons.yaml.',
      ));

  String constant(String canonical, String libraryName) =>
      icons[canonical]?[libraryName] ??
      (throw FormatException(
        'Icon $canonical has no $libraryName mapping in icons.yaml.',
      ));
}

final class IconLibrary {
  const IconLibrary({
    required this.import,
    required this.className,
    required this.dependencies,
  });
  final String import;
  final String className;
  final Map<String, VersionConstraint> dependencies;
}

Map<String, VersionConstraint> _dependencies(Object? value, String file) {
  if (value is! YamlMap) {
    throw FormatException('$file dependency must be a map.');
  }
  final result = <String, VersionConstraint>{};
  for (final entry in value.entries) {
    if (entry.key is! String || entry.value is! String) {
      throw FormatException(
        '$file dependency names and constraints must be strings.',
      );
    }
    result[entry.key as String] = VersionConstraint.parse(
      entry.value as String,
    );
  }
  return result;
}
