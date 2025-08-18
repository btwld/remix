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
/// // Primary spinner
/// RemixSpinner(style: RemixSpinnerStyles.primary)
///
/// // Custom spinner
/// RemixSpinner(
///   style: RemixSpinnerStyle(
///     size: 32,
///     color: Colors.blue,
///     style: SpinnerStyleType.dotted,
///   ),
/// )
/// ```
class RemixSpinner extends StatelessWidget {
  const RemixSpinner(
      {super.key, this.style = const RemixSpinnerStyle.create()});

  /// The style configuration for the spinner.
  final RemixSpinnerStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: DefaultRemixSpinnerStyle.merge(style),
      builder: (context, spec) {
        return SpinnerSpecWidget(spec: spec);
      },
    );
  }
}

class SpinnerSpecWidget extends StatefulWidget {
  const SpinnerSpecWidget({super.key, required this.spec});

  final SpinnerSpec spec;

  @override
  State createState() => _SpinnerSpecWidgetState();
}

class _SpinnerSpecWidgetState extends State<SpinnerSpecWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: widget.spec.duration ?? const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant SpinnerSpecWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final newDuration =
        widget.spec.duration ?? const Duration(milliseconds: 1000);
    final oldDuration =
        oldWidget.spec.duration ?? const Duration(milliseconds: 1000);
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
    final color = spec.color ?? Colors.black;
    final strokeWidth = spec.strokeWidth ?? 1.5;
    final size = spec.size ?? 24;
    final style = spec.style ?? SpinnerStyle.solid;

    final painter = style == SpinnerStyle.dotted
        ? DottedSpinnerPainter(
            animation: controller,
            strokeWidth: strokeWidth,
            color: color,
          )
        : SolidSpinnerPainter(
            animation: controller,
            strokeWidth: strokeWidth,
            color: color,
          );

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return CustomPaint(painter: painter, size: Size(size, size));
      },
    );
  }
}

/// Extension on SpinnerSpec to provide call() method for creating widgets
extension SpinnerSpecWidgetExtension on SpinnerSpec {
  /// Renders the SpinnerSpec into a SpinnerSpecWidget
  Widget call() {
    return SpinnerSpecWidget(spec: this);
  }
}
