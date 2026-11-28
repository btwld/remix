part of 'skeleton.dart';

/// One forward pulse leg when [SkeletonSpec.duration] is absent.
const _defaultPulseLeg = Duration(milliseconds: 1000);

/// Lowest opacity reached by the generic pulse fallback.
///
/// Only used when the container resolves no fill color to interpolate, so the
/// placeholder still reads as animated without inventing a color policy.
const _fallbackPulseOpacity = 0.5;

/// A decorative loading placeholder that preserves the geometry of its child.
///
/// While [loading] the child stays mounted so its intrinsic size and local
/// state survive, but it cannot be painted, tapped, focused, read by
/// assistive technology, or ticked. Set [loading] to false to hand the child
/// back its normal behavior without remounting it.
///
/// There is deliberately no Naked primitive behind this widget. Naked
/// primitives exist to own an interaction contract; Skeleton has none to own —
/// it exists to *remove* interaction from whatever it wraps. The one piece of
/// behavior it does own, an animation controller reacting to reduced motion,
/// follows `spinner/spinner_widget.dart`.
///
/// A skeleton is decorative and exposes no loading or progress semantics.
/// Applications that need to announce loading should render their own labelled
/// status region beside it.
///
/// ## Example
///
/// ```dart
/// RemixSkeleton(
///   loading: isLoading,
///   style: SkeletonStyler().container(
///     BoxStyler().color(Color(0x1F000000)).borderRadius(.circular(4)),
///   ),
///   child: const Text('Jane Appleseed'),
/// )
/// ```
class RemixSkeleton extends StyleWidget<SkeletonSpec> {
  /// Creates a loading placeholder.
  const RemixSkeleton({
    Key? key,
    this.child,
    this.loading = true,
    Style<SkeletonSpec> style = const SkeletonStyler.create(),
    StyleSpec<SkeletonSpec>? styleSpec,
  }) : super(key: key, style: style, styleSpec: styleSpec);

  static final styleFrom = SkeletonStyler.new;

  /// The content the placeholder stands in for.
  ///
  /// When present it keeps sizing the skeleton in both states, so switching
  /// [loading] never changes the layout.
  final Widget? child;

  /// Whether to show the placeholder instead of [child].
  final bool loading;

  @override
  Widget build(BuildContext context, SkeletonSpec spec) {
    final child = this.child;
    if (child == null && !loading) return const SizedBox.shrink();

    Widget pulse() => RemixReducedMotionBuilder(
      builder: (context, reduceMotion) =>
          _SkeletonPulse(spec: spec, reduceMotion: reduceMotion),
    );
    if (child == null) return pulse();

    return _SkeletonReveal(
      loading: loading,
      spec: spec,
      pulse: pulse,
      child: child,
    );
  }
}

/// Lays the pulse over the hidden child and plays the reveal.
class _SkeletonReveal extends StatefulWidget {
  const _SkeletonReveal({
    required this.loading,
    required this.spec,
    required this.pulse,
    required this.child,
  });

  final bool loading;
  final SkeletonSpec spec;
  final Widget Function() pulse;
  final Widget child;

  @override
  State<_SkeletonReveal> createState() => _SkeletonRevealState();
}

