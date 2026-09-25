import 'dart:convert';
import 'dart:io';

final _removedComponentBackgroundColorInvocation = RegExp(
  r'\b(?:Remix)?(?:Accordion|Avatar|Badge|Button|Callout|Card|Dialog|'
  r'IconButton|Popover|TextField|Toggle|ToggleGroup|ToggleGroupItem|Tooltip)'
  r'Styler(?:<[^>]+>)?(?:\.[A-Za-z0-9_]+)?\s*'
  r'\((?:[^()]|\([^()]*\)){0,1200}?\)'
  r'(?:\s*\.[A-Za-z0-9_]+\s*\((?:[^()]|\([^()]*\)){0,1200}?\))*'
  r'\s*\.backgroundColor\s*\(',
);

final _retiredApis = <(RegExp, String)>[
  (
    RegExp(
      r'Fortal(?:Accordion|Avatar|Badge|Button|Callout|Card|Checkbox|IconButton|Menu|Progress|Radio|Slider|Switch|TextField|Toggle|ToggleGroup)'
      r'(?:<[^>]+>)?\s*\((?:[^()]|\([^()]*\)){0,1200}?'
      r'\bvariant\s*:\s*(?:Fortal[A-Za-z0-9_]+Variant\s*)?'
      r'\.(?:classic|solid|soft|surface|outline|ghost)',
    ),
    'static Fortal variant argument; use its named constructor',
  ),
  (
    RegExp(r'\b(?:targetAnchor|followerAnchor)\s*:'),
    'retired overlay anchor API',
  ),
  (
    RegExp(r'\bentries\s*:'),
    'renamed Menu/Select collection argument; use items',
  ),
  // Narrow on purpose: the slot spellings always end in `(` or `:`, so the
  // pinned `RemixPathGlyph.chevronDown` / `FortalIcons.chevron*` glyph names
  // and prose about the chevron the indicator draws stay legal.
  (
    RegExp(r'\bchevron(?:Opacity)?\s*[(:]|\$chevron(?:Opacity)?\b'),
    'renamed Select trigger indicator slot; use indicator/indicatorOpacity',
  ),
  (
    RegExp(
      r'\b(?:RemixPaintShadow(?:Kind|Mix|ListToken)?|RemixSurface(?:Layer|Effects)?(?:Spec|Mix)?|remixSurface(?:Box|FlexBox))\b',
    ),
    'retired surface-effects API',
  ),
  (
    RegExp(
      r'\b(?:remixBoxWithEffects|remixFlexBoxWithEffects|remixInheritedContentStyle)\b',
    ),
    'removed internal widget helper',
  ),
  (RegExp(r'\.effects\s*\('), 'retired generic effects styler'),
  (
    RegExp(r'generated Fortal', caseSensitive: false),
    'stale generated-wrapper claim',
  ),
  (
    RegExp(
      r'\.(paddingTop|paddingBottom|paddingLeft|paddingRight|paddingX|'
      r'paddingY|paddingAll|paddingStart|paddingEnd|paddingOnly)\s*\(',
    ),
    'retired Box padding convenience; use padding(.all/.horizontal/.vertical/'
        '.top/.bottom/.left/.right/.start/.end/.only/.symmetric/.directional(...))',
  ),
  (
    RegExp(
      r'\.(marginTop|marginBottom|marginLeft|marginRight|marginX|marginY|'
      r'marginAll|marginStart|marginEnd|marginOnly)\s*\(',
    ),
    'retired Box margin convenience; use margin(.all/.horizontal/.vertical/'
        '.top/.bottom/.left/.right/.start/.end/.only/.symmetric/.directional(...))',
  ),
  (
    RegExp(r'\.constraintsOnly\s*\('),
    'retired Box constraints convenience; use '
        'constraints(.width/.height(...)) or constraints(BoxConstraintsMix(...))',
  ),
  (
    RegExp(
      r'\.(borderTop|borderBottom|borderLeft|borderRight|borderStart|'
      r'borderEnd|borderVertical|borderHorizontal|borderAll)\s*\(',
    ),
    'retired Box border-side convenience; use '
        'border(.top/.bottom/.left/.right/.start/.end/.vertical/.horizontal/.all(...))',
  ),
  (
    RegExp(
      r'\.(borderRadiusAll|borderRadiusTop|borderRadiusBottom|'
      r'borderRadiusLeft|borderRadiusRight|borderRadiusTopLeft|'
      r'borderRadiusTopRight|borderRadiusBottomLeft|borderRadiusBottomRight|'
      r'borderRadiusTopStart|borderRadiusTopEnd|borderRadiusBottomStart|'
      r'borderRadiusBottomEnd)\s*\(',
    ),
    'retired Box borderRadius convenience; use '
        'borderRadius(.all/.top/.bottom/.left/.right/...(radius))',
  ),
  (
    RegExp(
      r'\.(borderRounded|borderRoundedTop|borderRoundedBottom|'
      r'borderRoundedLeft|borderRoundedRight|borderRoundedTopLeft|'
      r'borderRoundedTopRight|borderRoundedBottomLeft|'
      r'borderRoundedBottomRight|borderRoundedTopStart|borderRoundedTopEnd|'
      r'borderRoundedBottomStart|borderRoundedBottomEnd)\s*\(',
    ),
    'retired Box borderRounded convenience; use borderRadius(.circular(x)) '
        'or nest .circular(x) inside a directional shorthand',
  ),
  (
    RegExp(
      r'\.(shapeCircle|shapeStadium|shapeRoundedRectangle|'
      r'shapeBeveledRectangle|shapeContinuousRectangle|shapeStar|'
      r'shapeLinear|shapeSuperellipse)\s*\(',
    ),
    'retired Box shape convenience; use '
        'shape(.circle/.stadium/.roundedRectangle/...(...))',
  ),
  (
    RegExp(r'\.(shadowOnly|boxShadows|boxElevation)\s*\('),
    'retired Box shadow convenience; use decoration(.boxShadow([...]))',
  ),
  (
    RegExp(r'\.transformReset\s*\('),
    'retired Box transform convenience; use transform(Matrix4.identity())',
  ),
  (
    _removedComponentBackgroundColorInvocation,
    'retired component backgroundColor alias; use color',
  ),
];

