/// Verifies that the workspace consumer apps still mirror the remote registry.
///
/// ```shell
/// dart run tool/check_consumer_apps.dart
/// ```
///
/// Playground and dashboard expect the full manifest for their configured
/// preset (`vanilla` and `fortal`); demo and widgetbook_vanilla install the
/// non-recipe, non-agent component catalog for their preset.
/// Check expected items even when their files are missing. The CLI owns config parsing, template rendering, and diffing.
///
/// Application-owned source may be customized. Each deliberate edit belongs in
/// [_customized]; an entry that matches the template again is also an error.
///
/// Every diff runs through [_harness], the checkout-only consumer seam, so the
/// comparison is against the registry bytes in *this* working tree. The apps'
/// own `remix.yaml` pins a published commit, and reading through that pin
/// would check the apps against source the change has not proposed -- a
/// registry edit and its consumer update could never land together.
library;

import 'dart:io';

import 'package:yaml/yaml.dart';

/// The consumer CLI that serves the committed `registry/` instead of GitHub.
const _harness = 'tool/registry_consumer_cli.dart';

/// Deliberate source edits, keyed by `consumer/item`.
const _customized = <String, String>{};

typedef _ItemFilter = bool Function(String key, YamlMap item);

/// Expected item filter per consumer; null means the entire preset registry.
const _consumers = <String, _ItemFilter?>{
  'apps/playground': null,
  'apps/demo': _isComponentCatalogItem,
  'apps/widgetbook_vanilla': _isComponentCatalogItem,
  'apps/dashboard': null,
};

bool _isComponentCatalogItem(String key, YamlMap item) {
  final files = item['files'];
  if (files is! YamlList) return false;
  return files.every((entry) {
    final source = entry is YamlMap ? entry['source'] as String? : null;
    final target = entry is YamlMap ? entry['target'] as String? : null;
    return source != null &&
        target != null &&
        !source.startsWith('templates/agent/') &&
        !target.startsWith('@ui/recipes/');
  });
}

/// What `remix add --diff` prints when the installed source is up to date.
///
/// The CLI prints a preamble and then exactly one verdict: this line, or a
/// `git diff`. Both are recognized below so that a third shape can be reported
/// as itself rather than silently read as divergence.
const _clean = 'No authored-source differences.';

Future<void> main(List<String> arguments) async {
  if (arguments.isNotEmpty) {
    stderr.writeln('Usage: dart run tool/check_consumer_apps.dart');
    exitCode = 64;
    return;
  }

  final failure = await _run(Directory.current.absolute);
  if (failure != null) {
    stderr.writeln('consumer apps check failed: $failure');
    exitCode = 1;
    return;
  }
  stdout.writeln(
    '${_consumers.length} consumers mirror the registry; '
    '${_customized.length} declared customization intact.',
  );
}

Future<String?> _run(Directory root) async {
  final problems = <String>[];
  final unknown = _customized.keys.toSet();

  final staging = Directory.systemTemp.createTempSync('remix_consumer_apps_');
  try {
    problems.addAll(await _compare(root, staging, unknown: unknown));
  } finally {
    staging.deleteSync(recursive: true);
  }
  for (final item in unknown) {
    problems.add('$item is listed as customized but is not an expected item.');
  }
  problems.addAll(_sourcePackageImports(root));

  if (problems.isEmpty) return null;
  return 'a consumer and the registry disagree:\n'
      '${problems.map((problem) => '  - $problem').join('\n')}';
}

YamlMap? _loadPresetItems(
  Directory root,
  String consumer,
  List<String> problems,
) {
  final configFile = File('${root.path}/$consumer/remix.yaml');
  if (!configFile.existsSync()) {
    problems.add('$consumer/remix.yaml is missing.');
    return null;
  }
  final config = loadYaml(configFile.readAsStringSync());
  final preset = config is YamlMap ? config['preset'] as String? : null;
  if (preset == null || preset.isEmpty) {
    problems.add('$consumer/remix.yaml does not declare a preset.');
    return null;
  }
  final registry = File('${root.path}/registry/$preset/registry.yaml');
  if (!registry.existsSync()) {
    problems.add('registry/$preset/registry.yaml is missing.');
    return null;
  }
  final document = loadYaml(registry.readAsStringSync());
  if (document is! YamlMap || document['items'] is! YamlMap) {
    problems.add(
      'registry/$preset/registry.yaml is not in the expected shape.',
    );
    return null;
  }
  return document['items'] as YamlMap;
}

