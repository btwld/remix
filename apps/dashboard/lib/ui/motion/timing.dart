import 'dart:math' as math;

import 'package:flutter/physics.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../theme/theme.dart';

/// How one animated value travels to a new target: along a curve over a
/// fixed duration, or on a spring.
///
/// A spring starts from the value's current velocity, so a retarget in
/// mid-flight bends the motion instead of restarting it. A curve always
/// starts at rest.
@immutable
sealed class UiTiming {
  const UiTiming({this.delay = Duration.zero});

  /// Things arriving: 200 ms on [UiMotion.easeEnter].
  static const enter = UiCurveTiming(UiMotion.standard, UiMotion.easeEnter);

  /// Colour, opacity and leaving content: 150 ms on
  /// [UiMotion.easeStandard].
  static const fade = UiCurveTiming(UiMotion.fast, UiMotion.easeStandard);

  /// Hover feedback and the reduced-motion fade: 100 ms on
  /// [UiMotion.easeStandard].
  static const instant = UiCurveTiming(UiMotion.instant, UiMotion.easeStandard);

  /// [UiMotion.springSnappy].
  static const snappy = UiSpringTiming(UiMotion.springSnappy);

  /// [UiMotion.springSmooth].
  static const smooth = UiSpringTiming(UiMotion.springSmooth);

  /// [UiMotion.springMorph], for size and position changes.
  static const morph = UiSpringTiming(UiMotion.springMorph);

  /// A press scaling in: the [instant] curve.
  static const pressIn = instant;

  /// A press letting go: the [snappy] spring, which picks up the velocity
  /// the press left.
  static const pressRelease = snappy;

  /// Time before the value starts to move.
  final Duration delay;

  /// This timing starting [by] later.
  UiTiming delayed(Duration by);

  /// The motion from [from] to [to] for a value moving at [velocity] units
  /// per second, delay included.
  Simulation simulate(double from, double to, double velocity) {
    final motion = _simulate(from, to, velocity);
    if (delay == Duration.zero) return motion;

    return _DelayedSimulation(motion, _seconds(delay));
  }

  Simulation _simulate(double from, double to, double velocity);
}

/// [duration] along [curve], starting at rest.
final class UiCurveTiming extends UiTiming {
  const UiCurveTiming(this.duration, this.curve, {super.delay});

  final Duration duration;
  final Curve curve;

  @override
  UiCurveTiming delayed(Duration by) =>
      UiCurveTiming(duration, curve, delay: delay + by);

  @override
  Simulation _simulate(double from, double to, double velocity) =>
      _CurveSimulation(from, to, _seconds(duration), curve);

  @override
  bool operator ==(Object other) =>
      other is UiCurveTiming &&
      other.duration == duration &&
      other.curve == curve &&
      other.delay == delay;

  @override
  int get hashCode => Object.hash(duration, curve, delay);
}

/// A [spring] that carries the value's velocity into each new target.
final class UiSpringTiming extends UiTiming {
  const UiSpringTiming(this.spring, {super.delay});

  final SpringDescription spring;

  @override
  UiSpringTiming delayed(Duration by) =>
      UiSpringTiming(spring, delay: delay + by);

  @override
  Simulation _simulate(double from, double to, double velocity) =>
      SpringSimulation(
        spring,
        from,
        to,
        velocity,
        snapToEnd: true,
        tolerance: _springTolerance,
      );

  @override
  bool operator ==(Object other) =>
      other is UiSpringTiming &&
      other.spring.mass == spring.mass &&
      other.spring.stiffness == spring.stiffness &&
      other.spring.damping == spring.damping &&
      other.delay == delay;

  @override
  int get hashCode =>
      Object.hash(spring.mass, spring.stiffness, spring.damping, delay);
}

// Thousandths of a unit is below a device pixel and below a visible opacity
// step; the default velocity tolerance keeps a pixel-scale spring ticking for
// hundreds of milliseconds after it is still.
const _springTolerance = Tolerance(distance: 1e-3, velocity: 1e-2);

/// A [Curve] that follows [spring] from rest, for APIs that take a curve and
/// a duration (Mix `AnimationConfig.curve`, `AnimatedSwitcher`, route
/// transitions).
///
/// Pair it with [duration]: the time the spring takes to stay within
/// 0.3 percent of its travel, where the curve snaps to the end. That is the
/// cut the transform ease makes on [UiMotion.springCss] at
/// [UiMotion.spring].
final class UiSpringCurve extends Curve {
  UiSpringCurve(this.spring)
    : duration = _settleDuration(spring),
      _motion = SpringSimulation(spring, 0, 1, 0);

  /// The transform ease, over [UiMotion.spring].
  static final css = UiSpringCurve(UiMotion.springCss);

  /// [UiMotion.springSnappy] as a curve.
  static final snappy = UiSpringCurve(UiMotion.springSnappy);

