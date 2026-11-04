import 'dart:convert';

import 'package:path/path.dart' as p;

import 'project_config.dart';
import 'registry.dart';

/// The line `add` and `list` print for each registry they read.
String revisionLine(ProjectConfig config, String namespace) =>
    '$namespace (${config.preset}) revision '
    '${config.registries[namespace]!.revision}';

/// The `remix list` text. Each registry prints its revision line, then its
/// items grouped by the directory their first file installs to. A schema-2
/// catalog carries no category, so the install layout is the grouping.
///
/// Names print the way `add` accepts them: bare for the default registry,
/// qualified for every other one.
String catalogListingText(
  ProjectConfig config,
  Map<String, RegistryCatalog> catalogs,
) {
  String display(String id) {
    final defaultPrefix = '${config.defaultRegistry}/';
    return id.startsWith(defaultPrefix)
        ? id.substring(defaultPrefix.length)
        : id;
  }

  final lines = <String>[];
  var count = 0;
  for (final MapEntry(key: namespace, value: catalog) in catalogs.entries) {
    lines.add(revisionLine(config, namespace));
    final items = catalog.items.values;
    count += items.length;
    final width =
        items
            .map((item) => display('$namespace/${item.name}').length)
            .fold(0, (longest, length) => length > longest ? length : longest) +
        2;
    final groups = <String, List<RegistryItem>>{};
    for (final item in items) {
      groups.putIfAbsent(_group(config, item), () => []).add(item);
    }
    for (final MapEntry(key: group, value: members) in groups.entries) {
      lines.add('$group/');
      for (final item in members) {
        final needs = [
          for (final dependency in item.registryDependencies)
            display(_qualify(dependency, namespace)),
        ];
        final name = display('$namespace/${item.name}');
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

/// The `remix list --json` document for scripts and agents. Ids are
/// qualified, because `add` accepts that form for every registry.
String catalogListingJson(
  ProjectConfig config,
  Map<String, RegistryCatalog> catalogs,
) => const JsonEncoder.withIndent('  ').convert({
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
              'group': _group(config, item),
              'registryDependencies': [
                for (final dependency in item.registryDependencies)
                  _qualify(dependency, namespace),
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

String _group(ProjectConfig config, RegistryItem item) =>
    p.posix.dirname(config.targetPath(item.files.first.target));

/// Catalog dependencies are bare within their own registry and qualified
/// across registries.
String _qualify(String dependency, String namespace) =>
    dependency.startsWith('@') ? dependency : '$namespace/$dependency';

String _collapse(List<String> names) => names.length <= 4
    ? names.join(', ')
    : '${names.take(4).join(', ')}, and ${names.length - 4} more';
