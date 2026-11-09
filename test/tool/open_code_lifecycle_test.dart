import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

import '../../tool/open_code_lifecycle.dart';
import '../../tool/compile_registry_consumer.dart';

void main() {
  late Directory sandbox;
  late StringBuffer log;

  setUp(() {
    sandbox = Directory.systemTemp.createTempSync('open_code_lifecycle_test_');
    log = StringBuffer();
  });

  tearDown(() {
    if (sandbox.existsSync()) sandbox.deleteSync(recursive: true);
  });

  OpenCodeLifecycle lifecycle({bool keep = false, bool failDeletion = false}) =>
      OpenCodeLifecycle(
        repositoryRoot: Directory.current,
        temporaryRoot: sandbox,
        keep: keep,
        out: log,
        err: log,
        deleteDirectory: failDeletion
            ? (_) =>
                  throw const FileSystemException('synthetic deletion failure')
            : null,
      );

  test(
    'five returned failures leave no run directories and give a hint',
    () async {
      for (var index = 0; index < 5; index++) {
        expect(
          await lifecycle().run<String>((parent) async {
            File('${parent.path}/fixture').writeAsStringSync('small fixture');
            return 'original failure';
          }),
          'original failure',
        );
        expect(sandbox.listSync(), isEmpty);
      }
      expect(log.toString(), contains('rerun with --keep'));
    },
  );

  test('success and exceptions both clean up in finally', () async {
    expect(await lifecycle().run<String>((_) async => null), isNull);
    await expectLater(
      lifecycle().run<String>((_) async => throw StateError('original error')),
      throwsStateError,
    );
    expect(sandbox.listSync(), isEmpty);
  });

  test('--keep preserves and names output for every outcome', () async {
    for (final outcome in ['success', 'failure', 'exception']) {
      late Directory output;
      final run = lifecycle(keep: true).run<String>((parent) async {
        output = parent;
        if (outcome == 'exception') throw StateError('original error');
        return outcome == 'failure' ? 'original failure' : null;
      });
      if (outcome == 'exception') {
        await expectLater(run, throwsStateError);
      } else {
        expect(await run, outcome == 'failure' ? 'original failure' : null);
      }
      expect(output.existsSync(), isTrue);
      expect(log.toString(), contains(output.path));
    }
  });

  test(
    'cleanup errors preserve the original failure and report the path',
    () async {
      final run = lifecycle(failDeletion: true);
      late Directory output;
      expect(
        await run.run<String>((parent) async {
          output = parent;
          return 'original failure';
        }),
        'original failure',
      );
      expect(run.cleanupProblem, contains('synthetic deletion failure'));
      expect(log.toString(), contains(output.path));
      expect(output.existsSync(), isTrue);
      await expectLater(
        lifecycle(
          failDeletion: true,
        ).run<String>((_) async => throw StateError('original error')),
        throwsStateError,
      );
    },
  );

  test('cleanup failure after success is exposed to the checker', () async {
    final run = lifecycle(failDeletion: true);
    expect(await run.run<String>((_) async => null), isNull);
    expect(run.cleanupProblem, contains('synthetic deletion failure'));
  });

  test(
    'deletion guards refuse a parent replaced with a symlink',
    () async {
      final run = lifecycle();
      late Directory renamed;
      expect(
        await run.run<String>((parent) async {
          renamed = parent.renameSync('${sandbox.path}/untouched');
          Link(parent.path).createSync(renamed.path);
          return 'original failure';
        }),
        'original failure',
      );
      expect(renamed.existsSync(), isTrue);
      expect(run.cleanupProblem, contains('symbolic link'));
    },
    skip: Platform.isWindows ? 'Symlink creation requires privileges' : false,
  );

  test(
    'sweep reports unmarked, kept, malformed and linked directories',
    () async {
      final legacy = sandbox.createTempSync('remix_open_code_');
      final malformed = sandbox.createTempSync('remix_open_code_');
      File('${malformed.path}/$openCodeOwnerMarker').writeAsStringSync('{}');
      late Directory kept;
      await lifecycle(keep: true).run<String>((parent) async {
        kept = parent;
        return null;
      });
      final link = Link('${sandbox.path}/remix_open_code_link');
      if (!Platform.isWindows) link.createSync(kept.path);
      await lifecycle().sweep(
        now: DateTime.now().add(const Duration(hours: 1)),
      );
      for (final directory in [legacy, malformed, kept]) {
        expect(directory.existsSync(), isTrue);
        expect(log.toString(), contains(directory.path));
      }
      if (!Platform.isWindows) expect(link.existsSync(), isTrue);
    },
  );

  test('sweep skips a live owner, then reclaims its SIGKILL output', () async {
    final owner = await _startFixture(sandbox, 'hold');
    final path = await owner.ready;
    addTearDown(() => owner.process.kill(ProcessSignal.sigkill));
    final abandoned = Directory(path);
    final future = DateTime.now().add(const Duration(minutes: 11));
    await lifecycle().sweep(now: future);
    expect(
      abandoned.existsSync(),
      isTrue,
      reason: 'exclusive lock is held by another OS process',
    );
    owner.process.kill(ProcessSignal.sigkill);
    await owner.process.exitCode;
    await lifecycle().sweep();
    expect(
      abandoned.existsSync(),
      isTrue,
      reason: 'recent output is not reclaimed',
    );
    await lifecycle().sweep(now: future);
    expect(abandoned.existsSync(), isFalse);
  });

  test('sweep checks changes below the app and only direct children', () async {
    final owner = await _startFixture(sandbox, 'hold');
    final path = await owner.ready;
    owner.process.kill(ProcessSignal.sigkill);
    await owner.process.exitCode;
    final abandoned = Directory(path);
    final later = DateTime.now().add(const Duration(minutes: 11));
    final changed = File('$path/app/recent');
    changed.writeAsStringSync('recent write');
    changed.setLastModifiedSync(later);
    await lifecycle().sweep(now: later);
    expect(abandoned.existsSync(), isTrue);
    await lifecycle().sweep(now: later.add(const Duration(minutes: 11)));
    expect(abandoned.existsSync(), isFalse);

    final nestedRoot = Directory('${sandbox.path}/nested')..createSync();
    final nestedOwner = await _startFixture(nestedRoot, 'hold');
    final nested = Directory(await nestedOwner.ready);
    nestedOwner.process.kill(ProcessSignal.sigkill);
    await nestedOwner.process.exitCode;
    await lifecycle().sweep(now: later.add(const Duration(hours: 1)));
    expect(nested.existsSync(), isTrue);
  });

  for (final signal in [
    ProcessSignal.sigint,
    if (!Platform.isWindows) ProcessSignal.sigterm,
  ]) {
    for (final failure in [
      'announcement',
      'hint',
      'finish',
      'flush-output',
      'flush-errors',
      'stuck-flush',
      'closed-stdout',
    ]) {
      test(
        '${signal.name} exits despite $failure failure',
        () async {
          final fixture = await _startFixture(sandbox, failure);
          final parent = Directory(await fixture.ready);
          fixture.process.kill(signal);
          expect(
            await fixture.process.exitCode.timeout(const Duration(seconds: 5)),
            signal == ProcessSignal.sigint ? 130 : 143,
          );
          expect(parent.existsSync(), failure == 'finish');
          expect(File('${sandbox.path}/flushes').readAsLinesSync(), [
            'output',
            'errors',
          ]);
        },
        skip: Platform.isWindows ? 'POSIX signal fixture' : false,
      );
    }

    for (final second in [ProcessSignal.sigint, ProcessSignal.sigterm]) {
      test(
        '${signal.name} then ${second.name} forces prompt exit',
        () async {
          final fixture = await _startFixture(sandbox, 'stuck-start');
          await fixture.ready;
          fixture.process.kill(signal);
          await _waitForFile(File('${sandbox.path}/cancelling'));
          fixture.process.kill(second);
          expect(
            await fixture.process.exitCode.timeout(const Duration(seconds: 1)),
            second == ProcessSignal.sigint ? 130 : 143,
          );
          expect(File('${sandbox.path}/kills').readAsLinesSync(), [
            '${ProcessSignal.sigkill}',
          ]);
        },
        skip: Platform.isWindows ? 'POSIX signal fixture' : false,
      );
    }

    for (final keep in [false, true]) {
      test(
        '${signal.name} stops children before ${keep ? 'keeping' : 'deleting'} output',
        () async {
          final fixture = await _startFixture(sandbox, 'wait', keep: keep);
          final ready = jsonDecode(await fixture.ready) as Map;
          final parent = Directory(ready['parent'] as String);
          final child = ready['child'] as int;
          final grandchild = ready['grandchild'] as int;
          addTearDown(() {
            fixture.process.kill(ProcessSignal.sigkill);
            Process.killPid(child, ProcessSignal.sigkill);
            Process.killPid(grandchild, ProcessSignal.sigkill);
          });
          fixture.process.kill(signal);
          expect(
            await fixture.process.exitCode.timeout(const Duration(seconds: 15)),
            signal == ProcessSignal.sigint ? 130 : 143,
          );
          expect(parent.existsSync(), keep);
          final output = await fixture.output;
          expect(output, isNot(contains('Could not stop all child processes')));
          expect(output, contains('running work settled'));
          if (keep) {
            expect(output, contains(parent.path));
          } else {
            expect(output, contains('rerun with --keep'));
          }
          expect(await _alive(child), isFalse);
          expect(await _alive(grandchild), isFalse);
        },
        skip: Platform.isWindows ? 'POSIX descendant fixture' : false,
      );
    }
  }

  test('cancellation bounds a never-completing process start', () async {
    final pending = Completer<Process>();
    final processes = OpenCodeProcesses(
      startProcess:
          (
            executable,
            arguments, {
            workingDirectory,
            environment,
            required mode,
          }) => pending.future,
      stopTimeout: const Duration(milliseconds: 20),
    );
    final starting = processes.start('fake', []);
    await processes
        .cancel(ProcessSignal.sigint)
        .timeout(const Duration(seconds: 1));
    final lateProcess = _FakeProcess();
    pending.complete(lateProcess);
    await starting;
    expect(lateProcess.signals, contains(ProcessSignal.sigkill));
    expect(processes.cancelled, isTrue);
  });

  test('a pending start is inspected before its parent is killed', () async {
    final pending = Completer<Process>();
    final child = _FakeProcess();
    final processes = OpenCodeProcesses(
      startProcess:
          (
            executable,
            arguments, {
            workingDirectory,
            environment,
            required mode,
          }) => pending.future,
      runProcess: (command, arguments) async {
        expect(child.signals, isEmpty);
        return ProcessResult(0, 0, '', '');
      },
      isWindows: false,
      stopTimeout: const Duration(milliseconds: 20),
    );
    final starting = processes.start('fake', []);
    final stopping = processes.cancel(ProcessSignal.sigint);
    pending.complete(child);
    await starting;
    await stopping.timeout(const Duration(seconds: 1));
    expect(child.signals, [ProcessSignal.sigterm, ProcessSignal.sigkill]);
  });

  for (final windows in [false, true]) {
    test(
      'cancellation bounds stuck ${windows ? 'taskkill' : 'ps'} and exit',
      () async {
        final child = _FakeProcess();
        final commands = <String>[];
        final processes = OpenCodeProcesses(
          startProcess:
              (
                executable,
                arguments, {
                workingDirectory,
                environment,
                required mode,
              }) async => child,
          runProcess: (command, arguments) {
            commands.add(command);
            return Completer<ProcessResult>().future;
          },
          isWindows: windows,
          stopTimeout: const Duration(milliseconds: 20),
        );
        await processes.start('fake', []);
        await expectLater(
          processes
              .cancel(ProcessSignal.sigint)
              .timeout(const Duration(seconds: 1)),
          throwsA(
            isA<TimeoutException>().having(
              (error) => error.duration,
              'bounded inspection',
              const Duration(milliseconds: 20),
            ),
          ),
        );
        expect(commands, [windows ? 'taskkill' : 'ps']);
        expect(child.signals, [ProcessSignal.sigterm, ProcessSignal.sigkill]);
      },
    );
  }

  test(
    'captured commands retain their exit status and both output streams',
    () async {
      final processes = OpenCodeProcesses();
      final result = await processes.run(Platform.resolvedExecutable, [
        'test/tool/fixtures/open_code_lifecycle_fixture.dart',
        'output',
      ]);
      expect(result.exitCode, 7);
      expect(result.stdout, 'fixture output\n');
      expect(result.stderr, 'fixture diagnostics\n');
    },
  );

  test(
    'cancellation includes a process whose start is still pending',
    () async {
      final processes = OpenCodeProcesses();
      final starting = processes.start(Platform.resolvedExecutable, [
        'test/tool/fixtures/open_code_lifecycle_fixture.dart',
        'child',
      ]);
      final stopping = processes.cancel(ProcessSignal.sigint);
      final process = await starting;
      addTearDown(() => process.kill(ProcessSignal.sigkill));
      unawaited(process.stdout.drain<void>());
      unawaited(process.stderr.drain<void>());
      await process.stdin.close();
      await stopping;
      expect(await process.exitCode, isNot(0));
    },
  );

  test('CLI compilation uses the tracked process runner', () async {
    final processes = OpenCodeProcesses();
    await processes.cancel(ProcessSignal.sigint);
    await expectLater(
      compileRegistryConsumerCli(
        dart: 'must-not-start',
        repositoryRoot: Directory.current,
        outputDirectory: sandbox,
        processes: processes,
      ),
      throwsA(isA<OpenCodeCancelled>()),
    );
  });

  test(
    'cancelled processes reject new work, including captured commands',
    () async {
      final processes = OpenCodeProcesses();
      await processes.cancel(ProcessSignal.sigint);
      await expectLater(
        processes.start('does-not-exist', []),
        throwsA(isA<OpenCodeCancelled>()),
      );
      await expectLater(
        processes.run('does-not-exist', []),
        throwsA(isA<OpenCodeCancelled>()),
      );
    },
  );
}

