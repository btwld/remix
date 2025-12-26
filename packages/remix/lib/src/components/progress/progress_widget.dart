part of 'progress.dart';

/// The [RemixProgress] widget is used to display a progress bar that indicates a
/// completion percentage between 0 and 1. It can be customized using the
/// [style] parameter to fit different design needs.
///
/// ## Example
///
/// ```dart
/// RemixProgress(
///   value: 0.5,
/// )
/// ```
class RemixProgress extends StyleWidget<RemixProgressSpec> {
  const RemixProgress({
    super.style = const RemixProgressStyle.create(),
    super.styleSpec,
    super.key,
    required this.value,
  }) : assert(
          value >= 0 && value <= 1,
          'Progress value must be between 0 and 1',
        );

  /// The progress value between 0 and 1.
  ///
  /// This value determines how much of the progress bar is filled.
  /// A value of 0 means empty, while 1 means completely filled.
  final double value;

  @override
  Widget build(BuildContext context, RemixProgressSpec spec) {
    return Box(
      styleSpec: spec.container,
      child: Stack(
        children: [
          // Track background
          Box(styleSpec: spec.track),
          // Indicator foreground based on value
          LayoutBuilder(
            builder: (context, constraints) {
              final biggestSize = constraints.biggest;

              return SizedBox(
                width: biggestSize.width * value.clamp(0.0, 1.0),
                child: Box(styleSpec: spec.indicator),
              );
            },
          ),
          // Track container (for any additional styling)
          Box(styleSpec: spec.trackContainer),
        ],
      ),
    );
  }
}
