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
            final thumbSize = _resolveThumbSize(context, spec.thumb);
            final trackThickness = spec.trackThickness > 0
                ? spec.trackThickness
                : RemixSliderSpec.defaultTrackStrokeWidth;

            // Slider height accommodates both thumb and track:
            // - thumb.height + trackThickness: ensures thumb has clearance above/below
            // - trackThickness alone: minimum viable height
            final sliderHeight =
                math.max(thumbSize.height + trackThickness, trackThickness);
            final horizontalOverflow = math.max(
              thumbSize.width / 2,
              trackThickness / 2,
            );
            final horizontalPadding = horizontalOverflow * 2;

            return SizedBox(
              height: sliderHeight,
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
                  final valueRange =
                      (max - min).abs() < 1e-6 ? 1.0 : (max - min);
                  final normalizedValue =
                      ((value - min) / valueRange).clamp(0.0, 1.0);

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
                  /// - Horizontal padding: derived from thumb size/track thickness
                  /// - Available space: width - horizontal padding
                  /// - At 50% value: thumb positioned at availableSpace / 2
                  final availableWidth = math.max(
                    0.0,
                    constraints.maxWidth - horizontalPadding,
                  );
                  final thumbPosition = availableWidth * normalizedValue;

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
                            range: spec.range,
                            track: spec.track,
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

Size _resolveThumbSize(BuildContext context, StyleSpec<BoxSpec> thumb) {
  final box = thumb.spec;
  final constraints = box.constraints;

  final width = _resolveTightDimension(
    tight: constraints?.hasTightWidth ?? false,
    min: constraints?.minWidth,
    max: constraints?.maxWidth,
    fallback: RemixSliderSpec.defaultThumbSize.width,
  );

  final height = _resolveTightDimension(
    tight: constraints?.hasTightHeight ?? false,
    min: constraints?.minHeight,
    max: constraints?.maxHeight,
    fallback: RemixSliderSpec.defaultThumbSize.height,
  );

  final padding = box.padding?.resolve(Directionality.of(context));

  return Size(
    width + (padding?.horizontal ?? 0),
    height + (padding?.vertical ?? 0),
  );
}

double _resolveTightDimension({
  required bool tight,
  double? min,
  double? max,
  required double fallback,
}) {
  if (tight && max != null && max.isFinite) {
    return max;
  }

  final finiteMax = (max != null && max.isFinite && max > 0) ? max : null;
  if (finiteMax != null) return finiteMax;

  final finiteMin = (min != null && min.isFinite && min > 0) ? min : null;
  if (finiteMin != null) return finiteMin;

  return fallback;
}

/// Custom painter for drawing slider track (no divisions).
///
/// This painter renders two visual elements:
/// 1. **Track**: The full-width background rail
/// 2. **Range**: The filled portion showing current progress
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

  /// Paint configuration for the range (filled) portion.
  final Paint range;

  /// Paint configuration for the track (unfilled) background.
  final Paint track;

  // Divisions removed.

  const _TrackPainter({
    required this.value,
    required this.range,
    required this.track,
  });

  // Ticks removed: no division rendering

  /// Draws a horizontal line segment representing part of the slider track.
  ///
  /// **Purpose:**
  /// This helper method is used to draw both the track (full width)
  /// and the range (partial width based on current value).
  ///
  /// **Parameters:**
  /// - `initialOffset`: Starting point of the line segment
  /// - `endOffset`: Ending point of the line segment
  /// - `paint`: Visual styling for the line (color, thickness, etc.)
  ///
  /// **Usage:**
  /// Called twice in paint(): once for track, once for range.
  void drawLine(
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
  /// 1. Track (full-width background)
  /// 2. Range (progress fill)
  ///
  /// **Why This Order:**
  /// - Track provides the foundation
  /// - Range is drawn last over it
  ///
  /// **Coordinate Calculations:**
  /// - All elements use `size.midY` for vertical centering
  /// - Track spans full width: (0, midY) to (width, midY)
  /// - Range spans partial width: (0, midY) to (width × value, midY)
  ///
  /// **Value Mapping:**
  /// The normalized value (0.0-1.0) is multiplied by width to get
  /// the pixel position where the range should end.
  @override
  void paint(Canvas canvas, Size size) {
    final initialOffset = Offset(0, size.midY);
    final endOffset = Offset(size.width, size.midY);

    // Draw the track (full width background)
    drawLine(canvas, initialOffset, endOffset, track);

    // Ticks removed: do not draw divisions

    // Draw the range (progress fill from start to current value)
    drawLine(
      canvas,
      initialOffset,
      Offset(size.width * value, size.midY),
      range,
    );
  }

  @override
  bool shouldRepaint(_TrackPainter oldDelegate) {
    return value != oldDelegate.value ||
        range != oldDelegate.range ||
        track != oldDelegate.track;
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
    required this.range,
    required this.track,
    required this.duration,
    required this.curve,
  });

  final double value;
  final Paint range;
  final Paint track;
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
    _oldTracks = _Tracks(range: widget.range, track: widget.track);
  }

  @override
  void didUpdateWidget(covariant _AnimatedTrack oldWidget) {
    super.didUpdateWidget(oldWidget);
    _oldTracks = _Tracks(
      range: oldWidget.range,
      track: oldWidget.track,
    );
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: _TracksTween(
        begin: _oldTracks,
        end: _Tracks(range: widget.range, track: widget.track),
      ),
      duration: widget.duration,
      curve: widget.curve,
      builder: (context, value, child) {
        return CustomPaint(
          painter: _TrackPainter(
            value: widget.value,
            range: value.range,
            track: value.track,
          ),
        );
      },
    );
  }
}

// Helper class for animating track properties
class _Tracks {
  final Paint range;
  final Paint track;

  const _Tracks({required this.range, required this.track});

  @override
  bool operator ==(Object other) {
    return other is _Tracks &&
        range == other.range &&
        track == other.track;
  }

  @override
  int get hashCode => range.hashCode ^ track.hashCode;
}

// Tween for animating between track states
class _TracksTween extends Tween<_Tracks> {
  _TracksTween({required super.begin, required super.end});

  @override
  _Tracks lerp(double t) {
    return _Tracks(
      range: lerpPaint(begin!.range, end!.range, t),
      track: lerpPaint(begin!.track, end!.track, t),
    );
  }
}
