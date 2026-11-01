/// Proves that the project-local CLI installs the open-code MVP into a fresh
/// Flutter application.
///
/// ```shell
/// dart run tool/check_open_code.dart [--preset vanilla|fortal|heroui]
///     [--source both|hosted|checkout]
///     [--item dashboard_demo|dashboard_shell|icons]
///     [--icon-library remix|lucide] [--hosted-cli] [--jobs N] [--keep]
/// ```
///
/// The checker writes only to a guarded system-temporary directory. It installs
/// this checkout's `remix_cli`, lets the CLI install every registry item, then
/// tests the installed source with the selected Remix source. The default runs
/// hosted Remix first, then regenerates against the checkout. CI selects the
/// checkout explicitly so a registry can be validated before its Remix version
/// is on pub.dev.
///
/// The independent-item installs run in parallel: `--jobs N` or
/// `REMIX_OPEN_CODE_JOBS=N` sets how many at once, and the default is one per
/// core, never fewer than two or more than four.
library;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:pub_semver/pub_semver.dart';
import 'package:yaml/yaml.dart';

import '../packages/remix_cli/lib/src/icon_registry.dart';
import 'compile_registry_consumer.dart';

const _fixtureAppFiles = <String>[
  'pubspec.yaml',
  'analysis_options.yaml',
  'lib/main.dart',
  'test/open_code_test.dart',
  'test/theme_modes_test.dart',
];

/// The registry items the CLI installs, in invocation order.
///
/// Each is added by its own `remix add` on purpose, even though one
/// invocation can now name several: installing them one at a time is what
/// exercises the incremental path a consumer actually takes, where each item
/// meets an application that already has the previous ones. Theme arrives as
/// the first item's registry dependency.
const _defaultRegistryItems = <String>[
  'icons',
  'accordion',
  'app_bar',
  'avatar',
  'badge',
  'button',
  'callout',
  'card',
  'chart',
  'dashboard_demo',
  'dashboard_shell',
  'checkbox',
  'data_list',
  'data_table',
  'dialog',
  'disclosure',
  'divider',
  'icon_button',
  'link',
  'menu',
  'popover',
  'progress',
  'radio',
  'segmented_control',
  'select',
  'sidebar',
  'sidebar_layout',
  'skeleton',
  'slider',
  'spinner',
  'switch',
  'tabs',
  'textfield',
  'toast',
  'toggle',
  'toggle_group',
  'tooltip',
  ..._agentRegistryItems,
];

const _agentComponentItems = <String>[
  'activity',
  'answer',
  'composer',
  'execution',
  'message',
  'permission',
  'plan',
  'transcript',
];

const _agentRecipeItems = <String>[
  'activity_recipe',
  'answer_recipe',
  'composer_recipe',
  'execution_recipe',
  'message_recipe',
  'permission_recipe',
  'plan_recipe',
  'transcript_recipe',
];

const _agentRegistryItems = <String>[
  ..._agentComponentItems,
  ..._agentRecipeItems,
];

const _independentRegistryItems = <String>[
  ..._agentRegistryItems,
  'dashboard_demo',
  'dashboard_shell',
];

const _foundationItems = <String>{'theme', 'models', 'support'};

/// Generated adapters compared byte-for-byte against a committed snapshot.
///
/// Representative shapes rather than every component: `button` is the
/// single-adapter case, `tabs` the multi-adapter one. These guard *generator*
/// drift, which is shape-wide; the fixture's behavior tests are the stronger
/// per-component guard.
///
/// The generator copies the recipe's doc comment into the adapter, so editing
/// prose in a template moves these bytes. A snapshot diff that is only
/// comments is expected and is refreshed, not investigated; a diff that
/// touches a constructor, a field, or a `build` body is the thing this is
/// here to catch.
const _generatedSnapshots = <String, String>{
  'lib/ui/components/button.g.dart': 'expected/acme_button.g.dart',
  'lib/ui/components/chart.g.dart': 'expected/acme_chart.g.dart',
  'lib/ui/components/tabs.g.dart': 'expected/acme_tabs.g.dart',
};

const _fortalRegistryItems = <String>[
  'icons',
  'accordion',
  'app_bar',
  'avatar',
  'badge',
  'base_button',
  'button',
  'callout',
  'card',
  'chart',
  'dashboard_demo',
  'dashboard_shell',
  'checkbox',
  'code',
  'data_list',
  'data_table',
  'dialog',
  'disclosure',
  'divider',
  'heading',
  'icon_button',
  'kbd',
  'link',
  'menu',
  'popover',
  'progress',
  'radio',
  'segmented_control',
  'select',
  'sidebar',
  'sidebar_layout',
  'skeleton',
  'slider',
  'spinner',
  'switch',
  'tabs',
  'text',
  'textfield',
  'toast',
  'toggle',
  'toggle_group',
  'tooltip',
  'typography',
  ..._agentRegistryItems,
];

const _defaultPreset = _PresetContract(
  name: 'vanilla',
  fixtureDirectory: 'fixture',
  registryItems: _defaultRegistryItems,
  // Vanilla's theme sets its type in Geist, so every install carries the fonts.
  requiredRuntimeDependencies: [..._baseRuntimeDependencies, 'remix_ui_fonts'],
  allowedImportPackages: [..._baseImportPackages, 'remix_ui_fonts'],
  generatedSnapshots: _generatedSnapshots,
);

const _fortalPreset = _PresetContract(
  name: 'fortal',
  fixtureDirectory: 'fortal_fixture',
  registryItems: _fortalRegistryItems,
);

const _herouiRegistryItems = [
  'accordion',
  'alert',
  'avatar',
  'avatar_group',
  'badge',
  'breadcrumbs',
  'button',
  'button_group',
  'card',
  'checkbox',
  'checkbox_group',
  'chip',
  'close_button',
  'disclosure',
  'dropdown',
  'field_layout',
  'input_group',
  'kbd',
  'link',
  'modal',
  'popover',
  'progress',
  'radio',
  'radio_group',
  'search_field',
  'select',
  'separator',
  'skeleton',
  'slider',
  'spinner',
  'surface',
  'switch',
  'switch_group',
  'table',
  'tabs',
  'textarea',
  'textfield',
  'toast',
  'toggle_button',
  'toggle_button_group',
  'tooltip',
  'typography',
];

const _herouiPreset = _PresetContract(
  name: 'heroui',
  fixtureDirectory: 'heroui_fixture',
  registryItems: _herouiRegistryItems,
  foundationItems: {'theme'},
  independentItems: null,
  specStylerItems: [],
  requiredRuntimeDependencies: [
    'remix',
    'mix_annotations',
    'remix_ui_fonts',
    'remix_ui_icons',
  ],
  allowedImportPackages: [
    'flutter',
    'remix',
    'mix_annotations',
    'remix_ui_fonts',
    'remix_ui_icons',
  ],
);

/// The hosted packages every preset's installed application declares. A preset
/// that ships more, as Vanilla ships its fonts, extends this in its own
/// [_PresetContract].
///
/// `remix_ui_icons` stands for the icon packages, which come from the
/// `icons.yaml` of the registry under test; see [iconPackagesFor].
const _baseRuntimeDependencies = <String>[
  'remix',
  'mix_annotations',
  'mix_chart',
  'remix_ui_icons',
];
const _requiredDevDependencies = <String>['build_runner', 'mix_generator'];
const _forbiddenDependencies = <String>['mix', 'naked_ui', 'registry_source'];

/// The packages installed source may import: Flutter and the runtime set.
const _baseImportPackages = <String>[
  'flutter',
  'remix',
  'mix_annotations',
  'mix_chart',
  'remix_ui_icons',
];

/// The `iconLibrary` values a fresh app may select.
const _iconLibraries = {'remix', 'lucide'};

/// The official registry the published CLI reads.
const _officialRepository = 'btwld/remix';
const _officialRegistryPath = 'registry';

/// The published ref a fresh app's CLI reads, or null for this checkout's
/// `registry/`.
///
/// Checkout validation compiles the checkout CLI against this tree's
/// `registry/`: the candidate registry. A hosted CLI, and the release smoke
/// that gates publishing a CLI (`REMIX_REGISTRY_RELEASE_SMOKE`), read the
/// promoted `registry-stable` the way an application does. The registry
/// workflow's smoke names a commit in `REMIX_REGISTRY_RELEASE_REF`. A
/// candidate and the stable registry can disagree on icon packages and
/// floors, because the candidate may need releases the stable one predates,
/// so the install contract follows whichever registry is under test.
String? publishedRegistryRef({
  required bool hostedCli,
  required Map<String, String> environment,
}) {
  if (hostedCli || environment['REMIX_REGISTRY_RELEASE_SMOKE'] == '1') {
    return 'registry-stable';
  }
  return environment['REMIX_REGISTRY_RELEASE_REF'];
}

/// The packages a full install of a registry adds for [iconLibrary]'s icons:
/// that library's package, and the package of every fallback library that
/// renders an icon [iconLibrary] does not draw. Schema 1 tables have no
/// fallbacks, so they add exactly one package.
List<String> iconPackagesFor(String iconsYaml, String iconLibrary) {
  final table = IconRegistry.parse(iconsYaml);
  final libraries = {
    iconLibrary,
    for (final canonical in table.icons.keys)
      table.resolve(canonical, iconLibrary).library,
  };
  return [
    for (final name in libraries) table.library(name).dependencies.keys.single,
  ];
}

/// Whether a checkout install resolves `remix_ui_icons` from this tree: only
/// when the registry under test floors it at a version the checkout package
/// satisfies. A candidate registry may require an unpublished release; the
/// stable registry's older floor resolves the published one.
bool iconsResolveFromCheckout(String iconsYaml, String checkoutVersion) {
  final constraint = IconRegistry.parse(
    iconsYaml,
  ).library(defaultIconLibrary).dependencies['remix_ui_icons'];
  return constraint != null &&
      constraint.allows(Version.parse(checkoutVersion));
}