final _iconButtonInvocation = RegExp(
  r'\b(?:RemixIconButton|FortalIconButton)(?:\.[A-Za-z0-9_]+)?\s*\(',
);
final _applicationBarrelImport = RegExp(
  r'''import\s+['"]ui/ui\.dart['"]\s*;''',
);

/// A fenced Dart block, indented or not, optionally preceded by an excerpt
/// marker: `{/* dart-excerpt: reason */}` in MDX or
/// `<!-- dart-excerpt: reason -->` in Markdown, on its own line, with only blank
/// lines or other MDX comments between it and the fence.
///
/// Group 1 is the excerpt reason (null when unmarked), group 2 the fence
/// indent, group 3 the raw body.
final _dartFence = RegExp(
  r'^(?:[ \t]*(?:\{/\*|<!--)[ \t]*dart-excerpt:[ \t]*(.+?)[ \t]*(?:\*/\}|-->)[ \t]*\n'
  r'(?:[ \t]*(?:\{/\*.*?\*/\})?[ \t]*\n)*)?'
  r'( *)```dart[ \t]*\n([\s\S]*?)\n\2```[ \t]*$',
  multiLine: true,
);
final _excerptMarker = RegExp(r'dart-excerpt:');
// A placeholder ellipsis, as opposed to a spread (`...items`, `...?items`).
final _placeholderEllipsis = RegExp(r'\.\.\.(?![\w\[({?])');
final _fortalApiReference = RegExp(r'\b(?:Fortal|fortal)[A-Z]\w*');
final _applicationTypeName = RegExp(r'\bUi([A-Z]\w*)');
final _agentTypeDeclaration = RegExp(
  r'^(?:(?:abstract|final|sealed|base|mixin)\s+)*'
  r'(?:class|enum|typedef|extension type|mixin)\s+Agent(\w+)',
  multiLine: true,
);

