part of 'spinner.dart';

/// Resolved visual values for a [RemixSpinner].
@MixableSpec()
class RemixSpinnerSpec with _$RemixSpinnerSpec {
  @override
  final double? size;
  @override
  final double? strokeWidth;
  @override
  final Color? indicatorColor;
  @override
  final Color? trackColor;
  @override
  final double? trackStrokeWidth;
  @override
  final Duration? duration;

  const RemixSpinnerSpec({
    this.size,
    this.strokeWidth,
    this.indicatorColor,
    this.trackColor,
    this.trackStrokeWidth,
    this.duration,
  });
}
