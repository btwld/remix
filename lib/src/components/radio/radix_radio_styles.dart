// ABOUTME: Factory for creating RemixRadioStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix radio variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'radio.dart';

// Export the extension so it's available when importing this file
export 'radio.dart';

enum RadixRadioSize {
  size1,
  size2,
  size3,
}

enum RadixRadioVariant {
  classic,
  surface,
  soft,
}

/// Factory class for creating Radix-compliant radio styles.
///
/// Provides static methods to create RemixRadioStyle instances for all
/// Radix UI radio variants using the RadixTokens system.
class RadixRadioStyles {
  const RadixRadioStyles._();

  /// Factory constructor for RadixRadioStyle with variant and size parameters.
  ///
  /// Returns a RemixRadioStyle configured with Radix design tokens.
  /// Defaults to classic variant with size2.
  static RemixRadioStyle create({
    RadixRadioVariant variant = RadixRadioVariant.classic,
    RadixRadioSize size = RadixRadioSize.size2,
  }) {
    return switch (variant) {
      RadixRadioVariant.classic => classic(size: size),
      RadixRadioVariant.surface => surface(size: size),
      RadixRadioVariant.soft => soft(size: size),
    };
  }

  static RemixRadioStyle base({RadixRadioSize size = RadixRadioSize.size2}) {
    return RemixRadioStyle()
        // Focus state (generic)
        .onFocused(
          RemixRadioStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a classic variant radio style.
  ///
  /// Classic radios use neutral surface with gray borders that become
  /// accent-colored when selected. Used for standard form controls.
  static RemixRadioStyle classic({
    RadixRadioSize size = RadixRadioSize.size2,
  }) {
    return base(size: size)
        // Indicator container (the radio circle itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadiusAll(RadixTokens.radiusFull()) // Circular

          ,
        )
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(RadixTokens.gray12())
              .borderRadiusAll(RadixTokens.radiusFull()),
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
              .indicator(BoxStyler().color(RadixTokens.accentContrast())),
        )
        .onDisabled(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.colorSurface()).borderAll(
                      color: RadixTokens.gray7(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(BoxStyler().color(RadixTokens.gray12())),
        );
  }

  /// Creates a surface variant radio style.
  ///
  /// Surface radios use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance.
  static RemixRadioStyle surface({
    RadixRadioSize size = RadixRadioSize.size2,
  }) {
    return base(size: size)
        // Indicator container (the radio circle itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadiusAll(RadixTokens.radiusFull()) // Circular

          ,
        )
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(RadixTokens.accent9())
              .borderRadiusAll(RadixTokens.radiusFull()),
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
              .indicator(BoxStyler().color(RadixTokens.accent9())),
        )
        .onDisabled(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.colorSurface()).borderAll(
                      color: RadixTokens.gray6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(BoxStyler().color(RadixTokens.accent9())),
        );
  }

  /// Creates a soft variant radio style.
  ///
  /// Soft radios use accent-tinted background with accent borders.
  /// Used for forms that need accent color integration.
  static RemixRadioStyle soft({RadixRadioSize size = RadixRadioSize.size2}) {
    return base(size: size)
        // Indicator container (the radio circle itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadiusAll(RadixTokens.radiusFull()) // Circular

          ,
        )
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(RadixTokens.accent11())
              .borderRadiusAll(RadixTokens.radiusFull()),
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
              .indicator(BoxStyler().color(RadixTokens.accent11())),
        )
        .onDisabled(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.accent3()).borderAll(
                      color: RadixTokens.accent6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicator(BoxStyler().color(RadixTokens.accent11())),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixRadioStyle _sizeStyle(RadixRadioSize size) {
    return switch (size) {
      RadixRadioSize.size1 => RemixRadioStyle(
          container: BoxStyler(alignment: Alignment.center),
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
        ),
      RadixRadioSize.size2 => RemixRadioStyle(
          container: BoxStyler(alignment: Alignment.center),
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
        ),
      RadixRadioSize.size3 => RemixRadioStyle(
          container: BoxStyler(alignment: Alignment.center),
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
        ),
    };
  }
}
