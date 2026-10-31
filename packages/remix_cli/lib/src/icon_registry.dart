import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import 'yaml_fields.dart';

/// The icon library a project uses when `remix.yaml` names none.
///
/// In a schema 1 table its constants are also the canonical names.
const defaultIconLibrary = 'remix';

/// The `icons.yaml` schemas this CLI reads.
const supportedIconSchemas = {1, 2};

/// The icon libraries a registry can install, and each icon's constant in each.
///
/// Schema 1 maps every icon in every library, and the default library's
/// constant is the canonical name. Schema 2 lets an icon leave libraries out
/// when it names a `fallback` library that maps it: a project on a library
/// without the icon renders the fallback's constant instead, and installs the
/// fallback's package. The default library's constant may then differ from
/// the canonical name, so a registry can keep its canonical names while the
/// default library renames a glyph.
final class IconRegistry {
  IconRegistry._(this.schema, this.libraries, this.icons, this.fallbacks);

  final int schema;
  final Map<String, IconLibrary> libraries;

  /// Each icon's constant in every library that maps it.
  final Map<String, Map<String, String>> icons;

  /// The fallback library of each icon that declares one.
  final Map<String, String> fallbacks;

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
    final schema = root['schema'];
    if (schema is! int || !supportedIconSchemas.contains(schema)) {
      throw FormatException(
        'Unsupported icons.yaml schema $schema; remix_cli supports '
        '${supportedIconSchemas.join(' and ')}. The registry may need a newer '
        'remix_cli; upgrade it and try again.',
      );
    }

    final libraries = <String, IconLibrary>{};
    for (final entry in yamlMap(root['libraries'], 'libraries').nodes.entries) {
      final name = yamlString(entry.key.value, 'library name');
      if (!packageNamePattern.hasMatch(name)) {
        throw FormatException(
          'icons.yaml library $name must be a lowercase name, as '
          'iconLibrary is in remix.yaml.',
        );
      }
      if (schema == 2 && name == 'fallback') {
        throw const FormatException(
          'icons.yaml library fallback clashes with the fallback key of an '
          'icon; rename the library.',
        );
      }
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
    final fallbacks = <String, String>{};
    // Two canonical icons must not render as the same glyph in any library.
    final claimed = <String, Map<String, String>>{};
    for (final entry in yamlMap(root['icons'], 'icons').nodes.entries) {
      final canonical = yamlString(entry.key.value, 'icon name');
      final label = 'icons.$canonical';
      final value = yamlMap(entry.value, label);
      String? fallback;
      if (schema == 1) {
        requireYamlKeys(value, label, required: libraries.keys.toSet());
      } else {
        requireYamlKeys(
          value,
          label,
          required: const {},
          optional: {...libraries.keys, 'fallback'},
        );
        if (value.containsKey('fallback')) {
          fallback = yamlString(value['fallback'], '$label.fallback');
          if (!libraries.containsKey(fallback)) {
            throw FormatException(
              '$label.fallback names $fallback, which icons.yaml does not '
              'list under libraries.',
            );
          }
          if (!value.containsKey(fallback)) {
            throw FormatException(
              '$label.fallback is $fallback, so $label must map $fallback.',
            );
          }
          if (libraries.keys.every(value.containsKey)) {
            throw FormatException(
              '$label maps every library, so its fallback is never used. '
              'Remove it.',
            );
          }
          fallbacks[canonical] = fallback;
        } else {
          final missing = libraries.keys.where(
            (key) => !value.containsKey(key),
          );
          if (missing.isNotEmpty) {
            throw FormatException(
              '$label has no ${missing.join(', ')} mapping. Map it, or name a '
              'fallback library that does.',
            );
          }
        }
      }
      final mapping = <String, String>{};
      for (final library in libraries.keys) {
        if (!value.containsKey(library)) continue;
        final constant = yamlString(value[library], '$label.$library');
        if (schema == 1 &&
            library == defaultIconLibrary &&
            constant != canonical) {
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
    return IconRegistry._(
      schema,
      Map.unmodifiable(libraries),
      Map.unmodifiable(icons),
      Map.unmodifiable(fallbacks),
    );
  }

  IconLibrary library(String name) =>
      libraries[name] ??
      (throw FormatException(
        'Icon library $name is not listed in icons.yaml.',
      ));

  /// The library and constant that render [canonical] for a project on
  /// [libraryName]: that library's own constant, else its fallback's.
  ResolvedIcon resolve(String canonical, String libraryName) {
    library(libraryName);
    final mapping =
        icons[canonical] ??
        (throw FormatException('Icon $canonical is not listed in icons.yaml.'));
    final own = mapping[libraryName];
    if (own != null) return (library: libraryName, constant: own);
    final fallback = fallbacks[canonical];
    if (fallback == null) {
      throw FormatException(
        'Icon $canonical has no $libraryName mapping in icons.yaml.',
      );
    }
    return (library: fallback, constant: mapping[fallback]!);
  }

  /// [canonical]'s constant in [libraryName], or in its fallback library.
  String constant(String canonical, String libraryName) =>
      resolve(canonical, libraryName).constant;

  /// The canonical name an authored `Class.constant` of [libraryName]
  /// stands for, or null when it is not one of this table's icons.
  ///
  /// A fallback library's constant only stands for an icon that the
  /// default library does not map: source written for the default library
  /// must use the default library's glyph whenever there is one.
  String? canonicalFor(String libraryName, String constant) {
    for (final entry in icons.entries) {
      if (entry.value[libraryName] != constant) continue;
      if (libraryName == defaultIconLibrary ||
          (!entry.value.containsKey(defaultIconLibrary) &&
              fallbacks[entry.key] == libraryName)) {
        return entry.key;
      }
    }
    return null;
  }
}

/// Where one icon's constant comes from for a project.
typedef ResolvedIcon = ({String library, String constant});

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
