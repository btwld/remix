import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../packages/remix_cli/lib/src/registry.dart';

/// Derives the application-owned Fortal registry from `remix_fortal` source.
///
/// Run without arguments to synchronize committed output. Pass `--check` to
/// compare in memory and fail on drift without writing.
void main(List<String> arguments) {
  final check = arguments.contains('--check');
  final unknown = arguments.where((argument) => argument != '--check').toList();
  if (unknown.isNotEmpty || arguments.length != (check ? 1 : 0)) {
    stderr.writeln('Usage: dart run tool/build_fortal_preset.dart [--check]');
    exitCode = 64;
    return;
  }

  final repositoryRoot = Directory.current.absolute;
  final pubspec = File(p.join(repositoryRoot.path, 'pubspec.yaml'));
  if (!pubspec.existsSync() ||
      !RegExp(
        r'^name:\s*remix_workspace\s*$',
        multiLine: true,
      ).hasMatch(pubspec.readAsStringSync())) {
    stderr.writeln('Run this tool from the Remix workspace root.');
    exitCode = 64;
    return;
  }

  try {
    final builder = PresetBuilder.forRepository(repositoryRoot);
    final agentBuilder = PresetBuilder.forRepository(
      repositoryRoot,
      spec: fortalAgentExtension,
    );
    final output = mergePresetOutputs(builder.derive(), agentBuilder.derive());
    if (!check) {
      builder.write(output);
      stdout.writeln(
        'Wrote the Fortal preset: ${output.files.length - 1} templates and '
        'registry.yaml.',
      );
      return;
    }

    final drift = builder.drift(output);
    if (drift.isNotEmpty) {
      stderr
        ..writeln('The committed Fortal preset is stale:')
        ..writeln(drift.map((entry) => '  - $entry').join('\n'))
        ..writeln(
          'Run `dart run tool/build_fortal_preset.dart` and commit the result.',
        );
      exitCode = 1;
      return;
    }
    stdout.writeln('The committed Fortal preset matches authored source.');
  } on Object catch (error) {
    stderr.writeln(error);
    exitCode = 1;
  }
}

/// One derivable source package, and everything that distinguishes it.
///
/// The builder below turns analyzer-checked Dart source into a bundled
/// registry tree. It does not know which package it is reading, what word
/// stands in for the consumer's prefix, or which items exist outside the
/// component directory. Those live here, so a second source package is a new
/// [PresetSpec] rather than a second copy of the builder.
final class PresetSpec {
  const PresetSpec({
    required this.name,
    required this.sourcePackage,
    required this.typeWord,
    required this.valueWord,
    required this.componentDirectory,
    required this.sharedItems,
    required this.copiedItems,
    required this.ignoredSourceFiles,
    required this.floorPackages,
    required this.detectedPackages,
    required this.composedRegistryDependencies,
    this.recipeItems = const [],
    this.ownedTemplateDirectory,
  });

  /// Preset name, and the directory it occupies under the bundled registry.
  final String name;

  /// A partially owned template subtree inside [name]. Null owns the whole
  /// preset, including registry.yaml. Partial output only asserts that file.
  final String? ownedTemplateDirectory;

  String get templateDirectory => ownedTemplateDirectory ?? 'templates';

  /// Package whose `lib/src` is the authored source, e.g. `remix_fortal`.
  ///
  /// Installed source may never import it: an item ships the source itself.
  final String sourcePackage;

  /// Identifier casing replaced by `{{typePrefix}}`, e.g. `Fortal`.
  final String typeWord;

  /// Lowercase casing replaced by `{{valuePrefix}}`, e.g. `fortal`.
  final String valueWord;

  /// Source directory holding one file per component item.
  final String componentDirectory;

  /// Items assembled from a source directory that components may import.
  final List<SharedItemSpec> sharedItems;

  /// Items copied verbatim from the default preset rather than derived.
  final List<CopiedItemSpec> copiedItems;

  /// Source files that are legal to author but own no registry item.
  final Set<String> ignoredSourceFiles;

  /// Packages whose constraint must be readable from the default registry.
  final Set<String> floorPackages;

  /// Packages declared on an item when its source imports them.
  final List<String> detectedPackages;

  /// Registry dependencies a component composes but never imports.
  ///
  /// Import inference misses `sidebar_layout` -> `sidebar`: its `sidebar`
  /// field is typed `Widget`, not `FortalSidebar`, so nothing imports
  /// `components/sidebar.dart`. The default preset's hand-authored
  /// registry.yaml declares the same dependency for the same reason.
  final Map<String, List<String>> composedRegistryDependencies;

