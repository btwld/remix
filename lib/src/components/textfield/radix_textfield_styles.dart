// ABOUTME: Factory for creating RemixTextFieldStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix textfield variants with proper token-based styling

import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'textfield.dart';

// Export the extension so it's available when importing this file
export 'textfield.dart' show RadixTextFieldStyleExt;

/// Factory class for creating Radix-compliant textfield styles.
///
/// Provides static methods to create RemixTextFieldStyle instances for all
/// Radix UI textfield variants using the RadixTokens system.
class RadixTextFieldStyles {
  const RadixTextFieldStyles._();

  /// Creates a classic variant textfield style.
  ///
  /// Classic textfields use neutral surface with gray borders that become
  /// accent-colored on focus. Used for standard form controls.
  /// Compose with size methods like .size2().
  static RemixTextFieldStyle classic() {
    return RemixTextFieldStyle(
      // Background and container styling - no size properties
      text: TextStyler()
          .color(RadixTokens.gray12())
          .fontWeight(RadixTokens.fontWeightRegular()),
      hintText: TextStyler()
          .color(RadixTokens.gray10())
          .fontWeight(RadixTokens.fontWeightRegular()),
      cursorWidth: 1.5,
      cursorColor: RadixTokens.gray12(),
      helperText: TextStyler()
          .color(RadixTokens.gray11())
          .fontWeight(RadixTokens.fontWeightRegular()),
      label: TextStyler()
          .color(RadixTokens.gray12())
          .fontWeight(RadixTokens.fontWeightMedium()),
    )
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray7(),
          width: RadixTokens.borderWidth1(),
        )
        // State variants
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: RadixTokens.accent8(),
            width: RadixTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixTextFieldStyle(
            text: TextStyler().color(RadixTokens.gray10()),
            hintText: TextStyler().color(RadixTokens.gray8()),
          ).color(RadixTokens.colorSurface()).borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              ),
        );
  }

  /// Creates a surface variant textfield style.
  ///
  /// Surface textfields use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance. Compose with size methods like .size2().
  static RemixTextFieldStyle surface() {
    return RemixTextFieldStyle(
      text: TextStyler()
          .color(RadixTokens.gray12())
          .fontWeight(RadixTokens.fontWeightRegular()),
      hintText: TextStyler()
          .color(RadixTokens.gray10())
          .fontWeight(RadixTokens.fontWeightRegular()),
      cursorWidth: 1.5,
      cursorColor: RadixTokens.gray12(),
      helperText: TextStyler()
          .color(RadixTokens.gray11())
          .fontWeight(RadixTokens.fontWeightRegular()),
      label: TextStyler()
          .color(RadixTokens.gray12())
          .fontWeight(RadixTokens.fontWeightMedium()),
    )
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray6(),
          width: RadixTokens.borderWidth1(),
        )
        // State variants
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: RadixTokens.accent7(),
            width: RadixTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixTextFieldStyle(
            text: TextStyler().color(RadixTokens.gray10()),
            hintText: TextStyler().color(RadixTokens.gray8()),
          ).color(RadixTokens.colorSurface()).borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              ),
        );
  }

  /// Creates a soft variant textfield style.
  ///
  /// Soft textfields use accent-tinted background with accent borders.
  /// Used for forms that need accent color integration. Compose with size methods like .size2().
  static RemixTextFieldStyle soft() {
    return RemixTextFieldStyle(
      text: TextStyler()
          .color(RadixTokens.accent12())
          .fontWeight(RadixTokens.fontWeightRegular()),
      hintText: TextStyler()
          .color(RadixTokens.accent10())
          .fontWeight(RadixTokens.fontWeightRegular()),
      cursorWidth: 1.5,
      cursorColor: RadixTokens.accent12(),
      helperText: TextStyler()
          .color(RadixTokens.gray11())
          .fontWeight(RadixTokens.fontWeightRegular()),
      label: TextStyler()
          .color(RadixTokens.gray12())
          .fontWeight(RadixTokens.fontWeightMedium()),
    )
        .color(RadixTokens.accent3())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        // State variants
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: RadixTokens.accent8(),
            width: RadixTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixTextFieldStyle(
            text: TextStyler().color(RadixTokens.accent11()),
            hintText: TextStyler().color(RadixTokens.accent9()),
          ).color(RadixTokens.accent3()).borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              ),
        );
  }

  /// Creates a size 1 textfield style (small).
  ///
  /// Small textfields for compact layouts and dense interfaces.
  static RemixTextFieldStyle size1() {
    return RemixTextFieldStyle(
      text: TextStyler().fontSize(12.0),
      hintText: TextStyler().fontSize(12.0),
      helperText: TextStyler().fontSize(11.0),
      label: TextStyler().fontSize(11.0),
    ).borderRadiusAll(RadixTokens.radius2()).paddingAll(8.0).height(32.0);
  }

  /// Creates a size 2 textfield style (medium - default).
  ///
  /// Standard textfields for most common use cases.
  static RemixTextFieldStyle size2() {
    return RemixTextFieldStyle(
      text: TextStyler().fontSize(14.0),
      hintText: TextStyler().fontSize(14.0),
      helperText: TextStyler().fontSize(12.0),
      label: TextStyler().fontSize(13.0),
    ).borderRadiusAll(RadixTokens.radius3()).paddingAll(12.0).height(40.0);
  }

  /// Creates a size 3 textfield style (large).
  ///
  /// Large textfields for prominent forms and accessibility needs.
  static RemixTextFieldStyle size3() {
    return RemixTextFieldStyle(
      text: TextStyler().fontSize(16.0),
      hintText: TextStyler().fontSize(16.0),
      helperText: TextStyler().fontSize(14.0),
      label: TextStyler().fontSize(15.0),
    ).borderRadiusAll(RadixTokens.radius4()).paddingAll(16.0).height(48.0);
  }
}

/// Extension providing Radix textfield size methods for fluent API.
///
/// Enables the pattern: `RadixTextFieldStyles.classic().size2()`
/// instead of: `RadixTextFieldStyles.size2().merge(RadixTextFieldStyles.classic())`
extension RadixTextFieldStyleExt on RemixTextFieldStyle {
  /// Creates a size 1 textfield style (small).
  ///
  /// Small textfields for compact layouts and dense interfaces.
  RemixTextFieldStyle size1() {
    return merge(RadixTextFieldStyles.size1());
  }

  /// Creates a size 2 textfield style (medium - default).
  ///
  /// Standard textfields for most common use cases.
  RemixTextFieldStyle size2() {
    return merge(RadixTextFieldStyles.size2());
  }

  /// Creates a size 3 textfield style (large).
  ///
  /// Large textfields for prominent forms and accessibility needs.
  RemixTextFieldStyle size3() {
    return merge(RadixTextFieldStyles.size3());
  }
}
