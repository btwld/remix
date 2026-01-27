part of 'radio.dart';

enum FortalRadioSize { size1, size2, size3 }

enum FortalRadioVariant { surface, soft }

/// Factory class for creating Fortal-compliant radio styles.
///
/// Provides static methods to create RemixRadioStyle instances for all
/// Fortal UI radio variants using the FortalTokens system.
class FortalRadioStyles {
  const FortalRadioStyles._();

  /// Factory constructor for FortalRadioStyle with variant and size parameters.
  ///
  /// Returns a RemixRadioStyle configured with Fortal design tokens.
  /// Defaults to surface variant with size2.
  static RemixRadioStyle create({
    FortalRadioVariant variant = .surface,
    FortalRadioSize size = .size2,
  }) {
    return switch (variant) {
      .surface => surface(size: size),
      .soft => soft(size: size),
    };
  }

  static RemixRadioStyle base({FortalRadioSize size = .size2}) {
    return RemixRadioStyle()
        // Focus state (generic)
        .onFocused(
          RemixRadioStyle().borderAll(
            color: FortalTokens.focusA8(),
            width: FortalTokens.focusRingWidth(),
          ),
        )
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a surface variant radio style.
  ///
  /// Surface radios use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance.
  static RemixRadioStyle surface({
    FortalRadioSize size = .size2,
  }) {
    return base(size: size)
        // Container (the radio circle itself) - no size properties
        .color(FortalTokens.colorSurface())
        .borderAll(
          color: FortalTokens.gray6(),
          width: FortalTokens.borderWidth1(),
        )
        .borderRadiusAll(FortalTokens.radiusFull()) // Circular
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(FortalTokens.accent9())
              .borderRadiusAll(FortalTokens.radiusFull()),
        )
        // State variants
        .onSelected(
          RemixRadioStyle()
              .color(FortalTokens.accent9())
              .borderAll(
                color: FortalTokens.accent9(),
                width: FortalTokens.borderWidth1(),
              )
              .indicator(BoxStyler().color(Colors.white)),
        )
        .onDisabled(
          RemixRadioStyle()
              .color(FortalTokens.gray3())
              .borderAll(
                color: FortalTokens.gray6(),
                width: FortalTokens.borderWidth1(),
              )
              .indicator(BoxStyler().color(FortalTokens.gray9())),
        );
  }

  /// Creates a soft variant radio style.
  ///
  /// Soft radios use accent-tinted background with accent borders.
  /// Used for forms that need accent color integration.
  static RemixRadioStyle soft({FortalRadioSize size = .size2}) {
    return base(size: size)
        // Container (the radio circle itself) - no size properties
        .color(FortalTokens.accentA4())
        .borderRadiusAll(FortalTokens.radiusFull()) // Circular
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(FortalTokens.accent11())
              .borderRadiusAll(FortalTokens.radiusFull()),
        )
        // State variants
        .onSelected(
          RemixRadioStyle()
              .color(FortalTokens.accentA4())
              .indicator(BoxStyler().color(FortalTokens.accent11())),
        )
        .onDisabled(
          RemixRadioStyle()
              .color(FortalTokens.gray3())
              .indicator(BoxStyler().color(FortalTokens.gray7())),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixRadioStyle _sizeStyle(FortalRadioSize size) {
    return switch (size) {
      .size1 => RemixRadioStyle(
        container: BoxStyler()
            .width(16.0)
            .height(16.0)
            .alignment(.center),
        indicator: BoxStyler().width(6.0).height(6.0),
      ),
      .size2 => RemixRadioStyle(
        container: BoxStyler()
            .width(20.0)
            .height(20.0)
            .alignment(.center),
        indicator: BoxStyler().width(8.0).height(8.0),
      ),
      .size3 => RemixRadioStyle(
        container: BoxStyler()
            .width(24.0)
            .height(24.0)
            .alignment(.center),
        indicator: BoxStyler().width(10.0).height(10.0),
      ),
    };
  }
}
