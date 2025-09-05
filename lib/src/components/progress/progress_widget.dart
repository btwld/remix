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
class RemixProgress extends StatelessWidget {
  const RemixProgress({
    super.key,
    required this.value,
    this.style = const RemixProgressStyle.create(),
  }) : assert(
          value >= 0 && value <= 1,
          'Progress value must be between 0 and 1',
        );

  /// The progress value between 0 and 1.
  ///
  /// This value determines how much of the progress bar is filled.
  /// A value of 0 means empty, while 1 means completely filled.
  final double value;

  /// The style configuration for the progress bar.
  final RemixProgressStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: DefaultRemixProgressStyle.merge(style),
      builder: (context, spec) {
        final Container = spec.container.createWidget;
        final Track = spec.track.createWidget;
        final Indicator = spec.indicator.createWidget;
        final TrackContainer = spec.trackContainer.createWidget;

        return Container(
          child: Stack(
            children: [
              // Track background
              Track(),
              // Indicator foreground based on value
              LayoutBuilder(
                builder: (context, constraints) {
                  final biggestSize = constraints.biggest;

                  return SizedBox(
                    width: biggestSize.width * value,
                    child: Indicator(),
                  );
                },
              ),
              // Track container (for any additional styling)
              TrackContainer(),
            ],
          ),
        );
      },
    );
  }
}
