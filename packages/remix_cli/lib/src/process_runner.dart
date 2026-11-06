import 'dart:convert';
import 'dart:io';

final class ProcessInvocation {
  const ProcessInvocation({
    required this.executable,
    required this.arguments,
    required this.workingDirectory,
    this.environment,
  });

  final String executable;
  final List<String> arguments;
  final String workingDirectory;
  final Map<String, String>? environment;

  String get display => [executable, ...arguments].join(' ');
}

final class ProcessOutput {
  const ProcessOutput({
    required this.exitCode,
    required this.stdout,
    required this.stderr,
  });

  final int exitCode;
  final String stdout;
  final String stderr;
}

abstract interface class ProcessRunner {
  Future<ProcessOutput> run(ProcessInvocation invocation);
}

final class SystemProcessRunner implements ProcessRunner {
  const SystemProcessRunner();

  @override
  Future<ProcessOutput> run(ProcessInvocation invocation) async {
    final process = await Process.start(
      invocation.executable,
      invocation.arguments,
      workingDirectory: invocation.workingDirectory,
      environment: invocation.environment,
      runInShell: false,
    );
    final stdoutFuture = utf8.decoder.bind(process.stdout).join();
    final stderrFuture = utf8.decoder.bind(process.stderr).join();
    final code = await process.exitCode;
    return ProcessOutput(
      exitCode: code,
      stdout: await stdoutFuture,
      stderr: await stderrFuture,
    );
  }
}

final class ProcessFailure implements Exception {
  const ProcessFailure(this.invocation, this.output, {this.detail})
    : _cause = null;

  /// The tool did not start, usually because it is not installed or not on
  /// PATH.
  const ProcessFailure.unstarted(
    this.invocation,
    ProcessException cause, {
    required String this.detail,
  }) : output = null,
       _cause = cause;

  final ProcessInvocation invocation;
  final ProcessOutput? output;
  final String? detail;
  final ProcessException? _cause;

  @override
  String toString() {
    final output = this.output;
    if (output == null) {
      return '$detail: could not start ${invocation.executable}. '
          '${_cause!.message}';
    }
    final message = StringBuffer(
      detail ?? 'Command failed with exit code ${output.exitCode}',
    )..write(': ${invocation.display}');
    final diagnostics = output.stderr.trim().isNotEmpty
        ? output.stderr.trim()
        : output.stdout.trim();
    if (diagnostics.isNotEmpty) message.write('\n$diagnostics');
    return message.toString();
  }
}
