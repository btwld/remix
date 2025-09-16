// ABOUTME: Factory constructors for RemixSpinnerStyle variants using Radix design tokens
// ABOUTME: Provides RadixSpinnerStyle subclass with size aware composition

import '../../radix/radix.dart';
import 'spinner.dart';

enum RadixSpinnerSize {
  size1,
  size2,
  size3,
}

/// RadixSpinnerStyle utility class for creating Radix-themed spinner styles.
///
/// Provides factory constructor with size parameters plus named
/// static methods for direct access. Composes the correct base metrics
/// and size-specific styles sourced from the Radix token JSON.
class RadixSpinnerStyle {
  const RadixSpinnerStyle._();

  /// Factory constructor for RadixSpinnerStyle with size parameters.
  ///
  /// Returns a RemixSpinnerStyle configured with Radix design tokens.
  /// Defaults to size2. Spinners have no variants, only defaultStyle().
  static RemixSpinnerStyle create({
    RadixSpinnerSize size = RadixSpinnerSize.size2,
  }) {
    return defaultStyle(size: size);
  }

  static RemixSpinnerStyle base({
    RadixSpinnerSize size = RadixSpinnerSize.size2,
  }) {
    return RemixSpinnerStyle(
        // Default properties (no focus state for spinners)
        color: RadixTokens.accent9(), // Uses accent step 9 as per spec
        duration: const Duration(milliseconds: 800), // per component token
        type: SpinnerType.solid,
      )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  static RemixSpinnerStyle defaultStyle({
    RadixSpinnerSize size = RadixSpinnerSize.size2,
  }) {
    return base(size: size);
  }


  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixSpinnerStyle _sizeStyle(RadixSpinnerSize size) {
    return switch (size) {
      RadixSpinnerSize.size1 => RemixSpinnerStyle(
          size: 16.0,
          strokeWidth: 1.5,
        ),
      RadixSpinnerSize.size2 => RemixSpinnerStyle(
          size: 20.0,
          strokeWidth: 2.0,
        ),
      RadixSpinnerSize.size3 => RemixSpinnerStyle(
          size: 24.0,
          strokeWidth: 2.5,
        ),
    };
  }
}

