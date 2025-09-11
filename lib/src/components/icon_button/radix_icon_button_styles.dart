// ABOUTME: Factory for creating RemixIconButtonStyle instances using Radix design tokens
// ABOUTME: Provides all 6 Radix icon button variants with proper token-based styling

import 'package:flutter/material.dart';

import '../../theme/radix_tokens.dart';
import '../spinner/spinner.dart';
import 'icon_button.dart';

/// Factory class for creating Radix-compliant icon button styles.
///
/// Provides static methods to create RemixIconButtonStyle instances for all
/// Radix UI icon button variants using the RadixTokens system.
class RadixIconButtonStyles {
  const RadixIconButtonStyles._();

  /// Creates a solid variant icon button style.
  ///
  /// Solid icon buttons have high emphasis with solid accent background color.
  /// Used for primary icon actions. Compose with size methods like .size2().
  static RemixIconButtonStyle solid() {
    return RemixIconButtonStyle()
        // Visual styling only - no size properties
        .color(RadixTokens.accent9())
        // Icon styling
        .iconColor(RadixTokens.accentContrast())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accentContrast(),
            duration: RadixTokens.transitionSlow(),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(RemixIconButtonStyle().color(RadixTokens.accent10()))
        .onPressed(RemixIconButtonStyle().color(RadixTokens.accent10()))
        .onFocused(
          RemixIconButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .color(RadixTokens.accent9())
              .iconColor(RadixTokens.accentContrast())
              .spinner(
                RemixSpinnerStyle(color: RadixTokens.accentContrast()),
              ),
        );
  }

  /// Creates a soft variant icon button style.
  ///
  /// Soft icon buttons have medium emphasis with subtle accent tinted background.
  /// Used for secondary icon actions. Compose with size methods like .size2().
  static RemixIconButtonStyle soft() {
    return RemixIconButtonStyle()
        // Visual styling only - no size properties
        .color(RadixTokens.accent3())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        // Icon styling
        .iconColor(RadixTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: RadixTokens.transitionSlow(),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixIconButtonStyle().color(RadixTokens.accent4()).borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onPressed(RemixIconButtonStyle().color(RadixTokens.accent5()))
        .onFocused(
          RemixIconButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .iconColor(RadixTokens.accent11())
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  /// Creates a surface variant icon button style.
  ///
  /// Surface icon buttons have subtle emphasis with accent-tinted surface.
  /// Used for tertiary icon actions. Compose with size methods like .size2().
  static RemixIconButtonStyle surface() {
    return RemixIconButtonStyle()
        // Visual styling only - no size properties
        .color(RadixTokens.accentSurface())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        // Icon styling
        .iconColor(RadixTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: RadixTokens.transitionSlow(),
            type: SpinnerType.solid,
          ),
        )
        // State variants with surface-specific hover (uses overlay calculation)
        .onHovered(
          RemixIconButtonStyle()
              .color(RadixTokens.accentA4()) // Simplified overlay calculation
              .borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onFocused(
          RemixIconButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .color(RadixTokens.accentSurface())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .iconColor(RadixTokens.accent11())
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  /// Creates an outline variant icon button style.
  ///
  /// Outline icon buttons have border-focused emphasis with transparent background.
  /// Used for secondary icon actions where more emphasis is needed than ghost.
  /// Compose with size methods like .size2().
  static RemixIconButtonStyle outline() {
    return RemixIconButtonStyle()
        // Visual styling only - no size properties
        .color(Colors.transparent)
        .borderAll(
          color: RadixTokens.accent7(),
          width: RadixTokens.borderWidth1(),
        )
        // Icon styling
        .iconColor(RadixTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: RadixTokens.transitionSlow(),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixIconButtonStyle().color(RadixTokens.accentA3()).borderAll(
                color: RadixTokens.accent8(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onFocused(
          RemixIconButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              )
              .iconColor(RadixTokens.accent11())
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  /// Creates a ghost variant icon button style.
  ///
  /// Ghost icon buttons have minimal emphasis with no visible container.
  /// Used for very subtle icon actions. Compose with size methods like .size2().
  static RemixIconButtonStyle ghost() {
    return RemixIconButtonStyle()
        // Visual styling only - no size properties
        .color(Colors.transparent)
        // Icon styling
        .iconColor(RadixTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: RadixTokens.transitionSlow(),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(RemixIconButtonStyle().color(RadixTokens.accentA3()))
        .onPressed(RemixIconButtonStyle().color(RadixTokens.accentA4()))
        .onFocused(
          RemixIconButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .iconColor(RadixTokens.accent11())
              .spinner(RemixSpinnerStyle(color: RadixTokens.accent11())),
        );
  }

  /// Creates a classic variant icon button style.
  ///
  /// Classic icon buttons have pre-flat UI style with neutral colors and shadows.
  /// Used when a more traditional icon button appearance is needed.
  /// Compose with size methods like .size2().
  static RemixIconButtonStyle classic() {
    return RemixIconButtonStyle()
        // Visual styling only - no size properties
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray7(),
          width: RadixTokens.borderWidth1(),
        )
        // Icon styling
        .iconColor(RadixTokens.gray12())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.gray12(),
            duration: RadixTokens.transitionSlow(),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixIconButtonStyle().color(RadixTokens.gray3()).borderAll(
                color: RadixTokens.gray8(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onFocused(
          RemixIconButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .iconColor(RadixTokens.gray12())
              .spinner(RemixSpinnerStyle(color: RadixTokens.gray12())),
        );
  }

  /// Creates a size 1 icon button style (small).
  ///
  /// Small icon buttons for compact layouts, toolbars, and dense interfaces.
  /// Compose with variant methods like .solid().
  static RemixIconButtonStyle size1() {
    return RemixIconButtonStyle()
        .width(24.0)
        .height(24.0)
        .borderRadiusAll(RadixTokens.radius2())
        .iconSize(12.0)
        .spinner(RemixSpinnerStyle(size: 12.0));
  }

  /// Creates a size 2 icon button style (medium - default).
  ///
  /// Standard icon buttons for most common use cases.
  /// Compose with variant methods like .solid().
  static RemixIconButtonStyle size2() {
    return RemixIconButtonStyle()
        .width(32.0)
        .height(32.0)
        .borderRadiusAll(RadixTokens.radius3())
        .iconSize(16.0)
        .spinner(RemixSpinnerStyle(size: 16.0));
  }

  /// Creates a size 3 icon button style (large).
  ///
  /// Large icon buttons for prominent actions and accessibility needs.
  /// Compose with variant methods like .solid().
  static RemixIconButtonStyle size3() {
    return RemixIconButtonStyle()
        .width(40.0)
        .height(40.0)
        .borderRadiusAll(RadixTokens.radius4())
        .iconSize(20.0)
        .spinner(RemixSpinnerStyle(size: 20.0));
  }

  /// Creates a size 4 icon button style (extra large).
  ///
  /// Extra large icon buttons for maximum prominence and accessibility.
  /// Compose with variant methods like .solid().
  static RemixIconButtonStyle size4() {
    return RemixIconButtonStyle()
        .width(48.0)
        .height(48.0)
        .borderRadiusAll(RadixTokens.radius5())
        .iconSize(24.0)
        .spinner(RemixSpinnerStyle(size: 24.0));
  }
}
