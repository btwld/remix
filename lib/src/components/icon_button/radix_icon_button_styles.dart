// ABOUTME: Factory for creating RemixIconButtonStyle instances using Radix design tokens
// ABOUTME: Provides all 6 Radix icon button variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import '../spinner/spinner.dart';
import 'icon_button.dart';

enum RadixIconButtonSize {
  size1,
  size2,
  size3,
  size4,
}

enum RadixIconButtonVariant {
  solid,
  soft,
  surface,
  outline,
  ghost,
  classic,
}

/// Factory class for creating Radix-compliant icon button styles.
///
/// Provides static methods to create RemixIconButtonStyle instances for all
/// Radix UI icon button variants using the RadixTokens system.
class RadixIconButtonStyles {
  const RadixIconButtonStyles._();

  /// Factory constructor for RadixIconButtonStyle with variant and size parameters.
  ///
  /// Returns a RemixIconButtonStyle configured with Radix design tokens.
  /// Defaults to solid variant with size2.
  static RemixIconButtonStyle create({
    RadixIconButtonVariant variant = RadixIconButtonVariant.solid,
    RadixIconButtonSize size = RadixIconButtonSize.size2,
  }) {
    return switch (variant) {
      RadixIconButtonVariant.solid => solid(size: size),
      RadixIconButtonVariant.soft => soft(size: size),
      RadixIconButtonVariant.surface => surface(size: size),
      RadixIconButtonVariant.outline => outline(size: size),
      RadixIconButtonVariant.ghost => ghost(size: size),
      RadixIconButtonVariant.classic => classic(size: size),
    };
  }

  static RemixIconButtonStyle base({
    RadixIconButtonSize size = RadixIconButtonSize.size2,
  }) {
    return RemixIconButtonStyle()
        // Focus state (generic)
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a solid variant icon button style.
  ///
  /// Solid icon buttons have high emphasis with solid accent background color.
  /// Used for primary icon actions.
  static RemixIconButtonStyle solid({
    RadixIconButtonSize size = RadixIconButtonSize.size2,
  }) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(RadixTokens.accent9())
        // Icon styling
        .iconColor(RadixTokens.accentContrast())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accentContrast(),
            duration: const Duration(milliseconds: 800),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(RemixIconButtonStyle().color(RadixTokens.accent10()))
        .onPressed(RemixIconButtonStyle().color(RadixTokens.accent10()))
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
  /// Used for secondary icon actions.
  static RemixIconButtonStyle soft({
    RadixIconButtonSize size = RadixIconButtonSize.size2,
  }) {
    return base(size: size)
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
            duration: const Duration(milliseconds: 800),
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
  /// Used for tertiary icon actions.
  static RemixIconButtonStyle surface({
    RadixIconButtonSize size = RadixIconButtonSize.size2,
  }) {
    return base(size: size)
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
            duration: const Duration(milliseconds: 800),
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
  static RemixIconButtonStyle outline({
    RadixIconButtonSize size = RadixIconButtonSize.size2,
  }) {
    return base(size: size)
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
            duration: const Duration(milliseconds: 800),
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
  /// Used for very subtle icon actions.
  static RemixIconButtonStyle ghost({
    RadixIconButtonSize size = RadixIconButtonSize.size2,
  }) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(Colors.transparent)
        // Icon styling
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
        .onHovered(RemixIconButtonStyle().color(RadixTokens.accentA3()))
        .onPressed(RemixIconButtonStyle().color(RadixTokens.accentA4()))
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
  static RemixIconButtonStyle classic({
    RadixIconButtonSize size = RadixIconButtonSize.size2,
  }) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray7(),
          width: RadixTokens.borderWidth1(),
        )
        // Add subtle shadow for classic feel using token
        .shadows(RadixTokens.shadow2().map(BoxShadowMix.value).toList())
        // Icon styling
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
          RemixIconButtonStyle()
              .color(RadixTokens.gray3())
              .borderAll(
                color: RadixTokens.gray8(),
                width: RadixTokens.borderWidth1(),
              )
              .shadows(
                RadixTokens.shadow2().map(BoxShadowMix.value).toList(),
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
              .spinner(RemixSpinnerStyle(color: RadixTokens.gray12()))
              .shadows(
                RadixTokens.shadow1().map(BoxShadowMix.value).toList(),
              ),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixIconButtonStyle _sizeStyle(RadixIconButtonSize size) {
    return switch (size) {
      RadixIconButtonSize.size1 => RemixIconButtonStyle()
          .width(24.0)
          .height(24.0)
          .borderRadiusAll(RadixTokens.radius2())
          .iconSize(12.0)
          .spinner(RemixSpinnerStyle(size: 12.0)),
      RadixIconButtonSize.size2 => RemixIconButtonStyle()
          .width(32.0)
          .height(32.0)
          .borderRadiusAll(RadixTokens.radius3())
          .iconSize(16.0)
          .spinner(RemixSpinnerStyle(size: 16.0)),
      RadixIconButtonSize.size3 => RemixIconButtonStyle()
          .width(40.0)
          .height(40.0)
          .borderRadiusAll(RadixTokens.radius4())
          .iconSize(20.0)
          .spinner(RemixSpinnerStyle(size: 20.0)),
      RadixIconButtonSize.size4 => RemixIconButtonStyle()
          .width(48.0)
          .height(48.0)
          .borderRadiusAll(RadixTokens.radius5())
          .iconSize(24.0)
          .spinner(RemixSpinnerStyle(size: 24.0)),
    };
  }
}
