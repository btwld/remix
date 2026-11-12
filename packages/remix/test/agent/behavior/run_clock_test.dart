import 'package:flutter_test/flutter_test.dart';
import 'package:remix/agent.dart';

void main() {
  var now = Duration.zero;
  late AgentRunClock clock;

  setUp(() {
    now = Duration.zero;
    clock = AgentRunClock(now: () => now);
  });

  tearDown(() => clock.dispose());

  test('measures a run from start to stop', () {
    expect(clock.isRunning, isFalse);
    expect(clock.elapsed, Duration.zero);
    clock.start();
    now += const Duration(milliseconds: 5600);
    expect(clock.isRunning, isTrue);
    expect(clock.elapsed, const Duration(milliseconds: 5600));
    clock.stop();
    now += const Duration(seconds: 10);
    expect(clock.elapsed, const Duration(milliseconds: 5600));
  });

  test('"Thought for Ns" rounds up, so any run reads at least 1s', () {
    expect(clock.elapsedSeconds, 0, reason: 'Nothing was measured yet.');
    clock.start();
    now += const Duration(milliseconds: 1);
    expect(clock.elapsedSeconds, 1);
    now = const Duration(seconds: 6);
    expect(clock.elapsedSeconds, 6);
    now = const Duration(milliseconds: 6001);
    expect(clock.elapsedSeconds, 7);
  });

  test('a pause for approval does not count as thinking', () {
    clock.start();
    now += const Duration(seconds: 2);
    clock.stop(); // awaiting approval
    now += const Duration(minutes: 2);
    clock.start(); // approved, running
    now += const Duration(seconds: 4);
    clock.stop();
    expect(clock.elapsed, const Duration(seconds: 6));
    expect(clock.elapsedSeconds, 6);
  });

  test('reset returns to zero for a new run', () {
    clock.start();
    now += const Duration(seconds: 3);
    clock.reset();
    expect(clock.isRunning, isFalse);
    expect(clock.elapsed, Duration.zero);
    clock.start();
    now += const Duration(seconds: 1);
    expect(clock.elapsed, const Duration(seconds: 1));
  });

  test('listeners hear start, stop and reset, and nothing redundant', () {
    var notified = 0;
    clock.addListener(() => notified++);
    clock
      ..start()
      ..start();
    expect(notified, 1);
    now += const Duration(seconds: 1);
    clock
      ..stop()
      ..stop();
    expect(notified, 2);
    clock.reset();
    expect(notified, 3);
    clock.reset();
    expect(notified, 3);
  });

  test('the default source is a real monotonic clock', () {
    final real = AgentRunClock()..start();
    addTearDown(real.dispose);
    final first = real.elapsed;
    expect(real.elapsed, greaterThanOrEqualTo(first));
  });
}
