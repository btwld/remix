/// Temporary output ownership, recovery and cancellation for the consumer check.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

const openCodeOwnerMarker = '.remix-open-code-owner.json';
const _lockName = '.remix-open-code.lock';
const _prefix = 'remix_open_code_';
const _quietPeriod = Duration(minutes: 10);

final class OpenCodeCancelled implements Exception {}

/// Tracks every command, including SDK discovery and CLI compilation.
final class OpenCodeProcesses {
  final _running = <Process>{};
  final _starting = <Future<Process>>{};
  // Retain identities after parents exit and descendants are reparented.
  final _descendantStarts = <int, String>{};
  Future<void>? _stopping;
  int? cancellationExitCode;

  bool get cancelled => cancellationExitCode != null;

  void throwIfCancelled() {
    if (cancelled) throw OpenCodeCancelled();
  }

  Future<Process> start(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
    ProcessStartMode mode = ProcessStartMode.normal,
  }) async {
    throwIfCancelled();
    final starting = Process.start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
      mode: mode,
    );
    _starting.add(starting);
    try {
      final process = await starting;
      _running.add(process);
      unawaited(
        process.exitCode.then<void>((_) {
          _running.remove(process);
        }),
      );
      return process;
    } finally {
      _starting.remove(starting);
    }
  }

  Future<ProcessResult> run(
    String executable,
    List<String> arguments, {
    String? workingDirectory,
    Map<String, String>? environment,
  }) async {
    final process = await start(
      executable,
      arguments,
      workingDirectory: workingDirectory,
      environment: environment,
    );
    const decoder = Utf8Decoder(allowMalformed: true);
    final output = process.stdout.transform(decoder).join();
    final errors = process.stderr.transform(decoder).join();
    await process.stdin.close();
    final code = await process.exitCode;
    final result = ProcessResult(process.pid, code, await output, await errors);
    throwIfCancelled();
    return result;
  }

  Future<void> cancel(ProcessSignal signal) {
    cancellationExitCode ??= signal == ProcessSignal.sigint ? 130 : 143;
    return _stopping ??= _stop();
  }

  Future<void> get stopped => _stopping ?? Future.value();

  Future<void> _stop() async {
    // Register pending starts before inspecting the process tree.
    await Future.wait([
      for (final pending in _starting.toList())
        pending.then<void>((_) {}, onError: (Object _) {}),
    ]);
    final running = _running.toList();
    if (running.isEmpty) return;
    Object? inspectionProblem;
    try {
      if (!Platform.isWindows) {
        _descendantStarts.addAll(
          _descendants(
            await Process.run('ps', ['-e', '-o', 'pid=,ppid=,lstart=']),
          ),
        );
        for (final child in _descendantStarts.keys.toList().reversed) {
          Process.killPid(child, ProcessSignal.sigterm);
        }
      } else {
        for (final process in running) {
          await Process.run('taskkill', ['/PID', '${process.pid}', '/T', '/F']);
        }
      }
    } on Object catch (error) {
      inspectionProblem = error;
    }
    for (final process in running) {
      process.kill(ProcessSignal.sigterm);
    }
    // Allow descendants the grace period even if tracked handles have exited.
    await Future<void>.delayed(const Duration(seconds: 2));
    try {
      if (!Platform.isWindows && _descendantStarts.isNotEmpty) {
        _killDescendants(await Process.run('ps', ['-e', '-o', 'pid=,lstart=']));
      }
    } on Object catch (error) {
      inspectionProblem ??= error;
    }
    for (final process in running) {
      if (_running.contains(process)) process.kill(ProcessSignal.sigkill);
    }
    await Future.wait(
      running.map((process) => process.exitCode),
    ).timeout(const Duration(seconds: 2), onTimeout: () => <int>[]);
    if (inspectionProblem != null) throw inspectionProblem;
  }

  void forceKill() {
    try {
      if (!Platform.isWindows) {
        if (_running.isNotEmpty) {
          final descendants = _descendants(
            Process.runSync('ps', ['-e', '-o', 'pid=,ppid=,lstart=']),
          );
          for (final entry in descendants.entries) {
            _descendantStarts.putIfAbsent(entry.key, () => entry.value);
          }
        }
        if (_descendantStarts.isNotEmpty) {
          _killDescendants(Process.runSync('ps', ['-e', '-o', 'pid=,lstart=']));
        }
      }
    } on Object {
      // Process inspection must not prevent the second signal from exiting.
    }
    for (final process in _running.toList()) {
      process.kill(ProcessSignal.sigkill);
    }
  }

  Iterable<String> _processRows(ProcessResult table) {
    if (table.exitCode != 0) {
      throw StateError('Could not inspect child processes: ${table.stderr}');
    }
    return (table.stdout as String).split('\n');
  }

  void _killDescendants(ProcessResult table) {
    for (final line in _processRows(table)) {
      final fields = RegExp(r'^\s*(\d+)\s+(.+?)\s*$').firstMatch(line);
      if (fields == null) continue;
      final child = int.parse(fields[1]!);
      if (_descendantStarts[child] == fields[2]) {
        Process.killPid(child, ProcessSignal.sigkill);
      }
    }
  }

  Map<int, String> _descendants(ProcessResult table) {
    final parents = <int, int>{};
    final starts = <int, String>{};
    for (final line in _processRows(table)) {
      final fields = RegExp(r'^\s*(\d+)\s+(\d+)\s+(.+?)\s*$').firstMatch(line);
      if (fields != null) {
        final child = int.parse(fields[1]!);
        parents[child] = int.parse(fields[2]!);
        starts[child] = fields[3]!;
      }
    }
    final descendants = <int>{};
    var ancestors = _running.map((process) => process.pid).toSet();
    while (ancestors.isNotEmpty) {
      ancestors = {
        for (final entry in parents.entries)
          if (ancestors.contains(entry.value) &&
              !descendants.contains(entry.key))
            entry.key,
      };
      descendants.addAll(ancestors);
    }
    return {for (final child in descendants) child: starts[child]!};
  }
}