  /// [UiMotion.springSmooth] as a curve.
  static final smooth = UiSpringCurve(UiMotion.springSmooth);

  final SpringDescription spring;

  /// How long this curve runs before it snaps to 1.
  final Duration duration;

  final SpringSimulation _motion;

  static Duration _settleDuration(SpringDescription spring) {
    final motion = SpringSimulation(spring, 0, 1, 0);
    var lastOutside = 0;
    for (var ms = 0; ms <= 5000; ms++) {
      if ((motion.x(ms / 1000) - 1).abs() > 0.003) lastOutside = ms;
    }

    return Duration(milliseconds: lastOutside + 1);
  }

  @override
  double transformInternal(double t) => _motion.x(t * _seconds(duration));
}

/// One animated number on a [UiMotionClock].
final class UiChannel {
  UiChannel._(double value) : _value = value, _target = value;

  double _value;
  double _target;
  Simulation? _motion;
  double _start = 0;

  /// The value on the clock's last frame.
  double get value => _value;

  /// Where the value is headed.
  double get target => _target;

  bool get isAnimating => _motion != null;

  double _velocityAt(double now) => _motion?.dx(now - _start) ?? 0;

  void _animate(double to, UiTiming timing, double now) {
    if (to == _target) return;
    final velocity = _velocityAt(now);
    _value = _motion?.x(now - _start) ?? _value;
    _target = to;
    _motion = timing.simulate(_value, to, velocity);
    _start = now;
  }

  void _jump(double to) {
    _value = to;
    _target = to;
    _motion = null;
  }

  void _tick(double now) {
    final motion = _motion;
    if (motion == null) return;
    final t = now - _start;
    if (motion.isDone(t)) {
      _value = _target;
      _motion = null;
    } else {
      _value = motion.x(t);
    }
  }
}

/// Drives a set of [UiChannel]s from one ticker and reports each frame.
///
/// The clock only runs while a channel moves. Its time keeps counting across
/// stops, so a channel's velocity is read at the frame it is retargeted on.
final class UiMotionClock {
  UiMotionClock(TickerProvider vsync, this._onFrame) {
    _ticker = vsync.createTicker(_handleTick);
  }

  final VoidCallback _onFrame;
  late final Ticker _ticker;
  final List<UiChannel> _channels = [];
  double _base = 0;
  double _elapsed = 0;

  double get _now => _base + _elapsed;

  bool get isAnimating => _channels.any((channel) => channel.isAnimating);

  /// A new channel resting at [value].
  UiChannel channel(double value) {
    final channel = UiChannel._(value);
    _channels.add(channel);

    return channel;
  }

  void remove(UiChannel channel) => _channels.remove(channel);

  /// Moves [channel] to [to] with [timing], or straight there when [jump].
  /// A target the channel already heads for leaves it as it is.
  void animate(
    UiChannel channel,
    double to,
    UiTiming timing, {
    bool jump = false,
  }) {
    if (jump) {
      if (to != channel._target) channel._jump(to);

      return;
    }
    channel._animate(to, timing, _now);
    if (channel.isAnimating && !_ticker.isActive) {
      _base = _now;
      _elapsed = 0;
      _ticker.start();
    }
  }

  void _handleTick(Duration elapsed) {
    _elapsed = elapsed.inMicroseconds / Duration.microsecondsPerSecond;
    for (final channel in _channels) {
      channel._tick(_now);
    }
    if (!isAnimating) {
      _base = _now;
      _elapsed = 0;
      _ticker.stop();
    }
    _onFrame();
  }

  void dispose() => _ticker.dispose();
}

double _seconds(Duration duration) =>
    duration.inMicroseconds / Duration.microsecondsPerSecond;

final class _CurveSimulation extends Simulation {
  _CurveSimulation(this._from, this._to, this._duration, this._curve);

  final double _from;
  final double _to;
  final double _duration;
  final Curve _curve;

  @override
  double x(double time) {
    if (time >= _duration) return _to;

    return _from +
        (_to - _from) * _curve.transform(math.max(0, time) / _duration);
  }

  @override
  double dx(double time) {
    if (time >= _duration) return 0;
    const step = 1e-4;
    final before = math.max(0.0, time - step);
    final after = math.min(_duration, time + step);

    return (x(after) - x(before)) / (after - before);
  }

  @override
  bool isDone(double time) => time >= _duration;
}

final class _DelayedSimulation extends Simulation {
  _DelayedSimulation(this._motion, this._delay);

  final Simulation _motion;
  final double _delay;

  @override
  double x(double time) => _motion.x(math.max(0, time - _delay));

  @override
  double dx(double time) => time < _delay ? 0 : _motion.dx(time - _delay);

  @override
  bool isDone(double time) => time >= _delay && _motion.isDone(time - _delay);
}
