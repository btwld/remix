import 'dart:async';
import 'dart:convert';
import 'dart:io';

import '../../../tool/open_code_lifecycle.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.first == 'output') {
    stdout.writeln('fixture output');
    stderr.writeln('fixture diagnostics');
    exitCode = 7;
    return;
  }
  if (arguments.first == 'child') {
    // The orphan fixture lets the tracked parent exit before SIGKILL.
    ProcessSignal.sigterm.watch().listen((_) {
      if (arguments.contains('exit-on-term')) exit(0);
    });
    if (arguments.length > 1) {
      final child = await Process.start(Platform.resolvedExecutable, [
        Platform.script.toFilePath(),
        'child',
      ]);
      stdout.writeln(
        await child.stdout
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .first,
      );
    } else {
      stdout.writeln(pid);
    }
    await Completer<void>().future;
    return;
  }
  if (!['hold', 'wait', 'orphan'].contains(arguments[1])) {
    // Keep a failed async handler alive so only its deliberate exit can pass.
    await runZonedGuarded(
      () => _cancellationFailure(arguments),
      (error, stack) => File(
        '${arguments[0]}/handler-errors',
      ).writeAsStringSync('$error\n', mode: FileMode.append),
    );
    return;
  }
  int? grandchildPid;
  final lifecycle = OpenCodeLifecycle(
    repositoryRoot: Directory.current,
    temporaryRoot: Directory(arguments[0]),
    keep: arguments.contains('--keep'),
    // Keep stderr empty so the parent test can check fixture errors.
    err: stdout,
    deleteDirectory: arguments[1] == 'orphan'
        ? (parent) {
            final result = Process.runSync('ps', [
              '-o',
              'stat=',
              '-p',
              '$grandchildPid',
            ]);
            final state = (result.stdout as String).trim();
            stdout.writeln(
              'grandchild alive before deletion: '
              '${result.exitCode == 0 && state.isNotEmpty && !state.startsWith('Z')}',
            );
            parent.deleteSync(recursive: true);
          }
        : null,
  );
  lifecycle.watchSignals();
  try {
    await lifecycle.run<String>((parent) async {
      Directory('${parent.path}/app').createSync();
      if (arguments[1] == 'hold') {
        stdout.writeln(parent.path);
        await stdin.first;
      } else {
        final child = await lifecycle.processes
            .start(Platform.resolvedExecutable, [
              Platform.script.toFilePath(),
              'child',
              'grandchild',
              if (arguments[1] == 'orphan') 'exit-on-term',
            ]);
        final grandchild = int.parse(
          await child.stdout
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .first,
        );
        grandchildPid = grandchild;
        stdout.writeln(
          jsonEncode({
            'parent': parent.path,
            'child': child.pid,
            'grandchild': grandchild,
          }),
        );
        await child.exitCode;
        // Model the final pipe drain and buffered logs of pooled commands.
        await Future<void>.delayed(const Duration(milliseconds: 50));
        stdout.writeln('running work settled');
        lifecycle.processes.throwIfCancelled();
      }
      return null;
    });
  } on OpenCodeCancelled {
    // The signal handler finishes retention and exits with the signal's code.
  } finally {
    await lifecycle.close();
  }
}

Future<void> _cancellationFailure(List<String> arguments) async {
  final root = arguments[0];
  final failure = arguments[1];
  void recordFlush(String stream) => File(
    '$root/flushes',
  ).writeAsStringSync('$stream\n', mode: FileMode.append);
  final lifecycle = OpenCodeLifecycle(
    repositoryRoot: Directory.current,
    temporaryRoot: Directory(root),
    keep: false,
    processes: OpenCodeProcesses(
      startProcess:
          (
            executable,
            arguments, {
            workingDirectory,
            environment,
            required mode,
          }) => executable == 'tracked'
          ? Future.value(_TrackedProcess(root))
          : Completer<Process>().future,
      // Leave time to deliver a second signal before the bounded first cancel.
      stopTimeout: failure == 'stuck-start'
          ? const Duration(seconds: 10)
          : const Duration(milliseconds: 20),
    ),
    err: _FailureSink(root, failure),
    deleteDirectory: failure == 'finish'
        ? (_) => throw StateError('synthetic deletion failure')
        : null,
    flushOutput: () async {
      recordFlush('output');
      if (failure == 'flush-output') {
        throw StateError('synthetic flush failure');
      }
      if (failure == 'stuck-flush') await Completer<void>().future;
      await stdout.flush();
    },
    flushErrors: () async {
      recordFlush('errors');
      if (failure == 'flush-errors') {
        throw StateError('synthetic flush failure');
      }
      await stderr.flush();
    },
  );
  lifecycle.watchSignals();
  await lifecycle.run<String>((parent) async {
    if (failure == 'stuck-start') {
      await lifecycle.processes.start('tracked', []);
      unawaited(lifecycle.processes.start('never-starts', []));
    }
    stdout.writeln(parent.path);
    await stdout.flush();
    if (failure == 'closed-stdout') await stdout.close();
    await Completer<void>().future;
    return null;
  });
}

final class _TrackedProcess implements Process {
  _TrackedProcess(this.root);

  final String root;

  @override
  int get pid => 123456789;

  @override
  final Future<int> exitCode = Completer<int>().future;

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    File('$root/kills').writeAsStringSync('$signal\n', mode: FileMode.append);
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

final class _FailureSink implements StringSink {
  _FailureSink(this.root, this.failure);

  final String root;
  final String failure;

  @override
  void writeln([Object? value = '']) {
    final message = '$value';
    if (message.startsWith('Cancelling')) {
      File('$root/cancelling').writeAsStringSync(message);
      if (failure == 'announcement') throw StateError('synthetic announcement');
    }
    if (failure == 'hint' && message.startsWith('To inspect')) {
      throw StateError('synthetic hint failure');
    }
    if (failure == 'finish' && message.startsWith('Could not clean up')) {
      throw StateError('synthetic finish failure');
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
