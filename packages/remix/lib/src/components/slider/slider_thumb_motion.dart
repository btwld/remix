part of 'slider.dart';

/// Builds with the painted percentage of each thumb, moving it toward its
/// [targets] entry with [motion] instead of jumping.
///
/// A thumb that was already being dragged in the previous build follows the
/// pointer, unless a move started by the press is still running; then the
/// move is retargeted so the thumb catches up without a jump.
class _SliderThumbMotion extends StatefulWidget {
  const _SliderThumbMotion({
    required this.targets,
    required this.draggedIndex,
    required this.motion,
    required this.builder,
  });

  final List<double> targets;
  final int? draggedIndex;
  final AnimationConfig? motion;
  final Widget Function(BuildContext context, List<double> painted) builder;

  @override
  State<_SliderThumbMotion> createState() => _SliderThumbMotionState();
}

class _SliderThumbMotionState extends State<_SliderThumbMotion>
    with TickerProviderStateMixin {
  final _thumbs = <AnimationController>[];
  final _targets = <double>[];

  @override
  void initState() {
    super.initState();
    _sync(null);
  }

  @override
  void didUpdateWidget(_SliderThumbMotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync(oldWidget);
  }

  void _sync(_SliderThumbMotion? oldWidget) {
    final targets = widget.targets;
    while (_thumbs.length > targets.length) {
      _thumbs.removeLast().dispose();
      _targets.removeLast();
    }
    final motion = widget.motion;
    final jumpAll =
        oldWidget == null || motion == null || remixReducedMotionOf(context);
    for (var i = 0; i < targets.length; i++) {
      final target = targets[i];
      if (i == _thumbs.length) {
        _targets.add(target);
        _thumbs.add(
          AnimationController.unbounded(vsync: this, value: target)
            ..addListener(_repaint),
        );
        continue;
      }
      if (_targets[i] == target) continue;
      _targets[i] = target;
      final thumb = _thumbs[i];
      final following = oldWidget?.draggedIndex == i && !thumb.isAnimating;
      if (jumpAll || following) {
        thumb.value = target;
      } else {
        _move(thumb, target, motion);
      }
    }
  }

  void _move(AnimationController thumb, double target, AnimationConfig motion) {
    switch (motion) {
      case SpringAnimationConfig(:final spring, :final onEnd):
        thumb
            .animateWith(
              SpringSimulation(
                spring,
                thumb.value,
                target,
                thumb.velocity,
                snapToEnd: true,
              ),
            )
            .then((_) => onEnd?.call());
      case CurveAnimationConfig(:final curve, :final delay, :final onEnd):
        final total = motion.totalDuration;
        thumb
            .animateTo(
              target,
              duration: total,
              curve: delay > Duration.zero
                  ? Interval(
                      delay.inMicroseconds / total.inMicroseconds,
                      1,
                      curve: curve,
                    )
                  : curve,
            )
            .then((_) => onEnd?.call());
      default:
        thumb.value = target;
    }
  }

  void _repaint() => setState(() {});

  @override
  void dispose() {
    for (final thumb in _thumbs) {
      thumb.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, [for (final thumb in _thumbs) thumb.value]);
}
