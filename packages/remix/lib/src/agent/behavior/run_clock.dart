import 'package:flutter/foundation.dart';

final Stopwatch _monotonic = Stopwatch()..start();

Duration _monotonicNow() => _monotonic.elapsed;

/// Measures how long a run worked, for "Thought for 6s".
///
/// It works like a [Stopwatch]: [start] begins or resumes, [stop] pauses or
/// ends, and [reset] returns to zero. Stop it while the run waits for an
/// approval, so time the reader spends deciding does not count as thinking.
///
/// Listeners hear [start], [stop] and [reset]; the clock does not tick.
class AgentRunClock extends ChangeNotifier {
  /// Creates a stopped clock at zero.
  ///
  /// [now] reads a monotonic time; it defaults to a running stopwatch. Tests
  /// pass a fake source.
  AgentRunClock({Duration Function()? now}) : _now = now ?? _monotonicNow;

  final Duration Function() _now;
  Duration _accumulated = Duration.zero;
  Duration? _startedAt;

  /// Whether the clock is measuring.
  bool get isRunning => _startedAt != null;

  /// The time measured so far, including the current stretch.
  Duration get elapsed {
    final startedAt = _startedAt;

    return startedAt == null
        ? _accumulated
        : _accumulated + (_now() - startedAt);
  }

  /// [elapsed] in whole seconds, rounded up, as the AI Elements reasoning
  /// summary counts them: any measured time reads as at least one second.
  int get elapsedSeconds {
    final microseconds = elapsed.inMicroseconds;

    return (microseconds + Duration.microsecondsPerSecond - 1) ~/
        Duration.microsecondsPerSecond;
  }

  /// Begins measuring, or resumes after [stop].
  void start() {
    if (isRunning) return;
    _startedAt = _now();
    notifyListeners();
  }

  /// Pauses measuring and keeps the time measured so far.
  void stop() {
    final startedAt = _startedAt;
    if (startedAt == null) return;
    _accumulated += _now() - startedAt;
    _startedAt = null;
    notifyListeners();
  }

  /// Stops and returns to zero, for a new run.
  void reset() {
    if (!isRunning && _accumulated == Duration.zero) return;
    _accumulated = Duration.zero;
    _startedAt = null;
    notifyListeners();
  }
}