  /// Hand-authored, preset-specific Agent recipes. Their canonical templates
  /// live outside either runtime package under `open_code/agent_recipes/`.
  final List<RecipeItemSpec> recipeItems;

  /// Source directories this preset reads, shared items first.
  List<String> get sourceDirectories => [
    for (final item in sharedItems) item.directory,
    componentDirectory,
  ];

  /// Item name owning each shared source directory.
  Map<String, String> get itemsByDirectory => {
    for (final item in sharedItems) item.directory: item.name,
  };

  /// Package imports that must never appear in installed source.
  List<String> get forbiddenImportPrefixes => [
    'package:$sourcePackage/',
    'package:mix/',
    'package:naked_ui/',
  ];
}

/// An item derived from every file in one source directory.
final class SharedItemSpec {
  const SharedItemSpec({
    required this.name,
    required this.directory,
    required this.requiredFile,
    required this.packages,
    required this.exports,
    this.registryDependencies = const [],
  });

  final String name;

  /// Source directory, also the installed target directory under `@ui/`.
  final String directory;

  /// Source path that must exist, or the preset is not derivable.
  final String requiredFile;

  final Set<String> packages;
  final List<String> exports;
  final List<String> registryDependencies;
}

/// An item taken verbatim from the default preset instead of from source.
final class CopiedItemSpec {
  const CopiedItemSpec({
    required this.name,
    required this.templatePath,
    required this.target,
    required this.registryDependencies,
    required this.packages,
    required this.exports,
  });

  final String name;
  final String templatePath;
  final String target;
  final List<String> registryDependencies;
  final Set<String> packages;
  final List<String> exports;
}

final class RecipeItemSpec {
  const RecipeItemSpec({
    required this.name,
    required this.registryDependencies,
  });

  final String name;
  final List<String> registryDependencies;
}

/// The Fortal design system as application-owned registry source.
const fortalPreset = PresetSpec(
  name: 'fortal',
  sourcePackage: 'remix_fortal',
  typeWord: 'Fortal',
  valueWord: 'fortal',
  componentDirectory: 'components',
  sharedItems: [
    SharedItemSpec(
      name: 'theme',
      directory: 'theme',
      requiredFile: 'theme/theme.dart',
      packages: {'remix'},
      exports: ['theme/theme.dart'],
    ),
  ],
  copiedItems: [
    CopiedItemSpec(
      name: 'icons',
      templatePath: 'templates/icons/icons.dart.tmpl',
      target: '@ui/icons.dart',
      registryDependencies: ['theme'],
      packages: {'remix_ui_icons'},
      exports: ['icons.dart'],
    ),
  ],
  // Authored for the package's own use. The registry item copies the default
  // preset's icons template instead, so this file owns no item.
  ignoredSourceFiles: {'icons.dart'},
  floorPackages: {
    'remix',
    'mix_annotations',
    'build_runner',
    'mix_generator',
    'mix_chart',
    'remix_ui_icons',
  },
  detectedPackages: ['mix_chart', 'remix_ui_icons'],
  composedRegistryDependencies: {
    'sidebar_layout': ['sidebar'],
  },
);

/// Agent behavior and Fortal-specific recipes merged into the existing Fortal
/// preset. The full Fortal writer remains the sole owner of that preset.
const fortalAgentExtension = PresetSpec(
  name: 'fortal',
  sourcePackage: 'remix_agent',
  typeWord: 'Agent',
  valueWord: 'agent',
  componentDirectory: 'components',
  ownedTemplateDirectory: 'templates/agent',
  sharedItems: [
    SharedItemSpec(
      name: 'models',
      directory: 'models',
      requiredFile: 'models/statuses.dart',
      packages: {},
      exports: [
        'models/activity_item.dart',
        'models/plan_item.dart',
        'models/statuses.dart',
      ],
    ),
    SharedItemSpec(
      name: 'support',
      directory: 'support',
      requiredFile: 'support/functional_glyph.dart',
      packages: {},
      registryDependencies: ['theme'],
      exports: [],
    ),
  ],
  copiedItems: [],
  ignoredSourceFiles: {},
  floorPackages: {
    'mix_annotations',
    'build_runner',
    'mix_generator',
    'remix_ui_icons',
  },
  detectedPackages: ['remix_ui_icons'],
  composedRegistryDependencies: {},
  recipeItems: [
    RecipeItemSpec(
      name: 'activity_recipe',
      registryDependencies: ['activity', 'disclosure'],
    ),
    RecipeItemSpec(
      name: 'answer_recipe',
      registryDependencies: ['answer', 'card', 'disclosure', 'icon_button'],
    ),
    RecipeItemSpec(
      name: 'composer_recipe',
      registryDependencies: ['composer', 'card', 'textfield', 'icon_button'],
    ),
    RecipeItemSpec(
      name: 'execution_recipe',
      registryDependencies: ['execution', 'card', 'disclosure', 'icon_button'],
    ),
    RecipeItemSpec(
      name: 'message_recipe',
      registryDependencies: ['message', 'card', 'button'],
    ),
    RecipeItemSpec(
      name: 'permission_recipe',
      registryDependencies: [
        'permission',
        'card',
        'disclosure',
        'data_list',
        'button',
      ],
    ),
    RecipeItemSpec(
      name: 'plan_recipe',
      registryDependencies: ['plan', 'disclosure'],
    ),
    RecipeItemSpec(
      name: 'transcript_recipe',
      registryDependencies: ['transcript'],
    ),
  ],
);

