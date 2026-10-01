/// Reports numeric literals in Vanilla's components that are off its scale.
///
/// ```shell
/// dart run tool/check_vanilla_scale.dart
/// ```
///
/// Vanilla takes its spacing, sizes, and type from one scale
/// (`registry_source/lib/src/default/theme/scale.dart` and the text steps in
/// `theme_data.dart`). A literal such as `13` or `18.4` in a component is a
/// value nobody else in the layer uses, and it is how the preset drifted out of
/// rhythm before. This lists every such literal in `components/*.dart`.
///
/// Values on the scale pass, as do fractions between zero and one (alphas,
/// opacities, and ratios, which are not geometry) and duration arguments.
/// Everything else has to be in [allowlistPath], which records the literals
/// that predate the check, by file and value, with a count. The list may only
/// shrink: a new literal fails, and so does an entry that no longer matches,
/// so moving a recipe onto the scale also means deleting its lines here.
library;

import 'dart:io';

/// The components this checks.
const componentsPath = 'registry_source/lib/src/default/components';

/// The scale constants.
const scalePath = 'registry_source/lib/src/default/theme/scale.dart';

/// The theme data, which declares the text steps.
const themeDataPath = 'registry_source/lib/src/default/theme/theme_data.dart';

/// The literals that predate the check.
const allowlistPath = 'tool/vanilla_scale_allowlist.txt';

/// One numeric literal off the scale.
final class ScaleFinding {
  const ScaleFinding(this.file, this.line, this.value);

  /// The file name, relative to [componentsPath].
  final String file;

  /// One-based line number.
  final int line;

  /// The literal's value.
  final double value;

  @override
  String toString() => '$file:$line ${formatValue(value)}';
}

/// Every value on the scale: the spacing, size, and stroke constants in
/// [scaleSource], the text sizes and line heights in [themeDataSource], and
/// zero.
Set<double> scaleValues({
  required String scaleSource,
  required String themeDataSource,
}) {
  final constants = RegExp(r'static const double \w+ = ([\d.]+);');
  final textSteps = RegExp(r'_text\(\s*([\d.]+),\s*([\d.]+)');

  return {
    0,
    for (final match in constants.allMatches(scaleSource))
      double.parse(match[1]!),
    for (final match in textSteps.allMatches(themeDataSource)) ...[
      double.parse(match[1]!),
      double.parse(match[2]!),
    ],
  };
}

/// The off-scale literals in [source], a file named [file].
List<ScaleFinding> offScaleLiterals(
  String file,
  String source,
  Set<double> scale,
) {
  final code = stripCommentsAndStrings(source);
  final findings = <ScaleFinding>[];

  for (final match in _literal.allMatches(code)) {
    final before = code.substring(0, match.start);
    if (_durationArgument.hasMatch(before)) continue;
    final value = double.parse(match[0]!);
    if (scale.contains(value)) continue;
    if (value > 0 && value < 1) continue;
    final line = '\n'.allMatches(before).length + 1;
    findings.add(ScaleFinding(file, line, value));
  }

  return findings;
}

/// A decimal literal that is not part of an identifier, a hex literal, or a
/// member access.
final _literal = RegExp(r'(?<![\w.$])\d+(?:\.\d+)?(?![\w.])');

/// A named duration argument ending right before a literal.
final _durationArgument = RegExp(
  r'\b(?:days|hours|minutes|seconds|milliseconds|microseconds):\s*$',
);

/// [source] with every comment and string literal blanked out.
///
/// Newlines are kept, so offsets into the result still map onto the same
/// lines, and nothing inside a doc comment or a string can be mistaken for a
/// literal.
String stripCommentsAndStrings(String source) {
  final out = StringBuffer();
  var index = 0;

  void blank(int end) {
    for (var i = index; i < end; i++) {
      out.write(source[i] == '\n' ? '\n' : ' ');
    }
    index = end;
  }

  while (index < source.length) {
    if (source.startsWith('//', index)) {
      final end = source.indexOf('\n', index);
      blank(end == -1 ? source.length : end);
    } else if (source.startsWith('/*', index)) {
      final end = source.indexOf('*/', index + 2);
      blank(end == -1 ? source.length : end + 2);
    } else if (_quoteAt(source, index) case final quote?) {
      blank(_stringEnd(source, index, quote));
    } else {
      out.write(source[index]);
      index++;
    }
  }

  return out.toString();
}

