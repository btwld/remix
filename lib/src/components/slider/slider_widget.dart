part of 'slider.dart';

/// A customizable slider component that supports various styles and behaviors.
/// The slider integrates with the Mix styling system and follows Remix design patterns.
///
/// ## Example
///
/// ```dart
/// RemixSlider(
///   min: 0.0,
///   max: 100.0,
///   value: 50.0,
///   onChanged: (value) {
///     print('Slider value changed: $value');
///   },
///   style: SliderStyle(),
/// )
/// ```
class RemixSlider extends StatefulWidget with HasEnabled {
  const RemixSlider({
    super.key,
    this.min = 0.0,
    this.max = 1.0,
    this.divisions,
    required this.onChanged,
    required this.value,
    this.onChangeEnd,
    this.onChangeStart,
    this.style = const RemixSliderStyle.create(),
    this.enabled = true,
    this.enableHapticFeedback = true,
    this.focusNode,
    this.autofocus = false,
  }) : assert(
          value >= min && value <= max,
          'Slider value must be between min and max values',
        );

  /// The minimum value the slider can have.
  final double min;

  /// The maximum value the slider can have.
  final double max;

  /// The number of discrete divisions the slider can move through.
  /// If it's 0, the slider moves continuously.
  final int? divisions;

  /// Whether the slider should automatically request focus when it is created.
  final bool autofocus;

  /// The current value of the slider.
  /// Must be between [min] and [max].
  final double value;

  /// The style configuration for the slider.
  final RemixSliderStyle style;

  /// Whether the slider is enabled for interaction.
  final bool enabled;

  /// Whether to provide haptic feedback during value changes.
  /// Defaults to true.
  final bool enableHapticFeedback;

  /// Called when the user starts dragging the slider.
  final ValueChanged<double>? onChangeStart;

  /// Called during drag with the new value.
  final ValueChanged<double>? onChanged;

  /// Called when the user is done selecting a new value.
  final ValueChanged<double>? onChangeEnd;

  /// The focus node for the slider.
  final FocusNode? focusNode;

  @override
  State<RemixSlider> createState() => _RemixSliderState();
}

class _RemixSliderState extends State<RemixSlider>
    with TickerProviderStateMixin, HasWidgetStateController, HasEnabledState {
  int? get _divisions {
    if (widget.divisions == 0) {
      return null;
    }

    return widget.divisions;
  }

  RemixSliderStyle get _style =>
      RemixSliderStyles.baseStyle.merge(widget.style);

  @override
  Widget build(BuildContext context) {
    return StyleBuilder(
      style: _style,
      controller: controller,
      builder: (context, spec) {
        // Use a fixed thumb size for simplicity
        final height = 24.0;
        final horizontalPadding = height;

        final sliderChild = SizedBox(
          height: height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final normalizedValue =
                  (widget.value - widget.min) / (widget.max - widget.min);
              final thumbPosition =
                  (constraints.maxWidth - horizontalPadding) * normalizedValue;

              return Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: horizontalPadding / 2,
                    ),
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: constraints.maxHeight,
                      child: _AnimatedTrack(
                        value: normalizedValue,
                        active: spec.activeTrack,
                        baseTrack: spec.baseTrack,
                        divisions: _divisions,
                        division: spec.division,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.linear,
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(thumbPosition, 0),
                    child: spec.thumb.createWidget(),
                  ),
                ],
              );
            },
          ),
        );

        final normalized =
            (widget.value - widget.min) / (widget.max - widget.min);
        final percent = (normalized * 100).round();

        return Semantics(
          enabled: widget.enabled,
          focusable: widget.enabled,
          value: '$percent%',
          child: NakedSlider(
            value: widget.value,
            min: widget.min,
            max: widget.max,
            onChanged: widget.onChanged,
            onDragStart: () => widget.onChangeStart?.call(widget.value),
            onDragEnd: widget.onChangeEnd,
            enabled: widget.enabled,
            focusNode: widget.focusNode,
            autofocus: widget.autofocus,
            direction: Axis.horizontal,
            divisions: _divisions,
            child: sliderChild,
          ),
        );
      },
    );
  }
}

