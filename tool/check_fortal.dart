import 'dart:convert';
import 'dart:io';

/// Checks Fortal's own specification, independently of any external library.
void main() {
  final failures = checkFortalContract(Directory.current);
  if (failures.isEmpty) {
    stdout.writeln(
      'Fortal specification, API catalog, and test inventory agree.',
    );
  } else {
    for (final failure in failures) {
      stderr.writeln(failure);
    }
    exitCode = 1;
  }
}

List<String> checkFortalContract(Directory workspace) {
  final failures = <String>[];
  final root = '${workspace.path}/registry_source';
  final contract = File('$root/specs/fortal_catalog.json');
  if (!contract.existsSync()) return ['Missing Fortal specification catalog.'];
  final catalog =
      jsonDecode(contract.readAsStringSync()) as Map<String, dynamic>;
  if (catalog['owner'] != 'Fortal' || catalog['contractVersion'] != 1) {
    failures.add('Unsupported Fortal contract owner/version.');
  }
  if (!File('$root/${catalog['specification']}').existsSync()) {
    failures.add('The Fortal prose specification is missing.');
  }
  final theme = File(
    '$root/lib/src/fortal/theme/theme_data.dart',
  ).readAsStringSync();
  final themeEnums = (catalog['theme']['enums'] as Map).cast<String, dynamic>();
  for (final entry in themeEnums.entries) {
    final type =
        'Fortal${_pascal(entry.key)}${entry.key == 'accent' || entry.key == 'gray' ? 'Color' : ''}';
    _checkEnum(type, theme, entry.value['values'] as List, failures);
    _checkDefault('theme', entry.key, entry.value['default'], theme, failures);
  }
  final families = (catalog['families'] as List).cast<Map<String, dynamic>>();
  final ids = <String>{};
  final coveredSources = <String>{};
  for (final family in families) {
    final id = family['id'] as String;
    if (!ids.add(id)) failures.add('Duplicate Fortal family $id.');
    final fileName = id == 'text_field' || id == 'text_area' ? 'textfield' : id;
    coveredSources.add(fileName);
    final file = File('$root/lib/src/fortal/components/$fileName.dart');
    if (!file.existsSync()) {
      failures.add('$id has no authored recipe.');
      continue;
    }
    final source = file.readAsStringSync();
    final generated = File(file.path.replaceFirst('.dart', '.g.dart'));
    final all =
        '$source\n${generated.existsSync() ? generated.readAsStringSync() : ''}';
    final type = family['fortalType'] as String;
    if (!RegExp('class\\s+$type(?:<|\\s)').hasMatch(all)) {
      failures.add('$id: public widget $type is missing.');
    }
    final axes = (family['enums'] as Map).cast<String, dynamic>();
    for (final entry in axes.entries) {
      final kind = entry.key;
      final definition = entry.value as Map;
      final enumType = switch (kind) {
        'weight' => 'FortalTextWeight',
        'size' when {'text', 'heading', 'code', 'kbd', 'link'}.contains(id) =>
          'FortalTextSize',
        'size' when id == 'tabs' => 'FortalTabsSize',
        _ => 'Fortal${_pascal(id)}${_pascal(kind)}',
      };
      var enumSource = source;
      if (enumType == 'FortalTextSize' || enumType == 'FortalTextWeight') {
        enumSource = File(
          '$root/lib/src/fortal/components/typography.dart',
        ).readAsStringSync();
      }
      // Framework/Remix behavioral enums stay owned by those packages.
      if (RegExp('enum\\s+$enumType\\b').hasMatch(enumSource)) {
        _checkEnum(
          enumType,
          enumSource,
          definition['values'] as List,
          failures,
        );
      } else if (kind == 'size' ||
          kind == 'variant' ||
          kind == 'weight' ||
          kind == 'underline') {
        failures.add('$id: missing enum $enumType.');
      }
      final defaultSource = definition['defaultSource'] as String?;
      final defaults = defaultSource == null
          ? all
          : File('${workspace.path}/$defaultSource').readAsStringSync();
      _checkDefault(id, kind, definition['default'], defaults, failures);
      if (kind == 'variant') {
        final variants = (definition['values'] as List).cast<String>().toSet();
        final constructors = RegExp(
          'const\\s+$type\\.(\\w+)\\s*\\(',
        ).allMatches(all).map((m) => m.group(1)!).toSet();
        if (!_same(variants, constructors)) {
          failures.add(
            '$id: named constructors $constructors differ from variants $variants.',
          );
        }
      }
    }
    final tests = (family['tests'] as List).cast<String>();
    if (tests.isEmpty) failures.add('$id has no Fortal test owner.');
    for (final test in tests) {
      if (!File('$root/$test').existsSync())
        failures.add('$id: missing test $test.');
    }
  }
  final components = Directory('$root/lib/src/fortal/components')
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart') && !f.path.endsWith('.g.dart'));
  for (final file in components) {
    final name = file.uri.pathSegments.last.replaceFirst('.dart', '');
    if (!coveredSources.contains(name) &&
        !{'base_button', 'typography'}.contains(name)) {
      failures.add('Unspecified Fortal recipe: $name.');
    }
  }
  for (final path in [
    'test/fortal/palette_contrast_test.dart',
    'test/fortal/spec_conformance_test.dart',
    'test/fortal/focus_ring_test.dart',
  ]) {
    if (!File('$root/$path').existsSync())
      failures.add('Missing Fortal gate $path.');
  }
  final visualGate = catalog['visualGate'] as String?;
  if (visualGate == null ||
      !File('${workspace.path}/$visualGate').existsSync()) {
    failures.add('Missing Fortal polish-board visual gate.');
  }
  return failures;
}

void _checkEnum(
  String name,
  String source,
  List expected,
  List<String> failures,
) {
  final match = RegExp(
    'enum\\s+$name\\s*\\{([^}]*)\\}',
    dotAll: true,
  ).firstMatch(source);
  if (match == null) {
    failures.add('Missing enum $name.');
    return;
  }
  final body = match
      .group(1)!
      .replaceAll(RegExp(r'//[^\n]*'), '')
      .split(';')
      .first;
  final values = RegExp(
    r'(\w+)\s*(?:\([^)]*\))?\s*(?:,|$)',
  ).allMatches(body).map((m) => m.group(1)!).toList();
  if (jsonEncode(values) != jsonEncode(expected)) {
    failures.add(
      '$name: $values differs from the Fortal specification $expected.',
    );
  }
}

void _checkDefault(
  String family,
  String parameter,
  Object? expected,
  String source,
  List<String> failures,
) {
  if (expected == null)
    return; // Omitted nullable typography intentionally inherits tokens.
  final expression = RegExp(
    '(?:\\bthis\\.$parameter|\\b$parameter)\\s*=\\s*(?:[A-Z]\\w*\\.)?\\.?${RegExp.escape('$expected')}\\b',
  );
  if (!expression.hasMatch(source)) {
    failures.add('$family: $parameter does not default to $expected.');
  }
}

String _pascal(String value) => value
    .split('_')
    .map((part) => part[0].toUpperCase() + part.substring(1))
    .join();
bool _same(Set<String> first, Set<String> second) =>
    first.length == second.length && first.containsAll(second);
