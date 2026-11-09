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
      expect(log.toString().split(output.path), hasLength(2));
      log.clear();
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
      final otherLegacy = sandbox.createTempSync('remix_open_code_');
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
      for (final directory in [malformed, kept]) {
        expect(directory.existsSync(), isTrue);
        expect(log.toString(), contains(directory.path));
      }
      for (final directory in [legacy, otherLegacy]) {
        expect(directory.existsSync(), isTrue);
        expect(log.toString(), isNot(contains(directory.path)));
      }
      expect(
        log.toString(),
        contains(
          'Left 2 older remix_open_code_* directories without an owner marker '
          'in ${sandbox.path}; remove them manually once no older checker is running.',
        ),
      );
      if (!Platform.isWindows) expect(link.existsSync(), isTrue);
    },
  );

  test(
    'a failed sweep listing warns once and allows the check to continue',
    () async {
      final run = lifecycle();
      sandbox.deleteSync();
      await run.sweep();
      expect(log.toString().trim().split('\n'), hasLength(1));
      expect(log.toString(), contains('Could not sweep temporary output'));
      sandbox.createSync();
      expect(await run.run<String>((_) async => null), isNull);
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
    expect(log.toString(), contains('Leaving $path: live owner.'));
    owner.process.kill(ProcessSignal.sigkill);
    await owner.process.exitCode;
    await lifecycle().sweep();
    expect(
      abandoned.existsSync(),
      isTrue,
      reason: 'recent output is not reclaimed',
    );
    expect(log.toString(), contains('Leaving $path: recently active.'));
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

  test(
    'cancellation kills an orphaned grandchild before deleting output',
    () async {
      final fixture = await _startFixture(sandbox, 'orphan');
      final ready = jsonDecode(await fixture.ready) as Map;
      final parent = Directory(ready['parent'] as String);
      final child = ready['child'] as int;
      final grandchild = ready['grandchild'] as int;
      addTearDown(() {
        Process.killPid(child, ProcessSignal.sigkill);
        Process.killPid(grandchild, ProcessSignal.sigkill);
      });
      fixture.process.kill(ProcessSignal.sigterm);
      expect(
        await fixture.process.exitCode.timeout(const Duration(seconds: 15)),
        143,
      );
      expect(await _alive(child), isFalse);
      expect(await _alive(grandchild), isFalse);
      expect(
        await fixture.output,
        contains('grandchild alive before deletion: false'),
      );
      expect(parent.existsSync(), isFalse);
    },
    skip: Platform.isWindows ? 'POSIX descendant fixture' : false,
  );

  for (final secondSignal in [false, true]) {
    test(
      'SIGKILL rechecks descendant identity ${secondSignal ? 'on a second signal' : 'after the grace period'}',
      () async {
        final bin = Directory('${sandbox.path}/bin')..createSync();
        final seen = File('${sandbox.path}/ps_seen');
        final reused = File('${sandbox.path}/ps_reused');
        final ps = File('${bin.path}/ps')
          ..writeAsStringSync(r'''#!/bin/sh
if [ -e "$OPEN_CODE_PS_SEEN" ]; then
  /bin/ps "$@" | /usr/bin/awk -v reused="$(/bin/cat "$OPEN_CODE_PS_REUSED")" '$1 == reused { $NF = 1900 } { print }'
else
  /usr/bin/touch "$OPEN_CODE_PS_SEEN"
  /bin/ps "$@"
fi
''');
        expect((await Process.run('chmod', ['+x', ps.path])).exitCode, 0);
        final fixture = await _startFixture(
          sandbox,
          secondSignal ? 'orphan' : 'wait',
          environment: {
            'PATH': '${bin.path}:${Platform.environment['PATH']}',
            'OPEN_CODE_PS_SEEN': seen.path,
            'OPEN_CODE_PS_REUSED': reused.path,
          },
        );
        final ready = jsonDecode(await fixture.ready) as Map;
        final child = ready['child'] as int;
        final grandchild = ready['grandchild'] as int;
        addTearDown(() {
          Process.killPid(child, ProcessSignal.sigkill);
          Process.killPid(grandchild, ProcessSignal.sigkill);
        });
        // Later snapshots model the same PID reused with a different start time.
        reused.writeAsStringSync('$grandchild');
        fixture.process.kill(ProcessSignal.sigint);
        if (secondSignal) {
          // Parent exit proves the first snapshot and SIGTERM phase completed.
          for (
            var attempt = 0;
            attempt < 100 && await _alive(child);
            attempt++
          ) {
            await Future<void>.delayed(const Duration(milliseconds: 10));
          }
          expect(await _alive(child), isFalse);
          fixture.process.kill(ProcessSignal.sigterm);
        }
        expect(
          await fixture.process.exitCode.timeout(const Duration(seconds: 15)),
          130,
        );
        expect(seen.existsSync(), isTrue);
        expect(await _alive(child), isFalse);
        expect(await _alive(grandchild), isTrue);
      },
      skip: Platform.isWindows ? 'POSIX process-table fixture' : false,
    );
  }

  for (final first in [ProcessSignal.sigint, ProcessSignal.sigterm]) {
    test(
      'a second signal exits immediately with ${first.name} status',
      () async {
        final fixture = await _startFixture(sandbox, 'wait');
        final ready = jsonDecode(await fixture.ready) as Map;
        final child = ready['child'] as int;
        final grandchild = ready['grandchild'] as int;
        addTearDown(() {
          Process.killPid(child, ProcessSignal.sigkill);
          Process.killPid(grandchild, ProcessSignal.sigkill);
        });
        fixture.process.kill(first);
        await fixture.cancelling.timeout(const Duration(seconds: 5));
        fixture.process.kill(
          first == ProcessSignal.sigint
              ? ProcessSignal.sigterm
              : ProcessSignal.sigint,
        );
        expect(
          await fixture.process.exitCode.timeout(const Duration(seconds: 1)),
          first == ProcessSignal.sigint ? 130 : 143,
        );
        expect(await _alive(child), isFalse);
        expect(await _alive(grandchild), isFalse);
      },
      skip: Platform.isWindows ? 'POSIX signal fixture' : false,
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

Future<
  ({
    Process process,
    Future<String> ready,
    Future<void> cancelling,
    Future<String> output,
  })
>
_startFixture(
  Directory root,
  String mode, {
  bool keep = false,
  Map<String, String>? environment,
}) async {
  final process = await Process.start(Platform.resolvedExecutable, [
    'test/tool/fixtures/open_code_lifecycle_fixture.dart',
    root.path,
    mode,
    if (keep) '--keep',
  ], environment: environment);
  final errors = process.stderr.transform(utf8.decoder).join();
  addTearDown(() async {
    process.kill(ProcessSignal.sigkill);
    await process.exitCode;
    expect(await errors, isEmpty);
  });
  final ready = Completer<String>();
  final cancelling = Completer<void>();
  final output = process.stdout
      .transform(utf8.decoder)
      .transform(const LineSplitter())
      .map((line) {
        if (!ready.isCompleted) ready.complete(line);
        if (line.startsWith('Cancelling ') && !cancelling.isCompleted) {
          cancelling.complete();
        }
        return line;
      })
      .join('\n');
  unawaited(
    output.then((_) {
      if (!ready.isCompleted)
        ready.completeError(StateError('Fixture exited before becoming ready'));
    }),
  );
  return (
    process: process,
    ready: ready.future,
    cancelling: cancelling.future,
    output: output,
  );
}

Future<bool> _alive(int pid) async {
  final result = await Process.run('ps', ['-o', 'stat=', '-p', '$pid']);
  return result.exitCode == 0 &&
      (result.stdout as String).trim().isNotEmpty &&
      !(result.stdout as String).trim().startsWith('Z');
}
