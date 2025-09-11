// ABOUTME: Factory for creating RemixCheckboxStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix checkbox variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'checkbox.dart';

/// Factory class for creating Radix-compliant checkbox styles.
///
/// Provides static methods to create RemixCheckboxStyle instances for all
/// Radix UI checkbox variants using the RadixTokens system.
class RadixCheckboxStyles {
  const RadixCheckboxStyles._();

  /// Creates a classic variant checkbox style.
  ///
  /// Classic checkboxes use neutral surface with gray borders that become
  /// accent-colored when checked. Used for standard form controls.
  static RemixCheckboxStyle classic({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixCheckboxStyle()
        // Container styling
        .container(
          FlexBoxStyler()
              .gap(sizeConfig.gap)
              .mainAxisAlignment(MainAxisAlignment.start)
              .crossAxisAlignment(CrossAxisAlignment.center),
        )
        // Indicator container (the checkbox box itself)
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(RadixTokens.radius2())
              .width(sizeConfig.checkboxSize)
              .height(sizeConfig.checkboxSize),
        )
        // Check mark icon
        .indicator(
          IconStyler()
              .color(RadixTokens.gray12())
              .size(sizeConfig.iconSize),
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
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler()
                .color(RadixTokens.accent9())
                .borderAll(
                  color: RadixTokens.accent9(),
                  width: RadixTokens.borderWidth1(),
                ),
          ).indicator(
            IconStyler().color(RadixTokens.accentContrast),
          ),
        )
        .onFocused(
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler()
                    .color(RadixTokens.colorSurface())
                    .borderAll(
                      color: RadixTokens.gray7(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(
                IconStyler().color(RadixTokens.gray12()),
              )
              .label(
                TextStyler().color(RadixTokens.gray12()),
              ),
        );
  }

  /// Creates a surface variant checkbox style.
  ///
  /// Surface checkboxes use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance.
  static RemixCheckboxStyle surface({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixCheckboxStyle()
        // Container styling
        .container(
          FlexBoxStyler()
              .gap(sizeConfig.gap)
              .mainAxisAlignment(MainAxisAlignment.start)
              .crossAxisAlignment(CrossAxisAlignment.center),
        )
        // Indicator container (the checkbox box itself)
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(RadixTokens.radius2())
              .width(sizeConfig.checkboxSize)
              .height(sizeConfig.checkboxSize),
        )
        // Check mark icon
        .indicator(
          IconStyler()
              .color(RadixTokens.accent9())
              .size(sizeConfig.iconSize),
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
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler()
                .color(RadixTokens.colorSurface())
                .borderAll(
                  color: RadixTokens.gray6(),
                  width: RadixTokens.borderWidth1(),
                ),
          ).indicator(
            IconStyler().color(RadixTokens.accent9()),
          ),
        )
        .onFocused(
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler()
                    .color(RadixTokens.colorSurface())
                    .borderAll(
                      color: RadixTokens.gray6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(
                IconStyler().color(RadixTokens.accent9()),
              )
              .label(
                TextStyler().color(RadixTokens.gray12()),
              ),
        );
  }

  /// Creates a soft variant checkbox style.
  ///
  /// Soft checkboxes use accent-tinted background with accent borders.
  /// Used for forms that need accent color integration.
  static RemixCheckboxStyle soft({int size = 2}) {
    final sizeConfig = _getSizeConfig(size);

    return RemixCheckboxStyle()
        // Container styling
        .container(
          FlexBoxStyler()
              .gap(sizeConfig.gap)
              .mainAxisAlignment(MainAxisAlignment.start)
              .crossAxisAlignment(CrossAxisAlignment.center),
        )
        // Indicator container (the checkbox box itself)
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(RadixTokens.radius2())
              .width(sizeConfig.checkboxSize)
              .height(sizeConfig.checkboxSize),
        )
        // Check mark icon
        .indicator(
          IconStyler()
              .color(RadixTokens.accent11())
              .size(sizeConfig.iconSize),
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
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler()
                .color(RadixTokens.accent3())
                .borderAll(
                  color: RadixTokens.accent6(),
                  width: RadixTokens.borderWidth1(),
                ),
          ).indicator(
            IconStyler().color(RadixTokens.accent11()),
          ),
        )
        .onFocused(
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler()
                    .color(RadixTokens.accent3())
                    .borderAll(
                      color: RadixTokens.accent6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(
                IconStyler().color(RadixTokens.accent11()),
              )
              .label(
                TextStyler().color(RadixTokens.gray12()),
              ),
        );
  }

  /// Gets size configuration for the given size index.
  static _CheckboxSizeConfig _getSizeConfig(int size) {
    switch (size) {
      case 1:
        return _CheckboxSizeConfig(
          checkboxSize: 16.0,
          iconSize: 12.0,
          fontSize: 12.0,
          gap: 6.0,
        );
      case 2:
        return _CheckboxSizeConfig(
          checkboxSize: 20.0,
          iconSize: 14.0,
          fontSize: 14.0,
          gap: 8.0,
        );
      case 3:
        return _CheckboxSizeConfig(
          checkboxSize: 24.0,
          iconSize: 16.0,
          fontSize: 16.0,
          gap: 10.0,
        );
      default:
        // Default to size 2 if invalid size provided
        return _CheckboxSizeConfig(
          checkboxSize: 20.0,
          iconSize: 14.0,
          fontSize: 14.0,
          gap: 8.0,
        );
    }
  }
}

/// Internal configuration for checkbox sizes.
class _CheckboxSizeConfig {
  final double checkboxSize;
  final double iconSize;
  final double fontSize;
  final double gap;

  const _CheckboxSizeConfig({
    required this.checkboxSize,
    required this.iconSize,
    required this.fontSize,
    required this.gap,
  });
}