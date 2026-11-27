part of 'skeleton.dart';

/// Resolved visual values for a [RemixSkeleton] placeholder.
@MixableSpec(target: RemixSkeleton.new)
class SkeletonSpec with _$SkeletonSpec {
  /// The placeholder surface.
  ///
  /// Owns explicit width/height/constraints, the base fill, decoration,
  /// radius, and any opacity modifier the caller attached.
  @override
  final StyleSpec<BoxSpec> container;

  /// The alternate fill the pulse animates toward.
  ///
  /// When [container] resolves a plain, unmasked fill color, the pulse
  /// interpolates between the two. When it does not — no fill color, or a
  /// gradient, image, or foreground decoration painting over one — the pulse
  /// instead fades the whole resolved container between full and half opacity,
  /// which multiplies rather than replaces an opacity the caller already
  /// applied to [container].
  @override
  final Color? pulseColor;

  /// The length of one forward pulse leg.
  ///
  /// Defaults to 1000 ms. The reverse leg takes the same time.
  @override
  final Duration? duration;

  /// The easing of each pulse leg, applied the same way in both directions.
  ///
  /// `null` keeps the linear pulse.
  @override
  final Curve? curve;

  /// How long the placeholder rests on its base frame before the first leg.
  ///
  /// Composers can stagger a list of placeholders by giving each a longer
  /// delay. `null` starts at once.
  @override
  final Duration? delay;

  /// How many pulses, each a forward and a reverse leg, to run before
  /// resting on the base frame. Must be greater than zero.
  ///
  /// `null` pulses for as long as the placeholder is loading.
  @override
  final int? cycles;

  const SkeletonSpec({
    StyleSpec<BoxSpec>? container,
    this.pulseColor,
    this.duration,
    this.curve,
    this.delay,
    this.cycles,
  }) : assert(cycles == null || cycles > 0),
       container = container ?? const StyleSpec(spec: BoxSpec());
}
