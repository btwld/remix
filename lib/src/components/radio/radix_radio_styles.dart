// ABOUTME: Factory for creating RemixRadioStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix radio variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'radio.dart';

// Export the extension so it's available when importing this file
export 'radio.dart';

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
  /// Compose with size methods like .size2().
  static RemixRadioStyle classic() {
    return RemixRadioStyle()
        // Indicator container (the radio circle itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(
                  BorderRadiusMix.all(RadixTokens.radiusFull())), // Circular
        )
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(RadixTokens.gray12())
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        )
        // Label text - no size properties
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // State variants
        .onSelected(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.colorSurface()).borderAll(
                      color: RadixTokens.accent9(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(
                BoxStyler().color(RadixTokens.accentContrast()),
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
                BoxStyler().color(RadixTokens.colorSurface()).borderAll(
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
  /// Used for forms with softer visual appearance. Compose with size methods like .size2().
  static RemixRadioStyle surface() {
    return RemixRadioStyle()
        // Indicator container (the radio circle itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(
                  BorderRadiusMix.all(RadixTokens.radiusFull())), // Circular
        )
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(RadixTokens.accent9())
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        )
        // Label text - no size properties
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // State variants
        .onSelected(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.colorSurface()).borderAll(
                      color: RadixTokens.gray6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(
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
                BoxStyler().color(RadixTokens.colorSurface()).borderAll(
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
  /// Used for forms that need accent color integration. Compose with size methods like .size2().
  static RemixRadioStyle soft() {
    return RemixRadioStyle()
        // Indicator container (the radio circle itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(
                  BorderRadiusMix.all(RadixTokens.radiusFull())), // Circular
        )
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(RadixTokens.accent11())
              .borderRadius(BorderRadiusMix.all(RadixTokens.radiusFull())),
        )
        // Label text - no size properties
        .label(
          TextStyler()
              .color(RadixTokens.gray12())
              .fontWeight(RadixTokens.fontWeightRegular()),
        )
        // State variants
        .onSelected(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.accent3()).borderAll(
                      color: RadixTokens.accent6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(
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
                BoxStyler().color(RadixTokens.accent3()).borderAll(
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

  /// Creates a size 1 radio style (small).
  ///
  /// Small radios for compact layouts and dense interfaces.
  /// Compose with variant methods like .classic().
  static RemixRadioStyle size1() {
    return RemixRadioStyle(
      container: FlexBoxStyler()
          .spacing(6.0)
          .mainAxisAlignment(MainAxisAlignment.start)
          .crossAxisAlignment(CrossAxisAlignment.center),
      indicatorContainer: BoxStyler().constraints(BoxConstraintsMix(
        minWidth: 16.0,
        maxWidth: 16.0,
        minHeight: 16.0,
        maxHeight: 16.0,
      )),
      indicator: BoxStyler().constraints(BoxConstraintsMix(
        minWidth: 8.0,
        maxWidth: 8.0,
        minHeight: 8.0,
        maxHeight: 8.0,
      )),
      label: TextStyler().fontSize(12.0),
    );
  }

  /// Creates a size 2 radio style (medium - default).
  ///
  /// Standard radios for most common use cases.
  /// Compose with variant methods like .classic().
  static RemixRadioStyle size2() {
    return RemixRadioStyle(
      container: FlexBoxStyler()
          .spacing(8.0)
          .mainAxisAlignment(MainAxisAlignment.start)
          .crossAxisAlignment(CrossAxisAlignment.center),
      indicatorContainer: BoxStyler().constraints(BoxConstraintsMix(
        minWidth: 20.0,
        maxWidth: 20.0,
        minHeight: 20.0,
        maxHeight: 20.0,
      )),
      indicator: BoxStyler().constraints(BoxConstraintsMix(
        minWidth: 10.0,
        maxWidth: 10.0,
        minHeight: 10.0,
        maxHeight: 10.0,
      )),
      label: TextStyler().fontSize(14.0),
    );
  }

  /// Creates a size 3 radio style (large).
  ///
  /// Large radios for accessibility needs and prominent forms.
  /// Compose with variant methods like .classic().
  static RemixRadioStyle size3() {
    return RemixRadioStyle(
      container: FlexBoxStyler()
          .spacing(10.0)
          .mainAxisAlignment(MainAxisAlignment.start)
          .crossAxisAlignment(CrossAxisAlignment.center),
      indicatorContainer: BoxStyler().constraints(BoxConstraintsMix(
        minWidth: 24.0,
        maxWidth: 24.0,
        minHeight: 24.0,
        maxHeight: 24.0,
      )),
      indicator: BoxStyler().constraints(BoxConstraintsMix(
        minWidth: 12.0,
        maxWidth: 12.0,
        minHeight: 12.0,
        maxHeight: 12.0,
      )),
      label: TextStyler().fontSize(16.0),
    );
  }
}

/// Extension providing Radix radio size methods for fluent API.
///
/// Enables the pattern: `RadixRadioStyles.classic().size1()`
/// instead of: `RadixRadioStyles.size1().merge(RadixRadioStyles.classic())`
extension RadixRadioStyleExt on RemixRadioStyle {
  /// Creates a size 1 radio style (small).
  ///
  /// Small radios for compact layouts and dense interfaces.
  RemixRadioStyle size1() {
    return merge(RadixRadioStyles.size1());
  }

  /// Creates a size 2 radio style (medium - default).
  ///
  /// Standard radios for most common use cases.
  RemixRadioStyle size2() {
    return merge(RadixRadioStyles.size2());
  }

  /// Creates a size 3 radio style (large).
  ///
  /// Large radios for accessibility needs and prominent forms.
  RemixRadioStyle size3() {
    return merge(RadixRadioStyles.size3());
  }
}
