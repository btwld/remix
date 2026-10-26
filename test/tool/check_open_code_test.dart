import 'dart:async';
import 'dart:io';
import 'dart:math';

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

  group('worker count', () {
    test('--jobs takes a positive integer once', () {
      expect(checker.parseConsumerCheckOptions([])!.jobs, isNull);
      expect(checker.parseConsumerCheckOptions(['--jobs', '3'])!.jobs, 3);

      for (final arguments in [
        ['--jobs'],
        ['--jobs', '0'],
        ['--jobs', '-2'],
        ['--jobs', 'many'],
        ['--jobs', '2', '--jobs', '3'],
        ['--source', 'checkout', '--item', 'dashboard_demo', '--jobs', '2'],
      ]) {
        expect(checker.parseConsumerCheckOptions(arguments), isNull);
      }
    });

    test('defaults to one worker per core, between two and four', () {
      expect(checker.resolveJobs(processors: 1), 2);
      expect(checker.resolveJobs(processors: 3), 3);
      expect(checker.resolveJobs(processors: 64), 4);
    });

    test('the flag overrides the environment, which overrides the default', () {
      expect(
        checker.resolveJobs(requested: 8, fromEnvironment: '2', processors: 4),
        8,
      );
      expect(checker.resolveJobs(fromEnvironment: '6', processors: 4), 6);
    });

    test('an environment value that is not a positive integer is rejected', () {
      for (final value in ['0', '-1', 'four', '']) {
        expect(
          checker.resolveJobs(fromEnvironment: value, processors: 4),
          isNull,
          reason: 'REMIX_OPEN_CODE_JOBS="$value"',
        );
      }
      expect(
        checker.resolveJobs(requested: 2, fromEnvironment: 'x', processors: 4),
        2,
      );
    });
  });

  group('runPooled', () {
    late StringBuffer out;
    late _Tasks tasks;

    setUp(() {
      out = StringBuffer();
      tasks = _Tasks();
    });

    Future<String?> pool(int count, {required int limit}) => checker.runPooled(
      List.generate(count, (index) => index),
      limit: limit,
      out: out,
      work: tasks.run,
    );

    test(
      'writes each log in input order whichever task finishes first',
      () async {
        final result = pool(3, limit: 3);
        await _settle();

        tasks.finish(2);
        await _settle();
        expect(out.toString(), isEmpty, reason: 'input 2 waits for 0 and 1');

        tasks.finish(0);
        await _settle();
        expect(out.toString(), 'log 0;', reason: 'input 1 is still running');

        tasks.finish(1);
        expect(await result, isNull);
        expect(out.toString(), 'log 0;log 1;log 2;');
      },
    );

    test(
      'keeps no more than the limit in flight and refills freed slots',
      () async {
        final result = pool(6, limit: 2);
        await _settle();
        expect(tasks.started, [0, 1]);

        tasks.finish(1);
        await _settle();
        expect(tasks.started, [0, 1, 2]);

        await tasks.finishAll();
        expect(await result, isNull);
        expect(tasks.started, [0, 1, 2, 3, 4, 5]);
        expect(tasks.peak, 2);
      },
    );

    test('a failure starts no more work but waits for running tasks', () async {
      var settled = false;
      final result = pool(5, limit: 2).whenComplete(() => settled = true);
      await _settle();

      tasks.finish(1, 'boom');
      await _settle();
      expect(tasks.started, [0, 1], reason: 'nothing starts after a failure');
      expect(settled, isFalse, reason: 'input 0 is still running');

      tasks.finish(0);
      expect(await result, 'boom');
      expect(
        out.toString(),
        'log 0;log 1;',
        reason: 'the failing log is written after the log before it',
      );
    });

    test(
      'reports the earliest input to fail, not the first to finish',
      () async {
        final result = pool(2, limit: 2);
        await _settle();

        tasks.finish(1, 'second input');
        tasks.finish(0, 'first input');

        expect(await result, 'first input');
      },
    );

    test(
      'an exception stops new work and surfaces once running tasks settle',
      () async {
        final started = <int>[];
        var settled = false;
        final result = checker.runPooled<int, String>(
          [0, 1, 2, 3],
          limit: 2,
          out: out,
          work: (input, log) async {
            started.add(input);
            if (input != 0) return tasks.run(input, log);
            await _settle();
            throw StateError('broken');
          },
        );
        final thrown = expectLater(result, throwsStateError);
        unawaited(thrown.then((_) => settled = true));
        await _settle();
        expect(settled, isFalse, reason: 'input 1 is still running');

        tasks.finish(1);
        await thrown;
        expect(started, [0, 1]);
      },
    );
  });

  test('--icon-library swaps the icon package in the Vanilla contract', () {
    final options = checker.parseConsumerCheckOptions([
      '--source',
      'checkout',
      '--item',
      'icons',
      '--icon-library',
      'lucide',
    ])!;
    expect(options.item, 'icons');
    expect(options.iconLibrary, 'lucide');

    for (final arguments in [
      ['--icon-library', 'missing'],
      ['--icon-library', 'lucide', '--icon-library', 'lucide'],
      ['--source', 'checkout', '--preset', 'fortal', '--item', 'icons'],
    ]) {
      expect(checker.parseConsumerCheckOptions(arguments), isNull);
    }
  });

  test('focused inventories derive grouped recipes from registry.yaml', () {
    final vanillaShell = checker.focusedInventoryForTest('dashboard_shell');
    expect(
      vanillaShell,
      containsAll([
        'recipes/dashboard/dashboard_shell_base.dart',
        'recipes/dashboard/dashboard_shell.dart',
        'components/sidebar_layout.dart',
      ]),
    );
    expect(
      vanillaShell,
      isNot(contains('recipes/dashboard/dashboard_demo.dart')),
    );

    final vanillaDemo = checker.focusedInventoryForTest('dashboard_demo');
    expect(
      vanillaDemo.where((path) => path.startsWith('recipes/dashboard/')),
      hasLength(13),
    );
    final fortalDemo = checker.focusedInventoryForTest(
      'dashboard_demo',
      preset: 'fortal',
    );
    expect(
      fortalDemo.where((path) => path.startsWith('recipes/dashboard/')),
      hasLength(19),
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

    test('permits Vanilla to import its own fonts package', () {
      final app = Directory('${sandbox.path}/app');
      _writeInstalledUi(app);
      File('${app.path}/lib/ui/theme/theme_data.dart').writeAsStringSync('''
import 'package:remix_ui_fonts/remix_ui_fonts.dart';
''');

      expect(checker.installedUiProblem(app), isNull);
    });

    test('does not let Fortal import the fonts package', () {
      final app = Directory('${sandbox.path}/app');
      _writeInstalledUi(app, preset: 'fortal');
      File('${app.path}/lib/ui/theme/theme_data.dart').writeAsStringSync('''
import 'package:remix_ui_fonts/remix_ui_fonts.dart';
''');

      expect(
        checker.installedUiProblem(app, preset: 'fortal'),
        contains(
          'theme/theme_data.dart: imports package:remix_ui_fonts, which is '
          'outside the registry contract',
        ),
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

  test('only Vanilla requires the fonts package in an installed app', () {
    expect(
      checker.requiredRuntimeDependenciesForTest('vanilla'),
      contains('remix_ui_fonts'),
    );
    expect(
      checker.requiredRuntimeDependenciesForTest('fortal'),
      isNot(contains('remix_ui_fonts')),
    );
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

void _writeInstalledUi(Directory app, {String preset = 'vanilla'}) {
  final files = checker.installedUiFilesForTest(preset: preset);
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

Future<void> _settle() => Future<void>.delayed(Duration.zero);

/// Tasks that run until the test finishes them, recording how many overlap.
final class _Tasks {
  final started = <int>[];
  final _gates = <int, Completer<String?>>{};
  var _running = 0;
  var peak = 0;

  Future<String?> run(int input, StringSink log) async {
    started.add(input);
    _running += 1;
    peak = max(peak, _running);
    log.write('log $input;');
    try {
      return await (_gates[input] = Completer<String?>()).future;
    } finally {
      _running -= 1;
    }
  }

  void finish(int input, [String? failure]) => _gates[input]!.complete(failure);

  /// Finishes every task not yet finished, including those started by it.
  Future<void> finishAll() async {
    for (var index = 0; ; index += 1) {
      await _settle();
      if (index >= started.length) return;
      final gate = _gates[started[index]]!;
      if (!gate.isCompleted) gate.complete();
    }
  }
}
