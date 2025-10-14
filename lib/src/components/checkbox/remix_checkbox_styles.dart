part of 'checkbox.dart';

enum FortalCheckboxSize { size1, size2, size3 }

enum FortalCheckboxVariant { surface, soft }

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
          RemixCheckboxStyle().borderAll(
            color: FortalTokens.focusA8(),
            width: FortalTokens.focusRingWidth(),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a surface variant checkbox style.
  ///
  /// Surface checkboxes use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance.
  static RemixCheckboxStyle surface({
    FortalCheckboxSize size = FortalCheckboxSize.size2,
  }) {
    return base(size: size)
        // Container (the checkbox box itself) - no size properties
        .borderAll(
          color: FortalTokens.gray6(),
          width: FortalTokens.borderWidth1(),
        )
        // Use token-based radius matching JSON intent.
        .borderRadiusAll(FortalTokens.radius2())
        // Check mark icon color
        .indicatorColor(FortalTokens.accent9())
        // State variants
        .onSelected(
          RemixCheckboxStyle()
              .color(FortalTokens.accent9())
              .borderAll(
                color: FortalTokens.accent9(),
                width: FortalTokens.borderWidth1(),
              )
              .indicatorColor(FortalTokens.accentContrast()),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .color(FortalTokens.grayA3())
              .borderAll(
                color: FortalTokens.gray7(),
                width: FortalTokens.borderWidth1(),
              )
              .indicatorColor(FortalTokens.gray8()),
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
        .color(FortalTokens.accentA4())
        .borderRadiusAll(FortalTokens.radius2())
        .onSelected(
          RemixCheckboxStyle().indicatorColor(FortalTokens.accentA11()),
        )
        .onDisabled(
          RemixCheckboxStyle()
              .color(FortalTokens.grayA3())
              .indicatorColor(FortalTokens.gray8()),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixCheckboxStyle _sizeStyle(FortalCheckboxSize size) {
    return switch (size) {
      FortalCheckboxSize.size1 => RemixCheckboxStyle(
        container: BoxStyler()
            // checkbox-size (size1) ~ space-4 (16px)
            .width(FortalTokens.space4())
            .height(FortalTokens.space4()),
        // Indicator icon size uses token step
        indicator: IconStyler().size(FortalTokens.space3()),
      ),
      FortalCheckboxSize.size2 => RemixCheckboxStyle(
        container: BoxStyler()
            .width(FortalTokens.space5())
            .height(FortalTokens.space5()),
        indicator: IconStyler().size(FortalTokens.space4()),
      ),
      FortalCheckboxSize.size3 => RemixCheckboxStyle(
        container: BoxStyler()
            .width(FortalTokens.space6())
            .height(FortalTokens.space6()),
        indicator: IconStyler().size(FortalTokens.space5()),
      ),
    };
  }
}