Future<List<String>> _compare(
  Directory root,
  Directory staging, {
  required Set<String> unknown,
}) async {
  final problems = <String>[];
  for (final consumer in _consumers.keys) {
    final items = _loadPresetItems(root, consumer, problems);
    if (items == null) continue;
    final directory = _stage(root, consumer, staging);
    final filter = _consumers[consumer];
    final expected = items.keys.cast<String>().where(
      (key) => filter == null || filter(key, items[key] as YamlMap),
    );
    for (final key in expected) {
      final label = '$consumer/$key';
      unknown.remove(label);

      final result = await Process.run(Platform.resolvedExecutable, [
        'run',
        '${root.path}/$_harness',
        'add',
        key,
        '--diff',
      ], workingDirectory: directory.path);
      if (result.exitCode != 0) {
        // The exit code alone cannot be acted on from a CI log. Carry the
        // reason, which is where a missing Git or a preflight refusal is named.
        final detail = (result.stderr as String).trim();
        problems.add(
          '$label: `remix add $key --diff` exited ${result.exitCode}'
          '${detail.isEmpty ? '' : '\n    $detail'}',
        );
        continue;
      }

      // Classifying on the sentinel alone means any reword of it reports all
      // 40 items as diverged and sends the reader to `--overwrite`, which
      // cannot fix a change in the CLI's own output. Recognize both verdicts
      // instead, and name the case where neither or both appear.
      final lines = (result.stdout as String).split('\n');
      final clean = lines.any((line) => line.trimRight() == _clean);
      final diffed = lines.any((line) => line.startsWith('diff --git '));
      if (clean == diffed) {
        problems.add(
          '$label: `remix add $key --diff` printed '
          '${clean ? 'both a clean verdict and a diff' : 'no recognizable verdict'}'
          '. The CLI output contract moved; update `_clean` in this check to '
          'match `installer.dart`.',
        );
        continue;
      }

      final edited = diffed;
      final reason = _customized[label];
      if (!edited && reason != null) {
        problems.add(
          '$label is listed as customized ($reason) but matches the template. '
          'Drop it from the list.',
        );
      } else if (edited && reason == null) {
        problems.add(
          '$label has diverged from the template. Rerun `dart run '
          'remix_cli:remix add $key --overwrite` in $consumer, or record the '
          'reason in this check.',
        );
      }
    }
  }

  return problems;
}

/// Copies the parts of [consumer] a diff reads into [staging].
///
/// The comparison is read-only, but it runs the real installer against a real
/// project, and a check that can write into the working tree is one bug away
/// from silently repairing the drift it exists to report.
Directory _stage(Directory root, String consumer, Directory staging) {
  final source = Directory('${root.path}/$consumer');
  final target = Directory('${staging.path}/${consumer.split('/').last}')
    ..createSync(recursive: true);

  for (final name in ['remix.yaml', 'build.yaml', 'analysis_options.yaml']) {
    final file = File('${source.path}/$name');
    if (file.existsSync()) file.copySync('${target.path}/$name');
  }
  // Workspace resolution has no meaning outside the workspace, and pub says so
  // on stderr for every item. The diff reads declared constraints only.
  File('${target.path}/pubspec.yaml').writeAsStringSync(
    File('${source.path}/pubspec.yaml')
        .readAsLinesSync()
        .where((line) => line.trim() != 'resolution: workspace')
        .join('\n'),
  );
  for (final entity in Directory(
    '${source.path}/lib',
  ).listSync(recursive: true)) {
    final relative = entity.path.substring(source.path.length + 1);
    if (entity is Directory) {
      Directory('${target.path}/$relative').createSync(recursive: true);
    } else if (entity is File) {
      File('${target.path}/$relative')
        ..parent.createSync(recursive: true)
        ..writeAsBytesSync(entity.readAsBytesSync());
    }
  }
  return target;
}

/// Applications consume installed source only. Outside their `lib/ui/`, no
/// file may reach the authoring packages the registry derives from.
Iterable<String> _sourcePackageImports(Directory root) sync* {
  final forbidden = RegExp(
    r"""^\s*(?:import|export)\s+['"]package:(registry_source)/""",
    multiLine: true,
  );
  for (final consumer in _consumers.keys) {
    final lib = Directory('${root.path}/$consumer/lib');
    if (!lib.existsSync()) continue;
    for (final file in lib.listSync(recursive: true).whereType<File>()) {
      if (!file.path.endsWith('.dart')) continue;
      final relative = file.path.substring(root.path.length + 1);
      if (relative.startsWith('$consumer/lib/ui/')) continue;
      final match = forbidden.firstMatch(file.readAsStringSync());
      if (match != null) {
        yield '$relative imports package:${match.group(1)}; applications '
            'consume installed source only.';
      }
    }
  }
}
