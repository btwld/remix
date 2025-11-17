part of 'spinner.dart';

/// The [RemixSpinner] widget is used to display a loading spinner.
/// It can be customized using the [style] parameter to fit different design needs.
///
/// ## Examples
///
/// ```dart
/// // Basic spinner
/// RemixSpinner()
///
/// // Custom spinner with track
/// RemixSpinner(
///   style: RemixSpinnerStyle(
///     size: 32,
///     indicatorColor: Colors.blue,
///     trackColor: Colors.blue.withValues(alpha: 0.2),
///   ),
/// )
/// ```
class RemixSpinner extends StyleWidget<RemixSpinnerSpec> {
  const RemixSpinner({
    super.style = const RemixSpinnerStyle.create(),
    super.styleSpec,
    super.key,
  });

  @override
  Widget build(BuildContext context, RemixSpinnerSpec spec) {
    return _SpinnerSpecWidget(spec: spec);
  }
}

class _SpinnerSpecWidget extends StatefulWidget {
  const _SpinnerSpecWidget({required this.spec});

  final RemixSpinnerSpec spec;

  @override
  State createState() => _SpinnerSpecWidgetState();
}

class _SpinnerSpecWidgetState extends State<_SpinnerSpecWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.spec.duration ?? RemixAnimationDurations.spinner,
      vsync: this,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant _SpinnerSpecWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newDuration =
        widget.spec.duration ?? RemixAnimationDurations.spinner;
    final oldDuration =
        oldWidget.spec.duration ?? RemixAnimationDurations.spinner;
    if (oldDuration != newDuration) {
      controller.duration = newDuration;
      controller.repeat();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spec = widget.spec;
    final indicatorColor =
        spec.indicatorColor ?? Theme.of(context).colorScheme.primary;
    final trackColor = spec.trackColor;
    final strokeWidth = spec.strokeWidth ?? 1.5;
    final size = spec.size ?? 24;

    final painter = RemixSpinnerPainter(
      animation: controller,
      strokeWidth: strokeWidth,
      indicatorColor: indicatorColor,
      trackColor: trackColor,
      trackStrokeWidth: spec.trackStrokeWidth,
    );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(painter: painter, size: Size(size, size));
      },
    );
  }
}

Widget createSpinnerWidget(RemixSpinnerSpec spec) {
  return _SpinnerSpecWidget(spec: spec);
}