class _SkeletonRevealState extends State<_SkeletonReveal>
    with SingleTickerProviderStateMixin {
  // At 1 the child is fully shown; a reveal runs it from 0.
  late final AnimationController _reveal = AnimationController(
    vsync: this,
    value: 1,
  );

  @override
  void didUpdateWidget(covariant _SkeletonReveal oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.loading) {
      _reveal.value = 1;

      return;
    }
    final duration = widget.spec.revealDuration;
    if (!oldWidget.loading ||
        duration == null ||
        duration <= Duration.zero ||
        remixReducedMotionOf(context)) {
      return;
    }
    _reveal
      ..duration = duration
      ..forward(from: 0);
  }

  @override
  void dispose() {
    _reveal.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loading = widget.loading;
    final curve = widget.spec.revealCurve ?? Curves.easeOut;
    final offset = widget.spec.revealOffset ?? Offset.zero;

    return AnimatedBuilder(
      animation: _reveal,
      builder: (context, child) => _layers(
        loading: loading,
        revealing: !loading && _reveal.value < 1,
        shown: loading ? 0 : curve.transform(_reveal.value),
        placeholder: loading ? 1 : 1 - _reveal.value,
        offset: offset,
        child: child!,
      ),
      child: widget.child,
    );
  }

  Widget _layers({
    required bool loading,
    required bool revealing,
    required double shown,
    required double placeholder,
    required Offset offset,
    required Widget child,
  }) {
    return ExcludeSemantics(
      // The single semantics control for both states. It sits outside the
      // Stack so it covers the pulse overlay as well as the hidden child.
      excluding: loading,
      child: Stack(
        // Provably a no-op: the single non-positioned child sizes the
        // stack, so there is nothing left to align. Spelling it
        // non-directionally keeps a decorative placeholder from requiring
        // an ambient Directionality.
        alignment: Alignment.topLeft,
        fit: StackFit.passthrough,
        children: [
          // One wrapper chain, one child slot, both states. Only the flags
          // change, so the child element — and its local state — survives
          // every loading toggle, and mounting the pulse sibling below
          // never reparents it.
          TickerMode(
            enabled: !loading,
            child: ExcludeFocus(
              // Also releases focus already held inside the child:
              // FocusNode.descendantsAreFocusable unfocuses on the way down.
              excluding: loading,
              child: IgnorePointer(
                ignoring: loading,
                child: Opacity(
                  // Paint hiding only. The ExcludeSemantics wrapping the
                  // Stack is the accessibility control.
                  opacity: shown,
                  child: Transform.translate(
                    offset: revealing ? offset * (1 - shown) : Offset.zero,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
          if (loading || revealing)
            Positioned.fill(
              // The fading placeholder never takes input from the content.
              child: IgnorePointer(
                ignoring: !loading,
                child: ExcludeSemantics(
                  child: Opacity(opacity: placeholder, child: widget.pulse()),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The animated placeholder surface.
///
/// Mounted only while loading, and only ever as a sibling of the child.
class _SkeletonPulse extends StatefulWidget {
  const _SkeletonPulse({required this.spec, required this.reduceMotion});

  final SkeletonSpec spec;
  final bool reduceMotion;

  @override
  State<_SkeletonPulse> createState() => _SkeletonPulseState();
}

class _SkeletonPulseState extends State<_SkeletonPulse>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _delay;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _resolveLeg(widget.spec.duration),
      vsync: this,
    );
    _syncMotion();
  }

  @override
  void didUpdateWidget(covariant _SkeletonPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.reduceMotion != widget.reduceMotion) _syncMotion();

    final leg = _resolveLeg(widget.spec.duration);
    if (_controller.duration == leg) return;

    // Retune in place. Replacing the controller would drop the current phase
    // and restart the pulse from its base frame.
    _controller.duration = leg;
    if (_controller.isAnimating) _pulse();
  }

  @override
  void dispose() {
    _delay?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _syncMotion() {
    _delay?.cancel();
    _delay = null;
    if (widget.reduceMotion) {
      _controller.stop();
      // Deterministic base frame, so a static placeholder always paints the
      // container exactly as styled.
      _controller.value = _controller.lowerBound;

      return;
    }

    if (_controller.isAnimating) return;
    final delay = widget.spec.delay ?? Duration.zero;
    if (delay > Duration.zero) {
      _delay = Timer(delay, _pulse);
    } else {
      _pulse();
    }
  }

  void _pulse() {
    _delay = null;
    final cycles = widget.spec.cycles;
    if (cycles == null) {
      _controller.repeat(reverse: true);

      return;
    }

    // Each cycle is a forward and a reverse leg.
    _controller.repeat(reverse: true, count: cycles * 2).then((_) {
      if (mounted) _controller.value = _controller.lowerBound;
    });
  }

  @override
  Widget build(BuildContext context) {
    final container = widget.spec.container;
    final fillPulse = _fillPulse(container.spec, widget.spec.pulseColor);
    final curve = widget.spec.curve ?? Curves.linear;

    if (fillPulse == null) {
      // Nothing to interpolate, so fade the resolved container instead. The
      // caller's own opacity modifier renders inside Box, which makes the two
      // opacities compose rather than one replacing the other.
      return AnimatedBuilder(
        animation: _controller,
        child: Box(styleSpec: container),
        builder: (context, child) => Opacity(
          opacity: lerpDouble(
            1,
            _fallbackPulseOpacity,
            curve.transform(_controller.value),
          )!,
          child: child,
        ),
      );
    }

    // Paint-only interpolation: the constraints, padding, and shape of the
    // container are untouched, so no pulse frame can change layout.
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => Box(
        // A fresh StyleSpec rather than copyWith, which cannot clear a field.
        // Any animation the caller put on the container has to be dropped
        // here: the pulse already animates this decoration, and an implicit
        // animation re-driven from a value that changes every tick chases the
        // pulse instead of tracking it, damping it so the fill never reaches
        // pulseColor. Modifiers still belong to the caller, so they carry over.
        styleSpec: StyleSpec(
          spec: container.spec.copyWith(
            decoration: fillPulse(curve.transform(_controller.value)),
          ),
          widgetModifiers: container.widgetModifiers,
        ),
      ),
    );
  }
}

Duration _resolveLeg(Duration? value) {
  if (value == null) return _defaultPulseLeg;
  assert(
    value > Duration.zero,
    'SkeletonSpec.duration must be greater than zero.',
  );

  return value > Duration.zero ? value : _defaultPulseLeg;
}

/// Builds the decoration for one pulse frame, or null when [box] has no fill
/// the pulse can visibly interpolate.
///
/// Interpolating the fill is only honest when the fill is what the container
/// actually shows. Anything painted over it can hide the animation completely:
/// a gradient replaces the fill, an image covers it, and a foreground
/// decoration paints on top of everything. Whether a given layer is opaque
/// enough to hide the fill cannot be decided reliably — a translucent color, a
/// gradient with clear stops, and a sparse image all look the same from here —
/// so every masked or non-plain paint falls through to the whole-surface
/// opacity pulse, which stays visible whatever the container paints.
Decoration Function(double t)? _fillPulse(BoxSpec box, Color? pulseColor) {
  if (pulseColor == null) return null;
  if (box.foregroundDecoration != null) return null;

  switch (box.decoration) {
    case final BoxDecoration base
        when base.gradient == null && base.image == null:
      final color = base.color;
      if (color == null) return null;

      return (t) => base.copyWith(color: Color.lerp(color, pulseColor, t));

    case final ShapeDecoration shape
        when shape.gradient == null && shape.image == null:
      final color = shape.color;
      if (color == null) return null;

      return (t) => ShapeDecoration(
        color: Color.lerp(color, pulseColor, t),
        shadows: shape.shadows,
        shape: shape.shape,
      );

    default:
      return null;
  }
}