PresetOutput mergePresetOutputs(PresetOutput base, PresetOutput extension) {
  final files = <String, String>{...base.files};
  for (final entry in extension.files.entries) {
    if (entry.key == 'registry.yaml') continue;
    if (files.containsKey(entry.key)) {
      throw StateError('Preset outputs collide at ${entry.key}.');
    }
    files[entry.key] = entry.value;
  }
  final items = <String, YamlMap>{};
  final targets = <String, String>{};
  for (final output in [base, extension]) {
    final document = loadYaml(output.files['registry.yaml']!) as YamlMap;
    final entries = document['items'] as YamlMap?;
    if (entries == null) continue;
    for (final entry in entries.entries) {
      final name = entry.key as String;
      if (items.containsKey(name)) {
        throw StateError('Preset items collide at $name.');
      }
      final item = entry.value as YamlMap;
      items[name] = item;
      final sources = item['files'] as YamlList? ?? const [];
      for (final source in sources) {
        if (!files.containsKey(source['source'])) {
          throw StateError(
            'Preset item $name references missing template ${source['source']}.',
          );
        }
      }
      final paths = [
        for (final source in sources) source['target'] as String,
        ...?item['generated'] as YamlList?,
      ];
      for (final target in paths.cast<String>()) {
        final previous = targets[target];
        if (previous != null) {
          throw StateError(
            'Preset targets collide at $target ($previous and $name).',
          );
        }
        targets[target] = name;
      }
    }
  }
  for (final entry in items.entries) {
    for (final dependency
        in entry.value['registryDependencies'] as YamlList? ?? const []) {
      if (!items.containsKey(dependency)) {
        throw StateError(
          'Preset item ${entry.key} has missing dependency $dependency.',
        );
      }
    }
  }
  String body(String yaml) =>
      yaml.substring(yaml.indexOf('items:') + 7).trimRight();
  files['registry.yaml'] =
      '${base.files['registry.yaml']!.split('items:').first}items:\n${body(base.files['registry.yaml']!)}\n\n${body(extension.files['registry.yaml']!)}\n';
  return PresetOutput(
    files: Map.unmodifiable(files),
    sourceByTemplate: Map.unmodifiable({
      ...base.sourceByTemplate,
      ...extension.sourceByTemplate,
    }),
  );
}

/// A deterministic snapshot of every file owned by one derived preset.
final class PresetOutput {
  const PresetOutput({required this.files, required this.sourceByTemplate});

  /// Output paths relative to the preset root. `registry.yaml` is an in-memory
  /// metadata snapshot; partial-preset writers assert it instead of writing it.
  final Map<String, String> files;

  /// Original authored source keyed by its derived template output path.
  ///
  /// This makes the substitution round trip directly testable without
  /// exposing filesystem implementation details.
  final Map<String, String> sourceByTemplate;
}

/// Builds one bundled registry tree from analyzer-checked Dart source.
final class PresetBuilder {
  const PresetBuilder({
    required this.spec,
    required this.sourceRoot,
    required this.defaultRegistryRoot,
    required this.outputRoot,
    this.recipeRoot,
  });

  factory PresetBuilder.forRepository(
    Directory repositoryRoot, {
    PresetSpec spec = fortalPreset,
  }) {
    final registryRoot = Directory(
      p.join(
        repositoryRoot.path,
        'packages',
        'remix_cli',
        'lib',
        'src',
        'registry',
      ),
    );
    return PresetBuilder(
      spec: spec,
      sourceRoot: Directory(
        p.join(
          repositoryRoot.path,
          'packages',
          spec.sourcePackage,
          'lib',
          'src',
        ),
      ),
      defaultRegistryRoot: Directory(p.join(registryRoot.path, 'default')),
      outputRoot: Directory(p.join(registryRoot.path, spec.name)),
      recipeRoot: Directory(
        p.join(repositoryRoot.path, 'open_code', 'agent_recipes', spec.name),
      ),
    );
  }

