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
  RemixSlider({
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

  RemixSliderStyle get _style => widget.style;

  @override
  Widget build(BuildContext context) {
    return StyleBuilder<SliderSpec>(
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
              /// **Value Normalization Algorithm**
              /// Converts the slider's actual value to a 0.0-1.0 range for positioning.
              /// Formula: (current - min) / (max - min)
              ///
              /// This normalization is essential because:
              /// - UI positioning works in pixel coordinates (0 to width)
              /// - Slider values can be any range (e.g., -50 to 150, 0 to 1000)
              /// - We need a consistent way to map between value space and pixel space
              final normalizedValue =
                  (widget.value - widget.min) / (widget.max - widget.min);

              /// **Thumb Position Calculation**
              /// Maps normalized value (0.0-1.0) to actual pixel position.
              ///
              /// **Algorithm:**
              /// Available space = total width - padding for thumb overflow
              /// Thumb position = available space × normalized value
              ///
              /// **Why subtract horizontalPadding:**
              /// The thumb needs space to move beyond the track edges when at min/max.
              /// Without this adjustment, the thumb would be clipped at the edges.
              ///
              /// **Example:**
              /// - Constraints width: 300px
              /// - Horizontal padding: 24px
              /// - Available space: 276px
              /// - At 50% value: thumb positioned at 138px from left edge
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

/// Custom painter for drawing slider track with optional divisions.
///
/// This painter renders three visual elements:
/// 1. **Base track**: The full-width background rail
/// 2. **Active track**: The filled portion showing current progress
/// 3. **Divisions**: Optional tick marks for discrete values
///
/// **Coordinate System:**
/// Uses standard Canvas coordinates where (0,0) is top-left.
/// Track is drawn horizontally across the full width at vertical center.
///
/// **Performance Considerations:**
/// Repaints only when value, colors, or divisions change.
/// Division positions are calculated once per paint cycle.
class _TrackPainter extends CustomPainter {
  /// Normalized value between 0.0 and 1.0 representing current position.
  final double value;

  /// Paint configuration for the active (filled) portion of the track.
  final Paint active;

  /// Paint configuration for the base (unfilled) track background.
  final Paint baseTrack;

  /// Number of discrete divisions to draw as tick marks.
  /// If null, track is continuous without divisions.
  final int? divisions;

  /// Paint configuration for division tick marks.
  final Paint division;

  const _TrackPainter({
    required this.value,
    required this.active,
    required this.baseTrack,
    required this.divisions,
    required this.division,
  });

  /// Calculates pixel positions for division tick marks along the track.
  ///
  /// **Algorithm:**
  /// Divides the track width into equal segments and places tick marks
  /// at the boundaries between segments (not at the start/end).
  ///
  /// **Mathematical Formula:**
  /// For `n` divisions, there are `n-1` tick marks positioned at:
  /// `x = (i + 1) × width ÷ divisions` where i = 0 to n-2
  ///
  /// **Why This Formula:**
  /// - Creates `divisions` number of equal value segments
  /// - Places ticks between segments, not at min/max positions
  /// - Avoids visual clutter at track endpoints where thumb sits
  ///
  /// **Example:**
  /// For 4 divisions on a 200px track:
  /// - Segment size: 50px each
  /// - Tick positions: 50px, 100px, 150px (3 ticks)
  /// - Creates 4 selectable ranges: [0-50], [50-100], [100-150], [150-200]
  ///
  /// All ticks are positioned at vertical center (midY) of the track.
  List<Offset> calculateDivisionsPositions(int divisions, Size size) {
    final list = <Offset>[];
    for (var i = 0; i < divisions; i++) {
      list.add(Offset((i + 1) * size.width / divisions, size.midY));
    }

    return list;
  }

  /// Renders division tick marks as individual points on the canvas.
  ///
  /// Uses Flutter's `drawPoints` with `PointMode.points` to efficiently
  /// draw multiple small circles in a single call. Each point represents
  /// a discrete value position that the slider can snap to.
  ///
  /// **Visual Result:**
  /// Creates small circular dots along the track, styled according
  /// to the division Paint configuration (color, size, etc.).
  void drawDivisions(Canvas canvas, Size size) {
    canvas.drawPoints(
      PointMode.points,
      calculateDivisionsPositions(divisions!, size),
      division,
    );
  }

  /// Draws a horizontal line segment representing part of the slider track.
  ///
  /// **Purpose:**
  /// This helper method is used to draw both the base track (full width)
  /// and the active track (partial width based on current value).
  ///
  /// **Parameters:**
  /// - `initialOffset`: Starting point of the line segment
  /// - `endOffset`: Ending point of the line segment
  /// - `paint`: Visual styling for the line (color, thickness, etc.)
  ///
  /// **Usage:**
  /// Called twice in paint(): once for base track, once for active track.
  void drawTrack(
    Canvas canvas,
    Offset initialOffset,
    Offset endOffset,
    Paint paint,
  ) {
    canvas.drawLine(initialOffset, endOffset, paint);
  }

  /// Main painting method that renders the complete slider track.
  ///
  /// **Rendering Order (important for layering):**
  /// 1. Base track (full-width background)
  /// 2. Division tick marks (if enabled)
  /// 3. Active track (progress fill)
  ///
  /// **Why This Order:**
  /// - Base track provides the foundation
  /// - Divisions are drawn on top so they're visible
  /// - Active track is drawn last to cover divisions in the filled area
  ///
  /// **Coordinate Calculations:**
  /// - All elements use `size.midY` for vertical centering
  /// - Base track spans full width: (0, midY) to (width, midY)
  /// - Active track spans partial width: (0, midY) to (width × value, midY)
  ///
  /// **Value Mapping:**
  /// The normalized value (0.0-1.0) is multiplied by width to get
  /// the pixel position where the active track should end.
  @override
  void paint(Canvas canvas, Size size) {
    final initialOffset = Offset(0, size.midY);
    final endOffset = Offset(size.width, size.midY);

    // Draw the base track (full width background)
    drawTrack(canvas, initialOffset, endOffset, baseTrack);

    // Draw division tick marks if configured
    if (divisions != null) {
      drawDivisions(canvas, size);
    }

    // Draw the active track (progress fill from start to current value)
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

/// Convenience extension for finding the vertical center of a Size.
///
/// **Purpose:**
/// Provides a clean, readable way to get the Y coordinate for horizontally
/// centering elements within a given height. Used extensively in track
/// painting to ensure all elements align on the same horizontal line.
///
/// **Usage:**
/// `size.midY` instead of `size.height / 2`
extension on Size {
  /// Returns the Y coordinate at the vertical center of this size.
  ///
  /// Equivalent to `height / 2` but more semantically clear.
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
