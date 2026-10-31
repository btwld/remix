import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:remix_cli/src/process_runner.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  late Directory root;

  setUp(() => root = createFlutterPackage());
  tearDown(() => root.deleteSync(recursive: true));

  _remixIconsTest();

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

void _remixIconsTest() => test(
  'installing icons with remix falls back to Lucide for missing glyphs',
  () async {
    final root = createFlutterPackage();
    addTearDown(() => root.deleteSync(recursive: true));
    await Installer(
      projectRoot: root,
      writeOut: (_) {},
      processRunner: _choiceRunner(root),
      sources: const FixtureOfficialResolver(),
    ).initialize(
      const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
    );
    final runner = _choiceRunner(root, remixUiIcons: true);
    await Installer(
      projectRoot: root,
      writeOut: (_) {},
      processRunner: runner,
      sources: const FixtureOfficialResolver(),
    ).add(const AddOptions(items: ['icons'], mode: AddMode.write));

    final icons = File(
      p.join(root.path, 'lib', 'ui', 'icons.dart'),
    ).readAsStringSync();
    // Remix draws search under its 1.0 name, and has no double arrow.
    expect(icons, contains('RemixIcons.search'));
    expect(icons, contains('RemixIcons.close'));
    expect(icons, contains('LucideIcons.chevronsLeft'));
    expect(icons, isNot(contains('RemixIcons.magnifyingGlass')));
    expect(
      icons,
      contains("import 'package:lucide_flutter/lucide_flutter.dart';"),
    );
    expect(
      icons,
      contains("import 'package:remix_ui_icons/remix_ui_icons.dart';"),
    );
    final added = runner.calls
        .map((call) => call.arguments.join(' '))
        .where((command) => command.startsWith('pub add'))
        .join('\n');
    expect(added, contains('remix_ui_icons@^1.0.0-beta.1'));
    expect(added, contains('lucide_flutter@^1.47.0'));
  },
);

RecordingProcessRunner _choiceRunner(
  Directory root, {
  bool remixUiIcons = false,
}) => RecordingProcessRunner((invocation) async {
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
      remixUiIcons: remixUiIcons ? '1.0.0-beta.1' : null,
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
