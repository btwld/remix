part of 'spinner.dart';

/// Resolved visual values for an eight-leaf [RemixSpinner].
@MixableSpec(target: RemixSpinner.new)
class SpinnerSpec with _$SpinnerSpec {
  @override
  final double? size;

  /// Established circular indicator stroke width.
  @override
  final double? strokeWidth;

  /// Established circular indicator color.
  @override
  final Color? indicatorColor;

  /// Established optional circular track color.
  @override
  final Color? trackColor;

  /// Established optional circular track stroke width.
  @override
  final double? trackStrokeWidth;

  /// Explicit color override. When absent the spinner uses inherited color.
  @override
  final Color? color;

  /// Opacity applied to the complete spinner before per-leaf fading.
  @override
  final double? opacity;

  /// Corner radius of each leaf.
  @override
  final Radius? leafRadius;

  /// Duration of one complete leaf-fade cycle.
  @override
  final Duration? duration;

  /// Length of the circular indicator's arc, in radians.
  ///
  /// Defaults to a third of a turn (`2 * pi / 3`). A full turn or more draws a
  /// closed ring. The leaf spinner ignores it.
  @override
  final double? sweepAngle;

  /// Shape of the circular indicator's arc ends.
  ///
  /// Defaults to [StrokeCap.butt]. The leaf spinner ignores it.
  @override
  final StrokeCap? strokeCap;

  const SpinnerSpec({
    this.size,
    this.strokeWidth,
    this.indicatorColor,
    this.trackColor,
    this.trackStrokeWidth,
    this.color,
    this.opacity,
    this.leafRadius,
    this.duration,
    this.sweepAngle,
    this.strokeCap,
  });
}

/// Backward-compatible name for [SpinnerSpec].
///
/// The generated style API is based on [SpinnerSpec], so resolved values use
/// `SpinnerSpec` as their runtime type.
typedef RemixSpinnerSpec = SpinnerSpec;