String _packageVersion(Directory repositoryRoot, String package) =>
    (loadYaml(
              File(
                '${repositoryRoot.path}/packages/$package/pubspec.yaml',
              ).readAsStringSync(),
            )
            as YamlMap)['version']
        as String;

Future<String> _registryIcons(Directory repositoryRoot, String? ref) async {
  if (ref == null) {
    return File(
      '${repositoryRoot.path}/registry/icons.yaml',
    ).readAsStringSync();
  }
  final client = HttpClient();
  try {
    final uri = Uri.https(
      'raw.githubusercontent.com',
      '/$_officialRepository/$ref/$_officialRegistryPath/icons.yaml',
    );
    final response = await (await client.getUrl(uri)).close();
    final body = await response.transform(utf8.decoder).join();
    if (response.statusCode != 200) {
      throw HttpException('GET $uri returned ${response.statusCode}', uri: uri);
    }
    return body;
  } finally {
    client.close();
  }
}

final class _PresetContract {
  const _PresetContract({
    required this.name,
    required this.fixtureDirectory,
    required this.registryItems,
    this.generatedSnapshots = const {},
    this.requiredRuntimeDependencies = _baseRuntimeDependencies,
    this.allowedImportPackages = _baseImportPackages,
    this.foundationItems = _foundationItems,
    this.independentItems = _independentRegistryItems,
    this.specStylerItems = _agentComponentItems,
    this.iconsFromCheckout = false,
  });

  final String name;
  final String fixtureDirectory;
  final List<String> registryItems;
  final Map<String, String> generatedSnapshots;

  /// Hosted runtime dependencies the CLI must add to the consumer, exactly.
  final List<String> requiredRuntimeDependencies;

  final Set<String> foundationItems;

  /// Items installed alone in a fresh app, so an omitted dependency cannot
  /// hide behind the full gallery. Each one costs a `remix init`, and a fresh
  /// init makes one unauthenticated GitHub API request (60 an hour). `null`
  /// derives the list from `registry.yaml`: the items whose dependencies name
  /// anything besides a foundation item.
  final List<String>? independentItems;
  final List<String> specStylerItems;

  /// Packages the installed `lib/ui` source may import.
  final List<String> allowedImportPackages;

  /// Whether a checkout install resolves `remix_ui_icons` from this tree.
  final bool iconsFromCheckout;

  /// This contract for one registry's `icons.yaml` and the app's
  /// `iconLibrary`: `remix_ui_icons` gives way to the icon packages that
  /// registry installs.
  _PresetContract forIcons(
    String iconsYaml,
    String iconLibrary, {
    required String checkoutIconsVersion,
  }) {
    final icons = iconPackagesFor(iconsYaml, iconLibrary);
    List<String> swap(List<String> packages) => [
      for (final package in packages)
        if (package == 'remix_ui_icons') ...icons else package,
    ];
    return _PresetContract(
      name: name,
      fixtureDirectory: fixtureDirectory,
      registryItems: registryItems,
      generatedSnapshots: generatedSnapshots,
      requiredRuntimeDependencies: swap(requiredRuntimeDependencies),
      allowedImportPackages: swap(allowedImportPackages),
      foundationItems: foundationItems,
      independentItems: independentItems,
      specStylerItems: specStylerItems,
      iconsFromCheckout:
          icons.contains('remix_ui_icons') &&
          iconsResolveFromCheckout(iconsYaml, checkoutIconsVersion),
    );
  }

  YamlMap _loadItems([Directory? repositoryRoot]) {
    final root = repositoryRoot ?? Directory.current.absolute;
    final file = File('${root.path}/registry/$name/registry.yaml');
    final document = loadYaml(file.readAsStringSync()) as YamlMap;
    return document['items'] as YamlMap;
  }

  static List<String> _authoredFiles(YamlMap items, String key) {
    final item = items[key] as YamlMap;
    final files = item['files'] as YamlList;
    return [
      for (final entry in files)
        ((entry as YamlMap)['target'] as String).replaceFirst('@ui/', ''),
    ];
  }

  static List<String> _generatedFiles(YamlMap items, String key) {
    final item = items[key] as YamlMap;
    final generated = item['generated'] as YamlList?;
    return [
      if (generated != null)
        for (final target in generated.cast<String>())
          target.replaceFirst('@ui/', ''),
    ];
  }

  static List<String> _allFiles(YamlMap items, String key) => [
    ..._authoredFiles(items, key),
    ..._generatedFiles(items, key),
  ];

  List<String> focusedUiFiles(String item, [Directory? repositoryRoot]) {
    final items = _loadItems(repositoryRoot);
    final visited = <String>{};
    final closure = <String>[];
    void visit(String key) {
      if (!visited.add(key)) return;
      final definition = items[key] as YamlMap?;
      if (definition == null) {
        throw StateError('Registry $name has no item "$key".');
      }
      final deps = definition['registryDependencies'] as YamlList?;
      if (deps != null) {
        for (final dep in deps.cast<String>()) {
          visit(dep);
        }
      }
      closure.add(key);
    }

    visit(item);
    return <String>{
      'ui.dart',
      for (final key in closure) ..._allFiles(items, key),
    }.toList();
  }

  List<String> independentInstalls([Directory? repositoryRoot]) {
    final listed = independentItems;
    if (listed != null) return listed;
    final items = _loadItems(repositoryRoot);
    return [
      for (final key in items.keys.cast<String>())
        if (!foundationItems.contains(key) &&
            ((items[key] as YamlMap)['registryDependencies'] as YamlList? ??
                    const [])
                .any((dependency) => !foundationItems.contains(dependency)))
          key,
    ];
  }

  List<String> get installedUiFiles {
    final items = _loadItems();
    return <String>{
      'ui.dart',
      for (final key in items.keys.cast<String>()) ..._allFiles(items, key),
    }.toList();
  }

  List<String> get generatedAppFiles {
    final items = _loadItems();
    return <String>{
      for (final key in items.keys.cast<String>())
        for (final file in _generatedFiles(items, key)) 'lib/ui/$file',
    }.toList();
  }
}

enum RemixSource { both, hosted, checkout }

final class ConsumerCheckOptions {
  const ConsumerCheckOptions({
    required this.keep,
    required this.preset,
    required this.source,
    required this.hostedCli,
    required this.item,
    this.iconLibrary = 'remix',
    this.jobs,
  });

  final bool keep;
  final String preset;
  final RemixSource source;
  final bool hostedCli;
  final String? item;

  /// Independent items installed at once, or null to resolve the default.
  final int? jobs;

  /// The `iconLibrary` written to the fresh app's remix.yaml before install.
  final String iconLibrary;
}

ConsumerCheckOptions? parseConsumerCheckOptions(List<String> arguments) {
  var keep = false;
  var sawPreset = false;
  var sawSource = false;
  var preset = _defaultPreset;
  var source = RemixSource.both;
  var hostedCli = false;
  var iconLibrary = 'remix';
  var sawIconLibrary = false;
  int? jobs;
  String? item;
  for (var index = 0; index < arguments.length; index += 1) {
    final argument = arguments[index];
    if (argument == '--hosted-cli') {
      if (hostedCli) return null;
      hostedCli = true;
      continue;
    }
    if (argument == '--keep') {
      if (keep) return null;
      keep = true;
      continue;
    }
    if (argument == '--jobs') {
      if (jobs != null || index + 1 >= arguments.length) return null;
      jobs = _positiveInt(arguments[++index]);
      if (jobs == null) return null;
      continue;
    }
    if (argument == '--item') {
      if (item != null || index + 1 >= arguments.length) return null;
      final selected = arguments[++index];
      if (selected != 'dashboard_demo' &&
          selected != 'dashboard_shell' &&
          selected != 'ownership' &&
          selected != 'icons') {
        return null;
      }
      item = selected;
      continue;
    }
    if (argument == '--icon-library') {
      if (sawIconLibrary || index + 1 >= arguments.length) return null;
      sawIconLibrary = true;
      final selected = arguments[++index];
      if (!_iconLibraries.contains(selected)) return null;
      iconLibrary = selected;
      continue;
    }
    if (argument == '--preset') {
      if (sawPreset || index + 1 >= arguments.length) return null;
      sawPreset = true;
      final name = arguments[++index];
      switch (name) {
        case 'vanilla':
          preset = _defaultPreset;
        case 'fortal':
          preset = _fortalPreset;
        case 'heroui':
          preset = _herouiPreset;
        default:
          return null;
      }
      continue;
    }
    if (argument == '--source') {
      if (sawSource || index + 1 >= arguments.length) return null;
      sawSource = true;
      final name = arguments[++index];
      final selected = RemixSource.values.where((value) => value.name == name);
      if (selected.isEmpty) return null;
      source = selected.single;
      continue;
    }
    return null;
  }
  if (hostedCli && source != RemixSource.hosted) return null;
  if (item != null && source != RemixSource.checkout) return null;
  if (item != null && jobs != null) return null;
  if ((item == 'icons' || item == 'ownership') && preset.name != 'vanilla')
    return null;
  if (item != null &&
      item != 'ownership' &&
      !preset.registryItems.contains(item)) {
    return null;
  }
  return ConsumerCheckOptions(
    keep: keep,
    preset: preset.name,
    source: source,
    hostedCli: hostedCli,
    item: item,
    iconLibrary: iconLibrary,
    jobs: jobs,
  );
}