/// Owns one run directory; all normal outcomes unwind through [run]'s finally.
final class OpenCodeLifecycle {
  OpenCodeLifecycle({
    required this.repositoryRoot,
    required this.keep,
    Directory? temporaryRoot,
    StringSink? out,
    StringSink? err,
    void Function(Directory)? deleteDirectory,
    OpenCodeProcesses? processes,
  }) : temporaryRoot = temporaryRoot ?? Directory.systemTemp,
       processes = processes ?? OpenCodeProcesses(),
       out = out ?? stdout,
       err = err ?? stderr,
       _deleteDirectory = deleteDirectory ?? _deleteDirectoryRecursively;

  final Directory repositoryRoot;
  final Directory temporaryRoot;
  final bool keep;
  final StringSink out;
  final StringSink err;
  final void Function(Directory) _deleteDirectory;
  final OpenCodeProcesses processes;
  final _signals = <StreamSubscription<ProcessSignal>>[];
  Directory? _parent;
  RandomAccessFile? _lock;
  Completer<void>? _workSettled;
  bool _finished = false;
  bool _hinted = false;
  String? cleanupProblem;

  void watchSignals() {
    for (final signal in [
      ProcessSignal.sigint,
      if (!Platform.isWindows) ProcessSignal.sigterm,
    ]) {
      _signals.add(
        signal.watch().listen((signal) async {
          if (processes.cancelled) {
            processes.forceKill();
            exit(processes.cancellationExitCode!);
          }
          err.writeln('Cancelling open-code check (${signal.name}).');
          try {
            await processes.cancel(signal);
            // Bound pipe draining so non-process I/O cannot delay cancellation.
            await _workSettled?.future.timeout(
              const Duration(seconds: 2),
              onTimeout: () {},
            );
          } on Object catch (error) {
            err.writeln('Could not stop all child processes: $error');
          } finally {
            if (_parent != null && !keep) _hint();
            _finish();
            await stdout.flush();
            await stderr.flush();
            exit(processes.cancellationExitCode!);
          }
        }),
      );
    }
  }

  Future<T?> run<T extends Object>(Future<T?> Function(Directory) check) async {
    processes.throwIfCancelled();
    _parent = temporaryRoot.createTempSync(_prefix);
    _workSettled = Completer<void>();
    try {
      final guard = _verifyDeletableParent(_parent!, repositoryRoot);
      if (guard != null) throw FileSystemException(guard, _parent!.path);
      _lock = File(
        '${_parent!.path}/$_lockName',
      ).openSync(mode: FileMode.append);
      _lock!.lockSync(FileLock.exclusive);
      File('${_parent!.path}/$openCodeOwnerMarker').writeAsStringSync(
        jsonEncode({'schema': 1, 'pid': pid, 'keep': keep}),
        flush: true,
      );
      final result = await check(_parent!);
      if (result != null && !keep) _hint();
      return result;
    } on Object {
      if (!keep) _hint();
      rethrow;
    } finally {
      try {
        if (processes.cancelled) await processes.stopped;
        _finish();
      } finally {
        _workSettled!.complete();
      }
    }
  }

  void _hint() {
    if (_hinted) return;
    _hinted = true;
    err.writeln('To inspect temporary output, rerun with --keep.');
  }

  void _finish() {
    if (_finished) return;
    _finished = true;
    final parent = _parent;
    if (parent == null) return;
    try {
      _lock?.closeSync();
      _lock = null;
      if (keep) {
        out.writeln('Temporary output kept at ${parent.path}');
      } else {
        _deleteVerifiedParent(parent, repositoryRoot, _deleteDirectory);
      }
    } on Object catch (error) {
      cleanupProblem =
          'Could not clean up temporary output: $error\nTemporary output remains at ${parent.path}';
      err.writeln(cleanupProblem);
    }
  }

  Future<void> close() async {
    if (processes.cancelled) await processes.stopped;
    for (final signal in _signals) {
      await signal.cancel();
    }
  }