const _exampleSourceDirectories = <String>[
  'apps/dashboard/lib',
  'apps/demo/lib',
  'apps/playground/lib',
  'packages/remix/example',
  'registry_source/example',
];

// Package library sources aren't examples, but the same retired-API sweep
// applies: doc comments quote call sites and drift the same way prose does.
const _packageLibraryDirectories = <String>[
  'packages/remix/lib',
  'registry_source/lib',
];

// Test code is part of the canonical-styler contract too. Mix still exposes
// several retired Remix convenience spellings, so those calls continue to
// compile and cannot be left to the analyzer alone. Some app test directories
// are optional today but should be picked up automatically when added later.
const _testSourceDirectories = <String>[
  'apps/dashboard/test',
  'apps/demo/test',
  'apps/playground/test',
  'packages/remix/test',
  'registry_source/test',
];

const _publishedSkillDirectories = <String>[
  'skills/using-remix',
  'skills/building-remix-design-system',
];
const _consumerDocumentationFiles = <String>[
  'README.md',
  'packages/remix/README.md',
  'registry_source/docs/fortal/README.md',
  'packages/remix_cli/README.md',
  'open_code/README.md',
  'open_code/CLEAN_SHEET.md',
];

final _staleConsumerDocumentationClaims = <(RegExp, String)>[
  (
    RegExp(r'one enum-based constructor', caseSensitive: false),
    'stale single-constructor Fortal claim',
  ),
  (
    RegExp(
      r'(?:variant-specific\s+named\s+constructors\s+'
      r'(?:are\s+not\s+part|were\s+removed)|'
      r'there\s+are\s+no\s+variant-specific\s+named\s+constructors)',
      caseSensitive: false,
    ),
    'stale missing Fortal named-constructor claim',
  ),
  (
    RegExp(
      r'`?(?:Remix|Fortal)IconButton`?[^\n]{0,100}`?Widget\s+child`?',
      caseSensitive: false,
    ),
    'stale IconButton child-slot claim',
  ),
  (
    RegExp(
      r'`?\.backgroundColor\(\)`?\s+(?:is|was|remains)\s+(?:an?\s+)?alias\b',
      caseSensitive: false,
    ),
    'stale component backgroundColor alias claim',
  ),
  (
    RegExp(r'ThemeScope\s*\(\s*data\s*:'),
    'retired theme scope data argument; use theme',
  ),
];

/// Documents that list the open-code registry's items by name.
///
/// The catalog is the one thing in these files that goes stale the instant a
/// registry item lands, and it is the thing a reader trusts most.
const _openCodeCatalogDocuments = <String>[
  'docs/open-code.mdx',
  'packages/remix_cli/README.md',
  'open_code/README.md',
];

/// Fails when an item in either remote preset is missing from a catalog
/// document.
///
/// Deliberately one-directional: a document may mention `theme` or discuss an
/// item in prose without listing it, and matching that exactly would make the
/// check fight the writing. What it will not allow is shipping an item nobody
/// wrote down.
void _checkOpenCodeCatalog(Directory workspaceRoot, List<String> failures) {
  final items = <String>{};
  // The published index is the source of truth for which presets ship, so a
  // preset added or held back there needs no matching edit here.
  final index = File('${workspaceRoot.path}/registry/index.yaml');
  if (!index.existsSync()) {
    failures.add('registry/index.yaml is missing.');
    return;
  }
  final presets = RegExp(r'^  ([a-z][a-z0-9_]*):', multiLine: true)
      .allMatches(index.readAsStringSync())
      .map((match) => match.group(1)!)
      .toList();
  if (presets.isEmpty) {
    failures.add('registry/index.yaml declares no presets.');
    return;
  }
  for (final preset in presets) {
    final registry = File(
      '${workspaceRoot.path}/registry/'
      '$preset/registry.yaml',
    );
    if (!registry.existsSync()) {
      failures.add('registry/$preset/registry.yaml is missing.');
      continue;
    }

    // Item keys are the only two-space-indented `name:` lines in the file.
    items.addAll(
      RegExp(r'^  ([a-z][a-z0-9_]*):$', multiLine: true)
          .allMatches(registry.readAsStringSync())
          .map((match) => match.group(1)!)
          .where((name) => name != 'theme'),
    );
  }
  if (items.isEmpty) {
    failures.add('remote registries declared no component items.');
    return;
  }

  for (final relativePath in _openCodeCatalogDocuments) {
    final file = File('${workspaceRoot.path}/$relativePath');
    if (!file.existsSync()) {
      failures.add('$relativePath is missing.');
      continue;
    }
    final source = file.readAsStringSync();
    final missing = items.where((item) => !source.contains('`$item`')).toList()
      ..sort();
    if (missing.isNotEmpty) {
      failures.add(
        '$relativePath does not list registry ${missing.join(', ')}.',
      );
    }
  }
}

