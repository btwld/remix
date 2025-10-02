part of 'icon_button.dart';

enum FortalIconButtonSize {
  size1,
  size2,
  size3,
  size4,
}

enum FortalIconButtonVariant {
  solid,
  soft,
  surface,
  outline,
  ghost,
  classic,
}

/// Factory class for creating Fortal-compliant icon button styles.
///
/// Provides static methods to create RemixIconButtonStyle instances for all
/// Fortal UI icon button variants using the FortalTokens system.
class FortalIconButtonStyles {
  const FortalIconButtonStyles._();

  /// Factory constructor for FortalIconButtonStyle with variant and size parameters.
  ///
  /// Returns a RemixIconButtonStyle configured with Fortal design tokens.
  /// Defaults to solid variant with size2.
  static RemixIconButtonStyle create({
    FortalIconButtonVariant variant = FortalIconButtonVariant.solid,
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return switch (variant) {
      FortalIconButtonVariant.solid => solid(size: size),
      FortalIconButtonVariant.soft => soft(size: size),
      FortalIconButtonVariant.surface => surface(size: size),
      FortalIconButtonVariant.outline => outline(size: size),
      FortalIconButtonVariant.ghost => ghost(size: size),
      FortalIconButtonVariant.classic => classic(size: size),
    };
  }

  static RemixIconButtonStyle base({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return RemixIconButtonStyle()
        // Focus state (generic)
        // Merge with size-specific styles
        .merge(_sizeStyle(size));
  }

  /// Creates a solid variant icon button style.
  ///
  /// Solid icon buttons have high emphasis with solid accent background color.
  /// Used for primary icon actions.
  static RemixIconButtonStyle solid({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(FortalTokens.accent9())
        // Icon styling
        .iconColor(FortalTokens.accentContrast())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: FortalTokens.borderWidth2(),
            indicatorColor: FortalTokens.accentContrast(),
            duration: const Duration(milliseconds: 800),
          ),
        )
        // State variants
        .onHovered(RemixIconButtonStyle().color(FortalTokens.accent10()))
        .onPressed(RemixIconButtonStyle().color(FortalTokens.accent10()))
        .onDisabled(
          RemixIconButtonStyle()
              .color(FortalTokens.accent9())
              .iconColor(FortalTokens.accentContrast())
              .spinner(
                RemixSpinnerStyle(indicatorColor: FortalTokens.accentContrast()),
              ),
        );
  }

  /// Creates a soft variant icon button style.
  ///
  /// Soft icon buttons have medium emphasis with subtle accent tinted background.
  /// Used for secondary icon actions.
  static RemixIconButtonStyle soft({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(FortalTokens.accent3())
        .borderAll(
          color: FortalTokens.accent6(),
          width: FortalTokens.borderWidth1(),
        )
        // Icon styling
        .iconColor(FortalTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: FortalTokens.borderWidth2(),
            indicatorColor: FortalTokens.accent11(),
            duration: const Duration(milliseconds: 800),
          ),
        )
        // State variants
        .onHovered(
          RemixIconButtonStyle().color(FortalTokens.accent4()).borderAll(
                color: FortalTokens.accent7(),
                width: FortalTokens.borderWidth1(),
              ),
        )
        .onPressed(RemixIconButtonStyle().color(FortalTokens.accent5()))
        .onDisabled(
          RemixIconButtonStyle()
              .color(FortalTokens.accent3())
              .borderAll(
                color: FortalTokens.accent6(),
                width: FortalTokens.borderWidth1(),
              )
              .iconColor(FortalTokens.accent11())
              .spinner(RemixSpinnerStyle(indicatorColor: FortalTokens.accent11())),
        );
  }

  /// Creates a surface variant icon button style.
  ///
  /// Surface icon buttons have subtle emphasis with accent-tinted surface.
  /// Used for tertiary icon actions.
  static RemixIconButtonStyle surface({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(FortalTokens.accentSurface())
        .borderAll(
          color: FortalTokens.accent6(),
          width: FortalTokens.borderWidth1(),
        )
        // Icon styling
        .iconColor(FortalTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: FortalTokens.borderWidth2(),
            indicatorColor: FortalTokens.accent11(),
            duration: const Duration(milliseconds: 800),
          ),
        )
        // State variants with surface-specific hover (uses overlay calculation)
        .onHovered(
          RemixIconButtonStyle()
              .color(FortalTokens.accentA4()) // Simplified overlay calculation
              .borderAll(
                color: FortalTokens.accent7(),
                width: FortalTokens.borderWidth1(),
              ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .color(FortalTokens.accentSurface())
              .borderAll(
                color: FortalTokens.accent6(),
                width: FortalTokens.borderWidth1(),
              )
              .iconColor(FortalTokens.accent11())
              .spinner(RemixSpinnerStyle(indicatorColor: FortalTokens.accent11())),
        );
  }

  /// Creates an outline variant icon button style.
  ///
  /// Outline icon buttons have border-focused emphasis with transparent background.
  /// Used for secondary icon actions where more emphasis is needed than ghost.
  static RemixIconButtonStyle outline({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(Colors.transparent)
        .borderAll(
          color: FortalTokens.accent7(),
          width: FortalTokens.borderWidth1(),
        )
        // Icon styling
        .iconColor(FortalTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: FortalTokens.borderWidth2(),
            indicatorColor: FortalTokens.accent11(),
            duration: const Duration(milliseconds: 800),
          ),
        )
        // State variants
        .onHovered(
          RemixIconButtonStyle().color(FortalTokens.accentA3()).borderAll(
                color: FortalTokens.accent8(),
                width: FortalTokens.borderWidth1(),
              ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .borderAll(
                color: FortalTokens.accent7(),
                width: FortalTokens.borderWidth1(),
              )
              .iconColor(FortalTokens.accent11())
              .spinner(RemixSpinnerStyle(indicatorColor: FortalTokens.accent11())),
        );
  }

  /// Creates a ghost variant icon button style.
  ///
  /// Ghost icon buttons have minimal emphasis with no visible container.
  /// Used for very subtle icon actions.
  static RemixIconButtonStyle ghost({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(Colors.transparent)
        // Icon styling
        .iconColor(FortalTokens.accent11())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: FortalTokens.borderWidth2(),
            indicatorColor: FortalTokens.accent11(),
            duration: const Duration(milliseconds: 800),
          ),
        )
        // State variants
        .onHovered(RemixIconButtonStyle().color(FortalTokens.accentA3()))
        .onPressed(RemixIconButtonStyle().color(FortalTokens.accentA4()))
        .onDisabled(
          RemixIconButtonStyle()
              .iconColor(FortalTokens.accent11())
              .spinner(RemixSpinnerStyle(indicatorColor: FortalTokens.accent11())),
        );
  }

  /// Creates a classic variant icon button style.
  ///
  /// Classic icon buttons have pre-flat UI style with neutral colors and shadows.
  /// Used when a more traditional icon button appearance is needed.
  static RemixIconButtonStyle classic({
    FortalIconButtonSize size = FortalIconButtonSize.size2,
  }) {
    return base(size: size)
        // Visual styling only - no size properties
        .color(FortalTokens.colorSurface())
        .borderAll(
          color: FortalTokens.gray7(),
          width: FortalTokens.borderWidth1(),
        )
        // Add subtle shadow for classic feel using token
        .shadows(FortalTokens.shadow2().map(BoxShadowMix.value).toList())
        // Icon styling
        .iconColor(FortalTokens.gray12())
        .spinner(
          RemixSpinnerStyle(
            strokeWidth: FortalTokens.borderWidth2(),
            indicatorColor: FortalTokens.gray12(),
            duration: const Duration(milliseconds: 800),
          ),
        )
        // State variants
        .onHovered(
          RemixIconButtonStyle()
              .color(FortalTokens.gray3())
              .borderAll(
                color: FortalTokens.gray8(),
                width: FortalTokens.borderWidth1(),
              )
              .shadows(
                FortalTokens.shadow2().map(BoxShadowMix.value).toList(),
              ),
        )
        .onDisabled(
          RemixIconButtonStyle()
              .color(FortalTokens.colorSurface())
              .borderAll(
                color: FortalTokens.gray7(),
                width: FortalTokens.borderWidth1(),
              )
              .iconColor(FortalTokens.gray12())
              .spinner(RemixSpinnerStyle(indicatorColor: FortalTokens.gray12()))
              .shadows(
                FortalTokens.shadow1().map(BoxShadowMix.value).toList(),
              ),
        );
  }

  // ---------------------------------------------------------------------------
  // Internal builders
  // ---------------------------------------------------------------------------

  static RemixIconButtonStyle _sizeStyle(FortalIconButtonSize size) {
    return switch (size) {
      FortalIconButtonSize.size1 => RemixIconButtonStyle()
          .width(24.0)
          .height(24.0)
          .borderRadiusAll(FortalTokens.radius2())
          .iconSize(12.0)
          .spinner(RemixSpinnerStyle(size: 12.0)),
      FortalIconButtonSize.size2 => RemixIconButtonStyle()
          .width(32.0)
          .height(32.0)
          .borderRadiusAll(FortalTokens.radius3())
          .iconSize(16.0)
          .spinner(RemixSpinnerStyle(size: 16.0)),
      FortalIconButtonSize.size3 => RemixIconButtonStyle()
          .width(40.0)
          .height(40.0)
          .borderRadiusAll(FortalTokens.radius4())
          .iconSize(20.0)
          .spinner(RemixSpinnerStyle(size: 20.0)),
      FortalIconButtonSize.size4 => RemixIconButtonStyle()
          .width(48.0)
          .height(48.0)
          .borderRadiusAll(FortalTokens.radius5())
          .iconSize(24.0)
          .spinner(RemixSpinnerStyle(size: 24.0)),
    };
  }
}
