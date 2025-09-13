// ABOUTME: Factory for creating RemixSpinnerStyle instances using Radix design tokens
// ABOUTME: Provides default Radix spinner style with proper token-based styling

// Export for convenience access to Radix spinner style extensions

import '../../radix/radix.dart';
import 'spinner.dart';

/// Factory class for creating Radix-compliant spinner styles.
///
/// Provides static methods to create RemixSpinnerStyle instances using
/// the RadixTokens system. Spinners only have a default variant.
class RadixSpinnerStyles {
  const RadixSpinnerStyles._();

  /// Creates the default spinner style.
  ///
  /// Uses accent color for the stroke. According to the Radix spec,
  /// spinners only have a single default variant.
  static RemixSpinnerStyle defaultStyle() {
    return RemixSpinnerStyle(
      color: RadixTokens.accent9(), // Uses accent step 9 as per spec
      duration: const Duration(milliseconds: 800), // per component token
      type: SpinnerType.solid,
    );
  }

  /// Small spinner size (16px with 1.5px stroke).
  static RemixSpinnerStyle size1() {
    return RemixSpinnerStyle(
      size: 16.0,
      strokeWidth: 1.5,
      color: RadixTokens.accent9(),
      duration: const Duration(milliseconds: 800),
      type: SpinnerType.solid,
    );
  }

  /// Medium spinner size (20px with 2.0px stroke).
  static RemixSpinnerStyle size2() {
    return RemixSpinnerStyle(
      size: 20.0,
      strokeWidth: 2.0,
      color: RadixTokens.accent9(),
      duration: const Duration(milliseconds: 800),
      type: SpinnerType.solid,
    );
  }

  /// Large spinner size (24px with 2.5px stroke).
  static RemixSpinnerStyle size3() {
    return RemixSpinnerStyle(
      size: 24.0,
      strokeWidth: 2.5,
      color: RadixTokens.accent9(),
      duration: const Duration(milliseconds: 800),
      type: SpinnerType.solid,
    );
  }
}

/// Extension for RadixSpinnerStyles providing convenient access to size methods.
extension RadixSpinnerStyleExt on RadixSpinnerStyles {
  /// Small spinner size (16px with 1.5px stroke).
  RemixSpinnerStyle get size1 => RadixSpinnerStyles.size1();

  /// Medium spinner size (20px with 2.0px stroke).
  RemixSpinnerStyle get size2 => RadixSpinnerStyles.size2();

  /// Large spinner size (24px with 2.5px stroke).
  RemixSpinnerStyle get size3 => RadixSpinnerStyles.size3();
}
