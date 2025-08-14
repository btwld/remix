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
/// RemixSpinner(style: SpinnerStyles.primary)
///
/// // Custom spinner
/// RemixSpinner(
///   style: SpinnerStyle(
///     size: 32,
///     color: Colors.blue,
///     style: SpinnerStyleType.dotted,
///   ),
/// )
/// ```
class RemixSpinner extends StatelessWidget {
  const RemixSpinner({super.key, this.style = const SpinnerStyle.create()});

  /// The style configuration for the spinner.
  final SpinnerStyle style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: DefaultSpinnerStyle.merge(style),
      builder: (context, spec) {
        return SpinnerWidget(spec: spec);
      },
    );
  }
}

class SpinnerWidget extends StatefulWidget {
  const SpinnerWidget({super.key, required this.spec});

  final SpinnerSpec spec;

  @override
  State createState() => _SpinnerWidgetState();
}

class _SpinnerWidgetState extends State<SpinnerWidget>
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
  void didUpdateWidget(covariant SpinnerWidget oldWidget) {
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
    final style = spec.style ?? SpinnerStyleType.solid;

    final painter = style == SpinnerStyleType.dotted
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
