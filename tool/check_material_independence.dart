import 'dart:io';

// Repository-relative package directories whose source ships to applications,
// either installed from the registry or resolved as a hosted dependency.
const _consumerSourcePackages = [
  'packages/naked_ui',
  'packages/remix',
  'packages/remix_ui_icons',
  'packages/remix_ui_fonts',
  'registry_source',
];

// Inspect every URI in a directive, including conditional imports/exports.
final _libraryDirective = RegExp(
  r'''^\s*(?:import|export)\s+[^;]+;''',
  multiLine: true,
);
final _materialLibraryUri = RegExp(
  r'''['"]package:(?:flutter/(?:material\.dart|src/material/[^'"]+)|material_ui/[^'"]+)['"]''',
);

final _materialUiDependency = RegExp(
  r'^\s{0,4}material_ui\s*:',
  multiLine: true,
);

final _materialFontFlag = RegExp(
  r'^\s*uses-material-design\s*:',
  multiLine: true,
);

void main() {
  final workspace = Directory.current.absolute;
  final failures = <String>[];

  for (final package in _consumerSourcePackages) {
    final packageDirectory = Directory('${workspace.path}/$package');
    final libraryDirectory = Directory('${packageDirectory.path}/lib');
    final pubspec = File('${packageDirectory.path}/pubspec.yaml');

    if (!libraryDirectory.existsSync() || !pubspec.existsSync()) {
      failures.add('$package is missing its lib directory or pubspec');
      continue;
    }

    for (final entity in libraryDirectory.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;

      final source = entity.readAsStringSync();
      for (final directive in _libraryDirective.allMatches(source)) {
        for (final uri in _materialLibraryUri.allMatches(directive.group(0)!)) {
          final relativePath = entity.path.substring(workspace.path.length + 1);
          final offset = directive.start + uri.start;
          final line = '\n'.allMatches(source.substring(0, offset)).length + 1;
          failures.add(
            '$relativePath:$line imports or exports a Material library',
          );
        }
      }
    }

    final manifest = pubspec.readAsStringSync();
    if (_materialUiDependency.hasMatch(manifest)) {
      failures.add('$package/pubspec.yaml declares material_ui');
    }
    if (_materialFontFlag.hasMatch(manifest)) {
      failures.add('$package/pubspec.yaml declares uses-material-design');
    }
  }

  if (failures.isEmpty) {
    stdout.writeln(
      'Naked UI, Remix, icon/font packages, and application-owned preset '
      'sources have no direct Material usage. '
      'Transitive dependencies are not checked.',
    );
    return;
  }

  stderr.writeln('Direct Material usage validation failed:');
  for (final failure in failures) {
    stderr.writeln('- $failure');
  }
  exitCode = 1;
}
