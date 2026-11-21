import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;

import 'project_config.dart';
import 'registry_graph.dart';
import 'registry_source.dart';

const ownershipFileName = 'remix.ownership.json';
const _registry511MigrationGuide =
    'https://github.com/btwld/remix/blob/main/open_code/REGISTRY_511_MIGRATION.md';

/// Durable target reservations, including generated outputs and missing files.
/// Revision and namespace are deliberately absent from identity: moving a pin
/// or registering an alias must not change who owns an installed recipe.
final class OwnershipPlan {
  OwnershipPlan._(this.before, this.after);

  final String? before;
  final String after;
  bool get changed => before != after;

  static OwnershipPlan resolve(
    ProjectConfig config,
    RegistryGraph graph, {
    required Set<String> adoptNames,
    required Set<String> managedExports,
  }) {
    final root = config.packageRoot;
    validateProjectFilePath(root, ownershipFileName);
    final file = File(p.join(root.path, ownershipFileName));
    final before = file.existsSync() ? file.readAsStringSync() : null;
    final targets = <String, String>{};
    final recordedPaths = <String>{};
    final context = <String, String>{
      'prefix': config.prefix,
      'preset': config.preset,
      'uiPath': config.uiPath,
    };
    if (before != null) {
      final document = jsonDecode(before);
      if (document is! Map<String, dynamic> ||
          document['schema'] != 1 ||
          document['context'] is! Map ||
          document['targets'] is! Map ||
          document.keys.any(
            (key) => !{'schema', 'context', 'targets'}.contains(key),
          )) {
        throw const FormatException(
          'Unsupported or malformed remix.ownership.json. Restore it from version control.',
        );
      }
      final savedContext = document['context'] as Map;
      if (savedContext.length != context.length ||
          context.entries.any(
            (entry) => savedContext[entry.key] != entry.value,
          )) {
        throw const FormatException(
          'remix.ownership.json does not match the project prefix, preset, and UI path. Restore the matching configuration and source.',
        );
      }
      for (final entry in (document['targets'] as Map).entries) {
        if (entry.key is! String ||
            entry.value is! String ||
            !RegExp(
              r'^[^/]+/[^/]+/[^#]+#[a-z][a-z0-9_]*/[a-z][a-z0-9_]*$',
            ).hasMatch(entry.value as String)) {
          throw const FormatException(
            'Malformed target owner in remix.ownership.json.',
          );
        }
        final target = entry.key as String;
        if (!target.startsWith('${config.uiPath}/') ||
            target == '${config.uiPath}/ui.dart') {
          throw const FormatException(
            'Invalid ownership target in remix.ownership.json.',
          );
        }
        recordedPaths.add(validateProjectFilePath(root, target));
        targets[target] = entry.value as String;
      }
    }

    bool hasRecordedFile(String target) {
      final path = validateProjectFilePath(root, target);
      return recordedPaths.contains(path) ||
          (File(path).existsSync() &&
              recordedPaths.any(
                (recordedPath) =>
                    File(recordedPath).existsSync() &&
                    FileSystemEntity.identicalSync(path, recordedPath),
              ));
    }

    // Resolve internal symlinks too, so different spellings of one output
    // cannot bypass the cross-invocation check. Validation rejects escapes.
    String canonical(String target) {
      validateProjectFilePath(root, target);
      var ancestor = p.joinAll([root.path, ...p.posix.split(target)]);
      final suffix = <String>[];
      while (FileSystemEntity.typeSync(ancestor, followLinks: false) ==
          FileSystemEntityType.notFound) {
        suffix.insert(0, p.basename(ancestor));
        ancestor = p.dirname(ancestor);
      }
      final resolved = FileSystemEntity.isDirectorySync(ancestor)
          ? Directory(ancestor).resolveSymbolicLinksSync()
          : File(ancestor).resolveSymbolicLinksSync();
      final path = p.joinAll([resolved, ...suffix]);
      // Keep the boundary portable to Windows and default macOS filesystems.
      // Case-only target differences cannot safely compose on every host.
      return path.toLowerCase();
    }

    final reservations = <String, (String, String)>{};
    for (final entry in targets.entries) {
      final path = canonical(entry.key);
      final previous = reservations[path];
      if (previous != null && previous.$2 != entry.value) {
        throw FormatException(
          '${entry.key} and ${previous.$1} have conflicting recorded owners and resolve to the same file. Restore their separate targets before installing.',
        );
      }
      reservations[path] = (entry.key, entry.value);
    }
    final barrel = canonical('${config.uiPath}/ui.dart');
    final planned = <String>{};
    for (final item in graph.items) {
      final [namespace, itemName] = item.name.split('/');
      final source = config.registries[namespace]!;
      final repository = source.repository.toLowerCase();
      final ownerScope = '$repository/${source.path}#${config.preset}';
      final owner = '$ownerScope/$itemName';
      final oldName = switch ((config.preset, itemName)) {
        ('vanilla' || 'fortal' || 'heroui', 'text_field') => 'textfield',
        ('heroui', 'text_area') => 'textarea',
        _ => null,
      };
      if (oldName != null &&
          repository == officialRepository &&
          source.path == 'registry' &&
          !graph.catalogs[namespace]!.items.containsKey(oldName)) {
        final oldExport = 'components/$oldName.dart';
        final oldOwner = '$ownerScope/$oldName';
        final obsoleteTargets = [
          for (final MapEntry(:key, :value) in targets.entries)
            if (value == oldOwner) key,
        ];
        final evidence = [
          if (managedExports.contains(oldExport) &&
              !hasRecordedFile('${config.uiPath}/$oldExport'))
            '${config.uiPath}/ui.dart still exports $oldExport.',
          if (obsoleteTargets.isNotEmpty)
            '$ownershipFileName still reserves ${obsoleteTargets.join(', ')}.',
        ];
        if (evidence.isNotEmpty) {
          throw FormatException(
            '$namespace/$oldName was renamed to ${item.name}.\n'
            '${evidence.join('\n')}\n'
            'No files were changed. Follow the migration guide before retrying: '
            '$_registry511MigrationGuide',
          );
        }
      }
      for (final declared in [
        ...item.files.map((file) => file.target),
        ...item.generated,
      ]) {
        final target = '${config.uiPath}/${declared.substring('@ui/'.length)}';
        final path = canonical(target);
        if (path == barrel) {
          throw const FormatException(
            'Registry items cannot own the managed UI barrel.',
          );
        }
        if (!planned.add(path)) {
          throw FormatException(
            'Multiple registry targets resolve to $target.',
          );
        }
        for (final entry in reservations.entries) {
          if (path == entry.key) {
            if (entry.value.$2 != owner) {
              throw FormatException(
                '$target is owned by ${entry.value.$2}; ${item.name} ($owner) cannot replace it, including with --overwrite or --adopt.',
              );
            }
          } else if (p.isWithin(path, entry.key) ||
              p.isWithin(entry.key, path)) {
            throw FormatException(
              '$target overlaps reserved target ${entry.value.$1} owned by ${entry.value.$2}.',
            );
          }
        }
        if (!reservations.containsKey(path) &&
            FileSystemEntity.typeSync(
                  p.joinAll([root.path, ...p.posix.split(target)]),
                  followLinks: false,
                ) !=
                FileSystemEntityType.notFound) {
          if (!adoptNames.contains(item.name)) {
            throw FormatException(
              '$target has unknown registry ownership. Verify its provenance, then explicitly request ${item.name} with --adopt (and its existing dependencies by name). --overwrite cannot establish ownership.',
            );
          }
        }
        targets[target] = owner;
        reservations[path] = (target, owner);
      }
    }
    final ordered = Map.fromEntries(
      targets.entries.toList()..sort((a, b) => a.key.compareTo(b.key)),
    );
    final after =
        '${const JsonEncoder.withIndent('  ').convert({'schema': 1, 'context': context, 'targets': ordered})}\n';
    return OwnershipPlan._(before, after);
  }
}