Future<void> main() async {
  // This validator owns root `docs/`, root `docs.json`, the root README, both
  // package READMEs, and the published skills, so it lives at the workspace
  // root rather than inside a package.
  final workspaceRoot = Directory.current.absolute;
  final pubspec = File('${workspaceRoot.path}/pubspec.yaml');
  if (!pubspec.existsSync() ||
      !pubspec.readAsStringSync().contains('name: remix_workspace')) {
    stderr.writeln('Run this validator from the workspace root.');
    exitCode = 64;
    return;
  }

  final docsRoot = Directory('${workspaceRoot.path}/docs');
  final docsConfig = File('${workspaceRoot.path}/docs.json');
  final failures = <String>[];

  final docs =
      docsRoot
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.mdx'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  if (docs.isEmpty) failures.add('No MDX documentation files were found.');

  for (final file in docs) {
    final relativePath = _relativePath(workspaceRoot, file);
    final source = file.readAsStringSync();
    if (!source.startsWith('---\n')) {
      failures.add('$relativePath is missing YAML front matter.');
    }
    if ('```'.allMatches(source).length.isOdd) {
      failures.add('$relativePath has an unclosed code fence.');
    }
    if ('<CodeGroup'.allMatches(source).length !=
        '</CodeGroup>'.allMatches(source).length) {
      failures.add('$relativePath has unbalanced CodeGroup tags.');
    }
    _checkRetiredApis(source, relativePath, failures);
  }

  final consumerDocumentationCount = _checkConsumerDocumentation(
    workspaceRoot,
    failures,
  );
  _checkOpenCodeCatalog(workspaceRoot, failures);
  _checkSkillEvalMetadata(workspaceRoot, failures);
  final exampleSourceCount = _checkDartSources(
    workspaceRoot,
    _exampleSourceDirectories,
    'app/example source',
    failures,
  );
  final packageLibrarySourceCount = _checkDartSources(
    workspaceRoot,
    _packageLibraryDirectories,
    'package library source',
    failures,
  );
  final testSourceCount = _checkDartSources(
    workspaceRoot,
    _testSourceDirectories,
    'test source',
    failures,
    requireDirectories: false,
  );

  _checkNavigation(workspaceRoot, docsConfig, failures);
  _checkFortalScopeTopology(workspaceRoot, failures);

  if (failures.isNotEmpty) {
    _finish(failures);
    return;
  }

  final skillDocuments = [
    for (final relativeDirectory in _publishedSkillDirectories)
      ...Directory('${workspaceRoot.path}/$relativeDirectory')
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.md')),
  ]..sort((a, b) => a.path.compareTo(b.path));
  final extraction = _extractAnalyzableSnippets(
    [...docs, ...skillDocuments],
    workspaceRoot,
    failures,
  );
  final snippets = extraction.snippets;
  if (failures.isNotEmpty) {
    _finish(failures);
    return;
  }

  final tempRoot = Directory(
    '${workspaceRoot.path}/tool/.docs_validation_${pid}_${DateTime.now().microsecondsSinceEpoch}',
  );
  tempRoot.createSync(recursive: true);
  try {
    final agentTypes = _agentTypeNames(workspaceRoot);
    for (final (index, snippet) in snippets.indexed) {
      final file = File('${tempRoot.path}/snippet_$index.dart');
      file.writeAsStringSync(
        '// Generated temporarily by tool/validate_docs.dart.\n'
        '${_validationSource(snippet.source, agentTypes)}\n',
      );
    }

    final result = await Process.run(Platform.resolvedExecutable, [
      'analyze',
      tempRoot.path,
    ], workingDirectory: workspaceRoot.path);
    if (result.exitCode != 0) {
      failures
        ..add('Dart documentation examples do not analyze.')
        ..add('${result.stdout}${result.stderr}'.trim())
        ..add(
          'Snippet map:\n${snippets.indexed.map((entry) => '  '
              'snippet_${entry.$1}.dart = ${entry.$2.path}').join('\n')}',
        );
    }
  } finally {
    if (tempRoot.existsSync()) tempRoot.deleteSync(recursive: true);
  }

  if (failures.isNotEmpty) {
    _finish(failures);
    return;
  }

  if (extraction.excerpts.isNotEmpty) {
    stdout.writeln('Dart excerpts left uncompiled, each with its reason:');
    for (final excerpt in extraction.excerpts) {
      stdout.writeln('  $excerpt');
    }
  }
  stdout.writeln(
    'Documentation validation passed: ${docs.length} MDX files, '
    '${snippets.length} analyzable Dart examples (docs and published skills), and '
    '${extraction.excerpts.length} marked Dart excerpts, plus '
    '$exampleSourceCount app/example Dart sources, plus '
    '$packageLibrarySourceCount package library Dart sources, plus '
    '$testSourceCount test Dart sources, plus '
    '$consumerDocumentationCount consumer-facing Markdown files.',
  );
}