int? _positiveInt(String text) {
  final value = int.tryParse(text);
  return value != null && value > 0 ? value : null;
}

/// The default cap on concurrent installs. Each is a `pub get`, an analyzer
/// run, and, for items with generated files, a `build_runner` build; past a few
/// at once they contend for CPU and memory instead of finishing sooner.
const _maxDefaultJobs = 4;

/// How many independent items are installed at once: [requested] (`--jobs`),
/// else [fromEnvironment] (`REMIX_OPEN_CODE_JOBS`), else one per processor up
/// to [_maxDefaultJobs], never fewer than two.
///
/// Null when [requested] is absent and [fromEnvironment] is not a positive
/// integer, so a misspelled override fails the run instead of silently falling
/// back to the default.
int? resolveJobs({
  int? requested,
  String? fromEnvironment,
  required int processors,
}) {
  if (requested != null) return requested;
  if (fromEnvironment != null) return _positiveInt(fromEnvironment);
  return min(max(processors, 2), _maxDefaultJobs);
}

Future<void> main(List<String> arguments) async {
  final parsed = parseConsumerCheckOptions(arguments);
  if (parsed == null) {
    stderr.writeln(
      'Usage: dart run tool/check_open_code.dart '
      '[--preset vanilla|fortal|heroui] [--source both|hosted|checkout] '
      '[--item dashboard_demo|dashboard_shell|icons|ownership (requires --source '
      'checkout; icons/ownership are vanilla)] [--icon-library remix|lucide] '
      '[--hosted-cli (requires --source hosted)] [--jobs N (not with --item)] '
      '[--keep]',
    );
    exitCode = 64;
    return;
  }
  final jobs = resolveJobs(
    requested: parsed.jobs,
    fromEnvironment: Platform.environment['REMIX_OPEN_CODE_JOBS'],
    processors: Platform.numberOfProcessors,
  );
  if (jobs == null) {
    stderr.writeln('REMIX_OPEN_CODE_JOBS must be a positive integer.');
    exitCode = 64;
    return;
  }

  final repositoryRoot = Directory.current.absolute;
  final ref = publishedRegistryRef(
    hostedCli: parsed.hostedCli,
    environment: Platform.environment,
  );
  final String icons;
  try {
    icons = await _registryIcons(repositoryRoot, ref);
  } on IOException catch (error) {
    stderr.writeln(
      'open-code check failed: could not read the '
      '${ref ?? 'checkout'} registry\'s icons.yaml: $error',
    );
    exitCode = 1;
    return;
  }
  stdout.writeln(
    'Registry under test: ${ref == null ? 'this checkout' : '$_officialRepository@$ref'}.',
  );
  final failure = await _run(
    repositoryRoot,
    keep: parsed.keep,
    preset: _presetByName(parsed.preset).forIcons(
      icons,
      parsed.iconLibrary,
      checkoutIconsVersion: _packageVersion(repositoryRoot, 'remix_ui_icons'),
    ),
    iconLibrary: parsed.iconLibrary,
    source: parsed.source,
    hostedCli: parsed.hostedCli,
    item: parsed.item,
    jobs: jobs,
  );
  if (failure != null) {
    stderr.writeln('open-code check failed: ${failure.message}');
    exitCode = failure.exitCode;
  }
}

Future<_Failure?> _run(
  Directory repositoryRoot, {
  required bool keep,
  required _PresetContract preset,
  required RemixSource source,
  required bool hostedCli,
  required String? item,
  required String iconLibrary,
  required int jobs,
}) async {
  final rootFailure = _verifyRepositoryRoot(repositoryRoot);
  if (rootFailure != null) return rootFailure;

  final pinnedVersion = _pinnedFlutterVersion(repositoryRoot);
  if (pinnedVersion == null) {
    return _Failure('.fvmrc does not pin a Flutter version.', exitCode: 64);
  }

  final resolved = await _resolveToolchain(repositoryRoot, pinnedVersion);
  if (resolved is _Failure) return resolved;
  final sdk = resolved as _Toolchain;
  _step('Flutter ${sdk.version} from ${sdk.root}');

  final coverageFailure = _verifyRegistryCoverage(repositoryRoot, preset);
  if (coverageFailure != null) return coverageFailure;
  _step('Every remote registry item is installed by this check.');

  final fixtureRoot = Directory(
    '${repositoryRoot.path}/open_code/${preset.fixtureDirectory}',
  );
  final fixtureFailure = _verifyFixtureContract(fixtureRoot, preset);
  if (fixtureFailure != null) return fixtureFailure;
  _step('Fixture is a minimal pre-install app with no consumer build.yaml.');

  final parent = Directory.systemTemp.createTempSync('remix_open_code_');
  final app = Directory('${parent.path}/app');

  try {
    final guardFailure = _verifyDeletableParent(parent, repositoryRoot);
    if (guardFailure != null) return _retainedFailure(parent, guardFailure);

    final checkFailure = await _checkInTemporaryApp(
      sdk: sdk,
      repositoryRoot: repositoryRoot,
      fixtureRoot: fixtureRoot,
      app: app,
      preset: preset,
      source: source,
      hostedCli: hostedCli,
      item: item,
      iconLibrary: iconLibrary,
      jobs: jobs,
    );
    if (checkFailure != null) {
      return _retainedFailure(parent, checkFailure);
    }

    if (!keep) {
      final deletionFailure = _deleteVerifiedParent(parent, repositoryRoot);
      if (deletionFailure != null) {
        return _retainedFailure(parent, deletionFailure);
      }
    }
  } on Object catch (error, stackTrace) {
    return _retainedFailure(parent, error, stackTrace: stackTrace);
  }

  if (keep) {
    stdout
      ..writeln('')
      ..writeln('Kept the generated application at:')
      ..writeln('  ${app.path}')
      ..writeln('');
    if (source != RemixSource.hosted) {
      stdout
        ..writeln('It has a temporary checkout override for Remix. Delete')
        ..writeln('pubspec_overrides.yaml and run `${sdk.flutter} pub get` to')
        ..writeln('return to hosted Remix after its required release exists.')
        ..writeln('');
    }
    stdout
      ..writeln('Run the gallery:')
      ..writeln('  cd ${app.path} && ${sdk.flutter} run -d chrome')
      ..writeln('')
      ..writeln('Review local source against the registry:')
      ..writeln(
        '  cd ${app.path} && ${sdk.dart} run remix_cli:remix add '
        '${item == 'ownership' ? '@addon/extra_button' : item ?? preset.registryItems.first} --diff',
      );
  }

  stdout.writeln('open-code check passed (${preset.name}, ${source.name}).');
  return null;
}

