import 'dart:convert';
import 'dart:io';

import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/token.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import '../packages/remix_cli/lib/src/directive_sort.dart';
import '../packages/remix_cli/lib/src/icon_registry.dart';
import '../packages/remix_cli/lib/src/registry.dart';
import '../packages/remix_cli/lib/src/template_renderer.dart';

/// Derives the remote registry presets from analyzer-checked Dart source.
///
/// Run without arguments to synchronize every committed preset. Pass `--check`
/// to compare in memory and fail on drift without writing, and `--preset` to
/// narrow the run to one preset.
void main(List<String> arguments) {
  final usage =
      'Usage: dart run tool/build_registry.dart '
      '[--preset ${presetSpecs.keys.join('|')}|all] [--check]';
  final check = arguments.contains('--check');
  final rest = arguments.where((argument) => argument != '--check').toList();
  var preset = 'all';
  if (rest.isNotEmpty) {
    if (rest.first != '--preset' || rest.length != 2) {
      stderr.writeln(usage);
      exitCode = 64;
      return;
    }
    preset = rest[1];
  }
  if (preset != 'all' && !presetSpecs.containsKey(preset)) {
    stderr.writeln(usage);
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

  final index = File(p.join(repositoryRoot.path, 'registry', 'index.yaml'));
  final indexSource =
      'schema: 1\npresets:\n${presetSpecs.keys.map((name) => '  $name: $name/registry.yaml\n').join()}';
  if (check) {
    if (!index.existsSync() || index.readAsStringSync() != indexSource) {
      stderr.writeln(
        'Registry index is stale. Run dart run tool/build_registry.dart.',
      );
      exitCode = 1;
      return;
    }
  } else {
    index.parent.createSync(recursive: true);
    index.writeAsStringSync(indexSource);
  }
  if (check) {
    final distribution = index.parent;
    // The choice tables are shared by every preset and are read by the CLI
    // alongside the generated catalogs.
    final expected = {'index.yaml', 'icons.yaml', ...presetSpecs.keys};
    final unexpected = distribution
        .listSync()
        .map((entry) => p.basename(entry.path))
        .where((name) => !expected.contains(name))
        .toList();
    if (unexpected.isNotEmpty) {
      stderr.writeln(
        'Unexpected registry distribution entries: ${unexpected.join(', ')}',
      );
      exitCode = 1;
      return;
    }
  }
  final selected = preset == 'all' ? presetSpecs.keys : [preset];
  for (final name in selected) {
    if (!_runPreset(repositoryRoot, name, check: check)) {
      exitCode = 1;
      return;
    }
  }
}

/// Derives one preset and either writes or verifies its committed output.
bool _runPreset(Directory repositoryRoot, String name, {required bool check}) {
  try {
    final builder = PresetBuilder.forRepository(
      repositoryRoot,
      spec: presetSpecs[name]!,
    );
    final output = builder.derive();
    if (!check) {
      builder.write(output);
      stdout.writeln(
        'Wrote the $name preset: ${output.files.length - 1} templates and '
        'registry.yaml.',
      );
      return true;
    }

    final drift = builder.drift(output);
    if (drift.isNotEmpty) {
      stderr
        ..writeln('The committed $name preset is stale:')
        ..writeln(drift.map((entry) => '  - $entry').join('\n'))
        ..writeln(
          'Run `dart run tool/build_registry.dart --preset $name` and commit '
          'the result.',
        );
      return false;
    }
    stdout.writeln('The committed $name preset matches authored source.');
    return true;
  } on Object catch (error) {
    stderr.writeln(error);
    return false;
  }
}

/// One derivable source package, and everything that distinguishes it.
///
/// The builder below turns analyzer-checked Dart source into a remote
/// registry tree. It does not know which package it is reading, what word
/// stands in for the consumer's prefix, or which items exist outside the
/// component directory. Those live here, so a second source package is a new
/// [PresetSpec] rather than a second copy of the builder.
final class PresetSpec {
  const PresetSpec({
    required this.name,
    required this.sourceRoot,
    required this.sourcePackage,
    required this.typeWord,
    required this.valueWord,
    required this.componentDirectory,
    required this.sharedItems,
    this.fileItems = const [],
    required this.ignoredSourceFiles,
    required this.floorPackages,
    required this.detectedPackages,
    required this.composedRegistryDependencies,
    this.recipeItems = const [],
    this.groupedRecipeItems = const [],
    this.fixedFileNames = const {},
  });

  /// Preset name, and the directory it occupies under the remote registry.
  final String name;

  /// Repository-relative directory of the authored source, e.g.
  /// `registry_source/lib/src/fortal`. Everything under it derives.
  final String sourceRoot;

  /// Name of the package [sourceRoot] belongs to.
  ///
  /// Installed source may never import it: an item ships the source itself.
  final String sourcePackage;

  /// Identifier casing replaced by `{{typePrefix}}`, e.g. `Fortal`.
  final String typeWord;

  /// Lowercase casing replaced by `{{valuePrefix}}`, e.g. `fortal`.
  final String valueWord;

  /// Stable data filenames are not identifiers and never take a UI prefix.
  final Set<String> fixedFileNames;

  /// Source directory holding one file per component item.
  final String componentDirectory;

  /// Items assembled from a source directory that components may import.
  final List<SharedItemSpec> sharedItems;

  /// Items derived from one authored file at the source root.
  final List<FileItemSpec> fileItems;

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

  /// Items derived from `recipes/<name>.dart`: preset-specific stylings of a
  /// published library, composed from this preset's own components and theme.
  final List<String> recipeItems;

  /// Multi-file recipe items assembled from explicitly mapped authored files.
  ///
  /// Sources are relative to [sourceRoot] and may name a sibling source tree.
  /// Targets and exports are relative to the installed `@ui/` directory.
  final List<GroupedRecipeItemSpec> groupedRecipeItems;

  /// Source directories this preset reads, shared items first.
  List<String> get sourceDirectories => [
    for (final item in sharedItems) item.directory,
    componentDirectory,
    if (recipeItems.isNotEmpty) recipeDirectory,
  ];

  static const recipeDirectory = 'recipes';

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

/// One registry item composed from multiple authored recipe sources.
final class GroupedRecipeItemSpec {
  const GroupedRecipeItemSpec({
    required this.name,
    required this.files,
    required this.exports,
    this.registryDependencies = const [],
    this.packages = const {},
  });

  final String name;
  final List<GroupedRecipeFileSpec> files;
  final List<String> exports;

  /// Dependencies used through composition callbacks rather than imports.
  final List<String> registryDependencies;

  /// Direct package floors not discoverable through [PresetSpec.detectedPackages].
  final Set<String> packages;
}

/// One authored source and its installed path within a grouped recipe item.
final class GroupedRecipeFileSpec {
  const GroupedRecipeFileSpec({
    required this.source,
    required this.target,
    this.sourceTypeWord,
    this.sourceValueWord,
  }) : assert((sourceTypeWord == null) == (sourceValueWord == null));

  /// Path relative to the preset's [PresetSpec.sourceRoot].
  final String source;

  /// Installed path relative to `@ui/`.
  final String target;

  /// Optional authoring prefixes for preset-neutral shared source.
  ///
  /// The pair is first rewritten to the preset prefix, then converted to the
  /// consumer placeholders by the normal template round trip.
  final String? sourceTypeWord;
  final String? sourceValueWord;
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

/// An item derived from a single file at the source root, e.g. `icons.dart`.
final class FileItemSpec {
  const FileItemSpec({
    required this.name,
    required this.file,
    required this.packages,
    required this.registryDependencies,
    required this.exports,
  });

  final String name;

  /// Source path relative to `lib/src`, also the installed path under `@ui/`.
  final String file;

  final Set<String> packages;
  final List<String> registryDependencies;
  final List<String> exports;
}

/// The Agent recipes each preset ships: one per widget of
/// `package:remix/agent.dart`, plus the glyph set that draws their icons.
/// Dependencies are inferred from each recipe's imports.
const agentRecipes = [
  'agent_glyphs_recipe',
  'answer_recipe',
  'composer_recipe',
  'conversation_recipe',
  'message_recipe',
  'sources_recipe',
  'steps_recipe',
  'suggestions_recipe',
  'tool_call_recipe',
];

/// The default preset as application-owned registry source.
///
/// `Vanilla` is the authoring word: it stands in for the consumer prefix where
/// it begins an identifier segment or a quoted id, and stays as written where
/// prose names the design system.
const defaultPreset = PresetSpec(
  name: 'vanilla',
  sourceRoot: 'registry_source/lib/src/default',
  sourcePackage: 'registry_source',
  typeWord: 'Vanilla',
  valueWord: 'vanilla',
  componentDirectory: 'components',
  sharedItems: [
    SharedItemSpec(
      name: 'theme',
      directory: 'theme',
      requiredFile: 'theme/tokens.dart',
      packages: {'remix'},
      exports: [
        'theme/tokens.dart',
        'theme/theme_data.dart',
        'theme/theme_scope.dart',
        'theme/effects.dart',
      ],
    ),
  ],
  fileItems: [
    FileItemSpec(
      name: 'icons',
      file: 'icons.dart',
      packages: const {},
      registryDependencies: ['theme'],
      exports: ['icons.dart'],
    ),
  ],
  ignoredSourceFiles: {},
  floorPackages: {
    'remix',
    'mix_annotations',
    'build_runner',
    'mix_generator',
    'mix_chart',
    'remix_ui_fonts',
  },
  detectedPackages: ['mix_chart', 'remix_ui_fonts'],
  // A layout, not a styled component: `sidebar_layout` composes an installed
  // Sidebar through a `Widget`-typed field, so its source never imports
  // components/sidebar.dart and import inference alone would miss it.
  composedRegistryDependencies: {
    'sidebar_layout': ['sidebar'],
  },
  recipeItems: agentRecipes,
  groupedRecipeItems: [
    GroupedRecipeItemSpec(
      name: 'dashboard_shell',
      files: [
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_shell_base.dart',
          target: 'recipes/dashboard/dashboard_shell_base.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_shell.dart',
          target: 'recipes/dashboard/dashboard_shell.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
      ],
      exports: ['recipes/dashboard/dashboard_shell.dart'],
    ),
    GroupedRecipeItemSpec(
      name: 'dashboard_demo',
      registryDependencies: [
        'agent_glyphs_recipe',
        'answer_recipe',
        'composer_recipe',
        'conversation_recipe',
        'message_recipe',
        'sources_recipe',
        'steps_recipe',
        'suggestions_recipe',
        'tool_call_recipe',
      ],
      files: [
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_sample_data.dart',
          target: 'recipes/dashboard/dashboard_sample_data.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_overview_base.dart',
          target: 'recipes/dashboard/dashboard_overview_base.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_base.dart',
          target: 'recipes/dashboard/dashboard_demo_base.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_chat.dart',
          target: 'recipes/dashboard/dashboard_demo_chat.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_charts.dart',
          target: 'recipes/dashboard/dashboard_demo_charts.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_records.dart',
          target: 'recipes/dashboard/dashboard_demo_records.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_overview.dart',
          target: 'recipes/dashboard/dashboard_overview.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_text.dart',
          target: 'recipes/dashboard/dashboard_demo_text.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_records.dart',
          target: 'recipes/dashboard/dashboard_demo_records_page.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_settings.dart',
          target: 'recipes/dashboard/dashboard_demo_settings.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo.dart',
          target: 'recipes/dashboard/dashboard_demo.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
      ],
      // A sample application, not part of the kit: it stays out of the barrel
      // and apps import recipes/dashboard/dashboard_demo.dart directly.
      exports: [],
    ),
  ],
);

/// The Fortal design system as application-owned registry source.
const fortalPreset = PresetSpec(
  name: 'fortal',
  fixedFileNames: {'fortal_colors.dart'},
  sourceRoot: 'registry_source/lib/src/fortal',
  sourcePackage: 'registry_source',
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
  fileItems: [
    FileItemSpec(
      name: 'icons',
      file: 'icons.dart',
      packages: const {},
      registryDependencies: ['theme'],
      exports: ['icons.dart'],
    ),
  ],
  ignoredSourceFiles: {},
  floorPackages: {
    'remix',
    'mix_annotations',
    'build_runner',
    'mix_generator',
    'mix_chart',
  },
  detectedPackages: ['mix_chart'],
  composedRegistryDependencies: {
    'sidebar_layout': ['sidebar'],
  },
  recipeItems: agentRecipes,
  groupedRecipeItems: [
    GroupedRecipeItemSpec(
      name: 'dashboard_shell',
      files: [
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_shell_base.dart',
          target: 'recipes/dashboard/dashboard_shell_base.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_shell.dart',
          target: 'recipes/dashboard/dashboard_shell.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
      ],
      exports: ['recipes/dashboard/dashboard_shell.dart'],
    ),
    GroupedRecipeItemSpec(
      name: 'dashboard_demo',
      registryDependencies: [
        'agent_glyphs_recipe',
        'answer_recipe',
        'composer_recipe',
        'conversation_recipe',
        'message_recipe',
        'sources_recipe',
        'steps_recipe',
        'suggestions_recipe',
        'tool_call_recipe',
      ],
      files: [
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_chat.dart',
          target: 'recipes/dashboard/dashboard_demo_chat.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_charts.dart',
          target: 'recipes/dashboard/dashboard_demo_charts.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_ui.dart',
          target: 'recipes/dashboard/dashboard_demo_ui.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_text.dart',
          target: 'recipes/dashboard/dashboard_demo_text.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_typography.dart',
          target: 'recipes/dashboard/dashboard_demo_typography.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_theme.dart',
          target: 'recipes/dashboard/dashboard_demo_theme.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_theme_panel.dart',
          target: 'recipes/dashboard/dashboard_demo_theme_panel.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_artwork.dart',
          target: 'recipes/dashboard/dashboard_demo_artwork.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_data.dart',
          target: 'recipes/dashboard/dashboard_demo_data.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_widgets.dart',
          target: 'recipes/dashboard/dashboard_demo_widgets.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_page_header.dart',
          target: 'recipes/dashboard/dashboard_demo_page_header.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_overview.dart',
          target: 'recipes/dashboard/dashboard_overview.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_analytics.dart',
          target: 'recipes/dashboard/dashboard_demo_analytics.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_collection.dart',
          target: 'recipes/dashboard/dashboard_demo_collection.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_records.dart',
          target: 'recipes/dashboard/dashboard_demo_records_page.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_schedule.dart',
          target: 'recipes/dashboard/dashboard_demo_schedule.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_themes.dart',
          target: 'recipes/dashboard/dashboard_demo_themes.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_settings.dart',
          target: 'recipes/dashboard/dashboard_demo_settings.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo.dart',
          target: 'recipes/dashboard/dashboard_demo.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
      ],
      exports: [],
    ),
  ],
);

/// The HeroUI web design system: a theme and recipes over Remix components.
const herouiPreset = PresetSpec(
  name: 'heroui',
  sourceRoot: 'registry_source/lib/src/heroui',
  sourcePackage: 'registry_source',
  typeWord: 'HeroUi',
  valueWord: 'heroUi',
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
  fileItems: [
    FileItemSpec(
      name: 'icons',
      file: 'icons.dart',
      packages: const {},
      registryDependencies: ['theme'],
      exports: ['icons.dart'],
    ),
  ],
  ignoredSourceFiles: {},
  floorPackages: {
    'remix',
    'mix_annotations',
    'build_runner',
    'mix_generator',
    'mix_chart',
    'remix_ui_fonts',
  },
  detectedPackages: ['mix_chart', 'remix_ui_fonts'],
  // The dashboard items are extensions with no upstream HeroUI family; see
  // `extensions` in registry_source/reference/heroui_3_2_6/families.json.
  // As in the other presets, `sidebar_layout` composes a `Widget`-typed
  // sidebar, so import inference alone would miss the dependency.
  composedRegistryDependencies: {
    'sidebar_layout': ['sidebar'],
  },
  groupedRecipeItems: [
    GroupedRecipeItemSpec(
      name: 'dashboard_shell',
      files: [
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_shell_base.dart',
          target: 'recipes/dashboard/dashboard_shell_base.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_shell.dart',
          target: 'recipes/dashboard/dashboard_shell.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
      ],
      exports: ['recipes/dashboard/dashboard_shell.dart'],
    ),
    // The other presets' demo over the shared base: the same pages, data and
    // behavior, with HeroUI's components.
    GroupedRecipeItemSpec(
      name: 'dashboard_demo',
      registryDependencies: [
        'agent_glyphs_recipe',
        'answer_recipe',
        'composer_recipe',
        'conversation_recipe',
        'message_recipe',
        'sources_recipe',
        'steps_recipe',
        'suggestions_recipe',
        'tool_call_recipe',
      ],
      files: [
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_sample_data.dart',
          target: 'recipes/dashboard/dashboard_sample_data.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_overview_base.dart',
          target: 'recipes/dashboard/dashboard_overview_base.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_base.dart',
          target: 'recipes/dashboard/dashboard_demo_base.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_chat.dart',
          target: 'recipes/dashboard/dashboard_demo_chat.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_charts.dart',
          target: 'recipes/dashboard/dashboard_demo_charts.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: '../dashboard/dashboard_demo_records.dart',
          target: 'recipes/dashboard/dashboard_demo_records.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_overview.dart',
          target: 'recipes/dashboard/dashboard_overview.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_text.dart',
          target: 'recipes/dashboard/dashboard_demo_text.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_records.dart',
          target: 'recipes/dashboard/dashboard_demo_records_page.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo_settings.dart',
          target: 'recipes/dashboard/dashboard_demo_settings.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
        GroupedRecipeFileSpec(
          source: 'recipes/dashboard/dashboard_demo.dart',
          target: 'recipes/dashboard/dashboard_demo.dart',
          sourceTypeWord: 'Registry',
          sourceValueWord: 'registry',
        ),
      ],
      exports: [],
    ),
  ],
  // The Agent recipes style `package:remix/agent.dart` with HeroUI's own
  // buttons, disclosure, spinner and text area.
  recipeItems: agentRecipes,
);

const presetSpecs = {
  'vanilla': defaultPreset,
  'fortal': fortalPreset,
  'heroui': herouiPreset,
};

/// A deterministic snapshot of every file owned by one derived preset.
final class PresetOutput {
  const PresetOutput({required this.files, required this.sourceByTemplate});

  /// Catalog and template contents keyed by paths relative to the preset root.
  final Map<String, String> files;

  /// Original authored source keyed by its derived template output path.
  ///
  /// This makes the substitution round trip directly testable without
  /// exposing filesystem implementation details.
  final Map<String, String> sourceByTemplate;
}

/// Builds one remote registry tree from analyzer-checked Dart source.
final class PresetBuilder {
  const PresetBuilder({
    required this.spec,
    required this.sourceRoot,
    required this.defaultRegistryRoot,
    required this.outputRoot,
    this.iconPlaceholders = false,
    this.icons,
  });

  factory PresetBuilder.forRepository(
    Directory repositoryRoot, {
    PresetSpec spec = fortalPreset,
  }) {
    final registryRoot = Directory(p.join(repositoryRoot.path, 'registry'));
    final iconFile = File(p.join(registryRoot.path, 'icons.yaml'));
    return PresetBuilder(
      spec: spec,
      sourceRoot: Directory(
        p.joinAll([repositoryRoot.path, ...p.posix.split(spec.sourceRoot)]),
      ),
      defaultRegistryRoot: Directory(p.join(registryRoot.path, 'vanilla')),
      outputRoot: Directory(p.join(registryRoot.path, spec.name)),
      iconPlaceholders: true,
      icons: iconFile.existsSync()
          ? IconRegistry.parse(iconFile.readAsStringSync())
          : null,
    );
  }

  final PresetSpec spec;
  final Directory sourceRoot;
  final Directory defaultRegistryRoot;
  final Directory outputRoot;

  /// When set, icon references become `{{icon:…}}` placeholders. The
  /// repository build turns this on. Tests that derive a catalog into a
  /// temporary directory leave it off.
  final bool iconPlaceholders;
  final IconRegistry? icons;

  PresetOutput derive() {
    if (!sourceRoot.existsSync()) {
      throw FormatException(
        '${spec.name} source root is missing: ${sourceRoot.path}',
      );
    }

    final sources = _readSources();
    final groupedSources = _readGroupedSources(sources);
    final sourceOwners = _sourceOwners(sources);
    final installedTargets = _installedTargets(sourceOwners);
    final directives = {
      for (final entry in {...sources, ...groupedSources}.entries)
        entry.key: _readDirectiveUris(entry.key, entry.value),
    };
    _validateSources(
      sources,
      groupedSources: groupedSources,
      sourceOwners: sourceOwners,
      directives: directives,
    );

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
        registryDependencies: {
          ...shared.registryDependencies,
          for (final entry in sharedSources)
            ..._registryDependencies(
              sourcePath: entry.key,
              imports: directives[entry.key]!.dependencies,
              componentNames: componentNames,
              sourceOwners: sourceOwners,
              itemName: shared.name,
            ),
        }.toList(),
        dependencies: {
          for (final package in shared.packages) package: floors[package]!,
          for (final package in spec.detectedPackages)
            if (sharedSources.any(
              (entry) => directives[entry.key]!.dependencies.any(
                (uri) => uri.startsWith('package:$package/'),
              ),
            ))
              package: floors[package]!,
        },
        files: files,
        exports: shared.exports,
      );
    }

    for (final item in spec.fileItems) {
      final source = sources[item.file];
      if (source == null) {
        throw FormatException('${spec.name} source must contain ${item.file}.');
      }
      final name = p.posix.basename(item.file);
      final templatePath = 'templates/${item.name}/$name.tmpl';
      final imports = directives[item.file]!.dependencies;
      output[templatePath] = _templateFor(item.file, source);
      sourceByTemplate[templatePath] = source;
      items[item.name] = _RegistryItemDraft(
        name: item.name,
        registryDependencies: {
          ...item.registryDependencies,
          ..._registryDependencies(
            sourcePath: item.file,
            imports: imports,
            componentNames: componentNames,
            sourceOwners: sourceOwners,
            itemName: item.name,
          ),
        }.toList(),
        dependencies: {
          for (final package in item.packages) package: floors[package]!,
          for (final package in spec.detectedPackages)
            if (imports.any((uri) => uri.startsWith('package:$package/')))
              package: floors[package]!,
        },
        files: [
          _RegistryFileDraft(source: templatePath, target: '@ui/${item.file}'),
        ],
        exports: item.exports,
      );
    }

    for (final entry in sources.entries.where(
      (entry) => entry.key.startsWith(componentPrefix),
    )) {
      final name = p.posix.basenameWithoutExtension(entry.key);
      final templatePath = 'templates/$name/$name.dart.tmpl';
      final sourceDirectives = directives[entry.key]!;
      final generated = sourceDirectives.generatedPart;
      final imports = sourceDirectives.dependencies;
      final registryDependencies = _registryDependencies(
        sourcePath: entry.key,
        imports: imports,
        componentNames: componentNames,
        sourceOwners: sourceOwners,
        itemName: name,
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

    final recipePrefix = '${PresetSpec.recipeDirectory}/';
    final recipeSources = sources.keys.where(
      (path) => p.posix.dirname(path) == PresetSpec.recipeDirectory,
    );
    for (final path in recipeSources) {
      final name = p.posix.basenameWithoutExtension(path);
      if (!spec.recipeItems.contains(name)) {
        throw FormatException('$path is not a declared ${spec.name} recipe.');
      }
    }
    for (final name in spec.recipeItems) {
      final path = '$recipePrefix$name.dart';
      final authored = sources[path];
      if (authored == null) {
        throw FormatException('${spec.name} source must contain $path.');
      }
      final source = sortDirectives(path, authored);
      final imports = directives[path]!.dependencies;
      final templatePath = 'templates/$path.tmpl';
      output[templatePath] = _templateFor(path, source);
      sourceByTemplate[templatePath] = source;
      items[name] = _RegistryItemDraft(
        name: name,
        registryDependencies: _registryDependencies(
          sourcePath: path,
          imports: imports,
          componentNames: componentNames,
          sourceOwners: sourceOwners,
          itemName: name,
        ),
        dependencies: {
          for (final package in spec.detectedPackages)
            if (imports.any((uri) => uri.startsWith('package:$package/')))
              package: floors[package]!,
        },
        files: [_RegistryFileDraft(source: templatePath, target: '@ui/$path')],
        exports: [path],
      );
    }

    for (final item in spec.groupedRecipeItems) {
      final files = <_RegistryFileDraft>[];
      final registryDependencies = <String>{...item.registryDependencies};
      final importedPackages = <String>{};
      for (final file in item.files) {
        final sourcePath = p.posix.normalize(file.source);
        final authored = groupedSources[sourcePath]!;
        final sourceDirectives = directives[sourcePath]!;
        final imports = sourceDirectives.dependencies;
        final rewritten = _groupedRecipeSource(
          sourcePath: sourcePath,
          targetPath: file.target,
          authored: authored,
          directives: sourceDirectives.all,
          installedTargets: installedTargets,
          sourceTypeWord: file.sourceTypeWord,
          sourceValueWord: file.sourceValueWord,
        );
        final templatePath =
            'templates/${item.name}/'
            '${p.posix.basename(file.target)}.tmpl';
        if (output.containsKey(templatePath)) {
          throw StateError(
            '${spec.name} grouped recipe templates collide at $templatePath.',
          );
        }
        output[templatePath] = _templateFor(sourcePath, rewritten);
        sourceByTemplate[templatePath] = rewritten;
        files.add(
          _RegistryFileDraft(
            source: templatePath,
            target: '@ui/${file.target}',
          ),
        );
        registryDependencies.addAll(
          _registryDependencies(
            sourcePath: sourcePath,
            imports: imports,
            componentNames: componentNames,
            sourceOwners: sourceOwners,
            itemName: item.name,
          ),
        );
        for (final package in spec.detectedPackages) {
          if (imports.any((uri) => uri.startsWith('package:$package/'))) {
            importedPackages.add(package);
          }
        }
      }
      items[item.name] = _RegistryItemDraft(
        name: item.name,
        registryDependencies: _orderRegistryDependencies(registryDependencies),
        dependencies: {
          for (final package in {...item.packages, ...importedPackages})
            package: floors[package]!,
        },
        files: files,
        exports: item.exports,
      );
    }

    final expected =
        componentNames.length +
        spec.sharedItems.length +
        spec.fileItems.length +
        spec.recipeItems.length +
        spec.groupedRecipeItems.length;
    if (items.length != expected) {
      throw StateError('${spec.name} registry item names collided.');
    }

    output['registry.yaml'] = _renderRegistry(items);
    return PresetOutput(
      files: Map.unmodifiable(_sortedMap(output)),
      sourceByTemplate: Map.unmodifiable(_sortedMap(sourceByTemplate)),
    );
  }

  /// Synchronizes the whole tree beneath [outputRoot] to [output].
  void write(PresetOutput output) {
    _validateOutput(output);
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
    _validateOutput(output);
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

  /// Reject the entire write before pruning, including links already on disk.
  void _validateOutput(PresetOutput output) {
    final registry = output.files['registry.yaml'];
    if (registry == null) {
      throw const FormatException('Missing derived registry metadata.');
    }
    for (final path in output.files.keys) {
      _validateRelativeOutput(path);
      _rejectOutputLinks(path);
    }
    // Validate even when the derived output is empty.
    _rejectOutputLinks('.');
    _outputFiles();
    validate(output);
  }

  /// Holds a preset to the installer's contract: no dependency cycles
  /// or target collisions, and every relative directive resolves to a target
  /// installed by its own item or a transitive dependency.
  void validate(PresetOutput output) {
    final catalog = RegistryCatalog.parse(
      output.files['registry.yaml']!,
      preset: spec.name,
    );
    for (final item in catalog.items.values) {
      final targets = <String>{
        for (final dependency in catalog.resolve(item.name)) ...[
          for (final file in dependency.files) file.target,
          ...dependency.generated,
        ],
      };
      for (final file in item.files) {
        final template = output.files[file.source];
        if (template == null) {
          throw FormatException(
            '${item.name} is missing template ${file.source}.',
          );
        }
        final source = const TemplateRenderer().render(
          template,
          typePrefix: spec.typeWord,
          valuePrefix: spec.valueWord,
          icons: icons,
        );
        for (final directive in _readDirectiveUris(file.source, source).all) {
          final uri = directive.uri;
          if (!_isRelativeUri(uri)) continue;
          final resolved = p.posix.normalize(
            p.posix.join(p.posix.dirname(file.target), uri),
          );
          if (!targets.contains(resolved)) {
            throw FormatException(
              '${item.name} imports $uri, which is not in its '
              '${spec.name} install closure.',
            );
          }
        }
      }
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

  Map<String, String> _readGroupedSources(Map<String, String> sources) {
    final grouped = <String, String>{};
    final targets = <String>{};
    final itemNames = <String>{};
    final allowedRoot = sourceRoot.parent.absolute.path;
    for (final item in spec.groupedRecipeItems) {
      if (!itemNames.add(item.name)) {
        throw FormatException(
          '${spec.name} declares grouped recipe ${item.name} more than once.',
        );
      }
      if (item.files.isEmpty) {
        throw FormatException(
          '${spec.name} grouped recipe ${item.name} declares no files.',
        );
      }
      final itemTargets = <String>{};
      for (final file in item.files) {
        final sourcePath = p.posix.normalize(file.source);
        if (file.source.isEmpty ||
            file.source.contains('\\') ||
            p.posix.isAbsolute(file.source) ||
            p.windows.isAbsolute(file.source)) {
          throw FormatException(
            '${spec.name} grouped recipe ${item.name} has unsafe source '
            '${file.source}.',
          );
        }
        final target = file.target;
        if (target.isEmpty ||
            target.contains('\\') ||
            p.posix.isAbsolute(target) ||
            p.windows.isAbsolute(target) ||
            p.posix.normalize(target) != target ||
            p.posix.split(target).contains('..')) {
          throw FormatException(
            '${spec.name} grouped recipe ${item.name} has unsafe target '
            '$target.',
          );
        }
        if (!target.startsWith('${PresetSpec.recipeDirectory}/')) {
          throw FormatException(
            '${spec.name} grouped recipe ${item.name} must install beneath '
            '@ui/${PresetSpec.recipeDirectory}/: $target.',
          );
        }
        if (!targets.add(target)) {
          throw FormatException(
            '${spec.name} grouped recipe target $target has multiple writers.',
          );
        }
        itemTargets.add(target);

        final authored = File(
          p.joinAll([sourceRoot.path, ...p.posix.split(sourcePath)]),
        ).absolute;
        if (authored.path != allowedRoot &&
            !p.isWithin(allowedRoot, authored.path)) {
          throw FormatException(
            '${spec.name} grouped recipe source ${file.source} escapes '
            '${sourceRoot.parent.path}.',
          );
        }
        if (!authored.existsSync()) {
          throw FormatException(
            '${spec.name} grouped recipe source is missing: ${file.source}.',
          );
        }
        final content = authored.readAsStringSync();
        final existing = grouped[sourcePath];
        if (existing != null) {
          throw FormatException(
            '${spec.name} grouped recipe source ${file.source} has multiple '
            'owners.',
          );
        }
        final local = sources[sourcePath];
        if (local != null && local != content) {
          throw StateError('$sourcePath changed while deriving the registry.');
        }
        grouped[sourcePath] = content;
      }
      for (final export in item.exports) {
        if (!itemTargets.contains(export)) {
          throw FormatException(
            '${spec.name} grouped recipe ${item.name} exports unmapped target '
            '$export.',
          );
        }
      }
    }
    return grouped;
  }

  Map<String, String> _sourceOwners(Map<String, String> sources) {
    final owners = <String, String>{};
    void own(String source, String item) {
      final previous = owners[source];
      if (previous != null && previous != item) {
        throw FormatException(
          '${spec.name} source $source is owned by both $previous and $item.',
        );
      }
      owners[source] = item;
    }

    for (final shared in spec.sharedItems) {
      for (final source in sources.keys.where(
        (path) => path.startsWith('${shared.directory}/'),
      )) {
        own(source, shared.name);
      }
    }
    for (final item in spec.fileItems) {
      if (sources.containsKey(item.file)) own(item.file, item.name);
    }
    final componentPrefix = '${spec.componentDirectory}/';
    for (final source in sources.keys.where(
      (path) => path.startsWith(componentPrefix),
    )) {
      own(source, p.posix.basenameWithoutExtension(source));
    }
    for (final name in spec.recipeItems) {
      final source = '${PresetSpec.recipeDirectory}/$name.dart';
      if (sources.containsKey(source)) own(source, name);
    }
    for (final item in spec.groupedRecipeItems) {
      for (final file in item.files) {
        own(p.posix.normalize(file.source), item.name);
      }
    }
    return owners;
  }

  Map<String, String> _installedTargets(Map<String, String> sourceOwners) {
    final targets = {for (final source in sourceOwners.keys) source: source};
    for (final item in spec.groupedRecipeItems) {
      for (final file in item.files) {
        targets[p.posix.normalize(file.source)] = file.target;
      }
    }
    return targets;
  }

  void _validateSources(
    Map<String, String> sources, {
    required Map<String, String> groupedSources,
    required Map<String, String> sourceOwners,
    required Map<String, _SourceDirectives> directives,
  }) {
    final failures = <String>[];
    final allSources = {...sources, ...groupedSources};
    for (final entry in allSources.entries) {
      final path = entry.key;
      final content = entry.value;
      if (p.posix
          .split(path)
          .any(
            (segment) =>
                !spec.fixedFileNames.contains(segment) &&
                segment.toLowerCase().contains(spec.valueWord),
          )) {
        failures.add('$path: a path segment contains "${spec.valueWord}"');
      }
      if (content.contains('{{')) {
        failures.add('$path: source contains the reserved template token "{{"');
      }
      final groupedRecipe = groupedSources.containsKey(path);
      for (final directive in directives[path]!.all) {
        final uri = directive.uri;
        final variableUri = uri
            .split('/')
            .where((segment) => !spec.fixedFileNames.contains(segment))
            .join('/');
        if (variableUri.contains(spec.typeWord) ||
            variableUri.contains(spec.valueWord)) {
          failures.add('$path: directive URI would be rewritten: $uri');
        }
        if (_isRelativeUri(uri)) {
          final resolved = p.posix.normalize(
            p.posix.join(p.posix.dirname(path), uri),
          );
          if (!directive.isGeneratedPart &&
              !sourceOwners.containsKey(resolved)) {
            failures.add('$path: missing relative source $uri');
          }
        }
        if (spec.forbiddenImportPrefixes.any(uri.startsWith)) {
          failures.add('$path: forbidden installed-source import $uri');
        }
      }
      if (!groupedRecipe &&
          !spec.ignoredSourceFiles.contains(path) &&
          !spec.fileItems.any((item) => item.file == path) &&
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

  /// Rebase each mapped relative directive from authored to installed paths.
  ///
  /// Only the directive URI is replaced. Identical text in comments, strings,
  /// or identifiers remains untouched.
  String _groupedRecipeSource({
    required String sourcePath,
    required String targetPath,
    required String authored,
    required List<_DirectiveUri> directives,
    required Map<String, String> installedTargets,
    required String? sourceTypeWord,
    required String? sourceValueWord,
  }) {
    var rewritten = authored;
    for (final directive in directives.reversed) {
      final uri = directive.uri;
      if (!_isRelativeUri(uri) || directive.isGeneratedPart) continue;
      final resolved = p.posix.normalize(
        p.posix.join(p.posix.dirname(sourcePath), uri),
      );
      final installed = installedTargets[resolved];
      if (installed == null) continue;
      final rebased = p.posix.relative(
        installed,
        from: p.posix.dirname(targetPath),
      );
      if (rebased != uri) {
        rewritten = _replaceDirectiveUri(rewritten, directive.literal, rebased);
      }
    }
    if (sourceTypeWord != null && sourceValueWord != null) {
      rewritten = _replacePrefixWords(
        sourcePath,
        rewritten,
        typeWord: sourceTypeWord,
        valueWord: sourceValueWord,
        typeReplacement: spec.typeWord,
        valueReplacement: spec.valueWord,
      );
    }
    return sortDirectives(sourcePath, rewritten);
  }

  /// Swaps the preset's own naming for the consumer prefix placeholders.
  ///
  /// The round trip is asserted rather than assumed: a template that does not
  /// render back to its source under the preset's own words would install
  /// something other than the analyzed source.
  String _templateFor(String path, String source) {
    var template = _replacePrefixWords(
      path,
      source,
      typeWord: spec.typeWord,
      valueWord: spec.valueWord,
      typeReplacement: '{{typePrefix}}',
      valueReplacement: '{{valuePrefix}}',
      fixedFileNames: spec.fixedFileNames,
    );
    template = _iconTemplate(path, template);
    final roundTrip = const TemplateRenderer().render(
      template,
      typePrefix: spec.typeWord,
      valuePrefix: spec.valueWord,
      icons: icons,
    );
    if (roundTrip != source) {
      throw StateError('$path did not survive the template round trip.');
    }
    return template;
  }

  /// Replaces the authoring icon libraries with registry placeholders.
  ///
  /// Source is authored against the default library, plus the fallback
  /// library for each icon the default library does not draw. Every constant
  /// becomes its canonical `{{icon:name}}`, and those libraries' imports
  /// become one `{{icon:import}}`, so the same template renders for any
  /// library the table maps. [_templateFor]'s round trip proves that the
  /// default library renders back exactly these constants and imports.
  String _iconTemplate(String path, String source) {
    if (!iconPlaceholders) return source;
    final table = icons;
    if (table == null) {
      if (source.contains('remix_ui_icons')) {
        throw StateError('$path uses icons but no icon table was provided.');
      }
      return source;
    }
    final defaultLibrary = table.library(defaultIconLibrary);
    final authoring = [
      defaultIconLibrary,
      ...{
        for (final fallback in table.fallbacks.values)
          if (fallback != defaultIconLibrary) fallback,
      },
    ];
    var rewritten = source;
    for (final name in authoring) {
      final library = table.library(name);
      rewritten = rewritten.replaceAllMapped(
        RegExp('\\b${RegExp.escape(library.className)}\\.([A-Za-z0-9_]+)'),
        (match) {
          final canonical = table.canonicalFor(name, match[1]!);
          if (canonical != null) return iconToken(canonical);
          if (name == defaultIconLibrary) {
            throw StateError('$path uses unmapped ${match[0]}.');
          }
          throw StateError(
            '$path uses ${match[0]}, which icons.yaml does not name as the '
            '$name fallback of an icon ${defaultLibrary.className} lacks. Use '
            'the ${defaultLibrary.className} glyph, or add a fallback entry.',
          );
        },
      );
      if (rewritten.contains(library.className)) {
        throw StateError(
          '$path mentions bare ${library.className}; use a mapped glyph or '
          'an alias.',
        );
      }
    }
    // The installer swaps the import token for the imports the chosen
    // library needs, so a file with icon constants must carry that token
    // itself, and must not reach an icon package any other way (an alias or
    // an export), which no library switch could rewrite.
    var tokenized = false;
    for (final name in authoring) {
      final directive = "import '${table.library(name).import}';";
      if (!rewritten.contains(directive)) continue;
      rewritten = tokenized
          ? rewritten.replaceFirst('$directive\n', '')
          : rewritten.replaceFirst(directive, iconImportToken);
      tokenized = true;
    }
    for (final name in authoring) {
      final library = table.library(name);
      final package = library.dependencies.keys.single;
      if (rewritten.contains('package:$package/')) {
        throw StateError(
          "$path reaches $package other than by `import '${library.import}';`; "
          'import it exactly that way so the installer can swap the library.',
        );
      }
    }
    if (rewritten.contains('{{icon:') && !rewritten.contains(iconImportToken)) {
      throw StateError(
        "$path uses ${defaultLibrary.className} without `import "
        "'${defaultLibrary.import}';`; import it in this file so the "
        'installer can swap the library.',
      );
    }
    return rewritten;
  }

  /// Infers one item's registry dependencies from its relative imports.
  List<String> _registryDependencies({
    required String sourcePath,
    required Iterable<String> imports,
    required Set<String> componentNames,
    required Map<String, String> sourceOwners,
    required String itemName,
  }) {
    final dependencies = <String>{};
    for (final uri in imports) {
      if (!_isRelativeUri(uri)) continue;
      final resolved = p.posix.normalize(
        p.posix.join(p.posix.dirname(sourcePath), uri),
      );
      final owner = sourceOwners[resolved];
      if (owner != null && owner != itemName) dependencies.add(owner);
    }
    for (final component
        in spec.composedRegistryDependencies[itemName] ?? const []) {
      if (!componentNames.contains(component)) {
        throw FormatException(
          '$sourcePath declares missing component dependency $component.',
        );
      }
      dependencies.add(component);
    }
    return _orderRegistryDependencies(dependencies);
  }

  /// Shared items lead, in spec order, so a graph reads foundation-first the
  /// way the hand-authored default registry does.
  List<String> _orderRegistryDependencies(Iterable<String> dependencies) {
    final remaining = dependencies.toSet();
    return [
      for (final shared in spec.sharedItems)
        if (remaining.remove(shared.name)) shared.name,
      ...remaining.toList()..sort(),
    ];
  }

  /// Renders `registry.yaml`: shared and file items, then components.
  String _renderRegistry(Map<String, _RegistryItemDraft> items) {
    final leading = [
      for (final shared in spec.sharedItems) shared.name,
      for (final item in spec.fileItems) item.name,
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
      ..writeln('# Generated by tool/build_registry.dart. Do not edit.')
      ..writeln('schema: 2')
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
    _rejectOutputLinks('.');
    if (!outputRoot.existsSync()) return const [];
    final entries = outputRoot.listSync(recursive: true, followLinks: false);
    for (final link in entries.whereType<Link>()) {
      throw FormatException('Output contains a symbolic link: ${link.path}');
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

typedef _DirectiveUri = ({
  String uri,
  StringLiteral literal,
  bool isGeneratedPart,
});

final _uriLiteralSpecialCharacter = RegExp(r'''['"\\$\x00-\x1f]''');

String _replaceDirectiveUri(String source, StringLiteral literal, String uri) {
  if (literal is SimpleStringLiteral &&
      !_uriLiteralSpecialCharacter.hasMatch(uri)) {
    return source.replaceRange(
      literal.contentsOffset,
      literal.contentsEnd,
      uri,
    );
  }
  return source.replaceRange(
    literal.offset,
    literal.end,
    jsonEncode(uri).replaceAll(r'$', r'\$'),
  );
}

bool _isRelativeUri(String uri) =>
    !uri.startsWith('package:') && !uri.startsWith('dart:');

_SourceDirectives _readDirectiveUris(String path, String source) {
  _DirectiveUri read(StringLiteral literal, {required bool isPart}) {
    final uri = literal.stringValue;
    if (uri == null) {
      throw FormatException('$path: directive URIs cannot interpolate.');
    }
    return (
      uri: uri,
      literal: literal,
      isGeneratedPart: isPart && uri.endsWith('.g.dart'),
    );
  }

  return _SourceDirectives([
    for (final directive in _parseSource(path, source).directives)
      if (directive is UriBasedDirective) ...[
        read(directive.uri, isPart: directive is PartDirective),
        if (directive is NamespaceDirective)
          for (final configuration in directive.configurations)
            read(configuration.uri, isPart: false),
      ],
  ]);
}

class _SourceDirectives {
  _SourceDirectives(this.all);

  final List<_DirectiveUri> all;
  late final dependencies = [
    for (final directive in all)
      if (!directive.isGeneratedPart) directive.uri,
  ];

  late final String? generatedPart = _findGeneratedPart();

  String? _findGeneratedPart() {
    final parts = all.where((directive) => directive.isGeneratedPart);
    if (parts.length > 1) {
      throw const FormatException(
        'A component declares multiple generated parts.',
      );
    }
    return parts.singleOrNull?.uri;
  }
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

/// Substitutes prefixes at identifier segments followed by an uppercase letter
/// or digit. In text, it rewrites quoted IDs and references marked as code by
/// syntax, markup, or a matching same-file identifier; other prose is kept.
/// Bare code prefixes and ambiguous ID-like strings fail with `path:line`.
String _replacePrefixWords(
  String path,
  String source, {
  required String typeWord,
  required String valueWord,
  required String typeReplacement,
  required String valueReplacement,
  Set<String> fixedFileNames = const {},
}) {
  final prefixes = RegExp(
    '${RegExp.escape(typeWord)}|${RegExp.escape(valueWord)}',
  );
  final words = RegExp(
    [...fixedFileNames.map(RegExp.escape), r'[\w$]+'].join('|'),
  );
  final edits = <({int start, int end, String replacement})>[];
  final unit = _parseSource(path, source);
  final identifiers = <String>{};
  final comments = <Token>[];

  void replace(String word, int start) {
    edits.add((
      start: start,
      end: start + word.length,
      replacement: word == typeWord ? typeReplacement : valueReplacement,
    ));
  }

  Never refuse(String word, int start, String problem) {
    final line = unit.lineInfo.getLocation(start).lineNumber;
    throw StateError('$path:$line: "$word" $problem.');
  }

  Iterable<RegExpMatch> segments(String identifier) => prefixes
      .allMatches(identifier)
      .where(
        (match) =>
            match.start == 0 ||
            match[0] == typeWord ||
            '_\$'.contains(identifier[match.start - 1]),
      );

  void rewriteText(
    String text,
    int offset, {
    String? idShape,
    bool literal = false,
    bool interpolatesBefore = false,
    bool interpolatesAfter = false,
  }) {
    if (!prefixes.hasMatch(text)) return;
    final leading = prefixes.matchAsPrefix(text);
    if (leading != null &&
        idShape != null &&
        !fixedFileNames.contains(words.matchAsPrefix(text)?[0])) {
      final suffix = idShape.substring(leading.end);
      final valueId = leading[0] == valueWord;
      if ((_idSuffix.hasMatch(suffix) &&
              (valueId || !suffix.startsWith('-'))) ||
          (valueId &&
              leading.end < text.length &&
              _camelIdSuffix.hasMatch(suffix))) {
        replace(leading[0]!, offset);
        return;
      }
    }
    final markup = _codeMarkup.allMatches(text).toList();
    for (final candidate in words.allMatches(text)) {
      final identifier = candidate[0]!;
      if (fixedFileNames.contains(identifier)) continue;
      final code =
          identifiers.contains(identifier) ||
          _codePunctuation.matchAsPrefix(text, candidate.end) != null ||
          markup.any(
            (span) => span.start < candidate.start && candidate.end < span.end,
          );
      for (final match in segments(identifier)) {
        final word = match[0]!;
        final start = candidate.start + match.start;
        final end = candidate.start + match.end;
        if (_identifierSuffixStart.hasMatch(_charAt(identifier, match.end))) {
          if (code) replace(word, offset + start);
        } else if (literal &&
            !(word == typeWord && _charAt(text, end) == '-') &&
            ((start == 0 && interpolatesBefore) ||
                (end == text.length && interpolatesAfter) ||
                (start == 0 && end == text.length) ||
                (start > 0 && '.-_:'.contains(text[start - 1])) ||
                (end < text.length && '.-_:'.contains(text[end])))) {
          refuse(
            word,
            offset + start,
            'is a whole string or touches `.`, `-`, `_`, `:` or an '
            'interpolation inside a string; reword it, or start the '
            'string with it to make an id',
          );
        }
      }
    }
  }

  for (var token = unit.beginToken; ; token = token.next!) {
    if (token.isIdentifier && prefixes.hasMatch(token.lexeme)) {
      identifiers.add(token.lexeme);
      for (final match in segments(token.lexeme)) {
        final word = match[0]!;
        final start = token.offset + match.start;
        if (!_identifierSuffixStart.hasMatch(
          _charAt(token.lexeme, match.end),
        )) {
          refuse(
            word,
            start,
            'is code but does not start an identifier segment; make it an '
            'identifier prefix',
          );
        }
        replace(word, start);
      }
    }
    for (
      Token? comment = token.precedingComments;
      comment != null;
      comment = comment.next
    ) {
      comments.add(comment);
    }
    if (token.isEof) break;
  }
  // A comment can refer to identifiers declared later in the file.
  for (final comment in comments) {
    rewriteText(comment.lexeme, comment.offset);
  }
  unit.accept(
    _StringPieces((start, end, {idShape, before = false, after = false}) {
      rewriteText(
        source.substring(start, end),
        start,
        literal: true,
        idShape: idShape,
        interpolatesBefore: before,
        interpolatesAfter: after,
      );
    }),
  );

  final buffer = StringBuffer();
  var copied = 0;
  for (final edit
      in edits..sort((left, right) => left.start.compareTo(right.start))) {
    buffer
      ..write(source.substring(copied, edit.start))
      ..write(edit.replacement);
    copied = edit.end;
  }
  return (buffer..write(source.substring(copied))).toString();
}

class _StringPieces extends RecursiveAstVisitor<void> {
  _StringPieces(this.visitPiece);

  final void Function(
    int start,
    int end, {
    String? idShape,
    bool before,
    bool after,
  })
  visitPiece;

  @override
  void visitSimpleStringLiteral(SimpleStringLiteral node) {
    visitPiece(node.contentsOffset, node.contentsEnd, idShape: node.value);
  }

  @override
  void visitStringInterpolation(StringInterpolation node) {
    final elements = node.elements;
    final shape = elements
        .map((element) => element is InterpolationString ? element.value : '0')
        .join();
    for (final (index, element) in elements.indexed) {
      if (element is InterpolationString) {
        visitPiece(
          element.contentsOffset,
          element.contentsEnd,
          idShape: index == 0 ? shape : null,
          before: index > 0,
          after: index < elements.length - 1,
        );
      } else {
        element.accept(this);
      }
    }
  }
}

final _identifierSuffixStart = RegExp('[A-Z0-9]');
final _idSuffix = RegExp(r'^[-._][A-Za-z0-9]\S*$');
final _camelIdSuffix = RegExp(r'^[A-Z0-9][\w./:-]*$');
final _codePunctuation = RegExp(r'(?:\(|[.<][A-Za-z_$])');
final _codeMarkup = RegExp(r'`[^`\n]+`|\[[\w.$]+\]');

String _charAt(String source, int index) =>
    index >= 0 && index < source.length ? source[index] : '';

CompilationUnit _parseSource(String path, String source) {
  try {
    return parseString(content: source).unit;
  } on ArgumentError catch (error) {
    throw StateError('$path does not parse. ${error.message}');
  }
}