int _checkConsumerDocumentation(
  Directory workspaceRoot,
  List<String> failures,
) {
  final documents = <File>[];
  for (final relativeDirectory in _publishedSkillDirectories) {
    final directory = Directory('${workspaceRoot.path}/$relativeDirectory');
    if (!directory.existsSync()) {
      failures.add(
        'Missing consumer documentation directory: $relativeDirectory.',
      );
      continue;
    }
    documents.addAll(
      directory
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.md')),
    );
  }
  for (final relativeFile in _consumerDocumentationFiles) {
    final file = File('${workspaceRoot.path}/$relativeFile');
    if (!file.existsSync()) {
      failures.add('Missing consumer documentation file: $relativeFile.');
      continue;
    }
    documents.add(file);
  }
  documents.sort((a, b) => a.path.compareTo(b.path));

  for (final file in documents) {
    final relativePath = _relativePath(workspaceRoot, file);
    final source = file.readAsStringSync();
    if ('```'.allMatches(source).length.isOdd) {
      failures.add('$relativePath has an unclosed code fence.');
    }
    for (final (pattern, description) in _staleConsumerDocumentationClaims) {
      final match = pattern.firstMatch(source);
      if (match != null) {
        failures.add(
          '$relativePath contains a $description at offset ${match.start}.',
        );
      }
    }
    for (final (index, match) in _dartFence.allMatches(source).indexed) {
      _checkRetiredApis(
        _fenceBody(match),
        '$relativePath Dart example ${index + 1}',
        failures,
      );
    }
  }

  return documents.length;
}

