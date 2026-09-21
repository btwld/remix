import 'dart:io';

import 'package:test/test.dart';

import '../../tool/check_open_code.dart' as checker;

void main() {
  late Directory sandbox;

  setUp(() {
    sandbox = Directory.systemTemp.createTempSync('open_code_tool_test_');
  });

  tearDown(() {
    if (sandbox.existsSync()) sandbox.deleteSync(recursive: true);
  });

  test('every invocation shipped in CI and docs actually parses', () {
    // The parser is the gate for combinations the checker cannot honour -- a
    // focused --item asserts the checkout resolves Remix locally, so it cannot
    // pair with --source hosted. A release workflow that names an impossible
    // pair only fails when a real release fires, so assert the shipped
    // commands here instead.
    final sources = [
      'pubspec.yaml',
      'open_code/RELEASING.md',
      // Both extensions: the repository uses `.yml` and `.yaml`, and a
      // workflow this skipped would be exactly the blind spot the test exists
      // to remove.
      for (final file in Directory('.github/workflows').listSync())
        if (file is File &&
            (file.path.endsWith('.yml') || file.path.endsWith('.yaml')))
          file.path,
    ];
    final invocation = RegExp(r'check_open_code\.dart([^\n]*)');
    var checked = 0;
    for (final path in sources) {
      final file = File(path);
      if (!file.existsSync()) continue;
      for (final match in invocation.allMatches(file.readAsStringSync())) {
        final arguments = match
            .group(1)!
            .trim()
            .split(RegExp(r'\s+'))
            .where((argument) => argument.isNotEmpty)
            .toList();
        expect(
          checker.parseConsumerCheckOptions(arguments),
          isNotNull,
          reason: '$path: check_open_code.dart ${arguments.join(' ')}',
        );
        checked += 1;
      }
    }
    expect(checked, greaterThan(4), reason: 'found no invocations to check');
  });

  group('consumer source selection', () {
    test('the default retains hosted and checkout validation', () {
      final options = checker.parseConsumerCheckOptions([])!;

      expect(options.source, checker.RemixSource.both);
      expect(options.preset, 'vanilla');
      expect(options.keep, isFalse);
      expect(options.hostedCli, isFalse);
      expect(options.item, isNull);
    });

    test('either preset can select an explicit source', () {
      for (final preset in ['vanilla', 'fortal']) {
        for (final source in checker.RemixSource.values) {
          final options = checker.parseConsumerCheckOptions([
            '--preset',
            preset,
            '--source',
            source.name,
            '--keep',
          ])!;

          expect(options.source, source);
          expect(options.preset, preset);
          expect(options.keep, isTrue);
        }
      }
    });

    test('invalid or repeated source choices fail instead of falling back', () {
      for (final arguments in [
        ['--source'],
        ['--source', 'missing'],
        ['--source', 'hosted', '--source', 'checkout'],
        ['--preset', 'fortal', '--source', 'missing'],
        ['--hosted-cli'],
        ['--source', 'checkout', '--hosted-cli'],
        ['--source', 'hosted', '--hosted-cli', '--hosted-cli'],
      ]) {
        expect(checker.parseConsumerCheckOptions(arguments), isNull);
      }
    });

    test('hosted CLI validation requires an explicit hosted Remix source', () {
      final options = checker.parseConsumerCheckOptions([
        '--hosted-cli',
        '--source',
        'hosted',
        '--preset',
        'fortal',
      ])!;

      expect(options.hostedCli, isTrue);
      expect(options.source, checker.RemixSource.hosted);
      expect(options.preset, 'fortal');
    });

    test('focused dashboard_demo checks require the checkout source', () {
      for (final item in ['dashboard_demo', 'dashboard_shell']) {
        final options = checker.parseConsumerCheckOptions([
          '--source',
          'checkout',
          '--item',
          item,
          '--preset',
          'fortal',
          '--keep',
        ])!;
        expect(options.item, item);
        expect(options.source, checker.RemixSource.checkout);
        expect(options.keep, isTrue);
      }

      for (final arguments in [
        ['--item', 'dashboard_demo'],
        ['--source', 'hosted', '--item', 'dashboard_demo'],
        ['--source', 'checkout', '--item', 'missing'],
        ['--source', 'checkout', '--item'],
        [
          '--source',
          'checkout',
          '--item',
          'dashboard_demo',
          '--item',
          'dashboard_shell',
        ],
      ]) {
        expect(checker.parseConsumerCheckOptions(arguments), isNull);
      }
    });
  });

  test('explicit item inventories support grouped non-generated recipes', () {
    expect(
      checker.registryItemInventoryForTest(
        'dashboard_shell',
        explicitFiles: [
          'recipes/dashboard/dashboard_navigation.dart',
          'recipes/dashboard/dashboard_shell_base.dart',
          'recipes/dashboard/dashboard_shell.dart',
        ],
        nonGenerated: true,
      ),
      [
        'recipes/dashboard/dashboard_navigation.dart',
        'recipes/dashboard/dashboard_shell_base.dart',
        'recipes/dashboard/dashboard_shell.dart',
      ],
    );
    expect(checker.registryItemInventoryForTest('button'), [
      'components/button.dart',
      'components/button.g.dart',
    ]);
    expect(
      checker.registryItemInventoryForTest(
        'dashboard_demo',
        explicitFiles: [
          'recipes/dashboard/dashboard_sample_data.dart',
          'recipes/dashboard/dashboard_overview_base.dart',
          'recipes/dashboard/dashboard_demo_base.dart',
          'recipes/dashboard/dashboard_demo_content.dart',
          'recipes/dashboard/dashboard_demo_chat.dart',
          'recipes/dashboard/dashboard_demo_charts.dart',
          'recipes/dashboard/dashboard_demo_records.dart',
          'recipes/dashboard/dashboard_overview.dart',
          'recipes/dashboard/dashboard_demo_galleries.dart',
          'recipes/dashboard/dashboard_demo_records_page.dart',
          'recipes/dashboard/dashboard_demo_settings.dart',
          'recipes/dashboard/dashboard_demo.dart',
        ],
        nonGenerated: true,
      ),
      hasLength(12),
    );
  });

  test('focused dashboard_demo inventory rejects a missing recipe file', () {
    final installed = checker.focusedInventoryForTest('dashboard_demo');
    installed.remove('recipes/dashboard/dashboard_overview_base.dart');

    expect(
      checker.focusedInventoryProblemsForTest('dashboard_demo', installed),
      ['focused install lacks recipes/dashboard/dashboard_overview_base.dart'],
    );
  });

  test('the committed fixture is the minimal pre-install contract', () {
    final fixture = Directory('${Directory.current.path}/open_code/fixture');

    expect(checker.fixtureContractProblem(fixture), isNull);
  });

  test('the Fortal fixture is also an isolated pre-install contract', () {
    final fixture = Directory(
      '${Directory.current.path}/open_code/fortal_fixture',
    );

    expect(checker.fixtureContractProblem(fixture, preset: 'fortal'), isNull);
  });

  group('registry coverage', () {
    test('the checkout catalog and the checker agree', () {
      expect(checker.registryCoverageProblem(Directory.current), isNull);
    });

    test('the Fortal catalog and the checker agree', () {
      expect(
        checker.registryCoverageProblem(Directory.current, preset: 'fortal'),
        isNull,
      );
    });

    test('an item the checker never installs is reported', () {
      final root = Directory('${sandbox.path}/repo');
      final registry = File('${root.path}/registry/vanilla/registry.yaml');
      registry.parent.createSync(recursive: true);
      registry.writeAsStringSync('''
schema: 1
items:
  theme:
    files:
      - source: templates/theme/tokens.dart.tmpl
        target: "@ui/theme/tokens.dart"
  brand_new:
    files:
      - source: templates/brand_new/brand_new.dart.tmpl
        target: "@ui/components/brand_new.dart"
''');

      final problem = checker.registryCoverageProblem(root);

      expect(problem, contains('registry.yaml has brand_new'));
      // The reverse direction is reported too, so a removed item cannot leave
      // the checker installing something that no longer exists.
      expect(problem, contains('this check installs button'));
    });
  });

  group('fixture contract', () {
    test('requires every committed generated adapter', () {
      const snapshots = [
        'expected/acme_button.g.dart',
        'expected/acme_chart.g.dart',
        'expected/acme_tabs.g.dart',
      ];

      for (var index = 0; index < snapshots.length; index += 1) {
        final fixture = Directory('${sandbox.path}/fixture$index');
        _writeValidFixture(fixture);
        File('${fixture.path}/${snapshots[index]}').deleteSync();

        expect(
          checker.fixtureContractProblem(fixture),
          contains('${snapshots[index]} is missing'),
          reason: snapshots[index],
        );
      }
    });

    test('rejects a consumer build.yaml', () {
      final fixture = Directory('${sandbox.path}/fixture');
      _writeValidFixture(fixture);
      File('${fixture.path}/build.yaml').writeAsStringSync('targets: {}\n');

      expect(
        checker.fixtureContractProblem(fixture),
        contains('declares a consumer build.yaml'),
      );
    });

    test('rejects dependencies that bypass CLI installation', () {
      final fixture = Directory('${sandbox.path}/fixture');
      _writeValidFixture(fixture);
      File('${fixture.path}/pubspec.yaml').writeAsStringSync('''
name: open_code_fixture
dependencies:
  flutter:
    sdk: flutter
  remix: ^1.0.0-beta.7
dev_dependencies:
  flutter_test:
    sdk: flutter
''');

      expect(
        checker.fixtureContractProblem(fixture),
        contains('unexpected runtime dependency remix'),
      );
    });

    test('rejects dependency overrides', () {
      final fixture = Directory('${sandbox.path}/fixture');
      _writeValidFixture(fixture);
      File('${fixture.path}/pubspec.yaml').writeAsStringSync('''
name: open_code_fixture
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_test:
    sdk: flutter
dependency_overrides:
  remix:
    path: ../../packages/remix
''');

      expect(
        checker.fixtureContractProblem(fixture),
        contains('declares dependency_overrides'),
      );
    });
  });

  group('installed UI boundary', () {
    test(
      'accepts exact registry output and scoped Agent builder configuration',
      () {
        final app = Directory('${sandbox.path}/app');
        _writeInstalledUi(app);

        expect(checker.installedUiProblem(app), isNull);
      },
    );

    test('rejects unexpected consumer builder configuration', () {
      final app = Directory('${sandbox.path}/app');
      _writeInstalledUi(app);
      File('${app.path}/build.yaml').writeAsStringSync('targets: {}\n');

      expect(
        checker.installedUiProblem(app),
        contains('does not match the scoped Agent builder contract'),
      );
    });

    test('rejects an extra installed file', () {
      final app = Directory('${sandbox.path}/app');
      _writeInstalledUi(app);
      File('${app.path}/lib/ui/surprise.dart').writeAsStringSync('library;\n');

      expect(
        checker.installedUiProblem(app),
        contains('unexpected file: surprise.dart'),
      );
    });

    test('checks every URI in conditional directives', () {
      final app = Directory('${sandbox.path}/app');
      _writeInstalledUi(app);
      File('${app.path}/lib/ui/ui.dart').writeAsStringSync('''
import 'package:flutter/widgets.dart'
    if (dart.library.io) 'package:unexpected_package/io.dart'
    if (dart.library.html) '../../outside.dart';
''');

      final problem = checker.installedUiProblem(app);

      expect(problem, contains('imports package:unexpected_package'));
      expect(problem, contains('`../../outside.dart` escapes lib/ui'));
    });
  });

  test('retained failure reporting includes the temporary directory', () {
    expect(
      checker.retainedFailureMessage(sandbox, StateError('synthetic failure')),
      allOf(
        contains('synthetic failure'),
        contains('Temporary application preserved at ${sandbox.path}'),
      ),
    );
  });
}