  final PresetSpec spec;
  final Directory sourceRoot;
  final Directory defaultRegistryRoot;
  final Directory outputRoot;
  final Directory? recipeRoot;

  PresetOutput derive() {
    if (!sourceRoot.existsSync()) {
      throw FormatException(
        '${spec.name} source root is missing: ${sourceRoot.path}',
      );
    }

    final sources = _readSources();
    _validateSources(sources);

    final floors = _readDefaultFloors();
    final output = <String, String>{};
    final sourceByTemplate = <String, String>{};
    final items = <String, _RegistryItemDraft>{};
    final componentPrefix = '${spec.componentDirectory}/';
    final componentNames = {
      for (final path in sources.keys)
        if (path.startsWith(componentPrefix))
          p.posix.basenameWithoutExtension(path),
    };

    for (final shared in spec.sharedItems) {
      final sharedSources = sources.entries
          .where((entry) => entry.key.startsWith('${shared.directory}/'))
          .toList();
      if (!sharedSources.any((entry) => entry.key == shared.requiredFile)) {
        throw FormatException(
          '${spec.name} source must contain ${shared.requiredFile} and the '
          'rest of ${shared.directory}/.',
        );
      }

      final files = <_RegistryFileDraft>[];
      for (final entry in sharedSources) {
        final name = p.posix.basename(entry.key);
        final templatePath =
            '${spec.templateDirectory}/${shared.directory}/$name.tmpl';
        output[templatePath] = _templateFor(entry.key, entry.value);
        sourceByTemplate[templatePath] = entry.value;
        files.add(
          _RegistryFileDraft(
            source: templatePath,
            target: '@ui/${shared.directory}/$name',
          ),
        );
      }
      items[shared.name] = _RegistryItemDraft(
        name: shared.name,
        registryDependencies: {
          ...shared.registryDependencies,
          for (final entry in sharedSources)
            ..._registryDependencies(
              sourcePath: entry.key,
              imports: _imports(entry.value),
              componentNames: componentNames,
            ),
        }.toList(),
        dependencies: {
          for (final package in shared.packages) package: floors[package]!,
          for (final package in spec.detectedPackages)
            if (sharedSources.any(
              (entry) => _imports(
                entry.value,
              ).any((uri) => uri.startsWith('package:$package/')),
            ))
              package: floors[package]!,
        },
        files: files,
        exports: shared.exports,
      );
    }

    for (final copied in spec.copiedItems) {
      final template = File(
        p.joinAll([
          defaultRegistryRoot.path,
          ...p.posix.split(copied.templatePath),
        ]),
      );
      if (!template.existsSync()) {
        throw FormatException(
          'Default ${copied.name} template is missing: ${template.path}',
        );
      }
      output[copied.templatePath] = template.readAsStringSync();
      items[copied.name] = _RegistryItemDraft(
        name: copied.name,
        registryDependencies: copied.registryDependencies,
        dependencies: {
          for (final package in copied.packages) package: floors[package]!,
        },
        files: [
          _RegistryFileDraft(
            source: copied.templatePath,
            target: copied.target,
          ),
        ],
        exports: copied.exports,
      );
    }

    for (final entry in sources.entries.where(
      (entry) => entry.key.startsWith(componentPrefix),
    )) {
      final name = p.posix.basenameWithoutExtension(entry.key);
      final templatePath = '${spec.templateDirectory}/$name/$name.dart.tmpl';
      final generated = _generatedPart(entry.value);
      final imports = _imports(entry.value);
      final registryDependencies = _registryDependencies(
        sourcePath: entry.key,
        imports: imports,
        componentNames: componentNames,
      );
      final dependencies = <String, String>{};
      final devDependencies = <String, String>{};
      if (generated != null) {
        dependencies['mix_annotations'] = floors['mix_annotations']!;
        devDependencies
          ..['build_runner'] = floors['build_runner']!
          ..['mix_generator'] = floors['mix_generator']!;
      }
      for (final package in spec.detectedPackages) {
        if (imports.any((uri) => uri.startsWith('package:$package/'))) {
          dependencies[package] = floors[package]!;
        }
      }

      output[templatePath] = _templateFor(entry.key, entry.value);
      sourceByTemplate[templatePath] = entry.value;
      items[name] = _RegistryItemDraft(
        name: name,
        registryDependencies: registryDependencies,
        dependencies: dependencies,
        devDependencies: devDependencies,
        files: [
          _RegistryFileDraft(
            source: templatePath,
            target: '@ui/$componentPrefix$name.dart',
          ),
        ],
        generated: generated == null
            ? const []
            : ['@ui/$componentPrefix$generated'],
        exports: ['$componentPrefix$name.dart'],
      );
    }

    for (final recipe in spec.recipeItems) {
      final root = recipeRoot;
      if (root == null) {
        throw StateError('${spec.name} recipe root was not configured.');
      }
      final source = File(p.join(root.path, '${recipe.name}.dart.tmpl'));
      if (!source.existsSync()) {
        throw FormatException('Missing canonical recipe: ${source.path}');
      }
      final contents = source.readAsStringSync();
      if (contents.contains('package:remix_agent')) {
        throw FormatException(
          '${recipe.name} imports the private Agent package.',
        );
      }
      final templatePath =
          '${spec.templateDirectory}/recipes/${recipe.name}.dart.tmpl';
      output[templatePath] = contents;
      sourceByTemplate[templatePath] = contents
          .replaceAll('{{typePrefix}}', spec.typeWord)
          .replaceAll('{{valuePrefix}}', spec.valueWord);
      items[recipe.name] = _RegistryItemDraft(
        name: recipe.name,
        registryDependencies: recipe.registryDependencies,
        files: [
          _RegistryFileDraft(
            source: templatePath,
            target: '@ui/recipes/${recipe.name}.dart',
          ),
        ],
        exports: ['recipes/${recipe.name}.dart'],
      );
    }

    final expected =
        componentNames.length +
        spec.sharedItems.length +
        spec.copiedItems.length +
        spec.recipeItems.length;
    if (items.length != expected) {
      throw StateError('${spec.name} registry item names collided.');
    }

    output['registry.yaml'] = _renderRegistry(items);
    if (spec.ownedTemplateDirectory != null) {
      _validateDefaultSeam(output['registry.yaml']!);
    }
    return PresetOutput(
      files: Map.unmodifiable(_sortedMap(output)),
      sourceByTemplate: Map.unmodifiable(_sortedMap(sourceByTemplate)),
    );
  }