// Custom painter for the track
class _TrackPainter extends CustomPainter {
  final double value;
  final Paint active;
  final Paint baseTrack;
  final int? divisions;
  final Paint division;

  const _TrackPainter({
    required this.value,
    required this.active,
    required this.baseTrack,
    required this.divisions,
    required this.division,
  });

  List<Offset> calculateDivisionsPositions(int divisions, Size size) {
    final list = <Offset>[];
    for (var i = 0; i < divisions; i++) {
      list.add(Offset((i + 1) * size.width / divisions, size.midY));
    }

    return list;
  }

  void drawDivisions(Canvas canvas, Size size) {
    canvas.drawPoints(
      PointMode.points,
      calculateDivisionsPositions(divisions!, size),
      division,
    );
  }

  void drawTrack(
    Canvas canvas,
    Offset initialOffset,
    Offset endOffset,
    Paint paint,
  ) {
    canvas.drawLine(initialOffset, endOffset, paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final initialOffset = Offset(0, size.midY);
    final endOffset = Offset(size.width, size.midY);

    drawTrack(canvas, initialOffset, endOffset, baseTrack);

    if (divisions != null) {
      drawDivisions(canvas, size);
    }

    drawTrack(
      canvas,
      initialOffset,
      Offset(size.width * value, size.midY),
      active,
    );
  }

  @override
  bool shouldRepaint(_TrackPainter oldDelegate) {
    return value != oldDelegate.value ||
        active != oldDelegate.active ||
        baseTrack != oldDelegate.baseTrack ||
        divisions != oldDelegate.divisions;
  }
}

extension on Size {
  double get midY => height / 2;
}

// Animated track widget for smooth color transitions
class _AnimatedTrack extends StatefulWidget {
  const _AnimatedTrack({
    required this.value,
    required this.active,
    required this.baseTrack,
    required this.divisions,
    required this.division,
    required this.duration,
    required this.curve,
  });

  final double value;
  final Paint active;
  final Paint baseTrack;
  final int? divisions;
  final Paint division;
  final Duration duration;
  final Curve curve;

  @override
  _AnimatedTrackState createState() => _AnimatedTrackState();
}

class _AnimatedTrackState extends State<_AnimatedTrack> {
  _Tracks? _oldTracks;

  @override
  void initState() {
    super.initState();
    _oldTracks = _Tracks(
      active: widget.active,
      baseTrack: widget.baseTrack,
      division: widget.division,
    );
  }

  @override
  void didUpdateWidget(covariant _AnimatedTrack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldTracks = _Tracks(
      active: oldWidget.active,
      baseTrack: oldWidget.baseTrack,
      division: oldWidget.division,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: _TracksTween(
        begin: _oldTracks,
        end: _Tracks(
          active: widget.active,
          baseTrack: widget.baseTrack,
          division: widget.division,
        ),
      ),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        return CustomPaint(
          painter: _TrackPainter(
            value: widget.value,
            active: value.active,
            baseTrack: value.baseTrack,
            divisions: widget.divisions,
            division: value.division,
          ),
        );
      },
    );
  }
}

// Helper class for animating track properties
class _Tracks {
  final Paint active;
  final Paint baseTrack;
  final Paint division;

  const _Tracks({
    required this.active,
    required this.baseTrack,
    required this.division,
  });

  @override
  bool operator ==(Object other) {
    return other is _Tracks &&
        active == other.active &&
        baseTrack == other.baseTrack &&
        division == other.division;
  }

  @override
  int get hashCode => active.hashCode ^ baseTrack.hashCode ^ division.hashCode;
}

// Tween for animating between track states
class _TracksTween extends Tween<_Tracks> {
  _TracksTween({required super.begin, required super.end});

  @override
  _Tracks lerp(double t) {
    return _Tracks(
      active: lerpPaint(begin!.active, end!.active, t),
      baseTrack: lerpPaint(begin!.baseTrack, end!.baseTrack, t),
      division: lerpPaint(begin!.division, end!.division, t),
    );
  }
}
