library radix_colors; // moved to radix/colors/

import 'package:flutter/painting.dart';

part 'colors_generated.dart';

// Radix color families
//
// Accent colors:
// - amber, blue, bronze, brown, crimson, cyan, gold, grass, gray,
//   green, indigo, iris, jade, lime, mauve, mint, olive, orange,
//   pink, plum, purple, red, ruby, sand, sage, sky, slate, teal,
//   tomato, violet, yellow
//
// Gray colors (neutral families):
// - gray:  Pure gray
// - mauve: Purple-tinted gray
// - slate: Blue-tinted gray
// - sage:  Green-tinted gray
// - olive: Yellow-green tinted gray
// - sand:  Yellow-tinted gray

class RadixColor {
  final RadixColorScale scale;
  final Color surface;
  final Color indicator;
  final Color track;
  final Color contrast;

  const RadixColor(
    this.scale,
    this.surface,
    this.indicator,
    this.track,
    this.contrast,
  );
}

class RadixColorTheme {
  final RadixColor light;
  final RadixColor dark;

  const RadixColorTheme(this.light, this.dark);
}

class RadixColorScale {
  final ColorSwatch<int> solid;
  final ColorSwatch<int> alpha;

  const RadixColorScale(this.solid, this.alpha);

  // ============================================================================
  // SEMANTIC COLOR ACCESSORS
  // ============================================================================
  //
  // These getters provide semantic access to color steps based on their
  // intended usage in the Radix design system. Use these instead of direct
  // step numbers when possible for better code readability and maintenance.
  //

  // Steps 1-2: App and layout backgrounds
  /// The most subtle background color (step 1).
  ///
  /// Use for main app backgrounds and large layout areas.
  /// Provides subtle color presence without interfering with content.
  Color get appBackground => step(1);

  /// Subtle background with slightly more presence (step 2).
  ///
  /// Good for cards, panels, and content areas that need slight
  /// visual separation from the main background.
  Color get subtleBackground => step(2);

  // Steps 3-5: Interactive component backgrounds
  /// Default background for interactive components (step 3).
  ///
  /// Use for buttons, form inputs, and other interactive elements
  /// in their resting state.
  Color get componentBackground => step(3);

  /// Background color for components on hover (step 4).
  ///
  /// Provides clear feedback when users hover over interactive elements.
  Color get componentBackgroundHover => step(4);

  /// Background color for active/pressed components (step 5).
  ///
  /// Used when components are pressed, selected, or in an active state.
  Color get componentBackgroundActive => step(5);

  // Steps 6-8: Borders and separators
  /// Subtle border color for gentle separation (step 6).
  ///
  /// Use for dividers and borders that should be present but not prominent.
  Color get subtleBorder => step(6);

  /// Standard border color for components (step 7).
  ///
  /// Default border for form inputs, cards, and interactive elements.
  Color get componentBorder => step(7);

  /// Border color for hover and focus states (step 8).
  ///
  /// Provides visual feedback for interactive borders and focus rings.
  Color get componentBorderHover => step(8);

  // Steps 9-10: Solid accent backgrounds
  /// Primary solid background color (step 9).
  ///
  /// The main brand/accent color for buttons, badges, and prominent elements.
  /// This is typically what users recognize as "the brand color".
  Color get solidBackground => step(9);

  /// Solid background color on hover (step 10).
  ///
  /// Darker/lighter variant of step 9 for hover states on solid elements.
  Color get solidBackgroundHover => step(10);

  // Steps 11-12: Text and content colors
  /// Low contrast text color (step 11).
  ///
  /// For secondary text, descriptions, and content that should be
  /// readable but not prominent. Still meets accessibility standards.
  Color get lowContrastText => step(11);

  /// High contrast text color (step 12).
  ///
  /// For primary text, headings, and content requiring maximum readability.
  /// Provides the highest contrast while maintaining color harmony.
  Color get highContrastText => step(12);

  // ============================================================================
  // DIRECT STEP ACCESS
  // ============================================================================

  /// Gets a solid color from the 12-step scale.
  ///
  /// Steps must be between 1 and 12. Each step has semantic meaning
  /// in the Radix color system - prefer using the semantic getters
  /// (like [componentBackground]) when possible for better code clarity.
  ///
  /// Falls back to step 9 (solid background) if the requested step
  /// is not available in the color swatch.
  Color step(int n) {
    assert(n >= 1 && n <= 12, 'Step must be between 1 and 12');

    return solid[n] ?? solid[9]!;
  }

  /// Gets a translucent color from the 12-step alpha scale.
  ///
  /// Alpha variants maintain the original color's saturation when composited,
  /// unlike simple opacity adjustments. This creates more vibrant and
  /// visually consistent translucent effects.
  ///
  /// Steps correspond to the same semantic meanings as solid colors.
  /// Falls back to alpha step 9 if the requested step is not available.
  Color alphaStep(int n) {
    assert(n >= 1 && n <= 12, 'Step must be between 1 and 12');

    return alpha[n] ?? alpha[9]!;
  }
}