  /// Synchronizes only the files owned beneath [outputRoot].
  void write(PresetOutput output) {
    _validateOutput(output);
    final metadata = _metadataDrift(output);
    if (metadata.isNotEmpty) {
      throw StateError(
        '${metadata.join('\n')}\n'
        'Update the owned entries in registry.yaml to match derivation.',
      );
    }
    outputRoot.createSync(recursive: true);
    final writable = _writableFiles(output);
    final expected = writable.keys.toSet();
    for (final file in _outputFiles()) {
      final relative = _relative(file, outputRoot);
      if (!expected.contains(relative)) file.deleteSync();
    }
    for (final entry in writable.entries) {
      final file = File(
        p.joinAll([outputRoot.path, ...p.posix.split(entry.key)]),
      );
      if (file.existsSync() && file.readAsStringSync() == entry.value) continue;
      file.parent.createSync(recursive: true);
      file.writeAsStringSync(entry.value);
    }
  }

  /// Returns stable, human-readable differences without mutating output.
  List<String> drift(PresetOutput output) {
    _validateOutput(output);
    final differences = _metadataDrift(output);
    final actual = {
      for (final file in _outputFiles()) _relative(file, outputRoot): file,
    };
    for (final entry in _writableFiles(output).entries) {
      final file = actual.remove(entry.key);
      if (file == null) {
        differences.add('missing ${entry.key}');
      } else if (file.readAsStringSync() != entry.value) {
        differences.add('changed ${entry.key}');
      }
    }
    for (final stale in actual.keys) {
      differences.add('stale $stale');
    }
    differences.sort();
    return differences;
  }

  Map<String, String> _writableFiles(PresetOutput output) => {
    for (final entry in output.files.entries)
      if (spec.ownedTemplateDirectory == null || entry.key != 'registry.yaml')
        entry.key: entry.value,
  };

  /// Reject the entire write before pruning, including links already on disk.
  void _validateOutput(PresetOutput output) {
    final owned = spec.ownedTemplateDirectory;
    if (owned != null) {
      _validateRelativeOutput(owned);
      if (!owned.startsWith('templates/')) {
        throw FormatException(
          'Partial ownership must be below templates/: $owned',
        );
      }
    }
    for (final path in _writableFiles(output).keys) {
      _validateRelativeOutput(path);
      if (owned != null && !path.startsWith('$owned/')) {
        throw FormatException('Output escapes owned subtree $owned: $path');
      }
      _rejectOutputLinks(path);
    }
    // Validate even when the derived output is empty.
    _rejectOutputLinks(owned ?? '.');
    _outputFiles();
    if (owned != null) {
      final registry = output.files['registry.yaml'];
      if (registry == null)
        throw const FormatException('Missing derived registry metadata.');
      _validateDefaultSeam(registry);
    }
  }

