// ABOUTME: Factory for creating RemixRadioStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix radio variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'radio.dart';

/// Factory class for creating Radix-compliant radio styles.
///
/// Provides static methods to create RemixRadioStyle instances for all
/// Radix UI radio variants using the RadixTokens system.
class RadixRadioStyles {
  const RadixRadioStyles._();

  /// Creates a classic variant radio style.
  ///
  /// Classic radios use neutral surface with gray borders that become
  /// accent-colored when selected. Used for standard form controls.
  static RemixRadioStyle classic({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixRadioStyle()
        // Container styling
        .container(
          FlexBoxStyler()
              .gap(sizeConfig.gap)
              .mainAxisAlignment(MainAxisAlignment.start)
              .crossAxisAlignment(CrossAxisAlignment.center),
        )
        // Indicator container (the radio circle itself)
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(RadixTokens.radiusFull()) // Circular
              .width(sizeConfig.radioSize)
              .height(sizeConfig.radioSize),
        )
        // Radio dot indicator
        .indicator(
          BoxStyler()
              .color(RadixTokens.gray12())
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.dotSize)
              .height(sizeConfig.dotSize),
        )
        // Label text
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // State variants
        .onVariant(
          'checked',
          RemixRadioStyle().indicatorContainer(
            BoxStyler()
                .color(RadixTokens.colorSurface())
                .borderAll(
                  color: RadixTokens.accent9(),
                  width: RadixTokens.borderWidth1(),
                ),
          ).indicator(
            BoxStyler().color(RadixTokens.accentContrast),
          ),
        )
        .onFocused(
          RemixRadioStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        .onDisabled(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler()
                    .color(RadixTokens.colorSurface())
                    .borderAll(
                      color: RadixTokens.gray7(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(
                BoxStyler().color(RadixTokens.gray12()),
              )
              .label(
                TextStyler().color(RadixTokens.gray12()),
              ),
        );
  }

  /// Creates a surface variant radio style.
  ///
  /// Surface radios use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance.
  static RemixRadioStyle surface({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixRadioStyle()
        // Container styling
        .container(
          FlexBoxStyler()
              .gap(sizeConfig.gap)
              .mainAxisAlignment(MainAxisAlignment.start)
              .crossAxisAlignment(CrossAxisAlignment.center),
        )
        // Indicator container (the radio circle itself)
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(RadixTokens.radiusFull()) // Circular
              .width(sizeConfig.radioSize)
              .height(sizeConfig.radioSize),
        )
        // Radio dot indicator
        .indicator(
          BoxStyler()
              .color(RadixTokens.accent9())
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.dotSize)
              .height(sizeConfig.dotSize),
        )
        // Label text
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // State variants
        .onVariant(
          'checked',
          RemixRadioStyle().indicatorContainer(
            BoxStyler()
                .color(RadixTokens.colorSurface())
                .borderAll(
                  color: RadixTokens.gray6(),
                  width: RadixTokens.borderWidth1(),
                ),
          ).indicator(
            BoxStyler().color(RadixTokens.accent9()),
          ),
        )
        .onFocused(
          RemixRadioStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        .onDisabled(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler()
                    .color(RadixTokens.colorSurface())
                    .borderAll(
                      color: RadixTokens.gray6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(
                BoxStyler().color(RadixTokens.accent9()),
              )
              .label(
                TextStyler().color(RadixTokens.gray12()),
              ),
        );
  }

  /// Creates a soft variant radio style.
  ///
  /// Soft radios use accent-tinted background with accent borders.
  /// Used for forms that need accent color integration.
  static RemixRadioStyle soft({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixRadioStyle()
        // Container styling
        .container(
          FlexBoxStyler()
              .gap(sizeConfig.gap)
              .mainAxisAlignment(MainAxisAlignment.start)
              .crossAxisAlignment(CrossAxisAlignment.center),
        )
        // Indicator container (the radio circle itself)
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(RadixTokens.radiusFull()) // Circular
              .width(sizeConfig.radioSize)
              .height(sizeConfig.radioSize),
        )
        // Radio dot indicator
        .indicator(
          BoxStyler()
              .color(RadixTokens.accent11())
              .borderRadius(RadixTokens.radiusFull())
              .width(sizeConfig.dotSize)
              .height(sizeConfig.dotSize),
        )
        // Label text
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontSize(sizeConfig.fontSize)
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // State variants
        .onVariant(
          'checked',
          RemixRadioStyle().indicatorContainer(
            BoxStyler()
                .color(RadixTokens.accent3())
                .borderAll(
                  color: RadixTokens.accent6(),
                  width: RadixTokens.borderWidth1(),
                ),
          ).indicator(
            BoxStyler().color(RadixTokens.accent11()),
          ),
        )
        .onFocused(
          RemixRadioStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        .onDisabled(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler()
                    .color(RadixTokens.accent3())
                    .borderAll(
                      color: RadixTokens.accent6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(
                BoxStyler().color(RadixTokens.accent11()),
              )
              .label(
                TextStyler().color(RadixTokens.gray12()),
              ),
        );
  }

  /// Gets size configuration for the given size index.
  static _RadioSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _RadioSizeConfig(
          radioSize: 16.0,
          dotSize: 6.0,
          fontSize: 12.0,
          gap: 6.0,
        );
      case 2:
        return _RadioSizeConfig(
          radioSize: 20.0,
          dotSize: 8.0,
          fontSize: 14.0,
          gap: 8.0,
        );
      case 3:
        return _RadioSizeConfig(
          radioSize: 24.0,
          dotSize: 10.0,
          fontSize: 16.0,
          gap: 10.0,
        );
      default:
        // Default to size 2 if invalid size provided
        return _RadioSizeConfig(
          radioSize: 20.0,
          dotSize: 8.0,
          fontSize: 14.0,
          gap: 8.0,
        );
    }
  }
}

/// Internal configuration for radio sizes.
class _RadioSizeConfig {
  final double radioSize;
  final double dotSize;
  final double fontSize;
  final double gap;

  const _RadioSizeConfig({
    required this.radioSize,
    required this.dotSize,
    required this.fontSize,
    required this.gap,
  });
}