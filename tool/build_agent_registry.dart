import 'dart:io';

import 'build_fortal_preset.dart';

/// Agent behavior source joins the existing default catalog, not a new preset.
const agentRegistry = PresetSpec(
  name: 'default',
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
      // The source imports Remix primitives, not the installed theme, but the
      // existing theme item is the sole owner of the default Remix floor.
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

/// Synchronize only Agent's owned templates; assert hand-authored metadata.
void main(List<String> arguments) {
  if (arguments.isNotEmpty &&
      (arguments.length != 1 || arguments.single != '--check')) {
    stderr.writeln('Usage: dart run tool/build_agent_registry.dart [--check]');
    exitCode = 64;
    return;
  }
  final root = Directory.current.absolute;
  if (!File('${root.path}/packages/remix_agent/pubspec.yaml').existsSync()) {
    stderr.writeln('Run this tool from the Remix workspace root.');
    exitCode = 64;
    return;
  }
  try {
    final builder = PresetBuilder.forRepository(root, spec: agentRegistry);
    final output = builder.derive();
    if (arguments.isEmpty) builder.write(output);
    final drift = builder.drift(output);
    if (drift.isNotEmpty) {
      stderr
        ..writeln('The committed Agent registry is stale:')
        ..writeln(drift.map((entry) => '  - $entry').join('\n'))
        ..writeln(
          'Run `dart run tool/build_agent_registry.dart` for templates; '
          'update the owned registry.yaml entries to match derived metadata.',
        );
      exitCode = 1;
      return;
    }
    stdout.writeln('The committed Agent registry matches authored source.');
  } on Object catch (error) {
    stderr.writeln(error);
    exitCode = 1;
  }
}