  void _validateRelativeOutput(String path) {
    if (path.isEmpty ||
        path == '.' ||
        path.contains('\\') ||
        p.posix.isAbsolute(path) ||
        p.windows.isAbsolute(path) ||
        p.posix.normalize(path) != path ||
        p.posix.split(path).contains('..')) {
      throw FormatException('Unsafe output path: $path');
    }
  }

  void _rejectOutputLinks(String relative) {
    var current = outputRoot.path;
    for (final segment in ['', ...p.posix.split(relative)]) {
      if (segment.isNotEmpty) current = p.join(current, segment);
      if (FileSystemEntity.typeSync(current, followLinks: false) ==
          FileSystemEntityType.link) {
        throw FormatException('Output path contains a symbolic link: $current');
      }
    }
  }

  YamlMap _registryItems(String source) {
    final document = loadYaml(source);
    if (document is! YamlMap || document['items'] is! YamlMap) {
      throw const FormatException('Registry must contain an items map.');
    }
    return document['items'] as YamlMap;
  }

  YamlMap _defaultItems() {
    final root = spec.name == 'default' ? defaultRegistryRoot : outputRoot;
    return _registryItems(
      File(p.join(root.path, 'registry.yaml')).readAsStringSync(),
    );
  }

  bool _ownsItem(Object? item) {
    if (item is! Map || item['files'] is! List) return false;
    final files = item['files'] as List;
    return files.isNotEmpty &&
        files.every(
          (file) =>
              file is Map &&
              file['source'] is String &&
              (file['source'] as String).startsWith(
                '${spec.ownedTemplateDirectory}/',
              ),
        );
  }

  /// Reuse the shipped validator for dependency cycles and target collisions.
  /// Existing items with a colliding name must already belong to this subtree.
  void _validateDefaultSeam(String registry) {
    final actual = _defaultItems();
    final derived = _registryItems(registry);
    for (final name in derived.keys) {
      if (actual.containsKey(name) && !_ownsItem(actual[name])) {
        throw FormatException(
          'Derived item $name collides with an existing default item.',
        );
      }
    }
    RegistryCatalog.parse(
      jsonEncode({
        'schema': 1,
        'items': {...actual, ...derived},
      }),
      preset: spec.name,
      rootUri: defaultRegistryRoot.uri,
    );
  }

  List<String> _metadataDrift(PresetOutput output) {
    if (spec.ownedTemplateDirectory == null) return [];
    final actual = _defaultItems();
    final derived = _registryItems(output.files['registry.yaml']!);
    return [
      for (final name in derived.keys)
        if (!actual.containsKey(name))
          'missing registry item $name'
        else if (!_sameYaml(actual[name], derived[name]))
          'changed registry item $name',
      for (final entry in actual.entries)
        if (_ownsItem(entry.value) && !derived.containsKey(entry.key))
          'stale registry item ${entry.key}',
    ];
  }

  Map<String, String> _readSources() {
    final files =
        sourceRoot
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where(
              (file) =>
                  file.path.endsWith('.dart') && !file.path.endsWith('.g.dart'),
            )
            .toList()
          ..sort((left, right) => left.path.compareTo(right.path));
    return {
      for (final file in files)
        _relative(file, sourceRoot): file.readAsStringSync(),
    };
  }

  void _validateSources(Map<String, String> sources) {
    final failures = <String>[];
    for (final entry in sources.entries) {
      final path = entry.key;
      final content = entry.value;
      if (p.posix
          .split(path)
          .any((segment) => segment.toLowerCase().contains(spec.valueWord))) {
        failures.add('$path: a path segment contains "${spec.valueWord}"');
      }
      if (content.contains('{{')) {
        failures.add('$path: source contains the reserved template token "{{"');
      }
      for (final match in _directivePattern.allMatches(content)) {
        final uri = match.group(2)!;
        if (uri.contains(spec.typeWord) || uri.contains(spec.valueWord)) {
          failures.add('$path: directive URI would be rewritten: $uri');
        }
        if (!uri.startsWith('package:') && !uri.startsWith('dart:')) {
          final resolved = p.posix.normalize(
            p.posix.join(p.posix.dirname(path), uri),
          );
          final generated = match.group(1) == 'part' && uri.endsWith('.g.dart');
          if (!generated && !sources.containsKey(resolved)) {
            failures.add('$path: missing relative source $uri');
          }
        }
        if (spec.forbiddenImportPrefixes.any(uri.startsWith)) {
          failures.add('$path: forbidden installed-source import $uri');
        }
      }
      if (!spec.ignoredSourceFiles.contains(path) &&
          !spec.sourceDirectories.any(
            (directory) => path.startsWith('$directory/'),
          )) {
        failures.add('$path: unsupported ${spec.name} source placement');
      }
    }
    if (failures.isNotEmpty) {
      failures.sort();
      throw FormatException(
        'Cannot derive the ${spec.name} preset:\n'
        '${failures.map((failure) => '  - $failure').join('\n')}',
      );
    }
  }