Future<_Failure?> _checkInTemporaryApp({
  required _Toolchain sdk,
  required Directory repositoryRoot,
  required Directory fixtureRoot,
  required Directory app,
  required _PresetContract preset,
  required RemixSource source,
  required bool hostedCli,
  required String? item,
  required String iconLibrary,
  required int jobs,
}) async {
  final environment = _toolchainEnvironment(sdk);
  if (!hostedCli &&
      Platform.environment['REMIX_REGISTRY_RELEASE_SMOKE'] != '1') {
    final snapshot = await compileRegistryConsumerCli(
      dart: sdk.dart,
      repositoryRoot: repositoryRoot,
      outputDirectory: app.parent,
      environment: environment,
    );
    environment['REMIX_REGISTRY_CONSUMER_CLI'] = snapshot.path;
    environment['REMIX_REGISTRY_ROOT'] = '${repositoryRoot.path}/registry';
    _step(
      'Compiled the checkout CLI; every invocation remains a fresh process.',
    );
  }

  final create = await _runProcess(
    sdk.flutter,
    [
      'create',
      '--empty',
      '--no-pub',
      '--platforms=web',
      '--project-name',
      'open_code_fixture',
      app.path,
    ],
    workingDirectory: app.parent.path,
    environment: environment,
  );
  if (create != null) return create;
  _step('Created a fresh Flutter application.');

  _replaceSkeleton(app: app, fixtureRoot: fixtureRoot);
  _step('Applied the committed pre-install fixture.');

  final cliRoot = Directory('${repositoryRoot.path}/packages/remix_cli');
  if (!cliRoot.existsSync()) {
    return _Failure('packages/remix_cli is missing from this checkout.');
  }
  final remixSource = Directory('${repositoryRoot.path}/packages/remix');
  if (!remixSource.existsSync()) {
    return _Failure('packages/remix is missing from this checkout.');
  }
  final startsWithCheckout = source == RemixSource.checkout;
  if (startsWithCheckout) _writeCheckoutOverride(app, remixSource, preset);

  // Hosted mode never falls back to the checkout. A missing release must fail
  // the release check, even when checkout validation already passed.
  final addCli = await _runProcess(
    sdk.dart,
    [
      'pub',
      'add',
      if (hostedCli)
        'dev:remix_cli:${(loadYaml(File('${cliRoot.path}/pubspec.yaml').readAsStringSync()) as YamlMap)['version']}'
      else
        'dev:remix_cli@{path: ${jsonEncode(cliRoot.path)}}',
    ],
    workingDirectory: app.path,
    environment: environment,
  );
  if (addCli != null) {
    return _Failure('could not add the selected CLI to the temporary app');
  }

  final init = await _runProcess(
    sdk.dart,
    [
      'run',
      'remix_cli:remix',
      'init',
      '--prefix',
      'Acme',
      '--preset',
      preset.name,
    ],
    workingDirectory: app.path,
    environment: environment,
  );
  if (init != null) return _Failure('remix init failed in the fresh app');
  _writeIconLibrary(app, iconLibrary);

  if (item == 'ownership') {
    return _checkOwnershipComposition(
      sdk: sdk,
      app: app,
      fixtureRoot: fixtureRoot,
      environment: environment,
    );
  }
  if (item != null) {
    return _checkFocusedItem(
      sdk: sdk,
      repositoryRoot: repositoryRoot,
      fixtureRoot: fixtureRoot,
      app: app,
      preset: preset,
      item: item,
      cliRoot: cliRoot,
      remixSource: remixSource,
      environment: environment,
    );
  }

  final independent = await _checkIndependentItems(
    sdk: sdk,
    app: app,
    preset: preset,
    environment: environment,
    jobs: jobs,
  );
  if (independent != null) return independent;

  for (final item in preset.registryItems) {
    final add = await _runProcess(
      sdk.dart,
      ['run', 'remix_cli:remix', 'add', item],
      workingDirectory: app.path,
      environment: environment,
    );
    if (add != null) return _Failure('remix add $item failed in the fresh app');
  }
  _step('CLI installed Theme, every item, dependencies, and generated output.');

  final installedFailure = _verifyInstalledUi(app, preset);
  if (installedFailure != null) return installedFailure;
  _step('Installed UI inventory and import boundary are exact.');

  final dependencyFailure = _verifyInstalledDependencies(
    app,
    preset: preset,
    hostedCli: hostedCli,
  );
  if (dependencyFailure != null) return dependencyFailure;

  final installedConfig = _readPackageConfig(app);
  if (installedConfig is _Failure) return installedConfig;
  final installedPackages = installedConfig as Map<String, String>;
  for (final package in [
    ...preset.requiredRuntimeDependencies,
    ..._requiredDevDependencies,
    if (hostedCli) 'remix_cli',
  ]) {
    if (startsWithCheckout &&
        _checkoutPackages(remixSource, preset).containsKey(package)) {
      continue;
    }
    final root = installedPackages[package];
    if (root == null || !_isHostedCachePath(root)) {
      return _Failure(
        '$package resolved to ${root ?? 'nothing'}, expected a hosted cache.',
      );
    }
    stdout.writeln('  $package -> $root');
  }

  final floorFailure = _verifyResolvedRemixFloor(
    repositoryRoot: repositoryRoot,
    resolvedPackages: installedPackages,
    preset: preset,
  );
  if (floorFailure != null) return floorFailure;
  _step('Resolved Remix matches the registry floor.');

  final installedCheckoutFailure = _verifyCheckoutPackages(
    packages: installedPackages,
    repositoryRoot: repositoryRoot,
    expected: {
      if (!hostedCli) 'remix_cli': cliRoot,
      if (startsWithCheckout) ..._checkoutPackages(remixSource, preset),
    },
  );
  if (installedCheckoutFailure != null) return installedCheckoutFailure;
  _step('Installed packages match the selected source boundary.');

  if (preset.generatedSnapshots.isNotEmpty) {
    final generatedFailure = _verifyGeneratedFixture(
      app: app,
      fixtureRoot: fixtureRoot,
      preset: preset,
    );
    if (generatedFailure != null) return generatedFailure;
    _step('Generation matches the committed Acme adapter.');
  }

  final installedVerification = await _analyzeAndTest(
    sdk: sdk,
    app: app,
    dependencySource: startsWithCheckout ? 'current checkout' : 'hosted Remix',
    environment: environment,
  );
  if (installedVerification != null) return installedVerification;
  if (source != RemixSource.both) return null;

  _writeCheckoutOverride(app, remixSource, preset);

  final overrideGet = await _runProcess(
    sdk.flutter,
    ['pub', 'get'],
    workingDirectory: app.path,
    environment: environment,
  );
  if (overrideGet != null) {
    return _Failure('flutter pub get failed with the Remix checkout override');
  }

  final currentConfig = _readPackageConfig(app);
  if (currentConfig is _Failure) return currentConfig;
  final currentPackages = currentConfig as Map<String, String>;
  final currentCheckoutFailure = _verifyCheckoutPackages(
    packages: currentPackages,
    repositoryRoot: repositoryRoot,
    expected: {'remix_cli': cliRoot, ..._checkoutPackages(remixSource, preset)},
  );
  if (currentCheckoutFailure != null) return currentCheckoutFailure;
  _step('Current-source override resolves only the checkout packages locally.');

  for (final relative in preset.generatedAppFiles) {
    final generated = File('${app.path}/$relative');
    if (!generated.existsSync()) {
      return _Failure('CLI produced no $relative before regeneration.');
    }
    generated.deleteSync();
  }
  final regenerate = await _runProcess(
    sdk.dart,
    [
      'run',
      'build_runner',
      'build',
      for (final relative in preset.generatedAppFiles)
        '--build-filter=$relative',
    ],
    workingDirectory: app.path,
    environment: environment,
  );
  if (regenerate != null) {
    return _Failure('build_runner failed against current Remix source');
  }
  if (File('${app.path}/build.yaml').existsSync()) {
    return _Failure('generation created an app-level build.yaml');
  }

  if (preset.generatedSnapshots.isNotEmpty) {
    final regeneratedFailure = _verifyGeneratedFixture(
      app: app,
      fixtureRoot: fixtureRoot,
      preset: preset,
    );
    if (regeneratedFailure != null) return regeneratedFailure;
    _step('Current-source regeneration matches the committed Acme adapter.');
  }

  return _analyzeAndTest(
    sdk: sdk,
    app: app,
    dependencySource: 'current checkout',
    environment: environment,
  );
}

/// Real processes and generated adapters; only registry transport is local.
Future<_Failure?> _checkOwnershipComposition({
  required _Toolchain sdk,
  required Directory app,
  required Directory fixtureRoot,
  required Map<String, String> environment,
}) async {
  final fixtureFailure = _applyFocusedFixture(
    app: app,
    fixtureRoot: fixtureRoot,
    item: 'ownership',
  );
  if (fixtureFailure != null) return fixtureFailure;
  environment['REMIX_REGISTRY_OWNERSHIP_PROBE'] = '1';
  Future<_Failure?> cli(List<String> arguments) => _runProcess(
    sdk.dart,
    ['run', 'remix_cli:remix', ...arguments],
    workingDirectory: app.path,
    environment: environment,
  );
  final buttonInstall = await cli(['add', 'button']);
  if (buttonInstall != null) return buttonInstall;
  final customized = <String, String>{};
  for (final relative in ['components/button.dart', 'theme/tokens.dart']) {
    final file = File('${app.path}/lib/ui/$relative');
    final source =
        '${file.readAsStringSync()}// consumer customization retained\n';
    file.writeAsStringSync(source);
    customized[relative] = source;
  }
  final register = await cli([
    'registry',
    'add',
    '@addon',
    '--repository',
    'fixture/addon',
    '--ref',
    'v1',
  ]);
  if (register != null) return register;
  final manifest = File('${app.path}/pubspec.yaml');
  manifest.writeAsStringSync(
    manifest.readAsStringSync().replaceFirst(
      'mix_annotations: ^2.2.0-beta.1',
      "mix_annotations: '>=2.2.0-beta.1 <3.0.0' # consumer constraint",
    ),
  );
  final pubspec = manifest.readAsStringSync();
  for (final arguments in [
    ['add', '@addon/extra_button', '--dry-run'],
    ['add', '@addon/extra_button', '--diff'],
    ['add', '@addon/extra_button'],
    ['add', '@addon/extra_button', '--overwrite'],
    ['add', 'button'],
  ]) {
    final failure = await cli(arguments);
    if (failure != null) return failure;
    for (final entry in customized.entries) {
      if (File('${app.path}/lib/ui/${entry.key}').readAsStringSync() !=
          entry.value) {
        return _Failure('Additive install replaced customized ${entry.key}.');
      }
    }
  }
  if (File('${app.path}/pubspec.yaml').readAsStringSync() != pubspec) {
    return _Failure(
      'Additive registry changed customized dependency declarations.',
    );
  }
  for (final target in [
    'components/button.g.dart',
    'addons/extra_button.g.dart',
  ]) {
    if (!File('${app.path}/lib/ui/$target').existsSync()) {
      return _Failure('Additive install removed generated $target.');
    }
  }
  final ownership =
      jsonDecode(File('${app.path}/remix.ownership.json').readAsStringSync())
          as Map;
  final targets = ownership['targets'] as Map;
  if (targets['lib/ui/addons/extra_button.g.dart'] !=
          'fixture/addon/registry#vanilla/extra_button' ||
      targets['lib/ui/components/button.g.dart'] !=
          'btwld/remix/registry#vanilla/button') {
    return _Failure(
      'Composition did not retain distinct generated-target owners.',
    );
  }
  _step(
    'Separate disjoint registries retained custom recipes, tokens, dependencies, adapters and owners.',
  );
  return _analyzeAndTest(
    sdk: sdk,
    app: app,
    dependencySource: 'current checkout',
    environment: environment,
  );
}

