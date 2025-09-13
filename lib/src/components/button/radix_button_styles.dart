// ABOUTME: Factory for creating RemixButtonStyle instances using Radix design tokens
// ABOUTME: Provides all 6 Radix button variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import '../spinner/spinner.dart';
import 'button.dart';

// Export the extension so it's available when importing this file
export 'button.dart' show RadixButtonStyleExt;

/// Factory class for creating Radix-compliant button styles.
///
/// Provides static methods to create RemixButtonStyle instances for all
/// Radix UI button variants using the RadixTokens system.
class RadixButtonStyles {
  const RadixButtonStyles._();

  /// Creates a solid variant button style.
  ///
  /// Solid buttons have high emphasis with solid accent background color.
  /// Used for primary actions. Compose with size methods like .size2().
  static RemixButtonStyle solid() {
    return RemixButtonStyle()
        // Visual styling only - no size properties
        .color(RadixTokens.accent9())
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.accentContrast())
              .fontWeight(RadixTokens.fontWeightMedium()),
        )
        .iconColor(RadixTokens.accentContrast())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accentContrast(),
            // Match Radix spinner token (800ms)
            duration: const Duration(milliseconds: 800),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(RemixButtonStyle().color(RadixTokens.accent10()))
        .onPressed(RemixButtonStyle().color(RadixTokens.accent10()))
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.accent9())
              .label(TextStyler().color(RadixTokens.accentContrast()))
              .icon(IconStyler(color: RadixTokens.accentContrast()))
              .spinner(
                RemixSpinnerStyle(color: RadixTokens.accentContrast()),
              ),
        );
  }

  /// Creates a soft variant button style.
  ///
  /// Soft buttons have medium emphasis with subtle accent tinted background.
  /// Used for secondary actions. Compose with size methods like .size2().
  static RemixButtonStyle soft() {
    return RemixButtonStyle()
        // Visual styling only - no size properties
        .color(RadixTokens.accent3())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontWeight(RadixTokens.fontWeightMedium()),
        )
        .iconColor(RadixTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: const Duration(milliseconds: 800),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle().color(RadixTokens.accent4()).borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onPressed(RemixButtonStyle().color(RadixTokens.accent5()))
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .label(TextStyler().color(RadixTokens.accent11()))
              .icon(IconStyler(color: RadixTokens.accent11()))
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  /// Creates a surface variant button style.
  ///
  /// Surface buttons have subtle emphasis with accent-tinted surface.
  /// Used for tertiary actions. Compose with size methods like .size2().
  static RemixButtonStyle surface() {
    return RemixButtonStyle()
        // Visual styling only - no size properties
        .color(RadixTokens.accentSurface())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontWeight(RadixTokens.fontWeightMedium()),
        )
        .iconColor(RadixTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: const Duration(milliseconds: 800),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle()
              .color(RadixTokens.accentA4()) // Uses surface hover overlay
              .borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.accentSurface())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .label(TextStyler().color(RadixTokens.accent11()))
              .icon(IconStyler(color: RadixTokens.accent11()))
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  /// Creates an outline variant button style.
  ///
  /// Outline buttons have border-focused emphasis with transparent background.
  /// Used for secondary actions where more emphasis is needed than ghost.
  /// Compose with size methods like .size2().
  static RemixButtonStyle outline() {
    return RemixButtonStyle()
        // Visual styling only - no size properties
        .color(Colors.transparent)
        .borderAll(
          color: RadixTokens.accent7(),
          width: RadixTokens.borderWidth1(),
        )
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontWeight(RadixTokens.fontWeightMedium()),
        )
        .iconColor(RadixTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: const Duration(milliseconds: 800),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle().color(RadixTokens.accentA3()).borderAll(
                color: RadixTokens.accent8(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              )
              .label(TextStyler().color(RadixTokens.accent11()))
              .icon(IconStyler(color: RadixTokens.accent11()))
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  /// Creates a ghost variant button style.
  ///
  /// Ghost buttons have minimal emphasis with no visible container.
  /// Used for very subtle actions. Compose with size methods like .size2().
  static RemixButtonStyle ghost() {
    return RemixButtonStyle()
        // Visual styling only - no size properties
        .color(Colors.transparent)
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontWeight(RadixTokens.fontWeightMedium()),
        )
        .iconColor(RadixTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: const Duration(milliseconds: 800),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(RemixButtonStyle().color(RadixTokens.accentA3()))
        .onPressed(RemixButtonStyle().color(RadixTokens.accentA4()))
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .label(TextStyler().color(RadixTokens.accent11()))
              .icon(IconStyler(color: RadixTokens.accent11()))
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  /// Creates a classic variant button style.
  ///
  /// Classic buttons have pre-flat UI style with neutral colors and shadows.
  /// Used when a more traditional button appearance is needed.
  /// Compose with size methods like .size2().
  static RemixButtonStyle classic() {
    return RemixButtonStyle()
        // Visual styling only - no size properties
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray7(),
          width: RadixTokens.borderWidth1(),
        )
        // Add subtle shadow for classic feel using token
        .shadows(RadixTokens.shadow2().map(BoxShadowMix.value).toList())
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontWeight(RadixTokens.fontWeightMedium()),
        )
        .iconColor(RadixTokens.gray12())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.gray12(),
            duration: const Duration(milliseconds: 800),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle()
              .color(RadixTokens.gray3())
              .borderAll(
                color: RadixTokens.gray8(),
                width: RadixTokens.borderWidth1(),
              )
              .shadows(
                RadixTokens.shadow2().map(BoxShadowMix.value).toList(),
              ),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .labelColor(RadixTokens.gray12())
              .spinnerColor(RadixTokens.gray12())
              .shadows(
                RadixTokens.shadow1().map(BoxShadowMix.value).toList(),
              )
              .iconColor(RadixTokens.gray12()),
        );
  }

  /// Creates a size 1 button style (small).
  ///
  /// Small buttons for compact layouts, toolbars, and dense interfaces.
  /// Compose with variant methods like .solid().
  static RemixButtonStyle size1() {
    return RemixButtonStyle()
        .height(24.0)
        .paddingX(RadixTokens.space2())
        .paddingY(RadixTokens.space1())
        .spacing(RadixTokens.space1())
        .borderRadiusAll(RadixTokens.radius2())
        .label(
          TextStyler()
              .fontSize(12.0)
              .height(16.0 / 12.0) // lineHeight as ratio
              .letterSpacing(0.0025),
        )
        .iconSize(12.0)
        .spinner(RemixSpinnerStyle(size: 12.0));
  }

  /// Creates a size 2 button style (medium - default).
  ///
  /// Standard buttons for most common use cases.
  /// Compose with variant methods like .solid().
  static RemixButtonStyle size2() {
    return RemixButtonStyle()
        .height(32.0)
        // Generic size padding (ghost-specific overrides provided via ghostSize*)
        .paddingX(RadixTokens.space3())
        .paddingY(RadixTokens.space2())
        .spacing(RadixTokens.space2())
        .borderRadiusAll(RadixTokens.radius3())
        .label(
          TextStyler()
              .fontSize(14.0)
              .height(20.0 / 14.0) // lineHeight as ratio
              .letterSpacing(0.0),
        )
        .iconSize(16.0)
        .spinner(RemixSpinnerStyle(size: 16.0));
  }

  /// Creates a size 3 button style (large).
  ///
  /// Large buttons for prominent CTAs and accessibility needs.
  /// Compose with variant methods like .solid().
  static RemixButtonStyle size3() {
    return RemixButtonStyle()
        .height(40.0)
        .paddingX(RadixTokens.space4())
        .paddingY(RadixTokens.space3())
        .spacing(RadixTokens.space3())
        .borderRadiusAll(RadixTokens.radius4())
        .label(
          TextStyler()
              .fontSize(16.0)
              .height(24.0 / 16.0) // lineHeight as ratio
              .letterSpacing(0.0),
        )
        .iconSize(20.0)
        .spinner(RemixSpinnerStyle(size: 20.0));
  }

  /// Creates a size 4 button style (extra large).
  ///
  /// Extra large buttons for maximum prominence and accessibility.
  /// Compose with variant methods like .solid().
  static RemixButtonStyle size4() {
    return RemixButtonStyle()
        .height(48.0)
        .paddingX(RadixTokens.space5())
        .paddingY(RadixTokens.space4())
        .spacing(RadixTokens.space4())
        .borderRadiusAll(RadixTokens.radius5())
        .label(
          TextStyler()
              .fontSize(18.0)
              .height(26.0 / 18.0) // lineHeight as ratio
              .letterSpacing(-0.0025),
        )
        .iconSize(24.0)
        .spinner(RemixSpinnerStyle(size: 24.0));
  }
}
