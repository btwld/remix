part of 'avatar.dart';

/// How a [RemixAvatar] image appears once it has loaded, and how its fallback
/// appears when the image fails.
///
/// Set it through [AvatarSpec.imageTransition]. Under reduced motion both
/// appear at once, without blur.
@immutable
final class RemixAvatarImageTransition {
  const RemixAvatarImageTransition({
    required this.duration,
    this.curve = Curves.linear,
    this.blurSigma = 0,
    this.showFallbackWhileLoading = true,
  }) : assert(blurSigma >= 0, 'blurSigma must not be negative.');

  /// Length of the fade.
  final Duration duration;

  /// Easing of the fade and the blur.
  final Curve curve;

  /// Gaussian blur, in logical pixels, that the image starts from and clears
  /// as it fades in. Zero fades without blur.
  final double blurSigma;

  /// Whether the fallback stays visible while the image loads.
  ///
  /// When false, only the container paints while loading, and the fallback
  /// fades in with [duration] and [curve] if the image fails. When true, the
  /// fallback is already visible, so a failure shows it without a fade.
  final bool showFallbackWhileLoading;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RemixAvatarImageTransition &&
          other.duration == duration &&
          other.curve == curve &&
          other.blurSigma == blurSigma &&
          other.showFallbackWhileLoading == showFallbackWhileLoading;

  @override
  int get hashCode =>
      Object.hash(duration, curve, blurSigma, showFallbackWhileLoading);
}

/// Fades [child] in from transparent, clearing [blurSigma] as it goes, once
/// per mount.
class _RemixAvatarAppear extends StatefulWidget {
  const _RemixAvatarAppear({
    required this.transition,
    required this.child,
    this.blurSigma = 0,
  });

  final RemixAvatarImageTransition transition;
  final double blurSigma;
  final Widget child;

  @override
  State<_RemixAvatarAppear> createState() => _RemixAvatarAppearState();
}

class _RemixAvatarAppearState extends State<_RemixAvatarAppear>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.transition.duration,
  );
  late final CurvedAnimation _progress = CurvedAnimation(
    parent: _controller,
    curve: widget.transition.curve,
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (remixReducedMotionOf(context)) {
      _controller.value = 1;
    } else {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _progress.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      child: widget.child,
      builder: (context, child) {
        final t = _progress.value;
        final sigma = widget.blurSigma * (1 - t);

        return Opacity(
          opacity: t.clamp(0.0, 1.0),
          alwaysIncludeSemantics: true,
          child: sigma > 0
              ? ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                  child: child,
                )
              : child,
        );
      },
    );
  }
}
