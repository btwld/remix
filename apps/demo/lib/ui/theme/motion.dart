import 'package:flutter/animation.dart' show Cubic;
import 'package:flutter/physics.dart' show SpringDescription;

/// Fortal's motion constants: durations, eases, springs and stagger steps.
///
/// Motion does not vary with the accent, appearance, radius or scaling, and
/// Mix animation configuration takes concrete [Duration], [Cubic] and
/// [SpringDescription] values, so these are constants beside [FortalTokens]
/// rather than scope tokens. Interface motion stays under 300 ms and exits
/// are quicker than entries.
abstract final class FortalMotion {
  /// Hover and press feedback.
  static const instant = Duration(milliseconds: 100);

  /// Colour, border and opacity transitions.
  static const fast = Duration(milliseconds: 150);

  /// Things leaving the screen.
  static const exit = Duration(milliseconds: 140);

  /// Things arriving and moving.
  static const standard = Duration(milliseconds: 200);

  /// Large surfaces arriving.
  static const considered = Duration(milliseconds: 360);

  /// The duration [springCss] is sampled over.
  static const spring = Duration(milliseconds: 440);

  /// Things arriving.
  static const easeEnter = Cubic(0.16, 1, 0.3, 1);

  /// The default for colour, border and opacity transitions.
  static const easeStandard = Cubic(0.22, 1, 0.36, 1);

  /// Things leaving.
  static const easeExit = Cubic(0.7, 0, 0.84, 0);

  /// Elements that move while already on screen.
  static const easeInOut = Cubic(0.65, 0, 0.35, 1);

  /// A slightly underdamped spring for responsive feedback (ratio 0.965).
  static const springResponsive = SpringDescription(
    mass: 1,
    stiffness: 520,
    damping: 44,
  );

  /// A slightly underdamped spring for gentle settling (ratio 0.922).
  static const springGentle = SpringDescription(
    mass: 1,
    stiffness: 340,
    damping: 34,
  );

  /// Critically damped, settling in about 240 ms. Equal to
  /// `SpringDescription.withDurationAndBounce(duration: 240 ms)`.
  static const springSnappy = SpringDescription(
    mass: 1,
    stiffness: 685.4,
    damping: 52.36,
  );

  /// Critically damped, settling in about 360 ms. Equal to
  /// `SpringDescription.withDurationAndBounce(duration: 360 ms)`.
  static const springSmooth = SpringDescription(
    mass: 1,
    stiffness: 304.6,
    damping: 34.91,
  );

  /// Shape changes share the smooth spring.
  static const springMorph = springSmooth;

  /// The critically damped spring behind the transform ease: it reaches
  /// 99.7 percent of its travel at [spring].
  static const springCss = SpringDescription(
    mass: 1,
    stiffness: 330.6,
    damping: 36.36,
  );

  /// Stagger steps for text and list reveals; keep a whole sequence under
  /// about 400 ms.
  static const staggerChar = Duration(milliseconds: 16);
  static const staggerWord = Duration(milliseconds: 40);
  static const staggerLine = Duration(milliseconds: 80);
  static const staggerItem = Duration(milliseconds: 35);

  /// Blur sigmas for `ImageFilter.blur`, which takes a standard deviation as
  /// CSS `filter: blur()` does.
  static const blurSubtle = 2.0;
  static const blurSoft = 4.0;
  static const blurText = 8.0;
}
