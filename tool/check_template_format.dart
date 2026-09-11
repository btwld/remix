import 'dart:io';

import 'package:path/path.dart' as p;

/// Registry root holding every bundled preset's templates.
const _registryPath = 'packages/remix_cli/lib/src/registry';

/// The prefix each preset's templates are rendered with before formatting.
///
/// "Formatter-clean" is only meaningful at a stated prefix, because the
/// formatter wraps on line width and the prefix is substituted into type
/// names. Each preset is therefore checked at the prefix of the rendering this
/// repository already commits: `fortal` is derived from `remix_fortal`, whose
/// formatted source `tool/build_fortal_preset.dart` holds byte-identical
/// through its round-trip assertion, and `default` is mirrored into
/// `apps/playground`, which the workspace `format:check` already covers.
///
/// A consumer whose prefix is a different length costs itself nothing: `add`
/// formats the tree it writes, so installed source is always formatted
/// regardless of what the template looked like. This check exists for
/// maintainers, so the two presets' templates stay diffable against each other
/// instead of differing by pure whitespace.
const _referencePrefixes = <String, String>{
  'default': 'Playground',
  'fortal': 'Fortal',
};

/// Formats every registry template's rendered output.
///
/// Run without arguments to rewrite templates that the formatter would change.
/// Pass `--check` to compare in memory and fail on drift without writing.
void main(List<String> arguments) {
  final check = arguments.contains('--check');
  final unknown = arguments.where((argument) => argument != '--check').toList();
  if (unknown.isNotEmpty || arguments.length != (check ? 1 : 0)) {
    stderr.writeln('Usage: dart run tool/check_template_format.dart [--check]');
    exitCode = 64;
    return;
  }

  final workspaceRoot = Directory.current.absolute;
  final pubspec = File(p.join(workspaceRoot.path, 'pubspec.yaml'));
  if (!pubspec.existsSync() ||
      !RegExp(
        r'^name:\s*remix_workspace\s*$',
        multiLine: true,
      ).hasMatch(pubspec.readAsStringSync())) {
    stderr.writeln('Run this tool from the Remix workspace root.');
    exitCode = 64;
    return;
  }

  final registry = Directory(p.join(workspaceRoot.path, _registryPath));
  if (!registry.existsSync()) {
    stderr.writeln('$_registryPath is missing');
    exitCode = 1;
    return;
  }

  final failures = <String>[];
  final drifted = <String>[];
  final staging = Directory.systemTemp.createTempSync('remix_template_format_');
  try {
    // Every rendered template lands in one flat directory so a single formatter
    // invocation covers all of them; the map carries each staged name back to
    // the template it came from.
    final staged = <String, _StagedTemplate>{};

    for (final preset in _presetsIn(registry)) {
      final typePrefix = _referencePrefixes[preset];
      if (typePrefix == null) {
        failures.add(
          'preset $preset has no reference prefix. Add one to '
          '_referencePrefixes in tool/check_template_format.dart so its '
          'templates are covered.',
        );
        continue;
      }
      final templates = Directory(p.join(registry.path, preset, 'templates'));
      if (!templates.existsSync()) continue;

      for (final template in _templatesIn(templates)) {
        // Unresolved tokens are the renderer's contract, not this check's;
        // `registry_test.dart` renders every template and would fail first.
        final rendered = _render(
          template.readAsStringSync(),
          typePrefix: typePrefix,
        );
        final withinPreset = p
            .relative(template.path, from: templates.path)
            .replaceAll(p.separator, '__')
            .replaceAll('.dart.tmpl', '');
        final name = '${preset}__$withinPreset.dart';
        File(p.join(staging.path, name)).writeAsStringSync(rendered);
        staged[name] = _StagedTemplate(
          file: template,
          origin: p.relative(template.path, from: workspaceRoot.path),
          prefix: typePrefix,
          rendered: rendered,
        );
      }
    }

    if (staged.isNotEmpty) {
      final result = Process.runSync(Platform.resolvedExecutable, [
        'format',
        staging.path,
      ]);
      if (result.exitCode != 0) {
        stderr.writeln('The formatter failed on the staged templates:');
        stderr.writeln('${result.stdout}${result.stderr}');
        exitCode = 1;
        return;
      }
    }

    for (final entry in staged.entries) {
      final template = entry.value;
      final formatted = File(
        p.join(staging.path, entry.key),
      ).readAsStringSync();
      if (formatted == template.rendered) continue;

      drifted.add(template.origin);
      if (check) continue;

      // The same guard `build_fortal_preset.dart` uses: reversing the
      // substitution must reproduce the formatted source exactly, or the
      // rewrite would silently corrupt a token.
      final source = _unrender(formatted, typePrefix: template.prefix);
      if (_render(source, typePrefix: template.prefix) != formatted) {
        failures.add(
          '${template.origin} did not survive the template round trip; '
          'format it by hand.',
        );
        continue;
      }
      template.file.writeAsStringSync(source);
    }

    if (failures.isEmpty) {
      if (drifted.isEmpty) {
        stdout.writeln(
          'Template formatting verified: ${staged.length} rendered templates '
          'match the formatter.',
        );
        return;
      }
      if (!check) {
        stdout.writeln(
          'Formatted ${drifted.length} of ${staged.length} templates:',
        );
        for (final origin in drifted) {
          stdout.writeln('- $origin');
        }
        return;
      }
    }

    stderr.writeln('Template formatting validation failed:');
    if (check) {
      for (final origin in drifted) {
        stderr.writeln(
          '- $origin does not match the formatter when rendered with prefix '
          '${_referencePrefixes[_presetOf(origin)]}',
        );
      }
    }
    for (final failure in failures) {
      stderr.writeln('- $failure');
    }
    stderr.writeln(
      'Run `dart run tool/check_template_format.dart` to format them, so the '
      'committed `.tmpl` matches what `add` would write.',
    );
    exitCode = 1;
  } finally {
    staging.deleteSync(recursive: true);
  }
}

String _render(String source, {required String typePrefix}) => source
    .replaceAll('{{typePrefix}}', typePrefix)
    // Matches ProjectConfig.valuePrefix, which is what the installer passes.
    .replaceAll('{{valuePrefix}}', _valuePrefix(typePrefix));

String _unrender(String source, {required String typePrefix}) => source
    .replaceAll(typePrefix, '{{typePrefix}}')
    .replaceAll(_valuePrefix(typePrefix), '{{valuePrefix}}');

String _valuePrefix(String typePrefix) =>
    '${typePrefix.substring(0, 1).toLowerCase()}${typePrefix.substring(1)}';

String _presetOf(String origin) =>
    p.split(origin).contains('fortal') ? 'fortal' : 'default';

/// A rendered template awaiting the formatter, and where it came from.
final class _StagedTemplate {
  const _StagedTemplate({
    required this.file,
    required this.origin,
    required this.prefix,
    required this.rendered,
  });

  final File file;
  final String origin;
  final String prefix;
  final String rendered;
}

/// Preset directories on disk, so a new preset tree cannot be skipped silently.
Iterable<String> _presetsIn(Directory registry) =>
    registry
        .listSync()
        .whereType<Directory>()
        .map((d) => p.basename(d.path))
        .toList()
      ..sort();

Iterable<File> _templatesIn(Directory templates) =>
    templates
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart.tmpl'))
        .toList()
      ..sort((a, b) => a.path.compareTo(b.path));
