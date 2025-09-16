// ABOUTME: Factory for creating RemixCheckboxStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix checkbox variants with proper token-based styling

import 'package:flutter/material.dart';
import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'checkbox.dart';


enum RadixCheckboxSize {
  size1,
  size2,
  size3,
}

enum RadixCheckboxVariant {
  classic,
  surface,
  soft,
}

/// Factory class for creating Radix-compliant checkbox styles.
///
/// Provides static methods to create RemixCheckboxStyle instances for all
/// Radix UI checkbox variants using the RadixTokens system.
class RadixCheckboxStyles {
  const RadixCheckboxStyles._();

  /// Factory constructor for RadixCheckboxStyle with variant and size parameters.
  ///
  /// Returns a RemixCheckboxStyle configured with Radix design tokens.
  /// Defaults to classic variant with size2.
  static RemixCheckboxStyle create({
    RadixCheckboxVariant variant = RadixCheckboxVariant.classic,
    RadixCheckboxSize size = RadixCheckboxSize.size2,
  }) {
    return switch (variant) {
      RadixCheckboxVariant.classic => classic(size: size),
      RadixCheckboxVariant.surface => surface(size: size),
      RadixCheckboxVariant.soft => soft(size: size),
    };
  }

  static RemixCheckboxStyle base({
    RadixCheckboxSize size = RadixCheckboxSize.size2,
  }) {
    return RemixCheckboxStyle()
        // Focus state (generic)
        .onFocused(
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: RadixTokens.focusA8(),
              width: RadixTokens.focusRingWidth(),
            ),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a classic variant checkbox style.
  ///
  /// Classic checkboxes use neutral surface with gray borders that become
  /// accent-colored when checked. Used for standard form controls.
  static RemixCheckboxStyle classic({
    RadixCheckboxSize size = RadixCheckboxSize.size2,
  }) {
    return base(size: size)
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
  /// Used for forms with softer visual appearance.
  static RemixCheckboxStyle surface({
    RadixCheckboxSize size = RadixCheckboxSize.size2,
  }) {
    return base(size: size)
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
  /// Used for forms that need accent color integration.
  static RemixCheckboxStyle soft({
    RadixCheckboxSize size = RadixCheckboxSize.size2,
  }) {
    return base(size: size)
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

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixCheckboxStyle _sizeStyle(RadixCheckboxSize size) {
    return switch (size) {
      RadixCheckboxSize.size1 => RemixCheckboxStyle(
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
        ),
      RadixCheckboxSize.size2 => RemixCheckboxStyle(
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
        ),
      RadixCheckboxSize.size3 => RemixCheckboxStyle(
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
        ),
    };
  }
}
