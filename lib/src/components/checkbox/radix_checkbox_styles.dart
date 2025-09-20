part of 'checkbox.dart';

enum FortalCheckboxSize {
  size1,
  size2,
  size3,
}

enum FortalCheckboxVariant {
  surface,
  soft,
}

/// Factory class for creating Fortal-compliant checkbox styles.
///
/// Provides static methods to create RemixCheckboxStyle instances for all
/// Fortal UI checkbox variants using the FortalTokens system.
class FortalCheckboxStyles {
  const FortalCheckboxStyles._();

  /// Factory constructor for FortalCheckboxStyle with variant and size parameters.
  ///
  /// Returns a RemixCheckboxStyle configured with Fortal design tokens.
  /// Defaults to classic variant with size2.
  static RemixCheckboxStyle create({
    FortalCheckboxVariant variant = FortalCheckboxVariant.surface,
    FortalCheckboxSize size = FortalCheckboxSize.size2,
  }) {
    return switch (variant) {
      FortalCheckboxVariant.surface => surface(size: size),
      FortalCheckboxVariant.soft => soft(size: size),
    };
  }

  static RemixCheckboxStyle base({
    FortalCheckboxSize size = FortalCheckboxSize.size2,
  }) {
    return RemixCheckboxStyle()
        // Focus state (generic)
        .onFocused(
          RemixCheckboxStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: FortalTokens.focusA8(),
              width: FortalTokens.focusRingWidth(),
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
    FortalCheckboxSize size = FortalCheckboxSize.size2,
  }) {
    return base(size: size)
        // Indicator container (the checkbox box itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(FortalTokens.colorSurface())
              .borderAll(
                color: FortalTokens.gray7(),
                width: FortalTokens.borderWidth1(),
              )
              // Use token-based radius. JSON: radius ≈ 1.25 × radius-1 (~3.75),
              // closest token step is radius-2 (4px).
              .borderRadiusAll(FortalTokens.radius2()),
        )
        // Check mark icon color
        .indicatorColor(FortalTokens.gray12())
        // State variants
        .onSelected(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.accent9()).borderAll(
                      color: FortalTokens.accent9(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(FortalTokens.accentContrast()),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.colorSurface()).borderAll(
                      color: FortalTokens.gray7(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(FortalTokens.gray12()),
        );
  }

  /// Creates a surface variant checkbox style.
  ///
  /// Surface checkboxes use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance.
  static RemixCheckboxStyle surface({
    FortalCheckboxSize size = FortalCheckboxSize.size2,
  }) {
    return base(size: size)
        // Indicator container (the checkbox box itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(FortalTokens.colorSurface())
              .borderAll(
                color: FortalTokens.gray6(),
                width: FortalTokens.borderWidth1(),
              )
              // Use token-based radius matching JSON intent.
              .borderRadiusAll(FortalTokens.radius2()),
        )
        // Check mark icon color
        .indicatorColor(FortalTokens.accent9())
        // State variants
        .onSelected(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.accent9()).borderAll(
                      color: FortalTokens.accent9(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(FortalTokens.accentContrast()),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.colorSurface()).borderAll(
                      color: FortalTokens.gray6(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(FortalTokens.accent9()),
        );
  }

  /// Creates a soft variant checkbox style.
  ///
  /// Soft checkboxes use accent-tinted background with accent borders.
  /// Used for forms that need accent color integration.
  static RemixCheckboxStyle soft({
    FortalCheckboxSize size = FortalCheckboxSize.size2,
  }) {
    return base(size: size)
        // Indicator container (the checkbox box itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(FortalTokens.accent3())
              .borderAll(
                color: FortalTokens.accent6(),
                width: FortalTokens.borderWidth1(),
              )
              // Use token-based radius matching JSON intent.
              .borderRadiusAll(FortalTokens.radius2()),
        )
        // Check mark icon color
        .indicatorColor(FortalTokens.accent11())
        // State variants
        .onSelected(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.accent9()).borderAll(
                      color: FortalTokens.accent9(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(FortalTokens.accentContrast()),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.accent3()).borderAll(
                      color: FortalTokens.accent6(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicatorColor(FortalTokens.accent11()),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixCheckboxStyle _sizeStyle(FortalCheckboxSize size) {
    return switch (size) {
      FortalCheckboxSize.size1 => RemixCheckboxStyle(
          indicatorContainer: BoxStyler()
              // checkbox-size (size1) ~ space-4 (16px)
              .width(FortalTokens.space4())
              .height(FortalTokens.space4()),
          // Indicator icon size uses token step
          indicator: IconStyler().size(FortalTokens.space3()),
        ),
      FortalCheckboxSize.size2 => RemixCheckboxStyle(
          indicatorContainer: BoxStyler()
              // checkbox-size: calc(space-4 * 1.25)
              // Resolve via token at runtime and scale
              // TODO: We need ot add this value 1.25 as a directive
              .width(FortalTokens.space4() * 1.25)
              .height(FortalTokens.space4() * 1.25),
          // JSON indicates 12px base indicator size (scaled). Use space-3 (12px).
          indicator: IconStyler().size(FortalTokens.space3()),
        ),
      FortalCheckboxSize.size3 => RemixCheckboxStyle(
          indicatorContainer: BoxStyler()
              // large size uses space-5 (24px)
              .width(FortalTokens.space5())
              .height(FortalTokens.space5()),
          indicator: IconStyler().size(FortalTokens.space4()),
        ),
    };
  }
}
