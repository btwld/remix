import 'package:path/path.dart' as p;
import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import 'yaml_fields.dart';

/// Stands in for the consumer's configured UI path in every registry target.
///
/// Targets are stored independent of where a project installs, so one registry
/// serves every `uiPath`; the installer swaps this prefix for the configured
/// directory. Both the validator and that swap need the same spelling, and the
/// swap also needs its length.
const uiTargetPrefix = '@ui/';

final class RegistryCatalog {
  RegistryCatalog._({required this.preset, required this.items});

  factory RegistryCatalog.parse(String source, {required String preset}) {
    final Object? document;
    try {
      document = loadYaml(source);
    } on YamlException catch (error) {
      throw FormatException('Invalid registry.yaml: $error');
    }
    final root = yamlMap(document, 'registry');
    requireYamlKeys(root, 'registry', required: {'schema', 'items'});
    if (root['schema'] is! int ||
        (root['schema'] != 1 && root['schema'] != 2)) {
      throw FormatException(
        'Unsupported registry schema ${root['schema']}; remix_cli supports schemas 1 and 2.',
      );
    }
    final itemMap = yamlMap(root['items'], 'registry.items');
    final items = <String, RegistryItem>{};
    for (final entry in itemMap.nodes.entries) {
      final name = yamlString(entry.key.value, 'registry item name');
      if (!packageNamePattern.hasMatch(name)) {
        throw FormatException('Invalid registry item name $name.');
      }
      items[name] = _parseItem(name, entry.value.value);
      for (final dependency in items[name]!.registryDependencies) {
        if (!packageNamePattern.hasMatch(dependency) &&
            !(root['schema'] == 2 &&
                RegExp(
                  r'^@[a-z][a-z0-9_-]*/[a-z][a-z0-9_]*$',
                ).hasMatch(dependency))) {
          throw FormatException(
            'Invalid registry dependency $dependency for catalog schema ${root['schema']}.',
          );
        }
      }
    }
    final catalog = RegistryCatalog._(
      preset: preset,
      items: Map.unmodifiable(items),
    );
    catalog._validateGraphAndTargets();
    return catalog;
  }

  final String preset;
  final Map<String, RegistryItem> items;

  List<RegistryItem> resolve(String requested) => resolveAll([requested]);

  /// Orders every item [requested] needs, dependencies before dependents.
  ///
  /// One traversal across all roots rather than one per root: the `visited`
  /// set is shared, so an item two requests both depend on -- theme, most of
  /// the time -- is emitted once, in a position that satisfies both. That is
  /// what lets a batch install write each file once and declare each
  /// dependency once.
  List<RegistryItem> resolveAll(Iterable<String> requested) {
    final roots = requested.toList(growable: false);
    if (roots.isEmpty) {
      throw const FormatException('Requested no registry items.');
    }
    final seenRoots = <String>{};
    for (final root in roots) {
      if (!items.containsKey(root)) {
        throw FormatException(
          'Unknown registry item $root in the $preset preset.',
        );
      }
      if (!seenRoots.add(root)) {
        throw FormatException('Registry item $root was requested twice.');
      }
    }
    final ordered = <RegistryItem>[];
    final visited = <String>{};
    void visit(String name) {
      if (!visited.add(name)) return;
      final item = items[name]!;
      for (final dependency in item.registryDependencies) {
        if (dependency.startsWith('@'))
          throw const FormatException(
            'Namespaced dependencies require a configured multi-registry project.',
          );
        visit(dependency);
      }
      ordered.add(item);
    }

    for (final root in roots) {
      visit(root);
    }
    return List.unmodifiable(ordered);
  }

