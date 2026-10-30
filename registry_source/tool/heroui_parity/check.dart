// Verifies the HeroUI reference contract. Run from registry_source:
//
//   dart run tool/heroui_parity/check.dart
//
// - The pinned snapshot matches its sha256 manifest and one upstream commit.
// - The token inventory, the Dart tokens, and the browser capture agree.
// - Every shipped item is a mapped upstream family with a worksheet, and every
//   mapped family names an item that exists.
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

const _reference = 'reference/heroui_3_2_6';
const _components = 'lib/src/heroui/components';
const _worksheets = 'specs/heroui/components';

final _failures = <String>[];

void main() {
  final sources = _json('$_reference/sources.json') as Map<String, dynamic>;
  final commit = sources['commit'] as String;
  _checkSnapshot(sources);
  _checkTokens(commit);
  _checkFamilies();
  _checkMeasurements(commit);

  if (_failures.isEmpty) {
    stdout.writeln('HeroUI reference contract holds.');
    return;
  }
  for (final failure in _failures) {
    stderr.writeln('HeroUI reference: $failure');
  }
  exitCode = 1;
}

void _checkSnapshot(Map<String, dynamic> sources) {
  for (final package in sources['packages'] as List) {
    _require(package['version'] == '3.2.6', 'unexpected ${package['name']}');
  }
  final pinned = (_json('$_reference/source/files.json') as List).cast<Map>();
  final paths = {for (final entry in pinned) entry['path'] as String};
  for (final entry in pinned) {
    final file = File('$_reference/${entry['path']}');
    if (!file.existsSync()) {
      _failures.add('missing pinned source ${entry['path']}');
      continue;
    }
    final digest = sha256.convert(file.readAsBytesSync()).toString();
    _require(digest == entry['sha256'], 'digest mismatch: ${entry['path']}');
  }
  for (final file in Directory(
    '$_reference/source',
  ).listSync(recursive: true)) {
    if (file is! File || file.path.endsWith('files.json')) continue;
    final path = file.path.substring('$_reference/'.length);
    _require(paths.contains(path), 'unpinned source $path');
  }
}

void _checkTokens(String commit) {
  final inventory = _json('specs/heroui/tokens.json') as Map<String, dynamic>;
  _require(inventory['commit'] == commit, 'token inventory commit drift');
  final declared = {
    for (final entry in (inventory['tokens'] as Map<String, dynamic>).entries)
      if ((entry.value as Map)['runtime'] == 'color') entry.key,
  };
  final dart = {
    for (final match in RegExp(
      r"ColorToken\(\s*'heroUi\.color\.([a-z0-9-]+)'",
    ).allMatches(File('lib/src/heroui/theme/tokens.dart').readAsStringSync()))
      match[1]!,
  };
  _require(
    _same(declared, dart),
    'tokens.json and HeroUiTokens disagree: ${_diff(declared, dart)}',
  );
  final captured = _json('$_reference/chromium/tokens.json') as Map;
  for (final mode in ['light', 'dark']) {
    final missing = declared.difference((captured[mode] as Map).keys.toSet());
    _require(missing.isEmpty, 'no $mode capture for $missing');
  }
}

void _checkFamilies() {
  final manifest = _json('$_reference/families.json') as Map<String, dynamic>;
  final families = (manifest['families'] as List).cast<Map>();
  final items = {
    for (final file in Directory(_components).listSync())
      if (file.path.endsWith('.dart') && !file.path.endsWith('.g.dart'))
        file.uri.pathSegments.last.replaceAll('.dart', ''),
  };
  final named = <String>{};
  for (final family in families) {
    final status = family['status'];
    _require(
      const {'mapped', 'composed', 'deferred'}.contains(status),
      '${family['upstream']} has unknown status $status',
    );
    if (status == 'deferred') {
      _require(
        family['reason'] != null,
        '${family['upstream']} lacks a reason',
      );
      continue;
    }
    final item = family['item'] as String?;
    _require(
      item != null && items.contains(item),
      '${family['upstream']} names missing item $item',
    );
    if (item != null) named.add(item);
  }
  for (final item in items) {
    _require(named.contains(item), 'item $item maps no upstream family');
    _require(
      File('$_worksheets/$item.yaml').existsSync(),
      'item $item has no worksheet',
    );
  }
}

void _checkMeasurements(String commit) {
  final measurements = _json('$_reference/measurements.json') as Map;
  _require(measurements['upstream'] == commit, 'measurements commit drift');
  final modes = measurements['modes'] as Map;
  _require(
    modes.containsKey('light') && modes.containsKey('dark'),
    'measurements lack a mode',
  );
}

Object? _json(String path) => jsonDecode(File(path).readAsStringSync());

void _require(bool condition, String failure) {
  if (!condition) _failures.add(failure);
}

bool _same(Set<String> a, Set<String> b) =>
    a.length == b.length && a.containsAll(b);

String _diff(Set<String> a, Set<String> b) =>
    '${a.difference(b)} / ${b.difference(a)}';