  Map<String, String> _readDefaultFloors() {
    final registry = File(p.join(defaultRegistryRoot.path, 'registry.yaml'));
    if (!registry.existsSync()) {
      throw FormatException('Default registry is missing: ${registry.path}');
    }
    final document = loadYaml(registry.readAsStringSync());
    if (document is! YamlMap || document['items'] is! YamlMap) {
      throw FormatException('${registry.path} is not a registry map.');
    }
    final constraints = <String, Set<String>>{};
    for (final item in (document['items'] as YamlMap).values) {
      if (item is! YamlMap) continue;
      for (final sectionName in const ['dependencies', 'devDependencies']) {
        final section = item[sectionName];
        if (section is! YamlMap) continue;
        for (final entry in section.entries) {
          if (entry.key is String && entry.value is String) {
            constraints
                .putIfAbsent(entry.key as String, () => <String>{})
                .add(entry.value as String);
          }
        }
      }
    }

    final floors = <String, String>{};
    for (final package in spec.floorPackages) {
      final values = constraints[package];
      if (values == null || values.length != 1) {
        throw FormatException(
          'Default registry must declare one $package constraint; found '
          '${values?.join(', ') ?? 'none'}.',
        );
      }
      floors[package] = values.single;
    }
    return floors;
  }

  /// Swaps the preset's own naming for the consumer prefix placeholders.
  ///
  /// The round trip is asserted rather than assumed: a substitution that does
  /// not reverse exactly means the source says the preset's name somewhere the
  /// consumer's prefix does not belong.
  String _templateFor(String path, String source) {
    final template = source
        .replaceAll(spec.typeWord, '{{typePrefix}}')
        .replaceAll(spec.valueWord, '{{valuePrefix}}');
    final roundTrip = template
        .replaceAll('{{typePrefix}}', spec.typeWord)
        .replaceAll('{{valuePrefix}}', spec.valueWord);
    if (roundTrip != source) {
      throw StateError('$path did not survive the template round trip.');
    }
    return template;
  }

  /// Infers one item's registry dependencies from its relative imports.
  List<String> _registryDependencies({
    required String sourcePath,
    required List<String> imports,
    required Set<String> componentNames,
  }) {
    final owners = spec.itemsByDirectory;
    final dependencies = <String>{};
    for (final uri in imports) {
      if (uri.startsWith('package:') || uri.startsWith('dart:')) continue;
      final resolved = p.posix.normalize(
        p.posix.join(p.posix.dirname(sourcePath), uri),
      );
      final directory = p.posix.split(resolved).first;
      final owner = owners[directory];
      if (owner != null) {
        if (owner == owners[p.posix.split(sourcePath).first]) continue;
        dependencies.add(owner);
        continue;
      }
      if (directory != spec.componentDirectory) continue;
      final component = p.posix.basenameWithoutExtension(resolved);
      if (component == p.posix.basenameWithoutExtension(sourcePath)) continue;
      if (!componentNames.contains(component)) {
        throw FormatException(
          '$sourcePath imports missing component source $uri.',
        );
      }
      dependencies.add(component);
    }
    final name = p.posix.basenameWithoutExtension(sourcePath);
    for (final component
        in spec.composedRegistryDependencies[name] ?? const []) {
      if (!componentNames.contains(component)) {
        throw FormatException(
          '$sourcePath declares missing component dependency $component.',
        );
      }
      dependencies.add(component);
    }
    // Shared items lead, in spec order, so a graph reads foundation-first the
    // way the hand-authored default registry does.
    return [
      for (final shared in spec.sharedItems)
        if (dependencies.remove(shared.name)) shared.name,
      ...dependencies.toList()..sort(),
    ];
  }

