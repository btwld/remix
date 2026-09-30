final _importUri = RegExp(r'''^\s*import\s+['"]([^'"]+)['"]''');

/// Re-sorts a file's leading import block into `dart:`, `package:`, and
/// relative groups, one blank line apart, the way `directives_ordering` reads
/// it.
///
/// A multi-line import stays one statement. Anything else inside the block is
/// refused rather than moved. The registry build and the installer share this
/// so a rendered icon import lands where `directives_ordering` expects it.
String sortDirectives(String path, String source) {
  final lines = source.split('\n');
  final start = lines.indexWhere((line) => line.startsWith('import '));
  if (start < 0) return source;

  final statements = <List<String>>[];
  var index = start;
  var end = start;
  while (index < lines.length) {
    final line = lines[index];
    if (line.trim().isEmpty) {
      index++;
      continue;
    }
    if (!line.startsWith('import ')) break;
    final statement = <String>[line];
    while (!statement.last.trimRight().endsWith(';')) {
      index++;
      if (index >= lines.length || lines[index].trim().isEmpty) {
        throw FormatException(
          '$path: an import statement is not terminated before a blank line.',
        );
      }
      statement.add(lines[index]);
    }
    statements.add(statement);
    index++;
    end = index;
  }
  if (statements.isEmpty) return source;

  String uri(List<String> statement) =>
      _importUri.firstMatch(statement.first)!.group(1)!;
  final groups = [
    for (final test in [
      (String value) => value.startsWith('dart:'),
      (String value) => value.startsWith('package:'),
      (String value) =>
          !value.startsWith('dart:') && !value.startsWith('package:'),
    ])
      statements.where((statement) => test(uri(statement))).toList()
        ..sort((a, b) => uri(a).compareTo(uri(b))),
  ];
  final sorted = <String>[];
  for (final group in groups) {
    if (group.isEmpty) continue;
    if (sorted.isNotEmpty) sorted.add('');
    for (final statement in group) {
      sorted.addAll(statement);
    }
  }
  return [
    ...lines.sublist(0, start),
    ...sorted,
    ...lines.sublist(end),
  ].join('\n');
}