Future<({Process process, Future<String> ready, Future<String> output})>
_startFixture(Directory root, String mode, {bool keep = false}) async {
  final process = await Process.start(Platform.resolvedExecutable, [
    'test/tool/fixtures/open_code_lifecycle_fixture.dart',
    root.path,
    mode,
    if (keep) '--keep',
  ]);
  final errors = process.stderr.transform(utf8.decoder).join();
  addTearDown(() async {
    process.kill(ProcessSignal.sigkill);
    await process.exitCode;
    expect(await errors, isEmpty);
  });
  final ready = Completer<String>();
  final output = process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map((line) {
        if (!ready.isCompleted) ready.complete(line);
        return line;
      })
      .join('\n');
  unawaited(
    output.then((_) {
      if (!ready.isCompleted)
        ready.completeError(StateError('Fixture exited before becoming ready'));
    }),
  );
  return (process: process, ready: ready.future, output: output);
}

Future<bool> _alive(int pid) async {
  final result = await Process.run('ps', ['-o', 'stat=', '-p', '$pid']);
  return result.exitCode == 0 &&
      (result.stdout as String).trim().isNotEmpty &&
      !(result.stdout as String).trim().startsWith('Z');
}

Future<void> _waitForFile(File file) async {
  await (() async {
    while (!file.existsSync()) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
  })().timeout(const Duration(seconds: 2));
}

final class _FakeProcess implements Process {
  final signals = <ProcessSignal>[];

  @override
  int get pid => 123456789;

  @override
  final Future<int> exitCode = Completer<int>().future;

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    signals.add(signal);
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