  /// Reclaims inactive direct children with a valid, non-kept owner marker.
  Future<void> sweep({DateTime? now}) async {
    final cutoff = (now ?? DateTime.now()).subtract(_quietPeriod);
    final List<FileSystemEntity> entries;
    try {
      entries = temporaryRoot.listSync(followLinks: false);
    } on FileSystemException catch (error) {
      err.writeln(
        'Could not sweep temporary output in ${temporaryRoot.path}: $error',
      );
      return;
    }
    var unmarked = 0;
    for (final entity in entries) {
      if (!basename(entity.path).startsWith(_prefix)) continue;
      RandomAccessFile? lock;
      try {
        if (entity is! Directory) {
          out.writeln('Leaving ${entity.path}: not a regular directory.');
          continue;
        }
        // Closing another handle to our lock would release its POSIX lock.
        if (entity.path == _parent?.path) continue;
        final marker = File('${entity.path}/$openCodeOwnerMarker');
        final lockFile = File('${entity.path}/$_lockName');
        if (FileSystemEntity.typeSync(marker.path, followLinks: false) !=
            FileSystemEntityType.file) {
          unmarked++;
          continue;
        }
        final owner = jsonDecode(marker.readAsStringSync());
        if (owner is! Map ||
            owner['schema'] != 1 ||
            owner['pid'] is! int ||
            owner['keep'] is! bool) {
          out.writeln('Leaving ${entity.path}: unrecognized owner marker.');
          continue;
        }
        if (owner['keep'] == true) {
          out.writeln('Leaving ${entity.path}: explicitly kept with --keep.');
          continue;
        }
        if (FileSystemEntity.typeSync(lockFile.path, followLinks: false) !=
            FileSystemEntityType.file) {
          out.writeln('Leaving ${entity.path}: no regular owner lock.');
          continue;
        }
        lock = lockFile.openSync(mode: FileMode.append);
        try {
          lock.lockSync(FileLock.exclusive);
        } on FileSystemException {
          out.writeln('Leaving ${entity.path}: live owner.');
          continue;
        }
        if (!_quiet(entity, cutoff, 2)) {
          out.writeln('Leaving ${entity.path}: recently active.');
          continue;
        }
        // Windows cannot delete an open lock; new runs never adopt old output.
        if (Platform.isWindows) {
          lock.closeSync();
          lock = null;
        }
        _deleteVerifiedParent(entity, repositoryRoot, _deleteDirectory);
        out.writeln('Reclaimed abandoned temporary output at ${entity.path}');
      } on Object catch (error) {
        out.writeln('Leaving ${entity.path}: $error');
      } finally {
        lock?.closeSync();
      }
    }
    if (unmarked > 0) {
      out.writeln(
        'Left $unmarked older remix_open_code_* directories without an owner marker '
        'in ${temporaryRoot.path}; remove them manually once no older checker is running.',
      );
    }
  }
}

bool _quiet(FileSystemEntity entity, DateTime cutoff, int depth) {
  final stat = FileStat.statSync(entity.path);
  if (stat.modified.isAfter(cutoff) || stat.changed.isAfter(cutoff)) {
    return false;
  }
  if (entity is Directory && depth > 0) {
    for (final child in entity.listSync(followLinks: false)) {
      // Links are not followed, including for timestamps.
      if (child is Link) return false;
      if (!_quiet(child, cutoff, depth - 1)) return false;
    }
  }
  return true;
}

String? _verifyDeletableParent(Directory parent, Directory repositoryRoot) {
  final problems = <String>[];
  final resolved = parent.resolveSymbolicLinksSync();
  final temp = Directory.systemTemp.resolveSymbolicLinksSync();
  final repository = repositoryRoot.resolveSymbolicLinksSync();
  if (!isWithin(resolved, temp)) problems.add('$resolved is not inside $temp');
  if (isWithin(resolved, repository) || resolved == repository) {
    problems.add('$resolved is inside the repository');
  }
  if (!basename(resolved).startsWith(_prefix)) {
    problems.add('$resolved was not created by this checker');
  }
  if (FileSystemEntity.isLinkSync(parent.path)) {
    problems.add('$resolved is a symbolic link');
  }
  if (problems.isEmpty) return null;
  return 'refusing to use a temporary directory that cannot be proven safe:\n'
      '${problems.map((problem) => '  - $problem').join('\n')}';
}

void _deleteVerifiedParent(
  Directory parent,
  Directory repositoryRoot,
  void Function(Directory) delete,
) {
  final guard = _verifyDeletableParent(parent, repositoryRoot);
  if (guard != null) throw FileSystemException(guard, parent.path);
  delete(parent);
}

void _deleteDirectoryRecursively(Directory parent) =>
    parent.deleteSync(recursive: true);
bool isWithin(String path, String parent) => path.startsWith(
  parent.endsWith(Platform.pathSeparator)
      ? parent
      : '$parent${Platform.pathSeparator}',
);
String basename(String path) => path.split(Platform.pathSeparator).last;
