import 'dart:io';

import 'install_pins.dart';

/// Rewrites every install pin in user-facing docs to the current version of
/// the package it installs. `tool/validate_docs.dart` fails when this has not
/// been run.
void main(List<String> arguments) {
  if (arguments.isNotEmpty) {
    stderr.writeln('Unsupported arguments: ${arguments.join(', ')}');
    stderr.writeln('Usage: dart run tool/sync_install_pins.dart');
    exitCode = 64;
    return;
  }

  final workspaceRoot = Directory.current;
  final pubspec = File('${workspaceRoot.path}/pubspec.yaml');
  if (!pubspec.existsSync() ||
      !RegExp(
        r'^name:\s*remix_workspace\s*$',
        multiLine: true,
      ).hasMatch(pubspec.readAsStringSync())) {
    stderr.writeln('Run this tool from the workspace root.');
    exitCode = 64;
    return;
  }

  final expected = {
    for (final package in pinnedInstallPackages)
      package: expectedInstallPin(workspaceRoot, package),
  };

  var rewritten = 0;
  for (final file in userFacingDocuments(workspaceRoot)) {
    final source = file.readAsStringSync();
    final stale = [
      for (final command in installCommands(source))
        if (command.constraint case final constraint?
            when constraint.text != expected[command.package])
          (package: command.package, constraint: constraint),
    ];
    if (stale.isEmpty) continue;

    var updated = source;
    for (final (:package, :constraint) in stale.reversed) {
      updated = updated.replaceRange(
        constraint.start,
        constraint.end,
        expected[package]!,
      );
    }
    file.writeAsStringSync(updated);
    rewritten += stale.length;
    final relativePath = file.path.substring(workspaceRoot.path.length + 1);
    for (final (:package, :constraint) in stale) {
      stdout.writeln(
        '$relativePath: $package ${constraint.text} -> ${expected[package]}.',
      );
    }
  }

  if (rewritten == 0) {
    stdout.writeln(
      'Install pins already match: '
      '${expected.entries.map((e) => '${e.key} ${e.value}').join(', ')}.',
    );
  }
}