void _checkSkillEvalMetadata(Directory workspaceRoot, List<String> failures) {
  for (final skillDirectory in _publishedSkillDirectories) {
    final evalsFile = File(
      '${workspaceRoot.path}/$skillDirectory/evals/evals.json',
    );
    if (!evalsFile.existsSync()) {
      failures.add('$skillDirectory is missing evals/evals.json.');
      continue;
    }

    Object? decoded;
    try {
      decoded = jsonDecode(evalsFile.readAsStringSync());
    } on FormatException catch (error) {
      failures.add('$skillDirectory/evals/evals.json is invalid: $error');
      continue;
    }
    if (decoded is! Map<String, Object?>) {
      failures.add('$skillDirectory/evals/evals.json must be a JSON object.');
      continue;
    }

    final expectedName = skillDirectory.split('/').last;
    if (decoded['skill_name'] != expectedName) {
      failures.add(
        '$skillDirectory/evals/evals.json skill_name must be $expectedName.',
      );
    }
    final evals = decoded['evals'];
    if (evals is! List<Object?> || evals.isEmpty) {
      failures.add('$skillDirectory/evals/evals.json needs nonempty evals.');
      continue;
    }

    final ids = <int>{};
    for (final (index, value) in evals.indexed) {
      final label = '$skillDirectory/evals/evals.json eval ${index + 1}';
      if (value is! Map<String, Object?>) {
        failures.add('$label must be a JSON object.');
        continue;
      }
      final id = value['id'];
      if (id is! int || !ids.add(id)) {
        failures.add('$label needs a unique integer id.');
      }
      for (final field in ['prompt', 'expected_output']) {
        final fieldValue = value[field];
        if (fieldValue is! String || fieldValue.trim().isEmpty) {
          failures.add('$label needs a nonempty $field.');
        }
      }
      final expectations = value['expectations'];
      if (expectations is! List<Object?> ||
          expectations.isEmpty ||
          expectations.any((item) => item is! String || item.trim().isEmpty)) {
        failures.add('$label needs nonempty string expectations.');
      }
      final files = value['files'];
      if (files is! List<Object?> || files.any((item) => item is! String)) {
        failures.add('$label files must be a list of strings.');
        continue;
      }
      for (final path in files.cast<String>()) {
        if (!File('${workspaceRoot.path}/$skillDirectory/$path').existsSync()) {
          failures.add('$label references missing file $path.');
        }
      }
    }
  }
}

int _checkDartSources(
  Directory workspaceRoot,
  List<String> directories,
  String missingDirectoryLabel,
  List<String> failures, {
  bool requireDirectories = true,
}) {
  final sources = <File>[];
  for (final relativeDirectory in directories) {
    final directory = Directory('${workspaceRoot.path}/$relativeDirectory');
    if (!directory.existsSync()) {
      if (requireDirectories) {
        failures.add(
          'Missing $missingDirectoryLabel directory: $relativeDirectory.',
        );
      }
      continue;
    }
    sources.addAll(
      directory
          .listSync(recursive: true)
          .whereType<File>()
          .where(
            (file) =>
                file.path.endsWith('.dart') && !file.path.endsWith('.g.dart'),
          ),
    );
  }
  sources.sort((a, b) => a.path.compareTo(b.path));

  for (final file in sources) {
    final relativePath = _relativePath(workspaceRoot, file);
    final source = file.readAsStringSync();
    _checkRetiredApis(source, relativePath, failures);
  }

  return sources.length;
}

void _checkRetiredApis(
  String source,
  String relativePath,
  List<String> failures,
) {
  for (final (pattern, description) in _retiredApis) {
    final match = pattern.firstMatch(source);
    if (match != null) {
      failures.add(
        '$relativePath contains a $description at offset ${match.start}.',
      );
    }
  }
  _checkLegacyIconButtonSlot(source, relativePath, failures);
}

void _checkLegacyIconButtonSlot(
  String source,
  String relativePath,
  List<String> failures,
) {
  for (final invocation in _iconButtonInvocation.allMatches(source)) {
    final openingParenthesis = invocation.end - 1;
    final closingParenthesis = _matchingParenthesis(source, openingParenthesis);
    if (closingParenthesis == null) continue;
    final arguments = source.substring(
      openingParenthesis + 1,
      closingParenthesis,
    );
    final childOffset = _topLevelNamedArgumentOffset(arguments, 'child');
    if (childOffset == null) continue;
    failures.add(
      '$relativePath contains the retired IconButton child argument at offset '
      '${openingParenthesis + 1 + childOffset}; use icon, and add iconBuilder '
      'for custom composition.',
    );
  }
}

