import 'dart:convert';
import 'dart:math' as math;

import 'package:path/path.dart' as p;

import 'project_config.dart';
import 'registry.dart';

/// The line `add` and `list` print for each registry they read.
String revisionLine(ProjectConfig config, String namespace) =>
    '$namespace (${config.preset}) revision '
    '${config.registries[namespace]!.revision}';

/// The `remix list` text. Each registry prints its revision line, then its
/// items grouped by the directory their first file installs to.
///
/// Names print the way `add` accepts them: bare for the default registry,
/// qualified for every other one.
String catalogListingText(
  ProjectConfig config,
  Map<String, RegistryCatalog> catalogs,
) {
  final lines = <String>[];
  var count = 0;
  for (final MapEntry(key: namespace, value: catalog) in catalogs.entries) {
    lines.add(revisionLine(config, namespace));
    final items = catalog.items.values;
    count += items.length;
    final width =
        items
            .map((item) => config.addSpelling('$namespace/${item.name}').length)
            .fold(0, math.max) +
        2;
    final groups = <String, List<RegistryItem>>{};
    for (final item in items) {
      groups.putIfAbsent(_installDirectory(config, item), () => []).add(item);
    }
    for (final MapEntry(key: group, value: members) in groups.entries) {
      lines.add('$group/');
      for (final item in members) {
        final needs = [
          for (final dependency in item.registryDependencies)
            config.addSpelling(qualifyRegistryItem(dependency, namespace)),
        ];
        final name = config.addSpelling('$namespace/${item.name}');
        lines.add(
          needs.isEmpty
              ? '  $name'
              : '  ${name.padRight(width)}needs ${_collapse(needs)}',
        );
      }
    }
  }
  lines.add(
    '$count items. Install with: remix add <item...>. '
    'Preview first with --dry-run.',
  );
  return lines.join('\n');
}

/// The `remix list --json` document. Ids are qualified.
String catalogListingJson(
  ProjectConfig config,
  Map<String, RegistryCatalog> catalogs,
) => const JsonEncoder.withIndent('  ').convert({
  'schema': 1,
  'preset': config.preset,
  'registries': [
    for (final MapEntry(key: namespace, value: catalog) in catalogs.entries)
      {
        'namespace': namespace,
        'default': namespace == config.defaultRegistry,
        'repository': config.registries[namespace]!.repository,
        'revision': config.registries[namespace]!.revision,
        'items': [
          for (final item in catalog.items.values)
            {
              'id': '$namespace/${item.name}',
              'group': _installDirectory(config, item),
              'registryDependencies': [
                for (final dependency in item.registryDependencies)
                  qualifyRegistryItem(dependency, namespace),
              ],
              'files': [
                for (final file in item.files) config.targetPath(file.target),
              ],
              'generated': [
                for (final target in item.generated) config.targetPath(target),
              ],
            },
        ],
      },
  ],
});

String _installDirectory(ProjectConfig config, RegistryItem item) =>
    p.posix.dirname(config.targetPath(item.files.first.target));

String _collapse(List<String> names) => names.length <= 4
    ? names.join(', ')
    : '${names.take(4).join(', ')}, and ${names.length - 4} more';