/// The quote that opens a string at [index], including a raw prefix and a
/// triple quote, or null.
({String delimiter, bool raw, int start})? _quoteAt(String source, int index) {
  var start = index;
  var raw = false;
  if (source[index] == 'r' &&
      index + 1 < source.length &&
      (source[index + 1] == "'" || source[index + 1] == '"') &&
      (index == 0 || !RegExp(r'[\w$]').hasMatch(source[index - 1]))) {
    raw = true;
    start = index + 1;
  }
  final char = source[start];
  if (char != "'" && char != '"') return null;
  final triple = source.startsWith(char * 3, start);

  return (delimiter: triple ? char * 3 : char, raw: raw, start: start);
}

/// The offset just past the string that opens at [index].
int _stringEnd(
  String source,
  int index,
  ({String delimiter, bool raw, int start}) quote,
) {
  var cursor = quote.start + quote.delimiter.length;
  while (cursor < source.length) {
    if (!quote.raw && source[cursor] == r'\') {
      cursor += 2;
      continue;
    }
    if (source.startsWith(quote.delimiter, cursor)) {
      return cursor + quote.delimiter.length;
    }
    cursor++;
  }

  return source.length;
}

/// Allowed counts keyed by `(file, value)`, read from an allowlist file.
///
/// Each non-comment line is `<file> <value> <count>`.
Map<(String, double), int> parseAllowlist(String source) {
  final entries = <(String, double), int>{};

  for (final (index, raw) in source.split('\n').indexed) {
    final line = raw.trim();
    if (line.isEmpty || line.startsWith('#')) continue;
    final parts = line.split(RegExp(r'\s+'));
    if (parts.length != 3) {
      throw FormatException('line ${index + 1}: expected `file value count`');
    }
    final key = (parts[0], double.parse(parts[1]));
    if (entries.containsKey(key)) {
      throw FormatException('line ${index + 1}: duplicate entry for $line');
    }
    entries[key] = int.parse(parts[2]);
  }

  return entries;
}

/// The differences between [findings] and [allowed], one message each; empty
/// when they agree exactly.
List<String> compareWithAllowlist(
  List<ScaleFinding> findings,
  Map<(String, double), int> allowed,
) {
  final actual = <(String, double), List<ScaleFinding>>{};
  for (final finding in findings) {
    (actual[(finding.file, finding.value)] ??= []).add(finding);
  }

  final problems = <String>[];
  for (final MapEntry(key: key, value: found) in actual.entries) {
    final limit = allowed[key] ?? 0;
    if (found.length > limit) {
      problems.add(
        'off the scale: ${found.join(', ')} '
        '(${found.length} found, $limit allowed). Use a VanillaSpace, '
        'VanillaSize, VanillaStroke, or text token value instead.',
      );
    }
  }
  for (final MapEntry(key: key, value: limit) in allowed.entries) {
    final count = actual[key]?.length ?? 0;
    if (count < limit) {
      final (file, value) = key;
      problems.add(
        count == 0
            ? 'stale: remove `$file ${formatValue(value)} $limit` from '
                  '$allowlistPath; the literal is gone.'
            : 'stale: lower `$file ${formatValue(value)} $limit` to $count in '
                  '$allowlistPath.',
      );
    }
  }

  return problems;
}

/// [value] as the allowlist writes it: no trailing `.0`.
String formatValue(double value) =>
    value == value.roundToDouble() ? '${value.toInt()}' : '$value';

void main() {
  final scale = scaleValues(
    scaleSource: File(scalePath).readAsStringSync(),
    themeDataSource: File(themeDataPath).readAsStringSync(),
  );
  final files =
      Directory(componentsPath)
          .listSync()
          .whereType<File>()
          .where(
            (file) =>
                file.path.endsWith('.dart') && !file.path.endsWith('.g.dart'),
          )
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));
  final findings = [
    for (final file in files)
      ...offScaleLiterals(
        file.uri.pathSegments.last,
        file.readAsStringSync(),
        scale,
      ),
  ];
  final problems = compareWithAllowlist(
    findings,
    parseAllowlist(File(allowlistPath).readAsStringSync()),
  );

  if (problems.isEmpty) {
    stdout.writeln(
      'Vanilla components are on the scale '
      '(${findings.length} allowlisted literals remain).',
    );
    return;
  }
  for (final problem in problems) {
    stderr.writeln(problem);
  }
  exitCode = 1;
}
