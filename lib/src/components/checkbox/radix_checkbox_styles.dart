// ABOUTME: Factory for creating RemixCheckboxStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix checkbox variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../theme/radix_tokens.dart';
import 'checkbox.dart';

// Export the extension so it's available when importing this file
export 'checkbox.dart' show RadixCheckboxStyleExt;

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
  /// Compose with size methods like .size2().
  static RemixCheckboxStyle classic() {
    return RemixCheckboxStyle()
        // Indicator container (the checkbox box itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray7(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius2())),
        )
        // Check mark icon color
        .indicatorColor(RadixTokens.gray12())
        // Label text color  
        .labelColor(RadixTokens.gray12())
        // State variants
        .onSelected(
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler()
                .color(RadixTokens.accent9())
                .borderAll(
                  color: RadixTokens.accent9(),
                  width: RadixTokens.borderWidth1(),
                ),
          ).indicatorColor(RadixTokens.accentContrast()),
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
              .indicatorColor(RadixTokens.gray12())
              .labelColor(RadixTokens.gray12()),
        );
  }

  /// Creates a surface variant checkbox style.
  ///
  /// Surface checkboxes use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance. Compose with size methods like .size2().
  static RemixCheckboxStyle surface() {
    return RemixCheckboxStyle()
        // Indicator container (the checkbox box itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.colorSurface())
              .borderAll(
                color: RadixTokens.gray6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius2())),
        )
        // Check mark icon color
        .indicatorColor(RadixTokens.accent9())
        // Label text color
        .labelColor(RadixTokens.gray12())
        // State variants
        .onSelected(
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler()
                .color(RadixTokens.colorSurface())
                .borderAll(
                  color: RadixTokens.gray6(),
                  width: RadixTokens.borderWidth1(),
                ),
          ).indicatorColor(RadixTokens.accent9()),
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
              .indicatorColor(RadixTokens.accent9())
              .labelColor(RadixTokens.gray12()),
        );
  }

  /// Creates a soft variant checkbox style.
  ///
  /// Soft checkboxes use accent-tinted background with accent borders.
  /// Used for forms that need accent color integration. Compose with size methods like .size2().
  static RemixCheckboxStyle soft() {
    return RemixCheckboxStyle()
        // Indicator container (the checkbox box itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(RadixTokens.accent3())
              .borderAll(
                color: RadixTokens.accent6(),
                width: RadixTokens.borderWidth1(),
              )
              .borderRadius(BorderRadiusMix.all(RadixTokens.radius2())),
        )
        // Check mark icon color
        .indicatorColor(RadixTokens.accent11())
        // Label text color
        .labelColor(RadixTokens.gray12())
        // State variants
        .onSelected(
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler()
                .color(RadixTokens.accent9())
                .borderAll(
                  color: RadixTokens.accent9(),
                  width: RadixTokens.borderWidth1(),
                ),
          ).indicatorColor(RadixTokens.accentContrast()),
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
              .indicatorColor(RadixTokens.accent11())
              .labelColor(RadixTokens.gray12()),
        );
  }

  /// Creates a size 1 checkbox style (small).
  ///
  /// Small checkboxes for compact layouts and dense interfaces.
  /// Compose with variant methods like .classic().
  static RemixCheckboxStyle size1() {
    return RemixCheckboxStyle(
      container: FlexBoxStyler()
        .spacing(6.0)
        .mainAxisAlignment(MainAxisAlignment.start)
        .crossAxisAlignment(CrossAxisAlignment.center),
      indicatorContainer: BoxStyler()
        .constraints(BoxConstraintsMix(
          minWidth: 16.0,
          maxWidth: 16.0,
          minHeight: 16.0,
          maxHeight: 16.0,
        )),
      indicator: IconStyler().size(12.0),
      label: TextStyler().fontSize(12.0),
    );
  }

  /// Creates a size 2 checkbox style (medium - default).
  ///
  /// Standard checkboxes for most common use cases.
  /// Compose with variant methods like .classic().
  static RemixCheckboxStyle size2() {
    return RemixCheckboxStyle(
      container: FlexBoxStyler()
        .spacing(8.0)
        .mainAxisAlignment(MainAxisAlignment.start)
        .crossAxisAlignment(CrossAxisAlignment.center),
      indicatorContainer: BoxStyler()
        .constraints(BoxConstraintsMix(
          minWidth: 20.0,
          maxWidth: 20.0,
          minHeight: 20.0,
          maxHeight: 20.0,
        )),
      indicator: IconStyler().size(14.0),
      label: TextStyler().fontSize(14.0),
    );
  }

  /// Creates a size 3 checkbox style (large).
  ///
  /// Large checkboxes for accessibility needs and prominent forms.
  /// Compose with variant methods like .classic().
  static RemixCheckboxStyle size3() {
    return RemixCheckboxStyle(
      container: FlexBoxStyler()
        .spacing(10.0)
        .mainAxisAlignment(MainAxisAlignment.start)
        .crossAxisAlignment(CrossAxisAlignment.center),
      indicatorContainer: BoxStyler()
        .constraints(BoxConstraintsMix(
          minWidth: 24.0,
          maxWidth: 24.0,
          minHeight: 24.0,
          maxHeight: 24.0,
        )),
      indicator: IconStyler().size(16.0),
      label: TextStyler().fontSize(16.0),
    );
  }
}