import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

import '../../packages/remix_cli/lib/src/registry_source.dart';
import '../../tool/check_open_code.dart' as checker;
import '../../tool/check_pub_floors.dart';
import '../../tool/check_published_cli.dart';
import '../../tool/compile_registry_consumer.dart';
import '../../tool/consumer_check_reporting.dart';
import '../../tool/install_pins.dart';
import '../../tool/open_code_lifecycle.dart';

void main() {
  late Directory sandbox;

  setUp(() {
    sandbox = Directory.systemTemp.createTempSync('open_code_tool_test_');
  });

  tearDown(() {
    if (sandbox.existsSync()) sandbox.deleteSync(recursive: true);
  });

  group('pub.dev floor preflight', () {
    test('hosted pin is exact and rejects path or extra override leaks', () {
      final floor = checker.registryRemixFloor(Directory.current, 'vanilla');
      checker.writeHostedFloorOverride(sandbox, floor: floor);
      expect(checker.hostedFloorOverrideProblem(sandbox, floor: floor), isNull);
      final file = File('${sandbox.path}/pubspec_overrides.yaml');
      expect(
        (loadYaml(file.readAsStringSync()) as YamlMap)['dependency_overrides'],
        {'remix': floor},
      );
      for (final declaration in [
        'dependency_overrides:\n  remix: ^$floor\n',
        'dependency_overrides:\n  remix: {path: ../remix}\n',
        'dependency_overrides:\n  remix: $floor\n  mix: 2.3.1\n',
        'dependency_overrides:\n  remix: $floor\nresolution: workspace\n',
      ]) {
        file.writeAsStringSync(declaration);
        expect(
          checker.hostedFloorOverrideProblem(sandbox, floor: floor),
          contains('exact hosted version'),
        );
      }
      file.deleteSync();
      expect(
        checker.hostedFloorOverrideProblem(sandbox, floor: floor),
        contains('missing'),
      );
    });
    late Directory registry;
    setUp(() {
      registry = Directory('${sandbox.path}/registry')..createSync();
      for (final preset in ['vanilla', 'fortal', 'heroui']) {
        final catalog = File('${registry.path}/$preset/registry.yaml');
        catalog.parent.createSync();
        catalog.writeAsStringSync("""
items:
  theme:
    dependencies: {remix: ^1.0.0-beta.18, flutter: {sdk: flutter}}
    devDependencies: {mix_generator: ^2.2.0-beta.3}
""");
      }
      File('${registry.path}/icons.yaml').writeAsStringSync("""
libraries:
  remix: {dependency: {remix_ui_icons: ^1.0.0-beta.1}}
""");
    });
    _FakePubClient client({String? missing, bool newer = false}) =>
        _FakePubClient((uri) async {
          final package = uri.pathSegments.last;
          final version = readHostedFloors(registry)[package]!.single;
          return (
            statusCode: 200,
            body: jsonEncode({
              'versions': [
                if (package != missing) {'version': version},
                if (newer && package == 'remix') {'version': '1.0.0-beta.19'},
              ],
            }),
          );
        });
    test(
      'present floors include generators and icons and query each package once',
      () async {
        final http = client();
        expect(await checkPubFloors(registry, client: http), isNull);
        expect(
          http.requests.map((uri) => uri.path),
          unorderedEquals([
            '/api/packages/remix',
            '/api/packages/mix_generator',
            '/api/packages/remix_ui_icons',
          ]),
        );
        expect(
          http.requests.every(
            (uri) => uri.host == 'pub.dev' && uri.scheme == 'https',
          ),
          isTrue,
        );
      },
    );
    test(
      'missing floor explains publication order before creating any app',
      () async {
        expect(
          await checkPubFloors(registry, client: client(missing: 'remix')),
          'remix ^1.0.0-beta.18 is not on pub.dev yet; push tag v1.0.0-beta.18, wait for the Publish workflow, then re-run Promote registry',
        );
        expect(
          await checkPubFloors(
            registry,
            client: client(missing: 'mix_generator'),
          ),
          contains('publish the required dependency upstream'),
        );
      },
    );
    test(
      '404 means missing while server and network errors stay distinct',
      () async {
        expect(
          await checkPubFloors(
            registry,
            client: _FakePubClient(
              (_) async => (statusCode: 404, body: 'not found'),
            ),
          ),
          contains('not on pub.dev yet'),
        );
        expect(
          await checkPubFloors(
            registry,
            client: _FakePubClient(
              (_) async => (statusCode: 503, body: 'unavailable'),
            ),
          ),
          contains('HTTP 503'),
        );
        final error = await checkPubFloors(
          registry,
          client: _FakePubClient(
            (_) async => throw const SocketException('fixture offline'),
          ),
        );
        expect(error, contains('fixture offline'));
        expect(error, isNot(contains('not on pub.dev yet')));
      },
    );
    test('a newer prerelease fails the separate freshness check', () async {
      expect(
        await checkPubFloors(registry, client: client(newer: true)),
        contains('older than published 1.0.0-beta.19'),
      );
    });
    test(
      'stable floors may predate newest Remix, but must be published',
      () async {
        final floors = readCatalogHostedFloors([
          'items: {theme: {dependencies: {remix: ^1.0.0-beta.18}}}',
        ]);
        expect(
          await checkPubPackageFloors(
            floors,
            client: client(newer: true),
            requireLatestRemix: false,
          ),
          isNull,
        );
        expect(
          await checkPubPackageFloors(
            floors,
            client: client(missing: 'remix'),
            requireLatestRemix: false,
          ),
          contains('not on pub.dev yet'),
        );
      },
    );

    test('every current catalog has hosted floors', () {
      expect(
        readHostedFloors(Directory('registry')).keys,
        containsAll([
          'remix',
          'mix_annotations',
          'mix_generator',
          'build_runner',
          'remix_ui_fonts',
          'remix_ui_icons',
          'lucide_flutter',
        ]),
      );
    });
  });

  group('published CLI candidate', () {
    final cliPin = expectedInstallPin(Directory.current, 'remix_cli');
    final cliVersion = cliPin.substring(1);
    _FakePubClient publishedCli() => _FakePubClient(
      (_) async => (
        statusCode: 200,
        body: jsonEncode({
          'versions': [
            {'version': cliVersion},
          ],
        }),
      ),
    );

    test('workflow never activates remix_cli without the documented pin', () {
      final workflow = File(
        '.github/workflows/registry.yml',
      ).readAsStringSync();
      final failures = <String>[];
      checkInstallPins(workflow, '.github/workflows/registry.yml', {
        'remix_cli': expectedInstallPin(Directory.current, 'remix_cli'),
      }, failures);
      expect(failures, isEmpty);
    });

    test(
      'activates the exact published version before creating an app',
      () async {
        final app = Directory('${sandbox.path}/app');
        final commands = <List<String>>[];
        final sha = 'a' * 40;
        expect(
          await checkPublishedCliCandidate(
            app: app,
            repositoryRoot: Directory.current,
            preset: 'vanilla',
            sha: sha,
            dart: 'fake-dart',
            flutter: 'fake-flutter',
            pubClient: publishedCli(),
            run: (executable, args, {capturedOutput}) async {
              capturedOutput?.writeln(cliVersion);
              commands.add([executable, ...args]);
              if (args.first == 'create') app.createSync();
              if (args.contains('update')) {
                File('${app.path}/remix.yaml').writeAsStringSync(
                  'registries: {"@remix": {revision: "$sha"}}',
                );
              }
              return null;
            },
          ),
          isNull,
        );
        expect(commands.first, [
          'fake-dart',
          'pub',
          'global',
          'activate',
          'remix_cli',
          cliVersion,
        ]);
      },
    );

    test(
      'every preset uses the activated CLI and repins before installing',
      () async {
        for (final preset in ['vanilla', 'fortal', 'heroui']) {
          final app = Directory('${sandbox.path}/released_$preset');
          final commands = <List<String>>[];
          final sha = 'a' * 40;
          expect(
            await checkPublishedCliCandidate(
              app: app,
              repositoryRoot: Directory.current,
              preset: preset,
              sha: sha,
              dart: 'fake-dart',
              flutter: 'fake-flutter',
              pubClient: publishedCli(),
              run: (executable, args, {capturedOutput}) async {
                capturedOutput?.writeln(cliVersion);
                commands.add([executable, ...args]);
                if (args.first == 'create') app.createSync();
                if (args.contains('update')) {
                  File('${app.path}/remix.yaml').writeAsStringSync(
                    'registries: {"@remix": {revision: "$sha"}}',
                  );
                }
                return null;
              },
            ),
            isNull,
          );
          expect(commands.map((command) => command.first), [
            'fake-dart',
            'fake-dart',
            'fake-flutter',
            'fake-dart',
            'fake-dart',
            'fake-dart',
            'fake-dart',
            'fake-dart',
          ]);
          expect(
            commands[4],
            containsAllInOrder([
              'pub',
              'global',
              'run',
              'remix_cli:remix',
              'init',
            ]),
          );
          expect(
            commands[5],
            containsAllInOrder(['registry', 'update', '@remix', '--ref', sha]),
          );
          expect(
            commands[6],
            containsAllInOrder([
              'pub',
              'global',
              'run',
              'remix_cli:remix',
              'add',
              preset == 'heroui' ? 'search_field' : 'dashboard_shell',
              'button',
            ]),
          );
          expect(commands.last, ['fake-dart', 'analyze', 'lib/ui']);
          expect(
            commands.expand((command) => command).join(' '),
            isNot(contains('registry_consumer_cli')),
          );
        }
        final workflow = File(
          '.github/workflows/registry.yml',
        ).readAsStringSync();
        expect(
          installCommands(workflow).where((c) => c.package == 'remix_cli'),
          isEmpty,
        );
        expect(
          workflow,
          contains(
            r'check_published_cli.dart --preset ${{ matrix.preset }} --ref ${{ github.sha }}',
          ),
        );
      },
    );
    test('failure stops the published CLI lane without falling back', () async {
      var calls = 0;
      expect(
        await checkPublishedCliCandidate(
          app: sandbox,
          repositoryRoot: Directory.current,
          preset: 'vanilla',
          sha: 'a' * 40,
          dart: 'fake-dart',
          flutter: 'fake-flutter',
          pubClient: publishedCli(),
          run: (_, args, {capturedOutput}) async {
            capturedOutput?.writeln(cliVersion);
            calls++;
            return args.contains('update')
                ? 'unsupported by published CLI'
                : null;
          },
        ),
        'unsupported by published CLI',
      );
      expect(calls, 6);
    });
    test(
      'branch names cannot silently spend the candidate API budget',
      () async {
        expect(
          await checkPublishedCliCandidate(
            app: sandbox,
            repositoryRoot: Directory.current,
            preset: 'vanilla',
            sha: 'main',
            dart: 'fake-dart',
            flutter: 'fake-flutter',
            run: (_, _, {capturedOutput}) async =>
                throw StateError('must not execute'),
          ),
          contains('full lowercase candidate SHA'),
        );
      },
    );
    test(
      'a successful update must actually select the candidate revision',
      () async {
        File(
          '${sandbox.path}/remix.yaml',
        ).writeAsStringSync('registries: {"@remix": {revision: "old"}}');
        expect(
          await checkPublishedCliCandidate(
            app: sandbox,
            repositoryRoot: Directory.current,
            preset: 'vanilla',
            sha: 'a' * 40,
            dart: 'fake-dart',
            flutter: 'fake-flutter',
            pubClient: publishedCli(),
            run: (_, _, {capturedOutput}) async {
              capturedOutput?.writeln(cliVersion);
              return null;
            },
          ),
          contains('did not pin @remix'),
        );
      },
    );
  });

  group('quiet process reporting', () {
    test('CLI compilation uses the same quiet tracked runner', () async {
      final out = StringBuffer();
      final processes = OpenCodeProcesses(
        startProcess:
            (
              _,
              args, {
              String? workingDirectory,
              Map<String, String>? environment,
              required ProcessStartMode mode,
            }) async {
              expect(mode, ProcessStartMode.normal);
              expect(args.take(2), ['compile', 'kernel']);
              File(args.last).writeAsStringSync('fixture kernel');
              final child = _ReportingProcess();
              child.output.add(utf8.encode('compiler details'));
              unawaited(child.output.close());
              unawaited(child.errors.close());
              child.completed.complete(0);
              return child;
            },
      );
      final snapshot = await compileRegistryConsumerCli(
        dart: 'fake-dart',
        repositoryRoot: sandbox,
        outputDirectory: sandbox,
        processes: processes,
        reporter: ConsumerCheckReporter(out: out, err: out),
      );
      expect(snapshot.readAsStringSync(), 'fixture kernel');
      expect(out.toString(), startsWith('ok compile CLI ('));
      expect(out.toString(), isNot(contains('compiler details')));
    });
    Future<String?> child(
      StringBuffer out, {
      int code = 0,
      bool verbose = false,
      StringSink? capturedOutput,
      StringSink? capturedStdout,
    }) async {
      final script = File('${sandbox.path}/output.dart')
        ..writeAsStringSync('''
import 'dart:io';
void main() {
  stdout.writeln('child stdout');
  stderr.writeln('child stderr');
  exitCode = $code;
}
''');
      return ConsumerCheckReporter(out: out, err: out, verbose: verbose).run(
        OpenCodeProcesses(),
        Platform.resolvedExecutable,
        [script.path],
        workingDirectory: sandbox.path,
        step: 'add fixture',
        capturedOutput: capturedOutput,
        capturedStdout: capturedStdout,
      );
    }

    test('success prints only one timing line', () async {
      final out = StringBuffer();
      expect(await child(out), isNull);
      expect(out.toString(), matches(r'^ok add fixture \(\d+\.\d s\)\n$'));
      expect(out.toString(), isNot(contains('ERROR')));
    });
    test('captures successful child output for version assertions', () async {
      final out = StringBuffer();
      final captured = StringBuffer();
      expect(await child(out, capturedOutput: captured), isNull);
      expect(captured.toString(), contains('child stdout'));
      expect(captured.toString(), contains('child stderr'));
      expect(out.toString(), isNot(contains('child stdout')));
    });
    test(
      'captures stdout separately while preserving full failure logs',
      () async {
        for (final code in [0, 7]) {
          final out = StringBuffer();
          final combined = StringBuffer();
          final captured = StringBuffer();
          final problem = await child(
            out,
            code: code,
            capturedOutput: combined,
            capturedStdout: captured,
          );
          expect(problem, code == 0 ? isNull : contains('exited 7'));
          expect(captured.toString(), 'child stdout\n');
          expect(combined.toString(), contains('child stdout'));
          expect(combined.toString(), contains('child stderr'));
          if (code != 0) {
            expect(out.toString(), contains('child stdout'));
            expect(out.toString(), contains('child stderr'));
          }
        }
      },
    );
    test('failure prints full stdout and stderr and the exit code', () async {
      final out = StringBuffer();
      expect(await child(out, code: 7), contains('exited 7'));
      expect(out.toString(), contains('child stdout'));
      expect(out.toString(), contains('child stderr'));
      expect(out.toString(), isNot(contains('ok add')));
    });
    test('verbose streams child output and parses once', () async {
      expect(checker.parseConsumerCheckOptions(['--verbose'])!.verbose, isTrue);
      expect(checker.parseConsumerCheckOptions([])!.verbose, isFalse);
      expect(
        checker.parseConsumerCheckOptions(['--verbose', '--verbose']),
        isNull,
      );
      final out = StringBuffer();
      expect(await child(out, verbose: true), isNull);
      expect(out.toString(), contains('child stdout'));
      expect(out.toString(), contains('child stderr'));
    });
    test('verbose bypasses pool buffers before the child finishes', () async {
      final child = _ReportingProcess();
      final processes = OpenCodeProcesses(
        startProcess:
            (
              _,
              _, {
              String? workingDirectory,
              Map<String, String>? environment,
              required ProcessStartMode mode,
            }) async => child,
      );
      final out = StringBuffer();
      final pooledLog = StringBuffer();
      final pending = ConsumerCheckReporter(out: out, err: out, verbose: true)
          .run(
            processes,
            'fake',
            ['add', 'fixture'],
            workingDirectory: sandbox.path,
            log: pooledLog,
          );
      await _settle();
      child.output.add(utf8.encode('live stdout\n'));
      child.errors.add(utf8.encode('live stderr\n'));
      await _settle();
      expect(out.toString(), contains('live stdout'));
      expect(out.toString(), contains('live stderr'));
      expect(pooledLog.toString(), isEmpty);
      expect(child.completed.isCompleted, isFalse);
      await child.output.close();
      await child.errors.close();
      child.completed.complete(0);
      expect(await pending, isNull);
    });
    test('phases close and timing summaries append on success and failure', () {
      final summary = File('${sandbox.path}/summary.md')
        ..writeAsStringSync('earlier\n');
      final out = StringBuffer();
      final reporter = ConsumerCheckReporter(
        out: out,
        err: out,
        githubActions: true,
        summaryFile: summary,
      );
      reporter.startPhase('Setup');
      reporter.startPhase('Gallery');
      reporter.failure('actual failure\nwith details%');
      reporter.finish('fixture');
      expect(out.toString(), contains('::group::Setup\n::endgroup::'));
      expect(out.toString(), contains('::group::Gallery'));
      expect(
        out.toString(),
        contains('::error::actual failure%0Awith details%25'),
      );
      expect(out.toString().split('::endgroup::'), hasLength(3));
      expect(summary.readAsStringSync(), startsWith('earlier\n'));
      expect(summary.readAsStringSync(), contains('| Phase | Time |'));
      expect(summary.readAsStringSync(), contains('| Setup |'));
      expect(summary.readAsStringSync(), contains('| Gallery |'));
    });
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
            .replaceAll(r'${{ matrix.preset }}', 'vanilla')
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

  test('promotion validates static contracts and every hosted preset', () {
    final jobs =
        (loadYaml(File('.github/workflows/registry.yml').readAsStringSync())
                as YamlMap)['jobs']
            as YamlMap;
    final hosted = jobs['hosted'] as YamlMap;
    expect(hosted['timeout-minutes'], 20);
    expect(hosted['strategy']['fail-fast'], isFalse);
    expect(hosted['strategy']['matrix']['preset'], [
      'vanilla',
      'fortal',
      'heroui',
    ]);
    expect(jobs['promote']['needs'], ['static', 'hosted']);
    expect(jobs['promote']['if'], "github.ref == 'refs/heads/main'");
    final staticSteps = jobs['static']['steps'].toString();
    for (final command in [
      'build_registry.dart --check',
      'check_dependency_constraints.dart',
      'check_version_alignment.dart',
      'build_registry_test.dart',
      'build_registry_agent_test.dart',
      'dart test',
    ]) {
      expect(staticSteps, contains(command));
    }
    expect(
      hosted['steps'].toString(),
      contains('check_open_code.dart --preset'),
    );
    expect(hosted['steps'].toString(), isNot(contains('melos run')));
    final scripts =
        (loadYaml(File('pubspec.yaml').readAsStringSync())
                as YamlMap)['melos']['scripts']
            as YamlMap;
    for (final preset in ['vanilla', 'fortal', 'heroui']) {
      expect(
        scripts['open-code:release:check:$preset']['run'],
        contains('--source hosted'),
      );
    }
    expect(scripts['open-code:release:check']['steps'], hasLength(3));
  });

  group('consumer source selection', () {
    test(
      'hosted fast modes stay below ten init calls and release smoke uses three',
      () {
        var canaryCalls = 0;
        var checkoutCalls = 0;
        for (final preset in ['vanilla', 'fortal', 'heroui']) {
          canaryCalls += checker.plannedInitCalls(
            checker.parseConsumerCheckOptions([
              '--source',
              'hosted',
              '--preset',
              preset,
            ])!,
          );
          checkoutCalls += checker.plannedInitCalls(
            checker.parseConsumerCheckOptions([
              '--source',
              'checkout',
              '--preset',
              preset,
            ])!,
          );
        }
        expect(canaryCalls, 6);
        expect(canaryCalls, lessThan(10));
        expect(checkoutCalls, greaterThan(10));
        final scripts =
            (loadYaml(File('pubspec.yaml').readAsStringSync())
                    as YamlMap)['melos']['scripts']
                as YamlMap;
        final commands =
            scripts['open-code:release:check']['steps'] as YamlList;
        var smokeCalls = 0;
        for (final command in commands.cast<String>()) {
          final options = checker.parseConsumerCheckOptions(
            command.split('check_open_code.dart ').last.split(' '),
          )!;
          expect(options.source, checker.RemixSource.hosted);
          expect(options.independent, checker.IndependentMode.none);
          expect(options.install, checker.InstallMode.batch);
          smokeCalls += checker.plannedInitCalls(options);
        }
        expect(smokeCalls, 3);
        expect(smokeCalls, lessThan(10));
        final workflow = File(
          '.github/workflows/publish.yml',
        ).readAsStringSync();
        expect(workflow, contains("REMIX_REGISTRY_RELEASE_SMOKE: '1'"));
        expect(workflow, contains('melos run open-code:release:check'));
      },
    );
    test('hosted batches the gallery after two incremental adds', () {
      for (final source in checker.RemixSource.values) {
        expect(
          checker.parseConsumerCheckOptions(['--source', source.name])!.install,
          source == checker.RemixSource.hosted
              ? checker.InstallMode.batch
              : checker.InstallMode.incremental,
        );
      }
      for (final mode in checker.InstallMode.values) {
        expect(
          checker.parseConsumerCheckOptions(['--install', mode.name])!.install,
          mode,
        );
      }
      for (final args in [
        ['--install'],
        ['--install', 'bad'],
        ['--install', 'batch', '--install', 'incremental'],
      ]) {
        expect(checker.parseConsumerCheckOptions(args), isNull);
      }
      const items = ['theme_user', 'generated', 'chart', 'dashboard', 'last'];
      expect(checker.galleryInstallBatches(items, checker.InstallMode.batch), [
        ['theme_user'],
        ['generated'],
        ['chart', 'dashboard', 'last'],
      ]);
      expect(
        checker.galleryInstallBatches(items, checker.InstallMode.incremental),
        items.map((item) => [item]).toList(),
      );
      for (var length = 0; length <= items.length; length++) {
        final subset = items.take(length).toList();
        final batches = checker.galleryInstallBatches(
          subset,
          checker.InstallMode.batch,
        );
        expect(batches.expand((batch) => batch), subset);
        expect(batches.every((batch) => batch.isNotEmpty), isTrue);
      }
    });
    test('independent defaults follow the selected source', () {
      for (final source in checker.RemixSource.values) {
        final options = checker.parseConsumerCheckOptions([
          '--source',
          source.name,
        ])!;
        expect(
          options.independent,
          source == checker.RemixSource.hosted
              ? checker.IndependentMode.canary
              : checker.IndependentMode.all,
        );
        for (final mode in checker.IndependentMode.values) {
          expect(
            checker.parseConsumerCheckOptions([
              '--source',
              source.name,
              '--independent',
              mode.name,
            ])!.independent,
            mode,
          );
        }
      }
      for (final args in [
        ['--independent'],
        ['--independent', 'bad'],
        ['--independent', 'all', '--independent', 'none'],
      ]) {
        expect(checker.parseConsumerCheckOptions(args), isNull);
      }
      for (final preset in ['vanilla', 'fortal', 'heroui']) {
        final canary = checker.independentInstallItems(
          preset,
          mode: checker.IndependentMode.canary,
        );
        expect(canary, [
          preset == 'heroui' ? 'search_field' : 'dashboard_shell',
        ]);
        expect(checker.independentInstallsForTest(preset), containsAll(canary));
        expect(
          checker.independentInstallItems(
            preset,
            mode: checker.IndependentMode.none,
          ),
          isEmpty,
        );
        expect(
          checker.independentInstallItems(
            preset,
            mode: checker.IndependentMode.all,
          ),
          checker.independentInstallsForTest(preset),
        );
      }
    });
    test('the default retains hosted and checkout validation', () {
      final options = checker.parseConsumerCheckOptions([])!;

      expect(options.source, checker.RemixSource.both);
      expect(options.preset, 'vanilla');
      expect(options.keep, isFalse);
      expect(options.hostedCli, isFalse);
      expect(options.item, isNull);
    });

    test('every preset can select an explicit source', () {
      for (final preset in ['vanilla', 'fortal', 'heroui']) {
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

  test(
    'ownership consumer check requires Vanilla checkout and the checkout CLI',
    () {
      expect(
        checker.parseConsumerCheckOptions([
          '--source',
          'checkout',
          '--item',
          'ownership',
        ])!.item,
        'ownership',
      );
      for (final arguments in [
        ['--item', 'ownership'],
        ['--source', 'hosted', '--item', 'ownership'],
        ['--source', 'checkout', '--preset', 'fortal', '--item', 'ownership'],
        ['--source', 'checkout', '--hosted-cli', '--item', 'ownership'],
      ]) {
        expect(checker.parseConsumerCheckOptions(arguments), isNull);
      }
    },
  );

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

  test(
    'production independent installs dispatch up to the requested jobs',
    () async {
      final app = Directory('${sandbox.path}/app')..createSync();
      File('${app.path}/pubspec.yaml').writeAsStringSync('''
name: dispatch_probe
environment:
  sdk: '>=3.10.0 <4.0.0'
''');
      final probe = Directory('${sandbox.path}/probe')..createSync();
      final release = File('${probe.path}/release');
      final harness = File('${sandbox.path}/cli.dart')
        ..writeAsStringSync(r'''
import 'dart:io';

Future<void> main(List<String> arguments) async {
  if (arguments.first == 'init') {
    final root = Platform.environment['REMIX_DISPATCH_PROBE']!;
    final item = Directory.current.uri.pathSegments.where((s) => s.isNotEmpty).last;
    File('$root/$item.started').writeAsStringSync('started');
    while (!File('$root/release').existsSync()) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  }
  Directory('lib/ui').createSync(recursive: true);
}
''');
      final result = checker.independentItemsProblemForTest(
        app,
        jobs: 2,
        environment: {
          'REMIX_REGISTRY_CONSUMER_CLI': harness.path,
          'REMIX_DISPATCH_PROBE': probe.path,
        },
      );
      int started() => probe
          .listSync()
          .whereType<File>()
          .where((file) => file.path.endsWith('.started'))
          .length;
      var overlapping = 0;
      try {
        final deadline = Stopwatch()..start();
        while (started() < 2 &&
            deadline.elapsed < const Duration(seconds: 10)) {
          await Future<void>.delayed(const Duration(milliseconds: 20));
        }
        overlapping = started();
      } finally {
        // Always release and await children, including when dispatch is serial.
        release.writeAsStringSync('continue');
      }
      expect(await result, isNull);
      expect(
        overlapping,
        2,
        reason:
            'the production checker must start two installs before either completes',
      );
      expect(
        started(),
        greaterThan(2),
        reason: 'remaining items were dispatched',
      );
    },
    timeout: const Timeout(Duration(minutes: 2)),
  );

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

    test(
      "an earlier input's failure outlasts a later input's exception",
      () async {
        final result = checker.runPooled<int, String>(
          [0, 1],
          limit: 2,
          out: out,
          work: (input, log) async {
            if (input == 1) throw StateError('later input');
            return tasks.run(input, log);
          },
        );
        await _settle();

        tasks.finish(0, 'first input');

        expect(await result, 'first input');
      },
    );

    test(
      "an earlier input's exception outlasts a later input's failure",
      () async {
        final result = checker.runPooled<int, String>(
          [0, 1],
          limit: 2,
          out: out,
          work: (input, log) async {
            if (input == 1) return 'later input';
            await _settle();
            await _settle();
            throw StateError('first input');
          },
        );

        await expectLater(result, throwsA(isA<StateError>()));
      },
    );

    test('cancellation stops dispatch, waits and keeps ordered logs', () async {
      var cancelled = false;
      var settled = false;
      final result = checker
          .runPooled<int, String>(
            [0, 1, 2, 3],
            limit: 2,
            out: out,
            work: tasks.run,
            isCancelled: () => cancelled,
          )
          .whenComplete(() => settled = true);
      await _settle();
      cancelled = true;
      tasks.finish(1);
      await _settle();
      expect(tasks.started, [0, 1]);
      expect(settled, isFalse);
      expect(out.toString(), isEmpty);
      tasks.finish(0);
      expect(await result, isNull);
      expect(out.toString(), 'log 0;log 1;');
    });

    test('a limit below one is rejected instead of running nothing', () {
      for (final limit in [0, -1]) {
        expect(pool(3, limit: limit), throwsArgumentError);
      }
      expect(tasks.started, isEmpty);
    });
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

  test('the complete Rounded library is available to a fresh consumer', () {
    final options = checker.parseConsumerCheckOptions([
      '--source',
      'checkout',
      '--icon-library',
      'rounded',
    ])!;
    expect(options.iconLibrary, 'rounded');
    final table = File('registry/icons.yaml').readAsStringSync();
    expect(checker.iconPackagesFor(table, 'rounded'), ['remix_ui_icons']);
    expect(checker.iconPackagesFor(table, 'remix'), ['remix_ui_icons']);
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
    // HeroUI mirrors Vanilla's file set: the shared base and five preset
    // files, plus the shell's two.
    final herouiDemo = checker.focusedInventoryForTest(
      'dashboard_demo',
      preset: 'heroui',
    );
    expect(
      herouiDemo.where((path) => path.startsWith('recipes/dashboard/')),
      hasLength(13),
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

  group('independent installs', () {
    test('Vanilla and Fortal install the Agent and dashboard items alone', () {
      for (final preset in ['vanilla', 'fortal']) {
        final items = checker.independentInstallsForTest(preset);

        expect(items, hasLength(preset == 'fortal' ? 23 : 19), reason: preset);
        if (preset == 'fortal') {
          expect(
            items,
            containsAll([
              'calendar',
              'range_calendar',
              'date_picker',
              'date_range_picker',
            ]),
          );
        }
        expect(items, contains('range_slider'));
        expect(
          items,
          containsAll(['activity', 'transcript_recipe', 'dashboard_demo']),
          reason: preset,
        );
      }
    });

    test('HeroUI installs alone only the items with a multi-item closure', () {
      // Every fresh `remix init` is one unauthenticated GitHub API request, so
      // the list stays short: these are the items that depend on another item
      // besides the theme, and they include every item that uses an icon.
      expect(
        checker.independentInstallsForTest('heroui'),
        unorderedEquals([
          'avatar_group',
          'breadcrumbs',
          'button',
          'button_group',
          'calendar',
          'range_calendar',
          'date_picker',
          'date_range_picker',
          'checkbox_group',
          'close_button',
          'combobox',
          'dashboard_shell',
          'input_group',
          'radio_group',
          'range_slider',
          'search_field',
          'sidebar',
          'sidebar_layout',
          'switch_group',
          'table',
          'textarea',
          'toast',
          'toggle_button_group',
          'activity_recipe',
          'answer_recipe',
          'composer_recipe',
          'execution_recipe',
          'message_recipe',
          'permission_recipe',
          'plan_recipe',
          'transcript_recipe',
          'dashboard_demo',
        ]),
      );
    });

    test('a derived list follows the registry dependencies', () {
      final root = Directory('${sandbox.path}/repo');
      final registry = File('${root.path}/registry/heroui/registry.yaml');
      registry.parent.createSync(recursive: true);
      registry.writeAsStringSync('''
schema: 2
items:
  theme:
    files: []
  solo:
    registryDependencies:
      - theme
    files: []
  base:
    files: []
  composite:
    registryDependencies:
      - theme
      - base
    files: []
  uses_composite:
    registryDependencies:
      - composite
    files: []
''');

      expect(
        checker.independentInstallsForTest('heroui', repositoryRoot: root),
        ['composite', 'uses_composite'],
      );
    });
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

  group('icon reinstall documentation', () {
    for (final preset in ['vanilla', 'fortal', 'heroui']) {
      test('$preset commands cover every item with icon placeholders', () {
        final registry = File('registry/$preset/registry.yaml');
        final catalog = loadYaml(registry.readAsStringSync()) as YamlMap;
        final items = catalog['items'] as YamlMap;
        final expected = <String>{};
        for (final entry in items.entries) {
          final item = entry.value as YamlMap;
          final files = item['files'] as YamlList? ?? [];
          if (files.any(
            (file) => File(
              'registry/$preset/${file['source']}',
            ).readAsStringSync().contains('{{icon:'),
          )) {
            expected.add(entry.key as String);
          }
        }
        expect(expected, containsAll(['date_picker', 'date_range_picker']));
        for (final path in [
          'docs/open-code/catalog.mdx',
          'skills/using-remix/references/cli.md',
        ]) {
          final commands = RegExp(
            r'^remix add (icons .+) --(diff|overwrite)',
            multiLine: true,
          ).allMatches(File(path).readAsStringSync()).toList();
          final selected = preset == 'heroui'
              ? commands.skip(2)
              : commands.take(2);
          expect(selected, hasLength(2), reason: '$path/$preset');
          for (final command in selected) {
            expect(
              command.group(1)!.split(' ').toSet(),
              expected,
              reason: '$path/$preset/${command.group(2)}',
            );
          }
        }
      });
    }
  });

  group('fixture contract', () {
    test('full Vanilla staging includes every committed fixture test', () {
      final fixture = Directory('open_code/fixture');
      checker.stageFixtureForTest(app: sandbox, fixtureRoot: fixture);

      for (final file in Directory('${fixture.path}/test').listSync()) {
        if (file is! File || !file.path.endsWith('_test.dart')) continue;
        final target = File(
          '${sandbox.path}/test/${file.uri.pathSegments.last}',
        );
        expect(target.readAsStringSync(), file.readAsStringSync());
      }
    });

    for (final preset in ['vanilla', 'fortal', 'heroui']) {
      test('$preset focused staging excludes gallery-only recipe tests', () {
        final directory = preset == 'vanilla' ? 'fixture' : '${preset}_fixture';
        final fixture = Directory('open_code/$directory');
        for (final item in [
          if (preset == 'vanilla') ...['icons', 'ownership'],
          if (preset == 'heroui') 'search_field',
          'dashboard_shell',
          'dashboard_demo',
        ]) {
          checker.stageFixtureForTest(
            app: sandbox,
            fixtureRoot: fixture,
            preset: preset,
            item: item,
          );

          expect(
            Directory(
              '${sandbox.path}/test',
            ).listSync().map((file) => file.uri.pathSegments.last),
            unorderedEquals(['open_code_test.dart', 'theme_modes_test.dart']),
            reason: '$preset --item $item',
          );
        }
      });
    }

    for (final preset in ['vanilla', 'fortal', 'heroui']) {
      test('$preset requires every committed fixture test', () {
        final directory = preset == 'vanilla' ? 'fixture' : '${preset}_fixture';
        final source = Directory('open_code/$directory');
        final fixture = Directory('${sandbox.path}/$directory');
        for (final entity
            in source.listSync(recursive: true).whereType<File>()) {
          final relative = entity.path.substring(source.path.length + 1);
          final target = File('${fixture.path}/$relative');
          target.parent.createSync(recursive: true);
          entity.copySync(target.path);
        }
        final tests = Directory('${fixture.path}/test')
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('_test.dart'));
        for (final file in tests) {
          final contents = file.readAsBytesSync();
          file.deleteSync();
          expect(
            checker.fixtureContractProblem(fixture, preset: preset),
            contains('${file.uri.pathSegments.last} is missing'),
            reason: file.path,
          );
          file.writeAsBytesSync(contents);
        }
      });
    }

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

  test(
    'Vanilla and HeroUI require their delivered fonts in a full install',
    () {
      expect(
        checker.requiredRuntimeDependenciesForTest('vanilla'),
        contains('remix_ui_fonts'),
      );
      expect(
        checker.requiredRuntimeDependenciesForTest('heroui'),
        contains('remix_ui_fonts'),
      );
      expect(
        checker.requiredRuntimeDependenciesForTest('fortal'),
        isNot(contains('remix_ui_fonts')),
      );
    },
  );

  test(
    'HeroUI has its own small fixture, catalog, and dependency contract',
    () {
      expect(
        checker.fixtureContractProblem(
          Directory('open_code/heroui_fixture'),
          preset: 'heroui',
        ),
        isNull,
      );
      expect(
        checker.registryCoverageProblem(Directory.current, preset: 'heroui'),
        isNull,
      );
      expect(
        checker.requiredRuntimeDependenciesForTest('heroui'),
        unorderedEquals([
          'remix',
          'mix_annotations',
          'mix_chart',
          'remix_ui_fonts',
          'remix_ui_icons',
        ]),
      );
      // The Agent components are `@MixableSpec` source, so HeroUI installs
      // the same scoped spec builder as the other presets.
      final app = Directory('${sandbox.path}/heroui');
      _writeInstalledUi(app, preset: 'heroui');
      expect(checker.installedUiProblem(app, preset: 'heroui'), isNull);
      File('${app.path}/build.yaml').writeAsStringSync('targets: {}\n');
      expect(
        checker.installedUiProblem(app, preset: 'heroui'),
        contains('scoped Agent builder contract'),
      );
      // HeroUI now ships the demo, as an extension; only Vanilla checks
      // its icon aliases and ownership alone.
      expect(
        checker.parseConsumerCheckOptions([
          '--preset',
          'heroui',
          '--source',
          'checkout',
          '--item',
          'dashboard_demo',
        ])!.item,
        'dashboard_demo',
      );
      expect(
        checker.parseConsumerCheckOptions([
          '--preset',
          'heroui',
          '--source',
          'checkout',
          '--item',
          'icons',
        ]),
        isNull,
      );
    },
  );

  test('HeroUI CI runs a focused web build beside the full install', () {
    expect(
      checker.parseConsumerCheckOptions([
        '--preset',
        'heroui',
        '--source',
        'checkout',
        '--item',
        'search_field',
      ])!.item,
      'search_field',
    );
    for (final arguments in [
      ['--preset', 'heroui', '--source', 'hosted', '--item', 'search_field'],
      ['--preset', 'fortal', '--source', 'checkout', '--item', 'search_field'],
      ['--source', 'checkout', '--item', 'search_field'],
    ]) {
      expect(checker.parseConsumerCheckOptions(arguments), isNull);
    }

    final inventory = checker.focusedInventoryForTest(
      'search_field',
      preset: 'heroui',
    );
    expect(
      inventory,
      containsAll([
        'components/search_field.dart',
        'components/search_field.g.dart',
        'components/close_button.dart',
        'components/spinner.dart',
        'components/textfield.dart',
      ]),
    );
    expect(inventory, isNot(contains('components/toast.dart')));

    expect(
      checker.parseConsumerCheckOptions([
        '--preset',
        'heroui',
        '--source',
        'checkout',
        '--item',
        'dashboard_shell',
      ])!.item,
      'dashboard_shell',
    );
    final shell = checker.focusedInventoryForTest(
      'dashboard_shell',
      preset: 'heroui',
    );
    expect(
      shell,
      containsAll([
        'recipes/dashboard/dashboard_shell.dart',
        'recipes/dashboard/dashboard_shell_base.dart',
        'components/app_bar.dart',
        'components/app_bar.g.dart',
        'components/sidebar.dart',
        'components/sidebar.g.dart',
        'components/sidebar_layout.dart',
        'components/toggle_button.dart',
        'components/tooltip.dart',
        'components/button.dart',
        'components/search_field.dart',
      ]),
    );
    expect(shell, isNot(contains('icons.dart')));
    expect(shell, isNot(contains('components/typography.dart')));

    final demo = checker.focusedInventoryForTest(
      'dashboard_demo',
      preset: 'heroui',
    );
    expect(
      demo,
      containsAll([
        'recipes/dashboard/dashboard_demo.dart',
        'recipes/dashboard/dashboard_demo_records_page.dart',
        'recipes/activity_recipe.dart',
        'components/activity.dart',
        'components/chart.dart',
        'components/table.dart',
        'models/statuses.dart',
        'support/functional_glyph.dart',
      ]),
    );
    expect(demo, isNot(contains('components/typography.dart')));
    // Its segmented choices are RemixSegmentedControl, not a tab list.
    expect(demo, isNot(contains('components/tabs.dart')));

    for (final file in [
      'search_field_main.dart',
      'search_field_test.dart',
      'dashboard_shell_main.dart',
      'dashboard_shell_test.dart',
      'dashboard_demo_main.dart',
      'dashboard_demo_test.dart',
    ]) {
      expect(
        File('open_code/heroui_fixture/focused/$file').existsSync(),
        isTrue,
      );
    }

    const full =
        'dart run tool/check_open_code.dart --preset heroui --source checkout';
    final scripts =
        (loadYaml(File('pubspec.yaml').readAsStringSync())
                as YamlMap)['melos']['scripts']
            as YamlMap;
    for (final script in ['open-code:check', 'ci:open-code:heroui']) {
      expect(
        (scripts[script] as YamlMap)['steps'],
        containsAll([
          '$full --item search_field',
          '$full --item dashboard_shell',
          '$full --item dashboard_demo',
          full,
        ]),
        reason: script,
      );
    }
  });

  group('icon packages follow the registry under test', () {
    // registry-stable as promoted before schema 2: every icon in both
    // libraries, remix_ui_icons floored at 0.1.0, and no Lucide fallback.
    const stable = '''
schema: 1
libraries:
  remix: {dependency: {remix_ui_icons: ^0.1.0}, import: "package:remix_ui_icons/remix_ui_icons.dart", class: RemixIcons}
  lucide: {dependency: {lucide_flutter: ^1.47.0}, import: "package:lucide_flutter/lucide_flutter.dart", class: LucideIcons}
icons:
  check: {remix: check, lucide: check}
  checkCircled: {remix: checkCircled, lucide: circleCheck}
''';
    const candidate = '''
schema: 2
libraries:
  remix: {dependency: {remix_ui_icons: ^1.0.0-beta.1}, import: "package:remix_ui_icons/remix_ui_icons.dart", class: RemixIcons}
  lucide: {dependency: {lucide_flutter: ^1.47.0}, import: "package:lucide_flutter/lucide_flutter.dart", class: LucideIcons}
icons:
  check: {remix: check, lucide: check}
  checkCircled: {lucide: circleCheck, fallback: lucide}
''';

    test('release smoke plans only the installed registry catalog', () {
      // The checkout has many unpromoted items, while stable also retains an
      // item since removed from the checkout. Use stable, not an intersection.
      const catalog = """
items:
  theme:
    dependencies: {remix: ^1.0.0-beta.17}
    files: [{source: theme.dart.tmpl, target: "@ui/theme/theme.dart"}]
  button:
    registryDependencies: [theme]
    dependencies: {stable_runtime: ^2.0.0}
    devDependencies: {stable_generator: ^3.0.0}
    files: [{source: button.dart.tmpl, target: "@ui/components/button.dart"}]
    generated: ["@ui/components/button.g.dart"]
  stable_only:
    registryDependencies: [theme]
    files: [{source: stable.dart.tmpl, target: "@ui/components/stable.dart"}]
""";
      for (final preset in ['vanilla', 'fortal', 'heroui']) {
        final plan = checker.registryPlanForTest(preset, catalog);
        expect(plan.items, ['theme', 'button', 'stable_only']);
        expect(plan.floor, '1.0.0-beta.17');
        expect(plan.runtime.toSet(), {
          'remix',
          'stable_runtime',
          'remix_ui_icons',
        });
        expect(readCatalogHostedFloors([catalog]), {
          'remix': {'1.0.0-beta.17'},
          'stable_runtime': {'2.0.0'},
          'stable_generator': {'3.0.0'},
        });
        expect(
          checker
              .galleryInstallBatches(plan.items, checker.InstallMode.batch)
              .expand((batch) => batch),
          plan.items,
        );
        expect(plan.files.toSet(), {
          'ui.dart',
          'theme/theme.dart',
          'components/button.dart',
          'components/button.g.dart',
          'components/stable.dart',
        });
      }
    });

    test(
      'smoke reads the CLI pin via the registry index without branch races',
      () async {
        _writePinnedRegistryConfig(sandbox);
        final requests = <Uri>[];
        final registry = await checker.readInstalledRegistryCatalog(
          sandbox,
          transport: (uri) async {
            requests.add(uri);
            expect(uri.path, startsWith('/btwld/remix/${'a' * 40}/registry/'));
            return RegistryResponse(200, switch (uri.pathSegments.last) {
              'index.yaml' =>
                'schema: 1\npresets: {vanilla: archived/catalog.yaml}',
              'catalog.yaml' =>
                'items: {theme: {files: [], dependencies: {remix: ^1.0.0}}}',
              'icons.yaml' => stable,
              _ => throw StateError('Unexpected request $uri'),
            });
          },
        );
        expect(requests.map((uri) => uri.pathSegments.last), [
          'index.yaml',
          'catalog.yaml',
          'icons.yaml',
        ]);
        expect(requests[1].path, endsWith('/registry/archived/catalog.yaml'));
        expect(checker.registryPlanForTest('vanilla', registry.catalog).items, [
          'theme',
        ]);
        expect(registry.icons, stable);
      },
    );

    test(
      'missing or unavailable pinned catalogs never fall back to checkout',
      () async {
        _writePinnedRegistryConfig(sandbox);
        for (final status in [404, 503]) {
          await expectLater(
            checker.readInstalledRegistryCatalog(
              sandbox,
              transport: (uri) async {
                return RegistryResponse(
                  uri.pathSegments.last == 'index.yaml' ? 200 : status,
                  'schema: 1\npresets: {vanilla: vanilla/registry.yaml}',
                );
              },
            ),
            throwsA(
              isA<HttpException>().having(
                (error) => error.message,
                'message',
                contains('returned $status'),
              ),
            ),
          );
        }
      },
    );

    test('a CLI release smoke reads registry-stable', () {
      // publish.yml verifies a new CLI against the promoted registry before
      // publishing it, the same registry applications read.
      final workflow = File('.github/workflows/publish.yml').readAsStringSync();
      expect(workflow, contains("REMIX_REGISTRY_RELEASE_SMOKE: '1'"));
      expect(workflow, contains('melos run open-code:release:check'));
      expect(
        checker.publishedRegistryRef(
          hostedCli: false,
          environment: const {'REMIX_REGISTRY_RELEASE_SMOKE': '1'},
        ),
        'registry-stable',
      );
      expect(
        checker.publishedRegistryRef(hostedCli: true, environment: const {}),
        'registry-stable',
      );
      expect(
        checker.publishedRegistryRef(
          hostedCli: false,
          environment: const {'REMIX_REGISTRY_RELEASE_REF': 'abc123'},
        ),
        'abc123',
      );
      expect(
        checker.publishedRegistryRef(hostedCli: false, environment: const {}),
        isNull,
      );
    });

    test('a schema 1 stable registry needs no Lucide and the hosted icons', () {
      for (final preset in ['vanilla', 'fortal', 'heroui']) {
        final contract = checker.iconContractForTest(preset, stable);
        expect(contract.runtime, contains('remix_ui_icons'));
        expect(contract.runtime, isNot(contains('lucide_flutter')));
        expect(contract.imports, isNot(contains('lucide_flutter')));
        // ^0.1.0 excludes the checkout's 1.0.0-beta.1, so even a checkout
        // install resolves the published package.
        expect(contract.checkout, isNot(contains('remix_ui_icons')));
      }
    });

    test('the candidate registry adds Lucide and the checkout icons', () {
      for (final preset in ['vanilla', 'fortal', 'heroui']) {
        final contract = checker.iconContractForTest(preset, candidate);
        expect(
          contract.runtime,
          containsAll(['remix_ui_icons', 'lucide_flutter']),
        );
        expect(
          contract.imports,
          containsAll(['remix_ui_icons', 'lucide_flutter']),
        );
        expect(contract.checkout, contains('remix_ui_icons'));
      }
    });

    test('the lucide library installs Lucide alone from either registry', () {
      for (final icons in [stable, candidate]) {
        final contract = checker.iconContractForTest(
          'vanilla',
          icons,
          iconLibrary: 'lucide',
        );
        expect(contract.runtime, contains('lucide_flutter'));
        expect(contract.runtime, isNot(contains('remix_ui_icons')));
        expect(contract.checkout, isNot(contains('remix_ui_icons')));
      }
    });

    test('icon packages are the library and its fallbacks', () {
      expect(checker.iconPackagesFor(stable, 'remix'), ['remix_ui_icons']);
      expect(checker.iconPackagesFor(candidate, 'remix'), [
        'remix_ui_icons',
        'lucide_flutter',
      ]);
      expect(checker.iconPackagesFor(candidate, 'lucide'), ['lucide_flutter']);
      expect(checker.iconsResolveFromCheckout(stable, '1.0.0-beta.1'), isFalse);
      expect(
        checker.iconsResolveFromCheckout(candidate, '1.0.0-beta.1'),
        isTrue,
      );
    });
  });
}

void _writeValidFixture(Directory fixture) {
  const files = [
    'analysis_options.yaml',
    'lib/main.dart',
    'test/open_code_test.dart',
    'test/theme_modes_test.dart',
    'test/agent_recipe_contract_test.dart',
    'test/composer_recipe_test.dart',
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

final class _ReportingProcess implements Process {
  _ReportingProcess() {
    unawaited(input.stream.drain<void>());
  }
  final completed = Completer<int>();
  final output = StreamController<List<int>>();
  final errors = StreamController<List<int>>();
  final input = StreamController<List<int>>();
  @override
  Future<int> get exitCode => completed.future;
  @override
  Stream<List<int>> get stdout => output.stream;
  @override
  Stream<List<int>> get stderr => errors.stream;
  @override
  late final IOSink stdin = IOSink(input.sink);
  @override
  int get pid => 123456789;
  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) => true;
}

final class _FakePubClient implements PubFloorClient {
  _FakePubClient(this.reply);
  final Future<PubResponse> Function(Uri) reply;
  final requests = <Uri>[];
  @override
  Future<PubResponse> get(Uri uri) {
    requests.add(uri);
    return reply(uri);
  }

  @override
  void close() {}
}

void _writePinnedRegistryConfig(Directory app) {
  File('${app.path}/remix.yaml').writeAsStringSync("""
schema: 3
prefix: Acme
preset: vanilla
paths: {ui: lib/ui}
defaultRegistry: "@remix"
registries:
  "@remix":
    repository: btwld/remix
    path: registry
    ref: registry-stable
    revision: ${'a' * 40}
""");
}
