// ABOUTME: Factory for creating RemixButtonStyle instances using Radix design tokens
// ABOUTME: Provides all 6 Radix button variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import '../spinner/spinner.dart';
import 'button.dart';

/// Factory class for creating Radix-compliant button styles.
///
/// Provides static methods to create RemixButtonStyle instances for all
/// Radix UI button variants using the RadixTokens system.
class RadixButtonStyles {
  const RadixButtonStyles._();

  /// Creates a solid variant button style.
  ///
  /// Solid buttons have high emphasis with solid accent background color.
  /// Used for primary actions.
  static RemixButtonStyle solid({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixButtonStyle()
        // Container styling with size-specific values
        .color(RadixTokens.accent9())
        .borderRadiusAll(sizeConfig.radius)
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(sizeConfig.gap)
        .height(sizeConfig.height)
        // Content styling with comprehensive typography
        .label(
          TextStyler()
              .color(RadixTokens.accentContrast())
              .fontSize(sizeConfig.fontSize)
              .height(sizeConfig.lineHeight /
                  sizeConfig.fontSize) // lineHeight as ratio
              .letterSpacing(sizeConfig.letterSpacing)
              .fontWeight(RadixTokens.fontWeightMedium),
        )
        .iconColor(RadixTokens.accentContrast())
        .iconSize(sizeConfig.iconSize)
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accentContrast(),
            duration: RadixTokens.transitionSlow,
            type: SpinnerType.solid,
          ),
        )
        // State variants with improved focus ring
        .onHovered(
          RemixButtonStyle().color(RadixTokens.accent10()),
        )
        .onPressed(
          RemixButtonStyle().color(RadixTokens.accent10()),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.accent9())
              .label(
                TextStyler().color(RadixTokens.accentContrast()),
              )
              .icon(
                IconStyler(color: RadixTokens.accentContrast()),
              )
              .spinner(
                RemixSpinnerStyle(color: RadixTokens.accentContrast()),
              ),
        );
  }

  /// Creates a soft variant button style.
  ///
  /// Soft buttons have medium emphasis with subtle accent tinted background.
  /// Used for secondary actions.
  static RemixButtonStyle soft({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixButtonStyle()
        // Container styling with size-specific values
        .color(RadixTokens.accent3())
        .borderRadiusAll(sizeConfig.radius)
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(sizeConfig.gap)
        .height(sizeConfig.height)
        // Content styling with comprehensive typography
        .label(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontSize(sizeConfig.fontSize)
              .height(sizeConfig.lineHeight / sizeConfig.fontSize)
              .letterSpacing(sizeConfig.letterSpacing)
              .fontWeight(RadixTokens.fontWeightMedium),
        )
        .iconColor(RadixTokens.accent11())
        .iconSize(sizeConfig.iconSize)
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: RadixTokens.transitionSlow,
            type: SpinnerType.solid,
          ),
        )
        // State variants with improved tokens
        .onHovered(
          RemixButtonStyle().color(RadixTokens.accent4()).borderAll(
                color: RadixTokens.accent7(),
                width: RadixTokens.borderWidth1(),
              ),
        )
        .onPressed(
          RemixButtonStyle().color(RadixTokens.accent5()),
        )
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
              .label(
                TextStyler().color(RadixTokens.accent11()),
              )
              .icon(
                IconStyler(color: RadixTokens.accent11()),
              )
              .spinner(
                RemixSpinnerStyle(color: RadixTokens.accent11()),
              ),
        );
  }

  /// Creates a surface variant button style.
  ///
  /// Surface buttons have subtle emphasis with accent-tinted surface.
  /// Used for tertiary actions.
  static RemixButtonStyle surface({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixButtonStyle()
        // Container styling with size-specific values
        .color(RadixTokens.accentSurface())
        .borderRadiusAll(sizeConfig.radius)
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(sizeConfig.gap)
        .height(sizeConfig.height)
        // Content styling with comprehensive typography
        .label(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontSize(sizeConfig.fontSize)
              .height(sizeConfig.lineHeight / sizeConfig.fontSize)
              .letterSpacing(sizeConfig.letterSpacing)
              .fontWeight(RadixTokens.fontWeightMedium),
        )
        .icon(
          IconStyler(
            color: RadixTokens.accent11(),
            size: sizeConfig.iconSize,
          ),
        )
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: RadixTokens.transitionSlow,
            type: SpinnerType.solid,
          ),
        )
        // State variants with surface-specific hover (uses overlay calculation)
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
              .label(
                TextStyler().color(RadixTokens.accent11()),
              )
              .icon(
                IconStyler(color: RadixTokens.accent11()),
              )
              .spinner(
                RemixSpinnerStyle(color: RadixTokens.accent11()),
              ),
        );
  }

  /// Creates an outline variant button style.
  ///
  /// Outline buttons have border-focused emphasis with transparent background.
  /// Used for secondary actions where more emphasis is needed than ghost.
  static RemixButtonStyle outline({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixButtonStyle()
        // Container styling with size-specific values
        .color(Colors.transparent)
        .borderRadiusAll(sizeConfig.radius)
        .borderAll(
          color: RadixTokens.accent7(),
          width: RadixTokens.borderWidth1(),
        )
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(sizeConfig.gap)
        .height(sizeConfig.height)
        // Content styling with comprehensive typography
        .label(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontSize(sizeConfig.fontSize)
              .height(sizeConfig.lineHeight / sizeConfig.fontSize)
              .letterSpacing(sizeConfig.letterSpacing)
              .fontWeight(RadixTokens.fontWeightMedium),
        )
        .icon(
          IconStyler(
            color: RadixTokens.accent11(),
            size: sizeConfig.iconSize,
          ),
        )
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: RadixTokens.transitionSlow,
            type: SpinnerType.solid,
          ),
        )
        // State variants with improved tokens
        .onHovered(
          RemixButtonStyle()
              .color(RadixTokens.accentA3())
              .borderAll(
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
              .label(
                TextStyler().color(RadixTokens.accent11()),
              )
              .icon(
                IconStyler(color: RadixTokens.accent11()),
              )
              .spinner(
                RemixSpinnerStyle(color: RadixTokens.accent11()),
              ),
        );
  }

  /// Creates a ghost variant button style.
  ///
  /// Ghost buttons have minimal emphasis with no visible container.
  /// Used for very subtle actions.
  static RemixButtonStyle ghost({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixButtonStyle()
        // Container styling with size-specific values
        .color(Colors.transparent)
        .borderRadiusAll(sizeConfig.radius)
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(sizeConfig.gap)
        .height(sizeConfig.height)
        // Content styling with comprehensive typography
        .label(
          TextStyler()
              .color(RadixTokens.accent11())
              .fontSize(sizeConfig.fontSize)
              .height(sizeConfig.lineHeight / sizeConfig.fontSize)
              .letterSpacing(sizeConfig.letterSpacing)
              .fontWeight(RadixTokens.fontWeightMedium),
        )
        .icon(
          IconStyler(
            color: RadixTokens.accent11(),
            size: sizeConfig.iconSize,
          ),
        )
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.accent11(),
            duration: RadixTokens.transitionSlow,
            type: SpinnerType.solid,
          ),
        )
        // State variants with improved tokens
        .onHovered(
          RemixButtonStyle().color(RadixTokens.accentA3()),
        )
        .onPressed(
          RemixButtonStyle().color(RadixTokens.accentA4()),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.focusA8(),
            width: RadixTokens.focusRingWidth(),
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .label(
                TextStyler().color(RadixTokens.accent11()),
              )
              .icon(
                IconStyler(color: RadixTokens.accent11()),
              )
              .spinner(
                RemixSpinnerStyle(color: RadixTokens.accent11()),
              ),
        );
  }

  /// Creates a classic variant button style.
  ///
  /// Classic buttons have pre-flat UI style with neutral colors and shadows.
  /// Used when a more traditional button appearance is needed.
  static RemixButtonStyle classic({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixButtonStyle()
        // Container styling with size-specific values
        .color(RadixTokens.colorSurface())
        .borderRadiusAll(sizeConfig.radius)
        .borderAll(
          color: RadixTokens.gray7(),
          width: RadixTokens.borderWidth1(),
        )
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(sizeConfig.gap)
        .height(sizeConfig.height)
        // Add subtle shadow for classic feel using token
        // TODO: Fix shadow implementation
        // .shadow(RadixTokens.shadow2())
        // Content styling with comprehensive typography
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontSize(sizeConfig.fontSize)
              .height(sizeConfig.lineHeight / sizeConfig.fontSize)
              .letterSpacing(sizeConfig.letterSpacing)
              .fontWeight(RadixTokens.fontWeightMedium),
        )
        .icon(
          IconStyler(
            color: RadixTokens.gray12(),
            size: sizeConfig.iconSize,
          ),
        )
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: RadixTokens.borderWidth2(),
            color: RadixTokens.gray12(),
            duration: RadixTokens.transitionSlow,
            type: SpinnerType.solid,
          ),
        )
        // State variants with improved tokens
        .onHovered(
          RemixButtonStyle()
              .color(RadixTokens.gray3())
              .borderAll(
                color: RadixTokens.gray8(),
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
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .labelColor(RadixTokens.gray12())
              .spinnerColor(RadixTokens.gray12())
              // TODO: Fix shadow implementation
              // .shadow(RadixTokens.shadow1())
              .iconColor(RadixTokens.gray12()),
        );
  }

  /// Gets size configuration for the given size index.
  static _ButtonSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _ButtonSizeConfig(
          height: 24.0,
          paddingX: 8.0,
          paddingY: 4.0,
          gap: 4.0,
          fontSize: 12.0,
          lineHeight: 16.0,
          letterSpacing: 0.0025,
          radius: RadixTokens.radius2(),
          iconSize: 12.0,
        );
      case 2:
        return _ButtonSizeConfig(
          height: 32.0,
          paddingX: 12.0,
          paddingY: 6.0,
          gap: 6.0,
          fontSize: 14.0,
          lineHeight: 20.0,
          letterSpacing: 0.0,
          radius: RadixTokens.radius3(),
          iconSize: 16.0,
        );
      case 3:
        return _ButtonSizeConfig(
          height: 40.0,
          paddingX: 16.0,
          paddingY: 8.0,
          gap: 8.0,
          fontSize: 16.0,
          lineHeight: 24.0,
          letterSpacing: 0.0,
          radius: RadixTokens.radius4(),
          iconSize: 20.0,
        );
      case 4:
        return _ButtonSizeConfig(
          height: 48.0,
          paddingX: 20.0,
          paddingY: 10.0,
          gap: 10.0,
          fontSize: 18.0,
          lineHeight: 26.0,
          letterSpacing: -0.0025,
          radius: RadixTokens.radius5(),
          iconSize: 24.0,
        );
      default:
        // Default to size 2 if invalid size provided
        return _ButtonSizeConfig(
          height: 32.0,
          paddingX: 12.0,
          paddingY: 6.0,
          gap: 6.0,
          fontSize: 14.0,
          lineHeight: 20.0,
          letterSpacing: 0.0,
          radius: RadixTokens.radius3(),
          iconSize: 16.0,
        );
    }
  }
}

/// Internal configuration for button sizes.
class _ButtonSizeConfig {
  final double height;
  final double paddingX;
  final double paddingY;
  final double gap;
  final double fontSize;
  final double lineHeight;
  final double letterSpacing;
  final Radius radius;
  final double iconSize;

  const _ButtonSizeConfig({
    required this.height,
    required this.paddingX,
    required this.paddingY,
    required this.gap,
    required this.fontSize,
    required this.lineHeight,
    required this.letterSpacing,
    required this.radius,
    required this.iconSize,
  });
}
