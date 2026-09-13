import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

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
    final output = builder.derive();
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
  });

  /// Preset name, and the directory it occupies under the bundled registry.
  final String name;

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
  });

  final String name;

  /// Source directory, also the installed target directory under `@ui/`.
  final String directory;

  /// Source path that must exist, or the preset is not derivable.
  final String requiredFile;

  final Set<String> packages;
  final List<String> exports;
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

/// A deterministic snapshot of every file owned by one derived preset.
final class PresetOutput {
  const PresetOutput({required this.files, required this.sourceByTemplate});

  /// Output paths relative to the preset root, including `registry.yaml`.
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
    );
  }

  final PresetSpec spec;
  final Directory sourceRoot;
  final Directory defaultRegistryRoot;
  final Directory outputRoot;

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
        final templatePath = 'templates/${shared.directory}/$name.tmpl';
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
        dependencies: {
          for (final package in shared.packages) package: floors[package]!,
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

    final componentPrefix = '${spec.componentDirectory}/';
    final componentNames = {
      for (final path in sources.keys)
        if (path.startsWith(componentPrefix))
          p.posix.basenameWithoutExtension(path),
    };
    for (final entry in sources.entries.where(
      (entry) => entry.key.startsWith(componentPrefix),
    )) {
      final name = p.posix.basenameWithoutExtension(entry.key);
      final templatePath = 'templates/$name/$name.dart.tmpl';
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

    final expected =
        componentNames.length +
        spec.sharedItems.length +
        spec.copiedItems.length;
    if (items.length != expected) {
      throw StateError('${spec.name} registry item names collided.');
    }

    output['registry.yaml'] = _renderRegistry(items);
    return PresetOutput(
      files: Map.unmodifiable(_sortedMap(output)),
      sourceByTemplate: Map.unmodifiable(_sortedMap(sourceByTemplate)),
    );
  }

  /// Synchronizes only the files owned beneath [outputRoot].
  void write(PresetOutput output) {
    outputRoot.createSync(recursive: true);
    final expected = output.files.keys.toSet();
    for (final file in _outputFiles()) {
      final relative = _relative(file, outputRoot);
      if (!expected.contains(relative)) file.deleteSync();
    }
    for (final entry in output.files.entries) {
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
    final differences = <String>[];
    final actual = {
      for (final file in _outputFiles()) _relative(file, outputRoot): file,
    };
    for (final entry in output.files.entries) {
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
      for (final match in _importPattern.allMatches(content)) {
        final uri = match.group(1)!;
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
    if (!outputRoot.existsSync()) return const [];
    final files =
        outputRoot
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .toList()
          ..sort((left, right) => left.path.compareTo(right.path));
    return files;
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
