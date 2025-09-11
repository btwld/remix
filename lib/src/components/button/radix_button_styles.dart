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
        // Container styling
        .color(RadixTokens.solidBackground())
        .borderRadiusAll(const Radius.circular(6.0))
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(6.0)
        // Content styling using helper methods
        .labelColor(RadixTokens.solidText())
        .labelFontSize(sizeConfig.fontSize)
        .iconColor(RadixTokens.solidText())
        .iconSize(sizeConfig.iconSize)
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: 2.0,
            color: RadixTokens.solidText(),
            duration: const Duration(milliseconds: 1000),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle().color(RadixTokens.solidBackgroundHover()),
        )
        .onPressed(
          RemixButtonStyle().color(RadixTokens.solidBackgroundHover()),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.solidFocusRing(),
            width: 2,
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.solidBackground().withValues(alpha: 0.5))
              .label(
                TextStyler().color(
                  RadixTokens.solidText().withValues(alpha: 0.7),
                ),
              )
              .icon(
                IconStyler(
                  color: RadixTokens.solidText().withValues(alpha: 0.7),
                ),
              )
              .spinner(
                RemixSpinnerStyle(
                  color: RadixTokens.solidText().withValues(alpha: 0.7),
                ),
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
        // Container styling
        .color(RadixTokens.softBackground())
        .borderRadiusAll(const Radius.circular(6.0))
        .borderAll(color: RadixTokens.softBorder(), width: 1)
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(6.0)
        // Content styling using helper methods
        .labelColor(RadixTokens.softText())
        .labelFontSize(sizeConfig.fontSize)
        .iconColor(RadixTokens.softText())
        .iconSize(sizeConfig.iconSize)
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: 2.0,
            color: RadixTokens.softText(),
            duration: const Duration(milliseconds: 1000),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle()
              .color(RadixTokens.softBackgroundHover())
              .borderAll(color: RadixTokens.softBorderHover(), width: 1),
        )
        .onPressed(
          RemixButtonStyle().color(RadixTokens.softBackgroundActive()),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.softFocusRing(),
            width: 2,
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.softBackground().withValues(alpha: 0.5))
              .borderAll(
                color: RadixTokens.softBorder().withValues(alpha: 0.5),
                width: 1,
              )
              .label(
                TextStyler().color(
                  RadixTokens.softText().withValues(alpha: 0.7),
                ),
              )
              .icon(
                IconStyler(
                  color: RadixTokens.softText().withValues(alpha: 0.7),
                ),
              )
              .spinner(
                RemixSpinnerStyle(
                  color: RadixTokens.softText().withValues(alpha: 0.7),
                ),
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
        // Container styling
        .color(RadixTokens.surfaceBackground())
        .borderRadiusAll(const Radius.circular(6.0))
        .borderAll(color: RadixTokens.surfaceBorder(), width: 1)
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(6.0)
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.surfaceText())
              .fontSize(sizeConfig.fontSize),
        )
        .icon(
          IconStyler(
            color: RadixTokens.surfaceText(),
            size: sizeConfig.iconSize,
          ),
        )
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: 2.0,
            color: RadixTokens.surfaceText(),
            duration: const Duration(milliseconds: 1000),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle()
              .color(RadixTokens.surfaceBackgroundHover())
              .borderAll(color: RadixTokens.surfaceBorderHover(), width: 1),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.surfaceFocusRing(),
            width: 2,
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.surfaceBackground().withValues(alpha: 0.5))
              .borderAll(
                color: RadixTokens.surfaceBorder().withValues(alpha: 0.5),
                width: 1,
              )
              .label(
                TextStyler().color(
                  RadixTokens.surfaceText().withValues(alpha: 0.7),
                ),
              )
              .icon(
                IconStyler(
                  color: RadixTokens.surfaceText().withValues(alpha: 0.7),
                ),
              )
              .spinner(
                RemixSpinnerStyle(
                  color: RadixTokens.surfaceText().withValues(alpha: 0.7),
                ),
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
        // Container styling
        .color(RadixTokens.outlineBackground())
        .borderRadiusAll(const Radius.circular(6.0))
        .borderAll(color: RadixTokens.outlineBorder(), width: 1)
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(6.0)
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.outlineText())
              .fontSize(sizeConfig.fontSize),
        )
        .icon(
          IconStyler(
            color: RadixTokens.outlineText(),
            size: sizeConfig.iconSize,
          ),
        )
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: 2.0,
            color: RadixTokens.outlineText(),
            duration: const Duration(milliseconds: 1000),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle()
              .color(RadixTokens.outlineBackgroundHover())
              .borderAll(color: RadixTokens.outlineBorderHover(), width: 1),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.outlineFocusRing(),
            width: 2,
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .borderAll(
                color: RadixTokens.outlineBorder().withValues(alpha: 0.5),
                width: 1,
              )
              .label(
                TextStyler().color(
                  RadixTokens.outlineText().withValues(alpha: 0.7),
                ),
              )
              .icon(
                IconStyler(
                  color: RadixTokens.outlineText().withValues(alpha: 0.7),
                ),
              )
              .spinner(
                RemixSpinnerStyle(
                  color: RadixTokens.outlineText().withValues(alpha: 0.7),
                ),
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
        // Container styling
        .color(RadixTokens.ghostBackground())
        .borderRadiusAll(const Radius.circular(6.0))
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(6.0)
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.ghostText())
              .fontSize(sizeConfig.fontSize),
        )
        .icon(
          IconStyler(
            color: RadixTokens.ghostText(),
            size: sizeConfig.iconSize,
          ),
        )
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: 2.0,
            color: RadixTokens.ghostText(),
            duration: const Duration(milliseconds: 1000),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle().color(RadixTokens.ghostBackgroundHover()),
        )
        .onPressed(
          RemixButtonStyle().color(RadixTokens.ghostBackgroundActive()),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.ghostFocusRing(),
            width: 2,
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .label(
                TextStyler().color(
                  RadixTokens.ghostText().withValues(alpha: 0.7),
                ),
              )
              .icon(
                IconStyler(
                  color: RadixTokens.ghostText().withValues(alpha: 0.7),
                ),
              )
              .spinner(
                RemixSpinnerStyle(
                  color: RadixTokens.ghostText().withValues(alpha: 0.7),
                ),
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
        // Container styling
        .color(RadixTokens.classicBackground())
        .borderRadiusAll(const Radius.circular(6.0))
        .borderAll(color: RadixTokens.classicBorder(), width: 1)
        .paddingX(sizeConfig.paddingX)
        .paddingY(sizeConfig.paddingY)
        .spacing(6.0)
        // Add subtle shadow for classic feel
        .shadow(BoxShadowMix(
          color: Colors.black.withValues(alpha: 0.1),
          offset: const Offset(0, 1),
          blurRadius: 2,
        ))
        // Content styling
        .label(
          TextStyler()
              .color(RadixTokens.classicText())
              .fontSize(sizeConfig.fontSize),
        )
        .icon(
          IconStyler(
            color: RadixTokens.classicText(),
            size: sizeConfig.iconSize,
          ),
        )
        .spinner(
          RemixSpinnerStyle(
            size: sizeConfig.iconSize,
            strokeWidth: 2.0,
            color: RadixTokens.classicText(),
            duration: const Duration(milliseconds: 1000),
            type: SpinnerType.solid,
          ),
        )
        // State variants
        .onHovered(
          RemixButtonStyle()
              .color(RadixTokens.classicBackgroundHover())
              .borderAll(color: RadixTokens.classicBorderHover(), width: 1),
        )
        .onFocused(
          RemixButtonStyle().borderAll(
            color: RadixTokens.classicFocusRing(),
            width: 2,
          ),
        )
        .onDisabled(
          RemixButtonStyle()
              .color(RadixTokens.classicBackground().withValues(alpha: 0.5))
              .borderAll(
                color: RadixTokens.classicBorder().withValues(alpha: 0.5),
                width: 1,
              )
              .shadow(BoxShadowMix(
                color: Colors.black.withValues(alpha: 0.05),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ))
              .label(
                TextStyler().color(
                  RadixTokens.classicText().withValues(alpha: 0.7),
                ),
              )
              .icon(
                IconStyler(
                  color: RadixTokens.classicText().withValues(alpha: 0.7),
                ),
              )
              .spinner(
                RemixSpinnerStyle(
                  color: RadixTokens.classicText().withValues(alpha: 0.7),
                ),
              ),
        );
  }

  /// Gets size configuration for the given size index.
  static _ButtonSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _ButtonSizeConfig(
          fontSize: RadixTokens.size1FontSize(),
          paddingX: RadixTokens.size1PaddingX(),
          paddingY: RadixTokens.size1PaddingY(),
          iconSize: RadixTokens.size1IconSize(),
        );
      case 2:
        return _ButtonSizeConfig(
          fontSize: RadixTokens.size2FontSize(),
          paddingX: RadixTokens.size2PaddingX(),
          paddingY: RadixTokens.size2PaddingY(),
          iconSize: RadixTokens.size2IconSize(),
        );
      case 3:
        return _ButtonSizeConfig(
          fontSize: RadixTokens.size3FontSize(),
          paddingX: RadixTokens.size3PaddingX(),
          paddingY: RadixTokens.size3PaddingY(),
          iconSize: RadixTokens.size3IconSize(),
        );
      case 4:
        return _ButtonSizeConfig(
          fontSize: RadixTokens.size4FontSize(),
          paddingX: RadixTokens.size4PaddingX(),
          paddingY: RadixTokens.size4PaddingY(),
          iconSize: RadixTokens.size4IconSize(),
        );
      default:
        // Default to size 2 if invalid size provided
        return _ButtonSizeConfig(
          fontSize: RadixTokens.size2FontSize(),
          paddingX: RadixTokens.size2PaddingX(),
          paddingY: RadixTokens.size2PaddingY(),
          iconSize: RadixTokens.size2IconSize(),
        );
    }
  }
}

/// Internal configuration for button sizes.
class _ButtonSizeConfig {
  final double fontSize;
  final double paddingX;
  final double paddingY;
  final double iconSize;

  const _ButtonSizeConfig({
    required this.fontSize,
    required this.paddingX,
    required this.paddingY,
    required this.iconSize,
  });
}
