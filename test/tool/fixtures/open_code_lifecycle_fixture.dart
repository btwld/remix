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
    // Both generations ignore SIGTERM so the bounded SIGKILL fallback is tested.
    ProcessSignal.sigterm.watch().listen((_) {});
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
  final lifecycle = OpenCodeLifecycle(
    repositoryRoot: Directory.current,
    temporaryRoot: Directory(arguments[0]),
    keep: arguments.contains('--keep'),
    // Keep stderr empty so the parent test can check fixture errors.
    err: stdout,
  );
  lifecycle.watchSignals();
  try {
    await lifecycle.run<String>((parent) async {
      Directory('${parent.path}/app').createSync();
      if (arguments[1] == 'hold') {
        stdout.writeln(parent.path);
        await stdin.first;
      } else {
        final child = await lifecycle.processes.start(
          Platform.resolvedExecutable,
          [Platform.script.toFilePath(), 'child', 'grandchild'],
        );
        final grandchild = int.parse(
          await child.stdout
              .transform(utf8.decoder)
              .transform(const LineSplitter())
              .first,
        );
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
