// ABOUTME: Factory for creating RemixSpinnerStyle instances using Radix design tokens
// ABOUTME: Provides default Radix spinner style with proper token-based styling

import '../../theme/radix_tokens.dart';
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
  static RemixSpinnerStyle defaultStyle({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixSpinnerStyle(
      size: sizeConfig.size,
      strokeWidth: sizeConfig.strokeWidth,
      color: RadixTokens.accent9(), // Uses accent step 9 as per spec
      duration: RadixTokens.transitionSlow(), // 300ms animation
      type: SpinnerType.solid,
    );
  }

  /// Gets size configuration for the given size index.
  static _SpinnerSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _SpinnerSizeConfig(size: 16.0, strokeWidth: 1.0);
      case 2:
        return _SpinnerSizeConfig(size: 24.0, strokeWidth: 1.5);
      case 3:
        return _SpinnerSizeConfig(size: 32.0, strokeWidth: 2.0);
      default:
        // Default to size 2 if invalid size provided
        return _SpinnerSizeConfig(size: 24.0, strokeWidth: 1.5);
    }
  }
}

/// Internal configuration for spinner sizes.
class _SpinnerSizeConfig {
  final double size;
  final double strokeWidth;

  const _SpinnerSizeConfig({required this.size, required this.strokeWidth});
}
