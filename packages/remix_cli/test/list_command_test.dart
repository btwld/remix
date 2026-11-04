import 'dart:convert';
import 'dart:io';

import 'package:remix_cli/src/catalog_listing.dart';
import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/registry.dart';
import 'package:test/test.dart';

import 'checkout_registry.dart';
import 'multi_registry_test.dart' show FixtureRegistries, item;
import 'test_support.dart';

void main() {
  late Directory root;
  late List<String> output;
  late List<String> progress;
  late RecordingProcessRunner runner;
  late Installer installer;

  setUp(() {
    root = createFlutterPackage();
    output = [];
    progress = [];
    runner = RecordingProcessRunner(
      (invocation) => throw StateError('Unexpected ${invocation.display}'),
    );
    installer = Installer(
      projectRoot: root,
      writeOut: output.add,
      writeProgress: progress.add,
      processRunner: runner,
      sources: const FixtureOfficialResolver(),
    );
  });
  tearDown(() => root.deleteSync(recursive: true));

  Future<int> list(List<String> flags, {LineWriter? writeError}) =>
      runInstallerCli(
        ['list', ...flags],
        installer,
        writeOut: output.add,
        writeError: writeError ?? fail,
      );

  Future<void> init() => installer.initialize(
    const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
  );

  test('lists the preset grouped by install directory', () async {
    await init();
    output.clear();
    final before = snapshotFiles(root);
    final catalog = await CheckoutRegistry(
      findCheckoutRegistry(),
      'vanilla',
    ).catalog();

    expect(await list([]), successExitCode);

    final lines = output.single.split('\n');
    expect(lines.first, '@remix (vanilla) revision ${'a' * 40}');
    expect(lines, contains('lib/ui/components/'));
    expect(lines, contains(matches(RegExp(r'^  button +needs theme$'))));
    expect(
      lines.last,
      '${catalog.items.length} items. Install with: remix add <item...>. '
      'Preview first with --dry-run.',
    );
    expect(progress, ['Fetching registry items...']);
    expect(runner.calls, isEmpty);
    expect(snapshotFiles(root), before);
  });

  test('--json is one document with qualified ids', () async {
    await init();
    output.clear();

    expect(await list(['--json']), successExitCode);

    final document = jsonDecode(output.single) as Map<String, Object?>;
    expect(document['preset'], 'vanilla');
    final registry = (document['registries']! as List).single as Map;
    expect(registry['namespace'], '@remix');
    expect(registry['default'], isTrue);
    expect(registry['revision'], 'a' * 40);
    final button = (registry['items'] as List).cast<Map>().singleWhere(
      (item) => item['id'] == '@remix/button',
    );
    expect(button['registryDependencies'], ['@remix/theme']);
    expect(button['group'], 'lib/ui/components');
    expect(button['files'], ['lib/ui/components/button.dart']);
    expect(button['generated'], ['lib/ui/components/button.g.dart']);
  });

  test('before init it names the command to run first', () async {
    final errors = <String>[];

    expect(await list([], writeError: errors.add), failureExitCode);

    expect(errors, ['Run remix init before remix list.']);
    expect(output, isEmpty);
  });

  test('positional arguments are a usage error', () async {
    final errors = <String>[];

    expect(await list(['button'], writeError: errors.add), usageExitCode);

    expect(errors.first, 'list accepts no positional arguments.');
  });

  test('every registry is listed, names as add accepts them', () async {
    final fixture = FixtureRegistries();
    fixture.company['button'] = item('company', ['@remix/button']);
    fixture.save(root);

    await runInstallerCli(
      ['list'],
      Installer(
        projectRoot: root,
        writeOut: output.add,
        sources: fixture.resolver,
      ),
      writeOut: output.add,
      writeError: fail,
    );

    expect(output.single.split('\n'), [
      '@remix (fortal) revision ${'a' * 40}',
      'lib/ui/',
      '  theme',
      '  button  needs theme',
      '@company (fortal) revision ${'b' * 40}',
      'lib/ui/',
      '  @company/button  needs button',
      '3 items. Install with: remix add <item...>. Preview first with --dry-run.',
    ]);
  });

  test('long dependency lists collapse after four names', () {
    final fixture = FixtureRegistries();
    final catalog = RegistryCatalog.parse(
      jsonEncode({
        'schema': 2,
        'items': {
          for (final name in ['a', 'b', 'c', 'd', 'e', 'f']) name: item(name),
          'page': item('page', ['a', 'b', 'c', 'd', 'e', 'f']),
        },
      }),
      preset: 'fortal',
    );

    final text = catalogListingText(fixture.config(root), {'@remix': catalog});

    expect(text, contains('  page  needs a, b, c, d, and 2 more\n'));
  });
}
