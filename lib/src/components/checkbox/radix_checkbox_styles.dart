// ABOUTME: Factory for creating RemixCheckboxStyle instances using Radix design tokens
// ABOUTME: Provides 3 Radix checkbox variants with proper token-based styling

import 'package:mix/mix.dart';

import '../../radix/radix.dart';
import 'checkbox.dart';

enum RadixCheckboxSize {
  size1,
  size2,
  size3,
}

enum RadixCheckboxVariant {
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
    RadixCheckboxVariant variant = RadixCheckboxVariant.surface,
    RadixCheckboxSize size = RadixCheckboxSize.size2,
  }) {
    return switch (variant) {
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
              // Use token-based radius. JSON: radius ≈ 1.25 × radius-1 (~3.75),
              // closest token step is radius-2 (4px).
              .borderRadiusAll(RadixTokens.radius2()),
        )
        // Check mark icon color
        .indicatorColor(RadixTokens.gray12())
        // State variants
        .onSelected(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.accent9()).borderAll(
                      color: RadixTokens.accent9(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(RadixTokens.accentContrast()),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.colorSurface()).borderAll(
                      color: RadixTokens.gray7(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(RadixTokens.gray12()),
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
              // Use token-based radius matching JSON intent.
              .borderRadiusAll(RadixTokens.radius2()),
        )
        // Check mark icon color
        .indicatorColor(RadixTokens.accent9())
        // State variants
        .onSelected(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.accent9()).borderAll(
                      color: RadixTokens.accent9(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(RadixTokens.accentContrast()),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.colorSurface()).borderAll(
                      color: RadixTokens.gray6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(RadixTokens.accent9()),
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
              // Use token-based radius matching JSON intent.
              .borderRadiusAll(RadixTokens.radius2()),
        )
        // Check mark icon color
        .indicatorColor(RadixTokens.accent11())
        // State variants
        .onSelected(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.accent9()).borderAll(
                      color: RadixTokens.accent9(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(RadixTokens.accentContrast()),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(RadixTokens.accent3()).borderAll(
                      color: RadixTokens.accent6(),
                      width: RadixTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(RadixTokens.accent11()),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixCheckboxStyle _sizeStyle(RadixCheckboxSize size) {
    return switch (size) {
      RadixCheckboxSize.size1 => RemixCheckboxStyle(
          indicatorContainer: BoxStyler().constraints(BoxConstraintsMix(
            // checkbox-size (size1) ~ space-4 (16px)
            minWidth: RadixTokens.space4(),
            maxWidth: RadixTokens.space4(),
            minHeight: RadixTokens.space4(),
            maxHeight: RadixTokens.space4(),
          )),
          // Indicator icon size uses token step
          indicator: IconStyler().size(RadixTokens.space3()),
        ),
      RadixCheckboxSize.size2 => RemixCheckboxStyle(
          indicatorContainer: BoxStyler().constraints(BoxConstraintsMix(
            // checkbox-size: calc(space-4 * 1.25)
            // Resolve via token at runtime and scale
            minWidth: RadixTokens.space4() * 1.25,
            maxWidth: RadixTokens.space4() * 1.25,
            minHeight: RadixTokens.space4() * 1.25,
            maxHeight: RadixTokens.space4() * 1.25,
          )),
          // JSON indicates 12px base indicator size (scaled). Use space-3 (12px).
          indicator: IconStyler().size(RadixTokens.space3()),
        ),
      RadixCheckboxSize.size3 => RemixCheckboxStyle(
          indicatorContainer: BoxStyler().constraints(BoxConstraintsMix(
            // large size uses space-5 (24px)
            minWidth: RadixTokens.space5(),
            maxWidth: RadixTokens.space5(),
            minHeight: RadixTokens.space5(),
            maxHeight: RadixTokens.space5(),
          )),
          indicator: IconStyler().size(RadixTokens.space4()),
        ),
    };
  }
}
