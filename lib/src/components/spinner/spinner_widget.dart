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
///     color: RemixTokens.primary(),
///     type: SpinnerType.dotted,
///   ),
/// )
/// ```
class RemixSpinner extends StyleWidget<SpinnerSpec> {
  const RemixSpinner({
    super.style = const RemixSpinnerStyle.create(),
    super.styleSpec,
    super.key,
  });

  @override
  Widget build(BuildContext context, SpinnerSpec spec) {
    return _SpinnerSpecWidget(spec: spec);
  }
}

class _SpinnerSpecWidget extends StatefulWidget {
  const _SpinnerSpecWidget({required this.spec});

  final SpinnerSpec spec;

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
      duration: widget.spec.duration ?? const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant _SpinnerSpecWidget oldWidget) {
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
    final color = spec.color ?? Theme.of(context).colorScheme.primary;
    final strokeWidth = spec.strokeWidth ?? 1.5;
    final size = spec.size ?? 24;
    final type = spec._type ?? SpinnerType.solid;

    final painter = type == SpinnerType.dotted
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

Widget createSpinnerWidget(SpinnerSpec spec) {
  return _SpinnerSpecWidget(spec: spec);
}
