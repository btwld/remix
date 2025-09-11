// ABOUTME: Factory for creating RemixTextFieldStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix textfield variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'textfield.dart';

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
  static RemixTextFieldStyle classic({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixTextFieldStyle()
        // Background and container styling
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray7(),
          width: RadixTokens.borderWidth1(),
        )
        .borderRadiusAll(sizeConfig.radius)
        .paddingAll(sizeConfig.padding)
        .height(sizeConfig.height)
        // Text styling
        .text(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // Placeholder text styling
        .hintText(
          TextStyler()
              .color(RadixTokens.gray10())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // Cursor styling
        .cursorColor(RadixTokens.gray12())
        .cursorWidth(1.5)
        // Label styling (if present)
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontSize(sizeConfig.labelFontSize)
              .fontWeight(RadixTokens.fontWeightMedium()),
        )
        // Helper text styling (if present)
        .helperText(
          TextStyler()
              .color(RadixTokens.gray11())
              .fontSize(sizeConfig.helperFontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // State variants
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: RadixTokens.accent8(),
            width: RadixTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixTextFieldStyle()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .text(
                TextStyler().color(RadixTokens.gray10()),
              )
              .hintText(
                TextStyler().color(RadixTokens.gray8()),
              ),
        );
  }

  /// Creates a surface variant textfield style.
  ///
  /// Surface textfields use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance.
  static RemixTextFieldStyle surface({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixTextFieldStyle()
        // Background and container styling
        .color(RadixTokens.colorSurface())
        .borderAll(
          color: RadixTokens.gray6(),
          width: RadixTokens.borderWidth1(),
        )
        .borderRadiusAll(sizeConfig.radius)
        .paddingAll(sizeConfig.padding)
        .height(sizeConfig.height)
        // Text styling
        .text(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // Placeholder text styling
        .hintText(
          TextStyler()
              .color(RadixTokens.gray10())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // Cursor styling
        .cursorColor(RadixTokens.gray12())
        .cursorWidth(1.5)
        // Label styling (if present)
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontSize(sizeConfig.labelFontSize)
              .fontWeight(RadixTokens.fontWeightMedium()),
        )
        // Helper text styling (if present)
        .helperText(
          TextStyler()
              .color(RadixTokens.gray11())
              .fontSize(sizeConfig.helperFontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // State variants
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: RadixTokens.accent7(),
            width: RadixTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixTextFieldStyle()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .text(
                TextStyler().color(RadixTokens.gray10()),
              )
              .hintText(
                TextStyler().color(RadixTokens.gray8()),
              ),
        );
  }

  /// Creates a soft variant textfield style.
  ///
  /// Soft textfields use accent-tinted background with accent borders.
  /// Used for forms that need accent color integration.
  static RemixTextFieldStyle soft({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixTextFieldStyle()
        // Background and container styling
        .color(RadixTokens.accent3())
        .borderAll(
          color: RadixTokens.accent6(),
          width: RadixTokens.borderWidth1(),
        )
        .borderRadiusAll(sizeConfig.radius)
        .paddingAll(sizeConfig.padding)
        .height(sizeConfig.height)
        // Text styling - uses accent12 for higher contrast on accent background
        .text(
          TextStyler()
              .color(RadixTokens.accent12())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // Placeholder text styling
        .hintText(
          TextStyler()
              .color(RadixTokens.accent10())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // Cursor styling
        .cursorColor(RadixTokens.accent12())
        .cursorWidth(1.5)
        // Label styling (if present)
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontSize(sizeConfig.labelFontSize)
              .fontWeight(RadixTokens.fontWeightMedium()),
        )
        // Helper text styling (if present)
        .helperText(
          TextStyler()
              .color(RadixTokens.gray11())
              .fontSize(sizeConfig.helperFontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // State variants
        .onFocused(
          RemixTextFieldStyle().borderAll(
            color: RadixTokens.accent8(),
            width: RadixTokens.borderWidth1(),
          ),
        )
        .onDisabled(
          RemixTextFieldStyle()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .text(
                TextStyler().color(RadixTokens.accent11()),
              )
              .hintText(
                TextStyler().color(RadixTokens.accent9()),
              ),
        );
  }

  /// Gets size configuration for the given size index.
  static _TextFieldSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _TextFieldSizeConfig(
          height: 32.0,
          padding: 8.0,
          fontSize: 12.0,
          labelFontSize: 11.0,
          helperFontSize: 11.0,
          radius: RadixTokens.radius2(),
        );
      case 2:
        return _TextFieldSizeConfig(
          height: 40.0,
          padding: 12.0,
          fontSize: 14.0,
          labelFontSize: 13.0,
          helperFontSize: 12.0,
          radius: RadixTokens.radius3(),
        );
      case 3:
        return _TextFieldSizeConfig(
          height: 48.0,
          padding: 16.0,
          fontSize: 16.0,
          labelFontSize: 15.0,
          helperFontSize: 14.0,
          radius: RadixTokens.radius4(),
        );
      default:
        // Default to size 2 if invalid size provided
        return _TextFieldSizeConfig(
          height: 40.0,
          padding: 12.0,
          fontSize: 14.0,
          labelFontSize: 13.0,
          helperFontSize: 12.0,
          radius: RadixTokens.radius3(),
        );
    }
  }
}

/// Internal configuration for textfield sizes.
class _TextFieldSizeConfig {
  final double height;
  final double padding;
  final double fontSize;
  final double labelFontSize;
  final double helperFontSize;
  final Radius radius;

  const _TextFieldSizeConfig({
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.labelFontSize,
    required this.helperFontSize,
    required this.radius,
  });
}