int? _topLevelNamedArgumentOffset(String source, String name) {
  var parentheses = 0;
  var brackets = 0;
  var braces = 0;
  String? quote;
  var escaped = false;

  for (var index = 0; index < source.length; index += 1) {
    final character = source[index];
    if (quote != null) {
      if (escaped) {
        escaped = false;
      } else if (character == r'\') {
        escaped = true;
      } else if (character == quote) {
        quote = null;
      }
      continue;
    }

    if (character == "'" || character == '"') {
      quote = character;
      continue;
    }
    switch (character) {
      case '(':
        parentheses += 1;
      case ')':
        parentheses -= 1;
      case '[':
        brackets += 1;
      case ']':
        brackets -= 1;
      case '{':
        braces += 1;
      case '}':
        braces -= 1;
    }
    if (parentheses != 0 || brackets != 0 || braces != 0) continue;
    if (!source.startsWith(name, index)) continue;

    final beforeIsIdentifier =
        index > 0 && RegExp(r'[A-Za-z0-9_$]').hasMatch(source[index - 1]);
    final afterName = index + name.length;
    final afterIsIdentifier =
        afterName < source.length &&
        RegExp(r'[A-Za-z0-9_$]').hasMatch(source[afterName]);
    if (beforeIsIdentifier || afterIsIdentifier) continue;

    var separator = afterName;
    while (separator < source.length &&
        RegExp(r'\s').hasMatch(source[separator])) {
      separator += 1;
    }
    if (separator < source.length && source[separator] == ':') return index;
  }
  return null;
}

int? _matchingParenthesis(String source, int openingParenthesis) {
  var depth = 0;
  for (var index = openingParenthesis; index < source.length; index += 1) {
    switch (source[index]) {
      case '(':
        depth += 1;
      case ')':
        depth -= 1;
        if (depth == 0) return index;
    }
  }
  return null;
}

void _checkNavigation(
  Directory workspaceRoot,
  File config,
  List<String> failures,
) {
  if (!config.existsSync()) {
    failures.add('Missing docs.json.');
    return;
  }
  Object? decoded;
  try {
    decoded = jsonDecode(config.readAsStringSync());
  } on FormatException catch (error) {
    failures.add('docs.json is invalid JSON: $error');
    return;
  }
  if (decoded is! Map<String, Object?>) {
    failures.add('docs.json must contain a JSON object.');
    return;
  }

  final hrefs = <String>[];
  void collect(Object? value) {
    switch (value) {
      case Map<String, Object?> map:
        if (map['href'] case final String href) hrefs.add(href);
        for (final child in map.values) {
          collect(child);
        }
      case List<Object?> list:
        for (final child in list) {
          collect(child);
        }
    }
  }

  collect(decoded['sidebar']);
  for (final href in hrefs) {
    final path = href == '/'
        ? '${workspaceRoot.path}/docs/index.mdx'
        : '${workspaceRoot.path}/docs$href.mdx';
    if (!File(path).existsSync()) {
      failures.add(
        'docs.json links $href to missing ${_relative(path, workspaceRoot)}.',
      );
    }
  }
}

void _checkFortalScopeTopology(Directory workspaceRoot, List<String> failures) {
  const relativePath = 'docs/fortal.mdx';
  final page = File('${workspaceRoot.path}/$relativePath');
  if (!page.existsSync()) {
    failures.add('Missing $relativePath.');

    return;
  }
  final topology = RegExp(
    r'return\s+FortalScope\s*\(\s*child:\s*WidgetsApp\s*\(',
    dotAll: true,
  );
  if (!topology.hasMatch(page.readAsStringSync())) {
    failures.add(
      '$relativePath must place the root FortalScope above WidgetsApp.',
    );
  }
}

