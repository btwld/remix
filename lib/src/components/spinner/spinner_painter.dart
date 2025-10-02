part of 'spinner.dart';

/// Paints a solid arc spinner that rotates continuously around a circle
/// with an optional track (background circle).
///
/// This creates a smooth, modern loading indicator consisting of a partial
/// circle arc that rotates around the center. The arc covers approximately
/// 1/3 of the full circle (120°) and spins continuously.
///
/// **Visual Characteristics:**
/// - Clean, minimalist appearance
/// - Smooth rotation without discrete steps
/// - Optional track for better visibility
/// - Works well in modern, flat design contexts
///
/// **Mathematical Foundation:**
/// Uses Flutter's `drawArc` method with careful angle calculations
/// to create smooth rotation and proper arc proportions.
class RemixSpinnerPainter extends CustomPainter {
  /// Animation controller providing values from 0.0 to 1.0 for rotation.
  final Animation<double> animation;

  /// Thickness of the indicator arc in logical pixels.
  final double strokeWidth;

  /// Color of the rotating indicator arc.
  final Color indicatorColor;

  /// Color of the background track circle.
  /// If null, no track is drawn.
  final Color? trackColor;

  /// Thickness of the track circle in logical pixels.
  /// If null, uses the same width as the indicator.
  final double? trackStrokeWidth;

  RemixSpinnerPainter({
    required this.animation,
    required this.strokeWidth,
    required this.indicatorColor,
    this.trackColor,
    this.trackStrokeWidth,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.translate(size.width / 2, size.height / 2);

    final indicatorThickness = strokeWidth * 2;
    final trackThickness =
        trackColor != null ? 2 * (trackStrokeWidth ?? strokeWidth) : 0;
    final maxThickness = max(indicatorThickness, trackThickness);

    final radius = min(size.width, size.height) / 2 - maxThickness;

    // Draw track (background circle) if trackColor is provided
    if (trackColor != null) {
      final trackPaint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * (trackStrokeWidth ?? strokeWidth)
        ..color = trackColor!;

      canvas.drawCircle(Offset.zero, radius, trackPaint);
    }

    // Draw indicator arc
    final indicatorPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * strokeWidth
      ..color = indicatorColor;

    /// **Arc Geometry Constants**
    ///
    /// **Start Angle: π/3 radians (60°)**
    /// Positions the arc to start at the 2 o'clock position.
    /// This creates a visually pleasing starting point that works well
    /// with the sweep angle.
    ///
    /// **Sweep Angle: 2π/3 radians (120°)**
    /// Creates an arc that covers exactly 1/3 of the circle.
    /// This proportion provides good visual balance - substantial enough
    /// to be clearly visible, but not so large as to dominate the space.
    const startAngle = pi / 3;
    const sweepAngle = 2 * pi / 3;

    /// **Arc Rotation Calculation**
    ///
    /// The arc is drawn with a starting angle that rotates based on animation:
    /// `startAngle + animation.value * 2 * pi`
    ///
    /// **Animation Mapping:**
    /// - animation.value: 0.0 to 1.0 (provided by AnimationController)
    /// - 2 * π: Full circle in radians
    /// - Result: Arc rotates 360° as animation progresses from 0 to 1
    ///
    /// **Why This Works:**
    /// As animation cycles from 0 to 1, the start angle advances by 2π,
    /// making the arc appear to rotate smoothly around the center.
    canvas.drawArc(
      Rect.fromCircle(center: Offset.zero, radius: radius),
      startAngle + animation.value * 2 * pi,
      sweepAngle,
      false, // useCenter: false - draws arc stroke, not a pie slice
      indicatorPaint,
    );
  }

  /// Always repaints to maintain smooth arc rotation.
  ///
  /// **Performance Justification:**
  /// Spinner animations require continuous repainting for smooth
  /// rotation. The visual smoothness is worth the performance cost for
  /// temporary loading states.
  @override
  bool shouldRepaint(RemixSpinnerPainter oldDelegate) => true;
}