void _writeValidFixture(Directory fixture) {
  const files = [
    'analysis_options.yaml',
    'lib/main.dart',
    'test/open_code_test.dart',
    'expected/acme_button.g.dart',
    'expected/acme_chart.g.dart',
    'expected/acme_tabs.g.dart',
  ];
  for (final relative in files) {
    final file = File('${fixture.path}/$relative');
    file.parent.createSync(recursive: true);
    file.writeAsStringSync('');
  }
  File('${fixture.path}/pubspec.yaml').writeAsStringSync('''
name: open_code_fixture
dependencies:
  flutter:
    sdk: flutter
dev_dependencies:
  flutter_test:
    sdk: flutter
''');
}

/// Mirrors the checker's own item list; kept here so a new registry item that
/// the checker forgot still shows up as a failing boundary test.
const _registryItems = <String>[
  'icons',
  'accordion',
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
  'activity',
  'answer',
  'composer',
  'execution',
  'message',
  'permission',
  'plan',
  'transcript',
  'activity_recipe',
  'answer_recipe',
  'composer_recipe',
  'execution_recipe',
  'message_recipe',
  'permission_recipe',
  'plan_recipe',
  'transcript_recipe',
];

/// Items with no generated adapter: layouts and other plain compositions
/// that install with no `Spec` and no `part '*.g.dart';`.
const _nonGeneratedRegistryItems = <String>['sidebar_layout'];

