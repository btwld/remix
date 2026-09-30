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

RecordingProcessRunner _choiceRunner(Directory root) =>
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
        writeRequiredLock(root, remixUiIcons: '0.1.0');
        final lock = File(p.join(root.path, 'pubspec.lock'));
        lock.writeAsStringSync(
          lock.readAsStringSync().replaceFirst(
            'packages:\n',
            'packages:\n'
                '  lucide_flutter:\n'
                '    version: "1.47.0"\n',
          ),
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
