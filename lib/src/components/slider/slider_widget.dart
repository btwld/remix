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
class RemixSlider extends StatelessWidget {
  const RemixSlider({
    super.key,
    this.min = 0.0,
    this.max = 1.0,
    required this.onChanged,
    required this.value,
    this.onChangeEnd,
    this.onChangeStart,
    this.style = const RemixSliderStyle.create(),
    this.styleSpec,
    this.enabled = true,
    this.enableHapticFeedback = true,
    this.focusNode,
    this.autofocus = false,
    this.snapDivisions,
  }) : assert(
          value >= min && value <= max,
          'Slider value must be between min and max values',
        );

  /// The minimum value the slider can have.
  final double min;

  /// The maximum value the slider can have.
  final double max;

  /// Optional snapping divisions for interaction only (no visual ticks).
  /// When provided, the slider snaps to these discrete steps but does not
  /// render any division marks on the track.
  final int? snapDivisions;

  /// Whether the slider should automatically request focus when it is created.
  final bool autofocus;

  /// The current value of the slider.
  /// Must be between [min] and [max].
  final double value;

  /// The style configuration for the slider.
  final RemixSliderStyle style;

  /// The style spec for the slider.
  final RemixSliderSpec? styleSpec;

  static late final styleFrom = RemixSliderStyle.new;

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
  Widget build(BuildContext context) {
    // NakedSlider handles semantics internally, no outer Semantics needed
    return NakedSlider(
      value: value,
      min: min,
      max: max,
      onChanged: onChanged,
      onDragStart: () => onChangeStart?.call(value),
      onDragEnd: onChangeEnd,
      enabled: enabled,
      enableFeedback: enableHapticFeedback,
      focusNode: focusNode,
      autofocus: autofocus,
      direction: Axis.horizontal,
      divisions: snapDivisions,
      builder: (context, state, _) {
        return StyleBuilder(
          style: style,
          controller: NakedState.controllerOf(context),
          builder: (context, spec) {
            // Use a fixed thumb size for simplicity
            final height = 24.0;
            final horizontalPadding = height;

            return SizedBox(
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
                  final normalizedValue = (value - min) / (max - min);

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
                      (constraints.maxWidth - horizontalPadding) *
                          normalizedValue;

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
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.linear,
                          ),
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(thumbPosition, 0),
                        child: Box(styleSpec: spec.thumb),
                      ),
                    ],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

/// Custom painter for drawing slider track (no divisions).
///
/// This painter renders two visual elements:
/// 1. **Base track**: The full-width background rail
/// 2. **Active track**: The filled portion showing current progress
///
/// **Coordinate System:**
/// Uses standard Canvas coordinates where (0,0) is top-left.
/// Track is drawn horizontally across the full width at vertical center.
///
/// **Performance Considerations:**
/// Repaints only when value or colors change.
class _TrackPainter extends CustomPainter {
  /// Normalized value between 0.0 and 1.0 representing current position.
  final double value;

  /// Paint configuration for the active (filled) portion of the track.
  final Paint active;

  /// Paint configuration for the base (unfilled) track background.
  final Paint baseTrack;

  // Divisions removed.

  const _TrackPainter({
    required this.value,
    required this.active,
    required this.baseTrack,
  });

  // Ticks removed: no division rendering

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
  /// 2. Active track (progress fill)
  ///
  /// **Why This Order:**
  /// - Base track provides the foundation
  /// - Active track is drawn last over it
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

    // Ticks removed: do not draw divisions

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
        baseTrack != oldDelegate.baseTrack;
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
    required this.duration,
    required this.curve,
  });

  final double value;
  final Paint active;
  final Paint baseTrack;
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
    _oldTracks = _Tracks(active: widget.active, baseTrack: widget.baseTrack);
  }

  @override
  void didUpdateWidget(covariant _AnimatedTrack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldTracks = _Tracks(
      active: oldWidget.active,
      baseTrack: oldWidget.baseTrack,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: _TracksTween(
        begin: _oldTracks,
        end: _Tracks(active: widget.active, baseTrack: widget.baseTrack),
      ),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        return CustomPaint(
          painter: _TrackPainter(
            value: widget.value,
            active: value.active,
            baseTrack: value.baseTrack,
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

  const _Tracks({required this.active, required this.baseTrack});

  @override
  bool operator ==(Object other) {
    return other is _Tracks &&
        active == other.active &&
        baseTrack == other.baseTrack;
  }

  @override
  int get hashCode => active.hashCode ^ baseTrack.hashCode;
}

// Tween for animating between track states
class _TracksTween extends Tween<_Tracks> {
  _TracksTween({required super.begin, required super.end});

  @override
  _Tracks lerp(double t) {
    return _Tracks(
      active: lerpPaint(begin!.active, end!.active, t),
      baseTrack: lerpPaint(begin!.baseTrack, end!.baseTrack, t),
    );
  }
}