  void _validateGraphAndTargets() {
    final visiting = <String>{};
    final visited = <String>{};
    void visit(String name, List<String> path) {
      if (visiting.contains(name)) {
        throw FormatException(
          'Registry dependency cycle: ${[...path, name].join(' -> ')}.',
        );
      }
      if (!visited.add(name)) return;
      visiting.add(name);
      for (final dependency in items[name]!.registryDependencies) {
        if (dependency.startsWith('@')) continue;
        if (!items.containsKey(dependency)) {
          throw FormatException('$name depends on missing item $dependency.');
        }
        visit(dependency, [...path, name]);
      }
      visiting.remove(name);
    }

    for (final name in items.keys) {
      visit(name, const []);
    }

    final owners = <String, String>{};
    for (final item in items.values) {
      final targets = [
        ...item.files.map((file) => file.target),
        ...item.generated,
      ];
      for (final target in targets) {
        final previous = owners[target];
        if (previous != null) {
          throw FormatException(
            '${item.name} and $previous both target $target.',
          );
        }
        owners[target] = item.name;
      }
    }
  }
}

final class RegistryItem {
  const RegistryItem({
    required this.name,
    required this.registryDependencies,
    required this.dependencies,
    required this.devDependencies,
    required this.files,
    required this.generated,
    required this.exports,
  });

  final String name;
  final List<String> registryDependencies;
  final Map<String, VersionConstraint> dependencies;
  final Map<String, VersionConstraint> devDependencies;
  final List<RegistryFile> files;
  final List<String> generated;
  final List<String> exports;
}

final class RegistryFile {
  const RegistryFile({required this.source, required this.target});

  final String source;
  final String target;
}

RegistryItem _parseItem(String name, Object? source) {
  final map = yamlMap(source, 'item $name');
  requireYamlKeys(
    map,
    'item $name',
    required: {'files'},
    optional: {
      'registryDependencies',
      'dependencies',
      'devDependencies',
      'generated',
      'exports',
    },
  );
  final registryDependencies = yamlStringList(
    map['registryDependencies'],
    'item $name registryDependencies',
  );
  if (registryDependencies.toSet().length != registryDependencies.length) {
    throw FormatException('item $name has duplicate registryDependencies.');
  }
  final filesNode = map['files'];
  if (filesNode is! YamlList || filesNode.isEmpty) {
    throw FormatException('item $name files must be a non-empty list.');
  }
  final files = <RegistryFile>[];
  for (var index = 0; index < filesNode.length; index++) {
    final file = yamlMap(filesNode[index], 'item $name files[$index]');
    requireYamlKeys(
      file,
      'item $name files[$index]',
      required: {'source', 'target'},
    );
    final sourcePath = yamlString(file['source'], 'source');
    _validateRelative(
      sourcePath,
      label: 'template source',
      prefix: 'templates/',
    );
    final target = yamlString(file['target'], 'target');
    _validateTarget(target);
    files.add(RegistryFile(source: sourcePath, target: target));
  }
  final generated = yamlStringList(map['generated'], 'item $name generated');
  for (final target in generated) {
    _validateTarget(target);
  }
  final exports = yamlStringList(map['exports'], 'item $name exports');
  for (final export in exports) {
    _validateRelative(export, label: 'export');
  }
  return RegistryItem(
    name: name,
    registryDependencies: List.unmodifiable(registryDependencies),
    dependencies: yamlConstraints(
      map['dependencies'],
      'item $name dependencies',
    ),
    devDependencies: yamlConstraints(
      map['devDependencies'],
      'item $name devDependencies',
    ),
    files: List.unmodifiable(files),
    generated: List.unmodifiable(generated),
    exports: List.unmodifiable(exports),
  );
}

void _validateTarget(String target) {
  if (!target.startsWith(uiTargetPrefix)) {
    throw FormatException(
      'Registry target $target must start with $uiTargetPrefix.',
    );
  }
  _validateRelative(
    target.substring(uiTargetPrefix.length),
    label: 'registry target',
  );
}

void _validateRelative(String value, {required String label, String? prefix}) {
  if (value.isEmpty ||
      value == '.' ||
      RegExp(r'''[%?#:'"\x00-\x1f]''').hasMatch(value) ||
      value.contains('\\') ||
      p.posix.isAbsolute(value) ||
      p.posix.normalize(value) != value ||
      value == '..' ||
      value.startsWith('../') ||
      (prefix != null && !value.startsWith(prefix))) {
    throw FormatException('$label $value must be a normalized safe path.');
  }
}