/// Collects every fenced Dart block that must analyze.
///
/// Every block is compiled unless it carries a `dart-excerpt` marker naming why
/// it cannot stand alone (a section of a multi-file layout, a signature
/// listing, a pinned tutorial). Marked blocks are counted and reported, never
/// silently dropped, and the retired-API sweep still reads them. An unmarked
/// block that cannot compile is a documentation bug, whatever it imports.
({List<({String path, String source})> snippets, List<String> excerpts})
_extractAnalyzableSnippets(
  List<File> docs,
  Directory workspaceRoot,
  List<String> failures,
) {
  final snippets = <({String path, String source})>[];
  final excerpts = <String>[];
  for (final file in docs) {
    final relativePath = _relativePath(workspaceRoot, file);
    final source = file.readAsStringSync();
    final matches = _dartFence.allMatches(source).toList();
    final markers = _excerptMarker.allMatches(source).length;
    final claimed = matches.where((match) => match.group(1) != null).length;
    if (markers != claimed) {
      failures.add(
        '$relativePath has a dart-excerpt marker that is not directly above a '
        '```dart fence.',
      );
    }
    for (final (index, match) in matches.indexed) {
      final label = '$relativePath#${index + 1}';
      final reason = match.group(1);
      if (reason != null) {
        excerpts.add('$label ($reason)');
        continue;
      }
      final snippet = _fenceBody(match);
      if (_placeholderEllipsis.hasMatch(snippet)) {
        failures.add(
          '$relativePath Dart example ${index + 1} contains an ellipsis and '
          'cannot be compile-validated; mark it with dart-excerpt or complete it.',
        );
        continue;
      }
      snippets.add((path: label, source: snippet));
    }
  }
  return (snippets: snippets, excerpts: excerpts);
}

/// The fence body with the fence's own indent removed from every line.
String _fenceBody(RegExpMatch match) {
  final indent = match.group(2)!;
  final body = match.group(3)!;
  if (indent.isEmpty) return body;
  return body
      .split('\n')
      .map(
        (line) =>
            line.startsWith(indent) ? line.substring(indent.length) : line,
      )
      .join('\n');
}

/// The suffixes of every type the Agent surfaces declare under their
/// authoring word, so `UiMessage` can be told apart from `UiButton`.
Set<String> _agentTypeNames(Directory workspaceRoot) {
  final names = <String>{};
  final agentSource = Directory(
    '${workspaceRoot.path}/registry_source/lib/src/agent',
  );
  for (final file in agentSource.listSync(recursive: true).whereType<File>()) {
    if (!file.path.endsWith('.dart') || file.path.endsWith('.g.dart')) continue;
    for (final match in _agentTypeDeclaration.allMatches(
      file.readAsStringSync(),
    )) {
      names.add(match.group(1)!);
    }
  }
  return names;
}

/// Points a snippet that imports the application-owned `ui/ui.dart` barrel at
/// the analyzer-checked authoring source that barrel is installed from.
///
/// The temporary validation directory has no application package. `Fortal*`
/// and `fortal*` names match `package:registry_source/fortal.dart`
/// byte-for-byte. `Ui*` is the prefix `remix init` installs under, so each
/// such type name is renamed back to its authoring word: an Agent surface's
/// word is `Agent`; every other name belongs to the preset, which is Fortal
/// when the snippet names anything Fortal and the default Vanilla preset
/// otherwise. Value names under `ui*` have no example yet, so they are left
/// alone and fail as undefined. The derivation round trip separately proves
/// that the prefixed APIs match.
String _validationSource(String snippet, Set<String> agentTypes) {
  if (!_applicationBarrelImport.hasMatch(snippet)) return snippet;
  final preset = _fortalApiReference.hasMatch(snippet) ? 'fortal' : 'vanilla';
  final typeWord = '${preset[0].toUpperCase()}${preset.substring(1)}';
  var usesAgent = false;
  var usesPreset = preset == 'fortal';
  final renamed = snippet.replaceAllMapped(_applicationTypeName, (match) {
    final name = match.group(1)!;
    if (agentTypes.contains(name)) {
      usesAgent = true;
      return 'Agent$name';
    }
    usesPreset = true;
    return '$typeWord$name';
  });
  final imports = [
    if (usesPreset || !usesAgent)
      "import 'package:registry_source/$preset.dart';",
    if (usesAgent) "import 'package:registry_source/agent.dart';",
  ];
  return renamed.replaceAll(_applicationBarrelImport, imports.join('\n'));
}

String _relativePath(Directory root, File file) => _relative(file.path, root);

String _relative(String path, Directory root) {
  final prefix = '${root.path}${Platform.pathSeparator}';
  return path.startsWith(prefix) ? path.substring(prefix.length) : path;
}

void _finish(List<String> failures) {
  stderr.writeln('Documentation validation failed (${failures.length}):');
  for (final failure in failures) {
    stderr.writeln('- $failure');
  }
  exitCode = 1;
}
