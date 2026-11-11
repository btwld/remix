/// Fails before consumer setup when a registry floor has not been published.
library;

import 'dart:convert';
import 'dart:io';

import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

typedef PubResponse = ({int statusCode, String body});

abstract interface class PubFloorClient {
  Future<PubResponse> get(Uri uri);
  void close();
}

final class IoPubFloorClient implements PubFloorClient {
  final _client = HttpClient()..connectionTimeout = const Duration(seconds: 5);

  @override
  Future<PubResponse> get(Uri uri) async {
    final response = await (await _client.getUrl(uri)).close();
    return (
      statusCode: response.statusCode,
      body: await response.transform(utf8.decoder).join(),
    );
  }

  @override
  void close() => _client.close(force: true);
}

/// Includes runtime, generator and icon-library floors, deduplicated by package.
/// SDK dependencies have no hosted floor. Reject unbounded declarations instead
/// of silently treating them as published.
Map<String, Set<String>> readHostedFloors(Directory registryRoot) {
  final catalogs =
      registryRoot
          .listSync()
          .whereType<Directory>()
          .map((directory) => File('${directory.path}/registry.yaml'))
          .where((file) => file.existsSync())
          .toList()
        ..sort((left, right) => left.path.compareTo(right.path));
  if (catalogs.isEmpty)
    throw const FormatException('No registry catalogs found.');
  final icons = File('${registryRoot.path}/icons.yaml');
  return readCatalogHostedFloors(
    catalogs.map((file) => file.readAsStringSync()),
    iconsYaml: icons.existsSync() ? icons.readAsStringSync() : null,
  );
}

/// Floors from the catalogs actually installed, including their icon table.
Map<String, Set<String>> readCatalogHostedFloors(
  Iterable<String> catalogs, {
  String? iconsYaml,
}) {
  final floors = <String, Set<String>>{};
  void add(Object? node) {
    if (node is! YamlMap) return;
    for (final entry in node.entries) {
      final value = entry.value;
      if (value is YamlMap && value['sdk'] != null) continue;
      if (value is! String)
        throw FormatException('No hosted floor: ${entry.key}: $value');
      final constraint = VersionConstraint.parse(value);
      final floor = constraint is Version
          ? constraint
          : constraint is VersionRange && constraint.includeMin
          ? constraint.min
          : null;
      if (floor == null)
        throw FormatException('No hosted floor: ${entry.key}: $value');
      floors.putIfAbsent(entry.key as String, () => {}).add(floor.toString());
    }
  }

  for (final catalog in catalogs) {
    final items = (loadYaml(catalog) as YamlMap)['items'] as YamlMap;
    for (final item in items.values.cast<YamlMap>()) {
      add(item['dependencies']);
      add(item['devDependencies']);
    }
  }
  if (iconsYaml != null) {
    final libraries = (loadYaml(iconsYaml) as YamlMap)['libraries'] as YamlMap;
    for (final library in libraries.values.cast<YamlMap>()) {
      add(library['dependency']);
    }
  }
  return floors;
}

/// Check existence of every exact floor, and separately retain the invariant
/// that Remix's floor tracks the newest published stable or prerelease. This
/// snapshot precedes resolution; a publication during the install cannot race
/// the pinned consumer. [client] makes all network outcomes fixture-testable.
Future<String?> checkPubFloors(
  Directory registryRoot, {
  PubFloorClient? client,
}) async {
  try {
    return await checkPubPackageFloors(
      readHostedFloors(registryRoot),
      client: client,
    );
  } on Object catch (error) {
    return 'pub.dev floor preflight failed: $error';
  }
}

/// Checks exact publication of each floor. Candidate promotion also requires
/// the newest Remix floor; an already-promoted catalog may legitimately be older
/// when testing a CLI release, so it sets [requireLatestRemix] to false.
Future<String?> checkPubPackageFloors(
  Map<String, Set<String>> floors, {
  PubFloorClient? client,
  bool requireLatestRemix = true,
}) async {
  final http = client ?? IoPubFloorClient();
  try {
    final problems = await Future.wait(
      floors.entries.map((entry) async {
        final name = entry.key;
        try {
          final response = await http
              .get(Uri.https('pub.dev', '/api/packages/$name'))
              .timeout(const Duration(seconds: 8));
          if (response.statusCode != 200 && response.statusCode != 404) {
            return 'pub.dev preflight for $name failed: HTTP ${response.statusCode}; re-run Promote registry.';
          }
          final versions = response.statusCode == 404
              ? <Version>[]
              : [
                  for (final release
                      in (jsonDecode(response.body) as Map)['versions'] as List)
                    if (release['retracted'] != true)
                      Version.parse(release['version'] as String),
                ];
          for (final floor in entry.value) {
            if (!versions.contains(Version.parse(floor))) {
              final tag = switch (name) {
                'remix' => 'v$floor',
                'remix_ui_icons' ||
                'remix_ui_fonts' ||
                'naked_ui' ||
                'remix_cli' => '$name-v$floor',
                _ => null,
              };
              final action = tag == null
                  ? 'publish the required dependency upstream, wait for pub.dev'
                  : 'push tag $tag, wait for the Publish workflow';
              return '$name ^$floor is not on pub.dev yet; $action, then re-run Promote registry';
            }
          }
          if (requireLatestRemix && name == 'remix' && versions.isNotEmpty) {
            versions.sort();
            for (final floor in entry.value) {
              if (Version.parse(floor).compareTo(versions.last) < 0) {
                return 'remix ^$floor is older than published ${versions.last}; update the registry floor before promotion.';
              }
            }
          }
          return null;
        } on Object catch (error) {
          return 'pub.dev preflight for $name failed: $error; re-run Promote registry.';
        }
      }),
    );
    final failures = problems.whereType<String>().toList();
    return failures.isEmpty ? null : failures.join('\n');
  } on Object catch (error) {
    return 'pub.dev floor preflight failed: $error';
  } finally {
    if (client == null) http.close();
  }
}

Future<void> main() async {
  final problem = await checkPubFloors(Directory('registry'));
  if (problem == null) {
    stdout.writeln('ok pub.dev floors');
  } else {
    stderr.writeln(problem);
    exitCode = 1;
  }
}
