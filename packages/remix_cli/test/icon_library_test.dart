import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/process_runner.dart';
import 'package:remix_cli/src/registry_source.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  late Directory root;

  setUp(() => root = createFlutterPackage());
  tearDown(() => root.deleteSync(recursive: true));

  test('schema 2 installs renamed glyphs and fallback dependencies', () async {
    final sources = GitHubSources(
      transport: (uri) async {
        if (uri.host == 'api.github.com') {
          return RegistryResponse(200, '{"sha":"${'a' * 40}"}');
        }
        final contents = switch (uri.pathSegments.last) {
          'index.yaml' =>
            'schema: 1\npresets: {vanilla: vanilla/registry.yaml}',
          'registry.yaml' =>
            '''
schema: 2
items:
  icons:
    files:
      - {source: templates/icons.dart.tmpl, target: "@ui/icons.dart"}
    exports: [icons.dart]
''',
          'icons.yaml' =>
            '''
schema: 2
libraries:
  remix: {dependency: {remix_ui_icons: ^1.0.0-beta.1}, import: package:remix_ui_icons/remix_ui_icons.dart, class: RemixIcons}
  lucide: {dependency: {lucide_flutter: ^1.47.0}, import: package:lucide_flutter/lucide_flutter.dart, class: LucideIcons}
icons:
  magnifyingGlass: {remix: search, lucide: search}
  doubleArrowLeft: {lucide: chevronsLeft, fallback: lucide}
''',
          'icons.dart.tmpl' =>
            '''
{{icon:import}}
const search = {{icon:magnifyingGlass}};
const previous = {{icon:doubleArrowLeft}};
''',
          _ => null,
        };
        return RegistryResponse(contents == null ? 404 : 200, contents ?? '');
      },
    );
    final runner = _choiceRunner(root, remixUiIcons: '1.0.0-beta.1');
    final installer = Installer(
      projectRoot: root,
      writeOut: (_) {},
      processRunner: runner,
      sources: sources,
    );
    await installer.initialize(
      const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
    );
    await installer.add(
      const AddOptions(items: ['icons'], mode: AddMode.write),
    );

    final icons = File('${root.path}/lib/ui/icons.dart').readAsStringSync();
    expect(icons, contains('RemixIcons.search'));
    expect(icons, contains('LucideIcons.chevronsLeft'));
    expect(icons, isNot(contains('RemixIcons.magnifyingGlass')));
    expect(
      icons,
      contains("import 'package:remix_ui_icons/remix_ui_icons.dart';"),
    );
    expect(
      icons,
      contains("import 'package:lucide_flutter/lucide_flutter.dart';"),
    );
    final added = runner.calls
        .map((call) => call.arguments.join(' '))
        .where((command) => command.startsWith('pub add'))
        .join('\n');
    expect(added, contains('remix_ui_icons@^1.0.0-beta.1'));
    expect(added, contains('lucide_flutter@^1.47.0'));
    expect(File('${root.path}/remix.ownership.json').existsSync(), isTrue);
  });

  test(
    'installing icons with lucide uses Lucide and not remix_ui_icons',
    () async {
      await Installer(
        projectRoot: root,
        writeOut: (_) {},
        processRunner: _choiceRunner(root),
        sources: const FixtureOfficialResolver(),
      ).initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      );
      final config = File(p.join(root.path, 'remix.yaml'));
      config.writeAsStringSync(
        config.readAsStringSync().replaceFirst(
          'preset: vanilla\n',
          'preset: vanilla\niconLibrary: lucide\n',
        ),
      );
      final runner = _choiceRunner(root);
      await Installer(
        projectRoot: root,
        writeOut: (_) {},
        processRunner: runner,
        sources: const FixtureOfficialResolver(),
      ).add(const AddOptions(items: ['icons'], mode: AddMode.write));

      final icons = File(
        p.join(root.path, 'lib', 'ui', 'icons.dart'),
      ).readAsStringSync();
      expect(icons, contains('LucideIcons.check'));
      expect(icons, contains("package:lucide_flutter/lucide_flutter.dart"));
      expect(icons, isNot(contains('remix_ui_icons')));
      expect(icons, isNot(contains('RemixIcons')));
      expect(
        runner.calls.map((call) => call.arguments.join(' ')),
        anyElement(contains('lucide_flutter')),
      );
      expect(
        runner.calls.map((call) => call.arguments.join(' ')),
        isNot(anyElement(contains('remix_ui_icons'))),
      );
    },
  );
}

RecordingProcessRunner _choiceRunner(Directory root, {String? remixUiIcons}) =>
    RecordingProcessRunner((invocation) async {
      if (invocation.executable == 'flutter' &&
          invocation.arguments.join(' ') == '--version --machine') {
        return ProcessOutput(
          exitCode: 0,
          stdout: fakeFlutterMachineJson(root),
          stderr: '',
        );
      }
      final command = invocation.arguments.join(' ');
      if (command.startsWith('pub add') || command.startsWith('pub remove')) {
        return successProcessOutput;
      }
      if (command == 'pub get') {
        writeRequiredLock(
          root,
          remixUiIcons: remixUiIcons,
          lucideFlutter: '1.47.0',
        );
        return successProcessOutput;
      }
      if (command.startsWith('format ') || command.startsWith('analyze ')) {
        return successProcessOutput;
      }
      if (command.startsWith('run build_runner build')) {
        return successProcessOutput;
      }
      throw StateError('Unexpected process: ${invocation.executable} $command');
    });