Future<_Failure?> _checkFocusedItem({
  required _Toolchain sdk,
  required Directory repositoryRoot,
  required Directory fixtureRoot,
  required Directory app,
  required _PresetContract preset,
  required String item,
  required Directory cliRoot,
  required Directory remixSource,
  required Map<String, String> environment,
}) async {
  final fixtureFailure = _applyFocusedFixture(
    app: app,
    fixtureRoot: fixtureRoot,
    item: item,
  );
  if (fixtureFailure != null) return fixtureFailure;

  final add = await _runProcess(
    sdk.dart,
    ['run', 'remix_cli:remix', 'add', item],
    workingDirectory: app.path,
    environment: environment,
  );
  if (add != null) return _Failure('remix add $item failed in the fresh app');

  final uiRoot = Directory('${app.path}/lib/ui');
  final found = uiRoot
      .listSync(recursive: true, followLinks: false)
      .whereType<File>()
      .map((file) => _relativePath(uiRoot, file))
      .toSet();
  final expected = preset.focusedUiFiles(item).toSet();
  final inventoryProblems = <String>[
    ..._focusedInventoryProblems(expected: expected, found: found),
    ..._installedReferenceProblems(uiRoot, expected, preset),
  ];
  if (inventoryProblems.isNotEmpty) {
    return _Failure(
      'focused $item inventory is invalid:\n'
      '${inventoryProblems.map((problem) => '  - $problem').join('\n')}',
    );
  }

  final forbiddenRecipeFiles = <String>{
    for (final agent in _agentRegistryItems)
      agent.endsWith('_recipe')
          ? 'recipes/$agent.dart'
          : 'components/$agent.dart',
  };
  if (item == 'dashboard_shell' &&
      found.intersection(forbiddenRecipeFiles).isNotEmpty) {
    return _Failure('focused $item unexpectedly installed Agent source');
  }
  if (item == 'dashboard_shell' &&
      (found.contains('components/chart.dart') ||
          found.contains('components/data_table.dart') ||
          found.contains('recipes/dashboard/dashboard_demo.dart'))) {
    return _Failure(
      'dashboard_shell unexpectedly installed dashboard_demo-only source',
    );
  }
  _step('Focused $item inventory matches its explicit dependency closure.');

  final dependencyFailure = _verifyFocusedDependencies(
    app,
    preset: preset,
    item: item,
  );
  if (dependencyFailure != null) return dependencyFailure;

  final packageConfig = _readPackageConfig(app);
  if (packageConfig is _Failure) return packageConfig;
  final checkoutFailure = _verifyCheckoutPackages(
    packages: packageConfig as Map<String, String>,
    repositoryRoot: repositoryRoot,
    expected: {'remix_cli': cliRoot, ..._checkoutPackages(remixSource, preset)},
  );
  if (checkoutFailure != null) return checkoutFailure;

  final verification = await _analyzeAndTest(
    sdk: sdk,
    app: app,
    dependencySource: 'current checkout',
    environment: environment,
  );
  if (verification != null) return verification;

  final build = await _runProcess(
    sdk.flutter,
    ['build', 'web'],
    workingDirectory: app.path,
    environment: environment,
  );
  if (build != null || !File('${app.path}/build/web/index.html').existsSync()) {
    return _Failure('focused $item did not produce a Flutter web build');
  }
  _step('Focused $item built for web.');
  return null;
}

List<String> _focusedInventoryProblems({
  required Set<String> expected,
  required Set<String> found,
}) => [
  for (final file in expected.difference(found)) 'focused install lacks $file',
  for (final file in found.difference(expected))
    'focused install has unexpected $file',
];

_Failure? _applyFocusedFixture({
  required Directory app,
  required Directory fixtureRoot,
  required String item,
}) {
  final sources = {
    '${item}_main.dart': 'lib/main.dart',
    '${item}_test.dart': 'test/open_code_test.dart',
  };
  for (final entry in sources.entries) {
    final source = File('${fixtureRoot.path}/focused/${entry.key}');
    if (!source.existsSync()) {
      return _Failure(
        'open_code/${fixtureRoot.path.split('/').last}/focused/'
        '${entry.key} is missing',
      );
    }
    final target = File('${app.path}/${entry.value}');
    target.parent.createSync(recursive: true);
    source.copySync(target.path);
  }
  return null;
}

/// Sets `iconLibrary` in the fresh app's remix.yaml; the default is left out.
void _writeIconLibrary(Directory app, String iconLibrary) {
  if (iconLibrary == 'remix') return;
  final file = File('${app.path}/remix.yaml');
  file.writeAsStringSync(
    file.readAsStringSync().replaceFirstMapped(
      RegExp(r'^preset: .*\n', multiLine: true),
      (match) => '${match[0]}iconLibrary: $iconLibrary\n',
    ),
  );
}

_Failure? _verifyFocusedDependencies(
  Directory app, {
  required _PresetContract preset,
  required String item,
}) {
  final sections = _dependencySections(
    File('${app.path}/pubspec.yaml').readAsStringSync(),
  );
  final runtime = sections['dependencies'] ?? const <String, Object?>{};
  final development = sections['dev_dependencies'] ?? const <String, Object?>{};
  // Every focused install still resolves the preset's theme, and with it the
  // theme's packages. The chart package follows the item, and the icon alias
  // alone installs no generated component.
  final runtimeExpected = {
    'flutter',
    for (final package in preset.requiredRuntimeDependencies)
      if ((package != 'mix_chart' || item == 'dashboard_demo') &&
          (package != 'mix_annotations' || item != 'icons'))
        package,
  };
  final developmentExpected = {
    'flutter_test',
    'remix_cli',
    if (item != 'icons') ...['build_runner', 'mix_generator'],
  };
  final problems = <String>[];
  _expectExactKeys(runtime, runtimeExpected, 'runtime', problems);
  _expectExactKeys(development, developmentExpected, 'development', problems);
  if (problems.isEmpty) return null;
  return _Failure(
    'focused $item dependency manifest is invalid:\n'
    '${problems.map((problem) => '  - $problem').join('\n')}',
  );
}

/// Each surface must compile with only its own dependency closure. The full
/// gallery installs every item and would otherwise mask an omitted dependency.
///
/// Each item gets its own directory, resolution, and generator run, and shares
/// only the pub cache and the Flutter SDK, so up to [jobs] of them are
/// installed at once. Concurrent `flutter` calls queue on the SDK's startup
/// lock, which slows them without blocking them.
Future<_Failure?> _checkIndependentItems({
  required _Toolchain sdk,
  required Directory app,
  required _PresetContract preset,
  required Map<String, String> environment,
  required int jobs,
}) async {
  final pubspec = File('${app.path}/pubspec.yaml').readAsStringSync();
  final override = File('${app.path}/pubspec_overrides.yaml');
  final items = preset.independentInstalls();

  Future<_Failure?> checkItem(String item, StringSink log) async {
    final elapsed = Stopwatch()..start();
    final isolated = Directory('${app.parent.path}/independent_$item')
      ..createSync();
    File('${isolated.path}/pubspec.yaml').writeAsStringSync(pubspec);
    if (override.existsSync()) {
      override.copySync('${isolated.path}/pubspec_overrides.yaml');
    }
    Directory('${isolated.path}/lib').createSync();
    File(
      '${isolated.path}/lib/main.dart',
    ).writeAsStringSync('void main() {}\n');
    for (final command in [
      ['pub', 'get'],
      [
        'run',
        'remix_cli:remix',
        'init',
        '--prefix',
        'Solo',
        '--preset',
        preset.name,
      ],
      ['run', 'remix_cli:remix', 'add', item],
    ]) {
      final failure = await _runProcess(
        sdk.dart,
        command,
        workingDirectory: isolated.path,
        environment: environment,
        log: log,
      );
      if (failure != null)
        return _Failure('Independent $item install failed: ${failure.message}');
    }
    final ui = Directory('${isolated.path}/lib/ui');
    final files = ui
        .listSync(recursive: true)
        .whereType<File>()
        .map(
          (file) =>
              file.path.substring(ui.path.length + 1).replaceAll('\\', '/'),
        )
        .toSet();
    final problems = _installedReferenceProblems(ui, files, preset);
    if (problems.isNotEmpty)
      return _Failure('Independent $item: ${problems.join('; ')}');
    _step(
      'Independent $item installed, generated, and analyzed with its own '
      'dependencies (${elapsed.elapsed.inSeconds}s).',
      log,
    );
    return null;
  }

  _step('Checking ${items.length} independent items, up to $jobs at a time.');
  return runPooled(items, limit: jobs, out: stdout, work: checkItem);
}

/// Runs [work] for every input with at most [limit] in flight, and returns the
/// failure of the earliest input that failed, or null.
///
/// Each call gets its own log, and the logs reach [out] in input order as soon
/// as every earlier one has, so the output does not depend on which task
/// finished first. After a failure or an exception no further input is
/// started; the tasks already running are awaited, so nothing outlives the
/// call, and their logs are still written.
///
/// An exception from [work] is rethrown after that, but only when no earlier
/// input failed or threw, so the outcome is the one a serial run would reach.
Future<F?> runPooled<T, F extends Object>(
  List<T> inputs, {
  required int limit,
  required StringSink out,
  required Future<F?> Function(T input, StringSink log) work,
}) async {
  if (limit < 1) throw ArgumentError.value(limit, 'limit', 'must be positive');
  final logs = [for (final _ in inputs) StringBuffer()];
  final finished = List.filled(inputs.length, false);
  final failures = <int, F>{};
  final errors = <int, (Object, StackTrace)>{};
  var started = 0;
  var written = 0;
  var stopped = false;

  Future<void> worker() async {
    while (!stopped && started < inputs.length) {
      final index = started++;
      try {
        final failure = await work(inputs[index], logs[index]);
        if (failure != null) {
          failures[index] = failure;
          stopped = true;
        }
      } catch (error, stackTrace) {
        errors[index] = (error, stackTrace);
        stopped = true;
      } finally {
        finished[index] = true;
        while (written < inputs.length && finished[written]) {
          out.write(logs[written++]);
        }
      }
    }
  }

  await Future.wait([
    for (var slot = 0; slot < min(limit, inputs.length); slot += 1) worker(),
  ]);
  final problems = [...failures.keys, ...errors.keys];
  if (problems.isEmpty) return null;
  final first = problems.reduce(min);
  final error = errors[first];
  if (error != null) Error.throwWithStackTrace(error.$1, error.$2);
  return failures[first];
}

