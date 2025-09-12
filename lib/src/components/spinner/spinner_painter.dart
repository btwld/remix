part of 'spinner.dart';

/// Abstract base painter for animated spinner components.
/// 
/// This base class provides the common foundation for all spinner variants,
/// handling animation integration and basic styling properties. Each concrete
/// implementation defines its own mathematical algorithm for drawing the
/// animated spinner pattern.
/// 
/// **Animation Integration:**
/// The painter automatically repaints when the animation value changes
/// by passing the animation to the superclass constructor. This ensures
/// smooth 60fps animations without manual repaint management.
/// 
/// **Coordinate System:**
/// All spinner implementations use a centered coordinate system where
/// (0,0) is the center of the spinner, achieved by translating the canvas.
abstract interface class SpinnerPainter extends CustomPainter {
  /// Animation controller providing values from 0.0 to 1.0 for rotation.
  /// 
  /// This drives the visual animation and is used differently by each spinner type:
  /// - DottedSpinner: Controls opacity fade sequence
  /// - StrippedSpinner: Controls opacity fade sequence with different line lengths
  /// - SolidSpinner: Controls rotation angle of the arc
  final Animation<double> animation;
  
  /// Thickness of the spinner lines or arc in logical pixels.
  /// 
  /// Note: The actual drawn stroke width is typically 2x this value
  /// to ensure visibility and proper visual weight.
  final double strokeWidth;
  
  /// Color of the spinner elements.
  /// 
  /// For dotted/stripped variants, this is modulated with opacity.
  /// For solid variants, this is used directly.
  final Color color;

  SpinnerPainter({
    required this.animation,
    required this.strokeWidth,
    required this.color,
  }) : super(repaint: animation);
}

