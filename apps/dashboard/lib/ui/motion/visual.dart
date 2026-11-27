import 'dart:ui' show ImageFilter, TileMode;

import 'package:flutter/widgets.dart';
import 'package:remix/remix.dart';

import 'timing.dart';

/// The paint-only state of an element: how opaque it is, where it sits
/// relative to its layout slot, how large it draws, and how blurred.
@immutable
final class UiVisual {
  const UiVisual({
    this.opacity = 1,
    this.offset = Offset.zero,
    this.scale = 1,
    this.blur = 0,
  });

  /// Fully shown, in place, unscaled and sharp.
  static const rest = UiVisual();

  final double opacity;

  /// Logical pixels from the layout slot.
  final Offset offset;

  final double scale;

  /// Gaussian blur standard deviation in logical pixels, as CSS
  /// `filter: blur()` takes it.
  final double blur;

  @override
  bool operator ==(Object other) =>
      other is UiVisual &&
      other.opacity == opacity &&
      other.offset == offset &&
      other.scale == scale &&
      other.blur == blur;

  @override
  int get hashCode => Object.hash(opacity, offset, scale, blur);
}

/// One timing per channel of a [UiVisual]: opacity, transform (offset
/// and scale) and blur.
@immutable
final class UiVisualTiming {
  const UiVisualTiming({
    required this.opacity,
    required this.transform,
    UiTiming? blur,
  }) : blur = blur ?? opacity;

  /// Every channel on [timing].
  const UiVisualTiming.all(UiTiming timing)
    : opacity = timing,
      transform = timing,
      blur = timing;

  final UiTiming opacity;
  final UiTiming transform;

  /// Defaults to [opacity].
  final UiTiming blur;

  /// Every channel starting [by] later.
  UiVisualTiming delayed(Duration by) => UiVisualTiming(
    opacity: opacity.delayed(by),
    transform: transform.delayed(by),
    blur: blur.delayed(by),
  );

  @override
  bool operator ==(Object other) =>
      other is UiVisualTiming &&
      other.opacity == opacity &&
      other.transform == transform &&
      other.blur == blur;

  @override
  int get hashCode => Object.hash(opacity, transform, blur);
}

/// Animates its child's [visual] with a separate timing per channel, so a
/// spring can drive the transform while a short curve drives the opacity.
///
/// Mix runs one animation config per styler; this covers the elements that
/// need two. With [initial] set, the child animates from it to [visual] when
/// it first builds.
///
/// Under reduced motion the offset, scale and blur jump to their targets and
/// opacity fades over [UiTiming.instant].
class UiAnimatedVisual extends StatelessWidget {
  const UiAnimatedVisual({
    super.key,
    required this.visual,
    required this.timing,
    this.initial,
    this.alignment = Alignment.center,
    this.onEnd,
    required this.child,
  });

  final UiVisual visual;
  final UiVisualTiming timing;
  final UiVisual? initial;

  /// The origin of [UiVisual.scale].
  final AlignmentGeometry alignment;

  /// Called when every channel has reached [visual] after a change.
  final VoidCallback? onEnd;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return RemixReducedMotionBuilder(
      builder: (context, reduceMotion) => _AnimatedVisual(
        visual: visual,
        timing: timing,
        initial: initial,
        alignment: alignment,
        onEnd: onEnd,
        reduceMotion: reduceMotion,
        child: child,
      ),
    );
  }
}

class _AnimatedVisual extends StatefulWidget {
  const _AnimatedVisual({
    required this.visual,
    required this.timing,
    required this.initial,
    required this.alignment,
    required this.onEnd,
    required this.reduceMotion,
    required this.child,
  });

  final UiVisual visual;
  final UiVisualTiming timing;
  final UiVisual? initial;
  final AlignmentGeometry alignment;
  final VoidCallback? onEnd;
  final bool reduceMotion;
  final Widget child;

  @override
  State<_AnimatedVisual> createState() => _AnimatedVisualState();
}

class _AnimatedVisualState extends State<_AnimatedVisual>
    with SingleTickerProviderStateMixin {
  late final UiMotionClock _clock = UiMotionClock(this, _handleFrame);
  late final UiChannel _opacity;
  late final UiChannel _dx;
  late final UiChannel _dy;
  late final UiChannel _scale;
  late final UiChannel _blur;

  @override
  void initState() {
    super.initState();
    final start = widget.initial ?? widget.visual;
    _opacity = _clock.channel(start.opacity);
    _dx = _clock.channel(start.offset.dx);
    _dy = _clock.channel(start.offset.dy);
    _scale = _clock.channel(start.scale);
    _blur = _clock.channel(start.blur);
    if (widget.initial != null) _retarget();
  }

  @override
  void didUpdateWidget(_AnimatedVisual oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visual != oldWidget.visual) _retarget();
  }

  void _retarget() {
    final visual = widget.visual;
    final timing = widget.timing;
    final reduce = widget.reduceMotion;
    _clock
      ..animate(
        _opacity,
        visual.opacity,
        reduce ? UiTiming.instant : timing.opacity,
      )
      ..animate(_dx, visual.offset.dx, timing.transform, jump: reduce)
      ..animate(_dy, visual.offset.dy, timing.transform, jump: reduce)
      ..animate(_scale, visual.scale, timing.transform, jump: reduce)
      ..animate(_blur, visual.blur, timing.blur, jump: reduce);
    if (!_clock.isAnimating && widget.onEnd != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onEnd?.call();
      });
    }
  }

  void _handleFrame() {
    setState(() {});
    if (!_clock.isAnimating) widget.onEnd?.call();
  }

  @override
  void dispose() {
    _clock.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blur = _blur.value < 0 ? 0.0 : _blur.value;

    return Opacity(
      opacity: _opacity.value.clamp(0.0, 1.0),
      child: Transform.translate(
        offset: Offset(_dx.value, _dy.value),
        child: Transform.scale(
          scale: _scale.value,
          alignment: widget.alignment,
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: blur,
              sigmaY: blur,
              tileMode: TileMode.decal,
            ),
            enabled: blur > 0.01,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