/// The checkout packages a preset's install resolves locally: Remix, its
/// workspace primitive package `naked_ui`, the fonts package when the
/// preset's theme depends on it, and `remix_ui_icons` when the registry under
/// test floors it at the checkout's version, which may not be published yet
/// ([iconsResolveFromCheckout]). The hosted release check requires every one
/// of them from pub.dev.
Map<String, Directory> _checkoutPackages(
  Directory remixSource,
  _PresetContract preset,
) => {
  'remix': remixSource,
  'naked_ui': Directory('${remixSource.parent.path}/naked_ui'),
  if (preset.requiredRuntimeDependencies.contains('remix_ui_fonts'))
    'remix_ui_fonts': Directory('${remixSource.parent.path}/remix_ui_fonts'),
  if (preset.iconsFromCheckout)
    'remix_ui_icons': Directory('${remixSource.parent.path}/remix_ui_icons'),
};

void _writeCheckoutOverride(
  Directory app,
  Directory remixSource,
  _PresetContract preset,
) {
  final overrides = [
    for (final entry in _checkoutPackages(remixSource, preset).entries)
      '  ${entry.key}:\n    path: ${jsonEncode(entry.value.path)}',
  ].join('\n');
  File('${app.path}/pubspec_overrides.yaml').writeAsStringSync('''
# Created in a guarded temporary app by tool/check_open_code.dart.
dependency_overrides:
$overrides
''');
}

Future<_Failure?> _analyzeAndTest({
  required _Toolchain sdk,
  required Directory app,
  required String dependencySource,
  required Map<String, String> environment,
}) async {
  final analyze = await _runProcess(
    sdk.flutter,
    ['analyze'],
    workingDirectory: app.path,
    environment: environment,
  );
  if (analyze != null) {
    return _Failure('flutter analyze failed against $dependencySource');
  }
  _step('flutter analyze is clean against $dependencySource.');

  final test = await _runProcess(
    sdk.flutter,
    ['test', '--reporter=failures-only'],
    workingDirectory: app.path,
    environment: environment,
  );
  if (test != null) {
    return _Failure('flutter test failed against $dependencySource');
  }
  _step('flutter test passed against $dependencySource.');
  return null;
}

_Failure? _verifyRepositoryRoot(Directory root) {
  final pubspec = File('${root.path}/pubspec.yaml');
  if (!pubspec.existsSync() ||
      !pubspec.readAsStringSync().contains('name: remix_workspace')) {
    return _Failure(
      'run this checker from the Remix workspace root.',
      exitCode: 64,
    );
  }
  if (!Directory('${root.path}/open_code').existsSync()) {
    return _Failure('open_code/ is missing from this checkout.', exitCode: 64);
  }
  return null;
}

String? _pinnedFlutterVersion(Directory root) {
  final file = File('${root.path}/.fvmrc');
  if (!file.existsSync()) return null;
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map) return null;
  final version = decoded['flutter'];
  return version is String && version.isNotEmpty ? version : null;
}

Future<Object> _resolveToolchain(Directory root, String pinned) async {
  final candidates = <List<String>>[
    ['fvm', 'flutter'],
    ['flutter'],
  ];
  final attempts = <String>[];

  for (final candidate in candidates) {
    final ProcessResult result;
    try {
      result = await Process.run(candidate.first, [
        ...candidate.skip(1),
        '--version',
        '--machine',
      ], workingDirectory: root.path);
    } on ProcessException catch (error) {
      attempts.add('${candidate.join(' ')}: ${error.message}');
      continue;
    }
    if (result.exitCode != 0) {
      attempts.add('${candidate.join(' ')}: exited ${result.exitCode}');
      continue;
    }

    try {
      final output = result.stdout as String;
      final jsonStart = output.indexOf('{');
      if (jsonStart < 0) throw const FormatException('no JSON object');
      final decoded = jsonDecode(output.substring(jsonStart));
      if (decoded is! Map) throw const FormatException('unexpected JSON');
      final version = decoded['frameworkVersion'];
      final sdkRoot = decoded['flutterRoot'];
      if (version is! String || sdkRoot is! String) {
        throw const FormatException('incomplete toolchain JSON');
      }
      if (version != pinned) {
        attempts.add(
          '${candidate.join(' ')}: Flutter $version, expected $pinned',
        );
        continue;
      }
      return _Toolchain(
        version: version,
        root: sdkRoot,
        flutter: '$sdkRoot/bin/flutter',
        dart: '$sdkRoot/bin/dart',
      );
    } on FormatException catch (error) {
      attempts.add('${candidate.join(' ')}: ${error.message}');
    }
  }

  return _Failure(
    'no Flutter SDK matching the .fvmrc pin ($pinned) was found.\n'
    '${attempts.map((attempt) => '  - $attempt').join('\n')}\n'
    '  Install it with `fvm install $pinned`, or put a matching SDK on PATH.',
    exitCode: 64,
  );
}

/// Fails when the checked item list and remote registry have drifted apart.
///
/// This check exists because the failure it prevents is silent: an item added
/// to `registry.yaml` but not to the preset contract is never installed, never
/// rendered into the fixture, never behavior-tested, and never boundary
/// checked — and every suite still passes.
_Failure? _verifyRegistryCoverage(
  Directory repositoryRoot,
  _PresetContract preset,
) {
  final file = File(
    '${repositoryRoot.path}/registry/'
    '${preset.name}/registry.yaml',
  );
  if (!file.existsSync()) {
    return _Failure('registry/${preset.name}/registry.yaml is missing.');
  }

  final document = loadYaml(file.readAsStringSync());
  if (document is! YamlMap || document['items'] is! YamlMap) {
    return _Failure('registry.yaml is not in the expected shape.');
  }

  // Foundations arrive through dependency closure. Their exact files are
  // still asserted by the installed inventory, not exempted from coverage.
  final catalogItems = {
    for (final key in (document['items'] as YamlMap).keys)
      if (key is String) key,
  };
  final installed = {...preset.foundationItems, ...preset.registryItems};
  final problems = <String>[
    for (final item in catalogItems.difference(installed))
      'registry.yaml has $item, which this check never installs',
    for (final item in installed.difference(catalogItems))
      'this check installs $item, which registry.yaml does not define',
  ]..sort();

  if (problems.isEmpty) return null;
  return _Failure(
    'the checker and the remote registry disagree on the catalog:\n'
    '${problems.map((problem) => '  - $problem').join('\n')}',
  );
}

/// Fails when the selected source resolved a `remix` other than the one the
/// registry floors at.
///
/// The registry constraint is a caret, so every later beta resolves and every
/// other check here still passes — while the installed templates were only
/// ever authored against the floor. `tool/check_version_alignment.dart` holds
/// that floor equal to `packages/remix`; this proves the version a real
/// consumer actually gets is the same one.
_Failure? _verifyResolvedRemixFloor({
  required Directory repositoryRoot,
  required Map<String, String> resolvedPackages,
  required _PresetContract preset,
}) {
  final registry = File(
    '${repositoryRoot.path}/registry/'
    '${preset.name}/registry.yaml',
  );
  final document = loadYaml(registry.readAsStringSync());
  final items = document is YamlMap ? document['items'] : null;
  if (items is! YamlMap) {
    return _Failure('registry.yaml is not in the expected shape.');
  }

  String? constraint;
  for (final item in items.values) {
    final dependencies = (item as YamlMap)['dependencies'];
    if (dependencies is YamlMap && dependencies['remix'] is String) {
      constraint = dependencies['remix'] as String;
      break;
    }
  }
  if (constraint == null || !constraint.startsWith('^')) {
    return _Failure(
      'registry.yaml declares no caret remix constraint to floor at.',
    );
  }

  final root = resolvedPackages['remix'];
  if (root == null) {
    return _Failure('remix is missing from package_config.json.');
  }

  final floor = constraint.substring(1);
  final manifest = File('$root/pubspec.yaml');
  if (!manifest.existsSync()) return _Failure('Resolved Remix has no pubspec.');
  final actual = (loadYaml(manifest.readAsStringSync()) as YamlMap)['version'];
  if (actual == floor) return null;
  return _Failure(
    'the fresh app resolved $actual, but the registry floors at $floor. '
    'If packages/remix was just bumped, push its `v$floor` tag and wait for '
    'pub.dev to serve it.',
  );
}

_Failure? _verifyFixtureContract(
  Directory fixtureRoot,
  _PresetContract preset,
) {
  final problems = <String>[];
  for (final relative in [
    ..._fixtureAppFiles,
    ...preset.generatedSnapshots.values,
  ]) {
    if (!File('${fixtureRoot.path}/$relative').existsSync()) {
      problems.add('open_code/${preset.fixtureDirectory}/$relative is missing');
    }
  }
  if (File('${fixtureRoot.path}/build.yaml').existsSync()) {
    problems.add('declares a consumer build.yaml');
  }

  final pubspec = File('${fixtureRoot.path}/pubspec.yaml');
  if (pubspec.existsSync()) {
    final sections = _dependencySections(pubspec.readAsStringSync());
    final runtime = sections['dependencies'] ?? const <String, Object?>{};
    final development =
        sections['dev_dependencies'] ?? const <String, Object?>{};
    if (sections.containsKey('dependency_overrides')) {
      problems.add('declares dependency_overrides');
    }
    _expectExactKeys(runtime, {'flutter'}, 'runtime', problems);
    _expectExactKeys(development, {'flutter_test'}, 'development', problems);
    if (!_isFlutterSdkDeclaration(runtime['flutter'])) {
      problems.add('flutter is not an SDK dependency');
    }
    if (!_isFlutterSdkDeclaration(development['flutter_test'])) {
      problems.add('flutter_test is not an SDK dependency');
    }
  }

  if (problems.isEmpty) return null;
  return _Failure(
    'open_code/${preset.fixtureDirectory} is not the minimal CLI consumer '
    'contract:\n'
    '${problems.map((problem) => '  - $problem').join('\n')}',
  );
}