  /// Renders `registry.yaml`: shared items, then copied, then components.
  String _renderRegistry(Map<String, _RegistryItemDraft> items) {
    final leading = [
      for (final shared in spec.sharedItems) shared.name,
      for (final copied in spec.copiedItems) copied.name,
    ];
    final ordered = <_RegistryItemDraft>[
      for (final name in leading) items[name]!,
      ...items.entries
          .where((entry) => !leading.contains(entry.key))
          .map((entry) => entry.value)
          .toList()
        ..sort((left, right) => left.name.compareTo(right.name)),
    ];
    final buffer = StringBuffer()
      ..writeln('# Generated by tool/build_fortal_preset.dart. Do not edit.')
      ..writeln('schema: 1')
      ..writeln('items:');
    for (final item in ordered) {
      buffer.writeln('  ${item.name}:');
      _writeStringList(
        buffer,
        'registryDependencies',
        item.registryDependencies,
      );
      _writeConstraintMap(buffer, 'dependencies', item.dependencies);
      _writeConstraintMap(buffer, 'devDependencies', item.devDependencies);
      buffer.writeln('    files:');
      for (final file in item.files) {
        buffer
          ..writeln('      - source: ${file.source}')
          ..writeln('        target: "${file.target}"');
      }
      _writeStringList(buffer, 'generated', item.generated, quote: true);
      _writeStringList(buffer, 'exports', item.exports);
      buffer.writeln();
    }
    return '${buffer.toString().trimRight()}\n';
  }

  List<File> _outputFiles() {
    final owned = spec.ownedTemplateDirectory;
    final root = owned == null
        ? outputRoot
        : Directory(p.join(outputRoot.path, owned));
    _rejectOutputLinks(owned ?? '.');
    if (!root.existsSync()) return const [];
    final entries = root.listSync(recursive: true, followLinks: false);
    for (final link in entries.whereType<Link>()) {
      throw FormatException(
        'Owned output contains a symbolic link: ${link.path}',
      );
    }
    return entries.whereType<File>().toList()
      ..sort((left, right) => left.path.compareTo(right.path));
  }
}

final class _RegistryItemDraft {
  const _RegistryItemDraft({
    required this.name,
    this.registryDependencies = const [],
    this.dependencies = const {},
    this.devDependencies = const {},
    required this.files,
    this.generated = const [],
    required this.exports,
  });

  final String name;
  final List<String> registryDependencies;
  final Map<String, String> dependencies;
  final Map<String, String> devDependencies;
  final List<_RegistryFileDraft> files;
  final List<String> generated;
  final List<String> exports;
}

final class _RegistryFileDraft {
  const _RegistryFileDraft({required this.source, required this.target});

  final String source;
  final String target;
}

List<String> _imports(String source) => [
  for (final match in _importPattern.allMatches(source)) match.group(1)!,
];

String? _generatedPart(String source) {
  final matches = RegExp(
    r'''^\s*part\s+['"]([^'"]+\.g\.dart)['"]\s*;''',
    multiLine: true,
  ).allMatches(source).toList();
  if (matches.length > 1) {
    throw const FormatException(
      'A component declares multiple generated parts.',
    );
  }
  return matches.singleOrNull?.group(1);
}

void _writeStringList(
  StringBuffer buffer,
  String name,
  List<String> values, {
  bool quote = false,
}) {
  if (values.isEmpty) return;
  buffer.writeln('    $name:');
  for (final value in values) {
    buffer.writeln('      - ${quote ? '"$value"' : value}');
  }
}

void _writeConstraintMap(
  StringBuffer buffer,
  String name,
  Map<String, String> values,
) {
  if (values.isEmpty) return;
  buffer.writeln('    $name:');
  for (final key in values.keys.toList()..sort()) {
    buffer.writeln('      $key: ${values[key]}');
  }
}

Map<String, String> _sortedMap(Map<String, String> source) {
  final keys = source.keys.toList()..sort();
  return {for (final key in keys) key: source[key]!};
}

String _relative(File file, Directory root) =>
    p.posix.joinAll(p.split(p.relative(file.path, from: root.path)));

final _importPattern = RegExp(
  r'''^\s*import\s+['"]([^'"]+)['"]''',
  multiLine: true,
);

bool _sameYaml(Object? left, Object? right) {
  if (left is Map && right is Map) {
    return left.length == right.length &&
        left.keys.every(
          (key) => right.containsKey(key) && _sameYaml(left[key], right[key]),
        );
  }
  if (left is List && right is List) {
    return left.length == right.length &&
        List.generate(
          left.length,
          (index) => index,
        ).every((index) => _sameYaml(left[index], right[index]));
  }
  return left == right;
}

final _directivePattern = RegExp(
  r'''^\s*(import|export|part)\s+['"]([^'"]+)['"]''',
  multiLine: true,
);
