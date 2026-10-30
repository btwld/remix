// Launches `flutter test` in a child process, which needs dart:io.
@TestOn('vm')
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Integration tests runner with proper process management
///
/// This file runs all integration tests from the example directory
/// and will appear in VS Code Test Explorer for easy execution.
/// Uses flutter test (recommended) with timeout and kill handling.
void main() {
  // Gate integration launcher behind an opt-in env flag to keep unit tests headless
  final shouldRunIntegration = () {
    final env = Platform.environment['RUN_INTEGRATION'];
    if (env == null) return false;
    final v = env.toLowerCase();
    return v == '1' || v == 'true' || v == 'yes';
  }();

  group('Integration Tests', () {
    test(
      'run all integration tests',
      () async {
        if (!Platform.isMacOS) {
          print('↩️ Skipping integration tests on non-macOS CI');
          return;
        }
        print('🚀 Starting NakedUI Integration Tests...\n');

        final stopwatch = Stopwatch()..start();
        Process? process;
        Timer? killTimer;

        try {
          // Use flutter test instead of flutter drive (recommended approach)
          process = await Process.start('flutter', [
            'test',
            'integration_test/all_tests.dart',
            '-d',
            'macos',
            '--no-enable-impeller',
          ], workingDirectory: Directory('example').absolute.path);

          // Set up kill timer (5 minutes timeout)
          killTimer = Timer(Duration(minutes: 5), () {
            print('⏱️ Timeout reached! Killing process...');
            process?.kill(ProcessSignal.sigterm);

            // Force kill if still running after 5 seconds
            Timer(Duration(seconds: 5), () {
              if (process != null) {
                final killed = process.kill(ProcessSignal.sigkill);
                print('💥 Force killed process: $killed');
              }
            });
          });

          // Collect and display output in real-time
          final stdout = StringBuffer();
          final stderr = StringBuffer();

          process.stdout.transform(utf8.decoder).listen((data) {
            stdout.write(data);
            print(data.trimRight()); // Print without extra newline
          });

          process.stderr.transform(utf8.decoder).listen((data) {
            stderr.write(data);
            print('STDERR: ${data.trimRight()}');
          });

          // Wait for process to complete
          final exitCode = await process.exitCode;
          killTimer.cancel();

          stopwatch.stop();
          final duration = stopwatch.elapsed;

          if (exitCode == 0) {
            print('\n✅ All integration tests completed successfully!');
            print(
              '⏱️  Total time: ${duration.inMinutes}m ${duration.inSeconds % 60}s',
            );
          } else {
            print('\n❌ Some integration tests failed (exit code: $exitCode)');
            print(
              '⏱️  Total time: ${duration.inMinutes}m ${duration.inSeconds % 60}s',
            );
            fail('Integration tests failed with exit code: $exitCode');
          }
        } catch (e) {
          killTimer?.cancel();
          if (process != null) {
            process.kill(ProcessSignal.sigkill);
          }
          stopwatch.stop();
          print('💥 Failed to run integration tests: $e');
          fail('Failed to run integration tests: $e');
        }
      },
      timeout: const Timeout(Duration(minutes: 6)),
      skip: shouldRunIntegration
          ? null
          : 'Skipped by default. Set RUN_INTEGRATION=1 to run external example integration tests.',
    ); // Slightly longer than kill timer

    test(
      'run button integration tests only',
      () async {
        if (!Platform.isMacOS) {
          print('↩️ Skipping button tests on non-macOS CI');
          return;
        }
        print('🚀 Running Button Integration Tests...\n');

        Process? process;
        Timer? killTimer;

        try {
          process = await Process.start('flutter', [
            'test',
            'integration_test/components/naked_button_integration.dart',
            '-d',
            'macos',
            '--no-enable-impeller',
          ], workingDirectory: Directory('example').absolute.path);

          // Set up kill timer (3 minutes for single component)
          killTimer = Timer(Duration(minutes: 3), () {
            print('⏱️ Button test timeout! Killing process...');
            process?.kill(ProcessSignal.sigterm);
            Timer(Duration(seconds: 5), () {
              process?.kill(ProcessSignal.sigkill);
            });
          });

          // Display output
          process.stdout.transform(utf8.decoder).listen((data) {
            print(data.trimRight());
          });

          process.stderr.transform(utf8.decoder).listen((data) {
            print('STDERR: ${data.trimRight()}');
          });

          final exitCode = await process.exitCode;
          killTimer.cancel();

          expect(
            exitCode,
            equals(0),
            reason: 'Button integration tests should pass',
          );
        } catch (e) {
          killTimer?.cancel();
          process?.kill(ProcessSignal.sigkill);
          fail('Failed to run button tests: $e');
        }
      },
      timeout: const Timeout(Duration(minutes: 4)),
      skip: shouldRunIntegration
          ? null
          : 'Skipped by default. Set RUN_INTEGRATION=1 to run external example integration tests.',
    );

    test(
      'run slider integration tests only',
      () async {
        if (!Platform.isMacOS) {
          print('↩️ Skipping slider tests on non-macOS CI');
          return;
        }
        print('🚀 Running Slider Integration Tests...\n');

        Process? process;
        Timer? killTimer;

        try {
          process = await Process.start('flutter', [
            'test',
            'integration_test/components/naked_slider_integration.dart',
            '-d',
            'macos',
            '--no-enable-impeller',
          ], workingDirectory: Directory('example').absolute.path);

          // Set up kill timer (3 minutes for single component)
          killTimer = Timer(Duration(minutes: 3), () {
            print('⏱️ Slider test timeout! Killing process...');
            process?.kill(ProcessSignal.sigterm);
            Timer(Duration(seconds: 5), () {
              process?.kill(ProcessSignal.sigkill);
            });
          });

          // Display output
          process.stdout.transform(utf8.decoder).listen((data) {
            print(data.trimRight());
          });

          process.stderr.transform(utf8.decoder).listen((data) {
            print('STDERR: ${data.trimRight()}');
          });

          final exitCode = await process.exitCode;
          killTimer.cancel();

          expect(
            exitCode,
            equals(0),
            reason: 'Slider integration tests should pass',
          );
        } catch (e) {
          killTimer?.cancel();
          process?.kill(ProcessSignal.sigkill);
          fail('Failed to run slider tests: $e');
        }
      },
      timeout: const Timeout(Duration(minutes: 4)),
      skip: shouldRunIntegration
          ? (Platform.isMacOS
                ? 'Skipped on macOS: flaky HardwareKeyboard KeyUp mismatch in isolated slider run. Covered by the "run all integration tests" suite.'
                : null)
          : 'Skipped by default. Set RUN_INTEGRATION=1 to run external example integration tests.',
    );
  });
}
