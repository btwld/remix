import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import 'yaml_fields.dart';

/// The icon library a project uses when `remix.yaml` names none. Its
/// constants are also the canonical names in `icons.yaml`.
const defaultIconLibrary = 'remix';

/// The icon libraries a registry can install, and each icon's constant in each.
final class IconRegistry {
  IconRegistry._(this.libraries, this.icons);

  final Map<String, IconLibrary> libraries;
  final Map<String, Map<String, String>> icons;

  factory IconRegistry.parse(String source) {
    final Object? document;
    try {
      document = loadYaml(source);
    } on YamlException catch (error) {
      throw FormatException('Invalid icons.yaml: $error');
    }
    final root = yamlMap(document, 'icons.yaml');
    requireYamlKeys(
      root,
      'icons.yaml',
      required: {'schema', 'libraries', 'icons'},
    );
    if (root['schema'] != 1) {
      throw FormatException(
        'Unsupported icons.yaml schema ${root['schema']}; remix_cli supports 1.',
      );
    }

    final libraries = <String, IconLibrary>{};
    for (final entry in yamlMap(root['libraries'], 'libraries').nodes.entries) {
      final name = yamlString(entry.key.value, 'library name');
      final label = 'libraries.$name';
      final value = yamlMap(entry.value, label);
      requireYamlKeys(
        value,
        label,
        required: {'dependency', 'import', 'class'},
      );
      final dependencies = yamlConstraints(
        value['dependency'],
        '$label.dependency',
      );
      if (dependencies.length != 1) {
        throw FormatException('$label.dependency must name one package.');
      }
      libraries[name] = IconLibrary(
        import: yamlString(value['import'], '$label.import'),
        className: yamlString(value['class'], '$label.class'),
        dependencies: dependencies,
      );
    }
    if (!libraries.containsKey(defaultIconLibrary)) {
      throw FormatException('icons.yaml must define $defaultIconLibrary.');
    }

    final icons = <String, Map<String, String>>{};
    // Two canonical icons must not render as the same glyph in any library.
    final claimed = <String, Map<String, String>>{};
    for (final entry in yamlMap(root['icons'], 'icons').nodes.entries) {
      final canonical = yamlString(entry.key.value, 'icon name');
      final label = 'icons.$canonical';
      final value = yamlMap(entry.value, label);
      requireYamlKeys(value, label, required: libraries.keys.toSet());
      final mapping = <String, String>{};
      for (final library in libraries.keys) {
        final constant = yamlString(value[library], '$label.$library');
        if (library == defaultIconLibrary && constant != canonical) {
          throw FormatException('$label.$library must be $canonical.');
        }
        final previous = claimed.putIfAbsent(library, () => {})[constant];
        if (previous != null) {
          throw FormatException(
            'icons.yaml maps $library.$constant to both $previous and '
            '$canonical.',
          );
        }
        claimed[library]![constant] = canonical;
        mapping[library] = constant;
      }
      icons[canonical] = Map.unmodifiable(mapping);
    }
    return IconRegistry._(Map.unmodifiable(libraries), Map.unmodifiable(icons));
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
