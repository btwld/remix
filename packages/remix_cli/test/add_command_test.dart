import 'package:remix_cli/src/cli.dart';
import 'package:remix_cli/src/installer.dart';
import 'package:test/test.dart';

import 'test_support.dart';

void main() {
  test(
    'CLI add dry-run uses the initialized installer without processes',
    () async {
      final root = createFlutterPackage();
      addTearDown(() => root.deleteSync(recursive: true));
      final output = <String>[];
      final runner = RecordingProcessRunner(
        (invocation) => throw StateError('Unexpected ${invocation.display}'),
      );
      final installer = Installer(
        projectRoot: root,
        writeOut: output.add,
        processRunner: runner,
        sources: const FixtureOfficialResolver(),
      );
      await installer.initialize(
        const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
      );

      final code = await runRemixCli(
        ['add', 'button', '--dry-run'],
        writeOut: output.add,
        writeError: fail,
        onAdd: installer.add,
      );

      expect(code, successExitCode);
      expect(
        output.join('\n'),
        contains('Items: @remix/theme -> @remix/button'),
      );
      expect(runner.calls, isEmpty);
    },
  );

  test('unknown item fails without project writes or processes', () async {
    final root = createFlutterPackage();
    addTearDown(() => root.deleteSync(recursive: true));
    final runner = RecordingProcessRunner(
      (invocation) => throw StateError('Unexpected ${invocation.display}'),
    );
    final installer = Installer(
      projectRoot: root,
      writeOut: (_) {},
      processRunner: runner,
      sources: const FixtureOfficialResolver(),
    );
    await installer.initialize(
      const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
    );
    final before = snapshotFiles(root);
    final errors = <String>[];

    final code = await runRemixCli(
      ['add', 'missing'],
      writeOut: (_) {},
      writeError: errors.add,
      onAdd: installer.add,
    );

    expect(code, failureExitCode);
    expect(
      errors.single,
      'Unknown registry item @remix/missing in the vanilla preset.\n'
      'Run remix list to see every item in the vanilla preset.',
    );
    expect(snapshotFiles(root), before);
    expect(runner.calls, isEmpty);
  });

  test('a misspelled item suggests the near match', () async {
    final root = createFlutterPackage();
    addTearDown(() => root.deleteSync(recursive: true));
    final installer = Installer(
      projectRoot: root,
      writeOut: (_) {},
      sources: const FixtureOfficialResolver(),
    );
    await installer.initialize(
      const InitOptions(prefix: 'Ui', preset: 'vanilla', uiPath: 'lib/ui'),
    );
    final errors = <String>[];

    final code = await runInstallerCli(
      ['add', 'buton'],
      installer,
      writeOut: (_) {},
      writeError: errors.add,
    );

    expect(code, failureExitCode);
    expect(
      errors.single,
      'Unknown registry item @remix/buton in the vanilla preset.\n'
      'Did you mean @remix/button?\n'
      'Run remix list to see every item in the vanilla preset.',
    );
  });
}
