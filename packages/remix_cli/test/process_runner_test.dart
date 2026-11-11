import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:remix_cli/src/process_runner.dart';
import 'package:test/test.dart';

void main() {
  test('an unstarted tool names the tool and the reason', () {
    final failure = ProcessFailure.unstarted(
      ProcessInvocation(
        executable: 'git',
        arguments: const ['diff'],
        workingDirectory: '.',
      ),
      const ProcessException('git', ['diff'], 'No such file or directory', 2),
      detail: 'Could not diff with git',
    );

    expect(
      failure.toString(),
      'Could not diff with git: could not start git. No such file or directory',
    );
  });

  test(
    'SystemProcessRunner passes literal arguments and environment',
    () async {
      final root = Directory.systemTemp.createTempSync('remix_process_test_');
      addTearDown(() => root.deleteSync(recursive: true));
      final script = File(p.join(root.path, 'arguments.dart'))
        ..writeAsStringSync('''import 'dart:convert';
import 'dart:io';
void main(List<String> arguments) => stdout.write(jsonEncode({
  'arguments': arguments,
  'marker': Platform.environment['REMIX_PROCESS_TEST'],
}));
''');

      final output = await const SystemProcessRunner().run(
        ProcessInvocation(
          executable: Platform.resolvedExecutable,
          arguments: [
            script.path,
            'two words',
            r'$HOME',
            '; echo unsafe',
            '^2.0.0',
          ],
          workingDirectory: root.path,
          environment: const {'REMIX_PROCESS_TEST': 'literal ^ value'},
        ),
      );

      expect(output.exitCode, 0);
      expect(jsonDecode(output.stdout), {
        'arguments': ['two words', r'$HOME', '; echo unsafe', '^2.0.0'],
        'marker': 'literal ^ value',
      });
      expect(output.stderr, isEmpty);
    },
  );

  group('ProcessFailure', () {
    const invocation = ProcessInvocation(
      executable: '/sdk/dart',
      arguments: ['analyze', 'lib/ui'],
      workingDirectory: '/project',
    );

    test('reports the exact invocation and diagnostics', () {
      const failure = ProcessFailure(
        invocation,
        ProcessOutput(exitCode: 2, stdout: '', stderr: 'bad source'),
        detail: 'Analysis failed',
      );

      expect(
        failure.toString(),
        'Analysis failed: /sdk/dart analyze lib/ui\nbad source',
      );
    });

    test('names the exit code when there is no detail', () {
      const failure = ProcessFailure(
        invocation,
        ProcessOutput(exitCode: 2, stdout: '', stderr: ''),
      );

      expect(
        failure.toString(),
        'Command failed with exit code 2: /sdk/dart analyze lib/ui',
      );
    });

    test('falls back to stdout when stderr is blank', () {
      const failure = ProcessFailure(
        invocation,
        ProcessOutput(exitCode: 1, stdout: 'on stdout\n', stderr: ' \n'),
        detail: 'Analysis failed',
      );

      expect(
        failure.toString(),
        'Analysis failed: /sdk/dart analyze lib/ui\non stdout',
      );
    });

    test(
      'an ordinary failure keeps its output and an unstarted one has none',
      () {
        const output = ProcessOutput(exitCode: 2, stdout: '', stderr: 'bad');
        const ordinary = ProcessFailure(invocation, output);
        final unstarted = ProcessFailure.unstarted(
          invocation,
          const ProcessException('/sdk/dart', ['analyze'], 'not found', 2),
          detail: 'Analysis failed',
        );

        expect(ordinary.output, same(output));
        expect(unstarted.output, isNull);
        expect(
          unstarted.toString(),
          'Analysis failed: could not start /sdk/dart. not found',
        );
      },
    );
  });
}
