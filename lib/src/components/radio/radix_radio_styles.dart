part of 'radio.dart';

enum FortalRadioSize {
  size1,
  size2,
  size3,
}

enum FortalRadioVariant {
  classic,
  surface,
  soft,
}

/// Factory class for creating Fortal-compliant radio styles.
///
/// Provides static methods to create RemixRadioStyle instances for all
/// Fortal UI radio variants using the FortalTokens system.
class FortalRadioStyles {
  const FortalRadioStyles._();

  /// Factory constructor for FortalRadioStyle with variant and size parameters.
  ///
  /// Returns a RemixRadioStyle configured with Fortal design tokens.
  /// Defaults to classic variant with size2.
  static RemixRadioStyle create({
    FortalRadioVariant variant = FortalRadioVariant.classic,
    FortalRadioSize size = FortalRadioSize.size2,
  }) {
    return switch (variant) {
      FortalRadioVariant.classic => classic(size: size),
      FortalRadioVariant.surface => surface(size: size),
      FortalRadioVariant.soft => soft(size: size),
    };
  }

  static RemixRadioStyle base({FortalRadioSize size = FortalRadioSize.size2}) {
    return RemixRadioStyle()
        // Focus state (generic)
        .onFocused(
          RemixRadioStyle().indicatorContainer(
            BoxStyler().borderAll(
              color: FortalTokens.focusA8(),
              width: FortalTokens.focusRingWidth(),
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
    FortalRadioSize size = FortalRadioSize.size2,
  }) {
    return base(size: size)
        // Indicator container (the radio circle itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(FortalTokens.colorSurface())
              .borderAll(
                color: FortalTokens.gray7(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radiusFull()) // Circular

          ,
        )
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(FortalTokens.gray12())
              .borderRadiusAll(FortalTokens.radiusFull()),
        )
        // State variants
        .onSelected(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.colorSurface()).borderAll(
                      color: FortalTokens.accent9(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicator(BoxStyler().color(FortalTokens.accentContrast())),
        )
        .onDisabled(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.colorSurface()).borderAll(
                      color: FortalTokens.gray7(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicator(BoxStyler().color(FortalTokens.gray12())),
        );
  }

  /// Creates a surface variant radio style.
  ///
  /// Surface radios use neutral surface with subtle borders.
  /// Used for forms with softer visual appearance.
  static RemixRadioStyle surface({
    FortalRadioSize size = FortalRadioSize.size2,
  }) {
    return base(size: size)
        // Indicator container (the radio circle itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(FortalTokens.colorSurface())
              .borderAll(
                color: FortalTokens.gray6(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radiusFull()) // Circular

          ,
        )
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(FortalTokens.accent9())
              .borderRadiusAll(FortalTokens.radiusFull()),
        )
        // State variants
        .onSelected(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.colorSurface()).borderAll(
                      color: FortalTokens.gray6(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicator(BoxStyler().color(FortalTokens.accent9())),
        )
        .onDisabled(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.colorSurface()).borderAll(
                      color: FortalTokens.gray6(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicator(BoxStyler().color(FortalTokens.accent9())),
        );
  }

  /// Creates a soft variant radio style.
  ///
  /// Soft radios use accent-tinted background with accent borders.
  /// Used for forms that need accent color integration.
  static RemixRadioStyle soft({FortalRadioSize size = FortalRadioSize.size2}) {
    return base(size: size)
        // Indicator container (the radio circle itself) - no size properties
        .indicatorContainer(
          BoxStyler()
              .color(FortalTokens.accent3())
              .borderAll(
                color: FortalTokens.accent6(),
                width: FortalTokens.borderWidth1(),
              )
              .borderRadiusAll(FortalTokens.radiusFull()) // Circular

          ,
        )
        // Radio dot indicator - no size properties
        .indicator(
          BoxStyler()
              .color(FortalTokens.accent11())
              .borderRadiusAll(FortalTokens.radiusFull()),
        )
        // State variants
        .onSelected(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.accent3()).borderAll(
                      color: FortalTokens.accent6(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicator(BoxStyler().color(FortalTokens.accent11())),
        )
        .onDisabled(
          RemixRadioStyle()
              .indicatorContainer(
                BoxStyler().color(FortalTokens.accent3()).borderAll(
                      color: FortalTokens.accent6(),
                      width: FortalTokens.borderWidth1(),
                    ),
              )
              .indicator(BoxStyler().color(FortalTokens.accent11())),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixRadioStyle _sizeStyle(FortalRadioSize size) {
    return switch (size) {
      FortalRadioSize.size1 => RemixRadioStyle(
          container: BoxStyler(alignment: Alignment.center),
          indicatorContainer: BoxStyler().width(16.0).height(16.0),
          indicator: BoxStyler().width(8.0).height(8.0),
        ),
      FortalRadioSize.size2 => RemixRadioStyle(
          container: BoxStyler(alignment: Alignment.center),
          indicatorContainer: BoxStyler().width(20.0).height(20.0),
          indicator: BoxStyler().width(10.0).height(10.0),
        ),
      FortalRadioSize.size3 => RemixRadioStyle(
          container: BoxStyler(alignment: Alignment.center),
          indicatorContainer: BoxStyler().width(24.0).height(24.0),
          indicator: BoxStyler().width(12.0).height(12.0),
        ),
    };
  }
}