_Failure? _verifyInstalledDependencies(
  Directory app, {
  required _PresetContract preset,
  required bool hostedCli,
}) {
  final sections = _dependencySections(
    File('${app.path}/pubspec.yaml').readAsStringSync(),
  );
  final runtime = sections['dependencies'] ?? const <String, Object?>{};
  final development = sections['dev_dependencies'] ?? const <String, Object?>{};
  final problems = <String>[];

  _expectExactKeys(
    runtime,
    {'flutter', ...preset.requiredRuntimeDependencies},
    'runtime',
    problems,
  );
  _expectExactKeys(
    development,
    {'flutter_test', 'remix_cli', ..._requiredDevDependencies},
    'development',
    problems,
  );
  for (final package in [
    ...preset.requiredRuntimeDependencies,
    ..._requiredDevDependencies,
  ]) {
    final declaration = runtime[package] ?? development[package];
    if (declaration is! String) {
      problems.add('$package is not a hosted version constraint');
    }
  }
  for (final package in _forbiddenDependencies) {
    if (runtime.containsKey(package) || development.containsKey(package)) {
      problems.add('declares forbidden direct dependency $package');
    }
  }
  final cli = development['remix_cli'];
  if (hostedCli) {
    if (cli is! String) problems.add('remix_cli is not a hosted constraint');
  } else if (cli is! YamlMap || !cli.containsKey('path')) {
    problems.add('remix_cli is not a temporary path development dependency');
  }
  if (sections.containsKey('dependency_overrides')) {
    problems.add('hosted phase unexpectedly declares dependency_overrides');
  }

  if (problems.isEmpty) return null;
  return _Failure(
    'CLI produced an invalid consumer dependency manifest:\n'
    '${problems.map((problem) => '  - $problem').join('\n')}',
  );
}

void _expectExactKeys(
  Map<String, Object?> actual,
  Set<String> expected,
  String section,
  List<String> problems,
) {
  for (final name in expected.difference(actual.keys.toSet())) {
    problems.add('missing $section dependency $name');
  }
  for (final name in actual.keys.toSet().difference(expected)) {
    problems.add('unexpected $section dependency $name');
  }
}

bool _isFlutterSdkDeclaration(Object? declaration) =>
    declaration is YamlMap && declaration['sdk'] == 'flutter';

_Failure? _verifyInstalledUi(Directory app, _PresetContract preset) {
  final buildConfig = File('${app.path}/build.yaml');
  final expected = {
    'targets': {
      r'$default': {
        'builders': {
          'mix_generator:spec_styler_generator': {
            'enabled': true,
            'generate_for': [
              for (final item in preset.specStylerItems)
                'lib/ui/components/$item.dart',
            ]..sort(),
          },
        },
      },
    },
  };
  if (preset.specStylerItems.isEmpty && buildConfig.existsSync()) {
    return _Failure('consumer build.yaml is unnecessary for ${preset.name}');
  }
  if (preset.specStylerItems.isNotEmpty &&
      (!buildConfig.existsSync() ||
          _canonicalYaml(loadYaml(buildConfig.readAsStringSync())) !=
              _canonicalYaml(expected))) {
    return _Failure(
      'consumer build.yaml does not match the scoped Agent builder contract',
    );
  }
  final uiRoot = Directory('${app.path}/lib/ui');
  if (!uiRoot.existsSync()) {
    return _Failure('remix_cli created no lib/ui directory');
  }

  final found =
      uiRoot
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .map((file) => _relativePath(uiRoot, file))
          .toList()
        ..sort();
  final expectedFiles = [...preset.installedUiFiles]..sort();
  final problems = <String>[];
  for (final relative in expectedFiles) {
    if (!found.contains(relative)) problems.add('installed UI lacks $relative');
  }
  for (final relative in found) {
    if (!expectedFiles.contains(relative)) {
      problems.add('installed UI has an unexpected file: $relative');
    }
  }
  problems.addAll(
    _installedReferenceProblems(
      uiRoot,
      preset.installedUiFiles.toSet(),
      preset,
    ),
  );

  if (problems.isEmpty) return null;
  return _Failure(
    'installed UI violates the registry boundary:\n'
    '${problems.map((problem) => '  - $problem').join('\n')}',
  );
}

List<String> _installedReferenceProblems(
  Directory uiRoot,
  Set<String> installedUiFiles,
  _PresetContract preset,
) {
  final directive = RegExp(
    r'''^\s*(?:import|export|part(?:\s+of)?)\s+([^;]+);''',
    multiLine: true,
  );
  final quotedUri = RegExp(r'''(?:'([^']*)'|"([^"]*)")''');
  final problems = <String>[];

  for (final file
      in uiRoot
          .listSync(recursive: true, followLinks: false)
          .whereType<File>()
          .where((candidate) => candidate.path.endsWith('.dart'))) {
    final relative = _relativePath(uiRoot, file);
    for (final match in directive.allMatches(file.readAsStringSync())) {
      for (final uriMatch in quotedUri.allMatches(match.group(1)!)) {
        final uri = uriMatch.group(1) ?? uriMatch.group(2)!;
        final problem = _referenceProblem(
          uri,
          from: relative,
          installedUiFiles: installedUiFiles,
          allowedPackages: preset.allowedImportPackages,
        );
        if (problem != null) problems.add('$relative: $problem');
      }
    }
  }
  return problems;
}

String? _referenceProblem(
  String uri, {
  required String from,
  required Set<String> installedUiFiles,
  required List<String> allowedPackages,
}) {
  if (uri.startsWith('dart:')) return null;
  if (uri.startsWith('package:')) {
    final package = uri.substring('package:'.length).split('/').first;
    if (allowedPackages.contains(package)) return null;
    return 'imports package:$package, which is outside the registry contract';
  }
  if (uri.contains(':')) return 'uses the non-relative URI `$uri`';
  if (uri.startsWith('/')) return 'uses the absolute path `$uri`';

  final resolved = Uri.parse(from).resolve(uri).path;
  if (resolved.startsWith('..') || resolved.startsWith('/')) {
    return '`$uri` escapes lib/ui';
  }
  if (!installedUiFiles.contains(resolved)) {
    return '`$uri` resolves to $resolved, which is not installed';
  }
  return null;
}

_Failure? _verifyGeneratedFixture({
  required Directory app,
  required Directory fixtureRoot,
  required _PresetContract preset,
}) {
  for (final entry in preset.generatedSnapshots.entries) {
    final generated = File('${app.path}/${entry.key}');
    if (!generated.existsSync()) {
      return _Failure('generation produced no ${entry.key}');
    }
    final expected = File('${fixtureRoot.path}/${entry.value}');
    if (!_sameBytes(expected.readAsBytesSync(), generated.readAsBytesSync())) {
      return _Failure(
        '${entry.key} differs from open_code/${preset.fixtureDirectory}/'
        '${entry.value}. '
        'Regenerate with --keep and review the diff; do not hand-edit '
        'generated source.',
      );
    }
  }
  return null;
}

_Failure? _verifyCheckoutPackages({
  required Map<String, String> packages,
  required Directory repositoryRoot,
  required Map<String, Directory> expected,
}) {
  final repository = repositoryRoot.resolveSymbolicLinksSync();
  final problems = <String>[];

  for (final entry in packages.entries) {
    final directory = Directory(entry.value);
    if (!directory.existsSync()) continue;
    final resolved = directory.resolveSymbolicLinksSync();
    if (!_isWithin(resolved, repository) && resolved != repository) continue;

    final expectedDirectory = expected[entry.key];
    if (expectedDirectory == null) {
      problems.add('${entry.key} unexpectedly resolves inside the checkout');
    }
  }

  for (final entry in expected.entries) {
    final root = packages[entry.key];
    if (root == null) {
      problems.add('${entry.key} is absent from package_config.json');
      continue;
    }
    final actual = Directory(root).resolveSymbolicLinksSync();
    final wanted = entry.value.resolveSymbolicLinksSync();
    if (actual != wanted) {
      problems.add('${entry.key} resolves to $actual, expected $wanted');
    }
  }

  if (problems.isEmpty) return null;
  return _Failure(
    'checkout package boundary failed:\n'
    '${problems.map((problem) => '  - $problem').join('\n')}',
  );
}

void _replaceSkeleton({
  required Directory app,
  required Directory fixtureRoot,
}) {
  final lib = Directory('${app.path}/lib');
  if (lib.existsSync()) lib.deleteSync(recursive: true);
  final tests = Directory('${app.path}/test');
  if (tests.existsSync()) tests.deleteSync(recursive: true);
  final lock = File('${app.path}/pubspec.lock');
  if (lock.existsSync()) lock.deleteSync();
  final build = File('${app.path}/build.yaml');
  if (build.existsSync()) build.deleteSync();

  for (final relative in _fixtureAppFiles) {
    final target = File('${app.path}/$relative');
    target.parent.createSync(recursive: true);
    File('${fixtureRoot.path}/$relative').copySync(target.path);
  }
}

Object _readPackageConfig(Directory app) {
  final file = File('${app.path}/.dart_tool/package_config.json');
  if (!file.existsSync()) {
    return _Failure('pub get produced no .dart_tool/package_config.json');
  }
  final decoded = jsonDecode(file.readAsStringSync());
  if (decoded is! Map || decoded['packages'] is! List) {
    return _Failure('package_config.json is not in the expected shape');
  }

  final roots = <String, String>{};
  for (final entry in decoded['packages'] as List) {
    if (entry is! Map) continue;
    final name = entry['name'];
    final rootUri = entry['rootUri'];
    if (name is! String || rootUri is! String) continue;
    roots[name] = rootUri.startsWith('file:')
        ? Uri.parse(rootUri).toFilePath()
        : file.parent.uri.resolve(rootUri).toFilePath();
  }
  return roots;
}