void _writeInstalledUi(Directory app) {
  final files = [
    'ui.dart',
    'theme/tokens.dart',
    'theme/theme_data.dart',
    'theme/theme_scope.dart',
    'models/activity_item.dart',
    'models/plan_item.dart',
    'models/statuses.dart',
    'support/disclosure.dart',
    'support/functional_glyph.dart',
    'support/live_edge.dart',
    for (final item in _registryItems)
      ...(item == 'dashboard_demo'
          ? const [
              'recipes/dashboard/dashboard_sample_data.dart',
              'recipes/dashboard/dashboard_overview_base.dart',
              'recipes/dashboard/dashboard_demo_base.dart',
              'recipes/dashboard/dashboard_demo_content.dart',
              'recipes/dashboard/dashboard_demo_chat.dart',
              'recipes/dashboard/dashboard_demo_charts.dart',
              'recipes/dashboard/dashboard_demo_records.dart',
              'recipes/dashboard/dashboard_overview.dart',
              'recipes/dashboard/dashboard_demo_galleries.dart',
              'recipes/dashboard/dashboard_demo_records_page.dart',
              'recipes/dashboard/dashboard_demo_settings.dart',
              'recipes/dashboard/dashboard_demo.dart',
            ]
          : item == 'dashboard_shell'
          ? const [
              'recipes/dashboard/dashboard_shell_base.dart',
              'recipes/dashboard/dashboard_shell.dart',
            ]
          : item == 'icons'
          ? const ['icons.dart']
          : item.endsWith('_recipe')
          ? ['recipes/$item.dart']
          : [
              'components/$item.dart',
              if (!_nonGeneratedRegistryItems.contains(item))
                'components/$item.g.dart',
            ]),
  ];
  app.createSync(recursive: true);
  File('${app.path}/build.yaml').writeAsStringSync('''targets:
  \$default:
    builders:
      mix_generator:spec_styler_generator:
        enabled: true
        generate_for:
          - lib/ui/components/activity.dart
          - lib/ui/components/answer.dart
          - lib/ui/components/composer.dart
          - lib/ui/components/execution.dart
          - lib/ui/components/message.dart
          - lib/ui/components/permission.dart
          - lib/ui/components/plan.dart
          - lib/ui/components/transcript.dart
''');
  for (final relative in files) {
    final file = File('${app.path}/lib/ui/$relative');
    file.parent.createSync(recursive: true);
    file.writeAsStringSync('library;\n');
  }
}
