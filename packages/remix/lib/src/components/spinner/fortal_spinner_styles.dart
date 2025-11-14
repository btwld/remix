part of 'spinner.dart';

enum FortalSpinnerSize {
  size1,
  size2,
  size3,
}

/// FortalSpinnerStyles utility class for creating Fortal-themed spinner styles.
///
/// Provides factory constructor with size parameters plus named
/// static methods for direct access. Composes the correct base metrics
/// and size-specific styles sourced from the Fortal token JSON.
class FortalSpinnerStyles {
  const FortalSpinnerStyles._();

  /// Factory constructor for FortalSpinnerStyles with size parameters.
  ///
  /// Returns a RemixSpinnerStyle configured with Fortal design tokens.
  /// Defaults to size2. Spinners have no variants, only defaultStyle().
  static RemixSpinnerStyle create({
    FortalSpinnerSize size = FortalSpinnerSize.size2,
  }) {
    return defaultStyle(size: size);
  }

  static RemixSpinnerStyle base({
    FortalSpinnerSize size = FortalSpinnerSize.size2,
  }) {
    return RemixSpinnerStyle(
      // Default properties (no focus state for spinners)
      indicatorColor: FortalTokens.accent9(), // Uses accent step 9 as per spec
      duration: RemixAnimationDurations.slow, // per component token
    )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixSpinnerStyle defaultStyle({
    FortalSpinnerSize size = FortalSpinnerSize.size2,
  }) {
    return base(size: size);
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixSpinnerStyle _sizeStyle(FortalSpinnerSize size) {
    return switch (size) {
      FortalSpinnerSize.size1 => RemixSpinnerStyle(
          size: 16.0,
          strokeWidth: 1.5,
        ),
      FortalSpinnerSize.size2 => RemixSpinnerStyle(
          size: 20.0,
          strokeWidth: 2.0,
        ),
      FortalSpinnerSize.size3 => RemixSpinnerStyle(
          size: 24.0,
          strokeWidth: 2.5,
        ),
    };
  }
}