Map<String, String> _toolchainEnvironment(_Toolchain sdk) => {
  'PATH':
      '${sdk.root}/bin${Platform.isWindows ? ';' : ':'}'
      '${Platform.environment['PATH'] ?? ''}',
};

bool _isHostedCachePath(String path) {
  final separator = Platform.pathSeparator;
  return path.contains('${separator}hosted$separator');
}

_Failure? _verifyDeletableParent(Directory parent, Directory repositoryRoot) {
  final problems = <String>[];
  final resolved = parent.resolveSymbolicLinksSync();
  final temp = Directory.systemTemp.resolveSymbolicLinksSync();
  final repository = repositoryRoot.resolveSymbolicLinksSync();

  if (!_isWithin(resolved, temp)) problems.add('$resolved is not inside $temp');
  if (_isWithin(resolved, repository) || resolved == repository) {
    problems.add('$resolved is inside the repository');
  }
  if (!_basename(resolved).startsWith('remix_open_code_')) {
    problems.add('$resolved was not created by this checker');
  }
  if (FileSystemEntity.isLinkSync(parent.path)) {
    problems.add('$resolved is a symbolic link');
  }

  if (problems.isEmpty) return null;
  return _Failure(
    'refusing to use a temporary directory that cannot be proven safe:\n'
    '${problems.map((problem) => '  - $problem').join('\n')}',
  );
}

_Failure? _deleteVerifiedParent(Directory parent, Directory repositoryRoot) {
  final guard = _verifyDeletableParent(parent, repositoryRoot);
  if (guard != null) return guard;
  parent.deleteSync(recursive: true);
  return null;
}

bool _isWithin(String path, String parent) =>
    path.startsWith(parent.endsWith('/') ? parent : '$parent/');

String _basename(String path) => path.split(Platform.pathSeparator).last;

/// Runs a process, streaming its output to this process' stdio.
///
/// Concurrent callers pass a [log] instead: inherited stdio from several
/// processes at once interleaves into an unreadable log, so the output goes to
/// the buffer for the caller to emit as one block.
Future<_Failure?> _runProcess(
  String executable,
  List<String> arguments, {
  required String workingDirectory,
  Map<String, String>? environment,
  StringSink? log,
}) async {
  final harness = environment?['REMIX_REGISTRY_CONSUMER_CLI'];
  if (harness != null &&
      arguments.length >= 2 &&
      arguments[0] == 'run' &&
      arguments[1] == 'remix_cli:remix') {
    arguments = [harness, ...arguments.skip(2)];
  }
  (log ?? stdout).writeln('\$ $executable ${arguments.join(' ')}');
  final Process process;
  try {
    process = await Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      mode: log == null
          ? ProcessStartMode.inheritStdio
          : ProcessStartMode.normal,
    );
  } on ProcessException catch (error) {
    return _Failure('could not start `$executable`: ${error.message}');
  }
  // A process that fills a pipe nobody reads never exits, and one that reads
  // stdin never would, so stdin is closed and both pipes are drained alongside
  // the exit code.
  const decoder = Utf8Decoder(allowMalformed: true);
  final drained = <Future<Object?>>[
    if (log != null) ...[
      process.stdin.close(),
      process.stdout.transform(decoder).forEach(log.write),
      process.stderr.transform(decoder).forEach(log.write),
    ],
  ];
  final code = await process.exitCode;
  await Future.wait(drained);
  if (code == 0) return null;
  return _Failure('`$executable ${arguments.join(' ')}` exited $code');
}

Map<String, Map<String, Object?>> _dependencySections(String pubspec) {
  const sectionNames = {
    'dependencies',
    'dev_dependencies',
    'dependency_overrides',
  };
  final document = loadYaml(pubspec);
  if (document is! YamlMap) return const {};

  final parsed = <String, Map<String, Object?>>{};
  for (final section in sectionNames) {
    if (!document.containsKey(section)) continue;
    final node = document[section];
    parsed[section] = {
      if (node is YamlMap)
        for (final entry in node.entries) entry.key.toString(): entry.value,
    };
  }
  return parsed;
}

String _relativePath(Directory root, File file) =>
    file.path.substring(root.path.length + 1);

bool _sameBytes(List<int> left, List<int> right) {
  if (left.length != right.length) return false;
  for (var index = 0; index < left.length; index += 1) {
    if (left[index] != right[index]) return false;
  }
  return true;
}

_PresetContract _presetByName(String name) => switch (name) {
  'vanilla' => _defaultPreset,
  'fortal' => _fortalPreset,
  'heroui' => _herouiPreset,
  _ => throw ArgumentError.value(
    name,
    'preset',
    'must be vanilla, fortal, or heroui',
  ),
};

/// Returns the fixture contract error for focused regression tests.
String? fixtureContractProblem(
  Directory fixtureRoot, {
  String preset = 'vanilla',
}) => _verifyFixtureContract(fixtureRoot, _presetByName(preset))?.message;

/// Returns the catalog-drift error for focused regression tests.
String? registryCoverageProblem(
  Directory repositoryRoot, {
  String preset = 'vanilla',
}) => _verifyRegistryCoverage(repositoryRoot, _presetByName(preset))?.message;

/// Returns installed inventory/import errors for focused regression tests.
String? installedUiProblem(Directory app, {String preset = 'vanilla'}) =>
    _verifyInstalledUi(app, _presetByName(preset))?.message;

/// Returns the hosted runtime dependencies a preset's installed app declares
/// before the registry under test names its icon packages.
List<String> requiredRuntimeDependenciesForTest(String preset) =>
    _presetByName(preset).requiredRuntimeDependencies;

/// Runs the production independent-install boundary with a fixture CLI harness.
Future<String?> independentItemsProblemForTest(
  Directory app, {
  required int jobs,
  required Map<String, String> environment,
}) async => (await _checkIndependentItems(
  sdk: _Toolchain(
    version: Platform.version,
    root: File(Platform.resolvedExecutable).parent.parent.path,
    flutter: '', // Independent installs invoke Dart, not Flutter.
    dart: Platform.resolvedExecutable,
  ),
  app: app,
  preset: _defaultPreset,
  environment: environment,
  jobs: jobs,
))?.message;

/// Returns the items a preset installs alone, for focused regression tests.
List<String> independentInstallsForTest(
  String preset, {
  Directory? repositoryRoot,
}) => _presetByName(preset).independentInstalls(repositoryRoot);

/// The install contract for [preset] against one registry's [iconsYaml]:
/// the runtime dependencies an installed app must declare, and the packages a
/// checkout install resolves from this tree.
({List<String> runtime, List<String> imports, Set<String> checkout})
iconContractForTest(
  String preset,
  String iconsYaml, {
  String iconLibrary = 'remix',
  String checkoutIconsVersion = '1.0.0-beta.1',
}) {
  final contract = _presetByName(preset).forIcons(
    iconsYaml,
    iconLibrary,
    checkoutIconsVersion: checkoutIconsVersion,
  );
  return (
    runtime: contract.requiredRuntimeDependencies,
    imports: contract.allowedImportPackages,
    checkout: _checkoutPackages(
      Directory('packages/remix'),
      contract,
    ).keys.toSet(),
  );
}

/// Returns the expected installed UI inventory for focused regression tests.
List<String> installedUiFilesForTest({String preset = 'vanilla'}) =>
    _presetByName(preset).installedUiFiles;

/// Returns exact focused-install inventory errors for checker regression tests.
List<String> focusedInventoryProblemsForTest(
  String item,
  Set<String> found, {
  String preset = 'vanilla',
}) => _focusedInventoryProblems(
  expected: _presetByName(preset).focusedUiFiles(item).toSet(),
  found: found,
);

/// Returns the independent expected inventory for a focused consumer check.
Set<String> focusedInventoryForTest(String item, {String preset = 'vanilla'}) =>
    _presetByName(preset).focusedUiFiles(item).toSet();

/// Formats a post-creation failure so the retained directory is always named.
String retainedFailureMessage(
  Directory parent,
  Object problem, {
  StackTrace? stackTrace,
}) {
  final String message;
  if (problem is _Failure) {
    message = problem.message;
  } else {
    final stack = stackTrace == null ? '' : '\n$stackTrace';
    message = 'unexpected exception: $problem$stack';
  }
  return '$message\nTemporary application preserved at ${parent.path}';
}

_Failure _retainedFailure(
  Directory parent,
  Object problem, {
  StackTrace? stackTrace,
}) => _Failure(
  retainedFailureMessage(parent, problem, stackTrace: stackTrace),
  exitCode: problem is _Failure ? problem.exitCode : 1,
);

void _step(String message, [StringSink? sink]) =>
    (sink ?? stdout).writeln('✓ $message');

final class _Toolchain {
  const _Toolchain({
    required this.version,
    required this.root,
    required this.flutter,
    required this.dart,
  });

  final String version;
  final String root;
  final String flutter;
  final String dart;
}

final class _Failure {
  const _Failure(this.message, {this.exitCode = 1});

  final String message;
  final int exitCode;
}

String _canonicalYaml(Object? value) {
  if (value is Map) {
    final keys = value.keys.cast<String>().toList()..sort();
    return '{${keys.map((key) => '${jsonEncode(key)}:${_canonicalYaml(value[key])}').join(',')}}';
  }
  if (value is List) return '[${value.map(_canonicalYaml).join(',')}]';
  return jsonEncode(value);
}
