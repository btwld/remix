import 'project_config.dart';
import 'registry.dart';
import 'registry_reader.dart';
import 'registry_source.dart';

/// A complete, validated dependency closure. Qualified names remain distinct
/// even when registries use the same local item name.
final class RegistryGraph {
  RegistryGraph._(this.items, this.catalogs, this._owners, this.requestedNames);

  final List<RegistryItem> items;
  final Map<String, RegistryCatalog> catalogs;

  /// What the caller asked for, in the same qualified naming [items] uses.
  /// `add --overwrite` replaces only these, so comparing an unqualified
  /// request against a qualified item would silently preserve the very file
  /// the caller asked to replace.
  final Set<String> requestedNames;

  /// The registry each item came from, so a template is always read back
  /// through the same pin that produced the item.
  final Map<String, RegistryReader> _owners;

  Future<String> template(RegistryItem item, RegistryFile file) =>
      _owners[item.name]!.template(file);

  static Future<RegistryGraph> resolve(
    ProjectConfig config,
    List<String> requested,
    RegistrySources sources,
  ) async {
    final catalogs = <String, RegistryCatalog>{};
    final readers = <String, RegistryReader>{};
    final owners = <String, RegistryReader>{};
    final ordered = <RegistryItem>[];
    final visiting = <String>[];
    final visited = <String>{};
    String qualify(String name, String namespace) {
      if (RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(name))
        return '$namespace/$name';
      if (!RegExp(r'^@[a-z][a-z0-9_-]*/[a-z][a-z0-9_]*$').hasMatch(name)) {
        throw FormatException('Invalid registry item $name.');
      }
      return name;
    }

    Future<void> visit(String id) async {
      if (visiting.contains(id))
        throw FormatException(
          'Registry dependency cycle: ${[...visiting, id].join(' -> ')}.',
        );
      if (visited.contains(id)) return;
      final namespace = id.split('/').first;
      final source = config.registries[namespace];
      if (source == null)
        throw FormatException(
          'Unknown registry $namespace. Register it explicitly with remix registry add $namespace --repository owner/repo.',
        );
      final reader = readers[namespace] ??= sources.open(source, config.preset);
      final catalog = catalogs[namespace] ??= await reader.catalog();
      final item = catalog.items[id.split('/').last];
      if (item == null)
        throw FormatException(
          'Unknown registry item $id in the ${config.preset} preset.',
        );
      visiting.add(id);
      for (final dependency in item.registryDependencies) {
        await visit(qualify(dependency, namespace));
      }
      visiting.removeLast();
      visited.add(id);
      owners[id] = reader;
      ordered.add(
        RegistryItem(
          name: id,
          registryDependencies: item.registryDependencies,
          dependencies: item.dependencies,
          devDependencies: item.devDependencies,
          files: item.files,
          generated: item.generated,
          exports: item.exports,
        ),
      );
    }

    if (requested.isEmpty) {
      throw const FormatException('Requested no registry items.');
    }
    // Qualify every root before visiting any, so a typo in the second request
    // is reported before the first one's registry is fetched.
    final roots = <String>{};
    for (final name in requested) {
      final id = qualify(name, config.defaultRegistry);
      if (!roots.add(id)) {
        throw FormatException('Registry item $id was requested twice.');
      }
    }
    // One traversal across all roots: `visited` is shared, so a dependency two
    // requests agree on is emitted once, in a position that satisfies both.
    for (final id in roots) {
      await visit(id);
    }
    final targets = <String, String>{};
    for (final item in ordered) {
      for (final target in [
        ...item.files.map((file) => file.target),
        ...item.generated,
      ]) {
        if (target == '@ui/ui.dart')
          throw const FormatException(
            'Registry items cannot own the managed UI barrel.',
          );
        for (final existing in targets.keys) {
          if (target.startsWith('$existing/') ||
              existing.startsWith('$target/')) {
            throw FormatException(
              '${targets[existing]} and ${item.name} have overlapping file targets $existing and $target.',
            );
          }
        }
        final previous = targets[target];
        if (previous != null)
          throw FormatException(
            '$previous and ${item.name} both target $target.',
          );
        targets[target] = item.name;
      }
    }
    return RegistryGraph._(
      List.unmodifiable(ordered),
      catalogs,
      owners,
      Set.unmodifiable(roots),
    );
  }
}