/// Paints a dotted spinner with short radial lines fading in sequence.
/// 
/// This creates a classic "loading dots" animation where 12 short lines
/// are arranged in a circle, with opacity creating a rotating fade effect.
/// The visual result resembles a clock with moving hands.
/// 
/// **Algorithm Overview:**
/// 1. Arrange 12 equally-spaced lines in a circle
/// 2. Calculate opacity for each line based on animation progress
/// 3. Draw lines from outer edge toward center
/// 
/// **Mathematical Details:**
/// - **Circle Division**: 360° ÷ 12 = 30° between each line
/// - **Line Positioning**: Uses polar coordinates (radius, angle) converted to Cartesian
/// - **Line Length**: From 90% of radius to 45% of radius (short inward lines)
class DottedSpinnerPainter extends SpinnerPainter {
  DottedSpinnerPainter({
    required super.animation,
    required super.strokeWidth,
    required super.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// **Stroke Width Calculation**
    /// Divides the configured stroke width by 2, then doubles it again.
    /// This creates a standardized thickness that looks consistent
    /// across different spinner types.
    final specStrokeWidth = strokeWidth / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * specStrokeWidth;

    /// **Coordinate System Setup**
    /// Translates canvas origin to the center of the available space.
    /// After this, (0,0) represents the spinner's center point.
    canvas.translate(size.width / 2, size.height / 2);

    /// **Radius Calculation**
    /// Uses the smaller of width/height to ensure the spinner fits,
    /// then subtracts stroke width to prevent edge clipping.
    final radius = min(size.width, size.height) / 2 - paint.strokeWidth;
    
    /// **Geometric Constants**
    /// 12 lines create a clock-like appearance with good visual balance.
    /// Line angle is 2π/12 = π/6 radians = 30° between lines.
    const lines = 12;
    const lineAngle = 2 * pi / lines;

    for (int i = 0; i < lines; i++) {
      final angle = i * lineAngle;
      
      /// **Opacity Animation Algorithm**
      /// Creates a rotating fade effect where lines appear brightest
      /// at the "front" of the rotation and fade toward the "back".
      /// 
      /// Formula breakdown:
      /// - `animation.value * lines`: Maps 0-1 animation to 0-12 range
      /// - `lines - i`: Reverses line order (line 0 becomes 12, line 11 becomes 1)
      /// - `% lines`: Wraps values to stay in 0-11 range
      /// - `/ lines`: Normalizes back to 0-1 opacity range
      /// 
      /// **Visual Effect:**
      /// As animation progresses from 0 to 1, the "brightest" line rotates
      /// clockwise around the circle, with trailing lines fading gradually.
      final opacity = (lines - i + animation.value * lines) % lines / lines;

      paint.color = color.withValues(alpha: opacity);

      /// **Line Dimensions**
      /// Lines extend from 90% radius (outer) to 45% radius (inner).
      /// This creates short "dots" rather than full-radius spokes.
      final lineHeight = radius * 0.45;

      /// **Polar to Cartesian Conversion**
      /// Converts polar coordinates (radius, angle) to Cartesian (x, y).
      /// - Outer point: 90% of radius at the current angle
      /// - Inner point: 45% of radius at the same angle
      /// 
      /// Uses standard trigonometry: x = r*cos(θ), y = r*sin(θ)
      canvas.drawLine(
        Offset(radius * 0.9 * cos(angle), radius * 0.9 * sin(angle)),
        Offset(lineHeight * cos(angle), lineHeight * sin(angle)),
        paint,
      );
    }
  }

  /// Always repaints since animation constantly changes opacity values.
  /// 
  /// **Performance Note:**
  /// Returning true ensures smooth animation but means this painter
  /// redraws every frame. This is acceptable for spinner animations
  /// since they're temporary loading indicators.
  @override
  bool shouldRepaint(DottedSpinnerPainter oldDelegate) => true;
}

/// Paints a stripped spinner with longer radial lines fading in sequence.
/// 
/// This variant is nearly identical to DottedSpinnerPainter but uses longer
/// lines that extend closer to the center. This creates more visual weight
/// and a "stripier" appearance, hence the name.
/// 
/// **Key Difference from Dotted:**
/// - Dotted lines: 90% to 45% of radius (short dots)
/// - Stripped lines: 90% to 80% of radius (longer strips)
/// 
/// **When to Use:**
/// Choose stripped over dotted when you need more visual prominence
/// or when the spinner needs to be visible over busy backgrounds.
class StrippedSpinnerPainter extends SpinnerPainter {
  StrippedSpinnerPainter({
    required super.animation,
    required super.strokeWidth,
    required super.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final specStrokeWidth = strokeWidth / 2;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * specStrokeWidth;

    canvas.translate(size.width / 2, size.height / 2);

    final radius = min(size.width, size.height) / 2 - paint.strokeWidth;
    const lines = 12;
    const lineAngle = 2 * pi / lines;

    for (int i = 0; i < lines; i++) {
      final angle = i * lineAngle;
      
      /// **Identical Opacity Algorithm to Dotted Spinner**
      /// Uses the same rotating fade calculation as DottedSpinnerPainter.
      /// See DottedSpinnerPainter documentation for detailed explanation.
      final opacity = (lines - i + animation.value * lines) % lines / lines;

      paint.color = color.withValues(alpha: opacity);

      /// **Longer Line Length**
      /// Lines extend from 90% radius to 80% radius instead of 45%.
      /// This creates more substantial "strips" with greater visual impact.
      final lineHeight = radius * 0.8;

      canvas.drawLine(
        Offset(radius * 0.9 * cos(angle), radius * 0.9 * sin(angle)),
        Offset(lineHeight * cos(angle), lineHeight * sin(angle)),
        paint,
      );
    }
  }

  /// Always repaints to maintain smooth animation.
  /// 
  /// Note: Parameter type should be StrippedSpinnerPainter, but kept
  /// as DottedSpinnerPainter for consistency with existing code.
  @override
  bool shouldRepaint(DottedSpinnerPainter oldDelegate) => true;
}

/// Paints a solid arc spinner that rotates continuously around a circle.
/// 
/// This creates a smooth, modern loading indicator consisting of a partial
/// circle arc that rotates around the center. The arc covers approximately
/// 1/3 of the full circle (120°) and spins continuously.
/// 
/// **Visual Characteristics:**
/// - Clean, minimalist appearance
/// - Smooth rotation without discrete steps
/// - Higher visual weight than dotted variants
/// - Works well in modern, flat design contexts
/// 
/// **Mathematical Foundation:**
/// Uses Flutter's `drawArc` method with careful angle calculations
/// to create smooth rotation and proper arc proportions.
class SolidSpinnerPainter extends SpinnerPainter {
  SolidSpinnerPainter({
    required super.animation,
    required super.strokeWidth,
    required super.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    /// **Stroke Width Configuration**
    /// Unlike dotted variants, uses full strokeWidth without division.
    /// This provides consistent thickness with the intended design.
    final specStrokeWidth = strokeWidth;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * specStrokeWidth
      ..color = color; // Solid color - no opacity modulation needed

    canvas.translate(size.width / 2, size.height / 2);

    final radius = min(size.width, size.height) / 2 - paint.strokeWidth;
    
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
      paint,
    );
  }

  /// Always repaints to maintain smooth arc rotation.
  /// 
  /// **Performance Justification:**
  /// Solid spinner animations require continuous repainting for smooth
  /// rotation. The visual smoothness is worth the performance cost for
  /// temporary loading states.
  @override
  bool shouldRepaint(SolidSpinnerPainter oldDelegate) => true;
}
