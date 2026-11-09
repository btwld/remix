/// Quiet, cancellation-aware process reporting for isolated consumer checks.
library;

import 'dart:convert';
import 'dart:io';

import 'open_code_lifecycle.dart';

final class ConsumerCheckReporter {
  ConsumerCheckReporter({
    required this.out,
    required this.err,
    this.verbose = false,
    this.githubActions = false,
    this.summaryFile,
  });

  final StringSink out;
  final StringSink err;
  final bool verbose;
  final bool githubActions;
  final File? summaryFile;
  final _timings = <(String, Duration)>[];
  String? _phase;
  Stopwatch? _clock;

  void startPhase(String name) {
    _endPhase();
    _phase = name;
    _clock = Stopwatch()..start();
    out.writeln(githubActions ? '::group::$name' : name);
  }

  void _endPhase() {
    if (_phase == null) return;
    _timings.add((_phase!, _clock!.elapsed));
    if (githubActions) out.writeln('::endgroup::');
    _phase = null;
  }

  void failure(String message) =>
      err.writeln(githubActions ? '::error::${_escape(message)}' : message);

  void finish(String title) {
    _endPhase();
    summaryFile?.writeAsStringSync(
      '\n### $title\n\n| Phase | Time |\n| --- | ---: |\n'
      '${_timings.map((entry) => '| ${entry.$1} | ${_seconds(entry.$2)} s |').join('\n')}\n',
      mode: FileMode.append,
    );
  }

  /// Returns an error only after draining both pipes. All children remain in
  /// the lifecycle's process tracker, including in verbose mode.
  Future<String?> run(
    OpenCodeProcesses processes,
    String executable,
    List<String> arguments, {
    required String workingDirectory,
    Map<String, String>? environment,
    StringSink? log,
    String? step,
  }) async {
    // Pool logs stay ordered in quiet mode; verbose explicitly opts into live,
    // possibly interleaved output from concurrent independent installs.
    final sink = verbose ? out : log ?? out;
    final label = arguments.join(' ');
    final output = StringBuffer();
    final clock = Stopwatch()..start();
    final Process process;
    try {
      process = await processes.start(
        executable,
        arguments,
        workingDirectory: workingDirectory,
        environment: environment,
      );
    } on ProcessException catch (error) {
      final message = 'could not start `$executable`: ${error.message}';
      sink.writeln(message);
      return message;
    }
    if (verbose) sink.writeln('\$ $executable $label');
    void record(String chunk) {
      output.write(chunk);
      if (verbose) sink.write(chunk);
    }

    const decoder = Utf8Decoder(allowMalformed: true);
    final drained = Future.wait([
      process.stdout.transform(decoder).forEach(record),
      process.stderr.transform(decoder).forEach(record),
      process.stdin.close(),
    ]);
    final code = await process.exitCode;
    await drained;
    processes.throwIfCancelled();
    if (code == 0) {
      // Keep add's useful item name without the Dart/CLI invocation prefix.
      final display = step ?? label;
      sink.writeln('ok $display (${_seconds(clock.elapsed)} s)');
      return null;
    }
    if (!verbose) sink.write(output);
    final message = '`$executable $label` exited $code';
    sink.writeln(message);
    return message;
  }
}

String _seconds(Duration duration) =>
    (duration.inMilliseconds / 1000).toStringAsFixed(1);

String _escape(String text) =>
    text.replaceAll('%', '%25').replaceAll('\r', '%0D').replaceAll('\n', '%0A');
